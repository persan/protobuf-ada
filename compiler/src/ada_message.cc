// Protocol Buffers - Google's data interchange format
// Copyright 2008 Google Inc.  All rights reserved.
// http://code.google.com/p/protobuf/
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//
//     * Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above
// copyright notice, this list of conditions and the following disclaimer
// in the documentation and/or other materials provided with the
// distribution.
//     * Neither the name of Google Inc. nor the names of its
// contributors may be used to endorse or promote products derived from
// this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

// Author: kenton@google.com (Kenton Varda)
//  Based on original Protocol Buffers design by
//  Sanjay Ghemawat, Jeff Dean, and others.

#include <google/protobuf/stubs/hash.h>
#include <ada_message.h>
#include <ada_enum.h>
#include <google/protobuf/io/printer.h>
#include <strutil.h>
#include <google/protobuf/wire_format.h>
#include <ada_helpers.h>
#include <algorithm>

namespace google {
  namespace protobuf {
    namespace compiler {
      namespace ada {

	namespace {

	  struct FieldOrderingByNumber {

	    inline bool operator()(const FieldDescriptor* a,
				   const FieldDescriptor * b) const {
	      return a->number() < b->number();
	    }
	  };

	  const char* kWireTypeNames[] = {
					  "VARINT",
					  "FIXED_64",
					  "LENGTH_DELIMITED",
					  "START_GROUP",
					  "END_GROUP",
					  "FIXED_32",
	  };

	  void PrintFieldComment(io::Printer* printer, const FieldDescriptor* field) {
	    // Print the field's proto-syntax definition as a comment.  We don't want to
	    // print group bodies so we cut off after the first line.
	    string def = field->DebugString();
	    printer->Print(
			   "-- $def$\n",
			   "def", def.substr(0, def.find_first_of('\n')));
	  }

	  // Returns true if the "required" restriction check should be ignored for the
	  // given field.

	  inline static bool ShouldIgnoreRequiredFieldCheck(
							    const FieldDescriptor* field) {
	    return false;
	  }

	  // Returns true if the message type has any required fields.  If it doesn't,
	  // we can optimize out calls to its Is_Initialized method.
	  //
	  // already_seen is used to avoid checking the same type multiple times
	  // (and also to protect against recursion).

	  static bool HasRequiredFields(
					const Descriptor* type,
					hash_set<const Descriptor*>* already_seen) {
	    if (already_seen->count(type) > 0) {
	      // Since the first occurrence of a required field causes the whole
	      // function to return true, we can assume that if the type is already
	      // in the cache it didn't have any required fields.
	      return false;
	    }
	    already_seen->insert(type);

	    // If the type has extensions, an extension with message type could contain
	    // required fields, so we have to be conservative and assume such an
	    // extension exists.
	    if (type->extension_range_count() > 0) return true;

	    for (int i = 0; i < type->field_count(); i++) {
	      const FieldDescriptor* field = type->field(i);
	      if (field->is_required()) {
		return true;
	      }
	      if (field->cpp_type() == FieldDescriptor::CPPTYPE_MESSAGE &&
		  !ShouldIgnoreRequiredFieldCheck(field)) {
		  if (HasRequiredFields(field->message_type(), already_seen)) {
		    return true;
		  }
		}
	    }

	    return false;
	  }

	  static bool HasRequiredFields(const Descriptor* type) {
	    hash_set<const Descriptor*> already_seen;
	    return HasRequiredFields(type, &already_seen);
	  }

	  // Sort the fields of the given Descriptor by number into a new[]'d array
	  // and return it.

	  const FieldDescriptor** SortFieldsByNumber(const Descriptor* descriptor) {
	    const FieldDescriptor** fields =
	    new const FieldDescriptor*[descriptor->field_count()];
	    for (int i = 0; i < descriptor->field_count(); i++) {
	      fields[i] = descriptor->field(i);
	    }
	    std::sort(fields, fields + descriptor->field_count(),
		      FieldOrderingByNumber());
	    return fields;
	  }

	}

	MessageGenerator::
	MessageGenerator(const Descriptor* descriptor,
			 const string& package)
	: descriptor_(descriptor),
	ada_package_name_(package),
	ada_package_type_(AdaPackageTypeName(descriptor)),
	field_generators_(descriptor) { }

	MessageGenerator::
	~MessageGenerator() { }

	void MessageGenerator::
	GenerateSpecification(io::Printer* printer) {
	  // TODO: store packages needing limited with clause for body ..
	  for (int i = 0; i < descriptor_->field_count(); i++) {
	    const FieldDescriptor* field = descriptor_->field(i);
	    // We want a limited with clause as long as the containing
	    // message is not a parent of this message.

	    if (field->cpp_type() == FieldDescriptor::CPPTYPE_MESSAGE &&
		!IsParentMessage(field->containing_type(), field->message_type())) {
		package_dependencies_.insert(FieldMessageContainingPackageName(field));
	      }
	  }

	  for (std::set<string>::const_iterator it = package_dependencies_.begin();
	       it != package_dependencies_.end(); ++it) {
	      printer->Print("limited with $containing_package$;\n",
			     "containing_package", *it);
	    }
	  if (package_dependencies_.size()) {
	    printer->Print("\n");
	  }


	  printer->Print(
			 "package $ada_package_name$ is\n",
			 "ada_package_name", ada_package_name_);

	  printer->Indent();

	  GenerateMessageDeclarations(printer);

	  if (descriptor_->field_count() > 0) {
	    GenerateFieldAccessorDeclarations(printer);
	  }

	  if (descriptor_->enum_type_count() > 0) {
	    // Generate functions renaming enumeration literals
	    GenerateEnumerationLiterals(printer);
	  }

	  printer->Outdent();

	  printer->Print(
			 "private\n");

	  printer->Indent();


	  for (int i = 0; i < descriptor_->field_count(); i++) {
	    const FieldDescriptor* field = descriptor_->field(i);

	    // Generate defaults for singular string fields
	    if (!field->is_repeated() && GetAdaType(field) == ADATYPE_STRING) {
	      field_generators_.get(field).GenerateStaticDefaults(printer);
	    }
	  }

	  GenerateTaggedType(printer);

	  for (int i = 0; i < descriptor_->field_count(); i++) {
	    if (!descriptor_->field(i)->is_repeated()) {

	      printer->Print("procedure Set_Has_$name$ (The_Message : in out Instance);\n",
			     "name", FieldName(descriptor_->field(i)),
			     "ada_package_name", ada_package_name_);
	      printer->Print("procedure Clear_Has_$name$ (The_Message : in out Instance);\n",
			     "name", FieldName(descriptor_->field(i)),
			     "ada_package_name", ada_package_name_);
	    }
	  }

	  printer->Outdent();

	  printer->Print("end $ada_package_name$;\n",
			 "ada_package_name", ada_package_name_);
	}

	void MessageGenerator::
	GenerateBody(io::Printer* printer) {
	  // Generate with clause for referenced packages.
	  for (int i = 0; i < descriptor_->field_count(); i++) {
	    const FieldDescriptor* field = descriptor_->field(i);
	    // We want a limited with clause as long as the containing
	    // message is not a parent of this message.

	    if (field->cpp_type() == FieldDescriptor::CPPTYPE_MESSAGE &&
		!IsParentMessage(field->containing_type(), field->message_type())) {
		package_dependencies_.insert(FieldMessageContainingPackageName(field));
	      }
	  }
	  for (std::set<string>::const_iterator it = package_dependencies_.begin();
	       it != package_dependencies_.end(); ++it) {
	      printer->Print("with $containing_package$;\n",
			     "containing_package", *it);
	    }
	  if (package_dependencies_.size()) {
	    printer->Print("\n");
	  }

	  printer->Print(
			 "package body $ada_package_name$ is\n",
			 "ada_package_name", ada_package_name_);
	  printer->Indent();

	  GenerateMessageDefinitions(printer);

	  if (descriptor_->field_count() > 0) {
	    GenerateFieldAccessorDefinitions(printer);
	  }

	  printer->Outdent();
	  printer->Print(
			 "end $ada_package_name$;\n",
			 "ada_package_name", ada_package_name_);
	}

	void MessageGenerator::
	GenerateMessageDeclarations(io::Printer * printer) {

	  // TODO: replace temporary type Instance!? Other declarations might also need
	  // prettification ...
	  printer->Print("type Instance is new Protocol_Buffers.Message.Instance with private;\n"
			 "type $package_type$_Access is access all Instance;\n"
			 "\n",
			 "package_type", ada_package_type_);

	  for (int i = 0; i < descriptor_->enum_type_count(); i++) {
	    printer->Print("subtype $enum_type$ is $enum_definition$;\n",
			   "enum_type", EnumTypeName(descriptor_->enum_type(i), false),
			   "enum_definition", EnumDefinitionTypeName(descriptor_->enum_type(i)));
	  }

	  if (descriptor_->enum_type_count() > 0) {
	    printer->Print("\n");
	  }

	  printer->Print("---------------------------------------------------------------------------\n"
			 "-- Inherited functions and procedures from Protocol_Buffers.Message -------\n"
			 "---------------------------------------------------------------------------\n"
			 "\n");

	  // Clear
	  printer->Print(
			 "overriding\n"
			 "procedure Clear\n");
	  printer->Indent();
	  printer->Print(
			 "(The_Message : in out Instance);\n"
			 "\n",
			 "package", ada_package_name_);
	  printer->Outdent();

	  // Serialize_With_Cached_Sizes
	  printer->Print(
			 "overriding\n"
			 "procedure Serialize_With_Cached_Sizes\n");
	  printer->Indent();
	  printer->Print(
			 "(The_Message   : in Instance;\n"
			 " The_Coded_Output_Stream : in\n",
			 "package", ada_package_name_);
	  printer->Indent();
	  printer->Print(
			 " Protocol_Buffers.IO.Coded_Output_Stream.Instance);\n"
			 "\n");
	  printer->Outdent();
	  printer->Outdent();

	  // Merge_Partial_From_Coded_Input_Stream
	  printer->Print(
			 "overriding\n"
			 "procedure Merge_Partial_From_Coded_Input_Stream\n");
	  printer->Indent();
	  printer->Print(
			 "(The_Message   : in out Instance;\n"
			 " The_Coded_Input_Stream : in out\n",
			 "package", ada_package_name_);
	  printer->Indent();
	  printer->Print(
			 " Protocol_Buffers.IO.Coded_Input_Stream.Instance);\n"
			 "\n");
	  printer->Outdent();
	  printer->Outdent();

	  // Merge
	  printer->Print(
			 "overriding\n"
			 "procedure Merge\n");
	  printer->Indent();
	  printer->Print(
			 "(To   : in out Instance;\n"
			 " From : in Instance);\n"
			 "\n",
			 "package", ada_package_name_);
	  printer->Outdent();

	  // Copy
	  printer->Print(
			 "overriding\n"
			 "procedure Copy\n");
	  printer->Indent();
	  printer->Print(
			 "(To   : in out Instance;\n"
			 " From : in Instance);\n"
			 "\n",
			 "package", ada_package_name_);
	  printer->Outdent();

	  // Get_Type_Name
	  printer->Print(
			 "overriding\n"
			 "function Get_Type_Name\n");
	  printer->Indent();
	  printer->Print(
			 "(The_Message : in Instance) return Protocol_Buffers.Wire_Format.PB_String;\n"
			 "\n",
			 "package", ada_package_name_);
	  printer->Outdent();

	  // TODO: change return type from PB_Object_Size
	  // Byte_Size
	  printer->Print(
			 "overriding\n"
			 "function Byte_Size\n");
	  printer->Indent();
	  printer->Print(
			 "(The_Message : in out Instance) return Protocol_Buffers.Wire_Format.PB_Object_Size;\n"
			 "\n",
			 "package", ada_package_name_);
	  printer->Outdent();

	  // TODO: change return type from PB_Object_Size
	  // Get_Cached_Size
	  printer->Print(
			 "overriding\n"
			 "function Get_Cached_Size\n");
	  printer->Indent();
	  printer->Print(
			 "(The_Message : in Instance) return Protocol_Buffers.Wire_Format.PB_Object_Size;\n"
			 "\n",
			 "package", ada_package_name_);
	  printer->Outdent();

	  // Is_Initialized
	  printer->Print(
			 "overriding\n"
			 "function Is_Initialized\n");
	  printer->Indent();
	  printer->Print(
			 "(The_Message : in Instance) return Boolean;\n"
			 "\n",
			 "package", ada_package_name_);
	  printer->Outdent();

	  // Finalize
	  printer->Print(
			 "overriding\n"
			 "procedure Finalize (The_Message : in out Instance);\n"
			 "\n",
			 "package", ada_package_name_);
	}

	void MessageGenerator::
	GenerateMessageDefinitions(io::Printer * printer) {

	  printer->Print("---------------------------------------------------------------------------\n"
			 "-- Inherited functions and procedures from Protocol_Buffers.Message -------\n"
			 "---------------------------------------------------------------------------\n"
			 "\n");

	  GenerateClear(printer);
	  GenerateCopy(printer);
	  GenerateGetTypeName(printer);
	  GenerateIsInitialized(printer);
	  GenerateMerge(printer);
	  GenerateByteSize(printer);
	  GenerateSerializeWithCachedSizes(printer);
	  GenerateMergePartialFromCodedInputStream(printer);
	  GenerateGetCachedSize(printer);
	  GenerateFinalize(printer);
	}

	void MessageGenerator::
	GenerateFieldAccessorDeclarations(io::Printer * printer) {
	  printer->Print(
			 "---------------------------------------------------------------------------\n"
			 "-- Field accessor declarations --------------------------------------------\n"
			 "---------------------------------------------------------------------------\n"
			 "\n");

	  for (int i = 0; i < descriptor_->field_count(); i++) {
	    const FieldDescriptor* field = descriptor_->field(i);

	    PrintFieldComment(printer, field);

	    map<string, string> vars;
	    SetCommonFieldVariables(field, &vars);

	    if (field->is_repeated()) {
	      // Generate $name$_Size
	      printer->Print(vars,"function $name$_Size\n");
	      printer->Indent();
	      printer->Print(vars,"(The_Message : in Instance) return Protocol_Buffers.Wire_Format.PB_Object_Size;\n");
	      printer->Outdent();
	    } else {
	      // Generate Has_$name$

	      printer->Print(vars,"function Has_$name$\n");
	      printer->Indent();
	      printer->Print(vars,"(The_Message : in Instance) return Boolean;\n");
	      printer->Outdent();
	    }

	    // Generate Clear_$name$
	    printer->Print(vars,"procedure Clear_$name$\n");
	    printer->Indent();
	    printer->Print(vars,"(The_Message : in out Instance);\n");
	    printer->Outdent();

	    // Generate type specific accessor declarations
	    field_generators_.get(field).GenerateAccessorDeclarations(printer);

	    printer->Print("\n");
	  }
	}

	void MessageGenerator::
	GenerateEnumerationLiterals(io::Printer* printer) {
	  printer->Print("--------------------------\n"
			 "--  Enumeration Literals -\n"
			 "--------------------------\n"
			 "\n");

	  for (int i = 0; i < descriptor_->enum_type_count(); i++) {
	    const EnumDescriptor* enum_descriptor = descriptor_->enum_type(i);
	    for (int k = 0; k < enum_descriptor->value_count(); k++) {
	      const EnumValueDescriptor* value = enum_descriptor->value(k);
	      printer->Print("function $literal$ return $enum_type$ "
			     "renames $literal$;\n",
			     "literal", value->name(),
			     "enum_type", EnumTypeName(enum_descriptor, false),
			     "package", EnumDefinitionPackageName(enum_descriptor));
	    }

	    printer->Print("\n");

	    printer->Print(
			   "function Enumeration_To_PB_Int32 is new Ada.Unchecked_Conversion "
			   "($name$, Protocol_Buffers.Wire_Format.PB_Int32);\n",
			   "name", EnumTypeName(enum_descriptor, false));
	    printer->Print(
			   "function PB_Int32_To_Enumeration is new Ada.Unchecked_Conversion "
			   "(Protocol_Buffers.Wire_Format.PB_Int32, $name$);\n",
			   "name", EnumTypeName(enum_descriptor, false));

	    printer->Print("\n");
	  }
	}

	void MessageGenerator::
	GenerateFieldAccessorDefinitions(io::Printer * printer) {
	  printer->Print(
			 "---------------------------------------------------------------------------\n"
			 "-- Field accessor definitions ---------------------------------------------\n"
			 "---------------------------------------------------------------------------\n"
			 "\n");

	  for (int i = 0; i < descriptor_->field_count(); i++) {
	    const FieldDescriptor* field = descriptor_->field(i);

	    PrintFieldComment(printer, field);

	    map<string, string> vars;
	    SetCommonFieldVariables(field, &vars);

	    // Generate Has_$name$ or $name$_Size.
	    if (field->is_repeated()) {
	      GenerateFieldAccessorDefinitionSize(&vars, printer);
	    } else {
	      // Singular field.

	      char buffer[kFastToBufferSize];
	      vars["has_array_index"] = SimpleItoa(field->index() / 32);
	      vars["has_mask"] = FastHex32ToBuffer(1u << (field->index() % 32), buffer);
	      GenerateFieldAccessorDefinitionHas(&vars, printer);
	    }

	    // Generate Clear_$name$
	    GenerateFieldAccessorDefinitionClear(&vars, field, printer);

	    // Generate type-specific accessors.
	    field_generators_.get(field).GenerateAccessorDefinitions(printer);

	    printer->Print("\n");
	  }
	}

	void MessageGenerator::
	GenerateClear(io::Printer * printer) {
	  printer->Print(
			 "procedure Clear\n");
	  printer->Indent();
	  printer->Print("(The_Message : in out Instance) is\n",
			 "package", ada_package_name_);
	  printer->Outdent();
	  printer->Print("begin\n");
	  // TODO: add code to clear extensions, unknown fields etc.
	  printer->Indent();

	  // Body

	  int last_index = -1;

	  for (int i = 0; i < descriptor_->field_count(); i++) {
	    const FieldDescriptor* field = descriptor_->field(i);

	    if (!field->is_repeated()) {
	      // We can use the fact that _has_bits_ is a giant bitfield to our
	      // advantage:  We can check up to 32 bits at a time for equality to
	      // zero, and skip the whole range if so.  This can improve the speed
	      // of Clear for messages which contain a very large number of
	      // optional fields of which only a few are used at a time.  Here,
	      // we've chosen to check 8 bits at a time rather than 32.
	      if (i / 8 != last_index / 8 || last_index < 0) {
		if (last_index >= 0) {
		  printer->Outdent();
		  printer->Print("end if;\n");
		}
		printer->Print(
			       "if (The_Message.Has_Bits ($index$ / 32) and "
			       "Protocol_Buffers.Wire_Format.Shift_Left (16#FF#, $index$ mod 32)) /= 0 then\n",
			       "index", SimpleItoa(field->index()));
		printer->Indent();
	      }
	      last_index = i;

	      // It's faster to just overwrite primitive types, but we should
	      // only clear strings and messages if they were set.
	      bool should_check_bit =
	      field->cpp_type() == FieldDescriptor::CPPTYPE_MESSAGE ||
	      field->cpp_type() == FieldDescriptor::CPPTYPE_STRING;

	      if (should_check_bit) {
		printer->Print("if The_Message.Has_$name$ then\n",
			       "name", FieldName(field));
		printer->Indent();
	      }

	      field_generators_.get(field).GenerateClearingCode(printer);

	      if (should_check_bit) {
		printer->Outdent();
		printer->Print("end if;\n");
	      }
	    }
	  }

	  if (last_index >= 0) {
	    printer->Outdent();
	    printer->Print("end if;\n");
	  }

	  // Repeated fields don't use _has_bits_ so we clear them in a separate
	  // pass.
	  for (int i = 0; i < descriptor_->field_count(); i++) {
	    const FieldDescriptor* field = descriptor_->field(i);

	    if (field->is_repeated()) {

	      field_generators_.get(field).GenerateClearingCode(printer);
	    }
	  }

	  printer->Print("The_Message.Has_Bits := (others => 0);\n");
	  printer->Outdent();
	  printer->Print(
			 "end Clear;\n"
			 "\n");
	}

	void MessageGenerator::
	GenerateCopy(io::Printer * printer) {

	  printer->Print("procedure Copy\n");
	  printer->Indent();
	  printer->Print("(To   : in out Instance;\n"
			 " From : in Instance) is\n",
			 "package", ada_package_name_);
	  printer->Outdent();
	  printer->Print("begin\n");
	  printer->Indent();
	  printer->Print("To.Clear;\n"
			 "To.Merge (From);\n");
	  printer->Outdent();
	  printer->Print("end Copy;\n\n");
	}

	void MessageGenerator::
	GenerateGetTypeName(io::Printer * printer) {

	  printer->Print("function Get_Type_Name\n");
	  printer->Indent();
	  // TODO: change return type?
	  printer->Print("(The_Message : in Instance) return "
			 "Protocol_Buffers.Wire_Format.PB_String is\n",
			 "package", ada_package_name_);
	  printer->Outdent();
	  printer->Print("begin\n");
	  printer->Indent();

	  // Body
	  printer->Print(
			 "return \"$type_name$\";\n",
			 "type_name", descriptor_->full_name());

	  printer->Outdent();
	  printer->Print(
			 "end Get_Type_Name;\n"
			 "\n");
	}

	void MessageGenerator::
	GenerateIsInitialized(io::Printer * printer) {

	  printer->Print(
			 "function Is_Initialized\n");
	  printer->Indent();
	  // TODO: change return type?
	  printer->Print(
			 "(The_Message : in Instance) return Boolean is\n",
			 "package", ada_package_name_);
	  printer->Outdent();
	  printer->Print(
			 "begin\n");
	  printer->Indent();

	  // TODO: Add checks for embedded fields and extensions
	  // Body

	  // Check that all required fields in this message are set.  We can do this
	  // most efficiently by checking 32 "has bits" at a time.
	  int has_bits_array_size = (descriptor_->field_count() + 31) / 32;
	  for (int i = 0; i < has_bits_array_size; i++) {
	    uint32 mask = 0;
	    for (int bit = 0; bit < 32; bit++) {
	      int index = i * 32 + bit;
	      if (index >= descriptor_->field_count()) break;
	      const FieldDescriptor * field = descriptor_->field(index);

	      if (field->is_required()) {
		mask |= 1 << bit;
	      }
	    }

	    if (mask != 0) {
	      char buffer[kFastToBufferSize];
	      printer->Print(
			     "if (The_Message.Has_Bits($i$) and 16#$mask$#) /= 16#$mask$# "
			     "then return False; end if;\n",
			     "i", SimpleItoa(i),
			     "mask", FastHex32ToBuffer(mask, buffer));
	    }
	  }

	  // Now check that all embedded messages are initialized.
	  for (int i = 0; i < descriptor_->field_count(); i++) {
	    const FieldDescriptor* field = descriptor_->field(i);
	    if (field->cpp_type() == FieldDescriptor::CPPTYPE_MESSAGE &&
		!ShouldIgnoreRequiredFieldCheck(field) &&
		HasRequiredFields(field->message_type())) {
		if (field->is_repeated()) {
		  printer->Print(
				 "for E of The_Message.$name$ loop\n",
				 "name", FieldName(field));
		  printer->Indent();
		  printer->Print(
				 "if not E.Is_Initialized then\n");
		  printer->Indent();
		  printer->Print(
				 "return False;\n");
		  printer->Outdent();
		  printer->Print(
				 "end if;\n");
		  printer->Outdent();
		  printer->Print(
				 "end loop;\n");
		} else {

		  printer->Print(
				 "if The_Message.Has_$name$ then\n",
				 "name", FieldName(field));
		  printer->Indent();
		  printer->Print(
				 "if not The_Message.$name$.Is_Initialized then\n",
				 "name", FieldName(field));
		  printer->Indent();
		  printer->Print("return false;\n");
		  printer->Outdent();
		  printer->Print("end if;\n");
		  printer->Outdent();
		  printer->Print(
				 "end if;\n");
		}
	      }
	  }

	  printer->Print(
			 "return True;\n");

	  printer->Outdent();
	  printer->Print(
			 "end Is_Initialized;\n"
			 "\n");
	}

	void MessageGenerator::
	GenerateMerge(io::Printer * printer) {
	  printer->Print(
			 "procedure Merge\n");
	  printer->Indent();
	  printer->Print(
			 "(To   : in out Instance;\n"
			 " From : in Instance) is\n",
			 "package", ada_package_name_);
	  printer->Outdent();
	  printer->Print(
			 "begin\n");
	  printer->Indent();
	  // TODO: implement for extensions ...

	  // Body
	  if (descriptor_->field_count() <= 0) {
	    printer->Print("null;\n");
	  }

	  // Merge Repeated fields. These fields do not require a
	  // check as we can simply iterate over them.
	  for (int i = 0; i < descriptor_->field_count(); ++i) {
	    const FieldDescriptor* field = descriptor_->field(i);

	    if (field->is_repeated()) {
	      field_generators_.get(field).GenerateMergingCode(printer);
	    }
	  }

	  // Merge Optional and Required fields (after a _has_bit check).
	  int last_index = -1;

	  for (int i = 0; i < descriptor_->field_count(); ++i) {
	    const FieldDescriptor* field = descriptor_->field(i);

	    if (!field->is_repeated()) {
	      // See above in GenerateClear for an explanation of this.
	      if (i / 8 != last_index / 8 || last_index < 0) {
		if (last_index >= 0) {
		  printer->Outdent();
		  printer->Print("end if;\n");
		}

		printer->Print("if (From.Has_Bits ($index$ / 32) and "
			       "Protocol_Buffers.Wire_Format.Shift_Left (16#FF#, $index$ mod 32)) /= 0 then\n",
			       "index", SimpleItoa(field->index()));
		printer->Indent();
	      }

	      last_index = i;

	      PrintFieldComment(printer, field);
	      printer->Print("if From.Has_$name$ then\n",
			     "name", FieldName(field));
	      printer->Indent();

	      field_generators_.get(field).GenerateMergingCode(printer);

	      printer->Outdent();
	      printer->Print("end if;\n");
	    }
	  }

	  if (last_index >= 0) {
	    printer->Outdent();
	    printer->Print(
			   "end if;\n");
	  }

	  printer->Outdent();
	  printer->Print(
			 "end Merge;\n"
			 "\n");
	}

	void MessageGenerator::
	GenerateByteSize(io::Printer * printer) {
	  printer->Print(
			 "function Byte_Size\n");
	  printer->Indent();
	  // TODO: change return type?
	  printer->Print(
			 "(The_Message : in out Instance) return Protocol_Buffers.Wire_Format.PB_Object_Size is\n",
			 "package", ada_package_name_);
	  printer->Outdent();
	  printer->Indent();
	  printer->Print(
			 "Total_Size : Protocol_Buffers.Wire_Format.PB_Object_Size := 0;\n");
	  printer->Outdent();
	  printer->Print(
			 "begin\n");
	  printer->Indent();

	  // Body
	  int last_index = -1;

	  for (int i = 0; i < descriptor_->field_count(); ++i) {
	    const FieldDescriptor* field = descriptor_->field(i);
	    if (!field->is_repeated()) {
	      // See above in GenerateClear for an explanation of this.
	      if ((i / 8) != (last_index / 8) ||
		  last_index < 0) {
		  if (last_index >= 0) {
		    printer->Outdent();
		    printer->Print("end if;\n");
		  }
		  printer->Print(
				 "if (The_Message.Has_Bits ($index$ / 32) and "
				 "Protocol_Buffers.Wire_Format.Shift_Left (16#FF#, $index$ mod 32)) /= 0 then\n",
				 "index", SimpleItoa(field->index()));
		  printer->Indent();
		}
	      last_index = i;

	      PrintFieldComment(printer, field);

	      printer->Print(
			     "if The_Message.Has_$name$ then\n",
			     "name", FieldName(field));
	      printer->Indent();

	      field_generators_.get(field).GenerateByteSize(printer);

	      printer->Outdent();
	      printer->Print(
			     "end if;\n");
	    }
	  }

	  if (last_index >= 0) {
	    printer->Outdent();
	    printer->Print("end if;\n");
	  }

	  // TODO: implement Byte_Size for extensions and (unknown fields)?

	  // Repeated fields don't use _has_bits_ so we count them in a separate
	  // pass.
	  for (int i = 0; i < descriptor_->field_count(); i++) {
	    const FieldDescriptor* field = descriptor_->field(i);

	    if (field->is_repeated()) {

	      PrintFieldComment(printer, field);
	      field_generators_.get(field).GenerateByteSize(printer);
	      printer->Print("\n");
	    }
	  }

	  printer->Print("The_Message.Cached_Size := Total_Size;\n"
			 "return Total_Size;\n");
	  printer->Outdent();
	  printer->Print("end Byte_Size;\n"
			 "\n");
	}

	void MessageGenerator::
	GenerateGetCachedSize(io::Printer * printer) {

	  printer->Print("function Get_Cached_Size\n");
	  printer->Indent();
	  // TODO: change return type?
	  printer->Print("(The_Message : in Instance) return Protocol_Buffers.Wire_Format.PB_Object_Size is\n",
			 "package", ada_package_name_);
	  printer->Outdent();
	  printer->Print("begin\n");
	  printer->Indent();
	  printer->Print("return The_Message.Cached_Size;\n");
	  printer->Outdent();
	  printer->Print("end Get_Cached_Size;\n"
			 "\n");
	}

	void MessageGenerator::
	GenerateSerializeWithCachedSizes(io::Printer * printer) {
	  //TODO: implement handling of extensions.
	  scoped_array<const FieldDescriptor*> ordered_fields(SortFieldsByNumber(descriptor_));

	  printer->Print("procedure Serialize_With_Cached_Sizes\n");
	  printer->Indent();
	  printer->Print("(The_Message   : in Instance;\n"
			 " The_Coded_Output_Stream : in\n",
			 "package", ada_package_name_);
	  printer->Indent();
	  printer->Print(" Protocol_Buffers.IO.Coded_Output_Stream.Instance) is\n");
	  printer->Outdent();
	  printer->Outdent();
	  printer->Print("begin\n");
	  printer->Indent();

	  // Body
	  if (descriptor_->field_count() <= 0) {
	    printer->Print("null;\n");
	  }

	  for (int i = 0; i < descriptor_->field_count(); ++i) {

	    GenerateSerializeOneField(printer, ordered_fields[i]);
	  }

	  printer->Outdent();
	  printer->Print("end Serialize_With_Cached_Sizes;\n"
			 "\n");
	}

	void MessageGenerator::
	GenerateMergePartialFromCodedInputStream(io::Printer * printer) {
	  // TODO: Return value indicating success or failure
	  printer->Print("procedure Merge_Partial_From_Coded_Input_Stream\n");
	  printer->Indent();
	  printer->Print("(The_Message   : in out Instance;\n"
			 " The_Coded_Input_Stream : in out\n",
			 "package", ada_package_name_);
	  printer->Indent();
	  printer->Print(" Protocol_Buffers.IO.Coded_Input_Stream.Instance) is\n");
	  printer->Outdent();
	  printer->Print("Tag : Protocol_Buffers.Wire_Format.PB_UInt32;\n");
	  printer->Outdent();
	  printer->Print("begin\n");
	  printer->Indent();

	  // TODO:  Extension, unknown fields, etc. not supported.

	  if (descriptor_->field_count() > 0) {
	    // Body
	    printer->Print("Tag := The_Coded_Input_Stream.Read_Tag;\n"
			   "while Tag /= 0 loop\n");
	    printer->Indent();

	    printer->Print("case Protocol_Buffers.Wire_Format.Get_Tag_Field_Number (Tag) is\n");

	    scoped_array<const FieldDescriptor*> ordered_fields(
								SortFieldsByNumber(descriptor_));

	    for (int i = 0; i < descriptor_->field_count(); i++) {
	      const FieldDescriptor* field = ordered_fields[i];

	      PrintFieldComment(printer, field);

	      printer->Print("when $number$ =>\n",
			     "number", SimpleItoa(field->number()));
	      printer->Indent();
	      const FieldGenerator& field_generator = field_generators_.get(field);

	      // Emit code to parse the common, expected case.
	      printer->Print("if Protocol_Buffers.Wire_Format.Get_Tag_Wire_Type (Tag) =\n");
	      printer->Indent();
	      printer->Print("Protocol_Buffers.Wire_Format.$wiretype$ then\n",
			     "wiretype", kWireTypeNames[internal::WireFormat::WireTypeForField(field)]);

	      // TODO: consider implementing optimization ExpectTag from C++
	      //       implementation if possible ...

	      if (field->options().packed()) {
		field_generator.GenerateMergeFromCodedInputStreamWithPacking(printer);
	      } else {
		field_generator.GenerateMergeFromCodedInputStream(printer);
	      }

	      printer->Outdent();
	      printer->Print("end if;\n");
	      printer->Outdent();
	    }

	    printer->Print("when others =>\n");
	    printer->Indent();
	    printer->Print("declare\n");
	    printer->Indent();
	    printer->Print("Dummy : Protocol_Buffers.Wire_Format.PB_Bool;\n"
			   "pragma Unreferenced (Dummy);\n");
	    printer->Outdent();
	    printer->Print("begin\n");
	    printer->Indent();
	    printer->Print("Dummy := The_Coded_Input_Stream.Skip_Field (Tag);\n"
			   "return;\n");
	    printer->Outdent();
	    printer->Print("end;\n");
	    printer->Outdent();

	    printer->Print("end case;\n"
			   "Tag := The_Coded_Input_Stream.Read_Tag;\n");
	    printer->Outdent();
	    printer->Print("end loop;\n");
	  } else {
	    printer->Print("null;\n");
	    printer->Print("pragma Unreferenced (Tag);\n");
	  }

	  printer->Outdent();
	  printer->Print("end Merge_Partial_From_Coded_Input_Stream;\n"
			 "\n");
	}

	void MessageGenerator::
	GenerateFieldAccessorDefinitionSize(const map<string, string>* variables,
					    io::Printer * printer) {

	  printer->Print((*variables),
			 "function $name$_Size\n");
	  printer->Indent();
	  printer->Print((*variables),
			 "(The_Message : in Instance) return Protocol_Buffers.Wire_Format.PB_Object_Size is\n");
	  printer->Outdent();
	  printer->Print("begin\n");
	  printer->Indent();

	  // Body
	  // TODO: remove type conversion ...
	  printer->Print((*variables),
			 "return Protocol_Buffers.Wire_Format.PB_Object_Size (The_Message.$name$.Length);\n");

	  printer->Outdent();
	  printer->Print((*variables),
			 "end $name$_Size;\n"
			 "\n");
	}

	void MessageGenerator::
	GenerateFieldAccessorDefinitionHas(const map<string, string>* variables,
					   io::Printer * printer) {
	  // Generate Has_$name$

	  printer->Print((*variables),
			 "function Has_$name$\n");
	  printer->Indent();
	  printer->Print((*variables),
			 "(The_Message : in Instance) return Boolean is\n");
	  printer->Outdent();
	  printer->Print("begin\n");
	  printer->Indent();

	  // Body
	  printer->Print((*variables),
			 "return (The_Message.Has_Bits($has_array_index$) and 16#$has_mask$#) /= 0;\n");

	  printer->Outdent();
	  printer->Print((*variables),
			 "end Has_$name$;\n"
			 "\n");

	  // Generate Set_Has_$name$
	  printer->Print((*variables),
			 "procedure Set_Has_$name$\n");
	  printer->Indent();
	  printer->Print((*variables),
			 "(The_Message : in out Instance) is\n");
	  printer->Outdent();
	  printer->Print("begin\n");
	  printer->Indent();

	  // Body
	  printer->Print((*variables),
			 "The_Message.Has_Bits($has_array_index$) := "
			 "The_Message.Has_Bits($has_array_index$) or 16#$has_mask$#;\n");

	  printer->Outdent();
	  printer->Print((*variables),
			 "end Set_Has_$name$;\n\n");

	  // Generate Clear_Has_$name$
	  printer->Print((*variables),
			 "procedure Clear_Has_$name$\n");
	  printer->Indent();
	  printer->Print((*variables),
			 "(The_Message : in out Instance) is\n");
	  printer->Outdent();
	  printer->Print("begin\n");
	  printer->Indent();

	  // Body
	  printer->Print((*variables),
			 "The_Message.Has_Bits($has_array_index$) := "
			 "The_Message.Has_Bits($has_array_index$) and (not 16#$has_mask$#);\n");

	  printer->Outdent();
	  printer->Print((*variables),
			 "end Clear_Has_$name$;\n\n");
	}

	void MessageGenerator::
	GenerateFieldAccessorDefinitionClear(const map<string, string>* variables,
					     const FieldDescriptor* field,
					     io::Printer * printer) {

	  printer->Print((*variables),
			 "procedure Clear_$name$\n");
	  printer->Indent();
	  printer->Print((*variables),
			 "(The_Message : in out Instance) is\n");
	  printer->Outdent();
	  printer->Print("begin\n");
	  printer->Indent();

	  // Body
	  field_generators_.get(field).GenerateClearingCode(printer);

	  if (!field->is_repeated()) {
	    printer->Print((*variables),
			   "The_Message.Clear_Has_$name$;\n");
	  }
	  printer->Outdent();
	  printer->Print((*variables),
			 "end Clear_$name$;\n"
			 "\n");
	}

	void MessageGenerator::
	GenerateTaggedType(io::Printer * printer) {
	  printer->Print("type Instance is new Protocol_Buffers.Message.Instance with record\n");
	  printer->Indent();

	  // Add component(s) to record if message has at least one field.
	  for (int i = 0; i < descriptor_->field_count(); ++i) {

	    const FieldDescriptor* field = descriptor_->field(i);
	    field_generators_.get(field).GenerateRecordComponentDeclaration(printer);
	  }

	  // TODO: change name to avoid name collisions, consider changing type of
	  // Has_Bits and the same goes for Cached_Size.
	  printer->Print("Has_Bits : Protocol_Buffers.Wire_Format.Has_Bits_Array_Type "
			 "(0 .. ($field_count$ + 31) / 32) := (others => 0);\n"
			 "Cached_Size : Protocol_Buffers.Wire_Format.PB_Object_Size := 0;\n",
			 "field_count", SimpleItoa(descriptor_->field_count()));
	  printer->Outdent();
	  printer->Print("end record;\n"
			 "\n");
	}

	void MessageGenerator::
	GenerateSerializeOneField(io::Printer* printer, const FieldDescriptor * field) {
	  PrintFieldComment(printer, field);

	  if (!field->is_repeated()) {
	    printer->Print("if The_Message.Has_$name$ then\n",
			   "name", FieldName(field));
	    printer->Indent();
	  }

	  field_generators_.get(field).GenerateSerializeWithCachedSizes(printer);

	  if (!field->is_repeated()) {

	    printer->Outdent();
	    printer->Print("end if;\n");
	  }
	}

	void MessageGenerator::
	GenerateFinalize(io::Printer * printer) {
	  printer->Print("overriding\n"
			 "procedure Finalize\n");
	  printer->Indent();
	  printer->Print("(The_Message : in out Instance) is\n",
			 "package", ada_package_name_);
	  printer->Outdent();
	  printer->Print("begin\n");
	  printer->Indent();

	  bool finalization_needed = false;

	  // Generate destruction code for each field.
	  for (int i = 0; i < descriptor_->field_count(); i++) {
	    field_generators_.get(descriptor_->field(i))
	    .GenerateFinalizationCode(printer);
	    if (descriptor_->field(i)->cpp_type() == FieldDescriptor::CPPTYPE_MESSAGE
		|| descriptor_->field(i)->cpp_type() == FieldDescriptor::CPPTYPE_STRING) {
		finalization_needed = true;
	      }
	  }

	  if (!finalization_needed) {
	    printer->Print("null;\n");
	  }

	  printer->Outdent();
	  printer->Print("end Finalize;\n\n");
	}

      } // namespace ada
    } // namespace compiler
  } // namespace protobuf
} // namespace google

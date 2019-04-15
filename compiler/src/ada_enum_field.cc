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

#include <ada_enum_field.h>
#include <google/protobuf/io/printer.h>
#include <google/protobuf/descriptor.pb.h>
#include <strutil.h>
#include <iostream>
#include "ada_helpers.h"

namespace google {
  namespace protobuf {
    namespace compiler {
      namespace ada {

	namespace {

	// =========================================================================================
	  void SetEnumVariables(const FieldDescriptor* descriptor,
				map<string, string>* variables) {
	    SetCommonFieldVariables(descriptor, variables);
	    const EnumDescriptor *enum_type = descriptor->enum_type();

	    const EnumValueDescriptor* default_value = descriptor->default_value_enum();
	    (*variables)["default"] = default_value->name();

	    (*variables)["type"] = EnumTypeName(enum_type, true);
	    (*variables)["definition_type"] = EnumDefinitionTypeName(enum_type);

	    //If top level or in same message
	    if (enum_type->containing_type() == NULL || enum_type->containing_type() == descriptor->containing_type()) {
	      //Enum is declared in the same file
	      if (enum_type->file() == descriptor->file()) {
		(*variables)["type"] =	FileAdaPackageName(enum_type->file()) + "." + EnumTypeName(enum_type, true);
		// (*variables)["type"] = EnumTypeName(enum_type, false);
		(*variables)["prefix"] = "";
	      }
	      //Enum is declared in a different file - thus should have a qualified name
	      else {
		(*variables)["type"] = FileAdaPackageName(enum_type->file()) + "." + enum_type->name();
		(*variables)["prefix"] = FileAdaPackageName(enum_type->file()) + ".";
	      }

	      //If the enum is declared somewhere further down in this type hierarchy (does that make sense?)
	    } else if (IsParentMessage(enum_type->containing_type(), descriptor->containing_type())) {
	      (*variables)["type"] =	FileAdaPackageName(enum_type->file()) + "." + EnumTypeName(enum_type, true);
	      //(*variables)["type"] = EnumTypeName(enum_type, true);
	      (*variables)["prefix"] =  AdaPackageName(enum_type->containing_type()) + ".";
	      //Prepend qualified package name
	    } else {
	      (*variables)["type"] =	FileAdaPackageName(enum_type->file()) + "." + EnumDefinitionTypeName(enum_type);
	      // (*variables)["type"] = EnumDefinitionTypeName(enum_type);
	      (*variables)["prefix"] = ""; // EnumDefinitionPackageName(enum_type) + ".";
	    }


	  }

	} // namespace

	// =========================================================================================
	EnumFieldGenerator::EnumFieldGenerator(const FieldDescriptor* descriptor)
	: descriptor_(descriptor) {
	  SetEnumVariables(descriptor, &variables_);
	}

	// =========================================================================================
	EnumFieldGenerator::~EnumFieldGenerator() { }

	// =========================================================================================
	void EnumFieldGenerator::GenerateAccessorDeclarations(io::Printer* printer) const {
	  // Generate declaration Get_$name$
	  printer->Print(variables_,"function Get_$name$ (The_Message : in $packagename$.Instance) return $type$;\n");

	  // Generate declaration Set_$name$
	  printer->Print(variables_, "procedure Set_$name$\n");
	  printer->Print(variables_, "   (The_Message : in out $packagename$.Instance;\n");
	  printer->Print(variables_, "    Value       : in $type$);\n");
	}

	// =========================================================================================
	void EnumFieldGenerator::GenerateAccessorDefinitions(io::Printer* printer) const {
	  // Generate body for $name$
	  printer->Print(variables_,"function Get_$name$ (The_Message : in $packagename$.Instance) return $type$ is\n");
	  printer->Print(variables_,"begin\n");
	  printer->Print(variables_,"   return The_Message.$name$;\n");
	  printer->Print(variables_,"end Get_$name$;\n\n");

	  // Generate body for Set_$name$
	  printer->Print(variables_, "procedure Set_$name$ (The_Message : in out $packagename$.Instance;\n");
	  printer->Print(variables_, "                      Value       : in $type$) is\n");
	  printer->Print(variables_, "begin\n");
	  printer->Print(variables_, "   Set_Has_$name$ (The_Message);\n");
	  printer->Print(variables_, "   The_Message.$name$ := Value;\n");
	  printer->Print(variables_, "end Set_$name$;\n");
	}

	// =========================================================================================
	void EnumFieldGenerator::GenerateClearingCode(io::Printer* printer) const {
	  printer->Print(variables_, "The_Message.$name$ := $type$'($prefix$$default$);\n");
	}

	// =========================================================================================
	void EnumFieldGenerator::GenerateRecordComponentDeclaration(io::Printer* printer) const {
	  printer->Print(variables_, "$name$ : $type$ := $type$'($prefix$$default$);\n");
	}

	// =========================================================================================
	void EnumFieldGenerator::GenerateSerializeWithCachedSizes(io::Printer* printer) const {
	  printer->Print(variables_, "Google.Protobuf.IO.Coded_Output_Stream.Write_Integer_32 (The_Coded_Output_Stream, $number$, $prefix$Enumeration_To_PB_Int32(The_Message.$name$));\n");
	}

	// =========================================================================================
	void EnumFieldGenerator::GenerateByteSize(io::Printer* printer) const {
	  printer->Print(variables_, "Total_Size := Total_Size + $tag_size$ + Google.Protobuf.IO.Coded_Output_Stream.Compute_Integer_32_Size_No_Tag ($prefix$Enumeration_To_PB_Int32(The_Message.$name$));\n");
	}

	// =========================================================================================
	void EnumFieldGenerator::GenerateMergeFromCodedInputStream(io::Printer* printer) const {
	  printer->Print(variables_, "The_Message.$name$ := $prefix$PB_Int32_To_Enumeration (The_Coded_Input_Stream.Read_Integer_32);\n");
	  printer->Print(variables_, "The_Message.Set_Has_$name$;\n");
	}

	void EnumFieldGenerator::GenerateMergingCode(io::Printer* printer) const {
	  printer->Print(variables_,"To.Set_$name$ (From.$name$);\n");
	}

	// =========================================================================================
	void EnumFieldGenerator::GenerateStaticDefaults(io::Printer* printer) const { }

	// =========================================================================================
	// =========================================================================================
	RepeatedEnumFieldGenerator::RepeatedEnumFieldGenerator(const FieldDescriptor* descriptor)
	: descriptor_(descriptor) {
	  SetEnumVariables(descriptor, &variables_);
	}

	// =========================================================================================
	RepeatedEnumFieldGenerator::~RepeatedEnumFieldGenerator() { }

	// =========================================================================================
	void RepeatedEnumFieldGenerator::GenerateAccessorDeclarations(io::Printer* printer) const {
	  // Generate declaration for Get_$name$
	  // TODO: change index type?
	  printer->Print(variables_, "function Get_$name$\n");
	  printer->Print(variables_, "   (The_Message : in $packagename$.Instance;\n");
	  printer->Print(variables_, "    Index : in Google.Protobuf.Wire_Format.PB_Object_Size) return $type$;\n");

	  // Generate declaration for Set_$name$
	  // TODO: change index type?
	  printer->Print(variables_, "procedure Set_$name$ (The_Message : in out $packagename$.Instance;\n");
	  printer->Print(variables_, "                      Index       : in Google.Protobuf.Wire_Format.PB_Object_Size;\n");
	  printer->Print(variables_, "                      Value       : in $type$);\n");

	  // Generate declaration for Add_$name$
	  // TODO: change index type?
	  printer->Print(variables_,"procedure Add_$name$\n");
	  printer->Print(variables_, "   (The_Message : in out $packagename$.Instance;\n");
	  printer->Print(variables_, "    Value       : in $type$);\n");
	}

	// =========================================================================================
	void RepeatedEnumFieldGenerator::GenerateAccessorDefinitions(io::Printer* printer) const {
	  // Generate body for Get_$name$
	  // TODO: change index type?
	  printer->Print(variables_, "function Get_$name$\n");
	  printer->Print(variables_, "   (The_Message : in $packagename$.Instance;\n");
	  printer->Print(variables_, "    Index : in Google.Protobuf.Wire_Format.PB_Object_Size) return $type$ is\n");
	  printer->Print(variables_, "begin\n");
	  printer->Print(variables_, "   return $prefix$PB_Int32_To_Enumeration(The_Message.$name$.Element (Index));\n");
	  printer->Print(variables_, "end Get_$name$;\n\n");

	  // Generate body for Set_$name$
	  // TODO: change index type?
	  printer->Print(variables_, "procedure Set_$name$\n");
	  printer->Print(variables_, "   (The_Message : in out $packagename$.Instance;\n");
	  printer->Print(variables_, "    Index       : in Google.Protobuf.Wire_Format.PB_Object_Size;\n");
	  printer->Print(variables_, "    Value       : in $type$) is\n");
	  printer->Print(variables_, "begin\n");
	  printer->Print(variables_, "   The_Message.$name$.Replace_Element (Index, $prefix$Enumeration_To_PB_Int32(Value));\n");
	  printer->Print(variables_, "end Set_$name$;\n\n");

	  // Generate body for Add_$name$
	  // TODO: change index type?
	  printer->Print(variables_, "procedure Add_$name$\n");
	  printer->Print(variables_, "   (The_Message : in out $packagename$.Instance;\n");
	  printer->Print(variables_, "    Value       : in $type$) is\n");
	  printer->Print(variables_, "begin\n");
	  printer->Print(variables_, "   The_Message.$name$.Append ($prefix$Enumeration_To_PB_Int32 (Value));\n");
	  printer->Print(variables_, "end Add_$name$;\n");
	}

	// =========================================================================================
	void RepeatedEnumFieldGenerator::GenerateClearingCode(io::Printer* printer) const {
	  printer->Print(variables_, "The_Message.$name$.Clear;\n");
	}

	// =========================================================================================
	void RepeatedEnumFieldGenerator::GenerateRecordComponentDeclaration(io::Printer* printer) const {
	  // TODO: store vector on heap?
	  printer->Print(variables_,"$name$ : Google.Protobuf.Wire_Format.PB_Int32_Vector.Vector;\n");
	  if (descriptor_->options().packed()) {
	    printer->Print(variables_,"$name$_cached_byte_size : Google.Protobuf.Wire_Format.PB_Object_Size;\n");
	  }
	}

	// =========================================================================================
	void RepeatedEnumFieldGenerator::GenerateSerializeWithCachedSizes(io::Printer* printer) const {
	  if (descriptor_->options().packed()) {
	    // Write the tag and the size.
	    printer->Print(variables_, "if The_Message.$name$_Size > 0 then\n");
	    printer->Print(variables_, "   The_Coded_Output_Stream.Write_Tag ($number$, Google.Protobuf.Wire_Format.LENGTH_DELIMITED);\n");
	    printer->Print(variables_, "   The_Coded_Output_Stream.Write_Raw_Varint_32 (Google.Protobuf.Wire_Format.PB_UInt32(The_Message.$name$_Cached_Byte_Size));\n");
	    printer->Print(variables_, "end if;\n");
	  }

	  printer->Print(variables_, "for E of The_Message.$name$ loop\n");
	  if (descriptor_->options().packed()) {
	    printer->Print(variables_, "   The_Coded_Output_Stream.Write_Integer_32_No_Tag (E);\n");
	  } else {
	    printer->Print(variables_, "   The_Coded_Output_Stream.Write_Integer_32 ($number$, E);\n");
	  }
	  printer->Print(variables_, "end loop;\n");
	}

	// =========================================================================================
	void RepeatedEnumFieldGenerator::GenerateByteSize(io::Printer* printer) const {
	  printer->Print(variables_, "declare\n");
	  printer->Print(variables_, "   Data_Size : Google.Protobuf.Wire_Format.PB_Object_Size := 0;\n");
	  printer->Print(variables_, "begin\n");
	  printer->Print(variables_, "   for E of The_Message.$name$ loop\n");
	  printer->Print(variables_, "      Data_Size := Data_Size + Google.Protobuf.IO.Coded_Output_Stream.Compute_Integer_32_Size_No_Tag (E);\n");
	  printer->Print(variables_, "   end loop;\n");
	  if (descriptor_->options().packed()) {
	    printer->Print(variables_,"   if Data_Size > 0 then\n");
	    printer->Print(variables_,"      Total_Size := Total_Size + $tag_size$ + Google.Protobuf.IO.Coded_Output_Stream.Compute_Integer_32_Size_No_Tag (Google.Protobuf.Wire_Format.PB_Int32 (Data_Size));\n");
	    printer->Print(variables_,"   end if;\n");
	    printer->Print(variables_,"   The_Message.$name$_Cached_Byte_Size := Data_Size;\n");
	    printer->Print(variables_,"   Total_Size := Total_Size + Data_Size;\n");
	  } else {
	    printer->Print(variables_,"   Total_Size := Total_Size + $tag_size$ * The_Message.$name$_Size + Data_Size;\n");
	  }
	  printer->Print(variables_, "end;\n");
	}

	// =========================================================================================
	void RepeatedEnumFieldGenerator::GenerateMergeFromCodedInputStream(io::Printer* printer) const {
	  // TODO: implement for packed repeated fields.
	  // TODO: consider optimizing. At present we only read one field at time.
	  //       It might be beneficial to guess that the next read item from the
	  //       Coded_Input_Stream is also of this type ...
	  printer->Print(variables_,"The_Message.$name$.Append (The_Coded_Input_Stream.Read_$declared_type$);\n");
	}

	// =========================================================================================
	void RepeatedEnumFieldGenerator::GenerateMergeFromCodedInputStreamWithPacking(io::Printer* printer) const {
	  // TODO: consider optimizing. At present we only read one field at time.
	  //       It might be beneficial to guess that the next read item from the
	  //       Coded_Input_Stream is also of this type ...
	  printer->Print(variables_, "declare\n");
	  printer->Print(variables_, "   use type Ada.Streams.Stream_Element_Offset;\n");
	  printer->Print(variables_, "   Length : Google.Protobuf.Wire_Format.PB_UInt32 := The_Coded_Input_Stream.Read_Raw_Varint_32;\n");
	  printer->Print(variables_, "   Limit  : Ada.Streams.Stream_Element_Offset := The_Coded_Input_Stream.Push_Limit (Ada.Streams.Stream_Element_Offset (Length));\n");
	  printer->Print(variables_, "begin\n");
	  printer->Print(variables_, "   while The_Coded_Input_Stream.Get_Bytes_Until_Limit > 0 loop\n");
	  printer->Print(variables_, "      The_Message.$name$.append (The_Coded_Input_Stream.Read_$declared_type$);\n");
	  printer->Print(variables_, "   end loop;\n");
	  printer->Print(variables_, "   The_Coded_Input_Stream.Pop_Limit (Limit);\n");
	  printer->Print(variables_, "end;\n");
	}

	// =========================================================================================
	void RepeatedEnumFieldGenerator::GenerateMergingCode(io::Printer* printer) const {
	  printer->Print(variables_,"To.$name$.Append (From.$name$);\n");
	}

	// =========================================================================================
	void RepeatedEnumFieldGenerator::GenerateStaticDefaults(io::Printer* printer) const { }

      } // namespace ada
    } // namespace compiler
  } // namespace protobuf
} // namespace google

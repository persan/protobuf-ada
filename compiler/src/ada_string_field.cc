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

#include <ada_string_field.h>
#include <ada_helpers.h>
#include <google/protobuf/io/printer.h>
#include <google/protobuf/descriptor.pb.h>

namespace google {
  namespace protobuf {
    namespace compiler {
      namespace ada {

	namespace {

	// ==================================================================================
	  void SetStringVariables(const FieldDescriptor* descriptor,
				  map<string, string>* variables) {
	    SetCommonFieldVariables(descriptor, variables);
	    (*variables)["type"] = "Google.Protobuf.Wire_Format.PB_String";
	    (*variables)["access_type"] = "Google.Protobuf.Wire_Format.PB_String_Access";
	    (*variables)["default"] = DefaultValue(descriptor);
	    (*variables)["default_variable"] = descriptor->default_value_string().empty() ?
	    "Google.Protobuf.Generated_Message_Utilities.EMPTY_STRING" : "Default_" + FieldName(descriptor);
	  }

	} // namespace

	// ==================================================================================
	StringFieldGenerator::StringFieldGenerator(const FieldDescriptor* descriptor)
	: descriptor_(descriptor) {
	  SetStringVariables(descriptor, &variables_);
	}

	// ==================================================================================
	StringFieldGenerator::~StringFieldGenerator() { }

	// ==================================================================================
	void StringFieldGenerator::GenerateAccessorDeclarations(io::Printer* printer) const {
	  // Generate declaration Get_$name$ return $type$
	  printer->Print(variables_,"function Get_$name$ (The_Message : in $packagename$.Instance) return $type$;\n");

	  // Generate declaration Get_$name$ return $access_type$
	  printer->Print(variables_,"function Get_$name$ (The_Message : in out $packagename$.Instance; Size : in Integer := -1) return $access_type$;\n");

	  // Generate declaration set_$name$
	  printer->Print(variables_,"procedure Set_$name$ (The_Message : in out $packagename$.Instance; Value : in $type$);\n");

	  // Generate declaration Release_$name$
	  printer->Print(variables_,"function Release_$name$ (The_Message : in out $packagename$.Instance) return $access_type$;\n");
	}

	// ==================================================================================
	void StringFieldGenerator::GenerateAccessorDefinitions(io::Printer* printer) const {
	  // Generate body for Get_$name$ return $type$
	  printer->Print(variables_,"function Get_$name$\n");
	  printer->Print(variables_,"   (The_Message : in $packagename$.Instance) return $type$ is\n");
	  printer->Print(variables_,"begin\n");
	  printer->Print(variables_,"   return The_Message.$name$.all;\n");
	  printer->Print(variables_,"end Get_$name$;\n\n");

	  // Generate body Get_$name$ return $access_type$
	  // TODO: call inline procedure instead of including finalization code?
	  printer->Print(variables_,"function Get_$name$\n");
	  printer->Print(variables_,"   (The_Message : in out $packagename$.Instance;\n");
	  printer->Print(variables_, "   Size        : in Integer := -1) return $access_type$ is\n");
	  printer->Print(variables_,"begin\n");
	  printer->Print(variables_,"   The_Message.Set_Has_$name$;\n");
	  printer->Print(variables_,"   if Size >= 0 then\n");
	  GenerateFinalizationCode(printer);
	  printer->Print(variables_,"       The_Message.$name$ := new $type$'(1 .. Size => Character'Val (0));\n");
	  printer->Print(variables_,"       return The_Message.$name$;\n");
	  printer->Print(variables_,"   end if;\n\n");
	  printer->Print(variables_,"   if The_Message.$name$ = $default_variable$'Access then\n");
	  printer->Print(variables_,"      The_Message.$name$ := new String'($default_variable$);\n");
	  printer->Print(variables_,"    end if;\n");
	  printer->Print(variables_,"    return The_Message.$name$;\n");
	  printer->Print(variables_,"end Get_$name$;\n\n");

	  // Generate body for Set_$name$

	  printer->Print(variables_, "procedure Set_$name$\n");
	  printer->Print(variables_, "   (The_Message : in out $packagename$.Instance;\n");
	  printer->Print(variables_, "    Value       : in $type$) is\n");
	  printer->Print(variables_, "begin\n");
	  printer->Print(variables_, "   The_Message.Set_Has_$name$;\n");
	  printer->Print(variables_, "   if The_Message.$name$ /= $default_variable$'Access and then Value'Length = The_Message.$name$.all'Length then\n");
	  printer->Print(variables_, "      The_Message.$name$.all := Value;\n");
	  printer->Print(variables_, "   else\n");
	  // TODO: call inline procedure instead of including finalization code?
	  GenerateFinalizationCode(printer);
	  printer->Print(variables_, "      The_Message.$name$ := new Google.Protobuf.Wire_Format.PB_String'(Value);\n");
	  printer->Print(variables_, "   end if;\n");
	  printer->Print(variables_, "end Set_$name$;\n\n");

	  // Generate body Release_$name$
	  printer->Print(variables_, "function Release_$name$\n");
	  printer->Print(variables_, "   (The_Message : in out $packagename$.Instance) return $access_type$ is\n");
	  printer->Print(variables_, "begin\n");
	  printer->Print(variables_, "   The_Message.Clear_Has_$name$;\n");
	  printer->Print(variables_, "   if The_Message.$name$ = $default_variable$'Access then\n");
	  printer->Print(variables_, "      return null;\n");
	  printer->Print(variables_, "   else\n");
	  printer->Print(variables_, "      declare\n");
	  printer->Print(variables_, "         Temp : $access_type$ := The_Message.$name$;\n");
	  printer->Print(variables_, "      begin\n");
	  printer->Print(variables_, "         The_Message.$name$ := $default_variable$'Access;\n");
	  printer->Print(variables_, "         return Temp;\n");
	  printer->Print(variables_, "      end;\n");
	  printer->Print(variables_, "   end if;\n");
	  printer->Print(variables_, "end Release_$name$;\n");
	}

	// ==================================================================================
	void StringFieldGenerator::GenerateClearingCode(io::Printer* printer) const {
	  // TODO: Optimize! We _really_ don't want to free a string
	  //  but instead reuse it to avoid allocating and deallocating
	  //  storage. This would involve quite a bit of extra work ...
	  printer->Print(variables_,"The_Message.Clear_Has_$name$;\n");
	  GenerateFinalizationCode(printer);
	  printer->Print(variables_,"The_Message.$name$ := $default_variable$'Access;\n");
	}

	// ==================================================================================
	void StringFieldGenerator::GenerateRecordComponentDeclaration(io::Printer* printer) const {
	  printer->Print(variables_,"$name$ : $access_type$ := $default_variable$'Access;\n");
	}

	// ==================================================================================
	void StringFieldGenerator::GenerateSerializeWithCachedSizes(io::Printer* printer) const {
	  printer->Print(variables_,"The_Coded_Output_Stream.Write_String ($number$, The_Message.$name$.all);\n");
	}

	// ==================================================================================
	void StringFieldGenerator::GenerateByteSize(io::Printer* printer) const {
	  printer->Print(variables_,"Total_Size := Total_Size + $tag_size$ + Google.Protobuf.IO.Coded_Output_Stream.Compute_$declared_type$_Size_No_Tag (The_Message.$name$.all);\n");
	}

	// ==================================================================================
	void StringFieldGenerator::GenerateMergeFromCodedInputStream(io::Printer* printer) const {
	  // TODO: create Set_$name$ for access types and use that instead.
	  GenerateFinalizationCode(printer);
	  printer->Print(variables_, "The_Message.Set_Has_$name$;\n");
	  printer->Print(variables_, "The_Message.$name$ := The_Coded_Input_Stream.Read_String;\n");
	}

	// ==================================================================================
	void StringFieldGenerator::GenerateMergingCode(io::Printer* printer) const {
	  printer->Print(variables_,"To.Set_$name$(From.Get_$name$);\n");
	}

	// ==================================================================================
	void StringFieldGenerator::GenerateStaticDefaults(io::Printer* printer) const {
	  if (descriptor_->has_default_value() && !descriptor_->default_value_string().empty()) {
	    printer->Print(variables_,"$default_variable$ : aliased $type$ := $default$;\n");
	  }
	}

	// ==================================================================================
	void StringFieldGenerator::GenerateFinalizationCode(io::Printer* printer) const {
	  // TODO: Consider changing this to a procedure.
	  // TODO: Move this elsewhere
	  printer->Print(variables_, "declare\n");
	  printer->Print(variables_, "   procedure Free is new Ada.Unchecked_Deallocation ($type$, $access_type$);\n");
	  printer->Print(variables_, "begin\n");
	  printer->Print(variables_, "   if The_Message.$name$ /= $default_variable$'Access then\n");
	  printer->Print(variables_, "      Free (The_Message.$name$);\n");
	  printer->Print(variables_, "   end if;\n");
	  printer->Print(variables_, "end;\n");
	}

	// ==================================================================================
	RepeatedStringFieldGenerator::RepeatedStringFieldGenerator(const FieldDescriptor* descriptor)
	: descriptor_(descriptor) {
	  SetStringVariables(descriptor, &variables_);
	}

	// ==================================================================================
	RepeatedStringFieldGenerator::~RepeatedStringFieldGenerator() { }

	// ==================================================================================
	void RepeatedStringFieldGenerator::GenerateAccessorDeclarations(io::Printer* printer) const {
	  // Generate declaration for Get_$name$(index : in Integer)
	  // TODO: change index type?
	  printer->Print(variables_,"function Get_$name$\n");
	  printer->Print(variables_,"   (The_Message : in $packagename$.Instance;\n");
	  printer->Print(variables_,"    Index : in Google.Protobuf.Wire_Format.PB_Object_Size) return $type$;\n");

	  // Generate body for Set_$name$
	  // TODO: change index type?
	  printer->Print(variables_,"procedure Set_$name$\n");
	  printer->Print(variables_,"   (The_Message : in out $packagename$.Instance;\n");
	  printer->Print(variables_,"    Index       : in Google.Protobuf.Wire_Format.PB_Object_Size;\n");
	  printer->Print(variables_,"    Value       : in $type$);\n");

	  // Generate declaration for Add_$name$
	  printer->Print(variables_, "procedure Add_$name$\n");
	  printer->Print(variables_, "   (The_Message : in out $packagename$.Instance;");
	  printer->Print(variables_, "    Value       : in $type$);\n");
	}

	// ==================================================================================
	void RepeatedStringFieldGenerator::GenerateAccessorDefinitions(io::Printer* printer) const {
	  // Generate body for Get_$name$(index : in Integer)
	  // TODO: change index type?
	  printer->Print(variables_, "function Get_$name$\n");
	  printer->Print(variables_, "   (The_Message : in $packagename$.Instance;\n");
	  printer->Print(variables_, "    Index       : in Google.Protobuf.Wire_Format.PB_Object_Size) return $type$ is\n");
	  printer->Print(variables_,"begin\n");
	  printer->Print(variables_,"   return The_Message.$name$.Element (Index).all;\n");
	  printer->Print(variables_,"end Get_$name$;\n\n");

	  // Generate body for Set_$name$
	  // TODO: change index type?
	  printer->Print(variables_,"procedure Set_$name$\n");
	  printer->Indent();
	  printer->Print(variables_,"   (The_Message : in out $packagename$.Instance;\n");
	  printer->Print(variables_,"    Index       : in Google.Protobuf.Wire_Format.PB_Object_Size;\n");
	  printer->Print(variables_,"    Value       : in $type$) is\n");
	  printer->Print(variables_,"begin\n");

	  // TODO: refactor.
	  // TODO: move this elsewhere.
	  printer->Print(variables_,"   declare\n");
	  printer->Print(variables_,"      Temp : $access_type$ := The_Message.$name$.Element (Index);\n");
	  printer->Print(variables_,"      procedure Free is new Ada.Unchecked_Deallocation ($type$, $access_type$);\n");
	  printer->Print(variables_,"   begin\n");
	  printer->Print(variables_,"      Free (Temp);\n");
	  printer->Print(variables_,"   end;\n");
	  printer->Print(variables_,"   The_Message.$name$.Replace_Element (Index, new $type$'(Value));\n");
	  printer->Print(variables_,"end Set_$name$;\n\n");

	  // Generate declaration for Add_$name$
	  printer->Print(variables_, "procedure Add_$name$\n");
	  printer->Print(variables_, "   (The_Message : in out $packagename$.Instance;\n");
	  printer->Print(variables_, "    Value       : in $type$) is\n");
	  //"New_Item : $access_type$ := new $type$'(Value);\n");
	  printer->Print(variables_, "begin\n");
	  printer->Print(variables_, "   The_Message.$name$.Append (new $type$'(Value));\n");
	  printer->Print(variables_, "end Add_$name$;\n");

	}

	// ==================================================================================
	void RepeatedStringFieldGenerator::GenerateClearingCode(io::Printer* printer) const {
	  // TODO: Optimize! We _really_ don't want to free all strings
	  //  but instead reuse them to avoid allocating and deallocating
	  //  storage. This would involve quite a bit of extra work ...
	  GenerateFinalizationCode(printer);
	}

	// ==================================================================================
	void RepeatedStringFieldGenerator::GenerateRecordComponentDeclaration(io::Printer* printer) const {
	  // TODO: store vector on heap?
	  printer->Print(variables_,"$name$ : $access_type$_Vector.Vector;\n");
	}

	// ==================================================================================
	void RepeatedStringFieldGenerator::GenerateSerializeWithCachedSizes(io::Printer* printer) const {
	  printer->Print(variables_,"for E of The_Message.$name$ loop\n");
	  printer->Print(variables_,"   The_Coded_Output_Stream.Write_$declared_type$ ($number$, E.all);\n");
	  printer->Print(variables_,"end loop;\n");
	}

	// ==================================================================================
	void RepeatedStringFieldGenerator::GenerateByteSize(io::Printer* printer) const {
	  printer->Print(variables_,"Total_Size := Total_Size + $tag_size$ * The_Message.$name$_Size;\n");
	  printer->Print(variables_,"for E of The_Message.$name$ loop\n");
	  printer->Print(variables_,"   Total_Size := Total_Size + Google.Protobuf.IO.Coded_Output_Stream.Compute_$declared_type$_Size_No_Tag (E.all);\n");
	  printer->Print(variables_,"end loop;\n");
	}

	// ==================================================================================
	void RepeatedStringFieldGenerator::GenerateMergeFromCodedInputStream(io::Printer* printer) const {
	  printer->Print(variables_,"The_Message.$name$.Append (The_Coded_Input_Stream.Read_String);\n");
	}

	// ==================================================================================
	void RepeatedStringFieldGenerator::GenerateMergingCode(io::Printer* printer) const {
	  // TODO: optimize ...
	  printer->Print(variables_,"for E of From.$name$ loop\n");
	  printer->Print(variables_,"   To.$name$.Append (new $type$'(E.all));\n");
	  printer->Print(variables_,"end loop;\n");
	}

	// ==================================================================================
	void RepeatedStringFieldGenerator::GenerateStaticDefaults(io::Printer* printer) const { }

	// ==================================================================================
	void RepeatedStringFieldGenerator::GenerateFinalizationCode(io::Printer* printer) const {
	  // TODO: Consider changing this to a procedure.
	  printer->Print(variables_,"declare\n");
	  // TODO: Make Free global?
	  printer->Print(variables_,"   Temp : $access_type$;\n");
	  printer->Print(variables_,"   procedure Free is new Ada.Unchecked_Deallocation ($type$, $access_type$);\n");
	  printer->Print(variables_,"begin\n");
	  printer->Print(variables_,"   for E of The_Message.$name$ loop\n");
	  printer->Print(variables_,"      Temp := E;\n");
	  printer->Print(variables_,"      Free (Temp);\n");
	  printer->Print(variables_,"   end loop;\n");
	  printer->Print(variables_,"end;\n");
	  printer->Print(variables_,"The_Message.$name$.Clear;\n\n");
	}
      } // namespace ada
    } // namespace compiler
  } // namespace protobuf
} // namespace google

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

#include <ada_primitive_field.h>
#include <ada_helpers.h>
#include <google/protobuf/io/printer.h>
#include <google/protobuf/wire_format.h>
#include <strutil.h>

#include "ada_enum_field.h"

namespace google {
namespace protobuf {
namespace compiler {
namespace ada {

using internal::WireFormatLite;

namespace {

// For encodings with fixed sizes, returns that size in bytes.  Otherwise
// returns -1.

int FixedSize(FieldDescriptor::Type type) {
  switch (type) {
    case FieldDescriptor::TYPE_INT32: return -1;
    case FieldDescriptor::TYPE_INT64: return -1;
    case FieldDescriptor::TYPE_UINT32: return -1;
    case FieldDescriptor::TYPE_UINT64: return -1;
    case FieldDescriptor::TYPE_SINT32: return -1;
    case FieldDescriptor::TYPE_SINT64: return -1;
    case FieldDescriptor::TYPE_FIXED32: return WireFormatLite::kFixed32Size;
    case FieldDescriptor::TYPE_FIXED64: return WireFormatLite::kFixed64Size;
    case FieldDescriptor::TYPE_SFIXED32: return WireFormatLite::kSFixed32Size;
    case FieldDescriptor::TYPE_SFIXED64: return WireFormatLite::kSFixed64Size;
    case FieldDescriptor::TYPE_FLOAT: return WireFormatLite::kFloatSize;
    case FieldDescriptor::TYPE_DOUBLE: return WireFormatLite::kDoubleSize;

    case FieldDescriptor::TYPE_BOOL: return WireFormatLite::kBoolSize;
    case FieldDescriptor::TYPE_ENUM: return -1;

    case FieldDescriptor::TYPE_STRING: return -1;
    case FieldDescriptor::TYPE_BYTES: return -1;
    case FieldDescriptor::TYPE_GROUP: return -1;
    case FieldDescriptor::TYPE_MESSAGE: return -1;

      // No default because we want the compiler to complain if any new
      // types are added.
  }
  GOOGLE_LOG(FATAL) << "Can't get here.";
  return -1;
}

const char* PrimitiveTypeName(AdaType type) {
  switch (type) {
    case ADATYPE_INT32: return "Protocol_Buffers.Wire_Format.PB_Int32";
    case ADATYPE_INT64: return "Protocol_Buffers.Wire_Format.PB_Int64";
    case ADATYPE_UINT32: return "Protocol_Buffers.Wire_Format.PB_UInt32";
    case ADATYPE_UINT64: return "Protocol_Buffers.Wire_Format.PB_UInt64";
    case ADATYPE_DOUBLE: return "Protocol_Buffers.Wire_Format.PB_Double";
    case ADATYPE_FLOAT: return "Protocol_Buffers.Wire_Format.PB_Float";
    case ADATYPE_BOOL: return "Protocol_Buffers.Wire_Format.PB_Bool";
    case ADATYPE_ENUM: return "Protocol_Buffers.Wire_Format.PB_UInt32";
    case ADATYPE_STRING: return "Protocol_Buffers.Wire_Format.PB_String";
    case ADATYPE_BYTES: return "Protocol_Buffers.Wire_Format.PB_String";
    case ADATYPE_MESSAGE: return "";
    case ADATYPE_GROUP: return "";

      // No default because we want the compiler to complain if any new
      // AdaTypes are added.
  }

  GOOGLE_LOG(FATAL) << "Can't get here.";
  return NULL;
}

void SetPrimitiveVariables(const FieldDescriptor* descriptor,
  map<string, string>* variables) {
  if (GetAdaType(descriptor) == ADATYPE_GROUP) {
    // TODO: fail more gracefully!
    GOOGLE_LOG(FATAL) << "groups not supported.";
  }
  SetCommonFieldVariables(descriptor, variables);
  (*variables)["type"] = PrimitiveTypeName(GetAdaType(descriptor));
  (*variables)["default"] = DefaultValue(descriptor);
  (*variables)["tag"] = SimpleItoa(internal::WireFormat::MakeTag(descriptor));
  int fixed_size = FixedSize(descriptor->type());
  if (fixed_size != -1) {
    (*variables)["fixed_size"] = SimpleItoa(fixed_size);
  }
}

} // namespace

PrimitiveFieldGenerator::
PrimitiveFieldGenerator(const FieldDescriptor* descriptor)
: descriptor_(descriptor) {
  SetPrimitiveVariables(descriptor, &variables_);
}

PrimitiveFieldGenerator::
~PrimitiveFieldGenerator() { }

void PrimitiveFieldGenerator::
GenerateAccessorDeclarations(io::Printer* printer) const {
  // Generate declaration Get_$name$
  printer->Print(variables_,
    "function Get_$name$\n");
  printer->Indent();
  printer->Print(variables_,
    "(The_Message : in $packagename$.Instance) return $type$;\n");
  printer->Outdent();

  // Generate declaration Set_$name$
  printer->Print(variables_,
    "procedure Set_$name$\n");
  printer->Indent();
  printer->Print(variables_,
    "(The_Message : in out $packagename$.Instance;\n"
    " value : in $type$);\n");
  printer->Outdent();
}

void PrimitiveFieldGenerator::
GenerateAccessorDefinitions(io::Printer* printer) const {
  // Generate body for Get_$name$
  printer->Print(variables_,
    "function Get_$name$\n");
  printer->Indent();
  printer->Print(variables_,
    "(The_Message : in $packagename$.Instance) return $type$ is\n");
  printer->Outdent();
  printer->Print(
    "begin\n");
  printer->Indent();
  printer->Print(variables_,
    "return The_Message.$name$;\n");
  printer->Outdent();
  printer->Print(variables_,
    "end Get_$name$;\n"
    "\n");

  // Generate body for Set_$name$
  printer->Print(variables_,
    "procedure Set_$name$\n");
  printer->Indent();
  printer->Print(variables_,
    "(The_Message : in out $packagename$.Instance;\n"
    " Value : in $type$) is\n");
  printer->Outdent();
  printer->Print(
    "begin\n");
  printer->Indent();
  printer->Print(variables_,
    "The_Message.Set_Has_$name$;\n"
    "The_Message.$name$ := Value;\n");
  printer->Outdent();
  printer->Print(variables_,
    "end Set_$name$;\n");
}

void PrimitiveFieldGenerator::
GenerateClearingCode(io::Printer* printer) const {
  printer->Print(variables_,
    "The_Message.$name$ := $default$;\n");
}

void PrimitiveFieldGenerator::
GenerateRecordComponentDeclaration(io::Printer* printer) const {
  printer->Print(variables_,
    "$name$ : $type$ := $default$;\n");
}

void PrimitiveFieldGenerator::
GenerateSerializeWithCachedSizes(io::Printer* printer) const {
  printer->Print(variables_,
    "Protocol_Buffers.IO.Coded_Output_Stream.Write_$declared_type$ ("
    "The_Coded_Output_Stream, $number$, The_Message.$name$);\n");
}

void PrimitiveFieldGenerator::
GenerateByteSize(io::Printer* printer) const {
  int fixed_size = FixedSize(descriptor_->type());
  if (fixed_size == -1) {
    printer->Print(variables_,
      "Total_Size := Total_Size + $tag_size$ + "
      "Protocol_Buffers.IO.Coded_Output_Stream.Compute_$declared_type$_Size_No_Tag ("
      "The_Message.$name$);\n");
  } else {
    printer->Print(variables_,
      "Total_Size := Total_Size + $tag_size$ + $fixed_size$;\n");
  }
}

void PrimitiveFieldGenerator::
GenerateMergeFromCodedInputStream(io::Printer* printer) const {
  printer->Print(variables_,
    "The_Message.$name$ := The_Coded_Input_Stream.Read_$declared_type$;\n"
    "The_Message.Set_Has_$name$;\n");
}

void PrimitiveFieldGenerator::
GenerateMergingCode(io::Printer* printer) const {
  printer->Print(variables_,
    "To.Set_$name$ (From.$name$);\n");
}

void PrimitiveFieldGenerator::
GenerateStaticDefaults(io::Printer* printer) const { }

// ===================================================================

RepeatedPrimitiveFieldGenerator::
RepeatedPrimitiveFieldGenerator(const FieldDescriptor* descriptor)
: descriptor_(descriptor) {
  SetPrimitiveVariables(descriptor, &variables_);
}

RepeatedPrimitiveFieldGenerator::
~RepeatedPrimitiveFieldGenerator() { }

void RepeatedPrimitiveFieldGenerator::
GenerateAccessorDeclarations(io::Printer* printer) const {
  // Generate declaration for Get_$name$
  // TODO: change index type?
  printer->Print(variables_,
    "function Get_$name$\n");
  printer->Indent();
  printer->Print(variables_,
    "(The_Message : in $packagename$.Instance;\n"
    " Index : in Protocol_Buffers.Wire_Format.PB_Object_Size) return $type$;\n");
  printer->Outdent();

  // Generate declaration for Set_$name$
  // TODO: change index type?
  printer->Print(variables_,
    "procedure Set_$name$\n");
  printer->Indent();
  printer->Print(variables_,
    "(The_Message : in out $packagename$.Instance;\n"
    " Index : in Protocol_Buffers.Wire_Format.PB_Object_Size;\n"
    " Value : in $type$);\n");
  printer->Outdent();

  // Generate declaration for Add_$name$
  // TODO: change index type?
  printer->Print(variables_,
    "procedure Add_$name$\n");
  printer->Indent();
  printer->Print(variables_,
    "(The_Message : in out $packagename$.Instance;\n"
    " Value : in $type$);\n");
  printer->Outdent();


  // TODO: add functionality to get and set vector?
}

void RepeatedPrimitiveFieldGenerator::
GenerateAccessorDefinitions(io::Printer* printer) const {
  // Generate body for Get_$name$
  // TODO: change index type?
  printer->Print(variables_,
    "function Get_$name$\n");
  printer->Indent();
  printer->Print(variables_,
    "(The_Message : in $packagename$.Instance;\n"
    " Index : in Protocol_Buffers.Wire_Format.PB_Object_Size) return $type$ is\n");
  printer->Outdent();
  printer->Print(
    "begin\n");
  printer->Indent();

  // Body
  printer->Print(variables_,
    "return The_Message.$name$.Element (Index);\n");

  printer->Outdent();
  printer->Print(variables_,
    "end Get_$name$;\n"
    "\n");

  // Generate body for Set_$name$
  // TODO: change index type?
  printer->Print(variables_,
    "procedure Set_$name$\n");
  printer->Indent();
  printer->Print(variables_,
    "(The_Message : in out $packagename$.Instance;\n"
    " Index : in Protocol_Buffers.Wire_Format.PB_Object_Size;\n"
    " Value : in $type$) is\n");
  printer->Outdent();
  printer->Print(
    "begin\n");
  printer->Indent();

  // Body
  printer->Print(variables_,
    "The_Message.$name$.Replace_Element (Index, Value);\n");

  printer->Outdent();
  printer->Print(variables_,
    "end Set_$name$;\n"
    "\n");

  // Generate body for Add_$name$
  // TODO: change index type?
  printer->Print(variables_,
    "procedure Add_$name$\n");
  printer->Indent();
  printer->Print(variables_,
    "(The_Message : in out $packagename$.Instance;\n"
    " Value : in $type$) is\n");
  printer->Outdent();
  printer->Print(
    "begin\n");
  printer->Indent();


  // Body
  printer->Print(variables_,
    "The_Message.$name$.Append (Value);\n");

  printer->Outdent();
  printer->Print(variables_,
    "end Add_$name$;\n");
}

void RepeatedPrimitiveFieldGenerator::
GenerateClearingCode(io::Printer* printer) const {
  printer->Print(variables_,
    "The_Message.$name$.Clear;\n");
}

void RepeatedPrimitiveFieldGenerator::
GenerateRecordComponentDeclaration(io::Printer* printer) const {
  // TODO: store vector on heap?
  printer->Print(variables_,
    "$name$ : $type$_Vector.Vector;\n");
  if (descriptor_->options().packed()) {
    printer->Print(variables_,
      "$name$_Cached_Byte_Size : Protocol_Buffers.Wire_Format.PB_Object_Size;\n");
  }
}

void RepeatedPrimitiveFieldGenerator::
GenerateSerializeWithCachedSizes(io::Printer* printer) const {
  if (descriptor_->options().packed()) {
    // Write the tag and the size.
    printer->Print(variables_,
      "if The_Message.$name$_Size > 0 then\n");
    printer->Indent();
    printer->Print(variables_,
      "The_Coded_Output_Stream.Write_Tag ($number$,"
      "Protocol_Buffers.Wire_Format.LENGTH_DELIMITED);\n"
      "The_Coded_Output_Stream.Write_Raw_Varint_32 ("
      "Protocol_Buffers.Wire_Format.PB_UInt32("
      "The_Message.$name$_Cached_Byte_Size));\n");
    printer->Outdent();
    printer->Print(
      "end if;\n");
  }
  printer->Print(variables_,
    "for E of The_Message.$name$ loop\n");
  printer->Indent();
  if (descriptor_->options().packed()) {
    printer->Print(variables_,
      "The_Coded_Output_Stream.Write_$declared_type$_No_Tag (E);\n");
  } else {
    printer->Print(variables_,
      "The_Coded_Output_Stream.Write_$declared_type$ ($number$, E);\n");
  }
  printer->Outdent();
  printer->Print(
    "end loop;\n");
}

void RepeatedPrimitiveFieldGenerator::
GenerateByteSize(io::Printer* printer) const {
  printer->Print(
    "declare\n");
  printer->Indent();
  printer->Print(
    "Data_Size : Protocol_Buffers.Wire_Format.PB_Object_Size := 0;\n");
  printer->Outdent();
  printer->Print(
    "begin\n");
  printer->Indent();

  int fixed_size = FixedSize(descriptor_->type());
  if (fixed_size == -1) {
    printer->Print(variables_,
      "for E of The_Message.$name$ loop\n");
    printer->Indent();
    printer->Print(variables_,
      "Data_Size := Data_Size + "
      "Protocol_Buffers.IO.Coded_Output_Stream.Compute_$declared_type$_Size_No_Tag ("
      "E);\n");
    printer->Outdent();
    printer->Print(
      "end loop;\n");
  } else {
    printer->Print(variables_,
      "Data_Size := $fixed_size$ * The_Message.$name$_Size;\n");
  }

  if (descriptor_->options().packed()) {
    printer->Print(variables_,
      "if Data_Size > 0 then\n");
    printer->Indent();
    printer->Print(variables_,
      "Total_Size := Total_Size + $tag_size$ + "
      "Protocol_Buffers.IO.Coded_Output_Stream.Compute_Integer_32_Size_No_Tag ("
      "Protocol_Buffers.Wire_Format.PB_Int32 (Data_Size));\n");
    printer->Outdent();
    printer->Print(
      "end if;\n");
    printer->Print(variables_,
      "The_Message.$name$_Cached_Byte_Size := Data_Size;\n"
      "Total_Size := Total_Size + Data_Size;\n");
  } else {
    printer->Print(variables_,
      "Total_Size := Total_Size + $tag_size$ * The_Message.$name$_Size + Data_Size;\n");
  }

  printer->Outdent();
  printer->Print("end;\n");
}

void RepeatedPrimitiveFieldGenerator::
GenerateMergeFromCodedInputStreamWithPacking(io::Printer* printer) const {
  // TODO: consider optimizing. At present we only read one field at time.
  //       It might be beneficial to guess that the next read item from the
  //       Coded_Input_Stream is also of this type ...
  printer->Print(
    "declare\n");
  printer->Indent();
  printer->Print(
    "use type Ada.Streams.Stream_Element_Offset;\n"
    "Length : Protocol_Buffers.Wire_Format.PB_UInt32 := "
    "The_Coded_Input_Stream.Read_Raw_Varint_32;\n"
    "Limit : Ada.Streams.Stream_Element_Offset := "
    "The_Coded_Input_Stream.Push_Limit ("
    "Ada.Streams.Stream_Element_Offset(Length));\n");
  printer->Outdent();
  printer->Print(
    "begin\n");
  printer->Indent();
  printer->Print(variables_,
    "while The_Coded_Input_Stream.Get_Bytes_Until_Limit > 0 loop\n");
  printer->Indent();
  printer->Print(variables_,
    "The_Message.$name$.append (The_Coded_Input_Stream.Read_$declared_type$);\n");
  printer->Outdent();
  printer->Print(
    "end loop;\n");
  printer->Outdent();
  printer->Print(
    "The_Coded_Input_Stream.Pop_Limit (Limit);\n"
    "end;\n");
}

void RepeatedPrimitiveFieldGenerator::
GenerateMergeFromCodedInputStream(io::Printer* printer) const {
  // TODO: consider optimizing. At present we only read one field at time.
  //       It might be beneficial to guess that the next read item from the
  //       Coded_Input_Stream is also of this type ...
  printer->Print(variables_,
    "The_Message.$name$.Append (The_Coded_Input_Stream.Read_$declared_type$);\n");
}

void RepeatedPrimitiveFieldGenerator::
GenerateMergingCode(io::Printer* printer) const {
  printer->Print(variables_,
    "To.$name$.Append(From.$name$);\n");
}

void RepeatedPrimitiveFieldGenerator::
GenerateStaticDefaults(io::Printer* printer) const { }


} // namespace ada
} // namespace compiler
} // namespace protobuf
} // namespace google

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

#ifndef GOOGLE_PROTOBUF_COMPILER_ADA_MESSAGE_H__
#define GOOGLE_PROTOBUF_COMPILER_ADA_MESSAGE_H__

#include <string>
#include <set>

#include <ada_field.h>

namespace google {
  namespace protobuf {
    namespace io {
      class Printer; // printer.h
    }
  }

  namespace protobuf {
    namespace compiler {
      namespace ada {

	class MessageGenerator {
	  public:
	  explicit MessageGenerator(const Descriptor* descriptor,
				    const string& package);
	  ~MessageGenerator();

	  // Generate package specification.
	  void GenerateSpecification(io::Printer* printer);

	  // Generate package body.
	  void GenerateBody(io::Printer* printer);

	  private:
	  // Generates function and procedure declarations for
	  // Google.Protobuf.Message.
	  void GenerateMessageDeclarations(io::Printer* printer);

	  // Generates function and procedure definitions for
	  // Google.Protobuf.Message.
	  void GenerateMessageDefinitions(io::Printer* printer);

	  // Generates declarations for accessors of fields defined in proto definition
	  // file.
	  void GenerateFieldAccessorDeclarations(io::Printer* printer);

	  // Generates definitions for accessors of fields defined in proto definition
	  // file.
	  void GenerateFieldAccessorDefinitions(io::Printer* printer);

	  // Generate enumeration literals so that they appear to be declared inside
	  // this message.
	  void GenerateEnumerationLiterals(io::Printer* printer);

	  // Generate code for Clear procedure declared in Google.Protobuf.Message.
	  void GenerateClear(io::Printer* printer);

	  // Generate code for Copy procedure declared in Google.Protobuf.Message.
	  void GenerateCopy(io::Printer* printer);

	  // Generate code for Merge procedure declared in Google.Protobuf.Message.
	  void GenerateMerge(io::Printer* printer);

	  // Generate code for Merge_Partial_From_Coded_Input_Stream procedure declared
	  // in Google.Protobuf.Message.
	  void GenerateMergePartialFromCodedInputStream(io::Printer* printer);

	  // Generate code for Get_Type_Name function declared in
	  // Google.Protobuf.Message.
	  void GenerateGetTypeName(io::Printer* printer);

	  // Generate code for Byte_Size function declared in
	  // Google.Protobuf.Message.
	  void GenerateByteSize(io::Printer* printer);

	  // Generate code for Get_Cached_Size function declared in
	  // Google.Protobuf.Message.
	  void GenerateGetCachedSize(io::Printer* printer);

	  // Generate code for Serialize_With_Cached_Sizes procedure in
	  // Google.Protobuf.Message.
	  void GenerateSerializeWithCachedSizes(io::Printer* printer);

	  // Generate code for Is_Initialized function declared in
	  // Google.Protobuf.Message.
	  void GenerateIsInitialized(io::Printer* printer);

	  // Generate tagged type
	  void GenerateTaggedType (io::Printer* printer);

	  // Generate code for $name$_Size
	  void GenerateFieldAccessorDefinitionSize(const map<string, string>* variables, io::Printer* printer);

	  // Generate code for Has_$name$
	  void GenerateFieldAccessorDefinitionHas(const map<string, string>* variables, io::Printer* printer);

	  // Generate code for Clear_$name$
	  void GenerateFieldAccessorDefinitionClear(const map<string, string>* variables, const FieldDescriptor* field, io::Printer* printer);

	  // Helper function to GenerateSerializeWithCachedSizes
	  void GenerateSerializeOneField(io::Printer* printer, const FieldDescriptor* field);

	  // Generate shared finalization code.
	  void GenerateFinalize(io::Printer* printer);

	  const Descriptor* descriptor_;
	  string ada_package_name_;
	  string ada_package_type_;
	  FieldGeneratorMap field_generators_;
	  set<string> package_dependencies_;
	  set<string> enum_package_dependencies_;

	  GOOGLE_DISALLOW_EVIL_CONSTRUCTORS(MessageGenerator);
	};

      } // namespace ada
    } // namespace compiler
  } // namespace protobuf
} // namespace google

#endif // GOOGLE_PROTOBUF_COMPILER_ADA_MESSAGE_H__

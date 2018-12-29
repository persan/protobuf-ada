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



#ifndef GOOGLE_PROTOBUF_COMPILER_ADA_HELPERS_H__
#define GOOGLE_PROTOBUF_COMPILER_ADA_HELPERS_H__

#include <string>
#include <google/protobuf/descriptor.pb.h>
#include <google/protobuf/descriptor.h>

namespace google {
namespace protobuf {
namespace compiler {
namespace ada {

enum AdaType {
  ADATYPE_INT32,
  ADATYPE_INT64,
  ADATYPE_UINT32,
  ADATYPE_UINT64,
  ADATYPE_FLOAT,
  ADATYPE_DOUBLE,
  ADATYPE_BOOL,
  ADATYPE_STRING,
  ADATYPE_BYTES,
  ADATYPE_ENUM,
  ADATYPE_GROUP,
  ADATYPE_MESSAGE
};

FieldDescriptor::Type GetType(const FieldDescriptor* field);

AdaType GetAdaType(const FieldDescriptor* field);

// Returns the scope where the field was defined (for extensions, this is
// different from the message type to which the field applies).
inline const Descriptor* FieldScope(const FieldDescriptor* field) {
  return field->is_extension() ?
    field->extension_scope() : field->containing_type();
}

// Get the (unqualified) name that should be used for this field in Ada code.
string FieldName(const FieldDescriptor* field);

// Get the message type name that should be used for this message field.
string FieldMessageTypeName(const FieldDescriptor* field);


// Get the containing message type name that should be used for this message 
// field.
string FieldMessageContainingPackageName(const FieldDescriptor* field);

// Get the containing message type name that should be used for this enum
// field.
string FieldEnumContainingPackageName(const EnumDescriptor* descriptor);

// Strips ".proto" or ".protodevel" from the end of a filename.
string StripProto(const string& filename);

// Gets the unqualified package name for the file.
string FileAdaPackageName(const FileDescriptor* file);

// TODO: rename!
bool IsParentMessage(const Descriptor* parent_descriptor, 
  const Descriptor* child_descriptor);

// TODO: commment!
string AdaPackageTypeName(const Descriptor* descriptor);
string AdaPackageName(const Descriptor* descriptor);
string EnumTypeName(const EnumDescriptor* enum_descriptor, bool qualified);
string EnumDefinitionTypeName(const EnumDescriptor* enum_descriptor);
string EnumDefinitionPackageName(const EnumDescriptor* enum_descriptor);

// Converts the field's name to capitalized underscore, e.g. "foo_bar_baz"
// becomes "Foo_Bar_Baz"
string UnderscoresToCapitalizedUnderscores(const FieldDescriptor* field);

// Get code that evaluates to the field's default value.
string DefaultValue(const FieldDescriptor* field);

// Takes a type as parameter and returns the type's primitive operation name
// (suffix).
const char* DeclaredTypePrimitiveOperationName(FieldDescriptor::Type type);

}  // namespace ada
}  // namespace compiler
}  // namespace protobuf
}  // namespace google
#endif  // GOOGLE_PROTOBUF_COMPILER_ADA_HELPERS_H__

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

#include <set>
#include <map>

#include <ada_enum.h>
#include <ada_helpers.h>
#include <google/protobuf/io/printer.h>
#include <strutil.h>
#include <algorithm>

namespace google {
  namespace protobuf {
    namespace compiler {
      namespace ada {

	namespace {

	  struct EnumConstantOrderingByValue {

	    inline bool operator()(const EnumValueDescriptor* a,
				   const EnumValueDescriptor * b) const {
	      return a->number() < b->number();
	    }
	  };

	  // Sort the fields of the given EnumDescriptor by value into a new[]'d array
	  // and return it.

	  const EnumValueDescriptor** SortEnumConstantsByValue(const EnumDescriptor* enum_descriptor) {
	    const EnumValueDescriptor** enum_constant =
	    new const EnumValueDescriptor*[enum_descriptor->value_count()];
	    for (int i = 0; i < enum_descriptor->value_count(); i++) {
	      enum_constant[i] = enum_descriptor->value(i);
	    }
	    std::sort(enum_constant, enum_constant + enum_descriptor->value_count(),
		      EnumConstantOrderingByValue());
	    return enum_constant;
	  }

	}

	EnumGenerator::EnumGenerator(const EnumDescriptor* descriptor)
	: descriptor_(descriptor) { }

	EnumGenerator::~EnumGenerator() { }

	void EnumGenerator::GenerateDefinition(io::Printer* printer) {
	  // Ada requires that enumeration constant values are defined in an ascending
	  // order. We must therefore sort enumeration constants by value.
	  scoped_array<const EnumValueDescriptor*> ordered_values(
								  SortEnumConstantsByValue(descriptor_));

	  printer->Print(
			 "type $name$ is (", "name", descriptor_->name());
	  for (int i = 0; i < descriptor_->value_count(); i++) {
	    printer->Print(
			   "$literal$", "literal", ordered_values[i]->name());

	    // More enumeration literals follow?
	    if (i != descriptor_->value_count() - 1) {
	      printer->Print(", ");
	    }
	  }
	  printer->Print(");\n");
	  printer->Print("for $name$'Size use 32;\n", "name", EnumTypeName(descriptor_, false));

	  printer->Print("for $name$ use (", "name", descriptor_->name());
	  for (int i = 0; i < descriptor_->value_count(); i++) {
	    printer->Print("$constant$ => $value$",
			   "constant", ordered_values[i]->name(),
			   "value", SimpleItoa(ordered_values[i]->number()));

	    // More constants follow?
	    if (i != descriptor_->value_count() - 1) {
	      printer->Print(", ");
	    }
	  }
	  printer->Print(");\n");
	  printer->Print(
			 "function Enumeration_To_PB_Int32 is new Ada.Unchecked_Conversion "
			 "($name$, Protocol_Buffers.Wire_Format.PB_Int32);\n",
			 "name", EnumTypeName(descriptor_, false));
	  printer->Print(
			 "function PB_Int32_To_Enumeration is new Ada.Unchecked_Conversion "
			 "(Protocol_Buffers.Wire_Format.PB_Int32, $name$);\n",
			 "name", EnumTypeName(descriptor_, false));
	}


      } // namespace ada
    } // namespace compiler
  } // namespace protobuf
} // namespace google

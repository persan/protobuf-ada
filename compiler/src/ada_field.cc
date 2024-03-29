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
#include <ada_enum_field.h>
#include <ada_message_field.h>
#include <ada_string_field.h>
#include <ada_field.h>
#include <ada_helpers.h>
#include <google/protobuf/wire_format.h>
#include <strutil.h>

namespace google {
  namespace protobuf {
    namespace compiler {
      namespace ada {

	// =========================================================================================
	void SetCommonFieldVariables(const FieldDescriptor* descriptor,
				     map<string, string>* variables) {
	  (*variables)["name"] = FieldName(descriptor);
	  (*variables)["index"] = SimpleItoa(descriptor->index());
	  (*variables)["number"] = SimpleItoa(descriptor->number());
	  (*variables)["packagename"] = AdaPackageName(FieldScope(descriptor));
	  (*variables)["declared_type"] = DeclaredTypePrimitiveOperationName(descriptor->type());
	  (*variables)["tag_size"] = SimpleItoa(internal::WireFormat::TagSize(descriptor->number(), descriptor->type()));
	}

	// =========================================================================================
	FieldGenerator::~FieldGenerator() {}


	// =========================================================================================
	FieldGeneratorMap::FieldGeneratorMap(const Descriptor* descriptor)
	: descriptor_(descriptor),
      field_generators_(new boost::scoped_ptr<FieldGenerator>[descriptor->field_count()]) {
	  // Construct all the FieldGenerators.
	  for (int i = 0; i < descriptor->field_count(); i++) {
	    field_generators_[i].reset(MakeGenerator(descriptor->field(i)));
	  }
	}

	// =========================================================================================
	void FieldGenerator::GenerateMergeFromCodedInputStreamWithPacking(io::Printer* printer) const {
	  // Reaching here indicates a bug. Cases are:
	  //   - This FieldGenerator should support packing, but this method should be
	  //     overridden.
	  //   - This FieldGenerator doesn't support packing, and this method should
	  //     never have been called.
	  GOOGLE_LOG(FATAL) << "GenerateMergeFromCodedStreamWithPacking() "
	  << "called on field generator that does not support packing.";

	}

	// =========================================================================================
	FieldGenerator* FieldGeneratorMap::MakeGenerator(const FieldDescriptor* field) {
	  if (field->is_repeated()) {
	    switch (GetAdaType(field)) {
	      case ADATYPE_MESSAGE:
		return new RepeatedMessageFieldGenerator(field);
	      case ADATYPE_ENUM:
		return new RepeatedEnumFieldGenerator(field);
	      case ADATYPE_STRING:
		return new RepeatedStringFieldGenerator(field);
	      default:
		return new RepeatedPrimitiveFieldGenerator(field);
	    }
	  } else {
	    switch (GetAdaType(field)) {
	      case ADATYPE_MESSAGE:
		return new MessageFieldGenerator(field);
	      case ADATYPE_ENUM:
		return new EnumFieldGenerator(field);
	      case ADATYPE_STRING:
		return new StringFieldGenerator(field);
	      default:
		return new PrimitiveFieldGenerator(field);
	    }
	  }
	}

	// =========================================================================================
	FieldGeneratorMap::~FieldGeneratorMap() {}

	// =========================================================================================
	const FieldGenerator& FieldGeneratorMap::get(const FieldDescriptor* field) const {
	  GOOGLE_CHECK_EQ(field->containing_type(), descriptor_);
	  return *field_generators_[field->index()];
	}

      } // namespace ada
    } // namespace compiler
  } // namespace protobuf
} // namespace google

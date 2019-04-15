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

#ifndef GOOGLE_PROTOBUF_COMPILER_ADA_FILE_H__
#define GOOGLE_PROTOBUF_COMPILER_ADA_FILE_H__

#include <vector>
#include <string>

#include <google/protobuf/stubs/common.h>

namespace google {
  namespace protobuf {
    class FileDescriptor; // descriptor.h
    class Descriptor; // descriptor.h
    namespace io {
      class Printer; // printer.h
    }
    namespace compiler {
      class GeneratorContext; // code_generator.h
    }
  }

  namespace protobuf {
    namespace compiler {
      namespace ada {

	class FileGenerator {
	  public:
	  explicit FileGenerator(const FileDescriptor* file);
	  ~FileGenerator();

	  void GenerateSpecification(io::Printer* printer);
	  void GenerateBody(io::Printer* printer);
	  void GenerateChildPackages(const string& package_dir,
				     const string& parent,
				     GeneratorContext* context,
				     vector<string>* file_list);

	  const string& packagename() {
	    return ada_package_name_;
	  }
	  private:
	  void GenerateNestedEnumerationPackages(io::Printer* printer,
						 const Descriptor* descriptor);

	  const FileDescriptor* file_;
	  string ada_package_name_;

	  GOOGLE_DISALLOW_EVIL_CONSTRUCTORS(FileGenerator);
	};
      } // namespace ada
    } // namespace compiler
  } // namespace protobuf
} // namespace google

#endif // GOOGLE_PROTOBUF_COMPILER_ADA_FILE_H__

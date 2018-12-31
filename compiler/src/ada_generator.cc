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

#include <ada_generator.h>

#include <vector>
#include <utility>

#include <ada_file.h>
#include <ada_helpers.h>
#include <google/protobuf/descriptor.pb.h>
#include <google/protobuf/io/printer.h>
#include <google/protobuf/io/zero_copy_stream.h>
#include <strutil.h>

namespace google {
  namespace protobuf {
    namespace compiler {
      namespace ada {

	AdaGenerator::
	AdaGenerator() { }

	AdaGenerator::
	~AdaGenerator() { }

	bool AdaGenerator::
	Generate(const FileDescriptor* file,
		 const string& parameter,
		 GeneratorContext* context,
		 string* error) const {

	  // -----------------------------------------------------------------
	  // parse generator options

	  // Name a file where we will write a list of generated file names, one
	  // per line.
	  string output_list_file;

	  vector<pair<string, string> > options;
	  ParseGeneratorParameter(parameter, &options);

	  for (unsigned int i = 0; i < options.size(); i++) {
	    if (options[i].first == "output_list_file") {
	      output_list_file = options[i].second;
	    } else {
	      *error = "Unknown generator option: " + options[i].first;
	      return false;
	    }
	  }

	  // -----------------------------------------------------------------

	  FileGenerator file_generator(file);

	  vector<string> all_files;
	  string ada_filename = file_generator.packagename() + ".ads";
	  LowerString(&ada_filename);
	  all_files.push_back(ada_filename);

	  // Generate specification for parent ada file
	  scoped_ptr<io::ZeroCopyOutputStream> output(
						      context->Open(ada_filename));
	  io::Printer printer(output.get(), '$');
	  file_generator.GenerateSpecification(&printer);

	  // Generate child package for every message
	  file_generator.GenerateChildPackages("",
					       file_generator.packagename(), context, &all_files);

	  // Generate output list if requested.
	  if (!output_list_file.empty()) {
	    // Generate output list.  This is just a simple text file placed in a
	    // deterministic location which lists the ada files being generated.
	    scoped_ptr<io::ZeroCopyOutputStream> srclist_raw_output(
								    context->Open(output_list_file));
	    io::Printer srclist_printer(srclist_raw_output.get(), '$');
	    for (unsigned int i = 0; i < all_files.size(); i++) {
	      srclist_printer.Print("$filename$\n", "filename", all_files[i]);
	    }
	  }

	  return true;
	}



      } // namespace ada
    } // namespace compiler
  } // namespace protobuf
} // namespace google

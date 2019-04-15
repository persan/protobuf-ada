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

#include <ada_file.h>
#include <ada_helpers.h>
#include <ada_message.h>
#include <ada_enum.h>
#include <google/protobuf/descriptor.pb.h>
#include <google/protobuf/io/printer.h>
#include <strutil.h>
#include <google/protobuf/io/zero_copy_stream.h>
#include <google/protobuf/compiler/code_generator.h>

namespace google {
  namespace protobuf {
    namespace compiler {
      namespace ada {

	FileGenerator::
	FileGenerator(const FileDescriptor* file) : file_(file), ada_package_name_(FileAdaPackageName(file)) {}

	FileGenerator::
	~FileGenerator() { }

	void FileGenerator::GenerateSpecification(io::Printer* printer) {
	  printer->Print("--  begin read only\n"
			 "--  Generated by the protocol buffer compiler. DO NOT EDIT!\n"
			 "--  source: $filename$\n"
			 "--  \n"
			 "--  ----------------------------------------------------------------------\n"
			 "pragma Warnings (Off);\n"
			 "pragma Ada_2012;\n",
			 "filename", file_->name());

	  if (file_->message_type_count() > 0) {
	    printer->Print("with Google.Protobuf.Message;\n"
			   "with Google.Protobuf.Wire_Format;\n"
			   "with Google.Protobuf.IO.Coded_Output_Stream;\n"
			   "with Google.Protobuf.IO.Coded_Input_Stream;\n"
			   "with Google.Protobuf.Generated_Message_Utilities;\n"
			   "with Ada.Streams.Stream_IO;\n"
			   "with Ada.Containers.Vectors;\n"
			   "with Ada.Unchecked_Conversion;\n"
			   "with Ada.Unchecked_Deallocation;\n"
			   "\n");
	  }

	  printer->Print("package $ada_package_name$ is\n",
			 "ada_package_name", ada_package_name_);

	  printer->Indent();

	  printer->Print("use type Google.Protobuf.Wire_Format.PB_String;\n"
			 "use type Google.Protobuf.Wire_Format.PB_Byte;\n"
			 "use type Google.Protobuf.Wire_Format.PB_UInt32;\n"
			 "use type Google.Protobuf.Wire_Format.PB_UInt64;\n"
			 "use type Google.Protobuf.Wire_Format.PB_Double;\n"
			 "use type Google.Protobuf.Wire_Format.PB_Float;\n"
			 "use type Google.Protobuf.Wire_Format.PB_Bool;\n"
			 "use type Google.Protobuf.Wire_Format.PB_Int32;\n"
			 "use type Google.Protobuf.Wire_Format.PB_Int64;\n"
			 "use type Google.Protobuf.Wire_Format.PB_Field_Type;\n"
			 "use type Google.Protobuf.Wire_Format.PB_Wire_Type;\n"
			 "use type Google.Protobuf.Wire_Format.PB_Object_Size;\n"
			 "use type Google.Protobuf.Wire_Format.PB_String_Access;\n"
			 "\n");

	  for (int i = 0; i < file_->enum_type_count(); i++) {
	    printer->Print("\n");
	    EnumGenerator enumGenerator(file_->enum_type(i));
	    enumGenerator.GenerateDefinition(printer);
	    printer->Print("\n");
	  }

	  printer->Print("package Enumeration is\n");
	  printer->Indent();

	  for (int i = 0; i < file_->message_type_count(); i++) {
	    GenerateNestedEnumerationPackages(printer, file_->message_type(i));
	  }

	  printer->Outdent();
	  printer->Print("end Enumeration;\n");

	  printer->Outdent();

	  printer->Print("end $ada_package_name$;\n"
			 "--  end  " "read only\n",
			 "ada_package_name", ada_package_name_);
	}

	// ===============================================================================================
	void FileGenerator::GenerateBody(io::Printer* printer) {
	  printer->Print("--  begin " "read only\n"
			 "--  Generated by the protocol buffer compiler. DO NOT EDIT!\n"
			 "--  source: $filename$\n\n"
			 "--\n"
			 "--  ---------------------------------------------------------------------\n"
			 "pragma Warnings (Off);\n"
			 "pragma Ada_2012;\n"
			 "with Ada.Unchecked_Deallocation;\n\n",
			 "filename", file_->name());

	  printer->Print("package body $ada_package_name$ is\n",
			 "ada_package_name", ada_package_name_);

	  printer->Print("end $ada_package_name$;\n"
			 "--  end " "read only\n",
			 "ada_package_name", ada_package_name_);	}

	// ===============================================================================================
	void FileGenerator::GenerateNestedEnumerationPackages(io::Printer* printer, const Descriptor* descriptor) {

	  //This will generate empty packages if no enum types are found in any of the
	  //subpackages/messages
	  printer->Print("package $package$ is\n",
			 "package", AdaPackageTypeName(descriptor));
	  printer->Indent();

	  for (int i = 0; i < descriptor->enum_type_count(); i++) {
	    printer->Print("\n");
	    EnumGenerator enumGenerator(descriptor->enum_type(i));
	    enumGenerator.GenerateDefinition(printer);
	    printer->Print("\n");
	  }

	  for (int i = 0; i < descriptor->nested_type_count(); i++) {
	    const Descriptor* message = descriptor->nested_type(i);
	    GenerateNestedEnumerationPackages(printer, message);
	  }

	  printer->Outdent();
	  printer->Print("end $package$;\n",
			 "package", AdaPackageTypeName(descriptor));
	}

	template<typename GeneratorClass, typename DescriptorClass>
	static void GenerateChildPackages(const string& package_dir,
					  const DescriptorClass* descriptor,
					  GeneratorContext* context,
					  vector<string>* file_list,
					  const string& name_suffix,
					  const string& file_suffix,
					  const string& ada_package,
					  void (GeneratorClass::*pfn)(io::Printer* printer)) {


	  string filename = ada_package;
	  StripString(&filename, ".", '-');

	  filename = package_dir + filename + name_suffix + file_suffix;

	  LowerString(&filename);
	  file_list->push_back(filename);

	  scoped_ptr<io::ZeroCopyOutputStream> output(context->Open(filename));
	  io::Printer printer(output.get(), '$');

	  printer.Print("--  begin read only\n"
			"--  Generated by the protocol buffer compiler. DO NOT EDIT!\n"
			"--  source: $filename$\n"
			"--  \n"
			"--  ----------------------------------------------------------------------\n"
			"pragma Warnings (Off);\n"
			"pragma Ada_2012;\n",
			"filename", descriptor->file()->name());

	  if (descriptor->file()->message_type_count() > 0) {
	    printer.Print("with Google.Protobuf.Message;\n"
			  "with Google.Protobuf.Wire_Format;\n"
			  "with Google.Protobuf.IO.Coded_Output_Stream;\n"
			  "with Google.Protobuf.IO.Coded_Input_Stream;\n"
			  "with Google.Protobuf.Generated_Message_Utilities;\n"
			  "with Ada.Streams.Stream_IO;\n"
			  "with Ada.Containers.Vectors;\n"
			  "with Ada.Unchecked_Conversion;\n"
			  "with Ada.Unchecked_Deallocation;\n"
			  "with Interfaces;\n\n");
	  }

	  GeneratorClass generator(descriptor, ada_package);
	  (generator.*pfn)(&printer);
	}
	//  =========================================================================
	void GenerateChildPackagesHelper(const string& package_dir,
					 const string& parent,
					 GeneratorContext* context,
					 vector<string>* file_list,
					 const Descriptor* descriptor) {
	  string ada_package = AdaPackageFullName(descriptor);
	  GenerateChildPackages<MessageGenerator > (package_dir,
						    descriptor,
						    context, file_list, "", ".ads", ada_package,
						    &MessageGenerator::GenerateSpecification);
	  GenerateChildPackages<MessageGenerator > (package_dir,
						    descriptor,
						    context, file_list, "", ".adb", ada_package,
						    &MessageGenerator::GenerateBody);

	  for (int i = 0; i < descriptor->nested_type_count(); i++) {
	    const Descriptor* message = descriptor->nested_type(i);
	    GenerateChildPackagesHelper(package_dir, parent, context, file_list, message);
	  }
	}

	void FileGenerator::GenerateChildPackages(const string& package_dir,
						  const string& parent,
						  GeneratorContext* context,
						  vector<string>* file_list) {
	  for (int i = 0; i < file_->message_type_count(); i++) {
	    GenerateChildPackagesHelper(package_dir, parent, context, file_list,
					file_->message_type(i));
	  }

	}


      } // namespace ada
    } // namespace compiler
  } // namespace protobuf
} // namespace google

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

#include <limits>
#include <google/protobuf/stubs/hash.h>

#include <ada_helpers.h>
#include <strutil.h>
#include <float.h>
#include <errno.h>
#include <stdio.h>

#ifdef _WIN32
// MSVC has only _snprintf, not snprintf.
//
// MinGW has both snprintf and _snprintf, but they appear to be different
// functions.  The former is buggy.  When invoked like so:
//   char buffer[32];
//   snprintf(buffer, 32, "%.*g\n", FLT_DIG, 1.23e10f);
// it prints "1.23000e+10".  This is plainly wrong:  %g should never print
// trailing zeros after the decimal point.  For some reason this bug only
// occurs with some input values, not all.  In any case, _snprintf does the
// right thing, so we use it.
#define snprintf _snprintf
#endif

namespace google {
  namespace protobuf {
    namespace compiler {
      namespace ada {

	namespace {

	  const char* const kKeywordList[] = {"abort", "else", "new", "return", "abs", "elsif", "not", "reverse",
					      "abstract", "end", "null", "accept", "entry", "select", "access", "exception",
					      "of", "separate", "aliased", "exit", "or", "some", "all", "others", "subtype",
					      "and", "for", "out", "synchronized", "array", "function", "overriding", "at",
					      "tagged", "generic", "package", "task", "begin", "goto", "pragma",
					      "terminate", "body", "private", "then", "if", "type", "case", "in",
					      "protected", "constant", "interface", "until", "is", "raise", "use",
					      "declare", "range", "delay","limited", "record", "when", "delta", "loop",
					      "rem", "while", "digits", "renames", "with", "do", "mod", "requeue", "xor"
	  };

	  // =========================================================================================
	  hash_set<string> MakeKeywordsMap() {
	    hash_set<string> result;
	    for (long unsigned i = 0; i < GOOGLE_ARRAYSIZE(kKeywordList); i++) {
	      result.insert(kKeywordList[i]);
	    }
	    return result;
	  }

	  hash_set<string> kKeywords = MakeKeywordsMap();

	  // =========================================================================================
	  string UnderscoresToCapitalizedUnderscoresImpl(const string& input) {
	    string result;
	    bool cap_next_letter = true;
	    // Note:  I distrust ctype.h due to locales.
	    for (long unsigned i = 0; i < input.size(); i++) {
	      if ('a' <= input[i] && input[i] <= 'z') {
		if (cap_next_letter) {
		  result += input[i] + ('A' - 'a');
		} else {
		  result += input[i];
		}
		cap_next_letter = false;
	      } else if ('A' <= input[i] && input[i] <= 'Z') {
		// Capital letters are left as-is.
		result += input[i];
		cap_next_letter = false;
	      } else {
		result += input[i];
		cap_next_letter = true;
	      }
	    }
	    return result;
	  }

	  // =========================================================================================
	  int AdaEscapeInternal(const char* src, int src_len, char* dest,
				int dest_len) {
	    const char* src_end = src + src_len;
	    int used = 0;

	    for (; src < src_end; src++) {
	      if (dest_len - used < 30) // Need extra space for special characters
		return -1;

	      if (*src == '\"') {
		dest[used++] = '\"';
		dest[used++] = '\"';
	      } else {
		if (static_cast<uint8> (*src) < 0x80 && !isprint(*src)) {
		  sprintf(dest + used, "\" & Character'Val (16#%02x#) & \"",
			  static_cast<uint8> (*src));
		  used += 30;
		} else {
		  dest[used++] = *src;
		}
	      }
	    }

	    if (dest_len - used < 1) // make sure that there is room for \0
	      return -1;

	    dest[used] = '\0'; // doesn't count towards return value though
	    return used;
	  }

	  // =========================================================================================
	  string Basename(const FileDescriptor* file) {
	    string basename;
	    string::size_type last_slash = file->name().find_last_of('/');
	    if (last_slash == string::npos) {
	      basename = file->name();
	    } else {
	      basename = file->name().substr(last_slash + 1);
	    }
	    return basename;
	  }

	  // -----------------------------------------------------------------------------
	  // The following functions are modified copies from strutil.cc. for more
	  // information about these functions see google/protobuf/stubs/strutil.cc and
	  // google/protobuf/stubs/strutil.h.
	  //
	  // Ada unfortunately provides no way of specifying the type of a literal instead
	  // it infers if a literal is a floating point literal from the presence of a
	  // decimal point. SimpleDtoa and SimpleFtoa must therefore be modified to always
	  // write a decimal point (SimpleDtoaDecimal and SimpleFtoaDecimal). The easiest
	  // way of doing this, according to my knowledge, is by using the flag '#' to
	  // ensure that the output contains a decimal point. It does affect the
	  // readability and length so it isn't a perfect solution. The maximum length of
	  // the numbers character representation _should_ not be affected.

	  // =========================================================================================
	  inline bool IsNaN(double value) {
	    // NaN is never equal to anything, even itself.
	    return value != value;
	  }

	  // =========================================================================================
	  static inline bool IsValidFloatChar(char c) {
	    return ('0' <= c && c <= '9') ||
	    c == 'e' || c == 'E' ||
	    c == '+' || c == '-';
	  }

	  // =========================================================================================
	  void DelocalizeRadix(char* buffer) {
	    // Fast check:  if the buffer has a normal decimal point, assume no
	    // translation is needed.
	    if (strchr(buffer, '.') != NULL) return;

	    // Find the first unknown character.
	    while (IsValidFloatChar(*buffer)) ++buffer;

	    if (*buffer == '\0') {
	      // No radix character found.
	      return;
	    }

	    // We are now pointing at the locale-specific radix character.  Replace it
	    // with '.'.
	    *buffer = '.';
	    ++buffer;

	    if (!IsValidFloatChar(*buffer) && *buffer != '\0') {
	      // It appears the radix was a multi-byte character.  We need to remove the
	      // extra bytes.
	      char* target = buffer;
	      do {
		++buffer;
	      } while (!IsValidFloatChar(*buffer) && *buffer != '\0');
	      memmove(target, buffer, strlen(buffer) + 1);
	    }
	  }

	  // =========================================================================================
	  bool safe_strtof(const char* str, float* value) {
	    char* endptr;
	    errno = 0; // errno only gets set on errors
#if defined(_WIN32) || defined (__hpux)  // has no strtof()
	    *value = strtod(str, &endptr);
#else
	    *value = strtof(str, &endptr);
#endif
	    return *str != 0 && *endptr == 0 && errno == 0;
	  }

	  char* DoubleToBufferDecimal(double value, char* buffer) {
	    // DBL_DIG is 15 for IEEE-754 doubles, which are used on almost all
	    // platforms these days.  Just in case some system exists where DBL_DIG
	    // is significantly larger -- and risks overflowing our buffer -- we have
	    // this assert.
	    GOOGLE_COMPILE_ASSERT(DBL_DIG < 20, DBL_DIG_is_too_big);

	    if (value == numeric_limits<double>::infinity()) {
	      strcpy(buffer, "inf");
	      return buffer;
	    } else if (value == -numeric_limits<double>::infinity()) {
	      strcpy(buffer, "-inf");
	      return buffer;
	    } else if (IsNaN(value)) {
	      strcpy(buffer, "nan");
	      return buffer;
	    }

	    int snprintf_result =
	    snprintf(buffer, kDoubleToBufferSize, "%#.*g", DBL_DIG, value);

	    // The snprintf should never overflow because the buffer is significantly
	    // larger than the precision we asked for.
	    GOOGLE_DCHECK(snprintf_result > 0 && snprintf_result < kDoubleToBufferSize);

	    // We need to make parsed_value volatile in order to force the compiler to
	    // write it out to the stack.  Otherwise, it may keep the value in a
	    // register, and if it does that, it may keep it as a long double instead
	    // of a double.  This long double may have extra bits that make it compare
	    // unequal to "value" even though it would be exactly equal if it were
	    // truncated to a double.
	    volatile double parsed_value = strtod(buffer, NULL);
	    if (parsed_value != value) {
	      int snprintf_result =
	      snprintf(buffer, kDoubleToBufferSize, "%#.*g", DBL_DIG + 2, value);

	      // Should never overflow; see above.
	      GOOGLE_DCHECK(snprintf_result > 0 && snprintf_result < kDoubleToBufferSize);
	    }

	    DelocalizeRadix(buffer);
	    return buffer;
	  }

	  char* FloatToBufferDecimal(float value, char* buffer) {
	    // FLT_DIG is 6 for IEEE-754 floats, which are used on almost all
	    // platforms these days.  Just in case some system exists where FLT_DIG
	    // is significantly larger -- and risks overflowing our buffer -- we have
	    // this assert.
	    GOOGLE_COMPILE_ASSERT(FLT_DIG < 10, FLT_DIG_is_too_big);

	    if (value == numeric_limits<double>::infinity()) {
	      strcpy(buffer, "inf");
	      return buffer;
	    } else if (value == -numeric_limits<double>::infinity()) {
	      strcpy(buffer, "-inf");
	      return buffer;
	    } else if (IsNaN(value)) {
	      strcpy(buffer, "nan");
	      return buffer;
	    }

	    int snprintf_result =
	    snprintf(buffer, kFloatToBufferSize, "%#.*g", FLT_DIG, value);

	    // The snprintf should never overflow because the buffer is significantly
	    // larger than the precision we asked for.
	    GOOGLE_DCHECK(snprintf_result > 0 && snprintf_result < kFloatToBufferSize);

	    float parsed_value;
	    if (!safe_strtof(buffer, &parsed_value) || parsed_value != value) {
	      int snprintf_result =
	      snprintf(buffer, kFloatToBufferSize, "%#.*g", FLT_DIG + 2, value);

	      // Should never overflow; see above.
	      GOOGLE_DCHECK(snprintf_result > 0 && snprintf_result < kFloatToBufferSize);
	    }

	    DelocalizeRadix(buffer);
	    return buffer;
	  }

	  // =========================================================================================
	  string SimpleDtoaDecimal(double value) {
	    char buffer[kDoubleToBufferSize];
	    return DoubleToBufferDecimal(value, buffer);
	  }

	  // =========================================================================================
	  string SimpleFtoaDecimal(float value) {
	    char buffer[kFloatToBufferSize];
	    return FloatToBufferDecimal(value, buffer);
	  }

	  // -----------------------------------------------------------------------------


	} // namespace

	// Escape non-printing characters.
	string AdaEscape(const string& src) {
	  const int dest_length = src.size() * 30 + 1; // Maximum possible expansion
	  scoped_array<char> dest(new char[dest_length]);
	  const int len = AdaEscapeInternal(src.data(), src.size(),
					    dest.get(), dest_length);
	  GOOGLE_DCHECK_GE(len, 0);
	  return string(dest.get(), len);
	}

	// Get the (unqualified) name that should be used for this field in Ada code.
	string FieldName(const FieldDescriptor* field) {
	  string result = field->name();
	  LowerString(&result);
	  if (kKeywords.count(result) > 0) {
	    result.append("_pb");
	  }
	  return UnderscoresToCapitalizedUnderscoresImpl(result);
	}

	string FieldMessageTypeName(const FieldDescriptor* field) {
	  return UnderscoresToCapitalizedUnderscoresImpl(
							 field->message_type()->name());
	}

	string FieldMessageContainingPackageName(const FieldDescriptor* field) {
	  return UnderscoresToCapitalizedUnderscoresImpl(AdaPackageFullName(field->message_type()));
	}

	string FieldEnumContainingPackageName(const EnumDescriptor* descriptor) {
	  string basename = Basename(descriptor->file());
	  string base_package = UnderscoresToCapitalizedUnderscoresImpl(StripProto(basename));
	  if (descriptor->containing_type() == NULL) {
	    return descriptor->file()->package();
	  }
	  return AdaPackageName(descriptor->containing_type());
	}


	string StripProto(const string& filename) {
	  if (HasSuffixString(filename, ".protodevel")) {
	    return StripSuffixString(filename, ".protodevel");
	  } else {
	    return StripSuffixString(filename, ".proto");
	  }
	}

	string FileAdaPackageName(const FileDescriptor* file) {
	  return UnderscoresToCapitalizedUnderscoresImpl(file->package());
	}

	string UnderscoresToCapitalizedUnderscores(const FieldDescriptor* field) {
	  return UnderscoresToCapitalizedUnderscoresImpl(FieldName(field));
	}

	FieldDescriptor::Type GetType(const FieldDescriptor* field) {
	  return field->type();
	}

	AdaType GetAdaType(const FieldDescriptor* field) {
	  switch (GetType(field)) {
	    case FieldDescriptor::TYPE_INT32: return ADATYPE_INT32;
	    case FieldDescriptor::TYPE_UINT32: return ADATYPE_UINT32;
	    case FieldDescriptor::TYPE_SINT32: return ADATYPE_INT32;
	    case FieldDescriptor::TYPE_FIXED32: return ADATYPE_UINT32;
	    case FieldDescriptor::TYPE_SFIXED32: return ADATYPE_INT32;
	    case FieldDescriptor::TYPE_INT64: return ADATYPE_INT64;
	    case FieldDescriptor::TYPE_UINT64: return ADATYPE_UINT64;
	    case FieldDescriptor::TYPE_SINT64: return ADATYPE_INT64;
	    case FieldDescriptor::TYPE_FIXED64: return ADATYPE_UINT64;
	    case FieldDescriptor::TYPE_SFIXED64: return ADATYPE_INT64;
	    case FieldDescriptor::TYPE_FLOAT: return ADATYPE_FLOAT;
	    case FieldDescriptor::TYPE_DOUBLE: return ADATYPE_DOUBLE;
	    case FieldDescriptor::TYPE_BOOL: return ADATYPE_BOOL;
	    case FieldDescriptor::TYPE_STRING: return ADATYPE_STRING;
	    case FieldDescriptor::TYPE_BYTES: return ADATYPE_STRING;
	    case FieldDescriptor::TYPE_ENUM: return ADATYPE_ENUM;
	    case FieldDescriptor::TYPE_GROUP: return ADATYPE_GROUP;
	    case FieldDescriptor::TYPE_MESSAGE: return ADATYPE_MESSAGE;


	      // No default because we want the compiler to complain if any new
	      // types are added.
	  }

	  GOOGLE_LOG(FATAL) << "Can't get here.";
	  return ADATYPE_INT32;
	}

	string DefaultValue(const FieldDescriptor* field) {
	  switch (field->cpp_type()) {
	    case FieldDescriptor::CPPTYPE_BOOL:
	      return field->default_value_bool() ? "True" : "False";
	    case FieldDescriptor::CPPTYPE_INT32:
	      return SimpleItoa(field->default_value_int32());
	    case FieldDescriptor::CPPTYPE_UINT32:
	      return SimpleItoa(field->default_value_uint32());
	    case FieldDescriptor::CPPTYPE_INT64:
	      return SimpleItoa(field->default_value_int64());
	    case FieldDescriptor::CPPTYPE_UINT64:
	      return SimpleItoa(field->default_value_uint64());
	    case FieldDescriptor::CPPTYPE_DOUBLE:
	      {
		double value = field->default_value_double();
		if (value == numeric_limits<double>::infinity()) {
		  return "Google.Protobuf.Generated_Message_Utilities.Positive_Infinity";
		} else if (value == -numeric_limits<double>::infinity()) {
		  return "Google.Protobuf.Generated_Message_Utilities.Negative_Infinity";
		} else if (value != value) {
		  return "Google.Protobuf.Generated_Message_Utilities.NaN";
		} else {
		  return "Google.Protobuf.Wire_Format.PB_Double (" +
		  SimpleDtoaDecimal(value) + ")";
		}
	      }
	    case FieldDescriptor::CPPTYPE_FLOAT:
	      {
		float value = field->default_value_float();
		if (value == numeric_limits<float>::infinity()) {
		  return "Google.Protobuf.Generated_Message_Utilities.Positive_Infinity";
		} else if (value == -numeric_limits<float>::infinity()) {
		  return "Google.Protobuf.Generated_Message_Utilities.Negative_Infinity";
		} else if (value != value) {
		  return "Google.Protobuf.Generated_Message_Utilities.NaN";
		} else {
		  return "Google.Protobuf.Wire_Format.PB_Float (" +
		  SimpleFtoaDecimal(value) + ")";
		}
	      }
	    case FieldDescriptor::CPPTYPE_STRING:
	      return "\"" +
	      AdaEscape(field->default_value_string()) +
	      "\"";
	    case FieldDescriptor::CPPTYPE_ENUM:
	    case FieldDescriptor::CPPTYPE_MESSAGE:
	      return "";
	      // No default because we want the compiler to complain if any new
	      // types are added.
	  }

	  GOOGLE_LOG(FATAL) << "Can't get here.";
	  return "";
	}

	string AdaPackageTypeName(const Descriptor* descriptor) {
	  return UnderscoresToCapitalizedUnderscoresImpl(descriptor->name());
	}

	string AdaPackageFullName(const Descriptor* descriptor) {
	  return UnderscoresToCapitalizedUnderscoresImpl(descriptor->full_name());
	}


	string AdaPackageName(const Descriptor* descriptor) {

	  // Find "outer", the descriptor of the top-level message in which
	  // "descriptor" is embedded.
	  const Descriptor* outer = descriptor;
	  while (outer->containing_type() != NULL) outer = outer->containing_type();

	  //Strip the package defined in the proto file from the name
	  const string& outer_name = outer->full_name();
	  string inner_name = descriptor->full_name().substr(outer_name.size());

	  return UnderscoresToCapitalizedUnderscoresImpl(outer->name() + inner_name);

	}

	bool IsParentMessage(const Descriptor* parent_descriptor,
			     const Descriptor* child_descriptor) {
	  const Descriptor* descriptor = parent_descriptor;
	  while (descriptor != NULL) {
	    if (descriptor == child_descriptor) {
	      return true;
	    }
	    descriptor = descriptor->containing_type();
	  }
	  return false;
	}

	bool HasCommonParent(const Descriptor* descriptor1, const Descriptor* descriptor2) {
	  const Descriptor* descriptorOne = descriptor1;
	  while (descriptorOne->containing_type() != NULL) {
	    descriptorOne = descriptorOne->containing_type();
	  }
	  const Descriptor* descriptorTwo = descriptor2;
	  while (descriptorTwo->containing_type() != NULL) {
	    descriptorTwo = descriptorTwo->containing_type();
	  }
	  return descriptorOne == descriptorTwo;
	}

	string EnumTypeName(const EnumDescriptor* enum_descriptor, bool qualified) {
	  if (enum_descriptor->containing_type() == NULL || !qualified) {
	    return UnderscoresToCapitalizedUnderscoresImpl(enum_descriptor->name());
	  } else {
	    string result = AdaPackageName(enum_descriptor->containing_type());
	    result += '.';
	    result += UnderscoresToCapitalizedUnderscoresImpl(enum_descriptor->name());
	    return result;
	  }
	}

	string EnumDefinitionPackageName(const EnumDescriptor* enum_descriptor) {
	  return UnderscoresToCapitalizedUnderscoresImpl(enum_descriptor->file()->package())  + ".Enumeration." +
	  AdaPackageName(enum_descriptor->containing_type());
	}

	string EnumDefinitionTypeName(const EnumDescriptor* enum_descriptor) {
	  return UnderscoresToCapitalizedUnderscoresImpl(enum_descriptor->file()->package()) + ".Enumeration." +
	  EnumTypeName(enum_descriptor, true);
	}

	const char* DeclaredTypePrimitiveOperationName(FieldDescriptor::Type type) {
	  switch (type) {
	    case FieldDescriptor::TYPE_INT32: return "Integer_32";
	    case FieldDescriptor::TYPE_INT64: return "Integer_64";
	    case FieldDescriptor::TYPE_UINT32: return "Unsigned_Integer_32";
	    case FieldDescriptor::TYPE_UINT64: return "Unsigned_Integer_64";
	    case FieldDescriptor::TYPE_SINT32: return "Signed_Integer_32";
	    case FieldDescriptor::TYPE_SINT64: return "Signed_Integer_64";
	    case FieldDescriptor::TYPE_FIXED32: return "Fixed_32";
	    case FieldDescriptor::TYPE_FIXED64: return "Fixed_64";
	    case FieldDescriptor::TYPE_SFIXED32: return "Signed_Fixed_32";
	    case FieldDescriptor::TYPE_SFIXED64: return "Signed_Fixed_64";
	    case FieldDescriptor::TYPE_FLOAT: return "Float";
	    case FieldDescriptor::TYPE_DOUBLE: return "Double";

	    case FieldDescriptor::TYPE_BOOL: return "Boolean";
	    case FieldDescriptor::TYPE_ENUM: return "Enumeration";

	    case FieldDescriptor::TYPE_STRING: return "String";
	    case FieldDescriptor::TYPE_BYTES: return "String";
	    case FieldDescriptor::TYPE_GROUP: return "Group";
	    case FieldDescriptor::TYPE_MESSAGE: return "Message";

	      // No default because we want the compiler to complain if any new
	      // types are added.
	  }
	  GOOGLE_LOG(FATAL) << "Can't get here.";
	  return "";
	}



      } // namespace ada
    } // namespace compiler
  } // namespace protobuf
} // namespace google

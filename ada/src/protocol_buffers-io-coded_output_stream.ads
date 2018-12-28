pragma Ada_2012;

with Protocol_Buffers.Wire_Format;
with Ada.Streams;

limited with Protocol_Buffers.Message;

-- limited with Protocol_Buffers.Message; is a trick to avoid a circular unit
-- dependency caused by with-ing Protocol_Buffers.IO.Coded_Output_Stream from
-- Protocol_Buffers.Message. with Protocol_Buffers.Message is used in body
-- since the incomplete view provided by limited with is not sufficient.

package Protocol_Buffers.IO.Coded_Output_Stream is
  type Root_Stream_Access is access all Ada.Streams.Root_Stream_Type'Class;
  type Instance (Output_Stream : Root_Stream_Access) is tagged private;

  TMP_LITTLE_ENDIAN_32_SIZE : constant := 4;
  TMP_LITTLE_ENDIAN_64_SIZE : constant := 8;

  -- Consider replacing this use clause???
  use Protocol_Buffers.Wire_Format;

  function Encode_Zig_Zag_32 (Value : in PB_Int32) return PB_UInt32;

  function Encode_Zig_Zag_64 (Value : in PB_Int64) return PB_UInt64;

  function Compute_Raw_Varint_32_Size (Value : in PB_UInt32) return PB_Object_Size;

  function Compute_Raw_Varint_64_Size (Value : in PB_UInt64) return PB_Object_Size;

  function Compute_Boolean_Size (Field_Number : in PB_Field_Type; Value : in PB_Bool) return PB_Object_Size;

  function Compute_Double_Size (Field_Number : in PB_Field_Type; Value : in PB_Double) return PB_Object_Size;

  function Compute_Enumeration_Size (Field_Number : in PB_Field_Type; Value : in PB_Int32) return PB_Object_Size;

  function Compute_Fixed_32_Size (Field_Number : in PB_Field_Type; Value : in PB_UInt32) return PB_Object_Size;

  function Compute_Fixed_64_Size (Field_Number : in PB_Field_Type; Value : in PB_UInt64) return PB_Object_Size;

  function Compute_Float_Size (Field_Number : in PB_Field_Type; Value : in PB_Float) return PB_Object_Size;

  function Compute_Integer_32_Size (Field_Number : in PB_Field_Type; Value : in PB_Int32) return PB_Object_Size;

  function Compute_Integer_64_Size (Field_Number : in PB_Field_Type; Value : in PB_Int64) return PB_Object_Size;

  function Compute_Signed_Fixed_32_Size (Field_Number : in PB_Field_Type; Value : in PB_Int32) return PB_Object_Size;

  function Compute_Signed_Fixed_64_Size (Field_Number : in PB_Field_Type; Value : in PB_Int64) return PB_Object_Size;

  function Compute_Signed_Integer_32_Size (Field_Number : in PB_Field_Type; Value : in PB_Int32) return PB_Object_Size;

  function Compute_Signed_Integer_64_Size (Field_Number : in PB_Field_Type; Value : in PB_Int64) return PB_Object_Size;

  function Compute_String_Size (Field_Number : in PB_Field_Type; Value : in PB_String) return PB_Object_Size;

  function Compute_Tag_Size (Field_Number : PB_Field_Type) return PB_Object_Size;

  function Compute_Unsigned_Integer_32_Size (Field_Number : in PB_Field_Type; Value : in PB_UInt32) return PB_Object_Size;

  function Compute_Unsigned_Integer_64_Size (Field_Number : in PB_Field_Type; Value : in PB_UInt64) return PB_Object_Size;

  function Compute_Boolean_Size_No_Tag (Value : in PB_Bool) return PB_Object_Size;

  function Compute_Double_Size_No_Tag (Value : in PB_Double) return PB_Object_Size;

  function Compute_Enumeration_Size_No_Tag (Value : in PB_Int32) return PB_Object_Size;

  function Compute_Fixed_32_Size_No_Tag (Value : in PB_UInt32) return PB_Object_Size;

  function Compute_Fixed_64_Size_No_Tag (Value : in PB_UInt64) return PB_Object_Size;

  function Compute_Float_Size_No_Tag (Value : in PB_Float) return PB_Object_Size;

  function Compute_Integer_32_Size_No_Tag (Value : in PB_Int32) return PB_Object_Size;

  function Compute_Integer_64_Size_No_Tag (Value : in PB_Int64) return PB_Object_Size;

  function Compute_Signed_Fixed_32_Size_No_Tag (Value : in PB_Int32) return PB_Object_Size;

  function Compute_Signed_Fixed_64_Size_No_Tag (Value : in PB_Int64) return PB_Object_Size;

  function Compute_Signed_Integer_32_Size_No_Tag (Value : in PB_Int32) return PB_Object_Size;

  function Compute_Signed_Integer_64_Size_No_Tag (Value : in PB_Int64) return PB_Object_Size;

  function Compute_String_Size_No_Tag (Value : in PB_String) return PB_Object_Size;

  function Compute_Unsigned_Integer_32_Size_No_Tag (Value : in PB_UInt32) return PB_Object_Size;

  function Compute_Unsigned_Integer_64_Size_No_Tag (Value : in PB_UInt64) return PB_Object_Size;

  function Compute_Message_Size (Field_Number : in PB_Field_Type; Value : in out Protocol_Buffers.Message.Instance'Class) return PB_Object_Size;

  function Compute_Message_Size_No_Tag (Value : in out Protocol_Buffers.Message.Instance'Class) return PB_Object_Size;

  procedure Write_Boolean (This : in Coded_Output_Stream.Instance; Field_Number : in PB_Field_Type; Value : in PB_Bool);

  procedure Write_Double (This : in Coded_Output_Stream.Instance; Field_Number : in PB_Field_Type; Value : in PB_Double);

  procedure Write_Enumeration (This : in Coded_Output_Stream.Instance; Field_Number : in PB_Field_Type; Value : in PB_Int32);

  procedure Write_Fixed_32 (This : in Coded_Output_Stream.Instance; Field_Number : in PB_Field_Type; Value : in PB_UInt32);

  procedure Write_Fixed_64 (This : in Coded_Output_Stream.Instance; Field_Number : in PB_Field_Type; Value : in PB_UInt64);

  procedure Write_Float (This : in Coded_Output_Stream.Instance; Field_Number : in PB_Field_Type; Value : in PB_Float);

  procedure Write_Integer_32 (This : in Coded_Output_Stream.Instance; Field_Number : in PB_Field_Type; Value : in PB_Int32);

  procedure Write_Integer_64 (This : in Coded_Output_Stream.Instance; Field_Number : in PB_Field_Type; Value : in PB_Int64);

  procedure Write_Signed_Fixed_32 (This : in Coded_Output_Stream.Instance; Field_Number : in PB_Field_Type; Value : in PB_Int32);

  procedure Write_Signed_Fixed_64 (This : in Coded_Output_Stream.Instance; Field_Number : in PB_Field_Type; Value : in PB_Int64);

  procedure Write_Signed_Integer_32 (This : in Coded_Output_Stream.Instance; Field_Number : in PB_Field_Type; Value : in PB_Int32);

  procedure Write_Signed_Integer_64 (This : in Coded_Output_Stream.Instance; Field_Number : in PB_Field_Type; Value : in PB_Int64);

  procedure Write_String (This : in Coded_Output_Stream.Instance; Field_Number : in PB_Field_Type; Value : in PB_String);

  procedure Write_Unsigned_Integer_32 (This : in Coded_Output_Stream.Instance; Field_Number : in PB_Field_Type; Value : in PB_UInt32);

  procedure Write_Unsigned_Integer_64 (This : in Coded_Output_Stream.Instance; Field_Number : in PB_Field_Type; Value : in PB_UInt64);

  procedure Write_Boolean_No_Tag (This : in Coded_Output_Stream.Instance; Value : in PB_Bool);

  procedure Write_Double_No_Tag (This : in Coded_Output_Stream.Instance; Value : in PB_Double);

  procedure Write_Enumeration_No_Tag (This : in Coded_Output_Stream.Instance; Value : in PB_Int32);

  procedure Write_Fixed_32_No_Tag (This : in Coded_Output_Stream.Instance; Value : in PB_UInt32);

  procedure Write_Fixed_64_No_Tag (This : in Coded_Output_Stream.Instance; Value : in PB_UInt64);

  procedure Write_Float_No_Tag (This : in Coded_Output_Stream.Instance; Value : in PB_Float);

  procedure Write_Integer_32_No_Tag (This : in Coded_Output_Stream.Instance; Value : in PB_Int32);

  procedure Write_Integer_64_No_Tag (This : in Coded_Output_Stream.Instance; Value : in PB_Int64);

  procedure Write_Signed_Fixed_32_No_Tag (This : in Coded_Output_Stream.Instance; Value : in PB_Int32);

  procedure Write_Signed_Fixed_64_No_Tag (This : in Coded_Output_Stream.Instance; Value : in PB_Int64);

  procedure Write_Signed_Integer_32_No_Tag (This : in Coded_Output_Stream.Instance; Value : in PB_Int32);

  procedure Write_Signed_Integer_64_No_Tag (This : in Coded_Output_Stream.Instance; Value : in PB_Int64);

  procedure Write_String_No_Tag (This : in Coded_Output_Stream.Instance; Value : in PB_String);

  procedure Write_Unsigned_Integer_32_No_Tag (This : in Coded_Output_Stream.Instance; Value : in PB_UInt32);

  procedure Write_Unsigned_Integer_64_No_Tag (This : in Coded_Output_Stream.Instance; Value : in PB_UInt64);

  procedure Write_Tag (This : in Coded_Output_Stream.Instance; Field_Number : in PB_Field_Type; Wire_Type : in PB_Wire_Type);

  procedure Write_Raw_Little_Endian_32 (This : in Coded_Output_Stream.Instance; Value : in PB_UInt32);

  procedure Write_Raw_Little_Endian_64 (This : in Coded_Output_Stream.Instance; Value : in PB_UInt64);

  procedure Write_Raw_Varint_32 (This : in Coded_Output_Stream.Instance; Value : in PB_UInt32);

  procedure Write_Raw_Varint_64 (This : in Coded_Output_Stream.Instance; Value : in PB_UInt64);

  procedure Write_Raw_Byte (This : in Coded_Output_Stream.Instance; Value : in PB_Byte);

  procedure Write_Message (This : in Coded_Output_Stream.Instance; Field_Number : in PB_Field_Type; Value : in Protocol_Buffers.Message.Instance'Class);

  procedure Write_Message_No_Tag (This : in Coded_Output_Stream.Instance; Value : in Protocol_Buffers.Message.Instance'Class);
private
  type Instance (Output_Stream : Root_Stream_Access) is tagged null record;
end Protocol_Buffers.IO.Coded_Output_Stream;

pragma Ada_2012;

with Interfaces;
with Protocol_Buffers.Wire_Format;
with Ada.Streams.Stream_IO;
package Protocol_Buffers.IO.Coded_Output_Stream is
   type Root_Stream_Access is access all Ada.Streams.Root_Stream_Type'Class;
   type Instance (Output_Stream : Root_Stream_Access) is tagged private;


   -- Consider changing for portability ???
   TMP_LITTLE_ENDIAN_32_SIZE : constant := 4;
   TMP_LITTLE_ENDIAN_64_SIZE : constant := 8;

   -- Consider replacing this use clause???
   use Protocol_Buffers.Wire_Format;

   function Encode_Zig_Zag_32 (Value : in TMP_INTEGER) return TMP_UNSIGNED_INTEGER;

   function Encode_Zig_Zag_64 (Value : in TMP_LONG) return TMP_UNSIGNED_LONG;

   function Compute_Raw_Varint_32_Size (Value : in TMP_UNSIGNED_INTEGER) return TMP_OBJECT_SIZE;

   function Compute_Raw_Varint_64_Size (Value : in TMP_UNSIGNED_LONG) return TMP_OBJECT_SIZE;

   function Compute_Boolean_Size (Field_Number : in TMP_FIELD_TYPE; Value : in TMP_BOOLEAN) return TMP_OBJECT_SIZE;

   function Compute_Double_Size (Field_Number : in TMP_FIELD_TYPE; Value : in TMP_DOUBLE) return TMP_OBJECT_SIZE;

   function Compute_Enumeration_Size (Field_Number : in TMP_FIELD_TYPE; Value : in TMP_INTEGER) return TMP_OBJECT_SIZE;

   function Compute_Fixed_32_Size (Field_Number : in TMP_FIELD_TYPE; Value : in TMP_UNSIGNED_INTEGER) return TMP_OBJECT_SIZE;

   function Compute_Fixed_64_Size (Field_Number : in TMP_FIELD_TYPE; Value : in TMP_UNSIGNED_LONG) return TMP_OBJECT_SIZE;

   function Compute_Float_Size (Field_Number : in TMP_FIELD_TYPE; Value : in TMP_FLOAT) return TMP_OBJECT_SIZE;

   function Compute_Integer_32_Size (Field_Number : in TMP_FIELD_TYPE; Value : in TMP_INTEGER) return TMP_OBJECT_SIZE;

   function Compute_Integer_64_Size (Field_Number : in TMP_FIELD_TYPE; Value : in TMP_LONG) return TMP_OBJECT_SIZE;

   function Compute_Signed_Fixed_32_Size (Field_Number : in TMP_FIELD_TYPE; Value : in TMP_INTEGER) return TMP_OBJECT_SIZE;

   function Compute_Signed_Fixed_64_Size (Field_Number : in TMP_FIELD_TYPE; Value : in TMP_LONG) return TMP_OBJECT_SIZE;

   function Compute_Signed_Integer_32_Size (Field_Number : in TMP_FIELD_TYPE; Value : in TMP_INTEGER) return TMP_OBJECT_SIZE;

   function Compute_Signed_Integer_64_Size (Field_Number : in TMP_FIELD_TYPE; Value : in TMP_LONG) return TMP_OBJECT_SIZE;

   function Compute_String_Size (Field_Number : in TMP_FIELD_TYPE; Value : in TMP_STRING) return TMP_OBJECT_SIZE;

   function Compute_Tag_Size (Field_Number : TMP_FIELD_TYPE) return TMP_OBJECT_SIZE;

   function Compute_Unsigned_Integer_32_Size (Field_Number : in TMP_FIELD_TYPE; Value : in TMP_UNSIGNED_INTEGER) return TMP_OBJECT_SIZE;

   function Compute_Unsigned_Integer_64_Size (Field_Number : in TMP_FIELD_TYPE; Value : in TMP_UNSIGNED_LONG) return TMP_OBJECT_SIZE;

   function Compute_Boolean_Size_No_Tag (Value : in TMP_BOOLEAN) return TMP_OBJECT_SIZE;

   function Compute_Double_Size_No_Tag (Value : in TMP_DOUBLE) return TMP_OBJECT_SIZE;

   function Compute_Enumeration_Size_No_Tag (Value : in TMP_INTEGER) return TMP_OBJECT_SIZE;

   function Compute_Fixed_32_Size_No_Tag (Value : in TMP_UNSIGNED_INTEGER) return TMP_OBJECT_SIZE;

   function Compute_Fixed_64_Size_No_Tag (Value : in TMP_UNSIGNED_LONG) return TMP_OBJECT_SIZE;

   function Compute_Float_Size_No_Tag (Value : in TMP_FLOAT) return TMP_OBJECT_SIZE;

   function Compute_Integer_32_Size_No_Tag (Value : in TMP_INTEGER) return TMP_OBJECT_SIZE;

   function Compute_Integer_64_Size_No_Tag (Value : in TMP_LONG) return TMP_OBJECT_SIZE;

   function Compute_Signed_Fixed_32_Size_No_Tag (Value : in TMP_INTEGER) return TMP_OBJECT_SIZE;

   function Compute_Signed_Fixed_64_Size_No_Tag (Value : in TMP_LONG) return TMP_OBJECT_SIZE;

   function Compute_Signed_Integer_32_Size_No_Tag (Value : in TMP_INTEGER) return TMP_OBJECT_SIZE;

   function Compute_Signed_Integer_64_Size_No_Tag (Value : in TMP_LONG) return TMP_OBJECT_SIZE;

   function Compute_String_Size_No_Tag (Value : in TMP_STRING) return TMP_OBJECT_SIZE;

   function Compute_Unsigned_Integer_32_Size_No_Tag (Value : in TMP_UNSIGNED_INTEGER) return TMP_OBJECT_SIZE;

   function Compute_Unsigned_Integer_64_Size_No_Tag (Value : in TMP_UNSIGNED_LONG) return TMP_OBJECT_SIZE;

   procedure Flush (The_Coded_Output_Stream : in Coded_Output_Stream.Instance);

   procedure Write_Boolean (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Field_Number : in TMP_FIELD_TYPE; Value : in TMP_BOOLEAN);

   procedure Write_Double (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Field_Number : in TMP_FIELD_TYPE; Value : in TMP_DOUBLE);

   procedure Write_Enumeration (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Field_Number : in TMP_FIELD_TYPE; Value : in TMP_INTEGER);

   procedure Write_Fixed_32 (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Field_Number : in TMP_FIELD_TYPE; Value : in TMP_UNSIGNED_INTEGER);

   procedure Write_Fixed_64 (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Field_Number : in TMP_FIELD_TYPE; Value : in TMP_UNSIGNED_LONG);

   procedure Write_Float (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Field_Number : in TMP_FIELD_TYPE; Value : in TMP_FLOAT);

   procedure Write_Integer_32 (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Field_Number : in TMP_FIELD_TYPE; Value : in TMP_INTEGER);

   procedure Write_Integer_64 (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Field_Number : in TMP_FIELD_TYPE; Value : in TMP_LONG);

   procedure Write_Signed_Fixed_32 (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Field_Number : in TMP_FIELD_TYPE; Value : in TMP_INTEGER);

   procedure Write_Signed_Fixed_64 (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Field_Number : in TMP_FIELD_TYPE; Value : in TMP_LONG);

   procedure Write_Signed_Integer_32 (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Field_Number : in TMP_FIELD_TYPE; Value : in TMP_INTEGER);

   procedure Write_Signed_Integer_64 (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Field_Number : in TMP_FIELD_TYPE; Value : in TMP_LONG);

   procedure Write_String (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Field_Number : in TMP_FIELD_TYPE; Value : in TMP_STRING);

   procedure Write_Unsigned_Integer_32 (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Field_Number : in TMP_FIELD_TYPE; Value : in TMP_UNSIGNED_INTEGER);

   procedure Write_Unsigned_Integer_64 (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Field_Number : in TMP_FIELD_TYPE; Value : in TMP_UNSIGNED_LONG);

   procedure Write_Boolean_No_Tag (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Value : in TMP_BOOLEAN);

   procedure Write_Double_No_Tag (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Value : in TMP_DOUBLE);

   procedure Write_Enumeration_No_Tag (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Value : in TMP_INTEGER);

   procedure Write_Fixed_32_No_Tag (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Value : in TMP_UNSIGNED_INTEGER);

   procedure Write_Fixed_64_No_Tag (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Value : in TMP_UNSIGNED_LONG);

   procedure Write_Float_No_Tag (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Value : in TMP_FLOAT);

   procedure Write_Integer_32_No_Tag (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Value : in TMP_INTEGER);

   procedure Write_Integer_64_No_Tag (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Value : in TMP_LONG);

   procedure Write_Signed_Fixed_32_No_Tag (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Value : in TMP_INTEGER);

   procedure Write_Signed_Fixed_64_No_Tag (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Value : in TMP_LONG);

   procedure Write_Signed_Integer_32_No_Tag (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Value : in TMP_INTEGER);

   procedure Write_Signed_Integer_64_No_Tag (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Value : in TMP_LONG);

   procedure Write_String_No_Tag (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Value : in TMP_STRING);

   procedure Write_Unsigned_Integer_32_No_Tag (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Value : in TMP_UNSIGNED_INTEGER);

   procedure Write_Unsigned_Integer_64_No_Tag (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Value : in TMP_UNSIGNED_LONG);

   procedure Write_Tag (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Field_Number : in TMP_FIELD_TYPE; Wire_Type : in TMP_WIRE_TYPE);

   procedure Write_Raw_Little_Endian_32 (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Value : in TMP_UNSIGNED_INTEGER);

   procedure Write_Raw_Little_Endian_64 (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Value : in TMP_UNSIGNED_LONG);

   procedure Write_Raw_Varint_32 (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Value : in TMP_UNSIGNED_INTEGER);

   procedure Write_Raw_Varint_64 (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Value : in TMP_UNSIGNED_LONG);

   procedure Write_Raw_Byte (The_Coded_Output_Stream : in Coded_Output_Stream.Instance; Value : in TMP_UNSIGNED_BYTE);
private
   type Instance (Output_Stream : Root_Stream_Access) is tagged null record;
end Protocol_Buffers.IO.Coded_Output_Stream;

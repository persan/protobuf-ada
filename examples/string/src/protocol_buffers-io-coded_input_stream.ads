pragma Ada_2012;

with Interfaces;
with Protocol_Buffers.Wire_Format;
with Ada.Streams;

package Protocol_Buffers.IO.Coded_Input_Stream is
   type Root_Stream_Access is access all Ada.Streams.Root_Stream_Type'Class;
   type Instance (Input_Stream : Root_Stream_Access) is tagged private;

   -- Consider replacing this use clause???
   use Protocol_Buffers.Wire_Format;

   function Decode_Zig_Zag_32 (Value : in TMP_UNSIGNED_INTEGER) return TMP_UNSIGNED_INTEGER;

   function Decode_Zig_Zag_64 (Value : in TMP_UNSIGNED_LONG) return TMP_UNSIGNED_LONG;

   function Read_Boolean (The_Coded_Input_Stream : in Coded_Input_Stream.Instance) return TMP_BOOLEAN;

   function Read_Double (The_Coded_Input_Stream : in Coded_Input_Stream.Instance) return TMP_DOUBLE;

   function Read_Enumeration (The_Coded_Input_Stream : in Coded_Input_Stream.Instance) return TMP_INTEGER;

   function Read_Fixed_32 (The_Coded_Input_Stream : in Coded_Input_Stream.Instance) return TMP_UNSIGNED_INTEGER;

   function Read_Fixed_64 (The_Coded_Input_Stream : in Coded_Input_Stream.Instance) return TMP_UNSIGNED_LONG;

   function Read_Float (The_Coded_Input_Stream : in Coded_Input_Stream.Instance) return TMP_FLOAT;

   function Read_Integer_32 (The_Coded_Input_Stream : in Coded_Input_Stream.Instance) return TMP_INTEGER;

   function Read_Integer_64 (The_Coded_Input_Stream : in Coded_Input_Stream.Instance) return TMP_LONG;

   function Read_Raw_Byte (The_Coded_Input_Stream : in Coded_Input_Stream.Instance) return TMP_UNSIGNED_BYTE;

   function Read_Raw_Little_Endian_32 (The_Coded_Input_Stream : in Coded_Input_Stream.Instance) return TMP_UNSIGNED_INTEGER;

   function Read_Raw_Little_Endian_64 (The_Coded_Input_Stream : in Coded_Input_Stream.Instance) return TMP_UNSIGNED_LONG;

   function Read_Raw_Varint_32 (The_Coded_Input_Stream : in Coded_Input_Stream.Instance) return TMP_UNSIGNED_INTEGER;

   function Read_Raw_Varint_64 (The_Coded_Input_Stream : in Coded_Input_Stream.Instance) return TMP_UNSIGNED_LONG;

   function Read_Signed_Fixed_32 (The_Coded_Input_Stream : in Coded_Input_Stream.Instance) return TMP_INTEGER;

   function Read_Signed_Fixed_64 (The_Coded_Input_Stream : in Coded_Input_Stream.Instance) return TMP_LONG;

   function Read_Signed_Integer_32 (The_Coded_Input_Stream : in Coded_Input_Stream.Instance) return TMP_INTEGER;

   function Read_Signed_Integer_64 (The_Coded_Input_Stream : in Coded_Input_Stream.Instance) return TMP_LONG;

   function Read_String (The_Coded_Input_Stream : in Coded_Input_Stream.Instance) return TMP_STRING;

   function Read_Tag (The_Coded_Input_Stream : in Coded_Input_Stream.Instance) return TMP_UNSIGNED_INTEGER;

   function Read_Unsigned_Integer_32 (The_Coded_Input_Stream : in Coded_Input_Stream.Instance) return TMP_UNSIGNED_INTEGER;

   function Read_Unsigned_Integer_64 (The_Coded_Input_Stream : in Coded_Input_Stream.Instance) return TMP_UNSIGNED_LONG;

   function Skip_Field (The_Coded_Input_Stream : in Coded_Input_Stream.Instance; Tag : in TMP_UNSIGNED_INTEGER) return Boolean;

   procedure Skip_Raw_Bytes (The_Coded_Input_Stream : in Coded_Input_Stream.Instance; Bytes_To_Skip : in TMP_UNSIGNED_INTEGER);

   procedure Skip_Message (The_Coded_Input_Stream : in Coded_Input_Stream.Instance);

private
   type Instance (Input_Stream : Root_Stream_Access) is tagged null record;
end Protocol_Buffers.IO.Coded_Input_Stream;

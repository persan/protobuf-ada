with Ada.Streams;
with Google.Protobuf.Wire_Format;

package Test_Helpers is
  procedure Assert_Write_Raw_Varint (Data : in Ada.Streams.Stream_Element_Array; Value : in Google.Protobuf.Wire_Format.PB_UInt64);
  procedure Assert_Write_Raw_Little_Endian_32 (Data : in Ada.Streams.Stream_Element_Array; Value : in Google.Protobuf.Wire_Format.PB_Int64);
  procedure Assert_Write_Raw_Little_Endian_64 (Data : in Ada.Streams.Stream_Element_Array; Value : in Google.Protobuf.Wire_Format.PB_Int64);
  procedure Assert_Read_Raw_Varint (Data : in Ada.Streams.Stream_Element_Array; Value : in Google.Protobuf.Wire_Format.PB_UInt64);
  procedure Assert_Read_Raw_Little_Endian_32 (Data : in Ada.Streams.Stream_Element_Array; Value : in Google.Protobuf.Wire_Format.PB_UInt32);
  procedure Assert_Read_Raw_Little_Endian_64 (Data : in Ada.Streams.Stream_Element_Array; Value : in Google.Protobuf.Wire_Format.PB_UInt64);
end Test_Helpers;

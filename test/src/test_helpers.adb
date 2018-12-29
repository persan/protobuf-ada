with Buffered_Byte_Stream;
with Protocol_Buffers.IO.Coded_Output_Stream;
with Protocol_Buffers.IO.Coded_Input_Stream;
with AUnit.Assertions;
with Ada.Unchecked_Conversion;

package body Test_Helpers is

  -----------------------------
  -- Assert_Write_Raw_Varint --
  -----------------------------

  procedure Assert_Write_Raw_Varint
    (Data  : Ada.Streams.Stream_Element_Array;
     Value : Protocol_Buffers.Wire_Format.PB_UInt64)
  is
    use Protocol_Buffers.Wire_Format;
    use Protocol_Buffers.IO;
    use Ada.Streams;

    use type PB_UInt64;
  begin
    -- Write 32-bit if value fits in 32-bits.
    if Value <= PB_UInt64 (PB_UInt32'Last) then
      declare
        Buffer_Stream : Buffered_Byte_Stream.Byte_Stream_Access := new Buffered_Byte_Stream.Byte_Stream (4096);
        Output_Stream : Coded_Output_Stream.Instance (Coded_Output_Stream.Root_Stream_Access (Buffer_Stream));
      begin
        Output_Stream.Write_Raw_Varint_32 (PB_UInt32 (Value));
        AUnit.Assertions.Assert (Condition => Data = Buffered_Byte_Stream.To_Stream_Element_Array (Buffer_Stream),
                                 Message   => "Assert_Write_Raw_Varint: Write_Raw_Varint_32 data not equal to value!");
        AUnit.Assertions.Assert (Condition => Data'Length = Coded_Output_Stream.Compute_Raw_Varint_32_Size (PB_UInt32 (Value)),
                                 Message   => "Size of data not equal to Compute_Raw_Varint_32_SIZE of value!");
        Buffered_Byte_Stream.Free (Buffer_Stream);
      end;
    end if;

    -- Write 64 bit
    declare
      Buffer_Stream : Buffered_Byte_Stream.Byte_Stream_Access := new Buffered_Byte_Stream.Byte_Stream (4096);
      Output_Stream : Coded_Output_Stream.Instance (Coded_Output_Stream.Root_Stream_Access (Buffer_Stream));
    begin
      Output_Stream.Write_Raw_Varint_64 (Value);
      AUnit.Assertions.Assert (Condition => Data = Buffered_Byte_Stream.To_Stream_Element_Array (Buffer_Stream),
                               Message   => "Assert_Write_Raw_Varint: Write_Raw_Varint_64 data not equal to value!");
      AUnit.Assertions.Assert (Condition => Data'Length = Coded_Output_Stream.Compute_Raw_Varint_64_Size (Value),
                               Message   => "Size of data not equal to Compute_Raw_Varint_64_SIZE of value!");
      Buffered_Byte_Stream.Free (Buffer_Stream);
    end;

  end Assert_Write_Raw_Varint;

  ---------------------------------------
  -- Assert_Write_Raw_Little_Endian_32 --
  ---------------------------------------

  procedure Assert_Write_Raw_Little_Endian_32 (Data : in Ada.Streams.Stream_Element_Array; Value : in Protocol_Buffers.Wire_Format.PB_Int64)
  is
    use Protocol_Buffers.Wire_Format;
    use Protocol_Buffers.IO;
    use Ada.Streams;

    Buffer_Stream : Buffered_Byte_Stream.Byte_Stream_Access := new Buffered_Byte_Stream.Byte_Stream (4096);
    Output_Stream : Coded_Output_Stream.Instance (Coded_Output_Stream.Root_Stream_Access (Buffer_Stream));
  begin
    Output_Stream.Write_Raw_Little_Endian_32 (PB_UInt32 (Value));
    AUnit.Assertions.Assert (Condition => Data = Buffered_Byte_Stream.To_Stream_Element_Array (Buffer_Stream),
                             Message   => "Assert_Write_Raw_Little_Endian_32: data not equal to value!");
    Buffered_Byte_Stream.Free (Buffer_Stream);
  end Assert_Write_Raw_Little_Endian_32;

  ---------------------------------------
  -- Assert_Write_Raw_Little_Endian_32 --
  ---------------------------------------

  procedure Assert_Write_Raw_Little_Endian_64 (Data : in Ada.Streams.Stream_Element_Array; Value : in Protocol_Buffers.Wire_Format.PB_Int64)
  is
    use Protocol_Buffers.Wire_Format;
    use Protocol_Buffers.IO;
    use Ada.Streams;

    function PB_Int64_To_PB_UInt64 is new Ada.Unchecked_Conversion (Source => PB_Int64,
                                                                            Target => PB_UInt64);

    Buffer_Stream : Buffered_Byte_Stream.Byte_Stream_Access := new Buffered_Byte_Stream.Byte_Stream (4096);
    Output_Stream : Coded_Output_Stream.Instance (Coded_Output_Stream.Root_Stream_Access (Buffer_Stream));
  begin
    Output_Stream.Write_Raw_Little_Endian_64 (PB_Int64_To_PB_UInt64 (Value));
    AUnit.Assertions.Assert (Condition => Data = Buffered_Byte_Stream.To_Stream_Element_Array (Buffer_Stream),
                             Message   => "Assert_Write_Raw_Little_Endian_64: data not equal to value!");
    Buffered_Byte_Stream.Free (Buffer_Stream);
  end Assert_Write_Raw_Little_Endian_64;

  ----------------------------
  -- Assert_Read_Raw_Varint --
  ----------------------------

  procedure Assert_Read_Raw_Varint (Data : in Ada.Streams.Stream_Element_Array; Value : in Protocol_Buffers.Wire_Format.PB_UInt64)
  is
    use Protocol_Buffers.IO;
    use Protocol_Buffers.Wire_Format;
    use Ada.Streams;

    use type PB_UInt64;
    use type PB_UInt32;

    function PB_UInt64_To_PB_UInt32 is new Ada.Unchecked_Conversion (Source => PB_UInt64,
                                                                                        Target => PB_UInt32);

  begin

    declare
      Buffer_Stream                 : Buffered_Byte_Stream.Byte_Stream_Access := new Buffered_Byte_Stream.Byte_Stream (4096);
      Input_Stream                  : Coded_Input_Stream.Instance (Coded_Input_Stream.Root_Stream_Access (Buffer_Stream));
      Value_As_PB_UInt32 : PB_UInt32 := PB_UInt64_To_PB_UInt32 (Value);
    begin
      Buffered_Byte_Stream.Empty_And_Load_Buffer (Buffer_Stream, Data);
      declare
        Read : PB_UInt32 := Input_Stream.Read_Raw_Varint_32;
      begin
        AUnit.Assertions.Assert (Condition => Value_As_PB_UInt32 = Read,
                                 Message   => "Assert_Read_Raw_Varint: Read_Raw_Varint_32 data not equal to value!" &
                                   " Expected: " & PB_UInt32'Image (Value_As_PB_UInt32) &
                                   " Read: " & PB_UInt32'Image (Read));
      end;
      Buffered_Byte_Stream.Free (Buffer_Stream);
    end;

    declare
      Buffer_Stream : Buffered_Byte_Stream.Byte_Stream_Access := new Buffered_Byte_Stream.Byte_Stream (4096);
      Input_Stream  : Coded_Input_Stream.Instance (Coded_Input_Stream.Root_Stream_Access (Buffer_Stream));

    begin
      Buffered_Byte_Stream.Empty_And_Load_Buffer (Buffer_Stream, Data);
      declare
        Read : PB_UInt64 := Input_Stream.Read_Raw_Varint_64;
      begin
        AUnit.Assertions.Assert (Condition => Value = Read,
                                 Message   => "Assert_Read_Raw_Varint: Read_Raw_Varint_64 data not equal to value!" &
                                   " Expected: " & PB_UInt64'Image (Value) &
                                   " Read: " & PB_UInt64'Image (Read));
      end;
      Buffered_Byte_Stream.Free (Buffer_Stream);
    end;
  end Assert_Read_Raw_Varint;

  ---------------------------------------
  -- Assert_Read_Raw_Little_Endian_32 --
  ---------------------------------------

  procedure Assert_Read_Raw_Little_Endian_32 (Data : in Ada.Streams.Stream_Element_Array; Value : in Protocol_Buffers.Wire_Format.PB_UInt32)
  is
    use Protocol_Buffers.IO;
    use Protocol_Buffers.Wire_Format;

    use type PB_UInt32;

    Buffer_Stream : Buffered_Byte_Stream.Byte_Stream_Access := new Buffered_Byte_Stream.Byte_Stream (4096);
    Input_Stream  : Coded_Input_Stream.Instance (Coded_Input_Stream.Root_Stream_Access (Buffer_Stream));
  begin
    Buffered_Byte_Stream.Empty_And_Load_Buffer (Buffer_Stream, Data);
    declare
      Read : PB_UInt32 := Input_Stream.Read_Raw_Little_Endian_32;
    begin
      AUnit.Assertions.Assert (Condition => Value = Read,
                               Message   => "Assert_Read_Raw_Little_Endian_32: Read_Raw_Little_Endian_32 data not equal to value!" &
                                 " Expected: " & PB_UInt32'Image (Value) &
                                 " Read: " & PB_UInt32'Image (Read));
    end;
    Buffered_Byte_Stream.Free (Buffer_Stream);
  end Assert_Read_Raw_Little_Endian_32;

  ---------------------------------------
  -- Assert_Read_Raw_Little_Endian_64 --
  ---------------------------------------

  procedure Assert_Read_Raw_Little_Endian_64 (Data : in Ada.Streams.Stream_Element_Array; Value : in Protocol_Buffers.Wire_Format.PB_UInt64)
  is
    use Protocol_Buffers.IO;
    use Protocol_Buffers.Wire_Format;

    use type PB_UInt64;

    Buffer_Stream : Buffered_Byte_Stream.Byte_Stream_Access := new Buffered_Byte_Stream.Byte_Stream (4096);
    Input_Stream  : Coded_Input_Stream.Instance (Coded_Input_Stream.Root_Stream_Access (Buffer_Stream));
  begin
    Buffered_Byte_Stream.Empty_And_Load_Buffer (Buffer_Stream, Data);
    declare
      Read : PB_UInt64 := Input_Stream.Read_Raw_Little_Endian_64;
    begin
      AUnit.Assertions.Assert (Condition => Value = Read,
                               Message   => "Assert_Read_Raw_Little_Endian_64: Read_Raw_Little_Endian_64 data not equal to value!" &
                                 " Expected: " & PB_UInt64'Image (Value) &
                                 " Read: " & PB_UInt64'Image (Read));
    end;
    Buffered_Byte_Stream.Free (Buffer_Stream);
  end Assert_Read_Raw_Little_Endian_64;

end Test_Helpers;

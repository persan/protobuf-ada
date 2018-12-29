-- Generated by the protocol buffer compiler.  DO NOT EDIT!
-- source: unittest.proto

pragma Ada_2012;

package body Unittest.TestReallyLargeTagNumber is
  ---------------------------------------------------------------------------
  -- Inherited functions and procedures from Protocol_Buffers.Message -------
  ---------------------------------------------------------------------------

  procedure Clear
    (The_Message : in out Unittest.TestReallyLargeTagNumber.Instance) is
  begin
    if (The_Message.Has_Bits (0 / 32) and Protocol_Buffers.Wire_Format.Shift_Left (16#FF#, 0 mod 32)) /= 0 then
      The_Message.A := 0;
      The_Message.Bb := 0;
    end if;
    The_Message.Has_Bits := (others => 0);
  end Clear;

  procedure Copy
    (To   : in out Unittest.TestReallyLargeTagNumber.Instance;
     From : in Unittest.TestReallyLargeTagNumber.Instance) is
  begin
    To.Clear;
    To.Merge (From);
  end Copy;

  function Get_Type_Name
    (The_Message : in Unittest.TestReallyLargeTagNumber.Instance) return Protocol_Buffers.Wire_Format.PB_String is
  begin
    return "protobuf_unittest.TestReallyLargeTagNumber";
  end Get_Type_Name;

  function Is_Initialized
    (The_Message : in Unittest.TestReallyLargeTagNumber.Instance) return Boolean is
  begin
    return True;
  end Is_Initialized;

  procedure Merge
    (To   : in out Unittest.TestReallyLargeTagNumber.Instance;
     From : in Unittest.TestReallyLargeTagNumber.Instance) is
  begin
    if (From.Has_Bits (0 / 32) and Protocol_Buffers.Wire_Format.Shift_Left (16#FF#, 0 mod 32)) /= 0 then
      -- optional int32 a = 1;
      if From.Has_A then
        To.Set_A (From.A);
      end if;
      -- optional int32 bb = 268435455;
      if From.Has_Bb then
        To.Set_Bb (From.Bb);
      end if;
    end if;
  end Merge;

  function Byte_Size
    (The_Message : in out Unittest.TestReallyLargeTagNumber.Instance) return Protocol_Buffers.Wire_Format.PB_Object_Size is
    Total_Size : Protocol_Buffers.Wire_Format.PB_Object_Size := 0;
  begin
    if (The_Message.Has_Bits (0 / 32) and Protocol_Buffers.Wire_Format.Shift_Left (16#FF#, 0 mod 32)) /= 0 then
      -- optional int32 a = 1;
      if The_Message.Has_A then
        Total_Size := Total_Size + 1 + Protocol_Buffers.IO.Coded_Output_Stream.Compute_Integer_32_Size_No_Tag (The_Message.A);
      end if;
      -- optional int32 bb = 268435455;
      if The_Message.Has_Bb then
        Total_Size := Total_Size + 5 + Protocol_Buffers.IO.Coded_Output_Stream.Compute_Integer_32_Size_No_Tag (The_Message.Bb);
      end if;
    end if;
    The_Message.Cached_Size := Total_Size;
    return Total_Size;
  end Byte_Size;

  procedure Serialize_With_Cached_Sizes
    (The_Message   : in Unittest.TestReallyLargeTagNumber.Instance;
     The_Coded_Output_Stream : in
       Protocol_Buffers.IO.Coded_Output_Stream.Instance) is
  begin
    -- optional int32 a = 1;
    if The_Message.Has_A then
      Protocol_Buffers.IO.Coded_Output_Stream.Write_Integer_32 (The_Coded_Output_Stream, 1, The_Message.A);
    end if;
    -- optional int32 bb = 268435455;
    if The_Message.Has_Bb then
      Protocol_Buffers.IO.Coded_Output_Stream.Write_Integer_32 (The_Coded_Output_Stream, 268435455, The_Message.Bb);
    end if;
  end Serialize_With_Cached_Sizes;

  procedure Merge_Partial_From_Coded_Input_Stream
    (The_Message   : in out Unittest.TestReallyLargeTagNumber.Instance;
     The_Coded_Input_Stream : in out
       Protocol_Buffers.IO.Coded_Input_Stream.Instance) is
    Tag : Protocol_Buffers.Wire_Format.PB_UInt32;
  begin
    Tag := The_Coded_Input_Stream.Read_Tag;
    while Tag /= 0 loop
      case Protocol_Buffers.Wire_Format.Get_Tag_Field_Number (Tag) is
      -- optional int32 a = 1;
      when 1 =>
        if Protocol_Buffers.Wire_Format.Get_Tag_Wire_Type (Tag) =
          Protocol_Buffers.Wire_Format.VARINT then
          The_Message.A := The_Coded_Input_Stream.Read_Integer_32;
          The_Message.Set_Has_A;
        end if;
      -- optional int32 bb = 268435455;
      when 268435455 =>
        if Protocol_Buffers.Wire_Format.Get_Tag_Wire_Type (Tag) =
          Protocol_Buffers.Wire_Format.VARINT then
          The_Message.Bb := The_Coded_Input_Stream.Read_Integer_32;
          The_Message.Set_Has_Bb;
        end if;
      when others =>
        declare
          Dummy : Protocol_Buffers.Wire_Format.PB_Bool;
          pragma Unreferenced (Dummy);
        begin
          Dummy := The_Coded_Input_Stream.Skip_Field (Tag);
          return;
        end;
      end case;
      Tag := The_Coded_Input_Stream.Read_Tag;
    end loop;
  end Merge_Partial_From_Coded_Input_Stream;

  function Get_Cached_Size
    (The_Message : in Unittest.TestReallyLargeTagNumber.Instance) return Protocol_Buffers.Wire_Format.PB_Object_Size is
  begin
    return The_Message.Cached_Size;
  end Get_Cached_Size;

  overriding
  procedure Finalize
    (The_Message : in out Unittest.TestReallyLargeTagNumber.Instance) is
  begin
    null;
  end Finalize;

  ---------------------------------------------------------------------------
  -- Field accessor definitions ---------------------------------------------
  ---------------------------------------------------------------------------

  -- optional int32 a = 1;
  function Has_A
    (The_Message : in TestReallyLargeTagNumber.Instance) return Boolean is
  begin
    return (The_Message.Has_Bits(0) and 16#00000001#) /= 0;
  end Has_A;

  procedure Set_Has_A
    (The_Message : in out TestReallyLargeTagNumber.Instance) is
  begin
    The_Message.Has_Bits(0) := The_Message.Has_Bits(0) or 16#00000001#;
  end Set_Has_A;

  procedure Clear_Has_A
    (The_Message : in out TestReallyLargeTagNumber.Instance) is
  begin
    The_Message.Has_Bits(0) := The_Message.Has_Bits(0) and (not 16#00000001#);
  end Clear_Has_A;

  procedure Clear_A
    (The_Message : in out TestReallyLargeTagNumber.Instance) is
  begin
    The_Message.A := 0;
    The_Message.Clear_Has_A;
  end Clear_A;

  function Get_A
    (The_Message : in TestReallyLargeTagNumber.Instance) return Protocol_Buffers.Wire_Format.PB_Int32 is
  begin
    return The_Message.A;
  end Get_A;

  procedure Set_A
    (The_Message : in out TestReallyLargeTagNumber.Instance;
     Value : in Protocol_Buffers.Wire_Format.PB_Int32) is
  begin
    The_Message.Set_Has_A;
    The_Message.A := Value;
  end Set_A;

  -- optional int32 bb = 268435455;
  function Has_Bb
    (The_Message : in TestReallyLargeTagNumber.Instance) return Boolean is
  begin
    return (The_Message.Has_Bits(0) and 16#00000002#) /= 0;
  end Has_Bb;

  procedure Set_Has_Bb
    (The_Message : in out TestReallyLargeTagNumber.Instance) is
  begin
    The_Message.Has_Bits(0) := The_Message.Has_Bits(0) or 16#00000002#;
  end Set_Has_Bb;

  procedure Clear_Has_Bb
    (The_Message : in out TestReallyLargeTagNumber.Instance) is
  begin
    The_Message.Has_Bits(0) := The_Message.Has_Bits(0) and (not 16#00000002#);
  end Clear_Has_Bb;

  procedure Clear_Bb
    (The_Message : in out TestReallyLargeTagNumber.Instance) is
  begin
    The_Message.Bb := 0;
    The_Message.Clear_Has_Bb;
  end Clear_Bb;

  function Get_Bb
    (The_Message : in TestReallyLargeTagNumber.Instance) return Protocol_Buffers.Wire_Format.PB_Int32 is
  begin
    return The_Message.Bb;
  end Get_Bb;

  procedure Set_Bb
    (The_Message : in out TestReallyLargeTagNumber.Instance;
     Value : in Protocol_Buffers.Wire_Format.PB_Int32) is
  begin
    The_Message.Set_Has_Bb;
    The_Message.Bb := Value;
  end Set_Bb;

end Unittest.TestReallyLargeTagNumber;

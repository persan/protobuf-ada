-- Generated by the protocol buffer compiler.  DO NOT EDIT!
-- source: unittest.proto

pragma Ada_2012;

package body Unittest.TestRecursiveMessage is
  ---------------------------------------------------------------------------
  -- Inherited functions and procedures from Protocol_Buffers.Message -------
  ---------------------------------------------------------------------------

  procedure Clear
    (The_Message : in out Unittest.TestRecursiveMessage.Instance) is
  begin
    if (The_Message.Has_Bits (0 / 32) and Protocol_Buffers.Wire_Format.Shift_Left (16#FF#, 0 mod 32)) /= 0 then
      if The_Message.Has_A then
        The_Message.Clear_Has_A;
        declare
          Temp : Protocol_Buffers.Message.Instance_Access := Protocol_Buffers.Message.Instance_Access(The_Message.A);
        begin
          Protocol_Buffers.Message.Free (Temp);
          The_Message.A := null;
        end;
      end if;
      The_Message.I := 0;
    end if;
    The_Message.Has_Bits := (others => 0);
  end Clear;

  procedure Copy
    (To   : in out Unittest.TestRecursiveMessage.Instance;
     From : in Unittest.TestRecursiveMessage.Instance) is
  begin
    To.Clear;
    To.Merge (From);
  end Copy;

  function Get_Type_Name
    (The_Message : in Unittest.TestRecursiveMessage.Instance) return Protocol_Buffers.Wire_Format.PB_String is
  begin
    return "protobuf_unittest.TestRecursiveMessage";
  end Get_Type_Name;

  function Is_Initialized
    (The_Message : in Unittest.TestRecursiveMessage.Instance) return Boolean is
  begin
    return True;
  end Is_Initialized;

  procedure Merge
    (To   : in out Unittest.TestRecursiveMessage.Instance;
     From : in Unittest.TestRecursiveMessage.Instance) is
  begin
    if (From.Has_Bits (0 / 32) and Protocol_Buffers.Wire_Format.Shift_Left (16#FF#, 0 mod 32)) /= 0 then
      -- optional .protobuf_unittest.TestRecursiveMessage a = 1;
      if From.Has_A then
        To.Get_A.Merge (From.A.all);
      end if;
      -- optional int32 i = 2;
      if From.Has_I then
        To.Set_I (From.I);
      end if;
    end if;
  end Merge;

  function Byte_Size
    (The_Message : in out Unittest.TestRecursiveMessage.Instance) return Protocol_Buffers.Wire_Format.PB_Object_Size is
    Total_Size : Protocol_Buffers.Wire_Format.PB_Object_Size := 0;
  begin
    if (The_Message.Has_Bits (0 / 32) and Protocol_Buffers.Wire_Format.Shift_Left (16#FF#, 0 mod 32)) /= 0 then
      -- optional .protobuf_unittest.TestRecursiveMessage a = 1;
      if The_Message.Has_A then
        Total_Size := Total_Size + 1 + Protocol_Buffers.IO.Coded_Output_Stream.Compute_Message_Size_No_Tag (The_Message.A.all);
      end if;
      -- optional int32 i = 2;
      if The_Message.Has_I then
        Total_Size := Total_Size + 1 + Protocol_Buffers.IO.Coded_Output_Stream.Compute_Integer_32_Size_No_Tag (The_Message.I);
      end if;
    end if;
    The_Message.Cached_Size := Total_Size;
    return Total_Size;
  end Byte_Size;

  procedure Serialize_With_Cached_Sizes
    (The_Message   : in Unittest.TestRecursiveMessage.Instance;
     The_Coded_Output_Stream : in
       Protocol_Buffers.IO.Coded_Output_Stream.Instance) is
  begin
    -- optional .protobuf_unittest.TestRecursiveMessage a = 1;
    if The_Message.Has_A then
      The_Coded_Output_Stream.Write_Message (1, The_Message.A.all);
    end if;
    -- optional int32 i = 2;
    if The_Message.Has_I then
      Protocol_Buffers.IO.Coded_Output_Stream.Write_Integer_32 (The_Coded_Output_Stream, 2, The_Message.I);
    end if;
  end Serialize_With_Cached_Sizes;

  procedure Merge_Partial_From_Coded_Input_Stream
    (The_Message   : in out Unittest.TestRecursiveMessage.Instance;
     The_Coded_Input_Stream : in out
       Protocol_Buffers.IO.Coded_Input_Stream.Instance) is
    Tag : Protocol_Buffers.Wire_Format.PB_UInt32;
  begin
    Tag := The_Coded_Input_Stream.Read_Tag;
    while Tag /= 0 loop
      case Protocol_Buffers.Wire_Format.Get_Tag_Field_Number (Tag) is
      -- optional .protobuf_unittest.TestRecursiveMessage a = 1;
      when 1 =>
        if Protocol_Buffers.Wire_Format.Get_Tag_Wire_Type (Tag) =
          Protocol_Buffers.Wire_Format.LENGTH_DELIMITED then
          The_Coded_Input_Stream.Read_Message (The_Message.Get_A.all);
        end if;
      -- optional int32 i = 2;
      when 2 =>
        if Protocol_Buffers.Wire_Format.Get_Tag_Wire_Type (Tag) =
          Protocol_Buffers.Wire_Format.VARINT then
          The_Message.I := The_Coded_Input_Stream.Read_Integer_32;
          The_Message.Set_Has_I;
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
    (The_Message : in Unittest.TestRecursiveMessage.Instance) return Protocol_Buffers.Wire_Format.PB_Object_Size is
  begin
    return The_Message.Cached_Size;
  end Get_Cached_Size;

  overriding
  procedure Finalize
    (The_Message : in out Unittest.TestRecursiveMessage.Instance) is
  begin
    declare
      Temp : Protocol_Buffers.Message.Instance_Access := Protocol_Buffers.Message.Instance_Access(The_Message.A);
    begin
      Protocol_Buffers.Message.Free (Temp);
      The_Message.A := null;
    end;
  end Finalize;

  ---------------------------------------------------------------------------
  -- Field accessor definitions ---------------------------------------------
  ---------------------------------------------------------------------------

  -- optional .protobuf_unittest.TestRecursiveMessage a = 1;
  function Has_A
    (The_Message : in TestRecursiveMessage.Instance) return Boolean is
  begin
    return (The_Message.Has_Bits(0) and 16#00000001#) /= 0;
  end Has_A;

  procedure Set_Has_A
    (The_Message : in out TestRecursiveMessage.Instance) is
  begin
    The_Message.Has_Bits(0) := The_Message.Has_Bits(0) or 16#00000001#;
  end Set_Has_A;

  procedure Clear_Has_A
    (The_Message : in out TestRecursiveMessage.Instance) is
  begin
    The_Message.Has_Bits(0) := The_Message.Has_Bits(0) and (not 16#00000001#);
  end Clear_Has_A;

  procedure Clear_A
    (The_Message : in out TestRecursiveMessage.Instance) is
  begin
    The_Message.Clear_Has_A;
    declare
      Temp : Protocol_Buffers.Message.Instance_Access := Protocol_Buffers.Message.Instance_Access(The_Message.A);
    begin
      Protocol_Buffers.Message.Free (Temp);
      The_Message.A := null;
    end;
    The_Message.Clear_Has_A;
  end Clear_A;

  function Get_A
    (The_Message : in out TestRecursiveMessage.Instance) return access Unittest.TestRecursiveMessage.Instance is
    use type Unittest.TestRecursiveMessage.TestRecursiveMessage_Access;
  begin
    The_Message.Set_Has_A;
    if The_Message.A = null then
      The_Message.A := Unittest.TestRecursiveMessage.TestRecursiveMessage_Access'(new Unittest.TestRecursiveMessage.Instance);
    end if;
    return The_Message.A;
  end Get_A;

  function Release_A
    (The_Message : in out TestRecursiveMessage.Instance) return access Unittest.TestRecursiveMessage.Instance is
    Temp : access Unittest.TestRecursiveMessage.Instance;
  begin
    The_Message.Clear_Has_A;
    Temp := The_Message.A;
    The_Message.A := null;
    return Temp;
  end Release_A;

  procedure Set_A
    (The_Message : in out TestRecursiveMessage.Instance;
     Value : in Unittest.TestRecursiveMessage.TestRecursiveMessage_Access) is
    use type Unittest.TestRecursiveMessage.TestRecursiveMessage_Access;
    Temp : Protocol_Buffers.Message.Instance_Access := Protocol_Buffers.Message.Instance_Access (The_Message.A);
  begin
    Protocol_Buffers.Message.Free (Temp);
    The_Message.A := Value;
    if The_Message.A /= null then
      The_Message.Set_Has_A;
    else
      The_Message.Clear_Has_A;
    end if;
  end Set_A;

  -- optional int32 i = 2;
  function Has_I
    (The_Message : in TestRecursiveMessage.Instance) return Boolean is
  begin
    return (The_Message.Has_Bits(0) and 16#00000002#) /= 0;
  end Has_I;

  procedure Set_Has_I
    (The_Message : in out TestRecursiveMessage.Instance) is
  begin
    The_Message.Has_Bits(0) := The_Message.Has_Bits(0) or 16#00000002#;
  end Set_Has_I;

  procedure Clear_Has_I
    (The_Message : in out TestRecursiveMessage.Instance) is
  begin
    The_Message.Has_Bits(0) := The_Message.Has_Bits(0) and (not 16#00000002#);
  end Clear_Has_I;

  procedure Clear_I
    (The_Message : in out TestRecursiveMessage.Instance) is
  begin
    The_Message.I := 0;
    The_Message.Clear_Has_I;
  end Clear_I;

  function Get_I
    (The_Message : in TestRecursiveMessage.Instance) return Protocol_Buffers.Wire_Format.PB_Int32 is
  begin
    return The_Message.I;
  end Get_I;

  procedure Set_I
    (The_Message : in out TestRecursiveMessage.Instance;
     Value : in Protocol_Buffers.Wire_Format.PB_Int32) is
  begin
    The_Message.Set_Has_I;
    The_Message.I := Value;
  end Set_I;

end Unittest.TestRecursiveMessage;
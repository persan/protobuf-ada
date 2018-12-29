-- Generated by the protocol buffer compiler.  DO NOT EDIT!
-- source: unittest.proto

pragma Ada_2012;

with Unittest.TestRequired;

package body Unittest.TestRequiredForeign is
  ---------------------------------------------------------------------------
  -- Inherited functions and procedures from Protocol_Buffers.Message -------
  ---------------------------------------------------------------------------

  procedure Clear
    (The_Message : in out Unittest.TestRequiredForeign.Instance) is
  begin
    if (The_Message.Has_Bits (0 / 32) and Protocol_Buffers.Wire_Format.Shift_Left (16#FF#, 0 mod 32)) /= 0 then
      if The_Message.Has_Optional_Message then
        The_Message.Clear_Has_Optional_Message;
        declare
          Temp : Protocol_Buffers.Message.Instance_Access := Protocol_Buffers.Message.Instance_Access(The_Message.Optional_Message);
        begin
          Protocol_Buffers.Message.Free (Temp);
          The_Message.Optional_Message := null;
        end;
      end if;
      The_Message.Dummy := 0;
    end if;
    for C in The_Message.Repeated_Message.Iterate loop
      Protocol_Buffers.Message.Free (The_Message.Repeated_Message.Reference (C).Element.all);
    end loop;
    The_Message.Repeated_Message.Clear;

    The_Message.Has_Bits := (others => 0);
  end Clear;

  procedure Copy
    (To   : in out Unittest.TestRequiredForeign.Instance;
     From : in Unittest.TestRequiredForeign.Instance) is
  begin
    To.Clear;
    To.Merge (From);
  end Copy;

  function Get_Type_Name
    (The_Message : in Unittest.TestRequiredForeign.Instance) return Protocol_Buffers.Wire_Format.PB_String is
  begin
    return "protobuf_unittest.TestRequiredForeign";
  end Get_Type_Name;

  function Is_Initialized
    (The_Message : in Unittest.TestRequiredForeign.Instance) return Boolean is
  begin
    if The_Message.Has_Optional_Message then
      if not The_Message.Optional_Message.Is_Initialized then
        return false;
      end if;
    end if;
    for E of The_Message.Repeated_Message loop
      if not E.Is_Initialized then
        return False;
      end if;
    end loop;
    return True;
  end Is_Initialized;

  procedure Merge
    (To   : in out Unittest.TestRequiredForeign.Instance;
     From : in Unittest.TestRequiredForeign.Instance) is
  begin
    declare
      Temp : Unittest.TestRequired.TestRequired_Access;
    begin
      for E of From.Repeated_Message loop
        Temp := new Unittest.TestRequired.Instance;
        Temp.Merge (Unittest.TestRequired.Instance (E.all));
        To.Repeated_Message.Append (Protocol_Buffers.Message.Instance_Access (Temp));
      end loop;
    end;
    if (From.Has_Bits (0 / 32) and Protocol_Buffers.Wire_Format.Shift_Left (16#FF#, 0 mod 32)) /= 0 then
      -- optional .protobuf_unittest.TestRequired optional_message = 1;
      if From.Has_Optional_Message then
        To.Get_Optional_Message.Merge (From.Optional_Message.all);
      end if;
      -- optional int32 dummy = 3;
      if From.Has_Dummy then
        To.Set_Dummy (From.Dummy);
      end if;
    end if;
  end Merge;

  function Byte_Size
    (The_Message : in out Unittest.TestRequiredForeign.Instance) return Protocol_Buffers.Wire_Format.PB_Object_Size is
    Total_Size : Protocol_Buffers.Wire_Format.PB_Object_Size := 0;
  begin
    if (The_Message.Has_Bits (0 / 32) and Protocol_Buffers.Wire_Format.Shift_Left (16#FF#, 0 mod 32)) /= 0 then
      -- optional .protobuf_unittest.TestRequired optional_message = 1;
      if The_Message.Has_Optional_Message then
        Total_Size := Total_Size + 1 + Protocol_Buffers.IO.Coded_Output_Stream.Compute_Message_Size_No_Tag (The_Message.Optional_Message.all);
      end if;
      -- optional int32 dummy = 3;
      if The_Message.Has_Dummy then
        Total_Size := Total_Size + 1 + Protocol_Buffers.IO.Coded_Output_Stream.Compute_Integer_32_Size_No_Tag (The_Message.Dummy);
      end if;
    end if;
    -- repeated .protobuf_unittest.TestRequired repeated_message = 2;
    Total_Size := Total_Size + 1 * The_Message.Repeated_Message_Size;
    for E of The_Message.Repeated_Message loop
      Total_Size := Total_Size + Protocol_Buffers.IO.Coded_Output_Stream.Compute_Message_Size_No_Tag (E.all);
    end loop;

    The_Message.Cached_Size := Total_Size;
    return Total_Size;
  end Byte_Size;

  procedure Serialize_With_Cached_Sizes
    (The_Message   : in Unittest.TestRequiredForeign.Instance;
     The_Coded_Output_Stream : in
       Protocol_Buffers.IO.Coded_Output_Stream.Instance) is
  begin
    -- optional .protobuf_unittest.TestRequired optional_message = 1;
    if The_Message.Has_Optional_Message then
      The_Coded_Output_Stream.Write_Message (1, The_Message.Optional_Message.all);
    end if;
    -- repeated .protobuf_unittest.TestRequired repeated_message = 2;
    for E of The_Message.Repeated_Message loop
      The_Coded_Output_Stream.Write_Message (2, E.all);
    end loop;
    -- optional int32 dummy = 3;
    if The_Message.Has_Dummy then
      Protocol_Buffers.IO.Coded_Output_Stream.Write_Integer_32 (The_Coded_Output_Stream, 3, The_Message.Dummy);
    end if;
  end Serialize_With_Cached_Sizes;

  procedure Merge_Partial_From_Coded_Input_Stream
    (The_Message   : in out Unittest.TestRequiredForeign.Instance;
     The_Coded_Input_Stream : in out
       Protocol_Buffers.IO.Coded_Input_Stream.Instance) is
    Tag : Protocol_Buffers.Wire_Format.PB_UInt32;
  begin
    Tag := The_Coded_Input_Stream.Read_Tag;
    while Tag /= 0 loop
      case Protocol_Buffers.Wire_Format.Get_Tag_Field_Number (Tag) is
      -- optional .protobuf_unittest.TestRequired optional_message = 1;
      when 1 =>
        if Protocol_Buffers.Wire_Format.Get_Tag_Wire_Type (Tag) =
          Protocol_Buffers.Wire_Format.LENGTH_DELIMITED then
          The_Coded_Input_Stream.Read_Message (The_Message.Get_Optional_Message.all);
        end if;
      -- repeated .protobuf_unittest.TestRequired repeated_message = 2;
      when 2 =>
        if Protocol_Buffers.Wire_Format.Get_Tag_Wire_Type (Tag) =
          Protocol_Buffers.Wire_Format.LENGTH_DELIMITED then
          declare
            Temp : Unittest.TestRequired.TestRequired_Access := The_Message.Add_Repeated_Message;
          begin
            The_Coded_Input_Stream.Read_Message (Temp.all);
          end;
        end if;
      -- optional int32 dummy = 3;
      when 3 =>
        if Protocol_Buffers.Wire_Format.Get_Tag_Wire_Type (Tag) =
          Protocol_Buffers.Wire_Format.VARINT then
          The_Message.Dummy := The_Coded_Input_Stream.Read_Integer_32;
          The_Message.Set_Has_Dummy;
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
    (The_Message : in Unittest.TestRequiredForeign.Instance) return Protocol_Buffers.Wire_Format.PB_Object_Size is
  begin
    return The_Message.Cached_Size;
  end Get_Cached_Size;

  overriding
  procedure Finalize
    (The_Message : in out Unittest.TestRequiredForeign.Instance) is
  begin
    declare
      Temp : Protocol_Buffers.Message.Instance_Access := Protocol_Buffers.Message.Instance_Access(The_Message.Optional_Message);
    begin
      Protocol_Buffers.Message.Free (Temp);
      The_Message.Optional_Message := null;
    end;
    for C in The_Message.Repeated_Message.Iterate loop
      Protocol_Buffers.Message.Free (The_Message.Repeated_Message.Reference (C).Element.all);
    end loop;
    The_Message.Repeated_Message.Clear;

  end Finalize;

  ---------------------------------------------------------------------------
  -- Field accessor definitions ---------------------------------------------
  ---------------------------------------------------------------------------

  -- optional .protobuf_unittest.TestRequired optional_message = 1;
  function Has_Optional_Message
    (The_Message : in TestRequiredForeign.Instance) return Boolean is
  begin
    return (The_Message.Has_Bits(0) and 16#00000001#) /= 0;
  end Has_Optional_Message;

  procedure Set_Has_Optional_Message
    (The_Message : in out TestRequiredForeign.Instance) is
  begin
    The_Message.Has_Bits(0) := The_Message.Has_Bits(0) or 16#00000001#;
  end Set_Has_Optional_Message;

  procedure Clear_Has_Optional_Message
    (The_Message : in out TestRequiredForeign.Instance) is
  begin
    The_Message.Has_Bits(0) := The_Message.Has_Bits(0) and (not 16#00000001#);
  end Clear_Has_Optional_Message;

  procedure Clear_Optional_Message
    (The_Message : in out TestRequiredForeign.Instance) is
  begin
    The_Message.Clear_Has_Optional_Message;
    declare
      Temp : Protocol_Buffers.Message.Instance_Access := Protocol_Buffers.Message.Instance_Access(The_Message.Optional_Message);
    begin
      Protocol_Buffers.Message.Free (Temp);
      The_Message.Optional_Message := null;
    end;
    The_Message.Clear_Has_Optional_Message;
  end Clear_Optional_Message;

  function Get_Optional_Message
    (The_Message : in out TestRequiredForeign.Instance) return access Unittest.TestRequired.Instance is
    use type Unittest.TestRequired.TestRequired_Access;
  begin
    The_Message.Set_Has_Optional_Message;
    if The_Message.Optional_Message = null then
      The_Message.Optional_Message := Unittest.TestRequired.TestRequired_Access'(new Unittest.TestRequired.Instance);
    end if;
    return The_Message.Optional_Message;
  end Get_Optional_Message;

  function Release_Optional_Message
    (The_Message : in out TestRequiredForeign.Instance) return access Unittest.TestRequired.Instance is
    Temp : access Unittest.TestRequired.Instance;
  begin
    The_Message.Clear_Has_Optional_Message;
    Temp := The_Message.Optional_Message;
    The_Message.Optional_Message := null;
    return Temp;
  end Release_Optional_Message;

  procedure Set_Optional_Message
    (The_Message : in out TestRequiredForeign.Instance;
     Value : in Unittest.TestRequired.TestRequired_Access) is
    use type Unittest.TestRequired.TestRequired_Access;
    Temp : Protocol_Buffers.Message.Instance_Access := Protocol_Buffers.Message.Instance_Access (The_Message.Optional_Message);
  begin
    Protocol_Buffers.Message.Free (Temp);
    The_Message.Optional_Message := Value;
    if The_Message.Optional_Message /= null then
      The_Message.Set_Has_Optional_Message;
    else
      The_Message.Clear_Has_Optional_Message;
    end if;
  end Set_Optional_Message;

  -- repeated .protobuf_unittest.TestRequired repeated_message = 2;
  function Repeated_Message_Size
    (The_Message : in TestRequiredForeign.Instance) return Protocol_Buffers.Wire_Format.PB_Object_Size is
  begin
    return Protocol_Buffers.Wire_Format.PB_Object_Size (The_Message.Repeated_Message.Length);
  end Repeated_Message_Size;

  procedure Clear_Repeated_Message
    (The_Message : in out TestRequiredForeign.Instance) is
  begin
    for C in The_Message.Repeated_Message.Iterate loop
      Protocol_Buffers.Message.Free (The_Message.Repeated_Message.Reference (C).Element.all);
    end loop;
    The_Message.Repeated_Message.Clear;

  end Clear_Repeated_Message;

  function Get_Repeated_Message
    (The_Message : in TestRequiredForeign.Instance;
     Index : in Protocol_Buffers.Wire_Format.PB_Object_Size) return access Unittest.TestRequired.Instance is
  begin
    return Unittest.TestRequired.TestRequired_Access (The_Message.Repeated_Message.Element (Index));
  end Get_Repeated_Message;

  function Add_Repeated_Message
    (The_Message : in out TestRequiredForeign.Instance) return access Unittest.TestRequired.Instance is
    Temp : Unittest.TestRequired.TestRequired_Access := new Unittest.TestRequired.Instance;
  begin
    The_Message.Repeated_Message.Append (Protocol_Buffers.Message.Instance_Access (Temp));
    return Temp;
  end Add_Repeated_Message;

  -- optional int32 dummy = 3;
  function Has_Dummy
    (The_Message : in TestRequiredForeign.Instance) return Boolean is
  begin
    return (The_Message.Has_Bits(0) and 16#00000004#) /= 0;
  end Has_Dummy;

  procedure Set_Has_Dummy
    (The_Message : in out TestRequiredForeign.Instance) is
  begin
    The_Message.Has_Bits(0) := The_Message.Has_Bits(0) or 16#00000004#;
  end Set_Has_Dummy;

  procedure Clear_Has_Dummy
    (The_Message : in out TestRequiredForeign.Instance) is
  begin
    The_Message.Has_Bits(0) := The_Message.Has_Bits(0) and (not 16#00000004#);
  end Clear_Has_Dummy;

  procedure Clear_Dummy
    (The_Message : in out TestRequiredForeign.Instance) is
  begin
    The_Message.Dummy := 0;
    The_Message.Clear_Has_Dummy;
  end Clear_Dummy;

  function Get_Dummy
    (The_Message : in TestRequiredForeign.Instance) return Protocol_Buffers.Wire_Format.PB_Int32 is
  begin
    return The_Message.Dummy;
  end Get_Dummy;

  procedure Set_Dummy
    (The_Message : in out TestRequiredForeign.Instance;
     Value : in Protocol_Buffers.Wire_Format.PB_Int32) is
  begin
    The_Message.Set_Has_Dummy;
    The_Message.Dummy := Value;
  end Set_Dummy;

end Unittest.TestRequiredForeign;

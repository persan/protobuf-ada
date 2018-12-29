-- Generated by the protocol buffer compiler.  DO NOT EDIT!
-- source: unittest.proto

pragma Ada_2012;

package Unittest.ForeignMessage is
  type Instance is new Protocol_Buffers.Message.Instance with private;
  type ForeignMessage_Access is access all Instance;

  ---------------------------------------------------------------------------
  -- Inherited functions and procedures from Protocol_Buffers.Message -------
  ---------------------------------------------------------------------------

  overriding
  procedure Clear
    (The_Message : in out Unittest.ForeignMessage.Instance);

  overriding
  procedure Serialize_With_Cached_Sizes
    (The_Message   : in Unittest.ForeignMessage.Instance;
     The_Coded_Output_Stream : in
       Protocol_Buffers.IO.Coded_Output_Stream.Instance);

  overriding
  procedure Merge_Partial_From_Coded_Input_Stream
    (The_Message   : in out Unittest.ForeignMessage.Instance;
     The_Coded_Input_Stream : in out
       Protocol_Buffers.IO.Coded_Input_Stream.Instance);

  overriding
  procedure Merge
    (To   : in out Unittest.ForeignMessage.Instance;
     From : in Unittest.ForeignMessage.Instance);

  overriding
  procedure Copy
    (To   : in out Unittest.ForeignMessage.Instance;
     From : in Unittest.ForeignMessage.Instance);

  overriding
  function Get_Type_Name
    (The_Message : in Unittest.ForeignMessage.Instance) return Protocol_Buffers.Wire_Format.PB_String;

  overriding
  function Byte_Size
    (The_Message : in out Unittest.ForeignMessage.Instance) return Protocol_Buffers.Wire_Format.PB_Object_Size;

  overriding
  function Get_Cached_Size
    (The_Message : in Unittest.ForeignMessage.Instance) return Protocol_Buffers.Wire_Format.PB_Object_Size;

  overriding
  function Is_Initialized
    (The_Message : in Unittest.ForeignMessage.Instance) return Boolean;

  overriding
  procedure Finalize (The_Message : in out Unittest.ForeignMessage.Instance);

  ---------------------------------------------------------------------------
  -- Field accessor declarations --------------------------------------------
  ---------------------------------------------------------------------------

  -- optional int32 c = 1;
  function Has_C
    (The_Message : in ForeignMessage.Instance) return Boolean;
  procedure Clear_C
    (The_Message : in out ForeignMessage.Instance);
  function Get_C
    (The_Message : in ForeignMessage.Instance) return Protocol_Buffers.Wire_Format.PB_Int32;
  procedure Set_C
    (The_Message : in out ForeignMessage.Instance;
     value : in Protocol_Buffers.Wire_Format.PB_Int32);

private
  type Instance is new Protocol_Buffers.Message.Instance with record
    C : Protocol_Buffers.Wire_Format.PB_Int32 := 0;
    Has_Bits : Protocol_Buffers.Wire_Format.Has_Bits_Array_Type (0 .. (1 + 31) / 32) := (others => 0);
    Cached_Size : Protocol_Buffers.Wire_Format.PB_Object_Size := 0;
  end record;

  procedure Set_Has_C (The_Message : in out Unittest.ForeignMessage.Instance);
  procedure Clear_Has_C (The_Message : in out Unittest.ForeignMessage.Instance);
end Unittest.ForeignMessage;

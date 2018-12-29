-- Generated by the protocol buffer compiler.  DO NOT EDIT!
-- source: unittest.proto

pragma Ada_2012;

limited with Unittest.ForeignMessage;

package Unittest.TestCamelCaseFieldNames is
  type Instance is new Protocol_Buffers.Message.Instance with private;
  type TestCamelCaseFieldNames_Access is access all Instance;

  ---------------------------------------------------------------------------
  -- Inherited functions and procedures from Protocol_Buffers.Message -------
  ---------------------------------------------------------------------------

  overriding
  procedure Clear
    (The_Message : in out Unittest.TestCamelCaseFieldNames.Instance);

  overriding
  procedure Serialize_With_Cached_Sizes
    (The_Message   : in Unittest.TestCamelCaseFieldNames.Instance;
     The_Coded_Output_Stream : in
       Protocol_Buffers.IO.Coded_Output_Stream.Instance);

  overriding
  procedure Merge_Partial_From_Coded_Input_Stream
    (The_Message   : in out Unittest.TestCamelCaseFieldNames.Instance;
     The_Coded_Input_Stream : in out
       Protocol_Buffers.IO.Coded_Input_Stream.Instance);

  overriding
  procedure Merge
    (To   : in out Unittest.TestCamelCaseFieldNames.Instance;
     From : in Unittest.TestCamelCaseFieldNames.Instance);

  overriding
  procedure Copy
    (To   : in out Unittest.TestCamelCaseFieldNames.Instance;
     From : in Unittest.TestCamelCaseFieldNames.Instance);

  overriding
  function Get_Type_Name
    (The_Message : in Unittest.TestCamelCaseFieldNames.Instance) return Protocol_Buffers.Wire_Format.PB_String;

  overriding
  function Byte_Size
    (The_Message : in out Unittest.TestCamelCaseFieldNames.Instance) return Protocol_Buffers.Wire_Format.PB_Object_Size;

  overriding
  function Get_Cached_Size
    (The_Message : in Unittest.TestCamelCaseFieldNames.Instance) return Protocol_Buffers.Wire_Format.PB_Object_Size;

  overriding
  function Is_Initialized
    (The_Message : in Unittest.TestCamelCaseFieldNames.Instance) return Boolean;

  overriding
  procedure Finalize (The_Message : in out Unittest.TestCamelCaseFieldNames.Instance);

  ---------------------------------------------------------------------------
  -- Field accessor declarations --------------------------------------------
  ---------------------------------------------------------------------------

  -- optional int32 PrimitiveField = 1;
  function Has_Primitivefield
    (The_Message : in TestCamelCaseFieldNames.Instance) return Boolean;
  procedure Clear_Primitivefield
    (The_Message : in out TestCamelCaseFieldNames.Instance);
  function Get_Primitivefield
    (The_Message : in TestCamelCaseFieldNames.Instance) return Protocol_Buffers.Wire_Format.PB_Int32;
  procedure Set_Primitivefield
    (The_Message : in out TestCamelCaseFieldNames.Instance;
     value : in Protocol_Buffers.Wire_Format.PB_Int32);

  -- optional string StringField = 2;
  function Has_Stringfield
    (The_Message : in TestCamelCaseFieldNames.Instance) return Boolean;
  procedure Clear_Stringfield
    (The_Message : in out TestCamelCaseFieldNames.Instance);
  function Get_Stringfield
    (The_Message : in TestCamelCaseFieldNames.Instance) return Protocol_Buffers.Wire_Format.PB_String;
  function Get_Stringfield
    (The_Message : in out TestCamelCaseFieldNames.Instance; Size : in Integer := -1) return Protocol_Buffers.Wire_Format.PB_String_Access;
  procedure Set_Stringfield
    (The_Message : in out TestCamelCaseFieldNames.Instance;
     Value : in Protocol_Buffers.Wire_Format.PB_String);
  function Release_Stringfield
    (The_Message : in out TestCamelCaseFieldNames.Instance) return Protocol_Buffers.Wire_Format.PB_String_Access;

  -- optional .protobuf_unittest.ForeignEnum EnumField = 3;
  function Has_Enumfield
    (The_Message : in TestCamelCaseFieldNames.Instance) return Boolean;
  procedure Clear_Enumfield
    (The_Message : in out TestCamelCaseFieldNames.Instance);
  function Get_Enumfield
    (The_Message : in TestCamelCaseFieldNames.Instance) return ForeignEnum;
  procedure Set_Enumfield
    (The_Message : in out TestCamelCaseFieldNames.Instance;
     Value : in ForeignEnum);

  -- optional .protobuf_unittest.ForeignMessage MessageField = 4;
  function Has_Messagefield
    (The_Message : in TestCamelCaseFieldNames.Instance) return Boolean;
  procedure Clear_Messagefield
    (The_Message : in out TestCamelCaseFieldNames.Instance);
  function Get_Messagefield
    (The_Message : in out TestCamelCaseFieldNames.Instance) return access Unittest.ForeignMessage.Instance;
  function Release_Messagefield
    (The_Message : in out TestCamelCaseFieldNames.Instance) return access Unittest.ForeignMessage.Instance;
  procedure Set_Messagefield
    (The_Message : in out TestCamelCaseFieldNames.Instance;
     Value : in Unittest.ForeignMessage.ForeignMessage_Access);

  -- optional string StringPieceField = 5 [ctype = STRING_PIECE];
  function Has_Stringpiecefield
    (The_Message : in TestCamelCaseFieldNames.Instance) return Boolean;
  procedure Clear_Stringpiecefield
    (The_Message : in out TestCamelCaseFieldNames.Instance);
  function Get_Stringpiecefield
    (The_Message : in TestCamelCaseFieldNames.Instance) return Protocol_Buffers.Wire_Format.PB_String;
  function Get_Stringpiecefield
    (The_Message : in out TestCamelCaseFieldNames.Instance; Size : in Integer := -1) return Protocol_Buffers.Wire_Format.PB_String_Access;
  procedure Set_Stringpiecefield
    (The_Message : in out TestCamelCaseFieldNames.Instance;
     Value : in Protocol_Buffers.Wire_Format.PB_String);
  function Release_Stringpiecefield
    (The_Message : in out TestCamelCaseFieldNames.Instance) return Protocol_Buffers.Wire_Format.PB_String_Access;

  -- optional string CordField = 6 [ctype = CORD];
  function Has_Cordfield
    (The_Message : in TestCamelCaseFieldNames.Instance) return Boolean;
  procedure Clear_Cordfield
    (The_Message : in out TestCamelCaseFieldNames.Instance);
  function Get_Cordfield
    (The_Message : in TestCamelCaseFieldNames.Instance) return Protocol_Buffers.Wire_Format.PB_String;
  function Get_Cordfield
    (The_Message : in out TestCamelCaseFieldNames.Instance; Size : in Integer := -1) return Protocol_Buffers.Wire_Format.PB_String_Access;
  procedure Set_Cordfield
    (The_Message : in out TestCamelCaseFieldNames.Instance;
     Value : in Protocol_Buffers.Wire_Format.PB_String);
  function Release_Cordfield
    (The_Message : in out TestCamelCaseFieldNames.Instance) return Protocol_Buffers.Wire_Format.PB_String_Access;

  -- repeated int32 RepeatedPrimitiveField = 7;
  function Repeatedprimitivefield_Size
    (The_Message : in TestCamelCaseFieldNames.Instance) return Protocol_Buffers.Wire_Format.PB_Object_Size;
  procedure Clear_Repeatedprimitivefield
    (The_Message : in out TestCamelCaseFieldNames.Instance);
  function Get_Repeatedprimitivefield
    (The_Message : in TestCamelCaseFieldNames.Instance;
     Index : in Protocol_Buffers.Wire_Format.PB_Object_Size) return Protocol_Buffers.Wire_Format.PB_Int32;
  procedure Set_Repeatedprimitivefield
    (The_Message : in out TestCamelCaseFieldNames.Instance;
     Index : in Protocol_Buffers.Wire_Format.PB_Object_Size;
     Value : in Protocol_Buffers.Wire_Format.PB_Int32);
  procedure Add_Repeatedprimitivefield
    (The_Message : in out TestCamelCaseFieldNames.Instance;
     Value : in Protocol_Buffers.Wire_Format.PB_Int32);

  -- repeated string RepeatedStringField = 8;
  function Repeatedstringfield_Size
    (The_Message : in TestCamelCaseFieldNames.Instance) return Protocol_Buffers.Wire_Format.PB_Object_Size;
  procedure Clear_Repeatedstringfield
    (The_Message : in out TestCamelCaseFieldNames.Instance);
  function Get_Repeatedstringfield
    (The_Message : in TestCamelCaseFieldNames.Instance;
     Index : in Protocol_Buffers.Wire_Format.PB_Object_Size) return Protocol_Buffers.Wire_Format.PB_String;
  procedure Set_Repeatedstringfield
    (The_Message : in out TestCamelCaseFieldNames.Instance;
     Index : in Protocol_Buffers.Wire_Format.PB_Object_Size;
     Value : in Protocol_Buffers.Wire_Format.PB_String);
  procedure Add_Repeatedstringfield
    (The_Message : in out TestCamelCaseFieldNames.Instance; Value : in Protocol_Buffers.Wire_Format.PB_String);

  -- repeated .protobuf_unittest.ForeignEnum RepeatedEnumField = 9;
  function Repeatedenumfield_Size
    (The_Message : in TestCamelCaseFieldNames.Instance) return Protocol_Buffers.Wire_Format.PB_Object_Size;
  procedure Clear_Repeatedenumfield
    (The_Message : in out TestCamelCaseFieldNames.Instance);
  function Get_Repeatedenumfield
    (The_Message : in TestCamelCaseFieldNames.Instance;
     Index : in Protocol_Buffers.Wire_Format.PB_Object_Size) return ForeignEnum;
  procedure Set_Repeatedenumfield
    (The_Message : in out TestCamelCaseFieldNames.Instance;
     Index : in Protocol_Buffers.Wire_Format.PB_Object_Size;
     Value : in ForeignEnum);
  procedure Add_Repeatedenumfield
    (The_Message : in out TestCamelCaseFieldNames.Instance;
     Value : in ForeignEnum);

  -- repeated .protobuf_unittest.ForeignMessage RepeatedMessageField = 10;
  function Repeatedmessagefield_Size
    (The_Message : in TestCamelCaseFieldNames.Instance) return Protocol_Buffers.Wire_Format.PB_Object_Size;
  procedure Clear_Repeatedmessagefield
    (The_Message : in out TestCamelCaseFieldNames.Instance);
  function Get_Repeatedmessagefield
    (The_Message : in TestCamelCaseFieldNames.Instance;
     Index : in Protocol_Buffers.Wire_Format.PB_Object_Size) return access Unittest.ForeignMessage.Instance;
  function Add_Repeatedmessagefield
    (The_Message : in out TestCamelCaseFieldNames.Instance) return access Unittest.ForeignMessage.Instance;

  -- repeated string RepeatedStringPieceField = 11 [ctype = STRING_PIECE];
  function Repeatedstringpiecefield_Size
    (The_Message : in TestCamelCaseFieldNames.Instance) return Protocol_Buffers.Wire_Format.PB_Object_Size;
  procedure Clear_Repeatedstringpiecefield
    (The_Message : in out TestCamelCaseFieldNames.Instance);
  function Get_Repeatedstringpiecefield
    (The_Message : in TestCamelCaseFieldNames.Instance;
     Index : in Protocol_Buffers.Wire_Format.PB_Object_Size) return Protocol_Buffers.Wire_Format.PB_String;
  procedure Set_Repeatedstringpiecefield
    (The_Message : in out TestCamelCaseFieldNames.Instance;
     Index : in Protocol_Buffers.Wire_Format.PB_Object_Size;
     Value : in Protocol_Buffers.Wire_Format.PB_String);
  procedure Add_Repeatedstringpiecefield
    (The_Message : in out TestCamelCaseFieldNames.Instance; Value : in Protocol_Buffers.Wire_Format.PB_String);

  -- repeated string RepeatedCordField = 12 [ctype = CORD];
  function Repeatedcordfield_Size
    (The_Message : in TestCamelCaseFieldNames.Instance) return Protocol_Buffers.Wire_Format.PB_Object_Size;
  procedure Clear_Repeatedcordfield
    (The_Message : in out TestCamelCaseFieldNames.Instance);
  function Get_Repeatedcordfield
    (The_Message : in TestCamelCaseFieldNames.Instance;
     Index : in Protocol_Buffers.Wire_Format.PB_Object_Size) return Protocol_Buffers.Wire_Format.PB_String;
  procedure Set_Repeatedcordfield
    (The_Message : in out TestCamelCaseFieldNames.Instance;
     Index : in Protocol_Buffers.Wire_Format.PB_Object_Size;
     Value : in Protocol_Buffers.Wire_Format.PB_String);
  procedure Add_Repeatedcordfield
    (The_Message : in out TestCamelCaseFieldNames.Instance; Value : in Protocol_Buffers.Wire_Format.PB_String);

private
  type Instance is new Protocol_Buffers.Message.Instance with record
    Primitivefield : Protocol_Buffers.Wire_Format.PB_Int32 := 0;
    Stringfield : Protocol_Buffers.Wire_Format.PB_String_Access := Protocol_Buffers.Generated_Message_Utilities.EMPTY_STRING'Access;
    Enumfield : ForeignEnum := ForeignEnum'(FOREIGN_FOO);
    Messagefield : access Unittest.ForeignMessage.Instance;
    Stringpiecefield : Protocol_Buffers.Wire_Format.PB_String_Access := Protocol_Buffers.Generated_Message_Utilities.EMPTY_STRING'Access;
    Cordfield : Protocol_Buffers.Wire_Format.PB_String_Access := Protocol_Buffers.Generated_Message_Utilities.EMPTY_STRING'Access;
    Repeatedprimitivefield : Protocol_Buffers.Wire_Format.PB_Int32_Vector.Vector;
    Repeatedstringfield : Protocol_Buffers.Wire_Format.PB_String_Access_Vector.Vector;
    Repeatedenumfield : Protocol_Buffers.Wire_Format.PB_Int32_Vector.Vector;
    Repeatedmessagefield : Protocol_Buffers.Message.Message_Vector.Vector;
    Repeatedstringpiecefield : Protocol_Buffers.Wire_Format.PB_String_Access_Vector.Vector;
    Repeatedcordfield : Protocol_Buffers.Wire_Format.PB_String_Access_Vector.Vector;
    Has_Bits : Protocol_Buffers.Wire_Format.Has_Bits_Array_Type (0 .. (12 + 31) / 32) := (others => 0);
    Cached_Size : Protocol_Buffers.Wire_Format.PB_Object_Size := 0;
  end record;

  procedure Set_Has_Primitivefield (The_Message : in out Unittest.TestCamelCaseFieldNames.Instance);
  procedure Clear_Has_Primitivefield (The_Message : in out Unittest.TestCamelCaseFieldNames.Instance);
  procedure Set_Has_Stringfield (The_Message : in out Unittest.TestCamelCaseFieldNames.Instance);
  procedure Clear_Has_Stringfield (The_Message : in out Unittest.TestCamelCaseFieldNames.Instance);
  procedure Set_Has_Enumfield (The_Message : in out Unittest.TestCamelCaseFieldNames.Instance);
  procedure Clear_Has_Enumfield (The_Message : in out Unittest.TestCamelCaseFieldNames.Instance);
  procedure Set_Has_Messagefield (The_Message : in out Unittest.TestCamelCaseFieldNames.Instance);
  procedure Clear_Has_Messagefield (The_Message : in out Unittest.TestCamelCaseFieldNames.Instance);
  procedure Set_Has_Stringpiecefield (The_Message : in out Unittest.TestCamelCaseFieldNames.Instance);
  procedure Clear_Has_Stringpiecefield (The_Message : in out Unittest.TestCamelCaseFieldNames.Instance);
  procedure Set_Has_Cordfield (The_Message : in out Unittest.TestCamelCaseFieldNames.Instance);
  procedure Clear_Has_Cordfield (The_Message : in out Unittest.TestCamelCaseFieldNames.Instance);
end Unittest.TestCamelCaseFieldNames;

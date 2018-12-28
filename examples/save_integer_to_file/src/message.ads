-- Generated by the protocol buffer compiler. DO NOT EDIT!
-- source: message.proto

pragma Ada_2012;

with Protocol_Buffers.Message;
with Protocol_Buffers.Wire_Format;
with Protocol_Buffers.IO.Coded_Output_Stream;
with Protocol_Buffers.IO.Coded_Input_Stream;
with Protocol_Buffers.Generated_Message_Utilities;
with Ada.Streams.Stream_IO;

package Message is
  use type Protocol_Buffers.Wire_Format.TMP_STRING;
  use type Protocol_Buffers.Wire_Format.TMP_UNSIGNED_BYTE;
  use type Protocol_Buffers.Wire_Format.TMP_UNSIGNED_INTEGER;
  use type Protocol_Buffers.Wire_Format.TMP_UNSIGNED_LONG;
  use type Protocol_Buffers.Wire_Format.TMP_DOUBLE;
  use type Protocol_Buffers.Wire_Format.TMP_FLOAT;
  use type Protocol_Buffers.Wire_Format.TMP_BOOLEAN;
  use type Protocol_Buffers.Wire_Format.TMP_INTEGER;
  use type Protocol_Buffers.Wire_Format.TMP_LONG;
  use type Protocol_Buffers.Wire_Format.TMP_FIELD_TYPE;
  use type Protocol_Buffers.Wire_Format.TMP_WIRE_TYPE;
  use type Protocol_Buffers.Wire_Format.TMP_OBJECT_SIZE;


  package Person is
    type Has_Bits_Array_Type is array (Protocol_Buffers.Wire_Format.TMP_UNSIGNED_INTEGER range <>) of Protocol_Buffers.Wire_Format.TMP_UNSIGNED_INTEGER;

    type Instance is new Protocol_Buffers.Message.Instance with private;

    ---------------------------------------------------------------------------
    -- Inherited functions and procedures from Protocol_Buffers.Message -------
    ---------------------------------------------------------------------------

    overriding
    procedure Clear
      (The_Message : in out Person.Instance);

    overriding
    procedure Serialize_With_Cached_Sizes
      (The_Message   : in Person.Instance;
       The_Coded_Output_Stream : in
         Protocol_Buffers.IO.Coded_Output_Stream.Instance);

    overriding
    procedure Merge_Partial_From_Coded_Input_Stream
      (The_Message   : in out Person.Instance;
       The_Coded_Input_Stream : in
         Protocol_Buffers.IO.Coded_Input_Stream.Instance);

    overriding
    procedure Merge
      (To   : in out Person.Instance;
       From : in Person.Instance);

    overriding
    procedure Copy
      (To   : in out Person.Instance;
       From : in Person.Instance);

    overriding
    function Get_Type_Name
      (The_Message : in Person.Instance) return Protocol_Buffers.Wire_Format.TMP_STRING;

    overriding
    function Byte_Size
      (The_Message : in out Person.Instance) return Protocol_Buffers.Wire_Format.TMP_OBJECT_SIZE;

    overriding
    function Get_Cached_Size
      (The_Message : in Person.Instance) return Protocol_Buffers.Wire_Format.TMP_OBJECT_SIZE;

    overriding
    function Is_Initialized
      (The_Message : in Person.Instance) return Boolean;

    ---------------------------------------------------------------------------
    -- Field accessor declarations --------------------------------------------
    ---------------------------------------------------------------------------

    -- required int32 id = 2;
    function Has_Id
      (The_Message : in Person.Instance) return Boolean;
    procedure Clear_Id
      (The_Message : in out Person.Instance);
    function Id
      (The_Message : in Person.Instance) return Protocol_Buffers.Wire_Format.TMP_INTEGER;
    procedure Set_Id
      (The_Message : in out Person.Instance;
       value : in Protocol_Buffers.Wire_Format.TMP_INTEGER);

    -- optional uint32 age = 3;
    function Has_Age
      (The_Message : in Person.Instance) return Boolean;
    procedure Clear_Age
      (The_Message : in out Person.Instance);
    function Age
      (The_Message : in Person.Instance) return Protocol_Buffers.Wire_Format.TMP_UNSIGNED_INTEGER;
    procedure Set_Age
      (The_Message : in out Person.Instance;
       value : in Protocol_Buffers.Wire_Format.TMP_UNSIGNED_INTEGER);

  private
    type Instance is new Protocol_Buffers.Message.Instance with record
      Id : Protocol_Buffers.Wire_Format.TMP_INTEGER := 0;
      Age : Protocol_Buffers.Wire_Format.TMP_UNSIGNED_INTEGER := 0;
      Has_Bits : Has_Bits_Array_Type (0 .. (2 + 31) / 32) := (others => 0);
      Cached_Size : Protocol_Buffers.Wire_Format.TMP_OBJECT_SIZE := 0;
    end record;

    procedure Set_Has_Id (The_Message : in out Person.Instance);
    procedure Clear_Has_Id (The_Message : in out Person.Instance);
    procedure Set_Has_Age (The_Message : in out Person.Instance);
    procedure Clear_Has_Age (The_Message : in out Person.Instance);
  end Person;

end Message;
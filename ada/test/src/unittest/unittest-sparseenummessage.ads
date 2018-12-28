-- Generated by the protocol buffer compiler.  DO NOT EDIT!
-- source: unittest.proto

pragma Ada_2012;

package Unittest.SparseEnumMessage is
  type Instance is new Protocol_Buffers.Message.Instance with private;
  type SparseEnumMessage_Access is access all Instance;

  ---------------------------------------------------------------------------
  -- Inherited functions and procedures from Protocol_Buffers.Message -------
  ---------------------------------------------------------------------------

  overriding
  procedure Clear
    (The_Message : in out Unittest.SparseEnumMessage.Instance);

  overriding
  procedure Serialize_With_Cached_Sizes
    (The_Message   : in Unittest.SparseEnumMessage.Instance;
     The_Coded_Output_Stream : in
       Protocol_Buffers.IO.Coded_Output_Stream.Instance);

  overriding
  procedure Merge_Partial_From_Coded_Input_Stream
    (The_Message   : in out Unittest.SparseEnumMessage.Instance;
     The_Coded_Input_Stream : in out
       Protocol_Buffers.IO.Coded_Input_Stream.Instance);

  overriding
  procedure Merge
    (To   : in out Unittest.SparseEnumMessage.Instance;
     From : in Unittest.SparseEnumMessage.Instance);

  overriding
  procedure Copy
    (To   : in out Unittest.SparseEnumMessage.Instance;
     From : in Unittest.SparseEnumMessage.Instance);

  overriding
  function Get_Type_Name
    (The_Message : in Unittest.SparseEnumMessage.Instance) return Protocol_Buffers.Wire_Format.PB_String;

  overriding
  function Byte_Size
    (The_Message : in out Unittest.SparseEnumMessage.Instance) return Protocol_Buffers.Wire_Format.PB_Object_Size;

  overriding
  function Get_Cached_Size
    (The_Message : in Unittest.SparseEnumMessage.Instance) return Protocol_Buffers.Wire_Format.PB_Object_Size;

  overriding
  function Is_Initialized
    (The_Message : in Unittest.SparseEnumMessage.Instance) return Boolean;

  overriding
  procedure Finalize (The_Message : in out Unittest.SparseEnumMessage.Instance);

  ---------------------------------------------------------------------------
  -- Field accessor declarations --------------------------------------------
  ---------------------------------------------------------------------------

  -- optional .protobuf_unittest.TestSparseEnum sparse_enum = 1;
  function Has_Sparse_Enum
    (The_Message : in SparseEnumMessage.Instance) return Boolean;
  procedure Clear_Sparse_Enum
    (The_Message : in out SparseEnumMessage.Instance);
  function Get_Sparse_Enum
    (The_Message : in SparseEnumMessage.Instance) return TestSparseEnum;
  procedure Set_Sparse_Enum
    (The_Message : in out SparseEnumMessage.Instance;
     Value : in TestSparseEnum);

private
  type Instance is new Protocol_Buffers.Message.Instance with record
    Sparse_Enum : TestSparseEnum := TestSparseEnum'(SPARSE_A);
    Has_Bits : Protocol_Buffers.Wire_Format.Has_Bits_Array_Type (0 .. (1 + 31) / 32) := (others => 0);
    Cached_Size : Protocol_Buffers.Wire_Format.PB_Object_Size := 0;
  end record;

  procedure Set_Has_Sparse_Enum (The_Message : in out Unittest.SparseEnumMessage.Instance);
  procedure Clear_Has_Sparse_Enum (The_Message : in out Unittest.SparseEnumMessage.Instance);
end Unittest.SparseEnumMessage;
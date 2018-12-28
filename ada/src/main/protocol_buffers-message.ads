pragma Ada_2012;

with Ada.Streams.Stream_IO;
with Protocol_Buffers.IO.Coded_Output_Stream;
with Protocol_Buffers.IO.Coded_Input_Stream;
with Protocol_Buffers.Wire_Format;
with Ada.Unchecked_Deallocation;
with Ada.Finalization;
with Ada.Containers.Vectors;

package Protocol_Buffers.Message is
  type Instance is abstract new Ada.Finalization.Controlled with null record;
  type Instance_Access is access all Instance'Class;
  package Message_Vector is new Ada.Containers.Vectors (Protocol_Buffers.Wire_Format.PB_Object_Size, Instance_Access);

  procedure Clear (The_Message : in out Message.Instance) is abstract;

  procedure Serialize_To_Output_Stream
    (The_Message   : in out Message.Instance'Class;
     Output_Stream : not null access
       Ada.Streams.Root_Stream_Type'Class);

  procedure Serialize_To_Coded_Output_Stream
    (The_Message             : in out Message.Instance'Class;
     The_Coded_Output_Stream : in out
       Protocol_Buffers.IO.Coded_Output_Stream.Instance);

  procedure Serialize_Partial_To_Output_Stream
    (The_Message   : in out Message.Instance'Class;
     Output_Stream : not null access
       Ada.Streams.Root_Stream_Type'Class);

  procedure Serialize_Partial_To_Coded_Output_Stream
    (The_Message             : in out Message.Instance'Class;
     The_Coded_Output_Stream : in out
       Protocol_Buffers.IO.Coded_Output_Stream.Instance);

  procedure Serialize_With_Cached_Sizes
    (The_Message             : in Message.Instance;
     The_Coded_Output_Stream : in
       Protocol_Buffers.IO.Coded_Output_Stream.Instance) is abstract;

  procedure Parse_From_Input_Stream
    (The_Message  : in out Message.Instance'Class;
     Input_Stream : not null access
       Ada.Streams.Root_Stream_Type'Class);

  procedure Parse_From_Coded_Input_Stream
    (The_Message            : in out Message.Instance'Class;
     The_Coded_Input_Stream : in out
       Protocol_Buffers.IO.Coded_Input_Stream.Instance);

  procedure Parse_Partial_From_Input_Stream
    (The_Message  : in out Message.Instance'Class;
     Input_Stream : not null access
       Ada.Streams.Root_Stream_Type'Class);

  procedure Parse_Partial_From_Coded_Input_Stream
    (The_Message            : in out Message.Instance'Class;
     The_Coded_Input_Stream : in out
       Protocol_Buffers.IO.Coded_Input_Stream.Instance);

  procedure Merge_From_Input_Stream
    (The_Message  : in out Message.Instance'Class;
     Input_Stream : not null access
       Ada.Streams.Root_Stream_Type'Class);

  procedure Merge_From_Coded_Input_Stream
    (The_Message            : in out Message.Instance'Class;
     The_Coded_Input_Stream : in out
       Protocol_Buffers.IO.Coded_Input_Stream.Instance);

  procedure Merge_Partial_From_Input_Stream
    (The_Message  : in out Message.Instance'Class;
     Input_Stream : not null access
       Ada.Streams.Root_Stream_Type'Class);

  procedure Merge_Partial_From_Coded_Input_Stream
    (The_Message            : in out Message.Instance;
     The_Coded_Input_Stream : in out
       Protocol_Buffers.IO.Coded_Input_Stream.Instance) is abstract;

  procedure Merge (To   : in out Message.Instance;
                   From : in Message.Instance) is abstract;

  procedure Copy (To   : in out Message.Instance;
                  From : in Message.Instance) is abstract;

  function Get_Type_Name
    (The_Message : in Message.Instance) return Protocol_Buffers.Wire_Format.PB_String is abstract;

  function Byte_Size
    (The_Message : in out Message.Instance) return Protocol_Buffers.Wire_Format.PB_Object_Size is abstract;

  function Get_Cached_Size
    (The_Message : in Message.Instance) return Protocol_Buffers.Wire_Format.PB_Object_Size is abstract;

  function Is_Initialized
    (The_Message : in Message.Instance) return Boolean is abstract;

  procedure Free is
    new Ada.Unchecked_Deallocation (Instance'Class, Instance_Access);

end Protocol_Buffers.Message;

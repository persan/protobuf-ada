pragma Ada_2012;

with Ada.Streams.Stream_IO;
with Protocol_Buffers.IO.Coded_Output_Stream;
with Protocol_Buffers.IO.Coded_Input_Stream;
with Protocol_Buffers.Wire_Format;

package Protocol_Buffers.Message is
   type Instance is abstract tagged limited private;

   procedure Clear (The_Message : in out Message.Instance) is abstract;

   procedure Merge_Partial_From_Coded_Input_Stream
     (The_Message            : in out Message.Instance;
      The_Coded_Input_Stream : in
        Protocol_Buffers.IO.Coded_Input_Stream.Instance) is abstract;

   procedure Serialize_To_Output_Stream
     (The_Message   : in Message.Instance'Class;
      Output_Stream : in not null
        Ada.Streams.Stream_IO.Stream_Access);

   procedure Serialize_Partial_To_Output_Stream
     (The_Message   : in Message.Instance'Class;
      Output_Stream : in not null
        Ada.Streams.Stream_IO.Stream_Access);

   procedure Serialize_With_Cached_Sizes
     (The_Message             : in Message.Instance;
      The_Coded_Output_Stream : in
        Protocol_Buffers.IO.Coded_Output_Stream.Instance) is abstract;

   procedure Parse_From_Input_Stream
     (The_Message  : in out Message.Instance'Class;
      Input_Stream : in not null
        Ada.Streams.Stream_IO.Stream_Access);

   procedure Parse_Partial_From_Input_Stream
     (The_Message  : in out Message.Instance'Class;
      Input_Stream : in not null
        Ada.Streams.Stream_IO.Stream_Access);

   procedure Merge_From_Input_Stream
     (The_Message  : in out Message.Instance'Class;
      Input_Stream : in not null
        Ada.Streams.Stream_IO.Stream_Access);

   procedure Merge_Partial_From_Input_Stream
     (The_Message  : in out Message.Instance'Class;
      Input_Stream : in not null
        Ada.Streams.Stream_IO.Stream_Access);

   procedure Merge (To   : in out Message.Instance;
                    From : in Message.Instance) is abstract;

   procedure Copy (To   : in out Message.Instance;
                   From : in Message.Instance) is abstract;

   function Get_Type_Name
     (The_Message : in Message.Instance) return Protocol_Buffers.Wire_Format.TMP_STRING is abstract;

   function Byte_Size
     (The_Message : in out Message.Instance) return Protocol_Buffers.Wire_Format.TMP_OBJECT_SIZE is abstract;

   function Get_Cached_Size
     (The_Message : in Message.Instance) return Protocol_Buffers.Wire_Format.TMP_OBJECT_SIZE is abstract;

   function Is_Initialized
     (The_Message : in Message.Instance) return Boolean is abstract;

private
   type Instance is abstract tagged limited null record;
end Protocol_Buffers.Message;

pragma Ada_2012;

package body Protocol_Buffers.Message is

   ------------------------------------------
   -- Inline_Merge_From_Coded_Input_Stream --
   ------------------------------------------

   procedure Inline_Merge_From_Coded_Input_Stream
     (The_Message            : in out Message.Instance'Class;
      The_Coded_Input_Stream : in
        Protocol_Buffers.IO.Coded_Input_Stream.Instance)
   is
   begin
      The_Message.Merge_Partial_From_Coded_Input_Stream (The_Coded_Input_Stream);
      pragma Compile_Time_Warning (Standard.True, "Inline_Merge_From_Coded_Input_Stream contains only temporary implementation ...");
   end Inline_Merge_From_Coded_Input_Stream;


   --------------------------------
   -- Serialize_To_Output_Stream --
   --------------------------------

   procedure Serialize_To_Output_Stream
     (The_Message   : in Message.Instance'Class;
      Output_Stream : in not null
        Ada.Streams.Stream_IO.Stream_Access)
   is
   begin
      pragma Compile_Time_Warning (Standard.True, "Serialize_To_Output_Stream should signal error when message has not been initialized");
      if The_Message.Is_Initialized then
         The_Message.Serialize_Partial_To_Output_Stream (Output_Stream);
      end if;
   end Serialize_To_Output_Stream;

   ----------------------------------------
   -- Serialize_Partial_To_Output_Stream --
   ----------------------------------------

   procedure Serialize_Partial_To_Output_Stream
     (The_Message   : in Message.Instance'Class;
      Output_Stream : in not null
        Ada.Streams.Stream_IO.Stream_Access)
   is
      A_Coded_Output_Stream : Protocol_Buffers.IO.Coded_Output_Stream.Instance
        (Protocol_Buffers.IO.Coded_Output_Stream.Root_Stream_Access (Output_Stream));
   begin
      The_Message.Serialize_With_Cached_Sizes (A_Coded_Output_Stream);
      pragma Compile_Time_Warning (Standard.True, "Serialize_Partial_To_Output_Stream contains only temporary implementation ...");
   end Serialize_Partial_To_Output_Stream;

   -----------------------------
   -- Parse_From_Input_Stream --
   -----------------------------

   procedure Parse_From_Input_Stream
     (The_Message  : in out Message.Instance'Class;
      Input_Stream : in not null
        Ada.Streams.Stream_IO.Stream_Access)
   is
      A_Coded_Input_Stream : Protocol_Buffers.IO.Coded_Input_Stream.Instance
        (Protocol_Buffers.IO.Coded_Input_Stream.Root_Stream_Access (Input_Stream));
   begin
      The_Message.Clear;
      Inline_Merge_From_Coded_Input_Stream (The_Message, A_Coded_Input_Stream);
      pragma Compile_Time_Warning (Standard.True, "Parse_From_Input_Stream contains only temporary implementation ...");
   end Parse_From_Input_Stream;

   -------------------------------------
   -- Parse_Partial_From_Input_Stream --
   -------------------------------------

   procedure Parse_Partial_From_Input_Stream
     (The_Message  : in out Message.Instance'Class;
      Input_Stream : in not null
        Ada.Streams.Stream_IO.Stream_Access)
   is
      A_Coded_Input_Stream : Protocol_Buffers.IO.Coded_Input_Stream.Instance
        (Protocol_Buffers.IO.Coded_Input_Stream.Root_Stream_Access (Input_Stream));
   begin
      The_Message.Clear;
      Inline_Merge_From_Coded_Input_Stream (The_Message, A_Coded_Input_Stream);
   end Parse_Partial_From_Input_Stream;

   -----------------------------
   -- Merge_From_Input_Stream --
   -----------------------------

   procedure Merge_From_Input_Stream
     (The_Message  : in out Message.Instance'Class;
      Input_Stream : in not null
        Ada.Streams.Stream_IO.Stream_Access)
   is
      A_Coded_Input_Stream : Protocol_Buffers.IO.Coded_Input_Stream.Instance
        (Protocol_Buffers.IO.Coded_Input_Stream.Root_Stream_Access (Input_Stream));
   begin
      Inline_Merge_From_Coded_Input_Stream (The_Message, A_Coded_Input_Stream);
      pragma Compile_Time_Warning (Standard.True, "Merge_From_Input_Stream contains only temporary implementation ...");
   end Merge_From_Input_Stream;

   -----------------------------
   -- Merge_Partial_From_Input_Stream --
   -----------------------------

   procedure Merge_Partial_From_Input_Stream
     (The_Message  : in out Message.Instance'Class;
      Input_Stream : in not null
        Ada.Streams.Stream_IO.Stream_Access)
   is
      A_Coded_Input_Stream : Protocol_Buffers.IO.Coded_Input_Stream.Instance
        (Protocol_Buffers.IO.Coded_Input_Stream.Root_Stream_Access (Input_Stream));
   begin
      Inline_Merge_From_Coded_Input_Stream (The_Message, A_Coded_Input_Stream);
   end Merge_Partial_From_Input_Stream;

end Protocol_Buffers.Message;

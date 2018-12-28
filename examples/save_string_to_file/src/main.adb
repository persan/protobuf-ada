with Ada.Streams.Stream_IO,
     Message,
     Ada.Text_IO,
     Protocol_Buffers.Message;
with Protocol_Buffers.Wire_Format;

procedure Main is
   Person : Message.Person.Instance;
begin
   declare
      Person        : Message.Person.Instance;
      Output_Stream : Ada.Streams.Stream_IO.Stream_Access;
      Some_File     : Ada.Streams.Stream_IO.File_Type;
   begin
      Person.Set_Name ("Joakim");
      Person.Set_Id  (2);

      Ada.Text_IO.Put_Line ("Instance to save to file:");
      Ada.Text_IO.Put_Line ("Age: " & String(Person.Name));
      Ada.Text_IO.Put_Line ("Id:  " & Person.Id'Img);

      Ada.Streams.Stream_IO.Create (File => Some_File,
                                    Name => "asdfk.dat");

      Output_Stream := Ada.Streams.Stream_IO.Stream (Some_File);

      Protocol_Buffers.Message.Serialize_Partial_To_Output_Stream (The_Message   => Person,
                                                                   Output_Stream => Output_Stream);

      Ada.Streams.Stream_IO.Close (Some_File);
   end;

   declare
      Person2 : Message.Person.Instance;
      Input_Stream : Ada.Streams.Stream_IO.Stream_Access;
      Input_File   : Ada.Streams.Stream_IO.File_Type;
   begin
      Ada.Streams.Stream_IO.Open (File => Input_File,
                                  Mode => Ada.Streams.Stream_IO.In_File,
                                  Name => "asdfk.dat");

      Input_Stream := Ada.Streams.Stream_IO.Stream (Input_File);

      Protocol_Buffers.Message.Parse_From_Input_Stream (The_Message  => Person2,
                                                        Input_Stream => Input_Stream);

      Ada.Text_IO.Put_Line ("Instance to read from file:");
      Ada.Text_IO.Put_Line ("Age: " & String (Person2.Name));
      Ada.Text_IO.Put_Line ("Id:  " & Person2.Id'Img);

      Ada.Streams.Stream_IO.Close (Input_File);
   end;
end Main;

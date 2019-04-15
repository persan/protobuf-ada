with Tutorial.IO;
with Ada.Streams.Stream_IO;
with Ada.Command_Line;
with ADa.Directories;
with Tutorial.AddressBook;
with Tutorial.Person;
with Tutorial.Person.PhoneNumber;
with Ada.Text_IO;
with Ada.Command_Line;

procedure Tutorial.Add_Person is
   use  Tutorial.IO;
   DataFile : constant String := (if Ada.Command_Line.Argument_Count = 1 then
                                     Ada.Command_Line.Argument (1)
                                  else
                                     "ADDRESS_BOOK_FILE");

   Address_Book : AddressBook.Instance;
begin
   if Ada.Directories.Exists (DataFile) then
      declare
         Input        : Ada.Streams.Stream_IO.File_Type;

      begin
         Ada.Streams.Stream_IO.Open (File => Input,
                                     Mode => Ada.Streams.Stream_IO.In_File,
                                     Name => DataFile);
         Address_Book.Parse_From_Input_Stream (Ada.Streams.Stream_IO.Stream (Input));
         Ada.Streams.Stream_IO.Close (Input);
      end;
   end if;

   declare
      Output        : Ada.Streams.Stream_IO.File_Type;

   begin
      Ada.Streams.Stream_IO.Create (File => Output,
                                    Mode => Ada.Streams.Stream_IO.Out_File,
                                    Name => DataFile);
      Address_Book.Parse_From_Input_Stream (Ada.Streams.Stream_IO.Stream (Output));
      Ada.Streams.Stream_IO.Close (Output);
   end;

end Tutorial.Add_Person;

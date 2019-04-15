with Tutorial.AddressBook;
with Tutorial.Person;
with Tutorial.Person.PhoneNumber;
with Ada.Text_IO;
with Ada.Command_Line;
procedure Tutorial.List_Person is

   procedure ListPeople (Address_Book : AddressBook.Instance) is
   begin
      for Ix in 1 .. Address_Book.Person_Size loop
         declare
            Person : Tutorial.Person.Person_Access := Address_Book.Get_Person (Ix - 1);
         begin
            Ada.Text_IO.Put_Line ( "Person ID:" & Person.Get_Id'Img);
            Ada.Text_IO.Put_Line ( "  Name:" &  Person.Get_Name);
            Ada.Text_IO.Put_Line ( "  E-mail address:" &  Person.Get_Email);

--              for Phone_Number of Person.Phone loop
--                 Ada.Text_IO.Put_Line ((case Phone_Number.Get_Type_Pb is
--                                          when Enumeration.Person.MOBILE => "  Mobile phone #:",
--                                          when Enumeration.Person.HOME   => "  Home phone #:",
--                                          when Enumeration.Person.WORK   => "  Work phone #:") &
--                                          Phone_Number.Get_Number);
--              end loop;

            for P_Ix in 1 .. Person.Phone_Size loop
               declare
                  Phone_Number : Tutorial.Person.PhoneNumber.PhoneNumber_Access := Person.Get_Phone (P_Ix - 1);
               begin
                  Ada.Text_IO.Put_Line ((case Phone_Number.Get_Type_Pb is
                                           when Enumeration.Person.MOBILE => "  Mobile phone #:",
                                           when Enumeration.Person.HOME   => "  Home phone #:",
                                           when Enumeration.Person.WORK   => "  Work phone #:") &
                                           Phone_Number.Get_Number);
               end;

            end loop;
         end;
      end loop;
   end ListPeople;

begin
   declare
      Address_Book : AddressBook.Instance;
      Input        : Ada.Streams.Stream_IO.File_Type;

   begin
      Ada.Streams.Stream_IO.Open (File => Input,
                                  Mode => Ada.Streams.Stream_IO.In_File,
                                  Name => (if Ada.Command_Line.Argument_Count = 1
                                           then
                                              Ada.Command_Line.Argument (1)
                                           else
                                              "ADDRESS_BOOK_FILE"));

      Address_Book.Parse_From_Input_Stream (Ada.Streams.Stream_IO.Stream (Input));

      Ada.Streams.Stream_IO.Close (Input);

      ListPeople (Address_Book);
   end;
end Tutorial.List_Person;

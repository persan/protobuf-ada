with Message,
     Ada.Text_IO;

procedure Main is
   Person : Message.Person.Instance;
begin
   Person.Set_Age (5);
   Person.Set_Id  (2);
   Ada.Text_IO.Put_Line ("Age: " & Person.Age'Img);
   Ada.Text_IO.Put_Line ("Id:  " & Person.Id'Img);
end Main;

-- This is how the one would like to use Google Protocol Buffers:
--  procedure Main is
--     Person : Message.Person_Type;
--  begin
--     Person.Set_Age(5);
--     Person.Set_Id (2);
--     Ada.Text_IO.Put_Line ("Age: " & Person.Get_Age'Img);
--     Ada.Text_IO.Put_Line ("Id:  " & Person.Get_Id'Img);
--  end Main;

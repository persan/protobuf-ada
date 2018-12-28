with Message,
     Ada.Text_IO;

procedure Main is
   Person : Message.Person.Instance;
begin
   Person.Set_Name ("Joakim");
   Person.Set_Id  (2);
   Ada.Text_IO.Put_Line ("Age: " & String(Person.Name));
   Ada.Text_IO.Put_Line ("Id:  " & Person.Id'Img);
end Main;

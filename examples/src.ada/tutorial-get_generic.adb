pragma Ada_2012;
with Tutorial.IO; use Tutorial.IO;
with Ada.Text_IO; use Ada.Text_IO;
function Tutorial.Get_Generic (Prompt : String) return Enum is
begin
   loop
      begin
         return Enum'Value (Tutorial.Io.Get (Prompt));
      exception
         when others =>
            Put_Line ("Invalid value");
      end;
   end loop;
end Tutorial.Get_Generic;

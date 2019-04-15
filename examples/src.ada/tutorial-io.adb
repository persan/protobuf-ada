pragma Ada_2012;
with ADa.Text_IO;
package body Tutorial.IO is
   use ADa.Text_IO;
   function Get (Prompt : String) return STring is
   begin
      Ada.Text_IO.Put (Prompt);
      return Ada.Text_IO.Get_Line;
   end;

   function Get (Prompt : String) return Integer is
   begin
      loop
         begin
            return Integer'Value (Get (Prompt));
         exception
            when others =>
               Put_Line ("Invalid value");
         end;
      end loop;
   end;

   function Get (Prompt : String) return Float is
   begin
      loop
         begin
            return Float'Value (Get (Prompt));
         exception
            when others =>
               Put_Line ("Invalid value");
         end;
      end loop;
   end;

end Tutorial.IO;

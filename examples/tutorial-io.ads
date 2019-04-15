with Ada.Text_IO;
with Tutorial.Get_Generic;
package Tutorial.IO is

   function Get (Prompt : String) return STring;
   function Get (Prompt : String) return Integer;
   function Get (Prompt : String) return Float;

   function Get is new Get_Generic(Enumeration.Person.PhoneType);

end Tutorial.IO;

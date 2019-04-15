pragma Ada_2012;
package body Google.Protobuf.Assertions is

   -------------------
   -- Generic_Equal --
   -------------------

   procedure Generic_Equal
     (Expected    : in Value_Type; Actual : in Value_Type;
      Source_Info : in String  := GNAT.Source_Info.File;
      File_Info   : in Natural := GNAT.Source_Info.Line)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True,
         "Generic_Equal unimplemented");
      raise Program_Error with "Unimplemented procedure Generic_Equal";
   end Generic_Equal;

   ------------------
   -- Assert_Equal --
   ------------------

   procedure Assert_Equal
     (Expected    : in Google.Protobuf.Wire_Format.PB_String;
      Actual      : in Google.Protobuf.Wire_Format.PB_String;
      Source_Info : in String  := GNAT.Source_Info.File;
      File_Info   : in Natural := GNAT.Source_Info.Line)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True,
         "Assert_Equal unimplemented");
      raise Program_Error with "Unimplemented procedure Assert_Equal";
   end Assert_Equal;

   -----------------
   -- Assert_True --
   -----------------

   procedure Assert_True
     (Actual    : in Boolean; Source_Info : in String := GNAT.Source_Info.File;
      File_Info : in Natural := GNAT.Source_Info.Line)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Assert_True unimplemented");
      raise Program_Error with "Unimplemented procedure Assert_True";
   end Assert_True;

   ------------------
   -- Assert_False --
   ------------------

   procedure Assert_False
     (Actual    : in Boolean; Source_Info : in String := GNAT.Source_Info.File;
      File_Info : in Natural := GNAT.Source_Info.Line)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True,
         "Assert_False unimplemented");
      raise Program_Error with "Unimplemented procedure Assert_False";
   end Assert_False;

end Google.Protobuf.Assertions;

package body Google.Protobuf.Generic_Assertions.Assertions is

  procedure Assert_Equal
    (Expected    : in Google.Protobuf.Wire_Format.PB_String;
     Actual      : in Google.Protobuf.Wire_Format.PB_String;
     Source_Info : in String := GNAT.Source_Info.File;
     File_Info   : in Natural := GNAT.Source_Info.Line)
  is
  begin
    Assert (Expected = Actual, "", Source_Info, File_Info);
  end Assert_Equal;

  procedure Assert_True
    (Actual      : in Boolean;
     Source_Info : in String := GNAT.Source_Info.File;
     File_Info   : in Natural := GNAT.Source_Info.Line)
  is
  begin
    Assert (Actual, "", Source_Info, File_Info);
  end Assert_True;

  procedure Assert_False
    (Actual      : in Boolean;
     Source_Info : in String := GNAT.Source_Info.File;
     File_Info   : in Natural := GNAT.Source_Info.Line)
  is
  begin
    Assert (not Actual, "", Source_Info, File_Info);
  end Assert_False;

end Google.Protobuf.Generic_Assertions.Assertions;

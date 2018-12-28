with AUnit.Assertions;

package body Protocol_Buffers.Generic_Assertions is

  procedure Assert
    (Condition   : in Boolean;
     Message     : in String;
     Source_Info : in String := GNAT.Source_Info.File;
     File_Info   : in Natural := GNAT.Source_Info.Line) renames AUnit.Assertions.Assert;

  -------------------
  -- Generic_Equal --
  -------------------

  procedure Generic_Equal
    (Expected    : in Value_Type;
     Actual      : in Value_Type;
     Source_Info : in String := GNAT.Source_Info.File;
     File_Info   : in Natural := GNAT.Source_Info.Line)
  is
  begin
    Assert (Expected = Actual, "", Source_Info, File_Info);
  end Generic_Equal;

end Protocol_Buffers.Generic_Assertions;

with AUnit.Test_Suites; use AUnit.Test_Suites;

with Coded_Input_Stream_Tests;
with Coded_Output_Stream_Tests;
with Message_Tests;

package body Composite_Suite is

  Result : aliased Test_Suite;
  Test_1 : aliased Coded_Input_Stream_Tests.Test_Case;
  Test_2 : aliased Coded_Output_Stream_Tests.Test_Case;
  Test_3 : aliased Message_Tests.Test_Case;

  -----------
  -- Suite --
  -----------

  function Suite return Access_Test_Suite is
  begin
    Add_Test (Result'Access, Test_1'Access);
    Add_Test (Result'Access, Test_2'Access);
    Add_Test (Result'Access, Test_3'Access);
    return Result'Access;
  end Suite;

end Composite_Suite;

with AUnit.Test_Suites; use AUnit.Test_Suites;

package Composite_Suite is
  function Suite return AUnit.Test_Suites.Access_Test_Suite;
  -- Return the test suite.
end Composite_Suite;

with AUnit.Test_Cases; use AUnit;

package Message_Tests is

  type Test_Case is new
    AUnit.Test_Cases.Test_Case with null record;

  procedure Register_Tests (T : in out Test_Case);
  --  Register routines to be run

  function Name (T : Test_Case)
                 return Test_String;
  --  Returns name identifying the test case

  -------------------
  -- Test Routines --
  -------------------

  procedure Test_Floating_Point_Defaults (T : in out Test_Cases.Test_Case'Class);
  -- Tests default values set for floating point fields.

  procedure Test_Extreme_Small_Integer_Defaults (T : in out Test_Cases.Test_Case'Class);
  -- Tests extreme default values set for integer fields.

  procedure Test_String_Defaults (T : in out Test_Cases.Test_Case'Class);
  -- Tests default values set for string fields.

  procedure Test_Required (T : in out Test_Cases.Test_Case'Class);
  -- Tests that Is_Initialized returns false when required fields are missing.

  procedure Test_Required_Foreign (T : in out Test_Cases.Test_Case'Class);
  -- Tests that Is_Initialized returns false when required fields are missing in
  -- nested messages.

  procedure Test_Really_Large_Tag_Number (T : in out Test_Cases.Test_Case'Class);
  -- Tests that really large tag numbers don't break anything.

  procedure Test_Mutual_Recursion (T : in out Test_Cases.Test_Case'Class);
  -- Tests that mutually recursive message works.

  procedure Test_Enumeration_Values_In_Case_Statement (T : in out Test_Cases.Test_Case'Class);
  -- Tests that nested enumeration values can be used in case statements.

  procedure Test_Accessors (T : in out Test_Cases.Test_Case'Class);
  -- Tests setting field values for all protocol buffer types.

  procedure Test_Clear (T : in out Test_Cases.Test_Case'Class);
  -- Tests clearing a message with all fields set.

  procedure Test_Clear_One_Field (T : in out Test_Cases.Test_Case'Class);
  -- Set every field to a unique value, then clear one value and insure that
  -- only that one value is cleared.

end Message_Tests;

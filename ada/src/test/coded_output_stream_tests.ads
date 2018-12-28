with AUnit.Test_Cases; use AUnit;

package Coded_Output_Stream_Tests is

  type Test_Case is new
    AUnit.Test_Cases.Test_Case with null record;

  procedure Register_Tests (T : in out Test_Case);
  --  Register routines to be run.

  function Name (T : Test_Case)
                 return Test_String;
  --  Returns name identifying the test case.

  -------------------
  -- Test Routines --
  -------------------

  procedure Test_Encode_Zig_Zag_32 (T : in out Test_Cases.Test_Case'Class);
  -- Tests ZigZag 32 encoding of various numbers.

  procedure Test_Encode_Zig_Zag_64 (T : in out Test_Cases.Test_Case'Class);
  -- Tests ZigZag 64 encoding of various numbers.

  procedure Test_Write_Raw_Little_Endian_32 (T : in out Test_Cases.Test_Case'Class);
  -- Tests writing 32-bits raw little endian numbers.

  procedure Test_Write_Raw_Little_Endian_64 (T : in out Test_Cases.Test_Case'Class);
  -- Tests writing 64-bits raw little endian numbers.

  procedure Test_Write_Raw_Varint_32 (T : in out Test_Cases.Test_Case'Class);
  -- Tests writing various bytes to a stream using Write_Raw_Varint_32.

  procedure Test_Write_Raw_Varint_64 (T : in out Test_Cases.Test_Case'Class);
  -- Tests writing various bytes to a stream using Write_Raw_Varint_64.
end Coded_Output_Stream_Tests;

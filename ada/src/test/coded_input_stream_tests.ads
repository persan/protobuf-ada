with AUnit.Test_Cases; use AUnit;

package Coded_Input_Stream_Tests is

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

  procedure Test_Decode_Zig_Zag_32 (T : in out Test_Cases.Test_Case'Class);
  -- Tests ZigZag 32 decoding of various numbers.

  procedure Test_Decode_Zig_Zag_64 (T : in out Test_Cases.Test_Case'Class);
  -- Tests ZigZag 64 decoding of various numbers.

  procedure Test_Read_Raw_Little_Endian_32 (T : in out Test_Cases.Test_Case'Class);
  -- Tests reading various bytes from a stream using Read_Raw_Little_Endian_32.

  procedure Test_Read_Raw_Little_Endian_64 (T : in out Test_Cases.Test_Case'Class);
  -- Tests reading various bytes from a stream using Read_Raw_Little_Endian_64.

  procedure Test_Read_Raw_Varint_32 (T : in out Test_Cases.Test_Case'Class);
  -- Tests reading various bytes from a stream using Read_Raw_Varint_32.

  procedure Test_Read_Raw_Varint_64 (T : in out Test_Cases.Test_Case'Class);
  -- Tests reading various bytes from a stream using Read_Raw_Varint_64.

  procedure Test_Invalid_Tag (T : in out Test_Cases.Test_Case'Class);
  -- Tests reading an invalid tag.

  procedure Test_Size_Limit (T : in out Test_Cases.Test_Case'Class);
  -- Tests reading past size limit.

  procedure Test_Malicious_Recursion (T : in out Test_Cases.Test_Case'Class);
  -- Tests recursion limit for messages.

  procedure Test_Reset_Size_Counter (T : in out Test_Cases.Test_Case'Class);
  -- Tests reset size counter.

  procedure Test_Write_And_Read_Whole_Message (T : in out Test_Cases.Test_Case'Class);
  -- Tests writing and reading a whole message with every field type set.

  procedure Test_Write_And_Read_Huge_Blob (T : in out Test_Cases.Test_Case'Class);
  -- Tests writing and reading a huge blob stored inside a message along with
  -- other fields.

  procedure Test_Read_Maliciously_Large_Blob (T : in out Test_Cases.Test_Case'Class);
  -- Tests reading a maliciously large blob.
end Coded_Input_Stream_Tests;

with AUnit.Assertions;
with GNAT.Source_Info;
with Google.Protobuf.Wire_Format;
with Google.Protobuf.IO.Coded_Output_Stream;
with Google.Protobuf.IO.Coded_Input_Stream;
with Ada.Streams;
with Ada.Unchecked_Conversion;
with Test_Helpers;

package body Coded_Output_Stream_Tests is

  procedure Assert
    (Condition : Boolean;
     Message   : String;
     Source    : String := GNAT.Source_Info.File;
     Line      : Natural := GNAT.Source_Info.Line) renames AUnit.Assertions.Assert;
  package COS renames Google.Protobuf.IO.Coded_Output_Stream;
  package CIS renames Google.Protobuf.IO.Coded_Input_Stream;
  package AS renames Ada.Streams;

  ----------
  -- Name --
  ----------

  function Name (T : Test_Case)
                  return Test_String is
    pragma Unreferenced (T);
  begin
    return Format ("Coded_Output_Stream_Tests");
  end Name;

  --------------------
  -- Register_Tests --
  --------------------

  procedure Register_Tests (T : in out Test_Case) is
    procedure Register_Routine
      (Test    : in out AUnit.Test_Cases.Test_Case'Class;
       Routine : AUnit.Test_Cases.Test_Routine;
       Name    : String) renames AUnit.Test_Cases.Registration.Register_Routine;
  begin
    Register_Routine
      (Test    => T,
       Routine => Test_Encode_Zig_Zag_32'Access,
       Name    => "Test_Encode_Zig_Zag_32");
    Register_Routine
      (Test    => T,
       Routine => Test_Encode_Zig_Zag_64'Access,
       Name    => "Test_Encode_Zig_Zag_64");
    Register_Routine
      (Test    => T,
       Routine => Test_Write_Raw_Little_Endian_32'Access,
       Name    => "Test_Write_Raw_Little_Endian_32");
    Register_Routine
      (Test    => T,
       Routine => Test_Write_Raw_Little_Endian_64'Access,
       Name    => "Test_Write_Raw_Little_Endian_64");
    Register_Routine
      (Test    => T,
       Routine => Test_Write_Raw_Varint_32'Access,
       Name    => "Test_Write_Raw_Varint_32");
    Register_Routine
      (Test    => T,
       Routine => Test_Write_Raw_Varint_64'Access,
       Name    => "Test_Write_Raw_Varint_64");
  end Register_Tests;

  ----------------------------
  -- Test_Encode_Zig_Zag_32 --
  ----------------------------

  procedure Test_Encode_Zig_Zag_32 (T : in out Test_Cases.Test_Case'Class) is
    pragma Unreferenced (T);

    use type Google.Protobuf.Wire_Format.PB_UInt32;
    use type Google.Protobuf.Wire_Format.PB_Int32;

    function Convert is
      new Ada.Unchecked_Conversion (Google.Protobuf.Wire_Format.PB_UInt32,
                                    Google.Protobuf.Wire_Format.PB_Int32);
  begin
    Assert (0 = COS.Encode_Zig_Zag_32 (0),
            "Expected: 0 = Encode_Zig_Zag_32 (0)");
    Assert (1 = COS.Encode_Zig_Zag_32 (-1),
            "Expected: -1 = Encode_Zig_Zag_32 (1)");
    Assert (2 = COS.Encode_Zig_Zag_32 (1),
            "Expected: 1 = Encode_Zig_Zag_32 (2)");
    Assert (3 = COS.Encode_Zig_Zag_32 (-2),
            "Expected: -2 = Encode_Zig_Zag_32 (3)");
    Assert (4 = COS.Encode_Zig_Zag_32 (2),
            "Expected: 2 = Encode_Zig_Zag_32 (4)");
    Assert (16#7FFF_FFFE# = COS.Encode_Zig_Zag_32 (16#3FFF_FFFF#),
            "Expected: 0x7FFFFFFE = Encode_Zig_Zag_32 (0x3FFF_FFFF)");
    Assert (16#7FFF_FFFF# = COS.Encode_Zig_Zag_32 (-1073741824),
            "Expected: 0x7FFFFFFF = Encode_Zig_Zag_32 (-1073741824)");
    Assert (16#FFFF_FFFE# = COS.Encode_Zig_Zag_32 (16#7FFF_FFFF#),
            "Expected: 0xFFFFFFFE = Encode_Zig_Zag_32 (0x7FFFFFFF)");
    Assert (16#FFFF_FFFF# = COS.Encode_Zig_Zag_32 (-2147483648),
            "Expected: 0xFFFFFFFF = Encode_Zig_Zag_32 (-2147483648)");

    -- Check that Encode (Decode (Value)) = Value.
    Assert (    0 = COS.Encode_Zig_Zag_32 (Convert (CIS.Decode_Zig_Zag_32(0))),
            "ZigZag32 encode(decode(number)) should return number");
    Assert (    1 = COS.Encode_Zig_Zag_32 (Convert (CIS.Decode_Zig_Zag_32(1))),
            "ZigZag32 encode(decode(number)) should return number");
    Assert (   -1 = COS.Encode_Zig_Zag_32 (Convert (CIS.Decode_Zig_Zag_32(-1))),
            "ZigZag32 encode(decode(number)) should return number");
    Assert (14927 = COS.Encode_Zig_Zag_32 (Convert (CIS.Decode_Zig_Zag_32(14927))),
            "ZigZag32 encode(decode(number)) should return number");
    Assert (-3612 = COS.Encode_Zig_Zag_32 (Convert (CIS.Decode_Zig_Zag_32(-3612))),
            "ZigZag32 encode(decode(number)) should return number");
  end Test_Encode_Zig_Zag_32;

  ----------------------------
  -- Test_Encode_Zig_Zag_64 --
  ----------------------------

  procedure Test_Encode_Zig_Zag_64 (T : in out Test_Cases.Test_Case'Class) is
    pragma Unreferenced (T);

    use type Google.Protobuf.Wire_Format.PB_Int64;
    use type Google.Protobuf.Wire_Format.PB_UInt64;

    function Convert is
      new Ada.Unchecked_Conversion (Google.Protobuf.Wire_Format.PB_UInt64,
                                    Google.Protobuf.Wire_Format.PB_Int64);
  begin
    Assert (0 = COS.Encode_Zig_Zag_64 (0),
            "Expected: 0 = Encode_Zig_Zag_64 (0)");
    Assert (1 = COS.Encode_Zig_Zag_64 (-1),
            "Expected: -1 = Encode_Zig_Zag_64 (1)");
    Assert (2 = COS.Encode_Zig_Zag_64 (1),
            "Expected: 1 = Encode_Zig_Zag_64 (2)");
    Assert (3 = COS.Encode_Zig_Zag_64 (-2),
            "Expected: -2 = Encode_Zig_Zag_64 (3)");
    Assert (4 = COS.Encode_Zig_Zag_64 (2),
            "Expected: 2 = Encode_Zig_Zag_64 (4)");
    Assert (16#0000_0000_7FFF_FFFE# = COS.Encode_Zig_Zag_64 (1073741823),
            "Expected: 0x000000007FFFFFFE = Encode_Zig_Zag_64 (1073741823)");
    Assert (16#0000_0000_7FFF_FFFF# = COS.Encode_Zig_Zag_64 (-1073741824),
            "Expected: 0x000000007FFFFFFF = Encode_Zig_Zag_64 (-1073741824)");
    Assert (16#0000_0000_FFFF_FFFE# = COS.Encode_Zig_Zag_64 (2147483647),
            "Expected: 0x00000000FFFFFFFE = Encode_Zig_Zag_64 (2147483647)");
    Assert (16#0000_0000_FFFF_FFFF# = COS.Encode_Zig_Zag_64 (-2147483648),
            "Expected: 0x00000000FFFFFFFF = Encode_Zig_Zag_64 (-2147483648)");
    Assert (16#FFFF_FFFF_FFFF_FFFE# = COS.Encode_Zig_Zag_64 (9223372036854775807),
            "Expected: 0xFFFFFFFFFFFFFFFE = Encode_Zig_Zag_64 (9223372036854775807)");
    Assert (16#FFFF_FFFF_FFFF_FFFF# = COS.Encode_Zig_Zag_64 (-9223372036854775808),
            "Expected: 0xFFFFFFFFFFFFFFFF = Encode_Zig_Zag_64 (-9223372036854775808)");

    -- Check that Encode (Decode (Value)) = Value.
    Assert (    0 = COS.Encode_Zig_Zag_64 (Convert (CIS.Decode_Zig_Zag_64 (0))),
            "ZigZag64 encode(decode(number)) should return number");
    Assert (    1 = COS.Encode_Zig_Zag_64 (Convert (CIS.Decode_Zig_Zag_64 (1))),
            "ZigZag64 encode(decode(number)) should return number");
    Assert (   -1 = COS.Encode_Zig_Zag_64 (Convert (CIS.Decode_Zig_Zag_64 (-1))),
            "ZigZag64 encode(decode(number)) should return number");
    Assert (14927 = COS.Encode_Zig_Zag_64 (Convert (CIS.Decode_Zig_Zag_64 (14927))),
            "ZigZag64 encode(decode(number)) should return number");
    Assert (-3612 = COS.Encode_Zig_Zag_64 (Convert (CIS.Decode_Zig_Zag_64 (-3612))),
            "ZigZag64 encode(decode(number)) should return number");
    Assert (856912304801416 =
              COS.Encode_Zig_Zag_64
                (Convert (CIS.Decode_Zig_Zag_64 (856912304801416))),
            "ZigZag64 encode(decode(number)) should return number");
    Assert (-75123905439571256 =
              COS.Encode_Zig_Zag_64
                (Convert (CIS.Decode_Zig_Zag_64 (-75123905439571256))),
            "ZigZag64 encode(decode(number)) should return number");
  end Test_Encode_Zig_Zag_64;

  -------------------------------------
  -- Test_Write_Raw_Little_Endian_32 --
  -------------------------------------

  procedure Test_Write_Raw_Little_Endian_32 (T : in out Test_Cases.Test_Case'Class) is
    pragma Unreferenced (T);
  begin
    Test_Helpers.Assert_Write_Raw_Little_Endian_32
      (Ada.Streams.Stream_Element_Array'(16#78#, 16#56#, 16#34#, 16#12#),
       16#12345678#);
    Test_Helpers.Assert_Write_Raw_Little_Endian_32
      (Ada.Streams.Stream_Element_Array'(16#F0#, 16#DE#, 16#BC#, 16#9A#),
       16#9ABCDEF0#);
  end Test_Write_Raw_Little_Endian_32;

  -------------------------------------
  -- Test_Write_Raw_Little_Endian_64 --
  -------------------------------------

  procedure Test_Write_Raw_Little_Endian_64 (T : in out Test_Cases.Test_Case'Class) is
    pragma Unreferenced (T);

    use type Google.Protobuf.Wire_Format.PB_Int64;
  begin
    Test_Helpers.Assert_Write_Raw_Little_Endian_64
      (Ada.Streams.Stream_Element_Array'
         (16#F0#, 16#DE#, 16#BC#, 16#9A#, 16#78#, 16#56#, 16#34#, 16#12#),
       16#123456789ABCDEF0#);
    -- -7296712173568108936 = 16#9ABCDEF012345678#
    Test_Helpers.Assert_Write_Raw_Little_Endian_64
      (Ada.Streams.Stream_Element_Array'
         (16#78#, 16#56#, 16#34#, 16#12#, 16#F0#, 16#DE#, 16#BC#, 16#9A#),
       -7296712173568108936);
  end Test_Write_Raw_Little_Endian_64;

  ------------------------------
  -- Test_Write_Raw_Varint_32 --
  ------------------------------

  procedure Test_Write_Raw_Varint_32 (T : in out Test_Cases.Test_Case'Class)
  is
    pragma Unreferenced (T);
  begin
    Test_Helpers.Assert_Write_Raw_Varint
      (AS.Stream_Element_Array'(0 => 0), 0);
    Test_Helpers.Assert_Write_Raw_Varint
      (AS.Stream_Element_Array'(0 => 1), 1);
    Test_Helpers.Assert_Write_Raw_Varint
      (AS.Stream_Element_Array'(0 => 16#7F#), 127);
    Test_Helpers.Assert_Write_Raw_Varint
      (AS.Stream_Element_Array'(16#A2#, 16#74#), 14882);
    Test_Helpers.Assert_Write_Raw_Varint
      (AS.Stream_Element_Array'(16#BE#, 16#F7#, 16#92#, 16#84#, 16#0B#),
       2961488830);
  end Test_Write_Raw_Varint_32;

  ------------------------------
  -- Test_Write_Raw_Varint_64 --
  ------------------------------

  procedure Test_Write_Raw_Varint_64 (T : in out Test_Cases.Test_Case'Class)
  is
    pragma Unreferenced (T);

    use type Google.Protobuf.Wire_Format.PB_Int64;
  begin
    -- 7256456126
    Test_Helpers.Assert_Write_Raw_Varint
      (AS.Stream_Element_Array'(16#BE#, 16#F7#, 16#92#, 16#84#, 16#1B#), 7256456126);
    -- 41256202580718336
    Test_Helpers.Assert_Write_Raw_Varint
      (AS.Stream_Element_Array'
         (16#80#, 16#E6#, 16#EB#, 16#9C#, 16#C3#, 16#C9#, 16#A4#, 16#49#),
       41256202580718336);
    -- 11964378330978735131
    Test_Helpers.Assert_Write_Raw_Varint
      (AS.Stream_Element_Array'
         (16#9B#, 16#A8#, 16#F9#, 16#C2#, 16#BB#, 16#D6#, 16#80#, 16#85#, 16#A6#, 16#01#),
       11964378330978735131);
  end Test_Write_Raw_Varint_64;

end Coded_Output_Stream_Tests;

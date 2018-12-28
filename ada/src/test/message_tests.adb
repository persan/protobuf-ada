with AUnit.Assertions;
with GNAT.Source_Info;
with Ada.Streams.Stream_IO;

with Protocol_Buffers.Generic_Assertions.Assertions;
with Protocol_Buffers.Generated_Message_Utilities;
with Protocol_Buffers.Wire_Format;

with Test_Util;
with Unittest.TestExtremeDefaultValues;
with Unittest.TestRequired;
with Unittest.TestRequiredForeign;
with Unittest.TestReallyLargeTagNumber;
with Unittest.TestMutualRecursionA;
with Unittest.TestMutualRecursionB;
with Unittest.TestAllTypes;

package body Message_Tests is

  use Protocol_Buffers.Generic_Assertions.Assertions;
  use Protocol_Buffers.Generated_Message_Utilities;

  ----------
  -- Name --
  ----------

  function Name (T : Test_Case)
                 return Test_String is
    pragma Unreferenced (T);
  begin
    return Format ("Message_Tests");
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
       Routine => Test_Floating_Point_Defaults'Access,
       Name    => "Test_Floating_Point_Defaults");
    Register_Routine
      (Test    => T,
       Routine => Test_Extreme_Small_Integer_Defaults'Access,
       Name    => "Test_Extreme_Small_Integer_Defaults");
    Register_Routine
      (Test    => T,
       Routine => Test_String_Defaults'Access,
       Name    => "Test_String_Defaults");
    Register_Routine
      (Test    => T,
       Routine => Test_Required'Access,
       Name    => "Test_Required");
    Register_Routine
      (Test    => T,
       Routine => Test_Required_Foreign'Access,
       Name    => "Test_Required_Foreign");
    Register_Routine
      (Test    => T,
       Routine => Test_Really_Large_Tag_Number'Access,
       Name    => "Test_Really_Large_Tag_Number");
    Register_Routine
      (Test    => T,
       Routine => Test_Mutual_Recursion'Access,
       Name    => "Test_Mutual_Recursion");
    Register_Routine
      (Test    => T,
       Routine => Test_Enumeration_Values_In_Case_Statement'Access,
       Name    => "Test_Enumeration_Values_In_Case_Statement");
    Register_Routine
      (Test    => T,
       Routine => Test_Accessors'Access,
       Name    => "Test_Accessors");
    Register_Routine
      (Test    => T,
       Routine => Test_Clear'Access,
       Name    => "Test_Clear");
    Register_Routine
      (Test    => T,
       Routine => Test_Clear_One_Field'Access,
       Name    => "Test_Clear_One_Field");
  end Register_Tests;

    ----------------------------------
  -- Test_Floating_Point_Defaults --
  ----------------------------------

  procedure Test_Floating_Point_Defaults (T : in out Test_Cases.Test_Case'Class) is
    Message : Unittest.TestExtremeDefaultValues.Instance;

    use type Protocol_Buffers.Wire_Format.PB_Float;
    use type Protocol_Buffers.Wire_Format.PB_Double;
  begin
    Assert_Equal (0.0              , Message.Get_Zero_Float);
    Assert_Equal (1.0              , Message.Get_One_Float);
    Assert_Equal (1.5              , Message.Get_Small_Float);
    Assert_Equal (-1.0             , Message.Get_Negative_One_Float);
    Assert_Equal (-1.5             , Message.Get_Negative_Float);
    Assert_Equal (2.0e8            , Message.Get_Large_Float);
    Assert_Equal (-8.0e-28         , Message.Get_Small_Negative_Float);
    Assert_Equal (Positive_Infinity, Message.Get_Inf_Double);
    Assert_Equal (Negative_Infinity, Message.Get_Neg_Inf_Double);
    Assert_Equal (Positive_Infinity, Message.Get_Inf_Float);
    Assert_Equal (Negative_Infinity, Message.Get_Neg_Inf_Float);

    Assert_True (Message.Get_Nan_Float /= Message.Get_Nan_Float);
    Assert_True (Message.Get_Nan_Double /= Message.Get_Nan_Double);
  end Test_Floating_Point_Defaults;

  -----------------------------------------
  -- Test_Extreme_Small_Integer_Defaults --
  -----------------------------------------

  procedure Test_Extreme_Small_Integer_Defaults (T : in out Test_Cases.Test_Case'Class) is
      Message : Unittest.TestExtremeDefaultValues.Instance;
      use type Protocol_Buffers.Wire_Format.PB_Int32;
      use type Protocol_BUffers.Wire_Format.PB_Int64;
  begin
    Assert_Equal (-16#8000_0000#          , Message.Get_Really_Small_Int32);
    Assert_Equal (-16#8000_0000_0000_0000#, Message.Get_Really_Small_Int64);
  end Test_Extreme_Small_Integer_Defaults;


  --------------------------
  -- Test_String_Defaults --
  --------------------------

  procedure Test_String_Defaults (T : in out Test_Cases.Test_Case'Class) is
    Message : Unittest.TestAllTypes.Instance;
  begin
    -- Function Get_Foo for a string should return a string initialized to its
    -- default value.
    Assert_Equal ("hello", Message.Get_Default_String);

    -- Check that we get the
    Message.Set_Default_String ("blah");
    Message.Clear;

    Assert_Equal ("hello", Message.Get_Default_String);
  end Test_String_Defaults;

  -------------------
  -- Test_Required --
  -------------------

  procedure Test_Required (T : in out Test_Cases.Test_Case'Class) is
    Message : Unittest.TestRequired.Instance;
  begin
    Assert_False (Message.Is_Initialized);
    Message.Set_A (1);
    Assert_False (Message.Is_Initialized);
    Message.Set_B (2);
    Assert_False (Message.Is_Initialized);
    Message.Set_C (3);
    Assert_True  (Message.Is_Initialized);
  end Test_Required;

  ---------------------------
  -- Test_Required_Foreign --
  ---------------------------

  procedure Test_Required_Foreign (T : in out Test_Cases.Test_Case'Class) is
    Message : Unittest.TestRequiredForeign.Instance;
    Dummy   : access Unittest.TestRequired.Instance;
    pragma Unreferenced (Dummy);
  begin
    Assert_True (Message.Is_Initialized);

    Dummy := Message.Get_Optional_Message;
    Assert_False (Message.Is_Initialized);

    Message.Get_Optional_Message.Set_A (1);
    Message.Get_Optional_Message.Set_B (2);
    Message.Get_Optional_Message.Set_C (3);
    Assert_True (Message.Is_Initialized);

    Dummy := Message.Add_Repeated_Message;
    Assert_False (Message.Is_Initialized);

    Message.Get_Repeated_Message (0).Set_A(1);
    Message.Get_Repeated_Message (0).Set_B(2);
    Message.Get_Repeated_Message (0).Set_C(3);
    Assert_True (Message.Is_Initialized);
  end Test_Required_Foreign;

  ----------------------------------
  -- Test_Really_Large_Tag_Number --
  ----------------------------------

  procedure Test_Really_Large_Tag_Number (T : in out Test_Cases.Test_Case'Class) is
    Stream    : Ada.Streams.Stream_IO.Stream_Access;
    File      : Ada.Streams.Stream_IO.File_Type;
    Test_File : String := "test_really_large_tag_number";

    Message_1 : Unittest.TestReallyLargeTagNumber.Instance;
    Message_2 : Unittest.TestReallyLargeTagNumber.Instance;
  begin
    -- For the most part, if this compiles and runs then we're probably good.
    -- (The most likely cause for failure would be if something were attempting
    -- to allocate a lookup table of some sort using tag numbers as the index.)
    -- We'll try serializing just for fun.

    Ada.Streams.Stream_IO.Create (File => File,
                                  Mode => Ada.Streams.Stream_IO.Out_File,
                                  Name => Test_File);
    Stream := Ada.Streams.Stream_IO.Stream (File);

    Message_1.Set_A (1234);
    Message_1.Set_Bb (5678);

    Message_1.Serialize_To_Output_Stream (Stream);
    Ada.Streams.Stream_IO.Close (File);

    Ada.Streams.Stream_IO.Open (File => File,
                                Mode => Ada.Streams.Stream_IO.In_File,
                                Name => Test_File);
    Stream := Ada.Streams.Stream_IO.Stream (File);

    Message_2.Parse_From_Input_Stream (Stream);
    Assert_Equal (1234, Message_2.Get_A);
    Assert_Equal (5678, Message_2.Get_Bb);

    Ada.Streams.Stream_IO.Delete (File);
  end Test_Really_Large_Tag_Number;

  ---------------------------
  -- Test_Mutual_Recursion --
  ---------------------------

  procedure Test_Mutual_Recursion (T : in out Test_Cases.Test_Case'Class) is
    Message  : aliased Unittest.TestMutualRecursionA.Instance;
    Nested   : access Unittest.TestMutualRecursionA.Instance :=
      Message.Get_Bb.Get_A;
    Nested_2 : access Unittest.TestMutualRecursionA.Instance :=
      Nested.Get_Bb.Get_A;

    use type Unittest.TestMutualRecursionA.TestMutualRecursionA_Access;
  begin
    -- Again, if the above compiles and runs, that's all we really have to
    -- test, but just for run we'll check that the system didn't somehow come
    -- up with a pointer loop...
    Assert (Message'Unchecked_Access /= Nested, "");
    Assert (Message'Unchecked_Access /= Nested_2, "");
    Assert (Nested /= Nested_2, "");
  end Test_Mutual_Recursion;

  -----------------------------------------------
  -- Test_Enumeration_Values_In_Case_Statement --
  -----------------------------------------------

  procedure Test_Enumeration_Values_In_Case_Statement (T : in out Test_Cases.Test_Case'Class) is
    A : Unittest.TestAllTypes.NestedEnum := Unittest.TestAllTypes.BAR;
    I : Protocol_Buffers.Wire_Format.PB_UInt32 := 0;
  begin
    -- Test that enumeration values can be used in case statements. This test
    -- doesn't actually do anything, the proof that it works is that it
    -- compiles.
    case A is
      when Unittest.TestAllTypes.FOO =>
        I := 1;
      when Unittest.TestAllTypes.BAR =>
        I := 2;
      when Unittest.TestAllTypes.BAZ =>
        I := 3;
        -- no default case:  We want to make sure the compiler recognizes that
        --   all cases are covered.  (GNAT warns if you do not cover all cases of
        --   an enum in a switch.)
    end case;

    -- Token check just for fun.
    Assert_Equal (2, I);
  end Test_Enumeration_Values_In_Case_Statement;

  --------------------
  -- Test_Accessors --
  --------------------

  procedure Test_Accessors (T : in out Test_Cases.Test_Case'Class) is
    Message : Unittest.TestAllTypes.Instance;
  begin
    -- Set every field to a unique value then go back and check all those
    -- values.

    Test_Util.Set_All_Fields (Message);
    Test_Util.Expect_All_Fields_Set (Message);

    Test_Util.Modify_Repeated_Fields (Message);
    Test_Util.Expect_Repeated_Fields_Modified (Message);
  end Test_Accessors;

  ----------------
  -- Test_Clear --
  ----------------

  procedure Test_Clear (T : in out Test_Cases.Test_Case'Class) is
    Message : Unittest.TestAllTypes.Instance;
  begin
    Test_Util.Set_All_Fields (Message);
    Message.Clear;
    Test_Util.Expect_Clear (Message);
  end Test_Clear;

  --------------------------
  -- Test_Clear_One_Field --
  --------------------------

  procedure Test_Clear_One_Field (T : in out Test_Cases.Test_Case'Class) is
    Message        : Unittest.TestAllTypes.Instance;
    Original_Value : Protocol_Buffers.Wire_Format.PB_Int64;
  begin
    Test_Util.Set_All_Fields (Message);
    Original_Value := Message.Get_Optional_Int64;

    -- Clear the field and make sure that it shows up as cleared.
    Message.Clear_Optional_Int64;
    Assert_False (Message.Has_Optional_Int64);
    Assert_Equal (0, Message.Get_Optional_Int64);

    -- Other adjacent fields should not be cleared.
    Assert_True (Message.Has_Optional_Int32);
    Assert_True (Message.Has_Optional_Uint32);

    -- Make sure if we set it again, then all fields are set.
    Message.Set_Optional_Int64 (Original_Value);
    Test_Util.Expect_All_Fields_Set (Message);
  end Test_Clear_One_Field;
end Message_Tests;

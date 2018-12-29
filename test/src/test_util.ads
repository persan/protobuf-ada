with Unittest.TestAllTypes;
with Unittest.TestPackedTypes;
with Unittest.TestUnpackedTypes;
with GNAT.Source_Info;

package Test_Util is
  -- Set every field in the message to a unique value.
  procedure Set_All_Fields (Message : in out Unittest.TestAllTypes.Instance);
  procedure Set_Optional_Fields (Message : in out Unittest.TestAllTypes.Instance);
  procedure Add_Repeated_Fields1 (Message : in out Unittest.TestAllTypes.Instance);
  procedure Add_Repeated_Fields2 (Message : in out Unittest.TestAllTypes.Instance);
  procedure Set_Default_Fields (Message : in out Unittest.TestAllTypes.Instance);
  procedure Set_Unpacked_Fields (Message : in out Unittest.TestUnpackedTypes.Instance);
  procedure Set_Packed_Fields (Message : in out Unittest.TestPackedTypes.Instance);

  -- Use the repeated versions of the Set_*(...) accessors to modify all the
  -- repeated fields of the message (which should already have been initialized
  -- with Set_*_Fields(...)). Set_*_Fields(...) itself only tests the
  -- Add_*(...) accessors.
  procedure Modify_Repeated_Fields (Message : in out Unittest.TestAllTypes.Instance);
  procedure Modify_Packed_Fields (Message : in out Unittest.TestPackedTypes.Instance);

  -- Check that all fields have the values that they should after
  -- Set_*_Fields(...) is called.
  procedure Expect_All_Fields_Set (Message : in out Unittest.TestAllTypes.Instance);
  procedure Expect_Packed_Fields_Set (Message : in Unittest.TestPackedTypes.Instance);
  procedure Expect_Unpacked_Fields_Set (Message : in Unittest.TestUnpackedTypes.Instance);

  -- Expect that the message is modified as would be expected from
  -- Modify_*_Fields(...).
  procedure Expect_Repeated_Fields_Modified (Message : in Unittest.TestAllTypes.Instance);
  procedure Expect_Packed_Fields_Modified (Message : in Unittest.TestPackedTypes.Instance);

  -- Check that all fields have their default values.
  procedure Expect_Clear (Message : in out Unittest.TestAllTypes.Instance);
  procedure Expect_Packed_Clear (Message : in Unittest.TestPackedTypes.Instance);

  -- Check that all repeated fields have had their last elements removed
  procedure Expect_Last_Repeateds_Removed (Message : in Unittest.TestAllTypes.Instance);
  procedure Expect_Last_Repeateds_Released (Message : in Unittest.TestAllTypes.Instance);

  procedure Expect_Repeateds_Swapped (Message : in Unittest.TestAllTypes.Instance);
  -- Check that all repeated fields have had their first and last elements
  -- swapped.
end Test_Util;

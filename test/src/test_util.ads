with protobuf_unittest.TestAllTypes;
with protobuf_unittest.TestPackedTypes;
with protobuf_unittest.TestUnpackedTypes;
with GNAT.Source_Info;

package Test_Util is
  -- Set every field in the message to a unique value.
  procedure Set_All_Fields (Message : in out protobuf_unittest.TestAllTypes.Instance);
  procedure Set_Optional_Fields (Message : in out protobuf_unittest.TestAllTypes.Instance);
  procedure Add_Repeated_Fields1 (Message : in out protobuf_unittest.TestAllTypes.Instance);
  procedure Add_Repeated_Fields2 (Message : in out protobuf_unittest.TestAllTypes.Instance);
  procedure Set_Default_Fields (Message : in out protobuf_unittest.TestAllTypes.Instance);
  procedure Set_Unpacked_Fields (Message : in out protobuf_unittest.TestUnpackedTypes.Instance);
  procedure Set_Packed_Fields (Message : in out protobuf_unittest.TestPackedTypes.Instance);

  -- Use the repeated versions of the Set_*(...) accessors to modify all the
  -- repeated fields of the message (which should already have been initialized
  -- with Set_*_Fields(...)). Set_*_Fields(...) itself only tests the
  -- Add_*(...) accessors.
  procedure Modify_Repeated_Fields (Message : in out protobuf_unittest.TestAllTypes.Instance);
  procedure Modify_Packed_Fields (Message : in out protobuf_unittest.TestPackedTypes.Instance);

  -- Check that all fields have the values that they should after
  -- Set_*_Fields(...) is called.
  procedure Expect_All_Fields_Set (Message : in out protobuf_unittest.TestAllTypes.Instance);
  procedure Expect_Packed_Fields_Set (Message : in protobuf_unittest.TestPackedTypes.Instance);
  procedure Expect_Unpacked_Fields_Set (Message : in protobuf_unittest.TestUnpackedTypes.Instance);

  -- Expect that the message is modified as would be expected from
  -- Modify_*_Fields(...).
  procedure Expect_Repeated_Fields_Modified (Message : in protobuf_unittest.TestAllTypes.Instance);
  procedure Expect_Packed_Fields_Modified (Message : in protobuf_unittest.TestPackedTypes.Instance);

  -- Check that all fields have their default values.
  procedure Expect_Clear (Message : in out protobuf_unittest.TestAllTypes.Instance);
  procedure Expect_Packed_Clear (Message : in protobuf_unittest.TestPackedTypes.Instance);

  -- Check that all repeated fields have had their last elements removed
  procedure Expect_Last_Repeateds_Removed (Message : in protobuf_unittest.TestAllTypes.Instance);
  procedure Expect_Last_Repeateds_Released (Message : in protobuf_unittest.TestAllTypes.Instance);

  procedure Expect_Repeateds_Swapped (Message : in protobuf_unittest.TestAllTypes.Instance);
  -- Check that all repeated fields have had their first and last elements
  -- swapped.
end Test_Util;

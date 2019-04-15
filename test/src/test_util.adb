with Protobuf_Unittest.TestAllTypes.NestedMessage;
with Protobuf_Unittest.ForeignMessage;
with Protobuf_Unittest_Import.ImportMessage;
with Protobuf_Unittest_Import.PublicImportMessage;

with Google.Protobuf.Wire_Format;
with Google.Protobuf.Generic_Assertions.Assertions; use Google.Protobuf.Generic_Assertions.Assertions;

package body Test_Util is

  use type Google.Protobuf.Wire_Format.PB_String;
  use type Google.Protobuf.Wire_Format.PB_Byte;
  use type Google.Protobuf.Wire_Format.PB_UInt32;
  use type Google.Protobuf.Wire_Format.PB_UInt64;
  use type Google.Protobuf.Wire_Format.PB_Double;
  use type Google.Protobuf.Wire_Format.PB_Float;
  use type Google.Protobuf.Wire_Format.PB_Bool;
  use type Google.Protobuf.Wire_Format.PB_Int32;
  use type Google.Protobuf.Wire_Format.PB_Int64;
  use type Google.Protobuf.Wire_Format.PB_Field_Type;
  use type Google.Protobuf.Wire_Format.PB_Wire_Type;
  use type Google.Protobuf.Wire_Format.PB_Object_Size;
  use type Google.Protobuf.Wire_Format.PB_String_Access;

  use type Protobuf_Unittest.ForeignEnum;
  use type Protobuf_Unittest_Import.ImportEnum;
  use type Protobuf_Unittest.TestAllTypes.NestedEnum;

  generic
    type Value_Type is private;
  procedure Generic_Equal
    (Expected    : in Value_Type;
     Actual      : in Value_Type;
     Source_Info : in String := GNAT.Source_Info.File;
     File_Info   : in Natural := GNAT.Source_Info.Line);


  procedure Generic_Equal
    (Expected    : in Value_Type;
     Actual      : in Value_Type;
     Source_Info : in String := GNAT.Source_Info.File;
     File_Info   : in Natural := GNAT.Source_Info.Line)
  is
  begin
    Assert (Expected = Actual, "", Source_Info, File_Info);
  end Generic_Equal;

  procedure Assert_Equal is new Generic_Equal (Protobuf_Unittest.ForeignEnum);
  procedure Assert_Equal is new Generic_Equal (Protobuf_Unittest_Import.ImportEnum);
  procedure Assert_Equal is new Generic_Equal (Protobuf_Unittest.TestAllTypes.NestedEnum);

  --------------------
  -- Set_All_Fields --
  --------------------

  procedure Set_All_Fields
    (Message : in out Protobuf_Unittest.TestAllTypes.Instance)
  is
  begin
    Set_Optional_Fields  (Message);
    Add_Repeated_Fields1 (Message);
    Add_Repeated_Fields2 (Message);
    Set_Default_Fields   (Message);
  end Set_All_Fields;

  -------------------------
  -- Set_Optional_Fields --
  -------------------------

  procedure Set_Optional_Fields
    (Message : in out Protobuf_Unittest.TestAllTypes.Instance)
  is
  begin
    Message.Set_Optional_Int32   (101);
    Message.Set_Optional_Int64   (102);
    Message.Set_Optional_Uint32  (103);
    Message.Set_Optional_Uint64  (104);
    Message.Set_Optional_Sint32  (105);
    Message.Set_Optional_Sint64  (106);
    Message.Set_Optional_Fixed32 (107);
    Message.Set_Optional_Fixed64 (108);
    Message.Set_Optional_Sfixed32(109);
    Message.Set_Optional_Sfixed64(110);
    Message.Set_Optional_Float   (111.0);
    Message.Set_Optional_Double  (112.0);
    Message.Set_Optional_Bool    (True);
    Message.Set_Optional_String  ("115");
    Message.Set_Optional_Bytes   ("116");

    Message.Get_Optional_Nested_Message       .Set_Bb(118);
    Message.Get_Optional_Foreign_Message      .Set_C(119);
    Message.Get_Optional_Import_Message       .Set_D(120);
    Message.Get_Optional_Public_Import_Message.Set_E(126);
    Message.Get_Optional_Lazy_Message         .Set_Bb(127);

    Message.Set_Optional_Nested_Enum (Protobuf_Unittest.TestAllTypes.BAZ);
    Message.Set_Optional_Foreign_Enum(Protobuf_Unittest.Foreign_BAZ);
    Message.Set_Optional_Import_Enum (Protobuf_Unittest_Import.Import_BAZ);
  end Set_Optional_Fields;

  --------------------------
  -- Add_Repeated_Fields1 --
  --------------------------

  procedure Add_Repeated_Fields1
    (Message : in out Protobuf_Unittest.TestAllTypes.Instance)
  is
  begin
    Message.Add_Repeated_Int32   (201);
    Message.Add_Repeated_Int64   (202);
    Message.Add_Repeated_Uint32  (203);
    Message.Add_Repeated_Uint64  (204);
    Message.Add_Repeated_Sint32  (205);
    Message.Add_Repeated_Sint64  (206);
    Message.Add_Repeated_Fixed32 (207);
    Message.Add_Repeated_Fixed64 (208);
    Message.Add_Repeated_Sfixed32(209);
    Message.Add_Repeated_Sfixed64(210);
    Message.Add_Repeated_Float   (211.0);
    Message.Add_Repeated_Double  (212.0);
    Message.Add_Repeated_Bool    (True);
    Message.Add_Repeated_String  ("215");
    Message.Add_Repeated_Bytes   ("216");

    Message.Add_Repeated_Nested_Message .Set_Bb(218);
    Message.Add_Repeated_Foreign_Message.Set_C(219);
    Message.Add_Repeated_Import_Message .Set_D(220);
    Message.Add_Repeated_Lazy_Message   .Set_Bb(227);

    Message.Add_Repeated_Nested_Enum (Protobuf_Unittest.TestAllTypes.BAR);
    Message.Add_Repeated_Foreign_Enum(Protobuf_Unittest.Foreign_BAR);
    Message.Add_Repeated_Import_Enum (Protobuf_Unittest_Import.Import_BAR);
  end Add_Repeated_Fields1;

  --------------------------
  -- Add_Repeated_Fields2 --
  --------------------------

  procedure Add_Repeated_Fields2
    (Message : in out Protobuf_Unittest.TestAllTypes.Instance)
  is
  begin
    -- Add a second one of each field.
    Message.Add_Repeated_Int32   (301);
    Message.Add_Repeated_Int64   (302);
    Message.Add_Repeated_Uint32  (303);
    Message.Add_Repeated_Uint64  (304);
    Message.Add_Repeated_Sint32  (305);
    Message.Add_Repeated_Sint64  (306);
    Message.Add_Repeated_Fixed32 (307);
    Message.Add_Repeated_Fixed64 (308);
    Message.Add_Repeated_Sfixed32(309);
    Message.Add_Repeated_Sfixed64(310);
    Message.Add_Repeated_Float   (311.0);
    Message.Add_Repeated_Double  (312.0);
    Message.Add_Repeated_Bool    (False);
    Message.Add_Repeated_String  ("315");
    Message.Add_Repeated_Bytes   ("316");

    Message.Add_Repeated_Nested_Message .Set_Bb(318);
    Message.Add_Repeated_Foreign_Message.Set_C(319);
    Message.Add_Repeated_Import_Message .Set_D(320);
    Message.Add_Repeated_Lazy_Message   .Set_Bb(327);

    Message.Add_Repeated_Nested_Enum (Protobuf_Unittest.TestAllTypes.BAZ);
    Message.Add_Repeated_Foreign_Enum(Protobuf_Unittest.Foreign_BAZ);
    Message.Add_Repeated_Import_Enum (Protobuf_Unittest_Import.Import_BAZ);
  end Add_Repeated_Fields2;

  ------------------------
  -- Set_Default_Fields --
  ------------------------

  procedure Set_Default_Fields
    (Message : in out Protobuf_Unittest.TestAllTypes.Instance)
  is
  begin
    Message.Set_Default_Int32   (401);
    Message.Set_Default_Int64   (402);
    Message.Set_Default_Uint32  (403);
    Message.Set_Default_Uint64  (404);
    Message.Set_Default_Sint32  (405);
    Message.Set_Default_Sint64  (406);
    Message.Set_Default_Fixed32 (407);
    Message.Set_Default_Fixed64 (408);
    Message.Set_Default_Sfixed32(409);
    Message.Set_Default_Sfixed64(410);
    Message.Set_Default_Float   (411.0);
    Message.Set_Default_Double  (412.0);
    Message.Set_Default_Bool    (False);
    Message.Set_Default_String  ("415");
    Message.Set_Default_Bytes   ("416");

    Message.Set_Default_Nested_Enum (Protobuf_Unittest.TestAllTypes.FOO);
    Message.Set_Default_Foreign_Enum(Protobuf_Unittest.Foreign_FOO);
    Message.Set_Default_Import_Enum (Protobuf_Unittest_Import.Import_FOO);
  end Set_Default_Fields;

  -------------------------
  -- Set_Unpacked_Fields --
  -------------------------

  procedure Set_Unpacked_Fields
    (Message : in out Protobuf_Unittest.TestUnpackedTypes.Instance)
  is
  begin
    -- The values applied here must match those of SetPackedFields.

    Message.Add_Unpacked_Int32   (601);
    Message.Add_Unpacked_Int64   (602);
    Message.Add_Unpacked_Uint32  (603);
    Message.Add_Unpacked_Uint64  (604);
    Message.Add_Unpacked_Sint32  (605);
    Message.Add_Unpacked_Sint64  (606);
    Message.Add_Unpacked_Fixed32 (607);
    Message.Add_Unpacked_Fixed64 (608);
    Message.Add_Unpacked_Sfixed32(609);
    Message.Add_Unpacked_Sfixed64(610);
    Message.Add_Unpacked_Float   (611.0);
    Message.Add_Unpacked_Double  (612.0);
    Message.Add_Unpacked_Bool    (true);
    Message.Add_Unpacked_Enum    (Protobuf_Unittest.FOREIGN_BAR);


    -- Add a second one of each field
    Message.Add_Unpacked_Int32   (701);
    Message.Add_Unpacked_Int64   (702);
    Message.Add_Unpacked_Uint32  (703);
    Message.Add_Unpacked_Uint64  (704);
    Message.Add_Unpacked_Sint32  (705);
    Message.Add_Unpacked_Sint64  (706);
    Message.Add_Unpacked_Fixed32 (707);
    Message.Add_Unpacked_Fixed64 (708);
    Message.Add_Unpacked_Sfixed32(709);
    Message.Add_Unpacked_Sfixed64(710);
    Message.Add_Unpacked_Float   (711.0);
    Message.Add_Unpacked_Double  (712.0);
    Message.Add_Unpacked_Bool    (false);
    Message.Add_Unpacked_Enum    (Protobuf_Unittest.FOREIGN_BAZ);
  end Set_Unpacked_Fields;

  -----------------------
  -- Set_Packed_Fields --
  -----------------------

  procedure Set_Packed_Fields
    (Message : in out Protobuf_Unittest.TestPackedTypes.Instance)
  is
  begin
    Message.Add_Packed_Int32   (601);
    Message.Add_Packed_Int64   (602);
    Message.Add_Packed_Uint32  (603);
    Message.Add_Packed_Uint64  (604);
    Message.Add_Packed_Sint32  (605);
    Message.Add_Packed_Sint64  (606);
    Message.Add_Packed_Fixed32 (607);
    Message.Add_Packed_Fixed64 (608);
    Message.Add_Packed_Sfixed32(609);
    Message.Add_Packed_Sfixed64(610);
    Message.Add_Packed_Float   (611.0);
    Message.Add_Packed_Double  (612.0);
    Message.Add_Packed_Bool    (true);
    Message.Add_Packed_Enum    (Protobuf_Unittest.FOREIGN_BAR);

    -- Add a second one of each field
    Message.Add_Packed_Int32   (701);
    Message.Add_Packed_Int64   (702);
    Message.Add_Packed_Uint32  (703);
    Message.Add_Packed_Uint64  (704);
    Message.Add_Packed_Sint32  (705);
    Message.Add_Packed_Sint64  (706);
    Message.Add_Packed_Fixed32 (707);
    Message.Add_Packed_Fixed64 (708);
    Message.Add_Packed_Sfixed32(709);
    Message.Add_Packed_Sfixed64(710);
    Message.Add_Packed_Float   (711.0);
    Message.Add_Packed_Double  (712.0);
    Message.Add_Packed_Bool    (false);
    Message.Add_Packed_Enum    (Protobuf_Unittest.FOREIGN_BAZ);
  end Set_Packed_Fields;

  ----------------------------
  -- Modify_Repeated_Fields --
  ----------------------------

  procedure Modify_Repeated_Fields
    (Message : in out Protobuf_Unittest.TestAllTypes.Instance)
  is
  begin
    Message.Set_Repeated_Int32   (1, 501);
    Message.Set_Repeated_Int64   (1, 502);
    Message.Set_Repeated_Uint32  (1, 503);
    Message.Set_Repeated_Uint64  (1, 504);
    Message.Set_Repeated_Sint32  (1, 505);
    Message.Set_Repeated_Sint64  (1, 506);
    Message.Set_Repeated_Fixed32 (1, 507);
    Message.Set_Repeated_Fixed64 (1, 508);
    Message.Set_Repeated_Sfixed32(1, 509);
    Message.Set_Repeated_Sfixed64(1, 510);
    Message.Set_Repeated_Float   (1, 511.0);
    Message.Set_Repeated_Double  (1, 512.0);
    Message.Set_Repeated_Bool    (1, true);
    Message.Set_Repeated_String  (1, "515");
    Message.Set_Repeated_Bytes   (1, "516");

    Message.Get_Repeated_Nested_Message (1).Set_Bb(518);
    Message.Get_Repeated_Foreign_Message(1).Set_C(519);
    Message.Get_Repeated_Import_Message (1).Set_D(520);
    Message.Get_Repeated_Lazy_Message   (1).Set_Bb(527);

    Message.Set_Repeated_Nested_Enum (1, Protobuf_Unittest.TestAllTypes.FOO);
    Message.Set_Repeated_Foreign_Enum(1, Protobuf_Unittest.Foreign_FOO);
    Message.Set_Repeated_Import_Enum (1, Protobuf_Unittest_Import.Import_FOO);
  end Modify_Repeated_Fields;

  --------------------------
  -- Modify_Packed_Fields --
  --------------------------

  procedure Modify_Packed_Fields
    (Message : in out Protobuf_Unittest.TestPackedTypes.Instance)
  is
  begin
    Message.Set_Packed_Int32   (1, 801);
    Message.Set_Packed_Int64   (1, 802);
    Message.Set_Packed_Uint32  (1, 803);
    Message.Set_Packed_Uint64  (1, 804);
    Message.Set_Packed_Sint32  (1, 805);
    Message.Set_Packed_Sint64  (1, 806);
    Message.Set_Packed_Fixed32 (1, 807);
    Message.Set_Packed_Fixed64 (1, 808);
    Message.Set_Packed_Sfixed32(1, 809);
    Message.Set_Packed_Sfixed64(1, 810);
    Message.Set_Packed_Float   (1, 811.0);
    Message.Set_Packed_Double  (1, 812.0);
    Message.Set_Packed_Bool    (1, true);
    Message.Set_Packed_Enum    (1, Protobuf_Unittest.FOREIGN_FOO);
  end Modify_Packed_Fields;

  ---------------------------
  -- Expect_All_Fields_Set --
  ---------------------------

  procedure Expect_All_Fields_Set
    (Message : in out Protobuf_Unittest.TestAllTypes.Instance)
  is
  begin
    Assert_True (Message.Has_Optional_Int32   );
    Assert_True (Message.Has_Optional_Int64   );
    Assert_True (Message.Has_Optional_Uint32  );
    Assert_True (Message.Has_Optional_Uint64  );
    Assert_True (Message.Has_Optional_Sint32  );
    Assert_True (Message.Has_Optional_Sint64  );
    Assert_True (Message.Has_Optional_Fixed32 );
    Assert_True (Message.Has_Optional_Fixed64 );
    Assert_True (Message.Has_Optional_Sfixed32);
    Assert_True (Message.Has_Optional_Sfixed64);
    Assert_True (Message.Has_Optional_Float   );
    Assert_True (Message.Has_Optional_Double  );
    Assert_True (Message.Has_Optional_Bool    );
    Assert_True (Message.Has_Optional_String  );
    Assert_True (Message.Has_Optional_Bytes   );

    Assert_True (Message.Has_Optional_Nested_Message       );
    Assert_True (Message.Has_Optional_Foreign_Message      );
    Assert_True (Message.Has_Optional_Import_Message       );
    Assert_True (Message.Has_Optional_Public_Import_Message);
    Assert_True (Message.Has_Optional_Lazy_Message         );

    Assert_True (Message.Get_Optional_Nested_Message       .Has_Bb);
    Assert_True (Message.Get_Optional_Foreign_Message      .Has_C );
    Assert_True (Message.Get_Optional_Import_Message       .Has_D );
    Assert_True (Message.Get_Optional_Public_Import_Message.Has_E );
    Assert_True (Message.Get_Optional_Lazy_Message         .Has_Bb);

    Assert_True (Message.Has_Optional_Nested_Enum );
    Assert_True (Message.Has_Optional_Foreign_Enum);
    Assert_True (Message.Has_Optional_Import_Enum );


    Assert_Equal (101  , Message.Get_Optional_Int32   );
    Assert_Equal (102  , Message.Get_Optional_Int64   );
    Assert_Equal (103  , Message.Get_Optional_Uint32  );
    Assert_Equal (104  , Message.Get_Optional_Uint64  );
    Assert_Equal (105  , Message.Get_Optional_Sint32  );
    Assert_Equal (106  , Message.Get_Optional_Sint64  );
    Assert_Equal (107  , Message.Get_Optional_Fixed32 );
    Assert_Equal (108  , Message.Get_Optional_Fixed64 );
    Assert_Equal (109  , Message.Get_Optional_Sfixed32);
    Assert_Equal (110  , Message.Get_Optional_Sfixed64);
    Assert_Equal (111.0, Message.Get_Optional_Float   );
    Assert_Equal (112.0, Message.Get_Optional_Double  );
    Assert_True  (       Message.Get_Optional_Bool    );
    Assert_Equal ("115", Message.Get_Optional_String  );
    Assert_Equal ("116", Message.Get_Optional_Bytes   );

    Assert_Equal (118, Message.Get_Optional_Nested_Message        .Get_Bb);
    Assert_Equal (119, Message.Get_Optional_Foreign_Message       .Get_C );
    Assert_Equal (120, Message.Get_Optional_Import_Message        .Get_D );
    Assert_Equal (126, Message.Get_Optional_Public_Import_Message .Get_E );
    Assert_Equal (127, Message.Get_Optional_Lazy_Message          .Get_Bb);

    Assert_Equal (Protobuf_Unittest.TestAllTypes.BAZ, Message.Get_Optional_Nested_Enum );
    Assert_Equal (Protobuf_Unittest.FOREIGN_BAZ     , Message.Get_Optional_Foreign_Enum);
    Assert_Equal (Protobuf_Unittest_Import.Import_BAZ      , Message.Get_Optional_Import_Enum );

    --------------------------------------------------------------------

    Assert_Equal (2,  Message.Repeated_Int32_Size   );
    Assert_Equal (2,  Message.Repeated_Int64_Size   );
    Assert_Equal (2,  Message.Repeated_Uint32_Size  );
    Assert_Equal (2,  Message.Repeated_Uint64_Size  );
    Assert_Equal (2,  Message.Repeated_Sint32_Size  );
    Assert_Equal (2,  Message.Repeated_Sint64_Size  );
    Assert_Equal (2,  Message.Repeated_Fixed32_Size );
    Assert_Equal (2,  Message.Repeated_Fixed64_Size );
    Assert_Equal (2,  Message.Repeated_Sfixed32_Size);
    Assert_Equal (2,  Message.Repeated_Sfixed64_Size);
    Assert_Equal (2,  Message.Repeated_Float_Size   );
    Assert_Equal (2,  Message.Repeated_Double_Size  );
    Assert_Equal (2,  Message.Repeated_Bool_Size    );
    Assert_Equal (2,  Message.Repeated_String_Size  );
    Assert_Equal (2,  Message.Repeated_Bytes_Size   );

    Assert_Equal (2,  Message.Repeated_Nested_Message_Size );
    Assert_Equal (2,  Message.Repeated_Foreign_Message_Size);
    Assert_Equal (2,  Message.Repeated_Import_Message_Size );
    Assert_Equal (2,  Message.Repeated_Lazy_Message_Size   );
    Assert_Equal (2,  Message.Repeated_Nested_Enum_Size    );
    Assert_Equal (2,  Message.Repeated_Foreign_Enum_Size   );
    Assert_Equal (2,  Message.Repeated_Import_Enum_Size    );

    Assert_Equal (201  , Message.Get_Repeated_Int32   (0));
    Assert_Equal (202  , Message.Get_Repeated_Int64   (0));
    Assert_Equal (203  , Message.Get_Repeated_Uint32  (0));
    Assert_Equal (204  , Message.Get_Repeated_Uint64  (0));
    Assert_Equal (205  , Message.Get_Repeated_Sint32  (0));
    Assert_Equal (206  , Message.Get_Repeated_Sint64  (0));
    Assert_Equal (207  , Message.Get_Repeated_Fixed32 (0));
    Assert_Equal (208  , Message.Get_Repeated_Fixed64 (0));
    Assert_Equal (209  , Message.Get_Repeated_Sfixed32(0));
    Assert_Equal (210  , Message.Get_Repeated_Sfixed64(0));
    Assert_Equal (211.0, Message.Get_Repeated_Float   (0));
    Assert_Equal (212.0, Message.Get_Repeated_Double  (0));
    Assert_True  (       Message.Get_Repeated_Bool    (0));
    Assert_Equal ("215", Message.Get_Repeated_String  (0));
    Assert_Equal ("216", Message.Get_Repeated_Bytes   (0));

    Assert_Equal (218, Message.Get_Repeated_Nested_Message (0).Get_Bb);
    Assert_Equal (219, Message.Get_Repeated_Foreign_Message(0).Get_C );
    Assert_Equal (220, Message.Get_Repeated_Import_Message (0).Get_D );
    Assert_Equal (227, Message.Get_Repeated_Lazy_Message   (0).Get_Bb);


    Assert_Equal (Protobuf_Unittest.TestAllTypes.BAR, Message.Get_Repeated_Nested_Enum (0));
    Assert_Equal (Protobuf_Unittest.FOREIGN_BAR     , Message.Get_Repeated_Foreign_Enum(0));
    Assert_Equal (Protobuf_Unittest_Import.Import_BAR      , Message.Get_Repeated_Import_Enum (0));

    Assert_Equal (301  , Message.Get_Repeated_Int32   (1));
    Assert_Equal (302  , Message.Get_Repeated_Int64   (1));
    Assert_Equal (303  , Message.Get_Repeated_Uint32  (1));
    Assert_Equal (304  , Message.Get_Repeated_Uint64  (1));
    Assert_Equal (305  , Message.Get_Repeated_Sint32  (1));
    Assert_Equal (306  , Message.Get_Repeated_Sint64  (1));
    Assert_Equal (307  , Message.Get_Repeated_Fixed32 (1));
    Assert_Equal (308  , Message.Get_Repeated_Fixed64 (1));
    Assert_Equal (309  , Message.Get_Repeated_Sfixed32(1));
    Assert_Equal (310  , Message.Get_Repeated_Sfixed64(1));
    Assert_Equal (311.0, Message.Get_Repeated_Float   (1));
    Assert_Equal (312.0, Message.Get_Repeated_Double  (1));
    Assert_False (       Message.Get_Repeated_Bool    (1));
    Assert_Equal ("315", Message.Get_Repeated_String  (1));
    Assert_Equal ("316", Message.Get_Repeated_Bytes   (1));

    Assert_Equal (318, Message.Get_Repeated_Nested_Message (1).Get_Bb);
    Assert_Equal (319, Message.Get_Repeated_Foreign_Message(1).Get_C);
    Assert_Equal (320, Message.Get_Repeated_Import_Message (1).Get_D);
    Assert_Equal (327, Message.Get_Repeated_Lazy_Message   (1).Get_Bb);

    Assert_Equal (Protobuf_Unittest.TestAllTypes.BAZ , Message.Get_Repeated_Nested_Enum (1));
    Assert_Equal (Protobuf_Unittest.FOREIGN_BAZ      , Message.Get_Repeated_Foreign_Enum(1));
    Assert_Equal (Protobuf_Unittest_Import.Import_BAZ       , Message.Get_Repeated_Import_Enum (1));


    --------------------------------------------------------------------

    Assert_True (Message.Has_Default_Int32   );
    Assert_True (Message.Has_Default_Int64   );
    Assert_True (Message.Has_Default_Uint32  );
    Assert_True (Message.Has_Default_Uint64  );
    Assert_True (Message.Has_Default_Sint32  );
    Assert_True (Message.Has_Default_Sint64  );
    Assert_True (Message.Has_Default_Fixed32 );
    Assert_True (Message.Has_Default_Fixed64 );
    Assert_True (Message.Has_Default_Sfixed32);
    Assert_True (Message.Has_Default_Sfixed64);
    Assert_True (Message.Has_Default_Float   );
    Assert_True (Message.Has_Default_Double  );
    Assert_True (Message.Has_Default_Bool    );
    Assert_True (Message.Has_Default_String  );
    Assert_True (Message.Has_Default_Bytes   );

    Assert_True (Message.Has_Default_Nested_Enum );
    Assert_True (Message.Has_Default_Foreign_Enum);
    Assert_True (Message.Has_Default_Import_Enum );


    Assert_Equal (401  , Message.Get_Default_Int32   );
    Assert_Equal (402  , Message.Get_Default_Int64   );
    Assert_Equal (403  , Message.Get_Default_Uint32  );
    Assert_Equal (404  , Message.Get_Default_Uint64  );
    Assert_Equal (405  , Message.Get_Default_Sint32  );
    Assert_Equal (406  , Message.Get_Default_Sint64  );
    Assert_Equal (407  , Message.Get_Default_Fixed32 );
    Assert_Equal (408  , Message.Get_Default_Fixed64 );
    Assert_Equal (409  , Message.Get_Default_Sfixed32);
    Assert_Equal (410  , Message.Get_Default_Sfixed64);
    Assert_Equal (411.0, Message.Get_Default_Float   );
    Assert_Equal (412.0, Message.Get_Default_Double  );
    Assert_False (       Message.Get_Default_Bool    );
    Assert_Equal ("415", Message.Get_Default_String  );
    Assert_Equal ("416", Message.Get_Default_Bytes   );

    Assert_Equal (Protobuf_Unittest.TestAllTypes.FOO , Message.Get_Default_Nested_Enum );
    Assert_Equal (Protobuf_Unittest.FOREIGN_FOO      , Message.Get_Default_Foreign_Enum);
    Assert_Equal (Protobuf_Unittest_Import.Import_FOO, Message.Get_Default_Import_Enum );
  end Expect_All_Fields_Set;

  ------------------------------
  -- Expect_Packed_Fields_Set --
  ------------------------------

  procedure Expect_Packed_Fields_Set
    (Message : in Protobuf_Unittest.TestPackedTypes.Instance)
  is
  begin
    Assert_Equal (2, Message.Packed_Int32_Size   );
    Assert_Equal (2, Message.Packed_Int64_Size   );
    Assert_Equal (2, Message.Packed_Uint32_Size  );
    Assert_Equal (2, Message.Packed_Uint64_Size  );
    Assert_Equal (2, Message.Packed_Sint32_Size  );
    Assert_Equal (2, Message.Packed_Sint64_Size  );
    Assert_Equal (2, Message.Packed_Fixed32_Size );
    Assert_Equal (2, Message.Packed_Fixed64_Size );
    Assert_Equal (2, Message.Packed_Sfixed32_Size);
    Assert_Equal (2, Message.Packed_Sfixed64_Size);
    Assert_Equal (2, Message.Packed_Float_Size   );
    Assert_Equal (2, Message.Packed_Double_Size  );
    Assert_Equal (2, Message.Packed_Bool_Size    );
    Assert_Equal (2, Message.Packed_Enum_Size    );


    Assert_Equal (601  , Message.Get_Packed_Int32   (0));
    Assert_Equal (602  , Message.Get_Packed_Int64   (0));
    Assert_Equal (603  , Message.Get_Packed_Uint32  (0));
    Assert_Equal (604  , Message.Get_Packed_Uint64  (0));
    Assert_Equal (605  , Message.Get_Packed_Sint32  (0));
    Assert_Equal (606  , Message.Get_Packed_Sint64  (0));
    Assert_Equal (607  , Message.Get_Packed_Fixed32 (0));
    Assert_Equal (608  , Message.Get_Packed_Fixed64 (0));
    Assert_Equal (609  , Message.Get_Packed_Sfixed32(0));
    Assert_Equal (610  , Message.Get_Packed_Sfixed64(0));
    Assert_Equal (611.0, Message.Get_Packed_Float   (0));
    Assert_Equal (612.0, Message.Get_Packed_Double  (0));
    Assert_True  (       Message.Get_Packed_Bool    (0));
    Assert_Equal (Protobuf_Unittest.FOREIGN_BAR, Message.Get_Packed_Enum(0));


    Assert_Equal (701  , Message.Get_Packed_Int32   (1));
    Assert_Equal (702  , Message.Get_Packed_Int64   (1));
    Assert_Equal (703  , Message.Get_Packed_Uint32  (1));
    Assert_Equal (704  , Message.Get_Packed_Uint64  (1));
    Assert_Equal (705  , Message.Get_Packed_Sint32  (1));
    Assert_Equal (706  , Message.Get_Packed_Sint64  (1));
    Assert_Equal (707  , Message.Get_Packed_Fixed32 (1));
    Assert_Equal (708  , Message.Get_Packed_Fixed64 (1));
    Assert_Equal (709  , Message.Get_Packed_Sfixed32(1));
    Assert_Equal (710  , Message.Get_Packed_Sfixed64(1));
    Assert_Equal (711.0, Message.Get_Packed_Float   (1));
    Assert_Equal (712.0, Message.Get_Packed_Double  (1));
    Assert_False (       Message.Get_Packed_Bool    (1));
    Assert_Equal (Protobuf_Unittest.FOREIGN_BAZ, Message.Get_Packed_Enum(1));
  end Expect_Packed_Fields_Set;

  --------------------------------
  -- Expect_Unpacked_Fields_Set --
  --------------------------------

  procedure Expect_Unpacked_Fields_Set
    (Message : in Protobuf_Unittest.TestUnpackedTypes.Instance)
  is
  begin
    -- The values expected here must match those of ExpectPackedFieldsSet.

    Assert_Equal (2,  Message.Unpacked_Int32_Size   );
    Assert_Equal (2,  Message.Unpacked_Int64_Size   );
    Assert_Equal (2,  Message.Unpacked_Uint32_Size  );
    Assert_Equal (2,  Message.Unpacked_Uint64_Size  );
    Assert_Equal (2,  Message.Unpacked_Sint32_Size  );
    Assert_Equal (2,  Message.Unpacked_Sint64_Size  );
    Assert_Equal (2,  Message.Unpacked_Fixed32_Size );
    Assert_Equal (2,  Message.Unpacked_Fixed64_Size );
    Assert_Equal (2,  Message.Unpacked_Sfixed32_Size);
    Assert_Equal (2,  Message.Unpacked_Sfixed64_Size);
    Assert_Equal (2,  Message.Unpacked_Float_Size   );
    Assert_Equal (2,  Message.Unpacked_Double_Size  );
    Assert_Equal (2,  Message.Unpacked_Bool_Size    );
    Assert_Equal (2,  Message.Unpacked_Enum_Size    );

    Assert_Equal (601  , Message.Get_Unpacked_Int32   (0));
    Assert_Equal (602  , Message.Get_Unpacked_Int64   (0));
    Assert_Equal (603  , Message.Get_Unpacked_Uint32  (0));
    Assert_Equal (604  , Message.Get_Unpacked_Uint64  (0));
    Assert_Equal (605  , Message.Get_Unpacked_Sint32  (0));
    Assert_Equal (606  , Message.Get_Unpacked_Sint64  (0));
    Assert_Equal (607  , Message.Get_Unpacked_Fixed32 (0));
    Assert_Equal (608  , Message.Get_Unpacked_Fixed64 (0));
    Assert_Equal (609  , Message.Get_Unpacked_Sfixed32(0));
    Assert_Equal (610  , Message.Get_Unpacked_Sfixed64(0));
    Assert_Equal (611.0, Message.Get_Unpacked_Float   (0));
    Assert_Equal (612.0, Message.Get_Unpacked_Double  (0));
    Assert_True  (       Message.Get_Unpacked_Bool    (0));
    Assert_Equal (Protobuf_Unittest.FOREIGN_BAR, Message.Get_Unpacked_Enum(0));

    Assert_Equal (701  , Message.Get_Unpacked_Int32   (1));
    Assert_Equal (702  , Message.Get_Unpacked_Int64   (1));
    Assert_Equal (703  , Message.Get_Unpacked_Uint32  (1));
    Assert_Equal (704  , Message.Get_Unpacked_Uint64  (1));
    Assert_Equal (705  , Message.Get_Unpacked_Sint32  (1));
    Assert_Equal (706  , Message.Get_Unpacked_Sint64  (1));
    Assert_Equal (707  , Message.Get_Unpacked_Fixed32 (1));
    Assert_Equal (708  , Message.Get_Unpacked_Fixed64 (1));
    Assert_Equal (709  , Message.Get_Unpacked_Sfixed32(1));
    Assert_Equal (710  , Message.Get_Unpacked_Sfixed64(1));
    Assert_Equal (711.0, Message.Get_Unpacked_Float   (1));
    Assert_Equal (712.0, Message.Get_Unpacked_Double  (1));
    Assert_False (       Message.Get_Unpacked_Bool    (1));
    Assert_Equal (Protobuf_Unittest.FOREIGN_BAZ, Message.Get_Unpacked_Enum(1));
  end Expect_Unpacked_Fields_Set;

  -------------------------------------
  -- Expect_Repeated_Fields_Modified --
  -------------------------------------

  procedure Expect_Repeated_Fields_Modified
    (Message : in Protobuf_Unittest.TestAllTypes.Instance)
  is
  begin
    -- ModifyRepeatedFields only Sets the second Repeated element of each
    -- field.  In Addition to verifying this, we also verify that the first
    -- element and size were *not* modified.

    Assert_Equal (2,  Message.Repeated_Int32_Size   );
    Assert_Equal (2,  Message.Repeated_Int64_Size   );
    Assert_Equal (2,  Message.Repeated_Uint32_Size  );
    Assert_Equal (2,  Message.Repeated_Uint64_Size  );
    Assert_Equal (2,  Message.Repeated_Sint32_Size  );
    Assert_Equal (2,  Message.Repeated_Sint64_Size  );
    Assert_Equal (2,  Message.Repeated_Fixed32_Size );
    Assert_Equal (2,  Message.Repeated_Fixed64_Size );
    Assert_Equal (2,  Message.Repeated_Sfixed32_Size);
    Assert_Equal (2,  Message.Repeated_Sfixed64_Size);
    Assert_Equal (2,  Message.Repeated_Float_Size   );
    Assert_Equal (2,  Message.Repeated_Double_Size  );
    Assert_Equal (2,  Message.Repeated_Bool_Size    );
    Assert_Equal (2,  Message.Repeated_String_Size  );
    Assert_Equal (2,  Message.Repeated_Bytes_Size   );

    Assert_Equal (2,  Message.Repeated_Nested_Message_Size );
    Assert_Equal (2,  Message.Repeated_Foreign_Message_Size);
    Assert_Equal (2,  Message.Repeated_Import_Message_Size );
    Assert_Equal (2,  Message.Repeated_Lazy_Message_Size   );
    Assert_Equal (2,  Message.Repeated_Nested_Enum_Size    );
    Assert_Equal (2,  Message.Repeated_Foreign_Enum_Size   );
    Assert_Equal (2,  Message.Repeated_Import_Enum_Size    );


    Assert_Equal (201  , Message.Get_Repeated_Int32   (0));
    Assert_Equal (202  , Message.Get_Repeated_Int64   (0));
    Assert_Equal (203  , Message.Get_Repeated_Uint32  (0));
    Assert_Equal (204  , Message.Get_Repeated_Uint64  (0));
    Assert_Equal (205  , Message.Get_Repeated_Sint32  (0));
    Assert_Equal (206  , Message.Get_Repeated_Sint64  (0));
    Assert_Equal (207  , Message.Get_Repeated_Fixed32 (0));
    Assert_Equal (208  , Message.Get_Repeated_Fixed64 (0));
    Assert_Equal (209  , Message.Get_Repeated_Sfixed32(0));
    Assert_Equal (210  , Message.Get_Repeated_Sfixed64(0));
    Assert_Equal (211.0, Message.Get_Repeated_Float   (0));
    Assert_Equal (212.0, Message.Get_Repeated_Double  (0));
    Assert_True (        Message.Get_Repeated_Bool    (0));
    Assert_Equal ("215", Message.Get_Repeated_String  (0));
    Assert_Equal ("216", Message.Get_Repeated_Bytes   (0));

    Assert_Equal (218, Message.Get_Repeated_Nested_Message (0).Get_Bb);
    Assert_Equal (219, Message.Get_Repeated_Foreign_Message(0).Get_C);
    Assert_Equal (220, Message.Get_Repeated_Import_Message (0).Get_D);
    Assert_Equal (227, Message.Get_Repeated_Lazy_Message   (0).Get_Bb);

    Assert_Equal (Protobuf_Unittest.TestAllTypes.BAR, Message.Get_Repeated_Nested_Enum (0));
    Assert_Equal (Protobuf_Unittest.FOREIGN_BAR     , Message.Get_Repeated_Foreign_Enum(0));
    Assert_Equal (Protobuf_Unittest_Import.Import_BAR      , Message.Get_Repeated_Import_Enum (0));


    -- Actually verify the second (modified) elements now.
    Assert_Equal (501  , Message.Get_Repeated_Int32   (1));
    Assert_Equal (502  , Message.Get_Repeated_Int64   (1));
    Assert_Equal (503  , Message.Get_Repeated_Uint32  (1));
    Assert_Equal (504  , Message.Get_Repeated_Uint64  (1));
    Assert_Equal (505  , Message.Get_Repeated_Sint32  (1));
    Assert_Equal (506  , Message.Get_Repeated_Sint64  (1));
    Assert_Equal (507  , Message.Get_Repeated_Fixed32 (1));
    Assert_Equal (508  , Message.Get_Repeated_Fixed64 (1));
    Assert_Equal (509  , Message.Get_Repeated_Sfixed32(1));
    Assert_Equal (510  , Message.Get_Repeated_Sfixed64(1));
    Assert_Equal (511.0, Message.Get_Repeated_Float   (1));
    Assert_Equal (512.0, Message.Get_Repeated_Double  (1));
    Assert_True  (       Message.Get_Repeated_Bool    (1));
    Assert_Equal ("515", Message.Get_Repeated_String  (1));
    Assert_Equal ("516", Message.Get_Repeated_Bytes   (1));

    Assert_Equal (518, Message.Get_Repeated_Nested_Message (1).Get_Bb);
    Assert_Equal (519, Message.Get_Repeated_Foreign_Message(1).Get_C);
    Assert_Equal (520, Message.Get_Repeated_Import_Message (1).Get_D);
    Assert_Equal (527, Message.Get_Repeated_Lazy_Message   (1).Get_Bb);

    Assert_Equal (Protobuf_Unittest.TestAllTypes.FOO, Message.Get_Repeated_Nested_Enum (1));
    Assert_Equal (Protobuf_Unittest.FOREIGN_FOO     , Message.Get_Repeated_Foreign_Enum(1));
    Assert_Equal (Protobuf_Unittest_Import.Import_FOO      , Message.Get_Repeated_Import_Enum (1));
  end Expect_Repeated_Fields_Modified;

  -----------------------------------
  -- Expect_Packed_Fields_Modified --
  -----------------------------------

  procedure Expect_Packed_Fields_Modified
    (Message : in Protobuf_Unittest.TestPackedTypes.Instance)
  is
  begin
    -- Do the same for Packed Repeated fields.
    Assert_Equal (2,  Message.Packed_Int32_Size   );
    Assert_Equal (2,  Message.Packed_Int64_Size   );
    Assert_Equal (2,  Message.Packed_Uint32_Size  );
    Assert_Equal (2,  Message.Packed_Uint64_Size  );
    Assert_Equal (2,  Message.Packed_Sint32_Size  );
    Assert_Equal (2,  Message.Packed_Sint64_Size  );
    Assert_Equal (2,  Message.Packed_Fixed32_Size );
    Assert_Equal (2,  Message.Packed_Fixed64_Size );
    Assert_Equal (2,  Message.Packed_Sfixed32_Size);
    Assert_Equal (2,  Message.Packed_Sfixed64_Size);
    Assert_Equal (2,  Message.Packed_Float_Size   );
    Assert_Equal (2,  Message.Packed_Double_Size  );
    Assert_Equal (2,  Message.Packed_Bool_Size    );
    Assert_Equal (2,  Message.Packed_Enum_Size    );


    Assert_Equal (601  , Message.Get_Packed_Int32   (0));
    Assert_Equal (602  , Message.Get_Packed_Int64   (0));
    Assert_Equal (603  , Message.Get_Packed_Uint32  (0));
    Assert_Equal (604  , Message.Get_Packed_Uint64  (0));
    Assert_Equal (605  , Message.Get_Packed_Sint32  (0));
    Assert_Equal (606  , Message.Get_Packed_Sint64  (0));
    Assert_Equal (607  , Message.Get_Packed_Fixed32 (0));
    Assert_Equal (608  , Message.Get_Packed_Fixed64 (0));
    Assert_Equal (609  , Message.Get_Packed_Sfixed32(0));
    Assert_Equal (610  , Message.Get_Packed_Sfixed64(0));
    Assert_Equal (611.0, Message.Get_Packed_Float   (0));
    Assert_Equal (612.0, Message.Get_Packed_Double  (0));
    Assert_True (        Message.Get_Packed_Bool    (0));
    Assert_Equal (Protobuf_Unittest.FOREIGN_BAR, Message.Get_Packed_Enum(0));


    -- Actually verify the second (modified) elements now.
    Assert_Equal (801  , Message.Get_Packed_Int32   (1));
    Assert_Equal (802  , Message.Get_Packed_Int64   (1));
    Assert_Equal (803  , Message.Get_Packed_Uint32  (1));
    Assert_Equal (804  , Message.Get_Packed_Uint64  (1));
    Assert_Equal (805  , Message.Get_Packed_Sint32  (1));
    Assert_Equal (806  , Message.Get_Packed_Sint64  (1));
    Assert_Equal (807  , Message.Get_Packed_Fixed32 (1));
    Assert_Equal (808  , Message.Get_Packed_Fixed64 (1));
    Assert_Equal (809  , Message.Get_Packed_Sfixed32(1));
    Assert_Equal (810  , Message.Get_Packed_Sfixed64(1));
    Assert_Equal (811.0, Message.Get_Packed_Float   (1));
    Assert_Equal (812.0, Message.Get_Packed_Double  (1));
    Assert_True (        Message.Get_Packed_Bool    (1));
    Assert_Equal (Protobuf_Unittest.FOREIGN_FOO, Message.Get_Packed_Enum(1));
  end Expect_Packed_Fields_Modified;

  ------------------
  -- Expect_Clear --
  ------------------

  procedure Expect_Clear (Message : in out Protobuf_Unittest.TestAllTypes.Instance) is
  begin
    -- has_Blah should initially be false for all Optional fields.
    Assert_False (Message.Has_Optional_Int32   );
    Assert_False (Message.Has_Optional_Int64   );
    Assert_False (Message.Has_Optional_Uint32  );
    Assert_False (Message.Has_Optional_Uint64  );
    Assert_False (Message.Has_Optional_Sint32  );
    Assert_False (Message.Has_Optional_Sint64  );
    Assert_False (Message.Has_Optional_Fixed32 );
    Assert_False (Message.Has_Optional_Fixed64 );
    Assert_False (Message.Has_Optional_Sfixed32);
    Assert_False (Message.Has_Optional_Sfixed64);
    Assert_False (Message.Has_Optional_Float   );
    Assert_False (Message.Has_Optional_Double  );
    Assert_False (Message.Has_Optional_Bool    );
    Assert_False (Message.Has_Optional_String  );
    Assert_False (Message.Has_Optional_Bytes   );

    Assert_False (Message.Has_Optional_Nested_Message       );
    Assert_False (Message.Has_Optional_Foreign_Message      );
    Assert_False (Message.Has_Optional_Import_Message       );
    Assert_False (Message.Has_Optional_Public_Import_Message);
    Assert_False (Message.Has_Optional_Lazy_Message         );

    Assert_False (Message.Has_Optional_Nested_Enum );
    Assert_False (Message.Has_Optional_Foreign_Enum);
    Assert_False (Message.Has_Optional_Import_Enum );

    Assert_False (Message.Has_Optional_String_piece);
    Assert_False (Message.Has_Optional_Cord);


    -- Optional fields without defaults are Set to zero or something like it.
    Assert_Equal (0    , Message.Get_Optional_Int32   );
    Assert_Equal (0    , Message.Get_Optional_Int64   );
    Assert_Equal (0    , Message.Get_Optional_Uint32  );
    Assert_Equal (0    , Message.Get_Optional_Uint64  );
    Assert_Equal (0    , Message.Get_Optional_Sint32  );
    Assert_Equal (0    , Message.Get_Optional_Sint64  );
    Assert_Equal (0    , Message.Get_Optional_Fixed32 );
    Assert_Equal (0    , Message.Get_Optional_Fixed64 );
    Assert_Equal (0    , Message.Get_Optional_Sfixed32);
    Assert_Equal (0    , Message.Get_Optional_Sfixed64);
    Assert_Equal (0.0  , Message.Get_Optional_Float   );
    Assert_Equal (0.0  , Message.Get_Optional_Double  );
    Assert_False (       Message.Get_Optional_Bool    );
    Assert_Equal (""   , Message.Get_Optional_String  );
    Assert_Equal (""   , Message.Get_Optional_Bytes   );

    -- Embedded Messages should also be clear.
    Assert_False (Message.Get_Optional_Nested_Message       .Has_Bb);
    Assert_False (Message.Get_Optional_Foreign_Message      .Has_C);
    Assert_False (Message.Get_Optional_Import_Message       .Has_D);
    Assert_False (Message.Get_Optional_Public_Import_Message.Has_E);
    Assert_False (Message.Get_Optional_Lazy_Message         .Has_Bb);

    Assert_Equal (0, Message.Get_Optional_Nested_Message       .Get_Bb);
    Assert_Equal (0, Message.Get_Optional_Foreign_Message      .Get_C);
    Assert_Equal (0, Message.Get_Optional_Import_Message       .Get_D);
    Assert_Equal (0, Message.Get_Optional_Public_Import_Message.Get_E);
    Assert_Equal (0, Message.Get_Optional_Lazy_Message         .Get_Bb);

    -- Enums without defaults are Set to the first value in the enum.
    Assert_Equal (Protobuf_Unittest.TestAllTypes.FOO , Message.Get_Optional_Nested_Enum );
    Assert_Equal (Protobuf_Unittest.FOREIGN_FOO      , Message.Get_Optional_Foreign_Enum);
    Assert_Equal (Protobuf_Unittest_Import.Import_FOO, Message.Get_Optional_Import_Enum );


    -- Repeated fields are empty.
    Assert_Equal (0, Message.Repeated_Int32_Size   );
    Assert_Equal (0, Message.Repeated_Int64_Size   );
    Assert_Equal (0, Message.Repeated_Uint32_Size  );
    Assert_Equal (0, Message.Repeated_Uint64_Size  );
    Assert_Equal (0, Message.Repeated_Sint32_Size  );
    Assert_Equal (0, Message.Repeated_Sint64_Size  );
    Assert_Equal (0, Message.Repeated_Fixed32_Size );
    Assert_Equal (0, Message.Repeated_Fixed64_Size );
    Assert_Equal (0, Message.Repeated_Sfixed32_Size);
    Assert_Equal (0, Message.Repeated_Sfixed64_Size);
    Assert_Equal (0, Message.Repeated_Float_Size   );
    Assert_Equal (0, Message.Repeated_Double_Size  );
    Assert_Equal (0, Message.Repeated_Bool_Size    );
    Assert_Equal (0, Message.Repeated_String_Size  );
    Assert_Equal (0, Message.Repeated_Bytes_Size   );

    Assert_Equal (0, Message.Repeated_Nested_Message_Size );
    Assert_Equal (0, Message.Repeated_Foreign_Message_Size);
    Assert_Equal (0, Message.Repeated_Import_Message_Size );
    Assert_Equal (0, Message.Repeated_Lazy_Message_Size   );
    Assert_Equal (0, Message.Repeated_Nested_Enum_Size    );
    Assert_Equal (0, Message.Repeated_Foreign_Enum_Size   );
    Assert_Equal (0, Message.Repeated_Import_Enum_Size    );

    Assert_Equal (0, Message.Repeated_String_piece_Size);
    Assert_Equal (0, Message.Repeated_Cord_Size);


    -- has_Blah should also be false for all default fields.
    Assert_False (Message.Has_Default_Int32   );
    Assert_False (Message.Has_Default_Int64   );
    Assert_False (Message.Has_Default_Uint32  );
    Assert_False (Message.Has_Default_Uint64  );
    Assert_False (Message.Has_Default_Sint32  );
    Assert_False (Message.Has_Default_Sint64  );
    Assert_False (Message.Has_Default_Fixed32 );
    Assert_False (Message.Has_Default_Fixed64 );
    Assert_False (Message.Has_Default_Sfixed32);
    Assert_False (Message.Has_Default_Sfixed64);
    Assert_False (Message.Has_Default_Float   );
    Assert_False (Message.Has_Default_Double  );
    Assert_False (Message.Has_Default_Bool    );
    Assert_False (Message.Has_Default_String  );
    Assert_False (Message.Has_Default_Bytes   );

    Assert_False (Message.Has_Default_Nested_Enum );
    Assert_False (Message.Has_Default_Foreign_Enum);
    Assert_False (Message.Has_Default_Import_Enum );


    -- Fields with defaults have their default values (duh).
    Assert_Equal ( 41    , Message.Get_Default_Int32   );
    Assert_Equal ( 42    , Message.Get_Default_Int64   );
    Assert_Equal ( 43    , Message.Get_Default_Uint32  );
    Assert_Equal ( 44    , Message.Get_Default_Uint64  );
    Assert_Equal (-45    , Message.Get_Default_Sint32  );
    Assert_Equal ( 46    , Message.Get_Default_Sint64  );
    Assert_Equal ( 47    , Message.Get_Default_Fixed32 );
    Assert_Equal ( 48    , Message.Get_Default_Fixed64 );
    Assert_Equal ( 49    , Message.Get_Default_Sfixed32);
    Assert_Equal (-50    , Message.Get_Default_Sfixed64);
    Assert_Equal ( 51.5  , Message.Get_Default_Float   );
    Assert_Equal ( 52.0e3, Message.Get_Default_Double  );
    Assert_True  (         Message.Get_Default_Bool   );
    Assert_Equal ("hello", Message.Get_Default_String  );
    Assert_Equal ("world", Message.Get_Default_Bytes   );

    Assert_Equal (Protobuf_Unittest.TestAllTypes.BAR, Message.Get_Default_Nested_Enum );
    Assert_Equal (Protobuf_Unittest.FOREIGN_BAR      , Message.Get_Default_Foreign_Enum);
    Assert_Equal (Protobuf_Unittest_Import.Import_BAR, Message.Get_Default_Import_Enum );
  end Expect_Clear;

  -------------------------
  -- Expect_Packed_Clear --
  -------------------------

  procedure Expect_Packed_Clear
    (Message : in Protobuf_Unittest.TestPackedTypes.Instance)
  is
  begin
    -- Packed Repeated fields are empty.
    Assert_Equal (0, Message.Packed_Int32_Size   );
    Assert_Equal (0, Message.Packed_Int64_Size   );
    Assert_Equal (0, Message.Packed_Uint32_Size  );
    Assert_Equal (0, Message.Packed_Uint64_Size  );
    Assert_Equal (0, Message.Packed_Sint32_Size  );
    Assert_Equal (0, Message.Packed_Sint64_Size  );
    Assert_Equal (0, Message.Packed_Fixed32_Size );
    Assert_Equal (0, Message.Packed_Fixed64_Size );
    Assert_Equal (0, Message.Packed_Sfixed32_Size);
    Assert_Equal (0, Message.Packed_Sfixed64_Size);
    Assert_Equal (0, Message.Packed_Float_Size   );
    Assert_Equal (0, Message.Packed_Double_Size  );
    Assert_Equal (0, Message.Packed_Bool_Size    );
    Assert_Equal (0, Message.Packed_Enum_Size    );
  end Expect_Packed_Clear;

  -----------------------------------
  -- Expect_Last_Repeateds_Removed --
  -----------------------------------

  procedure Expect_Last_Repeateds_Removed
    (Message : in Protobuf_Unittest.TestAllTypes.Instance)
  is
  begin
    Assert_Equal (1, Message.Repeated_Int32_Size   );
    Assert_Equal (1, Message.Repeated_Int64_Size   );
    Assert_Equal (1, Message.Repeated_Uint32_Size  );
    Assert_Equal (1, Message.Repeated_Uint64_Size  );
    Assert_Equal (1, Message.Repeated_Sint32_Size  );
    Assert_Equal (1, Message.Repeated_Sint64_Size  );
    Assert_Equal (1, Message.Repeated_Fixed32_Size );
    Assert_Equal (1, Message.Repeated_Fixed64_Size );
    Assert_Equal (1, Message.Repeated_Sfixed32_Size);
    Assert_Equal (1, Message.Repeated_Sfixed64_Size);
    Assert_Equal (1, Message.Repeated_Float_Size   );
    Assert_Equal (1, Message.Repeated_Double_Size  );
    Assert_Equal (1, Message.Repeated_Bool_Size    );
    Assert_Equal (1, Message.Repeated_String_Size  );
    Assert_Equal (1, Message.Repeated_Bytes_Size   );

    Assert_Equal (1, Message.Repeated_Nested_Message_Size );
    Assert_Equal (1, Message.Repeated_Foreign_Message_Size);
    Assert_Equal (1, Message.Repeated_Import_Message_Size );
    Assert_Equal (1, Message.Repeated_Import_Message_Size );
    Assert_Equal (1, Message.Repeated_Nested_Enum_Size    );
    Assert_Equal (1, Message.Repeated_Foreign_Enum_Size   );
    Assert_Equal (1, Message.Repeated_Import_Enum_Size    );


    -- Test that the remaining element is the correct one.
    Assert_Equal (201  , Message.Get_Repeated_Int32   (0));
    Assert_Equal (202  , Message.Get_Repeated_Int64   (0));
    Assert_Equal (203  , Message.Get_Repeated_Uint32  (0));
    Assert_Equal (204  , Message.Get_Repeated_Uint64  (0));
    Assert_Equal (205  , Message.Get_Repeated_Sint32  (0));
    Assert_Equal (206  , Message.Get_Repeated_Sint64  (0));
    Assert_Equal (207  , Message.Get_Repeated_Fixed32 (0));
    Assert_Equal (208  , Message.Get_Repeated_Fixed64 (0));
    Assert_Equal (209  , Message.Get_Repeated_Sfixed32(0));
    Assert_Equal (210  , Message.Get_Repeated_Sfixed64(0));
    Assert_Equal (211.0, Message.Get_Repeated_Float   (0));
    Assert_Equal (212.0, Message.Get_Repeated_Double  (0));
    Assert_True  (       Message.Get_Repeated_Bool    (0));
    Assert_Equal ("215", Message.Get_Repeated_String  (0));
    Assert_Equal ("216", Message.Get_Repeated_Bytes   (0));

    Assert_Equal (218, Message.Get_Repeated_Nested_Message (0).Get_Bb);
    Assert_Equal (219, Message.Get_Repeated_Foreign_Message(0).Get_C);
    Assert_Equal (220, Message.Get_Repeated_Import_Message (0).Get_D);
    Assert_Equal (220, Message.Get_Repeated_Import_Message (0).Get_D);

    Assert_Equal (Protobuf_Unittest.TestAllTypes.BAR , Message.Get_Repeated_Nested_Enum (0));
    Assert_Equal (Protobuf_Unittest.FOREIGN_BAR      , Message.Get_Repeated_Foreign_Enum(0));
    Assert_Equal (Protobuf_Unittest_Import.Import_BAR       , Message.Get_Repeated_Import_Enum (0));
  end Expect_Last_Repeateds_Removed;

  ------------------------------------
  -- Expect_Last_Repeateds_Released --
  ------------------------------------

  procedure Expect_Last_Repeateds_Released
    (Message : in Protobuf_Unittest.TestAllTypes.Instance)
  is
  begin
    Assert_Equal (1, Message.Repeated_Nested_Message_Size );
    Assert_Equal (1, Message.Repeated_Foreign_Message_Size);
    Assert_Equal (1, Message.Repeated_Import_Message_Size );
    Assert_Equal (1, Message.Repeated_Import_Message_Size );

    Assert_Equal (218, Message.Get_Repeated_Nested_Message (0).Get_Bb);
    Assert_Equal (219, Message.Get_Repeated_Foreign_Message(0).Get_C);
    Assert_Equal (220, Message.Get_Repeated_Import_Message (0).Get_D);
    Assert_Equal (220, Message.Get_Repeated_Import_Message (0).Get_D);
  end Expect_Last_Repeateds_Released;

  ------------------------------
  -- Expect_Repeateds_Swapped --
  ------------------------------

  procedure Expect_Repeateds_Swapped
    (Message : in Protobuf_Unittest.TestAllTypes.Instance)
  is
  begin
    Assert_Equal (2,  Message.Repeated_Int32_Size   );
    Assert_Equal (2,  Message.Repeated_Int64_Size   );
    Assert_Equal (2,  Message.Repeated_Uint32_Size  );
    Assert_Equal (2,  Message.Repeated_Uint64_Size  );
    Assert_Equal (2,  Message.Repeated_Sint32_Size  );
    Assert_Equal (2,  Message.Repeated_Sint64_Size  );
    Assert_Equal (2,  Message.Repeated_Fixed32_Size );
    Assert_Equal (2,  Message.Repeated_Fixed64_Size );
    Assert_Equal (2,  Message.Repeated_Sfixed32_Size);
    Assert_Equal (2,  Message.Repeated_Sfixed64_Size);
    Assert_Equal (2,  Message.Repeated_Float_Size   );
    Assert_Equal (2,  Message.Repeated_Double_Size  );
    Assert_Equal (2,  Message.Repeated_Bool_Size    );
    Assert_Equal (2,  Message.Repeated_String_Size  );
    Assert_Equal (2,  Message.Repeated_Bytes_Size   );

    Assert_Equal (2,  Message.Repeated_Nested_Message_Size );
    Assert_Equal (2,  Message.Repeated_Foreign_Message_Size);
    Assert_Equal (2,  Message.Repeated_Import_Message_Size );
    Assert_Equal (2,  Message.Repeated_Import_Message_Size );
    Assert_Equal (2,  Message.Repeated_Nested_Enum_Size    );
    Assert_Equal (2,  Message.Repeated_Foreign_Enum_Size   );
    Assert_Equal (2,  Message.Repeated_Import_Enum_Size    );


    -- Test that the first element and second element are flipped.
    Assert_Equal (201  , Message.Get_Repeated_Int32   (1));
    Assert_Equal (202  , Message.Get_Repeated_Int64   (1));
    Assert_Equal (203  , Message.Get_Repeated_Uint32  (1));
    Assert_Equal (204  , Message.Get_Repeated_Uint64  (1));
    Assert_Equal (205  , Message.Get_Repeated_Sint32  (1));
    Assert_Equal (206  , Message.Get_Repeated_Sint64  (1));
    Assert_Equal (207  , Message.Get_Repeated_Fixed32 (1));
    Assert_Equal (208  , Message.Get_Repeated_Fixed64 (1));
    Assert_Equal (209  , Message.Get_Repeated_Sfixed32(1));
    Assert_Equal (210  , Message.Get_Repeated_Sfixed64(1));
    Assert_Equal (211.0, Message.Get_Repeated_Float   (1));
    Assert_Equal (212.0, Message.Get_Repeated_Double  (1));
    Assert_True  (       Message.Get_Repeated_Bool    (1));
    Assert_Equal ("215", Message.Get_Repeated_String  (1));
    Assert_Equal ("216", Message.Get_Repeated_Bytes   (1));

    Assert_Equal (218, Message.Get_Repeated_Nested_Message (1).Get_Bb);
    Assert_Equal (219, Message.Get_Repeated_Foreign_Message(1).Get_C);
    Assert_Equal (220, Message.Get_Repeated_Import_Message (1).Get_D);

    Assert_Equal (Protobuf_Unittest.TestAllTypes.BAR, Message.Get_Repeated_Nested_Enum (1));
    Assert_Equal (Protobuf_Unittest.FOREIGN_BAR     , Message.Get_Repeated_Foreign_Enum(1));
    Assert_Equal (Protobuf_Unittest_Import.Import_BAR      , Message.Get_Repeated_Import_Enum (1));


    Assert_Equal (301  , Message.Get_Repeated_Int32   (0));
    Assert_Equal (302  , Message.Get_Repeated_Int64   (0));
    Assert_Equal (303  , Message.Get_Repeated_Uint32  (0));
    Assert_Equal (304  , Message.Get_Repeated_Uint64  (0));
    Assert_Equal (305  , Message.Get_Repeated_Sint32  (0));
    Assert_Equal (306  , Message.Get_Repeated_Sint64  (0));
    Assert_Equal (307  , Message.Get_Repeated_Fixed32 (0));
    Assert_Equal (308  , Message.Get_Repeated_Fixed64 (0));
    Assert_Equal (309  , Message.Get_Repeated_Sfixed32(0));
    Assert_Equal (310  , Message.Get_Repeated_Sfixed64(0));
    Assert_Equal (311.0, Message.Get_Repeated_Float   (0));
    Assert_Equal (312.0, Message.Get_Repeated_Double  (0));
    Assert_False (       Message.Get_Repeated_Bool    (0));
    Assert_Equal ("315", Message.Get_Repeated_String  (0));
    Assert_Equal ("316", Message.Get_Repeated_Bytes   (0));

    Assert_Equal (318, Message.Get_Repeated_Nested_Message (0).Get_Bb);
    Assert_Equal (319, Message.Get_Repeated_Foreign_Message(0).Get_C);
    Assert_Equal (320, Message.Get_Repeated_Import_Message (0).Get_D);

    Assert_Equal (Protobuf_Unittest.TestAllTypes.BAZ, Message.Get_Repeated_Nested_Enum (0));
    Assert_Equal (Protobuf_Unittest.FOREIGN_BAZ      , Message.Get_Repeated_Foreign_Enum(0));
    Assert_Equal (Protobuf_Unittest_Import.Import_BAZ, Message.Get_Repeated_Import_Enum (0));
  end Expect_Repeateds_Swapped;

end Test_Util;

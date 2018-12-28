with AUnit.Assertions;
with Ada.Streams;
with Ada.Exceptions;
with GNAT.Source_Info;
with Ada.Directories;
with Ada.Streams.Stream_IO;
with Interfaces;

with Protocol_Buffers.Wire_Format;
with Protocol_Buffers.IO.Coded_Input_Stream;
with Protocol_Buffers.IO.Coded_Output_Stream;
with Protocol_Buffers.IO.Invalid_Protocol_Buffer_Exception;
with Protocol_Buffers.Message;
with Buffered_Byte_Stream;
with Test_Helpers;
with Test_Util;
with Unittest.TestAllTypes;
with Unittest.TestRecursiveMessage;

package body Coded_Input_Stream_Tests is

  procedure Assert
    (Condition : Boolean;
     Message   : String;
     Source    : String := GNAT.Source_Info.File;
     Line      : Natural := GNAT.Source_Info.Line) renames AUnit.Assertions.Assert;
  package AS renames Ada.Streams;

  package CIS renames Protocol_Buffers.IO.Coded_Input_Stream;
  package COS renames Protocol_Buffers.IO.Coded_Output_Stream;
  package Wire_Format renames Protocol_Buffers.Wire_Format;
  package PB_Exception renames Protocol_Buffers.IO.Invalid_Protocol_Buffer_Exception;


  ----------
  -- Name --
  ----------

  function Name (T : Test_Case)
                 return Test_String is
    pragma Unreferenced (T);
  begin
    return Format ("Coded_Input_Stream_Tests");
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
       Routine => Test_Decode_Zig_Zag_32'Access,
       Name    => "Test_Decode_Zig_Zag_32");
    Register_Routine
      (Test    => T,
       Routine => Test_Decode_Zig_Zag_64'Access,
       Name    => "Test_Decode_Zig_Zag_64");
    Register_Routine
      (Test    => T,
       Routine => Test_Read_Raw_Little_Endian_32'Access,
       Name    => "Test_Read_Raw_Little_Endian_32");
    Register_Routine
      (Test    => T,
       Routine => Test_Read_Raw_Little_Endian_64'Access,
       Name    => "Test_Read_Raw_Little_Endian_64");
    Register_Routine
      (Test    => T,
       Routine => Test_Read_Raw_Varint_32'Access,
       Name    => "Test_Read_Raw_Varint_32");
    Register_Routine
      (Test    => T,
       Routine => Test_Read_Raw_Varint_64'Access,
       Name    => "Test_Read_Raw_Varint_64");
    Register_Routine
      (Test    => T,
       Routine => Test_Invalid_Tag'Access,
       Name    => "Test_Invalid_Tag");
    Register_Routine
      (Test    => T,
       Routine => Test_Write_And_Read_Whole_Message'Access,
       Name    => "Test_Write_And_Read_Whole_Message");
    Register_Routine
      (Test    => T,
       Routine => Test_Write_And_Read_Huge_Blob'Access,
       Name    => "Test_Write_And_Read_Huge_Blob");
    Register_Routine
      (Test    => T,
       Routine => Test_Read_Maliciously_Large_Blob'Access,
       Name    => "Test_Read_Maliciously_Large_Blob");
    Register_Routine
      (Test    => T,
       Routine => Test_Size_Limit'Access,
       Name    => "Test_Size_Limit");
    Register_Routine
      (Test    => T,
       Routine => Test_Malicious_Recursion'Access,
       Name    => "Test_Malicious_Recursion");
    Register_Routine
      (Test    => T,
       Routine => Test_Reset_Size_Counter'Access,
       Name    => "Test_Reset_Size_Counter");
  end Register_Tests;

  ----------------------------
  -- Test_Decode_Zig_Zag_32 --
  ----------------------------

  procedure Test_Decode_Zig_Zag_32 (T : in out Test_Cases.Test_Case'Class) is
    pragma Unreferenced (T);

    use type Wire_Format.PB_UInt32;
  begin
    Assert ( 0 = CIS.Decode_Zig_Zag_32 (0), "Expected: 0 = Decode_Zig_Zag_32 (0)");
    Assert (-1 = CIS.Decode_Zig_Zag_32 (1), "Expected: -1 = Decode_Zig_Zag_32 (1)");
    Assert ( 1 = CIS.Decode_Zig_Zag_32 (2), "Expected: 1 = Decode_Zig_Zag_32 (2)");
    Assert (-2 = CIS.Decode_Zig_Zag_32 (3), "Expected: -2 = Decode_Zig_Zag_32 (3)");
    Assert ( 2 = CIS.Decode_Zig_Zag_32 (4), "Expected: 2 = Decode_Zig_Zag_32 (4)");

    Assert (16#3FFF_FFFF# = CIS.Decode_Zig_Zag_32 (16#7FFF_FFFE#),
            "Expected: 0x3FFFFFFF = Decode_Zig_Zag_32 (0x7FFFFFFE)");
    Assert (16#C000_0000# = CIS.Decode_Zig_Zag_32 (16#7FFF_FFFF#),
            "Expected: 0xC0000000 = Decode_Zig_Zag_32 (0x7FFFFFFF)");
    Assert (16#7FFF_FFFF# = CIS.Decode_Zig_Zag_32 (16#FFFF_FFFE#),
            "Expected: 0x7FFFFFFF = Decode_Zig_Zag_32 (0xFFFFFFFE)");
    Assert (16#8000_0000# = CIS.Decode_Zig_Zag_32 (16#FFFF_FFFF#),
            "Expected: 0x80000000 = Decode_Zig_Zag_32 (0xFFFFFFFF)");
  end Test_Decode_Zig_Zag_32;

  ----------------------------
  -- Test_Decode_Zig_Zag_64 --
  ----------------------------

  procedure Test_Decode_Zig_Zag_64 (T : in out Test_Cases.Test_Case'Class) is
    pragma Unreferenced (T);

    package CIS renames Protocol_Buffers.IO.Coded_Input_Stream;

    use type Wire_Format.PB_UInt64;
  begin
    Assert ( 0 = CIS.Decode_Zig_Zag_64 (0), "Expected: 0 = Decode_Zig_Zag_64 (0)");
    Assert (-1 = CIS.Decode_Zig_Zag_64 (1), "Expected: -1 = Decode_Zig_Zag_64 (1)");
    Assert ( 1 = CIS.Decode_Zig_Zag_64 (2), "Expected: 1 = Decode_Zig_Zag_64 (2)");
    Assert (-2 = CIS.Decode_Zig_Zag_64 (3), "Expected: -2 = Decode_Zig_Zag_64 (3)");
    Assert ( 2 = CIS.Decode_Zig_Zag_64 (4), "Expected: 2 = Decode_Zig_Zag_64 (4)");
    Assert (16#0000_0000_3FFF_FFFF# = CIS.Decode_Zig_Zag_64 (16#0000_0000_7FFF_FFFE#),
            "Expected: 0x000000003FFFFFFF = Decode_Zig_Zag_64 (0x000000007FFFFFFE)");

    Assert (16#FFFF_FFFF_C000_0000# = CIS.Decode_Zig_Zag_64 (16#0000_0000_7FFF_FFFF#),
            "Expected: 0xFFFFFFFFC0000000 = Decode_Zig_Zag_64 (0x000000007FFFFFFF)");
    Assert (16#0000_0000_7FFF_FFFF# = CIS.Decode_Zig_Zag_64 (16#0000_0000_FFFF_FFFE#),
            "Expected: 0x000000007FFFFFFF = Decode_Zig_Zag_64 (0x00000000FFFFFFFE)");
    Assert (16#FFFF_FFFF_8000_0000# = CIS.Decode_Zig_Zag_64 (16#0000_0000_FFFF_FFFF#),
            "Expected: 0xFFFFFFFF80000000 = Decode_Zig_Zag_64 (0x00000000FFFFFFFF)");
    Assert (16#7FFF_FFFF_FFFF_FFFF# = CIS.Decode_Zig_Zag_64 (16#FFFF_FFFF_FFFF_FFFE#),
            "Expected: 0x7FFFFFFFFFFFFFFF = Decode_Zig_Zag_64 (0xFFFFFFFFFFFFFFFE)");
    Assert (16#8000_0000_0000_0000# = CIS.Decode_Zig_Zag_64 (16#FFFF_FFFF_FFFF_FFFF#),
            "Expected: 0x8000000000000000 = Decode_Zig_Zag_64 (0xFFFFFFFFFFFFFFFF)");
  end Test_Decode_Zig_Zag_64;

  ------------------------------------
  -- Test_Read_Raw_Little_Endian_32 --
  ------------------------------------

  procedure Test_Read_Raw_Little_Endian_32
    (T : in out Test_Cases.Test_Case'Class)
  is
    pragma Unreferenced (T);
  begin
    Test_Helpers.Assert_Read_Raw_Little_Endian_32
      (Ada.Streams.Stream_Element_Array'(16#78#, 16#56#, 16#34#, 16#12#),
       16#12345678#);
    Test_Helpers.Assert_Read_Raw_Little_Endian_32
      (Ada.Streams.Stream_Element_Array'(16#F0#, 16#DE#, 16#BC#, 16#9A#),
       16#9ABCDEF0#);
  end Test_Read_Raw_Little_Endian_32;

  ------------------------------------
  -- Test_Read_Raw_Little_Endian_64 --
  ------------------------------------

  procedure Test_Read_Raw_Little_Endian_64
    (T : in out Test_Cases.Test_Case'Class)
  is
    pragma Unreferenced (T);
  begin
    Test_Helpers.Assert_Read_Raw_Little_Endian_64
      (AS.Stream_Element_Array'
         (16#F0#, 16#DE#, 16#BC#, 16#9A#, 16#78#, 16#56#, 16#34#, 16#12#),
       16#123456789ABCDEF0#);
    Test_Helpers.Assert_Read_Raw_Little_Endian_64
      (AS.Stream_Element_Array'
         (16#78#, 16#56#, 16#34#, 16#12#, 16#F0#, 16#DE#, 16#BC#, 16#9A#),
       16#9ABCDEF012345678#);
  end Test_Read_Raw_Little_Endian_64;

  -----------------------------
  -- Test_Read_Raw_Varint_32 --
  -----------------------------

  procedure Test_Read_Raw_Varint_32 (T : in out Test_Cases.Test_Case'Class)
  is
    pragma Unreferenced (T);
  begin
    Test_Helpers.Assert_Read_Raw_Varint
      (AS.Stream_Element_Array'(0 => 16#0#), 0);
    Test_Helpers.Assert_Read_Raw_Varint
      (AS.Stream_Element_Array'(0 => 16#01#), 1);
    Test_Helpers.Assert_Read_Raw_Varint
      (AS.Stream_Element_Array'(0 => 16#7F#), 127);
    Test_Helpers.Assert_Read_Raw_Varint
      (AS.Stream_Element_Array'(16#A2#, 16#74#), 14882);
    Test_Helpers.Assert_Read_Raw_Varint
      (AS.Stream_Element_Array'(16#BE#, 16#F7#, 16#92#, 16#84#, 16#0B#),
       2961488830);
  end Test_Read_Raw_Varint_32;

  -----------------------------
  -- Test_Read_Raw_Varint_64 --
  -----------------------------

  procedure Test_Read_Raw_Varint_64 (T : in out Test_Cases.Test_Case'Class)
  is
    pragma Unreferenced (T);
  begin
    Test_Helpers.Assert_Read_Raw_Varint
      (AS.Stream_Element_Array'(16#BE#, 16#F7#, 16#92#, 16#84#, 16#1B#),
       7256456126);
    Test_Helpers.Assert_Read_Raw_Varint
      (AS.Stream_Element_Array'
         (16#80#, 16#E6#, 16#EB#, 16#9C#, 16#C3#, 16#C9#, 16#A4#, 16#49#),
       41256202580718336);
    Test_Helpers.Assert_Read_Raw_Varint
      (AS.Stream_Element_Array'
         (16#9B#, 16#A8#, 16#F9#, 16#C2#, 16#BB#, 16#D6#, 16#80#, 16#85#, 16#A6#, 16#01#),
       11964378330978735131);
  end Test_Read_Raw_Varint_64;

  ----------------------
  -- Test_Invalid_Tag --
  ----------------------

  procedure Test_Invalid_Tag (T : in out Test_Cases.Test_Case'Class) is
    pragma Unreferenced (T);

    Data          : constant Ada.Streams.Stream_Element_Array (1 .. 8) := (others => 0);
    Buffer_Stream : Buffered_Byte_Stream.Byte_Stream_Access := new Buffered_Byte_Stream.Byte_Stream (8);
    Input_Stream  : CIS.Instance (CIS.Root_Stream_Access (Buffer_Stream));

    Tag : Wire_Format.PB_UInt32;
    pragma Unreferenced (Tag);
  begin
    Buffered_Byte_Stream.Empty_And_Load_Buffer (Buffer_Stream, Data);
    begin
      -- Try reading an invalid tag (in this case 0) and see that it raises
      -- a Protocol_Buffer_Exception with an invalid tag message.
      Tag := Input_Stream.Read_Tag;
      Assert (False, "Should have thrown an exception");
    exception
      when Error : PB_Exception.Protocol_Buffer_Exception =>
        declare
          Exception_Message : String :=
            Ada.Exceptions.Exception_Message (Error);

          Message : String :=
            "Expected exception message to equal: " &
            PB_Exception.Invalid_Tag_Message & " was: " &
            Exception_Message;
        begin
          Assert (Exception_Message = PB_Exception.Invalid_Tag_Message,
                  Message);
        end;
    end;
    Buffered_Byte_Stream.Free (Buffer_Stream);
  end Test_Invalid_Tag;

  ---------------------
  -- Test_Size_Limit --
  ---------------------

  procedure Test_Size_Limit (T : in out Test_Cases.Test_Case'Class) is
    pragma Unreferenced (T);

    Stream    : Ada.Streams.Stream_IO.Stream_Access;
    File      : Ada.Streams.Stream_IO.File_Type;
    Test_File : String := "test_size_limit_file";

    Message : Unittest.TestAllTypes.Instance;
  begin
    Test_Util.Set_All_Fields (Message);

    -- Write Message to file.
    Ada.Streams.Stream_IO.Create (File => File,
                                  Mode => Ada.Streams.Stream_IO.Out_File,
                                  Name => Test_File);
    Stream := Ada.Streams.Stream_IO.Stream (File);
    Message.Serialize_To_Output_Stream (Stream);
    Ada.Streams.Stream_IO.Close (File);

    -- Parse Message from file
    Ada.Streams.Stream_IO.Open (File => File,
                                Mode => Ada.Streams.Stream_IO.In_File,
                                Name => Test_File);
    Stream := Ada.Streams.Stream_IO.Stream (File);

    declare
      Coded_Input_Stream : CIS.Instance (CIS.Root_Stream_Access (Stream));
      Dummy              : AS.Stream_Element_Count := Coded_Input_Stream.Set_Size_Limit (16);
      pragma Unreferenced (Dummy);
    begin
      begin
        Message.Parse_From_Coded_Input_Stream (Coded_Input_Stream);
        Assert (False, "Should have raised an exception!");
      end;
    exception
      when Error : PB_Exception.Protocol_Buffer_Exception =>
        declare
          Exception_Message : String :=
            Ada.Exceptions.Exception_Message (Error);

          Message : String :=
            "Expected exception message to equal: " &
            PB_Exception.Size_Limit_Exceeded_Message & " was: " &
            Exception_Message;
        begin
          Assert (Exception_Message = PB_Exception.Size_Limit_Exceeded_Message,
                  Message);
        end;
    end;

    Ada.Streams.Stream_IO.Delete (File);
  end Test_Size_Limit;


  -----------------------------------
  -- Make_Recursive_Message --
  -----------------------------------

  function Make_Recursive_Message (Depth : in Natural) return Unittest.TestRecursiveMessage.TestRecursiveMessage_Access is
    A_Recursive_Message : Unittest.TestRecursiveMessage.TestRecursiveMessage_Access :=
      new Unittest.TestRecursiveMessage.Instance;
  begin
    if Depth = 0 then
      A_Recursive_Message.Set_I (5);
      return A_Recursive_Message;
    else
      A_Recursive_Message.Set_A (Make_Recursive_Message (Depth - 1));
      return A_Recursive_Message;
    end if;
  end Make_Recursive_Message;

  --------------------------
  -- Assert_Message_Depth --
  --------------------------

  procedure Assert_Message_Depth (Message : access Unittest.TestRecursiveMessage.Instance; Depth : in Natural) is
    use type Wire_Format.PB_Int32;
  begin
    if Depth = 0 then
      Assert (False = Message.Has_A, "");
      Assert (5 = Message.Get_I, "");
    else
      Assert (True = Message.Has_A, "");
      Assert_Message_Depth (Message.Get_A, Depth - 1);
    end if;
  end Assert_Message_Depth;

  ------------------------------
  -- Test_Malicious_Recursion --
  ------------------------------

  procedure Test_Malicious_Recursion (T : in out Test_Cases.Test_Case'Class) is
    pragma Unreferenced (T);

    Stream    : Ada.Streams.Stream_IO.Stream_Access;
    File      : Ada.Streams.Stream_IO.File_Type;
    Test_File : String := "test_malicious_recursion_file";

    Message_64   : Unittest.TestRecursiveMessage.Instance;
    Message_64_2 : aliased Unittest.TestRecursiveMessage.Instance;
    Message_65   : Unittest.TestRecursiveMessage.Instance;
    Message_65_2 : aliased Unittest.TestRecursiveMessage.Instance;
  begin
    Message_64.Set_A (Make_Recursive_Message (63));
    Message_65.Set_A (Make_Recursive_Message (64));

    -- Write Message_64 to file.
    Ada.Streams.Stream_IO.Create (File => File,
                                  Mode => Ada.Streams.Stream_IO.Out_File,
                                  Name => Test_File);
    Stream := Ada.Streams.Stream_IO.Stream (File);
    Message_64.Serialize_To_Output_Stream (Stream);
    Ada.Streams.Stream_IO.Close (File);

    -- Check that Get_Cached_Size returns file size
    declare
      Test_File_Size : Ada.Directories.File_Size :=
        Ada.Directories.Size (Test_File);
      Cached_Size    : Ada.Directories.File_Size :=
        Ada.Directories.File_Size (Message_64.Get_Cached_Size);

      use type Ada.Directories.File_Size;
    begin
      Assert (Test_File_Size = Cached_Size,
              "Expected Get_Cached_Size to equal file size (bytes). " &
                "Get_Cached_Size:" &
                Ada.Directories.File_Size'Image (Cached_Size) &
                " file size: " & Ada.Directories.File_Size'Image (Test_File_Size));
    end;

    -- Parse Message_64 from file to Message_64_2
    Ada.Streams.Stream_IO.Open (File => File,
                                Mode => Ada.Streams.Stream_IO.In_File,
                                Name => Test_File);
    Stream := Ada.Streams.Stream_IO.Stream (File);
    Message_64_2.Parse_From_Input_Stream (Stream);

    --Assert_Message_Depth (Message_64_2'Access, 64);

    Ada.Streams.Stream_IO.Delete (File);

    -- Write Message_65 to file.
    Ada.Streams.Stream_IO.Create (File => File,
                                  Mode => Ada.Streams.Stream_IO.Out_File,
                                  Name => Test_File);
    Stream := Ada.Streams.Stream_IO.Stream (File);
    Message_65.Serialize_To_Output_Stream (Stream);
    Ada.Streams.Stream_IO.Close (File);

    -- Parse Message_65 from file to Message_65_2
    begin
      Ada.Streams.Stream_IO.Open (File => File,
                                  Mode => Ada.Streams.Stream_IO.In_File,
                                  Name => Test_File);
      Stream := Ada.Streams.Stream_IO.Stream (File);
      Message_65_2.Parse_From_Input_Stream (Stream);

      Assert_Message_Depth (Message_65_2'Access, 65);
      Assert (False, "Should have raised an exception!");
    exception
      when Error : PB_Exception.Protocol_Buffer_Exception =>
        declare
          Exception_Message : String :=
            Ada.Exceptions.Exception_Message (Error);

          Message : String :=
            "Expected exception message to equal: " &
            PB_Exception.Recursion_Limit_Exceeded_Message & " was: " &
            Exception_Message;
        begin
          Assert (Exception_Message = PB_Exception.Recursion_Limit_Exceeded_Message,
                  Message);
        end;
    end;

    Ada.Streams.Stream_IO.Delete (File);
  end Test_Malicious_Recursion;

  -----------------------------------
  -- Test_Write_And_Read_Huge_Blob --
  -----------------------------------

  procedure Test_Write_And_Read_Huge_Blob (T : in out Test_Cases.Test_Case'Class) is
    pragma Unreferenced (T);

    Stream    : Ada.Streams.Stream_IO.Stream_Access;
    File      : Ada.Streams.Stream_IO.File_Type;
    Test_File : String := "test_write_and_read_huge_blob_file";

    Message   : Unittest.TestAllTypes.Instance;
    Message_2 : Unittest.TestAllTypes.Instance;
    Message_3 : Unittest.TestAllTypes.Instance;

    -- 1 MB Blob
    Blob : Wire_Format.PB_String (1 .. 2 ** 20);
  begin
    for K in Blob'Range loop
      Blob (K) := Character'Val (K mod 256);
    end loop;

    Test_Util.Set_All_Fields (Message);
    Message.Set_Optional_Bytes (Blob);

    -- Write Message to file.
    Ada.Streams.Stream_IO.Create (File => File,
                                  Mode => Ada.Streams.Stream_IO.Out_File,
                                  Name => Test_File);
    Stream := Ada.Streams.Stream_IO.Stream (File);
    Message.Serialize_To_Output_Stream (Stream);
    Ada.Streams.Stream_IO.Close (File);

    -- Check that Get_Cached_Size returns file size
    declare
      Test_File_Size : Ada.Directories.File_Size :=
        Ada.Directories.Size (Test_File);
      Cached_Size    : Ada.Directories.File_Size :=
        Ada.Directories.File_Size (Message.Get_Cached_Size);

      use type Ada.Directories.File_Size;
    begin
      Assert (Test_File_Size = Cached_Size,
              "Expected Get_Cached_Size to equal file size (bytes). " &
                "Get_Cached_Size:" &
                Ada.Directories.File_Size'Image (Cached_Size) &
                " file size: " & Ada.Directories.File_Size'Image (Test_File_Size));
    end;

    -- Parse Message from file to Message_2.
    Ada.Streams.Stream_IO.Open (File => File,
                                Mode => Ada.Streams.Stream_IO.In_File,
                                Name => Test_File);
    Stream := Ada.Streams.Stream_IO.Stream (File);
    Message_2.Parse_From_Input_Stream (Stream);

    Assert (Message.Get_Optional_Bytes = Message_2.Get_Optional_Bytes,
            "Write and read of field optional bytes should return the same " &
              "contents");

    -- Reset field optional bytes in Message_2
    Test_Util.Set_All_Fields (Message);
    Message_2.Set_Optional_Bytes (Message.Get_Optional_Bytes);

    Test_Util.Expect_All_Fields_Set (Message_2);

    Ada.Streams.Stream_IO.Delete (File);
  end Test_Write_And_Read_Huge_Blob;

  --------------------------------------
  -- Test_Read_Maliciously_Large_Blob --
  --------------------------------------

  procedure Test_Read_Maliciously_Large_Blob (T : in out Test_Cases.Test_Case'Class) is
    pragma Unreferenced (T);

    Stream    : Ada.Streams.Stream_IO.Stream_Access;
    File      : Ada.Streams.Stream_IO.File_Type;
    Test_File : String := "test_read_maliciously_large_blob_file";

    Tag   : Wire_Format.PB_UInt32;
    Bytes : array (1 .. 32) of Wire_Format.PB_Byte;
    pragma Unmodified (Bytes);


  begin
    Ada.Streams.Stream_IO.Create (File => File,
                                  Mode => Ada.Streams.Stream_IO.Out_File,
                                  Name => Test_File);
    Stream := Ada.Streams.Stream_IO.Stream (File);

    -- Write malicious blob
    declare
      Coded_Output_Stream : COS.Instance (COS.Root_Stream_Access (Stream));
    begin
      Tag := Wire_Format.Make_Tag (1, Wire_Format.LENGTH_DELIMITED);
      Coded_Output_Stream.Write_Raw_Varint_32 (Tag);
      Coded_Output_Stream.Write_Raw_Varint_32 (16#7FFF_FFFF#);
      -- Pad with semi random bytes
      for K in Bytes'Range loop
        Coded_Output_Stream.Write_Raw_Byte (Bytes(K));
      end loop;
    end;
    Ada.Streams.Stream_IO.Close (File);

    -- Try reading malicious blob
    Ada.Streams.Stream_IO.Open (File => File,
                                Mode => Ada.Streams.Stream_IO.In_File,
                                Name => Test_File);
    Stream := Ada.Streams.Stream_IO.Stream (File);

    declare
      Coded_Input_Stream : CIS.Instance (CIS.Root_Stream_Access (Stream));

      use type Wire_Format.PB_UInt32;
    begin
      Assert (Tag = Coded_Input_Stream.Read_Tag,
              "Expected: Tag = Coded_Input_Stream.Read_Tag");

      declare
        Blob : Wire_Format.PB_String_Access := Coded_Input_Stream.Read_String;
      begin
        Assert (False, "Should have raised an exception!");
      end;
    exception
      when PB_Exception.Protocol_Buffer_Exception =>
        -- Success
        null;
    end;

    Ada.Streams.Stream_IO.Delete (File);
  end Test_Read_Maliciously_Large_Blob;

  -----------------------------
  -- Test_Reset_Size_Counter --
  -----------------------------

  procedure Test_Reset_Size_Counter (T : in out Test_Cases.Test_Case'Class) is
    pragma Unreferenced (T);

    Stream    : Ada.Streams.Stream_IO.Stream_Access;
    File      : Ada.Streams.Stream_IO.File_Type;
    Test_File : String := "test_reset_size_counter_file";

    Bytes : Wire_Format.PB_String (1 .. 32768) := (others => '1');
  begin
    -- Write some bytes to file.
    Ada.Streams.Stream_IO.Create (File => File,
                                  Mode => Ada.Streams.Stream_IO.Out_File,
                                  Name => Test_File);
    Stream := Ada.Streams.Stream_IO.Stream (File);


    declare
      Coded_Output_Stream : COS.Instance (COS.Root_Stream_Access (Stream));
    begin
      Coded_Output_Stream.Write_String_No_Tag (Bytes);
    end;
    Ada.Streams.Stream_IO.Close (File);

    -- Read some bytes from file.
    Ada.Streams.Stream_IO.Open (File => File,
                                Mode => Ada.Streams.Stream_IO.In_File,
                                Name => Test_File);
    Stream := Ada.Streams.Stream_IO.Stream (File);

    declare
      Coded_Input_Stream : CIS.Instance (CIS.Root_Stream_Access (Stream));
      Dummy_1            : AS.Stream_Element_Count := Coded_Input_Stream.Set_Size_Limit (8096);
      Dummy_2            : AS.Stream_Element_Array := Coded_Input_Stream.Read_Raw_Bytes (8096);
      Dummy_3            : Wire_Format.PB_Byte;
      pragma Unreferenced (Dummy_1, Dummy_2);
      Total_Bytes_Read   : AS.Stream_Element_Offset := Coded_Input_Stream.Get_Total_Bytes_Read;

      use type AS.Stream_Element_Offset;
    begin
      Assert (8096 = Total_Bytes_Read,
              "Expected Get_Total_Bytes to return 8096. Returned:" &
                AS.Stream_Element_Count'Image (Total_Bytes_Read));

      begin
        Dummy_3 := Coded_Input_Stream.Read_Raw_Byte;
        Assert (False, "Should have raised an exception!");
      exception
        when PB_Exception.Protocol_Buffer_Exception =>
          -- Success!
          null;
      end;

      Coded_Input_Stream.Reset_Size_Counter;

      Assert (0 = Coded_Input_Stream.Get_Total_Bytes_Read,
              "Expected Get_Total_Bytes to return 0. Returned:" &
                As.Stream_Element_Count'Image (Coded_Input_Stream.Get_Total_Bytes_Read));

      Dummy_1 := Coded_Input_Stream.Get_Total_Bytes_Read;
      -- Check that this doesn't throw an exception!
      Dummy_3 := Coded_Input_Stream.Read_Raw_Byte;
      Coded_Input_Stream.Reset_Size_Counter;
      Assert (0 = Coded_Input_Stream.Get_Total_Bytes_Read,
              "Expected Get_Total_Bytes to return 0. Returned:" &
                As.Stream_Element_Count'Image (Coded_Input_Stream.Get_Total_Bytes_Read));
    end;

  end Test_Reset_Size_Counter;

  -----------------------------
  -- Test_Read_Whole_Message --
  -----------------------------

  procedure Test_Write_And_Read_Whole_Message (T : in out Test_Cases.Test_Case'Class) is
    pragma Unreferenced (T);

    Stream    : Ada.Streams.Stream_IO.Stream_Access;
    File      : Ada.Streams.Stream_IO.File_Type;
    Test_File : String := "test_write_and_read_whole_message_file";

    Message   : Unittest.TestAllTypes.Instance;
    Message_2 : Unittest.TestAllTypes.Instance;
  begin
    Test_Util.Set_All_Fields (Message);

    -- Write Message to file.
    Ada.Streams.Stream_IO.Create (File => File,
                                  Mode => Ada.Streams.Stream_IO.Out_File,
                                  Name => Test_File);
    Stream := Ada.Streams.Stream_IO.Stream (File);
    Message.Serialize_To_Output_Stream (Stream);
    Ada.Streams.Stream_IO.Close (File);

    -- Check that Get_Cached_Size returns file size.
    declare
      Test_File_Size : Ada.Directories.File_Size :=
        Ada.Directories.Size (Test_File);
      Cached_Size    : Ada.Directories.File_Size :=
        Ada.Directories.File_Size (Message.Get_Cached_Size);

      use type Ada.Directories.File_Size;
    begin
      Assert (Test_File_Size = Cached_Size,
              "Expected Get_Cached_Size to equal file size (bytes). " &
                "Get_Cached_Size:" &
                Ada.Directories.File_Size'Image (Cached_Size) &
                " file size: " & Ada.Directories.File_Size'Image (Test_File_Size));
    end;

    -- Parse Message from file to Message_2.
    Ada.Streams.Stream_IO.Open (File => File,
                                Mode => Ada.Streams.Stream_IO.In_File,
                                Name => Test_File);
    Stream := Ada.Streams.Stream_IO.Stream (File);
    Message_2.Parse_From_Input_Stream (Stream);

    -- Check that all fields are set as expected.
    Test_Util.Expect_All_Fields_Set (Message_2);

    Ada.Streams.Stream_IO.Delete (File);
  end Test_Write_And_Read_Whole_Message;

end Coded_Input_Stream_Tests;

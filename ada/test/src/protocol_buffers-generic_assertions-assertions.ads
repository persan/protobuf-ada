with AUnit.Assertions;
with Protocol_Buffers.Wire_Format;

package Protocol_Buffers.Generic_Assertions.Assertions is
  use type Protocol_Buffers.Wire_Format.PB_String;
  use type Protocol_Buffers.Wire_Format.PB_Byte;
  use type Protocol_Buffers.Wire_Format.PB_UInt32;
  use type Protocol_Buffers.Wire_Format.PB_UInt64;
  use type Protocol_Buffers.Wire_Format.PB_Double;
  use type Protocol_Buffers.Wire_Format.PB_Float;
  use type Protocol_Buffers.Wire_Format.PB_Bool;
  use type Protocol_Buffers.Wire_Format.PB_Int32;
  use type Protocol_Buffers.Wire_Format.PB_Int64;
  use type Protocol_Buffers.Wire_Format.PB_Field_Type;
  use type Protocol_Buffers.Wire_Format.PB_Wire_Type;
  use type Protocol_Buffers.Wire_Format.PB_Object_Size;
  use type Protocol_Buffers.Wire_Format.PB_String_Access;

  procedure Assert
    (Condition   : in Boolean;
     Message     : in String;
     Source_Info : in String := GNAT.Source_Info.File;
     File_Info   : in Natural := GNAT.Source_Info.Line) renames AUnit.Assertions.Assert;

  procedure Assert_Equal is new Generic_Equal (Protocol_Buffers.Wire_Format.PB_Int32);
  procedure Assert_Equal is new Generic_Equal (Protocol_Buffers.Wire_Format.PB_UInt32);
  procedure Assert_Equal is new Generic_Equal (Protocol_Buffers.Wire_Format.PB_UInt64);
  procedure Assert_Equal is new Generic_Equal (Protocol_Buffers.Wire_Format.PB_Double);
  procedure Assert_Equal is new Generic_Equal (Protocol_Buffers.Wire_Format.PB_Float);
   procedure Assert_Equal is new Generic_Equal (Protocol_Buffers.Wire_Format.PB_Int64);
   procedure Assert_Equal is new Generic_Equal (Protocol_Buffers.Wire_Format.PB_Object_Size);

  procedure Assert_Equal
    (Expected    : in Protocol_Buffers.Wire_Format.PB_String;
     Actual      : in Protocol_Buffers.Wire_Format.PB_String;
     Source_Info : in String := GNAT.Source_Info.File;
     File_Info   : in Natural := GNAT.Source_Info.Line);

  procedure Assert_True
    (Actual      : in Boolean;
     Source_Info : in String := GNAT.Source_Info.File;
     File_Info   : in Natural := GNAT.Source_Info.Line);

  procedure Assert_False
    (Actual      : in Boolean;
     Source_Info : in String := GNAT.Source_Info.File;
     File_Info   : in Natural := GNAT.Source_Info.Line);
end Protocol_Buffers.Generic_Assertions.Assertions;

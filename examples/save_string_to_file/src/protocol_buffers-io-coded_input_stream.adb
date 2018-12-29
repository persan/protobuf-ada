pragma Ada_2012;

with Ada.Unchecked_Conversion;
with Ada.IO_Exceptions;

package body Protocol_Buffers.IO.Coded_Input_Stream is

   -----------------------
   -- Decode_Zig_Zag_32 --
   -----------------------

   function Decode_Zig_Zag_32
     (Value : in TMP_UNSIGNED_INTEGER)
      return TMP_UNSIGNED_INTEGER
   is
      Value_To_Unsigned_32 : Interfaces.Unsigned_32 := Interfaces.Unsigned_32 (Value);
      use type Interfaces.Unsigned_32;
   begin
      return TMP_UNSIGNED_INTEGER (Interfaces.Shift_Right (Value_To_Unsigned_32, 1) xor - (Value_To_Unsigned_32 and 1));
   end Decode_Zig_Zag_32;

   -----------------------
   -- Decode_Zig_Zag_64 --
   -----------------------

   function Decode_Zig_Zag_64
     (Value : in TMP_UNSIGNED_LONG)
      return TMP_UNSIGNED_LONG
   is
      Value_To_Unsigned_64 : Interfaces.Unsigned_64 := Interfaces.Unsigned_64 (Value);
      use type Interfaces.Unsigned_64;
   begin
      return TMP_UNSIGNED_LONG (Interfaces.Shift_Right (Value_To_Unsigned_64, 1) xor - (Value_To_Unsigned_64 and 1));
   end Decode_Zig_Zag_64;

   ------------------
   -- Read_Boolean --
   ------------------

   function Read_Boolean
     (The_Coded_Input_Stream : in Coded_Input_Stream.Instance)
      return TMP_BOOLEAN
   is
      function BOOLEAN_TO_TMP_BOOLEAN is new Ada.Unchecked_Conversion (Source => Boolean,
                                                                       Target => TMP_BOOLEAN);
      use type TMP_UNSIGNED_BYTE;
   begin
      return BOOLEAN_TO_TMP_BOOLEAN (The_Coded_Input_Stream.Read_Raw_Byte /= 0);
   end Read_Boolean;

   -----------------
   -- Read_Double --
   -----------------

   function Read_Double
     (The_Coded_Input_Stream : in Coded_Input_Stream.Instance)
      return TMP_DOUBLE
   is
      function TMP_UNSIGNED_LONG_To_TMP_DOUBLE is new Ada.Unchecked_Conversion (Source => TMP_UNSIGNED_LONG,
                                                                                Target => TMP_DOUBLE);
   begin
      return TMP_UNSIGNED_LONG_To_TMP_DOUBLE (The_Coded_Input_Stream.Read_Raw_Little_Endian_64);
   end Read_Double;

   ----------------------
   -- Read_Enumeration --
   ----------------------

   function Read_Enumeration
     (The_Coded_Input_Stream : in Coded_Input_Stream.Instance)
      return TMP_INTEGER
   is
      function TMP_UNSIGNED_INTEGER_To_TMP_INTEGER is new Ada.Unchecked_Conversion (Source => TMP_UNSIGNED_INTEGER,
                                                                                    Target => TMP_INTEGER);
   begin
      return TMP_UNSIGNED_INTEGER_To_TMP_INTEGER (The_Coded_Input_Stream.Read_Raw_Varint_32);
   end Read_Enumeration;

   -------------------
   -- Read_Fixed_32 --
   -------------------

   function Read_Fixed_32
     (The_Coded_Input_Stream : in Coded_Input_Stream.Instance)
      return TMP_UNSIGNED_INTEGER
   is
   begin
      return The_Coded_Input_Stream.Read_Raw_Little_Endian_32;
   end Read_Fixed_32;

   -------------------
   -- Read_Fixed_64 --
   -------------------

   function Read_Fixed_64
     (The_Coded_Input_Stream : in Coded_Input_Stream.Instance)
      return TMP_UNSIGNED_LONG
   is
   begin
      return The_Coded_Input_Stream.Read_Raw_Little_Endian_64;
   end Read_Fixed_64;

   ----------------
   -- Read_Float --
   ----------------

   function Read_Float
     (The_Coded_Input_Stream : in Coded_Input_Stream.Instance)
      return TMP_FLOAT
   is
      function TMP_UNSIGNED_INTEGER_To_TMP_FLOAT is new Ada.Unchecked_Conversion (Source => TMP_UNSIGNED_INTEGER,
                                                                                  Target => TMP_FLOAT);
   begin
      return TMP_UNSIGNED_INTEGER_To_TMP_FLOAT (The_Coded_Input_Stream.Read_Raw_Little_Endian_32);
   end Read_Float;

   ---------------------
   -- Read_Integer_32 --
   ---------------------

   function Read_Integer_32
     (The_Coded_Input_Stream : in Coded_Input_Stream.Instance)
      return TMP_INTEGER
   is
      function TMP_UNSIGNED_INTEGER_To_TMP_INTEGER is new Ada.Unchecked_Conversion (Source => TMP_UNSIGNED_INTEGER,
                                                                                    Target => TMP_INTEGER);
   begin
      return TMP_UNSIGNED_INTEGER_To_TMP_INTEGER (The_Coded_Input_Stream.Read_Raw_Varint_32);
   end Read_Integer_32;

   ---------------------
   -- Read_Integer_64 --
   ---------------------

   function Read_Integer_64
     (The_Coded_Input_Stream : in Coded_Input_Stream.Instance)
      return TMP_LONG
   is
      function TMP_UNSIGNED_LONG_To_TMP_LONG is new Ada.Unchecked_Conversion (Source => TMP_UNSIGNED_LONG,
                                                                              Target => TMP_LONG);
   begin
      return TMP_UNSIGNED_LONG_To_TMP_LONG (The_Coded_Input_Stream.Read_Raw_Varint_64);
   end Read_Integer_64;

   -------------------
   -- Read_Raw_Byte --
   -------------------

   function Read_Raw_Byte
     (The_Coded_Input_Stream : in Coded_Input_Stream.Instance)
      return TMP_UNSIGNED_BYTE
   is
      Value : TMP_UNSIGNED_BYTE;
   begin
      TMP_UNSIGNED_BYTE'Read (The_Coded_Input_Stream.Input_Stream, Value);
      return Value;
   end Read_Raw_Byte;

   -------------------------------
   -- Read_Raw_Little_Endian_32 --
   -------------------------------

   function Read_Raw_Little_Endian_32
     (The_Coded_Input_Stream : in Coded_Input_Stream.Instance)
      return TMP_UNSIGNED_INTEGER
   is
      Value : TMP_UNSIGNED_INTEGER;
   begin
      TMP_UNSIGNED_INTEGER'Read (The_Coded_Input_Stream.Input_Stream, Value);
      return Value;
   end Read_Raw_Little_Endian_32;

   -------------------------------
   -- Read_Raw_Little_Endian_64 --
   -------------------------------

   function Read_Raw_Little_Endian_64
     (The_Coded_Input_Stream : in Coded_Input_Stream.Instance)
      return TMP_UNSIGNED_LONG
   is
      Value : TMP_UNSIGNED_LONG;
   begin
      TMP_UNSIGNED_LONG'Read (The_Coded_Input_Stream.Input_Stream, Value);
      return Value;
   end Read_Raw_Little_Endian_64;

   ------------------------
   -- Read_Raw_Varint_32 --
   ------------------------

   function Read_Raw_Varint_32
     (The_Coded_Input_Stream : in Coded_Input_Stream.Instance)
      return TMP_UNSIGNED_INTEGER
   is
      Result       : TMP_UNSIGNED_INTEGER := 0;
      Tmp          : TMP_UNSIGNED_BYTE := The_Coded_Input_Stream.Read_Raw_Byte;
      Byte_MSB_Set : constant := 16#80#;
      use type TMP_UNSIGNED_BYTE;
      use type TMP_UNSIGNED_INTEGER;
   begin
      -- MSB not set, which means that varint consist of only one byte. See Base 128 Varints:
      -- https://developers.google.com/protocol-buffers/docs/encoding
      if Tmp < Byte_MSB_Set then
         return TMP_UNSIGNED_INTEGER (Tmp);
      end if;

      Result := TMP_UNSIGNED_INTEGER (Tmp and 16#7F#); -- (TMP and 16#7F#) == set MSB to 0
      Tmp := The_Coded_Input_Stream.Read_Raw_Byte;
      if Tmp < Byte_MSB_Set then
         Result := Result or  Shift_Left (TMP_UNSIGNED_INTEGER (Tmp), 7);
      else
         Result := Result or Shift_Left (TMP_UNSIGNED_INTEGER (Tmp and 16#7F#), 7);
         Tmp := The_Coded_Input_Stream.Read_Raw_Byte;
         if Tmp < Byte_MSB_Set then
            Result := Result or Shift_Left (TMP_UNSIGNED_INTEGER (Tmp), 14);
         else
            Result := Result or Shift_Left (TMP_UNSIGNED_INTEGER (Tmp and 16#7F#), 14);
            Tmp := The_Coded_Input_Stream.Read_Raw_Byte;
            if Tmp < Byte_MSB_Set then
               Result := Result or Shift_Left (TMP_UNSIGNED_INTEGER (Tmp), 21);
            else
               Result := Result or Shift_Left (TMP_UNSIGNED_INTEGER (Tmp and 16#7F#), 21);
               Tmp := The_Coded_Input_Stream.Read_Raw_Byte;
               Result := Result or Shift_Left (TMP_UNSIGNED_INTEGER (Tmp), 28);

               -- Tests if last byte has MSB set in which case the varint is
               -- malformed, since it cannot be represented by a 32-bit type.
               if Tmp >= Byte_MSB_Set then
                  -- Discard upper 32-bits
                  for I in 1 .. 5 loop
                     Tmp := The_Coded_Input_Stream.Read_Raw_Byte;
                     if Tmp < Byte_MSB_Set then
                        return Result;
                     end if;
                  end loop;

                  pragma Compile_Time_Warning (Standard.True, "Add indication of malformed varint");

               end if;
            end if;
         end if;
      end if;

      return Result;
   end Read_Raw_Varint_32;

   ------------------------
   -- Read_Raw_Varint_64 --
   ------------------------

   function Read_Raw_Varint_64
     (The_Coded_Input_Stream : in Coded_Input_Stream.Instance)
      return TMP_UNSIGNED_LONG
   is
      Shift  : Natural := 0;
      Result : TMP_UNSIGNED_LONG := 0;
      Tmp    : TMP_UNSIGNED_BYTE;

      Byte_MSB_Set : constant := 16#80#;

      use type TMP_UNSIGNED_BYTE;
      use type TMP_UNSIGNED_LONG;
   begin

      while Shift < 64 loop
         Tmp := The_Coded_Input_Stream.Read_Raw_Byte;
         Result := Result or Shift_Left (TMP_UNSIGNED_LONG (Tmp and 16#7F#), Shift);
         if (Tmp and Byte_MSB_Set) = 0 then
            return Result;
         end if;

         Shift := Shift + 7;
      end loop;

      pragma Compile_Time_Warning (Standard.True, "Add indication of malformed varint");
      return Result; -- Temporary fix
   end Read_Raw_Varint_64;

   --------------------------
   -- Read_Signed_Fixed_32 --
   --------------------------

   function Read_Signed_Fixed_32
     (The_Coded_Input_Stream : in Coded_Input_Stream.Instance)
      return TMP_INTEGER
   is
      function TMP_UNSIGNED_INTEGER_To_TMP_INTEGER is new Ada.Unchecked_Conversion (Source => TMP_UNSIGNED_INTEGER,
                                                                                    Target => TMP_INTEGER);
   begin
      return TMP_UNSIGNED_INTEGER_To_TMP_INTEGER (The_Coded_Input_Stream.Read_Raw_Little_Endian_32);
   end Read_Signed_Fixed_32;

   --------------------------
   -- Read_Signed_Fixed_64 --
   --------------------------

   function Read_Signed_Fixed_64
     (The_Coded_Input_Stream : in Coded_Input_Stream.Instance)
      return TMP_LONG
   is
      function TMP_UNSIGNED_LONG_To_TMP_LONG is new Ada.Unchecked_Conversion (Source => TMP_UNSIGNED_LONG,
                                                                              Target => TMP_LONG);
   begin
      return TMP_UNSIGNED_LONG_To_TMP_LONG (The_Coded_Input_Stream.Read_Raw_Little_Endian_64);
   end Read_Signed_Fixed_64;

   ----------------------------
   -- Read_Signed_Integer_32 --
   ----------------------------

   function Read_Signed_Integer_32
     (The_Coded_Input_Stream : in Coded_Input_Stream.Instance)
      return TMP_INTEGER
   is
      function TMP_UNSIGNED_INTEGER_To_TMP_INTEGER is new Ada.Unchecked_Conversion (Source => TMP_UNSIGNED_INTEGER,
                                                                                    Target => TMP_INTEGER);
   begin
      return TMP_UNSIGNED_INTEGER_To_TMP_INTEGER (Decode_Zig_Zag_32 (The_Coded_Input_Stream.Read_Raw_Varint_32));
   end Read_Signed_Integer_32;

   ----------------------------
   -- Read_Signed_Integer_64 --
   ----------------------------

   function Read_Signed_Integer_64
     (The_Coded_Input_Stream : in Coded_Input_Stream.Instance)
      return TMP_LONG
   is
      function TMP_UNSIGNED_LONG_To_TMP_LONG is new Ada.Unchecked_Conversion (Source => TMP_UNSIGNED_LONG,
                                                                              Target => TMP_LONG);
   begin
      return TMP_UNSIGNED_LONG_To_TMP_LONG (Decode_Zig_Zag_64 (The_Coded_Input_Stream.Read_Raw_Varint_64));
   end Read_Signed_Integer_64;

   -----------------
   -- Read_String --
   -----------------

   function Read_String
     (The_Coded_Input_Stream : in Coded_Input_Stream.Instance)
      return Ada.Strings.Unbounded.Unbounded_String
   is
      function To_Standard_Character is new Ada.Unchecked_Conversion (Source => Interfaces.Unsigned_8,
                                                                         Target => Standard.Character);
--     begin
--        The_Coded_Output_Stream.Write_Raw_Varint_32 (Value'Length);
--        for I in 1 .. Value'Length loop
--           The_Coded_Output_Stream.Write_Raw_Byte(To_Interfaces_Unsigned_8(Value(I)));
--        end loop;
      String_Length : Integer := Integer(The_Coded_Input_Stream.Read_Raw_Varint_32);
      Target_String : String(1..String_Length);
   begin
      for I in 1 .. String_Length loop
         Target_String(I) := To_Standard_Character(The_Coded_Input_Stream.Read_Raw_Byte);
      end loop;

      return Ada.Strings.Unbounded.To_Unbounded_String(Target_String);
   end Read_String;

   --------------
   -- Read_Tag --
   --------------

   function Read_Tag
     (The_Coded_Input_Stream : in Coded_Input_Stream.Instance)
      return TMP_UNSIGNED_INTEGER
   is
   begin
      declare
      begin
         return The_Coded_Input_Stream.Read_Raw_Varint_32;
      exception
         when Ada.IO_Exceptions.End_Error =>
            return 0;
      end;
   end Read_Tag;

   ------------------------------
   -- Read_Unsigned_Integer_32 --
   ------------------------------

   function Read_Unsigned_Integer_32
     (The_Coded_Input_Stream : in Coded_Input_Stream.Instance)
      return TMP_UNSIGNED_INTEGER
   is
   begin
      return The_Coded_Input_Stream.Read_Raw_Varint_32;
   end Read_Unsigned_Integer_32;

   ------------------------------
   -- Read_Unsigned_Integer_64 --
   ------------------------------

   function Read_Unsigned_Integer_64
     (The_Coded_Input_Stream : in Coded_Input_Stream.Instance)
      return TMP_UNSIGNED_LONG
   is
   begin
      return The_Coded_Input_Stream.Read_Raw_Varint_64;
   end Read_Unsigned_Integer_64;

   ----------------
   -- Skip_Field --
   ----------------

   function Skip_Field
     (The_Coded_Input_Stream : in Coded_Input_Stream.Instance;
      Tag                    : in TMP_UNSIGNED_INTEGER)
      return Boolean
   is
      Dummy_1 : TMP_INTEGER;
      Dummy_2 : TMP_UNSIGNED_INTEGER;
      Dummy_3 : TMP_UNSIGNED_LONG;
   begin
      case Get_Tag_Wire_Type (Tag) is
         when VARINT =>
            Dummy_1 := The_Coded_Input_Stream.Read_Integer_32;
            return True;
         when FIXED_32 =>
            Dummy_2 := The_Coded_Input_Stream.Read_Raw_Little_Endian_32;
            return True;
         when FIXED_64 =>
            Dummy_3 := The_Coded_Input_Stream.Read_Raw_Little_Endian_64;
            return True;
         when LENGTH_DELIMITED =>
            The_Coded_Input_Stream.Skip_Raw_Bytes (The_Coded_Input_Stream.Read_Raw_Varint_32);
            return True;
         when START_GROUP =>
            pragma Compile_Time_Warning (Standard.True, "START_GROUP unimplemented");
            return True;
         when END_GROUP =>
            return False;
      end case;
   end Skip_Field;

   --------------------
   -- Skip_Raw_Bytes --
   --------------------

   procedure Skip_Raw_Bytes
     (The_Coded_Input_Stream : in Coded_Input_Stream.Instance;
      Bytes_To_Skip          : in TMP_UNSIGNED_INTEGER)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Skip_Raw_Bytes unimplemented");
      raise Program_Error with "Unimplemented procedure Skip_Raw_Bytes";
   end Skip_Raw_Bytes;

   ------------------
   -- Skip_Message --
   ------------------

   procedure Skip_Message
     (The_Coded_Input_Stream : in Coded_Input_Stream.Instance)
   is
      Tag : TMP_UNSIGNED_INTEGER;
      use type TMP_UNSIGNED_INTEGER;
   begin
      loop
         Tag := The_Coded_Input_Stream.Read_Tag;

         if Tag = 0 or else (not The_Coded_Input_Stream.Skip_Field (Tag)) then
            return;
         end if;
      end loop;
   end Skip_Message;

end Protocol_Buffers.IO.Coded_Input_Stream;

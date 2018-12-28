pragma Ada_2012;

with Ada.Unchecked_Conversion;

package body Protocol_Buffers.IO.Coded_Output_Stream is

   -----------------------
   -- Encode_Zig_Zag_32 --
   -----------------------

   function Encode_Zig_Zag_32
     (Value : in TMP_INTEGER)
      return TMP_UNSIGNED_INTEGER
   is
      function TMP_INTEGER_To_Interfaces_Unsigned_32 is new Ada.Unchecked_Conversion (Source => TMP_INTEGER,
                                                                                      Target => Interfaces.Unsigned_32);
      Value_To_Unsigned_32 : Interfaces.Unsigned_32 := TMP_INTEGER_To_Interfaces_Unsigned_32 (Value);
      use type Interfaces.Unsigned_32;
   begin
      return TMP_UNSIGNED_INTEGER (Interfaces.Shift_Left (Value_To_Unsigned_32, 1) xor Interfaces.Shift_Right_Arithmetic (Value_To_Unsigned_32, 31));
   end Encode_Zig_Zag_32;

   -----------------------
   -- Encode_Zig_Zag_64 --
   -----------------------

   function Encode_Zig_Zag_64
     (Value : in TMP_LONG)
      return TMP_UNSIGNED_LONG
   is
      function TMP_LONG_To_Interfaces_Unsigned_64 is new Ada.Unchecked_Conversion (Source => TMP_LONG,
                                                                                   Target => Interfaces.Unsigned_64);
      Value_To_Unsigned_64 : Interfaces.Unsigned_64 := TMP_LONG_To_Interfaces_Unsigned_64 (Value);
      use type Interfaces.Unsigned_64;
   begin
      return TMP_UNSIGNED_LONG (Interfaces.Shift_Left (Value_To_Unsigned_64, 1) xor Interfaces.Shift_Right_Arithmetic (Value_To_Unsigned_64, 63));
   end Encode_Zig_Zag_64;

   --------------------------------
   -- Compute_Raw_Varint_32_Size --
   --------------------------------

   function Compute_Raw_Varint_32_Size
     (Value : in TMP_UNSIGNED_INTEGER)
      return TMP_OBJECT_SIZE
   is
      Value_To_Unsigned_32 : Interfaces.Unsigned_32 := Interfaces.Unsigned_32 (Value);
      use type Interfaces.Unsigned_32;
   begin
      if Interfaces.Shift_Right (Value_To_Unsigned_32,  7) = 0 then return 1; end if;
      if Interfaces.Shift_Right (Value_To_Unsigned_32, 14) = 0 then return 2; end if;
      if Interfaces.Shift_Right (Value_To_Unsigned_32, 21) = 0 then return 3; end if;
      if Interfaces.Shift_Right (Value_To_Unsigned_32, 28) = 0 then return 4; end if;
      return 5;
   end Compute_Raw_Varint_32_Size;

   --------------------------------
   -- Compute_Raw_Varint_64_Size --
   --------------------------------

   function Compute_Raw_Varint_64_Size
     (Value : in TMP_UNSIGNED_LONG)
      return TMP_OBJECT_SIZE
   is
      Value_To_Unsigned_64 : Interfaces.Unsigned_64 := Interfaces.Unsigned_64 (Value);
      use type Interfaces.Unsigned_64;
   begin
      if Interfaces.Shift_Right (Value_To_Unsigned_64,  7) = 0 then return 1; end if;
      if Interfaces.Shift_Right (Value_To_Unsigned_64, 14) = 0 then return 2; end if;
      if Interfaces.Shift_Right (Value_To_Unsigned_64, 21) = 0 then return 3; end if;
      if Interfaces.Shift_Right (Value_To_Unsigned_64, 28) = 0 then return 4; end if;
      if Interfaces.Shift_Right (Value_To_Unsigned_64, 35) = 0 then return 5; end if;
      if Interfaces.Shift_Right (Value_To_Unsigned_64, 42) = 0 then return 6; end if;
      if Interfaces.Shift_Right (Value_To_Unsigned_64, 56) = 0 then return 8; end if;
      if Interfaces.Shift_Right (Value_To_Unsigned_64, 63) = 0 then return 9; end if;
      return 10;
   end Compute_Raw_Varint_64_Size;

   --------------------------
   -- Compute_Boolean_Size --
   --------------------------

   function Compute_Boolean_Size
     (Field_Number : in TMP_FIELD_TYPE;
      Value        : in TMP_BOOLEAN)
      return TMP_OBJECT_SIZE
   is
   begin
      return Compute_Tag_Size (Field_Number) + Compute_Boolean_Size_No_Tag (Value);
   end Compute_Boolean_Size;

   -------------------------
   -- Compute_Double_Size --
   -------------------------

   function Compute_Double_Size
     (Field_Number : in TMP_FIELD_TYPE;
      Value        : in TMP_DOUBLE)
      return TMP_OBJECT_SIZE
   is
   begin
      return Compute_Tag_Size (Field_Number) + Compute_Double_Size_No_Tag (Value);
   end Compute_Double_Size;

   ------------------------------
   -- Compute_Enumeration_Size --
   ------------------------------

   function Compute_Enumeration_Size
     (Field_Number : in TMP_FIELD_TYPE;
      Value        : in TMP_INTEGER)
      return TMP_OBJECT_SIZE
   is
   begin
      return Compute_Tag_Size (Field_Number) + Compute_Enumeration_Size_No_Tag (Value);
   end Compute_Enumeration_Size;

   ---------------------------
   -- Compute_Fixed_32_Size --
   ---------------------------

   function Compute_Fixed_32_Size
     (Field_Number : in TMP_FIELD_TYPE;
      Value        : in TMP_UNSIGNED_INTEGER)
      return TMP_OBJECT_SIZE
   is
   begin
      return Compute_Tag_Size (Field_Number) + Compute_Fixed_32_Size_No_Tag (Value);
   end Compute_Fixed_32_Size;

   ---------------------------
   -- Compute_Fixed_64_Size --
   ---------------------------

   function Compute_Fixed_64_Size
     (Field_Number : in TMP_FIELD_TYPE;
      Value        : in TMP_UNSIGNED_LONG)
      return TMP_OBJECT_SIZE
   is
   begin
      return Compute_Tag_Size (Field_Number) + Compute_Fixed_64_Size_No_Tag (Value);
   end Compute_Fixed_64_Size;

   ------------------------
   -- Compute_Float_Size --
   ------------------------

   function Compute_Float_Size
     (Field_Number : in TMP_FIELD_TYPE;
      Value        : in TMP_FLOAT)
      return TMP_OBJECT_SIZE
   is
   begin
      return Compute_Tag_Size (Field_Number) + Compute_Float_Size_No_Tag (Value);
   end Compute_Float_Size;

   -----------------------------
   -- Compute_Integer_32_Size --
   -----------------------------

   function Compute_Integer_32_Size
     (Field_Number : in TMP_FIELD_TYPE;
      Value        : in TMP_INTEGER)
      return TMP_OBJECT_SIZE
   is
   begin
      return Compute_Tag_Size (Field_Number) + Compute_Integer_32_Size_No_Tag (Value);
   end Compute_Integer_32_Size;

   -----------------------------
   -- Compute_Integer_64_Size --
   -----------------------------

   function Compute_Integer_64_Size
     (Field_Number : in TMP_FIELD_TYPE;
      Value        : in TMP_LONG)
      return TMP_OBJECT_SIZE
   is
   begin
      return Compute_Tag_Size (Field_Number) + Compute_Integer_64_Size_No_Tag (Value);
   end Compute_Integer_64_Size;

   ----------------------------------
   -- Compute_Signed_Fixed_32_Size --
   ----------------------------------

   function Compute_Signed_Fixed_32_Size
     (Field_Number : in TMP_FIELD_TYPE;
      Value        : in TMP_INTEGER)
      return TMP_OBJECT_SIZE
   is
   begin
      return Compute_Tag_Size (Field_Number) + Compute_Signed_Fixed_32_Size_No_Tag (Value);
   end Compute_Signed_Fixed_32_Size;

   ----------------------------------
   -- Compute_Signed_Fixed_64_Size --
   ----------------------------------

   function Compute_Signed_Fixed_64_Size
     (Field_Number : in TMP_FIELD_TYPE;
      Value        : in TMP_LONG)
      return TMP_OBJECT_SIZE
   is
   begin
      return Compute_Tag_Size (Field_Number) + Compute_Signed_Fixed_64_Size_No_Tag (Value);
   end Compute_Signed_Fixed_64_Size;

   ------------------------------------
   -- Compute_Signed_Integer_32_Size --
   ------------------------------------

   function Compute_Signed_Integer_32_Size
     (Field_Number : in TMP_FIELD_TYPE;
      Value        : in TMP_INTEGER)
      return TMP_OBJECT_SIZE
   is
   begin
      return Compute_Tag_Size (Field_Number) + Compute_Signed_Integer_32_Size_No_Tag (Value);
   end Compute_Signed_Integer_32_Size;

   ------------------------------------
   -- Compute_Signed_Integer_64_Size --
   ------------------------------------

   function Compute_Signed_Integer_64_Size
     (Field_Number : in TMP_FIELD_TYPE;
      Value        : in TMP_LONG)
      return TMP_OBJECT_SIZE
   is
   begin
      return Compute_Tag_Size (Field_Number) + Compute_Signed_Integer_64_Size_No_Tag (Value);
   end Compute_Signed_Integer_64_Size;

   -------------------------
   -- Compute_String_Size --
   -------------------------

   function Compute_String_Size
     (Field_Number : in TMP_FIELD_TYPE;
      Value        : in TMP_STRING)
      return TMP_OBJECT_SIZE
   is
   begin
      return Compute_Tag_Size (Field_Number) + Compute_String_Size_No_Tag (Value);
   end Compute_String_Size;

   ----------------------
   -- Compute_Tag_Size --
   ----------------------

   function Compute_Tag_Size
     (Field_Number : TMP_FIELD_TYPE)
      return TMP_OBJECT_SIZE
   is
      function TMP_FIELD_TYPE_To_TMP_UNSIGNED_INTEGER is new Ada.Unchecked_Conversion (Source => TMP_FIELD_TYPE,
                                                                                       Target => TMP_UNSIGNED_INTEGER);
      Tag : TMP_UNSIGNED_INTEGER := Wire_Format.Make_Tag (Field_Number, TMP_WIRE_TYPE'Val (0));
   begin
      return Compute_Raw_Varint_32_Size (Tag);
   end Compute_Tag_Size;

   --------------------------------------
   -- Compute_Unsigned_Integer_32_Size --
   --------------------------------------

   function Compute_Unsigned_Integer_32_Size
     (Field_Number : in TMP_FIELD_TYPE;
      Value        : in TMP_UNSIGNED_INTEGER)
      return TMP_OBJECT_SIZE
   is
   begin
      return Compute_Tag_Size (Field_Number) + Compute_Unsigned_Integer_32_Size_No_Tag (Value);
   end Compute_Unsigned_Integer_32_Size;

   --------------------------------------
   -- Compute_Unsigned_Integer_64_Size --
   --------------------------------------

   function Compute_Unsigned_Integer_64_Size
     (Field_Number : in TMP_FIELD_TYPE;
      Value        : in TMP_UNSIGNED_LONG)
      return TMP_OBJECT_SIZE
   is
   begin
      return Compute_Tag_Size (Field_Number) + Compute_Unsigned_Integer_64_Size_No_Tag (Value);
   end Compute_Unsigned_Integer_64_Size;

   ---------------------------------
   -- Compute_Boolean_Size_No_Tag --
   ---------------------------------

   function Compute_Boolean_Size_No_Tag
     (Value : in TMP_BOOLEAN)
      return TMP_OBJECT_SIZE
   is
   begin
      return 1;
   end Compute_Boolean_Size_No_Tag;

   --------------------------------
   -- Compute_Double_Size_No_Tag --
   --------------------------------

   function Compute_Double_Size_No_Tag
     (Value : in TMP_DOUBLE)
      return TMP_OBJECT_SIZE
   is
   begin
      return TMP_LITTLE_ENDIAN_64_SIZE;
   end Compute_Double_Size_No_Tag;

   -------------------------------------
   -- Compute_Enumeration_Size_No_Tag --
   -------------------------------------

   function Compute_Enumeration_Size_No_Tag
     (Value : in TMP_INTEGER)
      return TMP_OBJECT_SIZE
   is
   begin
      return Compute_Integer_32_Size_No_Tag (Value);
   end Compute_Enumeration_Size_No_Tag;

   ----------------------------------
   -- Compute_Fixed_32_Size_No_Tag --
   ----------------------------------

   function Compute_Fixed_32_Size_No_Tag
     (Value : in TMP_UNSIGNED_INTEGER)
      return TMP_OBJECT_SIZE
   is
   begin
      return TMP_LITTLE_ENDIAN_32_SIZE;
   end Compute_Fixed_32_Size_No_Tag;

   ----------------------------------
   -- Compute_Fixed_64_Size_No_Tag --
   ----------------------------------

   function Compute_Fixed_64_Size_No_Tag
     (Value : in TMP_UNSIGNED_LONG)
      return TMP_OBJECT_SIZE
   is
   begin
      return TMP_LITTLE_ENDIAN_64_SIZE;
   end Compute_Fixed_64_Size_No_Tag;

   -------------------------------
   -- Compute_Float_Size_No_Tag --
   -------------------------------

   function Compute_Float_Size_No_Tag
     (Value : in TMP_FLOAT)
      return TMP_OBJECT_SIZE
   is
   begin
      return TMP_LITTLE_ENDIAN_32_SIZE;
   end Compute_Float_Size_No_Tag;

   ------------------------------------
   -- Compute_Integer_32_Size_No_Tag --
   ------------------------------------

   function Compute_Integer_32_Size_No_Tag
     (Value : in TMP_INTEGER)
      return TMP_OBJECT_SIZE
   is
      function TMP_INTEGER_To_TMP_UNSIGNED_INTEGER is new Ada.Unchecked_Conversion (Source => TMP_INTEGER,
                                                                                    Target => TMP_UNSIGNED_INTEGER);
   begin
      if Value >= 0 then
         return Compute_Raw_Varint_32_Size (TMP_INTEGER_To_TMP_UNSIGNED_INTEGER (Value));
      else
         -- Value must be sign-extended. See More Value Types
         -- https://developers.google.com/protocol-buffers/docs/encoding
         return 10;
      end if;
   end Compute_Integer_32_Size_No_Tag;

   ------------------------------------
   -- Compute_Integer_64_Size_No_Tag --
   ------------------------------------

   function Compute_Integer_64_Size_No_Tag
     (Value : in TMP_LONG)
      return TMP_OBJECT_SIZE
   is
      function TMP_LONG_To_TMP_UNSIGNED_LONG is new Ada.Unchecked_Conversion (Source => TMP_LONG,
                                                                              Target => TMP_UNSIGNED_LONG);
   begin
      return Compute_Raw_Varint_64_Size (TMP_LONG_To_TMP_UNSIGNED_LONG (Value));
   end Compute_Integer_64_Size_No_Tag;

   -----------------------------------------
   -- Compute_Signed_Fixed_32_Size_No_Tag --
   -----------------------------------------

   function Compute_Signed_Fixed_32_Size_No_Tag
     (Value : in TMP_INTEGER)
      return TMP_OBJECT_SIZE
   is
   begin
      return TMP_LITTLE_ENDIAN_32_SIZE;
   end Compute_Signed_Fixed_32_Size_No_Tag;

   -----------------------------------------
   -- Compute_Signed_Fixed_64_Size_No_Tag --
   -----------------------------------------

   function Compute_Signed_Fixed_64_Size_No_Tag
     (Value : in TMP_LONG)
      return TMP_OBJECT_SIZE
   is
   begin
      return TMP_LITTLE_ENDIAN_64_SIZE;
   end Compute_Signed_Fixed_64_Size_No_Tag;

   -------------------------------------------
   -- Compute_Signed_Integer_32_Size_No_Tag --
   -------------------------------------------

   function Compute_Signed_Integer_32_Size_No_Tag
     (Value : in TMP_INTEGER)
      return TMP_OBJECT_SIZE
   is
   begin
      return Compute_Raw_Varint_32_Size (Encode_Zig_Zag_32 (Value));
   end Compute_Signed_Integer_32_Size_No_Tag;

   -------------------------------------------
   -- Compute_Signed_Integer_64_Size_No_Tag --
   -------------------------------------------

   function Compute_Signed_Integer_64_Size_No_Tag
     (Value : in TMP_LONG)
      return TMP_OBJECT_SIZE
   is
   begin
      return Compute_Raw_Varint_64_Size (Encode_Zig_Zag_64 (Value));
   end Compute_Signed_Integer_64_Size_No_Tag;

   --------------------------------
   -- Compute_String_Size_No_Tag --
   --------------------------------

   function Compute_String_Size_No_Tag
     (Value : in TMP_STRING)
      return TMP_OBJECT_SIZE
   is
   begin
      return Compute_Raw_Varint_32_Size(Value'Length) + TMP_OBJECT_SIZE(Value'Length);
   end Compute_String_Size_No_Tag;

   ---------------------------------------------
   -- Compute_Unsigned_Integer_32_Size_No_Tag --
   ---------------------------------------------

   function Compute_Unsigned_Integer_32_Size_No_Tag
     (Value : in TMP_UNSIGNED_INTEGER)
      return TMP_OBJECT_SIZE
   is
   begin
      return Compute_Raw_Varint_32_Size (Value);
   end Compute_Unsigned_Integer_32_Size_No_Tag;

   ---------------------------------------------
   -- Compute_Unsigned_Integer_64_Size_No_Tag --
   ---------------------------------------------

   function Compute_Unsigned_Integer_64_Size_No_Tag
     (Value : in TMP_UNSIGNED_LONG)
      return TMP_OBJECT_SIZE
   is
   begin
      return Compute_Raw_Varint_64_Size (Value);
   end Compute_Unsigned_Integer_64_Size_No_Tag;

   -----------
   -- Flush --
   -----------

   procedure Flush
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance)
   is
   begin
      --        --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Flush unimplemented");
      --        raise Program_Error with "Unimplemented procedure Flush";
      null;
   end Flush;

   -------------------
   -- Write_Boolean --
   -------------------

   procedure Write_Boolean
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Field_Number            : in TMP_FIELD_TYPE;
      Value                   : in TMP_BOOLEAN)
   is
   begin
      The_Coded_Output_Stream.Write_Tag (Field_Number, Wire_Format.VARINT);
      The_Coded_Output_Stream.Write_Boolean_No_Tag (Value);
   end Write_Boolean;

   ------------------
   -- Write_Double --
   ------------------

   procedure Write_Double
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Field_Number            : in TMP_FIELD_TYPE;
      Value                   : in TMP_DOUBLE)
   is
   begin
      The_Coded_Output_Stream.Write_Tag (Field_Number, Wire_Format.FIXED_64);
      The_Coded_Output_Stream.Write_Double_No_Tag (Value);
   end Write_Double;

   -----------------------
   -- Write_Enumeration --
   -----------------------

   procedure Write_Enumeration
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Field_Number            : in TMP_FIELD_TYPE;
      Value                   : in TMP_INTEGER)
   is
   begin
      The_Coded_Output_Stream.Write_Tag (Field_Number, Wire_Format.VARINT);
      The_Coded_Output_Stream.Write_Enumeration_No_Tag (Value);
   end Write_Enumeration;

   --------------------
   -- Write_Fixed_32 --
   --------------------

   procedure Write_Fixed_32
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Field_Number            : in TMP_FIELD_TYPE;
      Value                   : in TMP_UNSIGNED_INTEGER)
   is
   begin
      The_Coded_Output_Stream.Write_Tag (Field_Number, Wire_Format.FIXED_32);
      The_Coded_Output_Stream.Write_Fixed_32_No_Tag (Value);
   end Write_Fixed_32;

   --------------------
   -- Write_Fixed_64 --
   --------------------

   procedure Write_Fixed_64
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Field_Number            : in TMP_FIELD_TYPE;
      Value                   : in TMP_UNSIGNED_LONG)
   is
   begin
      The_Coded_Output_Stream.Write_Tag (Field_Number, Wire_Format.FIXED_64);
      The_Coded_Output_Stream.Write_Fixed_64_No_Tag (Value);
   end Write_Fixed_64;

   -----------------
   -- Write_Float --
   -----------------

   procedure Write_Float
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Field_Number            : in TMP_FIELD_TYPE;
      Value                   : in TMP_FLOAT)
   is
   begin
      The_Coded_Output_Stream.Write_Tag (Field_Number, Wire_Format.FIXED_32);
      The_Coded_Output_Stream.Write_Float_No_Tag (Value);
   end Write_Float;

   ----------------------
   -- Write_Integer_32 --
   ----------------------

   procedure Write_Integer_32
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Field_Number            : in TMP_FIELD_TYPE;
      Value                   : in TMP_INTEGER)
   is
   begin
      The_Coded_Output_Stream.Write_Tag (Field_Number, Wire_Format.VARINT);
      The_Coded_Output_Stream.Write_Integer_32_No_Tag (Value);
   end Write_Integer_32;

   ----------------------
   -- Write_Integer_64 --
   ----------------------

   procedure Write_Integer_64
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Field_Number            : in TMP_FIELD_TYPE;
      Value                   : in TMP_LONG)
   is
   begin
      The_Coded_Output_Stream.Write_Tag (Field_Number, Wire_Format.VARINT);
      The_Coded_Output_Stream.Write_Integer_64_No_Tag (Value);
   end Write_Integer_64;

   ---------------------------
   -- Write_Signed_Fixed_32 --
   ---------------------------

   procedure Write_Signed_Fixed_32
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Field_Number            : in TMP_FIELD_TYPE;
      Value                   : in TMP_INTEGER)
   is
   begin
      The_Coded_Output_Stream.Write_Tag (Field_Number, Wire_Format.FIXED_32);
      The_Coded_Output_Stream.Write_Signed_Fixed_32_No_Tag (Value);
   end Write_Signed_Fixed_32;

   ---------------------------
   -- Write_Signed_Fixed_64 --
   ---------------------------

   procedure Write_Signed_Fixed_64
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Field_Number            : in TMP_FIELD_TYPE;
      Value                   : in TMP_LONG)
   is
   begin
      The_Coded_Output_Stream.Write_Tag (Field_Number, Wire_Format.FIXED_64);
      The_Coded_Output_Stream.Write_Signed_Fixed_64_No_Tag (Value);
   end Write_Signed_Fixed_64;

   -----------------------------
   -- Write_Signed_Integer_32 --
   -----------------------------

   procedure Write_Signed_Integer_32
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Field_Number            : in TMP_FIELD_TYPE;
      Value                   : in TMP_INTEGER)
   is
   begin
      The_Coded_Output_Stream.Write_Tag (Field_Number, Wire_Format.VARINT);
      The_Coded_Output_Stream.Write_Signed_Integer_32_No_Tag (Value);
   end Write_Signed_Integer_32;

   -----------------------------
   -- Write_Signed_Integer_64 --
   -----------------------------

   procedure Write_Signed_Integer_64
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Field_Number            : in TMP_FIELD_TYPE;
      Value                   : in TMP_LONG)
   is
   begin
      The_Coded_Output_Stream.Write_Tag (Field_Number, Wire_Format.VARINT);
      The_Coded_Output_Stream.Write_Signed_Integer_64_No_Tag (Value);
   end Write_Signed_Integer_64;

   ------------------
   -- Write_String --
   ------------------

   procedure Write_String
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Field_Number            : in TMP_FIELD_TYPE;
      Value                   : in Ada.Strings.Unbounded.Unbounded_String)
   is
   begin
      The_Coded_Output_Stream.Write_Tag (Field_Number, Wire_Format.LENGTH_DELIMITED);
      The_Coded_Output_Stream.Write_String_No_Tag (Value);
   end Write_String;

   -------------------------------
   -- Write_Unsigned_Integer_32 --
   -------------------------------

   procedure Write_Unsigned_Integer_32
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Field_Number            : in TMP_FIELD_TYPE;
      Value                   : in TMP_UNSIGNED_INTEGER)
   is
   begin
      The_Coded_Output_Stream.Write_Tag (Field_Number, Wire_Format.VARINT);
      The_Coded_Output_Stream.Write_Unsigned_Integer_32_No_Tag (Value);
   end Write_Unsigned_Integer_32;

   -------------------------------
   -- Write_Unsigned_Integer_64 --
   -------------------------------

   procedure Write_Unsigned_Integer_64
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Field_Number            : in TMP_FIELD_TYPE;
      Value                   : in TMP_UNSIGNED_LONG)
   is
   begin
      The_Coded_Output_Stream.Write_Tag (Field_Number, Wire_Format.VARINT);
      The_Coded_Output_Stream.Write_Unsigned_Integer_64_No_Tag (Value);
   end Write_Unsigned_Integer_64;

   --------------------------
   -- Write_Boolean_No_Tag --
   --------------------------

   procedure Write_Boolean_No_Tag
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Value                   : in TMP_BOOLEAN)
   is
   begin
      if Value then
         The_Coded_Output_Stream.Write_Raw_Byte (1);
      else
         The_Coded_Output_Stream.Write_Raw_Byte (0);
      end if;
   end Write_Boolean_No_Tag;

   -------------------------
   -- Write_Double_No_Tag --
   -------------------------

   procedure Write_Double_No_Tag
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Value                   : in TMP_DOUBLE)
   is
      function TMP_DOUBLE_To_TMP_UNSIGNED_LONG is new Ada.Unchecked_Conversion (Source => TMP_DOUBLE,
                                                                                Target => TMP_UNSIGNED_LONG);
   begin
      The_Coded_Output_Stream.Write_Raw_Little_Endian_64 (TMP_DOUBLE_To_TMP_UNSIGNED_LONG (Value));
   end Write_Double_No_Tag;

   ------------------------------
   -- Write_Enumeration_No_Tag --
   ------------------------------

   procedure Write_Enumeration_No_Tag
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Value                   : in TMP_INTEGER)
   is
   begin
      The_Coded_Output_Stream.Write_Integer_32_No_Tag (Value);
   end Write_Enumeration_No_Tag;

   ---------------------------
   -- Write_Fixed_32_No_Tag --
   ---------------------------

   procedure Write_Fixed_32_No_Tag
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Value                   : in TMP_UNSIGNED_INTEGER)
   is
   begin
      The_Coded_Output_Stream.Write_Raw_Little_Endian_32 (Value);
   end Write_Fixed_32_No_Tag;

   ---------------------------
   -- Write_Fixed_64_No_Tag --
   ---------------------------

   procedure Write_Fixed_64_No_Tag
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Value                   : in TMP_UNSIGNED_LONG)
   is
   begin
      The_Coded_Output_Stream.Write_Raw_Little_Endian_64 (Value);
   end Write_Fixed_64_No_Tag;

   ------------------------
   -- Write_Float_No_Tag --
   ------------------------

   procedure Write_Float_No_Tag
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Value                   : in TMP_FLOAT)
   is
      function TMP_FLOAT_To_TMP_UNSIGNED_INTEGER is new Ada.Unchecked_Conversion (Source => TMP_FLOAT,
                                                                                  Target => TMP_UNSIGNED_INTEGER);
   begin
      The_Coded_Output_Stream.Write_Raw_Little_Endian_32 (TMP_FLOAT_To_TMP_UNSIGNED_INTEGER (Value));
   end Write_Float_No_Tag;

   -----------------------------
   -- Write_Integer_32_No_Tag --
   -----------------------------

   procedure Write_Integer_32_No_Tag
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Value                   : in TMP_INTEGER)
   is
      function TMP_INTEGER_To_TMP_UNSIGNED_INTEGER is new Ada.Unchecked_Conversion (Source => TMP_INTEGER,
                                                                                    Target => TMP_UNSIGNED_INTEGER);

      function TMP_LONG_To_TMP_UNSIGNED_LONG is new Ada.Unchecked_Conversion (Source => TMP_LONG,
                                                                              Target => TMP_UNSIGNED_LONG);

      Value_As_Unsigned_Integer : TMP_UNSIGNED_INTEGER := TMP_INTEGER_To_TMP_UNSIGNED_INTEGER (Value);
      Value_As_Long             : TMP_LONG := TMP_LONG (Value);
      Value_As_Unsigned_Long    : TMP_UNSIGNED_LONG := TMP_LONG_To_TMP_UNSIGNED_LONG (Value_As_Long);

   begin
      if Value >= 0 then
         The_Coded_Output_Stream.Write_Raw_Varint_32 (Value_As_Unsigned_Integer);
      else
         The_Coded_Output_Stream.Write_Raw_Varint_64 (Value_As_Unsigned_Long);
      end if;
   end Write_Integer_32_No_Tag;

   -----------------------------
   -- Write_Integer_64_No_Tag --
   -----------------------------

   procedure Write_Integer_64_No_Tag
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Value                   : in TMP_LONG)
   is
      function TMP_LONG_To_TMP_UNSIGNED_LONG is new Ada.Unchecked_Conversion (Source => TMP_LONG,
                                                                              Target => TMP_UNSIGNED_LONG);
   begin
      The_Coded_Output_Stream.Write_Raw_Varint_64 (TMP_LONG_To_TMP_UNSIGNED_LONG (Value));
   end Write_Integer_64_No_Tag;

   ----------------------------------
   -- Write_Signed_Fixed_32_No_Tag --
   ----------------------------------

   procedure Write_Signed_Fixed_32_No_Tag
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Value                   : in TMP_INTEGER)
   is
      function TMP_INTEGER_To_TMP_UNSIGNED_INTEGER is new Ada.Unchecked_Conversion (Source => TMP_INTEGER,
                                                                                    Target => TMP_UNSIGNED_INTEGER);
   begin
      The_Coded_Output_Stream.Write_Raw_Little_Endian_32 (TMP_INTEGER_To_TMP_UNSIGNED_INTEGER (Value));
   end Write_Signed_Fixed_32_No_Tag;

   ----------------------------------
   -- Write_Signed_Fixed_64_No_Tag --
   ----------------------------------

   procedure Write_Signed_Fixed_64_No_Tag
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Value                   : in TMP_LONG)
   is
      function TMP_LONG_To_TMP_UNSIGNED_LONG is new Ada.Unchecked_Conversion (Source => TMP_LONG,
                                                                              Target => TMP_UNSIGNED_LONG);
   begin
      The_Coded_Output_Stream.Write_Raw_Little_Endian_64 (TMP_LONG_To_TMP_UNSIGNED_LONG (Value));
   end Write_Signed_Fixed_64_No_Tag;

   ------------------------------------
   -- Write_Signed_Integer_32_No_Tag --
   ------------------------------------

   procedure Write_Signed_Integer_32_No_Tag
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Value                   : in TMP_INTEGER)
   is
   begin
      The_Coded_Output_Stream.Write_Raw_Varint_32 (Encode_Zig_Zag_32 (Value));
   end Write_Signed_Integer_32_No_Tag;

   ------------------------------------
   -- Write_Signed_Integer_64_No_Tag --
   ------------------------------------

   procedure Write_Signed_Integer_64_No_Tag
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Value                   : in TMP_LONG)
   is
   begin
      The_Coded_Output_Stream.Write_Raw_Varint_64 (Encode_Zig_Zag_64 (Value));
   end Write_Signed_Integer_64_No_Tag;

   -------------------------
   -- Write_String_No_Tag --
   -------------------------

   procedure Write_String_No_Tag
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Value                   : in Ada.Strings.Unbounded.Unbounded_String)
   is
      function To_Interfaces_Unsigned_8 is new Ada.Unchecked_Conversion (Source => Standard.Character,
                                                                         Target => Interfaces.Unsigned_8);
      String_Length : Natural := Ada.Strings.Unbounded.Length (Value);
      Source_String : String(1..String_Length) := Ada.Strings.Unbounded.To_String(Value);
   begin
      The_Coded_Output_Stream.Write_Raw_Varint_32 (Interfaces.Unsigned_32 (String_Length));
      for I in 1 .. String_Length loop
         The_Coded_Output_Stream.Write_Raw_Byte(To_Interfaces_Unsigned_8(Source_String(I)));
      end loop;
   end Write_String_No_Tag;

   --------------------------------------
   -- Write_Unsigned_Integer_32_No_Tag --
   --------------------------------------

   procedure Write_Unsigned_Integer_32_No_Tag
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Value                   : in TMP_UNSIGNED_INTEGER)
   is
   begin
      The_Coded_Output_Stream.Write_Raw_Varint_32 (Value);
   end Write_Unsigned_Integer_32_No_Tag;

   --------------------------------------
   -- Write_Unsigned_Integer_64_No_Tag --
   --------------------------------------

   procedure Write_Unsigned_Integer_64_No_Tag
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Value                   : in TMP_UNSIGNED_LONG)
   is
   begin
      The_Coded_Output_Stream.Write_Raw_Varint_64 (Value);
   end Write_Unsigned_Integer_64_No_Tag;

   ---------------
   -- Write_Tag --
   ---------------

   procedure Write_Tag
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Field_Number            : in TMP_FIELD_TYPE;
      Wire_Type               : in TMP_WIRE_TYPE)
   is
      function TMP_FIELD_TYPE_To_TMP_UNSIGNED_INTEGER is new Ada.Unchecked_Conversion (Source => TMP_FIELD_TYPE,
                                                                                       Target => TMP_UNSIGNED_INTEGER);
      Tag : TMP_UNSIGNED_INTEGER := Wire_Format.Make_Tag (Field_Number => Field_Number,
                                                    Wire_Type    => Wire_Type);
   begin
      The_Coded_Output_Stream.Write_Raw_Varint_32 (Tag);
   end Write_Tag;

   --------------------------------
   -- Write_Raw_Little_Endian_32 --
   --------------------------------

   procedure Write_Raw_Little_Endian_32
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Value                   : in TMP_UNSIGNED_INTEGER)
   is
   begin
      TMP_UNSIGNED_INTEGER'Write (The_Coded_Output_Stream.Output_Stream, Value);
   end Write_Raw_Little_Endian_32;

   --------------------------------
   -- Write_Raw_Little_Endian_64 --
   --------------------------------

   procedure Write_Raw_Little_Endian_64
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Value                   : in TMP_UNSIGNED_LONG)
   is
   begin
      TMP_UNSIGNED_LONG'Write (The_Coded_Output_Stream.Output_Stream, Value);
   end Write_Raw_Little_Endian_64;

   -------------------------
   -- Write_Raw_Varint_32 --
   -------------------------

   procedure Write_Raw_Varint_32
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Value                   : in TMP_UNSIGNED_INTEGER)
   is
      Value_To_Unsigned_32 : Interfaces.Unsigned_32 := Interfaces.Unsigned_32 (Value);
      function Unsigned_32_To_TMP_UNSIGNED_BYTE is new Ada.Unchecked_Conversion (Source => Interfaces.Unsigned_32,
                                                                                 Target => TMP_UNSIGNED_BYTE);
      use type Interfaces.Unsigned_32;
   begin
      loop
         if (Value_To_Unsigned_32 and (not 16#7F#)) = 0 then
            The_Coded_Output_Stream.Write_Raw_Byte (Unsigned_32_To_TMP_UNSIGNED_BYTE (Value_To_Unsigned_32));
            return;
         else
            The_Coded_Output_Stream.Write_Raw_Byte (Unsigned_32_To_TMP_UNSIGNED_BYTE ((Value_To_Unsigned_32 and 16#7f#) or 16#80#));
            Value_To_Unsigned_32 := Interfaces.Shift_Right (Value  => Value_To_Unsigned_32,
                                                            Amount => 7);
         end if;
      end loop;
   end Write_Raw_Varint_32;

   -------------------------
   -- Write_Raw_Varint_64 --
   -------------------------

   procedure Write_Raw_Varint_64
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Value                   : in TMP_UNSIGNED_LONG)
   is
      Value_To_Unsigned_64 : Interfaces.Unsigned_64 := Interfaces.Unsigned_64 (Value);
      function Unsigned_64_To_TMP_UNSIGNED_BYTE is new Ada.Unchecked_Conversion (Source => Interfaces.Unsigned_64,
                                                                                 Target => TMP_UNSIGNED_BYTE);
      use type Interfaces.Unsigned_64;
   begin
      loop
         if (Value_To_Unsigned_64 and (not 16#7F#)) = 0 then
            The_Coded_Output_Stream.Write_Raw_Byte (Unsigned_64_To_TMP_UNSIGNED_BYTE (Value_To_Unsigned_64));
            return;
         else
            The_Coded_Output_Stream.Write_Raw_Byte (Unsigned_64_To_TMP_UNSIGNED_BYTE ((Value_To_Unsigned_64 and 16#7f#) or 16#80#));
            Value_To_Unsigned_64 := Interfaces.Shift_Right (Value  => Value_To_Unsigned_64,
                                                            Amount => 7);
         end if;
      end loop;
   end Write_Raw_Varint_64;

   --------------------
   -- Write_Raw_Byte --
   --------------------

   procedure Write_Raw_Byte
     (The_Coded_Output_Stream : in Coded_Output_Stream.Instance;
      Value                   : in TMP_UNSIGNED_BYTE)
   is
   begin
      TMP_UNSIGNED_BYTE'Write (The_Coded_Output_Stream.Output_Stream, Value);
   end Write_Raw_Byte;

end Protocol_Buffers.IO.Coded_Output_Stream;

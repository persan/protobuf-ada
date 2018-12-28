pragma Ada_2012;

with Interfaces;

package Protocol_Buffers.Wire_Format is
   -- These are temporary types that should be replaced
   -- with something more portable. ???
   type TMP_STRING is new String;
   type TMP_STRING_ACCESS is access all TMP_STRING;
   subtype TMP_UNSIGNED_BYTE is Interfaces.Unsigned_8;
   subtype TMP_UNSIGNED_INTEGER is Interfaces.Unsigned_32;
   subtype TMP_UNSIGNED_LONG is Interfaces.Unsigned_64;
   type TMP_DOUBLE is new Interfaces.IEEE_Float_64;
   type TMP_FLOAT is new Interfaces.IEEE_Float_32;
   type TMP_BOOLEAN is new Boolean;
   type TMP_INTEGER is new Long_Integer;
   type TMP_LONG is new Long_Long_Integer;
   type TMP_FIELD_TYPE is new Interfaces.Unsigned_32;

   type TMP_WIRE_TYPE is (VARINT, FIXED_64, LENGTH_DELIMITED, START_GROUP, END_GROUP, FIXED_32);

   type TMP_OBJECT_SIZE is new Natural;

   -- Change return type ???
   function Make_Tag (Field_Number : in TMP_FIELD_TYPE; Wire_Type : in TMP_WIRE_TYPE) return TMP_UNSIGNED_INTEGER;

   function Get_Tag_Wire_Type (Tag : in TMP_UNSIGNED_INTEGER) return TMP_WIRE_TYPE;

   function Get_Tag_Field_Number (Tag : in TMP_UNSIGNED_INTEGER) return TMP_FIELD_TYPE;

   function Shift_Left (Value : in Interfaces.Unsigned_8; Amount : in Natural) return Interfaces.Unsigned_8 renames Interfaces.Shift_Left;
   function Shift_Left (Value : in Interfaces.Unsigned_32; Amount : in Natural) return Interfaces.Unsigned_32 renames Interfaces.Shift_Left;
   function Shift_Left (Value : in Interfaces.Unsigned_64; Amount : in Natural) return Interfaces.Unsigned_64 renames Interfaces.Shift_Left;
   function Shift_Right (Value : in Interfaces.Unsigned_8; Amount : in Natural) return Interfaces.Unsigned_8 renames Interfaces.Shift_Right;
   function Shift_Right (Value : in Interfaces.Unsigned_32; Amount : in Natural) return Interfaces.Unsigned_32 renames Interfaces.Shift_Right;
   function Shift_Right (Value : in Interfaces.Unsigned_64; Amount : in Natural) return Interfaces.Unsigned_64 renames Interfaces.Shift_Right;

   TAG_TYPE_BITS : constant := 3;
   TAG_TYPE_MASK : TMP_UNSIGNED_INTEGER := Interfaces."-"(Shift_Left (1, TAG_TYPE_BITS) , 1);

end Protocol_Buffers.Wire_Format;

pragma Ada_2012;

package body Protocol_Buffers.Wire_Format is

   --------------
   -- Make_Tag --
   --------------

   function Make_Tag
     (Field_Number : in TMP_FIELD_TYPE;
      Wire_Type    : in TMP_WIRE_TYPE)
      return TMP_UNSIGNED_INTEGER
   is
      use type TMP_UNSIGNED_INTEGER;
   begin
      return TMP_UNSIGNED_INTEGER (Shift_Left (Field_Number, TAG_TYPE_BITS)) or
        TMP_UNSIGNED_INTEGER (TMP_WIRE_TYPE'Pos (Wire_Type));
      pragma Compile_Time_Warning (Standard.True, "Make_Tag temporary implementation!");
   end Make_Tag;

   -----------------------
   -- Get_Tag_Wire_Type --
   -----------------------

   function Get_Tag_Wire_Type
     (Tag : in TMP_UNSIGNED_INTEGER)
      return TMP_WIRE_TYPE
   is
      use type TMP_UNSIGNED_INTEGER;
   begin
      return TMP_WIRE_TYPE'Val (Tag and TAG_TYPE_MASK);
      pragma Compile_Time_Warning (Standard.True, "Get_Tag_Wire_Type temporary implementation!");
   end Get_Tag_Wire_Type;

   --------------------------
   -- Get_Tag_Field_Number --
   --------------------------

   function Get_Tag_Field_Number
     (Tag : in TMP_UNSIGNED_INTEGER)
      return TMP_FIELD_TYPE
   is
      use type TMP_UNSIGNED_INTEGER;
   begin
      return TMP_FIELD_TYPE (Shift_Right (Tag, TAG_TYPE_BITS));
      pragma Compile_Time_Warning (Standard.True, "Get_Tag_Field_Number temporary implementation!");
   end Get_Tag_Field_Number;

end Protocol_Buffers.Wire_Format;

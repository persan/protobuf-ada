-- Package used by generated code to generate special default values
-- (Inf, -Inf and NaN) for TMP_FLOAT and TMP_DOUBLE. This might not be portable,
-- consider replacing with something that is???

pragma Ada_2012;

with Protocol_Buffers.Wire_Format;

package Protocol_Buffers.Generated_Message_Utilities is

   -- Protocol_Buffers.Wire_Format.TMP_FLOAT
   function Positive_Infinity return Protocol_Buffers.Wire_Format.TMP_FLOAT;
   function Negative_Infinity return Protocol_Buffers.Wire_Format.TMP_FlOAT;
   function NaN return Protocol_Buffers.Wire_Format.TMP_FLOAT;

   -- Protocol_Buffers.Wire_Format.TMP_DOUBLE
   function Positive_Infinity return Protocol_Buffers.Wire_Format.TMP_DOUBLE;
   function Negative_Infinity return Protocol_Buffers.Wire_Format.TMP_DOUBLE;
   function NaN return Protocol_Buffers.Wire_Format.TMP_DOUBLE;

   EMPTY_STRING : aliased Protocol_Buffers.Wire_Format.TMP_STRING := "";

end Protocol_Buffers.Generated_Message_Utilities;

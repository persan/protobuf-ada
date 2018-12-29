-- Package used by generated code to generate special default values
-- (Inf, -Inf and NaN) for PB_Float and PB_Double. This might not be portable,
-- consider replacing with something that is???

pragma Ada_2012;

with Protocol_Buffers.Wire_Format;

package Protocol_Buffers.Generated_Message_Utilities is

  -- Protocol_Buffers.Wire_Format.PB_Float
  function Positive_Infinity return Protocol_Buffers.Wire_Format.PB_Float;
  function Negative_Infinity return Protocol_Buffers.Wire_Format.PB_Float;
  function NaN return Protocol_Buffers.Wire_Format.PB_Float;

  -- Protocol_Buffers.Wire_Format.PB_Double
  function Positive_Infinity return Protocol_Buffers.Wire_Format.PB_Double;
  function Negative_Infinity return Protocol_Buffers.Wire_Format.PB_Double;
  function NaN return Protocol_Buffers.Wire_Format.PB_Double;

  EMPTY_STRING : aliased Protocol_Buffers.Wire_Format.PB_String := "";

end Protocol_Buffers.Generated_Message_Utilities;

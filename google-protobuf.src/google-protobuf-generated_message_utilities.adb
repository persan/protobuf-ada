pragma Ada_2012;

package body Google.Protobuf.Generated_Message_Utilities is

   ------------------------
   -- Positive_Infinity --
   ------------------------

   function Positive_Infinity
     return Google.Protobuf.Wire_Format.PB_Float
   is
      Inf : Google.Protobuf.Wire_Format.PB_Float :=
              Google.Protobuf.Wire_Format.PB_Float'Last;
   begin
--        if not Google.Protobuf.Wire_Format.PB_Float'Machine_Overflows then
--           Inf := Google.Protobuf.Wire_Format.PB_Float'Succ (Inf);
--        end if;
      return Inf;
   end Positive_Infinity;

   -----------------------
   -- Negative_Infinity --
   -----------------------

   function Negative_Infinity
     return Google.Protobuf.Wire_Format.PB_Float
   is
      Neg_Inf : Google.Protobuf.Wire_Format.PB_Float :=
                  Google.Protobuf.Wire_Format.PB_Float'First;
   begin
--        if not Google.Protobuf.Wire_Format.PB_Float'Machine_Overflows then
--           Neg_Inf := Google.Protobuf.Wire_Format.PB_Float'Pred (Neg_Inf);
--        end if;
      return Neg_Inf;
   end Negative_Infinity;

   ---------
   -- NaN --
   ---------

   function NaN
     return Google.Protobuf.Wire_Format.PB_Float
   is
      use type Google.Protobuf.Wire_Format.PB_Float;

      --Do not change the below to "const"!
      Zero  : Google.Protobuf.Wire_Format.PB_Float := 0.0;
      A_NaN : Google.Protobuf.Wire_Format.PB_Float := 0.0;
   begin
      if not Google.Protobuf.Wire_Format.PB_Float'Machine_Overflows then
         A_NaN := 0.0 / Zero;
      end if;
      return A_NaN;
   end NaN;

   ------------------------
   -- Positive_Infinity --
   ------------------------

   function Positive_Infinity
     return Google.Protobuf.Wire_Format.PB_Double
   is
      Inf : Google.Protobuf.Wire_Format.PB_Double :=
              Google.Protobuf.Wire_Format.PB_Double'Last;
   begin
      --        if not Google.Protobuf.Wire_Format.PB_Double'Machine_Overflows then
      --           Inf := Google.Protobuf.Wire_Format.PB_Double'Succ (Inf);
      --        end if;
      return Inf;
   end Positive_Infinity;

   -----------------------
   -- Negative_Infinity --
   -----------------------

   function Negative_Infinity
     return Google.Protobuf.Wire_Format.PB_Double
   is
      Neg_Inf : Google.Protobuf.Wire_Format.PB_Double :=
                  Google.Protobuf.Wire_Format.PB_Double'First;
   begin
      --        if not Google.Protobuf.Wire_Format.PB_Double'Machine_Overflows then
      --           Neg_Inf := Google.Protobuf.Wire_Format.PB_Double'Pred (Neg_Inf);
      --        end if;
      return Neg_Inf;
   end Negative_Infinity;

   ---------
   -- NaN --
   ---------

   function NaN
     return Google.Protobuf.Wire_Format.PB_Double
   is
      use type Google.Protobuf.Wire_Format.PB_Double;

      --Do not change the below to "const"!
      Zero  : Google.Protobuf.Wire_Format.PB_Double := 0.0;
      A_NaN : Google.Protobuf.Wire_Format.PB_Double := 0.0;
   begin
      if not Google.Protobuf.Wire_Format.PB_Double'Machine_Overflows then
         A_NaN := 0.0 / Zero;
      end if;
      return A_NaN;
   end NaN;

end Google.Protobuf.Generated_Message_Utilities;

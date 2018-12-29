pragma Ada_2012;

package body Protocol_Buffers.Generated_Message_Utilities is

   ------------------------
   -- Positive_Infinity --
   ------------------------

   function Positive_Infinity
     return Protocol_Buffers.Wire_Format.TMP_FLOAT
   is
      Inf : Protocol_Buffers.Wire_Format.TMP_FLOAT :=
              Protocol_Buffers.Wire_Format.TMP_FLOAT'Last;
   begin
      if not Protocol_Buffers.Wire_Format.TMP_FLOAT'Machine_Overflows then
         Inf := Protocol_Buffers.Wire_Format.TMP_FLOAT'Succ (Inf);
      end if;
      return Inf;
   end Positive_Infinity;

   -----------------------
   -- Negative_Infinity --
   -----------------------

   function Negative_Infinity
     return Protocol_Buffers.Wire_Format.TMP_FlOAT
   is
      Neg_Inf : Protocol_Buffers.Wire_Format.TMP_FLOAT :=
                  Protocol_Buffers.Wire_Format.TMP_FLOAT'First;
   begin
      if not Protocol_Buffers.Wire_Format.TMP_FLOAT'Machine_Overflows then
         Neg_Inf := Protocol_Buffers.Wire_Format.TMP_FLOAT'Pred (Neg_Inf);
      end if;
      return Neg_Inf;
   end Negative_Infinity;

   ---------
   -- NaN --
   ---------

   function NaN
     return Protocol_Buffers.Wire_Format.TMP_FLOAT
   is
      use type Protocol_Buffers.Wire_Format.TMP_FLOAT;

      Zero : Protocol_Buffers.Wire_Format.TMP_FLOAT := 0.0;
      A_NaN : Protocol_Buffers.Wire_Format.TMP_FLOAT := 0.0;
   begin
      if not Protocol_Buffers.Wire_Format.TMP_FLOAT'Machine_Overflows then
         A_NaN := 0.0 / Zero;
      end if;
      return A_NaN;
   end NaN;

   ------------------------
   -- Positive_Infinity --
   ------------------------

   function Positive_Infinity
     return Protocol_Buffers.Wire_Format.TMP_DOUBLE
   is
      Inf : Protocol_Buffers.Wire_Format.TMP_DOUBLE :=
              Protocol_Buffers.Wire_Format.TMP_DOUBLE'Last;
   begin
      if not Protocol_Buffers.Wire_Format.TMP_DOUBLE'Machine_Overflows then
         Inf := Protocol_Buffers.Wire_Format.TMP_DOUBLE'Succ (Inf);
      end if;
      return Inf;
   end Positive_Infinity;

   -----------------------
   -- Negative_Infinity --
   -----------------------

   function Negative_Infinity
     return Protocol_Buffers.Wire_Format.TMP_DOUBLE
   is
      Neg_Inf : Protocol_Buffers.Wire_Format.TMP_DOUBLE :=
                  Protocol_Buffers.Wire_Format.TMP_DOUBLE'First;
   begin
      if not Protocol_Buffers.Wire_Format.TMP_DOUBLE'Machine_Overflows then
         Neg_Inf := Protocol_Buffers.Wire_Format.TMP_DOUBLE'Pred (Neg_Inf);
      end if;
      return Neg_Inf;
   end Negative_Infinity;

   ---------
   -- NaN --
   ---------

   function NaN
     return Protocol_Buffers.Wire_Format.TMP_DOUBLE
   is
      use type Protocol_Buffers.Wire_Format.TMP_DOUBLE;
      Zero : Protocol_Buffers.Wire_Format.TMP_DOUBLE := 0.0;
      A_NaN : Protocol_Buffers.Wire_Format.TMP_DOUBLE := 0.0;
   begin
      if not Protocol_Buffers.Wire_Format.TMP_DOUBLE'Machine_Overflows then
         A_NaN := 0.0 / Zero;
      end if;
      return A_NaN;
   end NaN;

end Protocol_Buffers.Generated_Message_Utilities;

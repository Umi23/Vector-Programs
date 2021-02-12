unit ymmfloat;

{$mode objfpc}{$H+}
{$CODEPAGE UTF8}
{$ASMMODE INTEL}
{$FPUTYPE AVX}
{$GOTO ON}
{$OPTIMIZATION OFF}  // assembler is optimized!

{ This unit is for the SIMD calculation with the VEX unit of the Intel or
  AMD processor an ONLY FOR 64 BIT working systems.

  Please check that yo have a processor with VEX support( Intel >= Sandy-Bridge
  and AMD >= Bulldozer). Test this with the function fnTestIntelAVX. When
  your program include this unit and the processor have not a VEX unit,
  the program stop with a error.
  Only single and double floating point routines are implemented. All the
  input values of the routines (array's) shold are align at 32 byte but
  is not must. The routines working with align and unalign arrays.
  Many functiones give as result a boolean value, when the input value
  is incorrect,(length of the arrays not equal) is the result = false.
  All the routines have as a marker a letter Y in the name.

  - routines with ..VX working of array cols
  - routines with ..2VX,4VX working with 2,4 array pairs in cols direction
  - routines with ..Value... add, mul od div a const value to the array fields.
  - routines start with S... are special routines for reciprocal. Give no
                 exception, when  input value is zero.
  - all routines work with T8Single or T4Double arrays. See simd.inc

  For convert the data array in calculation order or reverse use the convert
  routines.
  Please read the documented routines in unit Test_ymm.
  In this unit are all the routines explaned with a short coding.

  Copyright (C) 2020 Klaus Stöhr  mail: k.stoehr@gmx.de

  This source is free software; you can redistribute it and/or modify it under
  the terms of the GNU Lesser General Public License as published by the Free
  Software Foundation; either version 3 of the License, or (at your option)
  any later version.
  As a special exception, the copyright holder of this library give you
  permission to link this library with independent modules to produce an
  executable, regardless of the license terms of these independent modules,and
  to copy and distribute the resulting executable under terms of your choice,
  provided that you also meet, for each linked independent module, the terms
  and conditions of the license of that module. An independent module is a
  module which is not derived from or based on this library.

  This code is distributed in the hope that it will be useful, but WITHOUT ANY
  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more
  details.

  You should have received a copy of the GNU Lesser General Public License
  along with this program. If not, see <http://www.gnu.org/licenses/>.
}

{The following hints are not removable.}

{Remark:
    All the routines in this unit are thread secure (reentrant).
    All the routines work with open array T8Single or T4Double.
    The convert routines with flag set a fill value when the length of the
    array is not a multiply of 8 for single and 4 for double. Set flag = true
    for fill with 1.0 and flag = false for fill with zeros.
    The input single or double value are pointer (constref) this is for
    the divrent ABI for input float value.

    All the routines have NOT ERROR HANDLING. It is the work for the developer
    for control the input and output results for errors. When working with
    the unit, it is a good idea set the control word (MXCSR) to denormals as zero.
    (Denormals for single |x| < 1.18E-38; double |x| < 2.23E-308)
    This set input and output denormal value to zero. You can do this with
    the routine "SetYNotDenormals" and reset with "SetYUseDenormals".

Remark for SRec.. et al.:
    The routines set internal the mxcsr bit 9 (div by zero masked) and
    the division by zero give +-oo. The values with +-oo is than set to zero.

Remark for trigonometric, log and exponential functions:
   This functions use the FPU. The functions NOT TEST for valid range of the
   input values, this is work for the developer. For accuracy see the intel
   developer books.
}

interface

{$include simd.inc}

 function fnTestIntelAVX:Boolean;

{$IFDEF CPUX86_64}

{For set control word and evaluation of the bits please use the constants
 in simd.inc}
 function  GetYControlWord :Longword;
 procedure SetYControlWord (cw:Longword);
 procedure SetYNotDenormals;
 procedure SetYUseDenormals;


 // Set a Value in all fields of the array
 procedure SetValueYSingle      (out Feld :array of T8Single;constref Value :Single);
 procedure SetValuePlaceYSingle (var Feld :array of T8Single;constref Value :Single; place :Byte);
 procedure SetValueYDouble      (out Feld :array of T4Double;constref Value :Double);
 procedure SetValuePlaceYDouble (var Feld :array of T4Double;constref Value :Double; place :Byte);

 {--------------------------------addition-----------------------------------}

 function  SumVYSingle          (const Feld :array of T8Single):T8Single;
 function  AddVYSingle          (const Feld :array of T8Single;
                                 out   Res  :array of Single):Longbool;
 function  Add4VYSingle         (const Feld :array of T8Single;
                                 out   Res  :array of T4Single):Longbool;
 function  AddYSingle           (const Feld1,Feld2 :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;
 function  Add2TabYSingle       (const Tab1,Tab2 :array of T8Single;out ResTab :array of T8Single):Longbool;
 procedure SumMinMaxVYSingle    (const Feld :array of T8Single;out Sum,Min,Max :T8Single);
 procedure SumMinMaxYSingle     (const Feld :array of T8Single;out Sum,Min,Max :Single);
 {for subtract use negativ value}
 procedure AddValueYSingle      (var   Feld :array of T8Single;constref Value :Single);overload;
 function  AddValueYSingle      (const Feld :array of T8Single;
                                 out   Res  :array of T8Single;constref Value :Single):Longbool;overload;
 function  SumVYDouble          (const Feld :array of T4Double):T4Double;
 function  AddYDouble           (const Feld1,Feld2 :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;
 function  Add2VYDouble         (const Feld :array of T4Double;
                                 out   Res  :array of T2Double):Longbool;
 function  AddVYDouble          (const Feld :array of T4Double;
                                 out   Res  :array of Double):Longbool;
 function  Add2TabYDouble       (const Tab1,Tab2 :array of T4Double;
                                 out   ResTab :array of T4Double):Longbool;
 procedure AddValueYDouble      (var   Feld :array of T4Double;
                                 constref Value :Double);overload;
 function  AddValueYDouble      (const Feld :array of T4Double;
                                 out   Res  :array of T4Double;
                                 constref Value :Double):Longbool;overload;
 procedure SumMinMaxVYDouble    (const Feld :array of T4Double;out Sum,Min,Max :T4Double);
 procedure SumMinMaxYDouble     (const Feld :array of T4Double;out Sum,Min,Max :Double);

{----------------------subtract----------------------------------------------}

 {Res = Feld1 - Feld2}
 function  SubYSingle           (const Feld1,Feld2 :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;
 {Res = (Feld1-Feld2)/Value}
 function  SubDivValueYSingle    (const Feld1,Feld2 :array of T8Single;
                                 out Res :array of T8Single;constref Value :Single):Longbool;
 {res = Feld1*(Feld2-Feld3)}
 function  MulDiffYSingle       (const Feld1,Feld2,Feld3 :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;
 {res = sum(Feld1*(Feld2-Feld3)}
 function  SumMulDiffYSingle    (const Feld1,Feld2,Feld3 :array of T8Single;
                                 out   Res  :Single):Longbool;
 {Result  = Max(1,n)(Abs(Feld1*(Feld2-Feld3)))}
 function  MaxAbsMulDiffYSingle (const Feld1,Feld2,Feld3 :array of T8Single):Single;
 function  Sub4VYSingle         (const Feld :array of T8Single;
                                 out   Res  :array of T4Single):Longbool;
 function  Sub2TabYSingle       (const Tab1,Tab2 :array of T8Single;
                                 out   ResTab :array of T8Single):Longbool;
 function  SubYDouble           (const Feld1,Feld2 :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;
 {res = (Feld1-Feld2)/Value}
 function  SubDivValueYDouble   (const Feld1,Feld2 :array of T4Double;
                                 out Res :array of T4Double;
                                 constref Value :Double):Longbool;assembler;
 function  MulDiffYDouble       (const Feld1,Feld2,Feld3 :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;
 function  SumMulDiffYDouble    (const Feld1,Feld2,Feld3 :array of T4Double;
                                 out   Res  :Double):Longbool;
 function  Sub2VYDouble         (const Feld :array of T4Double;
                                 out   Res  :array of T2Double):Longbool;
 function  Sub2TabYDouble       (const Tab1,Tab2 :array of T4Double;
                                 out   ResTab :array of T4Double):Longbool;
 {Result  = Max(1,n)(Abs(Feld1*(Feld2-Feld3)))}
 function  MaxAbsMulDiffYDouble (const Feld1,Feld2,Feld3 :array of T4Double):Double;

{---------------------------add and subtract--------------------------------}

 function  AddSubYSingle        (const Feld1,Feld2 :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;
 procedure AddSubValueYSingle   (var   Feld :array of T8Single;constref Value :Single);
 function  AddSubYDouble        (const Feld1,Feld2 :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;
 procedure AddSubValueYDouble   (var   Feld :array of T4Double;constref Value :Double);


{---------------------------multiply----------------------------------------}

 function  ProductVYSingle      (const Feld :array of T8Single):T8Single;
 function  ProductYSingle       (const Feld :array of T8Single):Single;
 function  MulYSingle           (const Feld1,Feld2 :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;
 function  Mul4VYSingle         (const Feld :array of T8Single;
                                 out   Res  :array of T4Single):Longbool;
 function  MulVYSingle          (const Feld :array of T8Single;
                                 out   Res  :array of Single):Longbool;
 {for division use the reciprocal value}
 procedure MulValueYSingle      (var   Feld :array of T8Single;constref Value :Single);overload;
 function  MulValueYSingle      (const Feld :array of T8Single;out Res :array of T8Single;
                                 constref Value :Single):Longbool;overload;
 {res = (Feld1*Feld2) + Feld3}
 function  FMulAddYSingle       (const Feld1,Feld2,Feld3 :array of T8Single;
                                 out   Res :array of T8Single):Longbool;overload;
 {(Feld1*Feld2)+Feld3; result in Feld1!}
 function  FMulAddYSingle       (var   Feld1 :array of T8Single;
                                 const Feld2,Feld3 :array of T8Single):Longbool;overload;
 {res = (Feld1*Feld2) - Feld3}
 function  FMulSubYSingle       (const Feld1,Feld2,Feld3 :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;overload;
 function  FMulSubYSingle       (var   Feld1:array of T8Single;
                                 const Feld2,Feld3 :array of T8Single):Longbool;overload;
 {product of array cols}
 function  ProductVYDouble      (const Feld :array of T4Double):T4Double;
 function  ProductYDouble       (const Feld :array of T4Double):Double;
 function  MulVYDouble          (const Feld :array of T4Double;
                                 out   Res  :array of Double):Longbool;
 function  Mul2VYDouble         (const Feld :array of T4Double;
                                 out   Res  :array of T2Double):Longbool;
 function  MulYDouble           (const Feld1,Feld2 :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;
 {for division use the reciprocal value}
 procedure MulValueYDouble      (var   Feld :array of T4Double;constref Value :Double);overload;
 function  MulValueYDouble      (const Feld :array of T4Double;out Res :array of T4Double;
                                 constref Value :Double):Longbool;overload;
 function  FMulAddYDouble       (const Feld1,Feld2,Feld3 :array of T4Double;
                                 out   Res   :array of T4Double):Longbool;overload;
 function  FMulAddYDouble       (var   Feld1 :array of T4Double;
                                 const Feld2,Feld3 :array of T4Double):Longbool;overload;
 function  FMulSubYDouble       (const Feld1,Feld2,Feld3 :array of T4Double;
                                 out   Res   :array of T4Double):Longbool;overload;
 function  FMulSubYDouble       (var   Feld1 :array of T4Double;
                                 const Feld2,Feld3 :array of T4Double):Longbool;overload;

{---------------------------division------------------------------------------}
 {Res = Feld1/Feld2}
 function  DivYSingle           (const Feld1,Feld2 :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;
 function  Div4VYSingle         (const Feld :array of T8Single;
                                 out   Res  :array of T4Single):Longbool;
 function  DivYDouble           (const Feld1,Feld2 :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;
 function  Div2VYDouble         (const Feld :array of T4Double;
                                 out   Res  :array of T2Double):Longbool;

{----------------------------functions---------------------------------------}

 procedure SQRYSingle           (var   Feld :array of T8Single);overload;
 function  SQRYSingle           (const Feld :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;overload;
 {SQR(Feld1*(Feld2-Feld3)}
 function  SQRMulDiffYSingle    (const Feld1,Feld2,Feld3 :array of T8Single;
                                 out   Res :array of T8Single):Longbool;
 {Sum(SQR(Feld1*(Feld2-Feld3)))}
 function  SumSQRMulDiffYSingle (const Feld1,Feld2,Feld3 :array of T8Single):Single;
 function  SumSQRYSingle        (const Feld :array of T8Single):Single;
 function  SumSQRVYSingle       (const Feld :array of T8Single):T8Single;
 procedure SQRYDouble           (var   Feld :array of T4Double);overload;
 function  SQRYDouble           (const Feld :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;overload;
 function  SQRMulDiffYDouble    (const Feld1,Feld2,Feld3 :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;
 function  SumSQRMulDiffYDouble (const Feld1,Feld2,Feld3 :array of T4Double):Double;
 function  SumSQRYDouble        (const Feld :array of T4Double):Double;
 function  SumSQRVYDouble       (const Feld :array of T4Double):T4Double;

 procedure CubicYSingle         (var   Feld :array of T8Single);overload;
 function  CubicYSingle         (const Feld :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;overload;
 procedure CubicYDouble         (var   Feld :array of T4Double);overload;
 function  CubicYDouble         (const Feld :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;overload;

{--------------------------rec single------------------------------------------}
 procedure RecYSingle           (var   Feld :array of T8Single);overload;
 function  RecYSingle           (const Feld :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;overload;
 // fast reciprocal but less accuracy
 procedure FastRecYSingle       (var   Feld :array of T8Single);overload;
 function  FastRecYSingle       (const Feld :array of T8Single;
                                   out Res  :array of T8Single):Longbool;overload;
 procedure SRecYSingle          (var   Feld :array of T8Single);overload;
 function  SRecYSingle          (const Feld :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;overload;
 function  SumRecYSingle        (const Feld :array of T8Single):Single;
 function  SumSRecYSingle       (const Feld :array of T8Single):Single;
 function  SumRecVYSingle       (const Feld :array of T8Single):T8Single;
 function  SumSRecVYSingle      (const Feld :array of T8Single):T8Single;

 {--------------------------sqrt single---------------------------------------}
 procedure SQRTYSingle          (var   Feld :array of T8Single);overload;
 function  SQRTYSingle          (const Feld :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;overload;
 function  SumSQRTYSingle       (const Feld :array of T8Single):Single;
 function  SumSQRTVYSingle      (const Feld :array of T8Single):T8Single;
 procedure FastRecSQRTYSingle   (var   Feld :array of T8Single);overload;
 function  FastRecSQRTYSingle   (const Feld :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;overload;
 procedure RecSQRTYSingle       (var   Feld :array of T8Single);overload;
 function  RecSQRTYSingle       (const Feld :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;overload;
 procedure SRecSQRTYSingle      (var   Feld :array of T8Single);overload;
 function  SRecSQRTYSingle      (const Feld :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;overload;
 function  SumRecSQRTYSingle    (const Feld :array of T8Single):Single;
 function  SumSRecSQRTYSingle   (const Feld :array of T8Single):Single;
 function  SumRecSQRTVYSingle   (const Feld :array of T8Single):T8Single;
 function  SumSRecSQRTVYSingle  (const Feld :array of T8Single):T8Single;

{--------------------------rec double--------------------------------------}

 procedure RecYDouble           (var   Feld :array of T4Double);overload;
 function  RecYDouble           (const Feld :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;overload;
 procedure SRecYDouble          (var   Feld :array of T4Double);overload;
 function  SRecYDouble          (const Feld :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;overload;
 function  SumRecYDouble        (const Feld :array of T4Double):Double;
 function  SumSRecYDouble       (const Feld :array of T4Double):Double;
 function  SumRecVYDouble       (const Feld :array of T4Double):T4Double;
 function  SumSRecVYDouble      (const Feld :array of T4Double):T4Double;

 {-----------------------sqrt double----------------------------------------}
 procedure SQRTYDouble          (var   Feld :array of T4Double);overload;
 function  SQRTYDouble          (const Feld :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;overload;
 function  SumSQRTYDouble       (const Feld :array of T4Double):Double;
 function  SumSQRTVYDouble      (const Feld :array of T4Double):T4Double;
 procedure RecSQRTYDouble       (var   Feld :array of T4Double);overload;
 function  RecSQRTYDouble       (const Feld :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;overload;
 procedure SRecSQRTYDouble      (var   Feld :array of T4Double);overload;
 function  SRecSQRTYDouble      (const Feld :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;overload;
 function  SumRecSQRTYDouble    (const Feld :array of T4Double):Double;
 function  SumSRecSQRTYDouble   (const Feld :array of T4Double):Double;
 function  SumRecSQRTVYDouble   (const Feld :array of T4Double):T4Double;
 function  SumSRecSQRTVYDouble  (const Feld :array of T4Double):T4Double;

{-----------------------------sign----------------------------------------}

 procedure AbsYSingle           (var   Feld :array of T8Single);
 procedure AbsYDouble           (var   Feld :array of T4Double);
 procedure SetSignYSingle       (var   Feld :array of T8Single);
 procedure SetSignYDouble       (var   Feld :array of T4Double);
 procedure SignFlipFlopYSingle  (var   Feld :array of T8Single);
 procedure SignFlipFlopYDouble  (var   Feld :array of T4Double);

 {------------------log and exp functions-----------------------------------}

 {calculate base**exponent}
 function  IntPowYSingle        (const Feld :array of T8Single;
                                 out   Res  :array of T8Single;exponent :Longint):Longbool;
 function  IntPowYDouble        (const Feld :array of T4Double;
                                 out   Res  :array of T4Double;exponent :Longint):Longbool;
 {calculate e^x}
 function  ExpYSingle           (const Feld :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;
 function  ExpYDouble           (const Feld :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;
 {logarithmus naturalis; base e }
 function  LnYSingle            (const Feld :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;
 {logarithm dualis ; base 2}
 function  LdYSingle            (const Feld :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;
 function  LnYDouble            (const Feld :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;
 function  LdYDouble            (const Feld :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;
 {logarithmus basis 10}
 function  LogYSingle           (const Feld :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;
 function  LogYDouble           (const Feld :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;
 {calculate a^(x)}
 function  PowYSingle           (const Feld :array of T8Single;
                                 out   Res  :array of T8Single;
                                 constref exponent :Single):Longbool;
 function  PowYDouble           (const Feld :array of T4Double;
                                 out   Res  :array of T4Double;
                                 constref exponent :Double):Longbool;
 {calculate 10^(x)}
 function  Exp10YSingle         (const Feld :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;
 function  Exp10YDouble         (const Feld :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;

 {calculate 2^(x)}
 function  Exp2YSingle          (const Feld :array of T8Int32;
                                 out   Res  :array of T8Single):Longbool;
 function  Exp2YDouble          (const Feld :array of T4Int32;
                                 out   Res  :array of T4Double):Longbool;

{-----------------trigonometric functions----------------------------------}

 {Change the angel from degree or gon in radian y reverse.}
 procedure RadInDegYSingle      (var Feld :array of T8Single);
 procedure RadInGonYSingle      (var Feld :array of T8Single);
 procedure DegInRadYSingle      (var Feld :array of T8Single);
 procedure GonInRadYSingle      (var Feld :array of T8Single);
 procedure RadInDegYDouble      (var Feld :array of T4Double);
 procedure RadInGonYDouble      (var Feld :array of T4Double);
 procedure DegInRadYDouble      (var Feld :array of T4Double);
 procedure GonInRadYDouble      (var Feld :array of T4Double);

 {Follow functions use the FPU. All the input and output value are in radians!}
 function  SinYSingle           (const Feld :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;
 function  SinYDouble           (const Feld :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;
 function  SinCosYSingle        (const Feld :array of T8Single;
                                 out   Sin,Cos :array of T8Single):Longbool;
 function  SinCosYDouble        (const Feld :array of T4Double;
                                 out   Sin,Cos :array of T4Double):Longbool;
 function  CosYSingle           (const Feld :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;
 function  CosYDouble           (const Feld :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;
 function  TanYSingle           (const Feld :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;
 function  TanYDouble           (const Feld :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;
 function  CotanYSingle         (const Feld :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;
 function  CotanYDouble         (const Feld :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;

 function  ArctanYSingle        (const Feld :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;
 function  ArctanYDouble        (const Feld :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;
 function  ArccotYSingle        (const Feld :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;
 function  ArccotYDouble        (const Feld :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;
 function  ArcsinYSingle        (const Feld :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;
 function  ArcsinYDouble        (const Feld :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;
 function  ArccosYSingle        (const Feld :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;
 function  ArccosYDouble        (const Feld :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;

 function  SinhYSingle          (const Feld :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;
 function  SinhYDouble          (const Feld :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;
 function  SechYSingle          (const Feld :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;
 function  SechYDouble          (const Feld :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;
 function  CschYSingle          (const Feld :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;
 function  CschYDouble          (const Feld :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;
 function  CoshYSingle          (const Feld :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;
 function  CoshYDouble          (const Feld :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;
 function  TanhYSingle          (const Feld :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;
 function  TanhYDouble          (const Feld :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;
 function  CothYSingle          (const Feld :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;
 function  CothYDouble          (const Feld :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;

 function  ArSinhYSingle        (const Feld :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;
 function  ArSinhYDouble        (const Feld :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;
 function  ArCoshYSingle        (const Feld :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;
 function  ArCoshYDouble        (const Feld :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;
 function  ArTanhYSingle        (const Feld :array of T8Single;
                                 out   Res  :array of T8Single):Longbool;
 function  ArTanhYDouble        (const Feld :array of T4Double;
                                 out   Res  :array of T4Double):Longbool;

 {extract the exponent as decimal integer value}
 function ExponentYSingle       (const Feld: T8Single):T8Int32;
 function ExponentYDouble       (const Feld: T4Double):T4Int32;

{--------------------------rounding------------------------------------------}

{Round to Integer as single or double; modi is for ALL input value equal}
 procedure RoundYSingle         (var   Feld :array of T8Single);
 procedure TruncateYSingle      (var   Feld :array of T8Single);
 procedure FloorYSingle         (var   Feld :array of T8Single);
 procedure CeilYSingle          (var   Feld :array of T8Single);
 procedure RoundYDouble         (var   Feld :array of T4Double);
 procedure TruncateYDouble      (var   Feld :array of T4Double);
 procedure FloorYDouble         (var   Feld :array of T4Double);
 procedure CeilYDouble          (var   Feld :array of T4Double);

 {Max 6 Digits for single and 14 digits for double when greater -> set the max
  posibility of single or double digits for rounding.}
 procedure RoundYSingle         (var Feld :array of T8Single; Digits :Byte);overload;
 function  RoundYSingle         (constref Value :Single; Digits :Byte):Single;overload;
 procedure RoundYDouble         (var Feld :array of T4Double; Digits :Byte);overload;
 function  RoundYDouble         (constref Value :Double; Digits :Byte):Double;overload;
 procedure RoundChopYSingle     (var Feld :array of T8Single; Digits :Byte);overload;
 function  RoundChopYSingle     (constref Value :Single; Digits :Byte):Single;overload;
 procedure RoundChopYDouble     (var Feld :array of T4Double; Digits :Byte);overload;
 function  RoundChopYDouble     (constref Value :Double; Digits :Byte):Double;overload;

{---------------------------------logical-----------------------------------}

 {Test of zero in ALL positions.}
 function  TestYSingle          (const Feld :T8Single):Boolean;
 function  TestYDouble          (const Feld :T4Double):Boolean;


{-------------------------------statistic functions-------------------------}

 procedure StatCalcYSingle      (const Feld :array of T8Single; count :Longint;
                                 out   average,sDev,variance,skew,Excess :Single);
 procedure StatCalcVYSingle     (const Feld :array of T8Single;const count :T8Int32;
                                 out   average,sDev,variance,skew,excess :T8Single);
 procedure StatCalcYDouble      (const Feld :array of T4Double; count :Longint;
                                 out   average,sDev,variance,skew,Excess :Double);
 procedure StatCalcVYDouble     (const Feld :array of T4Double;const count :T4Int32;
                                 out   average,sDev,variance,skew,Excess :T4Double);
 function  AverageYSingle       (const Feld :array of T8Single;count :Longint):Single;
 function  AverageVYSingle      (const Feld :array of T8Single;
                                 const count :T8Int32):T8Single;
 function  AverageVYDouble      (const Feld :array of T4Double;const count :T4Int32):T4Double;
 function  AverageYDouble       (const Feld :array of T4Double;count :Longint):Double;
 function  GeoAverageVYSingle   (const Feld :array of T8Single;const count :T8Int32):T8Single;
 function  GeoAverageYSingle    (const Feld :array of T8Single;count :Longint):Single;
 function  GeoAverageVYDouble   (const Feld :array of T4Double;const count :T4Int32):T4Double;
 function  GeoAverageYDouble    (const Feld :array of T4Double;count :Longint):Double;

 function  KorrAnalyseYSingle   (const x,y  :array of T8Single;count :Longint):Single;
 function  KorrAnalyse4VYSingle (const Feld :array of T8Single;const count :T8Int32):T4Single;

{--------------regressions----------------------------------------------------}

 function  LinRegYSingle        (const x,y  :array of T8Single;count :Longint;
                                   out a,b  :Single):Longbool;
 function  LinReg4VYSingle      (const Feld :array of T8Single;
                                 const count :T8Int32):T8Single;
 function  LogRegYSingle        (const x,y  :array of T8Single;count :Longint;
                                   out a,b  :Single):Longbool;
 function  LogReg4VYSingle      (const Feld :array of T8Single;
                                 const count :T8Int32):T8Single;
 function  ExpRegYSingle        (const x,y  :array of T8Single;count :Longint;
                                   out a,b  :Single):Longbool;
 function  ExpReg4VYSingle      (const Feld :array of T8Single;
                                 const count :T8Int32):T8Single;
 function  BPotenzRegYSingle    (const x,y  :array of T8Single;count :Longint;
                                   out a,b  :Single):Longbool;
 function  BPotenzReg4VYSingle  (const Feld :array of T8Single;
                                 const count :T8Int32):T8Single;
 function  XPotenzRegYSingle    (const x,y  :array of T8Single;count :Longint;
                                   out a,b  :Single):Longbool;
 function  XPotenzReg4VYSingle  (const Feld :array of T8Single;
                                 const count :T8Int32):T8Single;
 function  KorrAnalyseYDouble   (const x,y  :array of T4Double;count :Longint):Double;
 function  KorrAnalyse2VYDouble (const Feld :array of T4Double;
                                 const count :T4Int32):T2Double;
 function  LinRegYDouble        (const x,y  :array of T4Double;count :Longint;
                                   out a,b  :Double):Longbool;
 function  LinReg2VYDouble      (const Feld :array of T4Double;
                                 const count :T4Int32):T4Double;
 function  LogRegYDouble        (const x,y  :array of T4Double;count :Longint;
                                   out a,b  :Double):Longbool;
 function  LogReg2VYDouble      (const Feld :array of T4Double;
                                 const count :T4Int32):T4Double;
 function  ExpRegYDouble        (const x,y  :array of T4Double;count :Longint;
                                   out a,b  :Double):Longbool;
 function  ExpReg2VYDouble      (const Feld :array of T4Double;
                                 const count :T4Int32):T4Double;
 function  BPotenzRegYDouble    (const x,y  :array of T4Double;count :Longint;
                                   out a,b  :Double):Longbool;
 function  BPotenzReg2VYDouble  (const Feld :array of T4Double;
                                 const count :T4Int32):T4Double;
 function  XPotenzRegYDouble    (const x,y  :array of T4Double;count :Longint;
                                   out a,b  :Double):Longbool;
 function  XPotenzReg2VYDouble  (const Feld :array of T4Double;
                                 const count :T4Int32):T4Double;

{------------------------------convert-------------------------------------}

 function  ConvertYSingleToInt32 (const Feld :T8Single):T8Int32;overload;
 function  ConvertYSingleToDouble(const Feld :T4Single):T4Double;overload;
 function  ConvertYDoubleToInt32 (const Feld :T4Double):T4Int32;overload;
 function  ConvertYDoubleToSingle(const Feld :T4Double):T4Single;overload;
 function  ConvertYInt32ToSingle (const Feld :T8Int32) :T8Single;overload;
 function  ConvertYInt32ToDouble (const Feld :T4Int32) :T4Double;overload;
 function  ChopYSingleToInt32    (const Feld :T8Single):T8Int32;overload;
 function  ChopYDoubleToInt32    (const Feld :T4Double):T4Int32;overload;

 function  ConvertYSingleToInt32 (const Feld :array of T8Single;
                                    out Res  :array of T8Int32):Longbool;overload;
 function  ConvertYSingleToDouble(const Feld :array of T8Single;
                                    out Res  :array of T4Double):Longbool;overload;
 function  ConvertYDoubleToInt32 (const Feld :array of T4Double;
                                    out Res  :array of T4Int32):Longbool;overload;
 function  ConvertYDoubleToSingle(const Feld :array of T4Double;
                                    out Res  :array of T4Single):longbool;overload;
 function  ConvertYInt32ToSingle (const Feld :array of T8Int32;
                                    out Res  :array of T8Single):Longbool;overload;
 function  ConvertYInt32ToDouble (const Feld :array of T8Int32;
                                    out Res  :array of T4Double):Longbool;overload;
 function  ChopYSingleToInt32    (const Feld :array of T8Single;
                                    out Res  :array of T8Int32):longbool;overload;
 function  ChopYDoubleToInt32    (const Feld :array of T4Double;
                                    out Res  :array of T4Int32):Longbool;overload;

{------------------------------compare--------------------------------------}

 function  CmpYSingleEQ        (const a,b :T8Single):T8YBool;
 function  CmpYSingleLT        (const a,b :T8Single):T8YBool;
 function  CmpYSingleLE        (const a,b :T8Single):T8YBool;
 function  CmpYSingleGE        (const a,b :T8Single):T8YBool;
 function  CmpYSingleGT        (const a,b :T8Single):T8YBool;

 function  CmpYDoubleEQ        (const a,b :T4Double):T4YBool;
 function  CmpYDoubleLT        (const a,b :T4Double):T4YBool;
 function  CmpYDoubleLE        (const a,b :T4Double):T4YBool;
 function  CmpYDoubleGE        (const a,b :T4Double):T4YBool;
 function  CmpYDoubleGT        (const a,b :T4Double):T4YBool;


{----------------------------diverses---------------------------------------}

 {extract the sign of the array fields. Result a bit field.}
 function  SignExtractYSingle  (const Feld :T8Single):Longint;
 function  SignExtractYDouble  (const Feld :T4Double):Longint;

 {Test for NAN and infinity}
 function  Is_INFYSingle       (const Feld :T8Single):T8YBool;
 function  Is_INFYDouble       (const Feld :T4Double):T4YBool;
 function  Is_NANYSingle       (const Feld :T8Single):T8YBool;
 function  Is_NANYDouble       (const Feld :T4Double):T4YBool;

{$ENDIF}

implementation


function fnTestIntelAVX :Boolean;assembler;nostackframe;
 asm
   xor eax,eax;
   mov eax,1;
   cpuid;
   and ecx,$18000000;
   cmp ecx,$18000000; // check both OSXSAVE Bit 27 and AVX Bit 28 feature flags
   jne @not_supported;
   // processor supports AVX instructions and XGETBV is enabled by OS
   mov  ecx,0;          // specify 0 for XCR0 register
   db $0F,$01,$D0;   //XGETBV;              //result in EDX:EAX
   and  eax,06H;
   cmp  eax,06H;       // check OS has enabled both XMM and YMM state support
   jne  @not_supported;
   mov  eax,1
   jmp  @ok;
  @not_supported:
   xor eax,eax;
  @ok:
end;


{$IFDEF CPUX86_64}
{$DEFINE SIMD256}
{$INCLUDE simd_fpu}

{----------------------------manipulate MXCSR-------------------------------}

function GetYControlWord: Longword; assembler;nostackframe;

 asm
 sub  rsp,16;
 vstmxcsr dword ptr [rsp];
 mov  eax,dword ptr [rsp];
 add rsp,16;
end;

{The upper 16 bit must are always zero!}
procedure SetYControlWord (cw :Longword); assembler; nostackframe;

 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;   //cw
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  sub rsp,16;
  mov dword ptr [rsp],ecx;
  vldmxcsr dword ptr [rsp];
  add rsp,16;
end;

procedure SetYNotDenormals ;assembler;nostackframe;
{Set denormals on input and output values to zero.}

{In FPC is normal masked; denormal, underflow and precision}
 asm
  sub rsp,16;
  mov eax,$00008140;           //1000 0001 0100 0000b
  vstmxcsr dword ptr [rsp];    // 8    1      4     0
  mov edx, dword ptr [rsp];
  or  edx,eax;
  mov dword ptr [rsp],edx;
  vldmxcsr dword ptr [rsp];
  add rsp,16;
end;

procedure SetYUseDenormals ;assembler;nostackframe;
{Clear all exceptions flags (bit 0..5) and reset to use denormals
 and clear denormals as zero.}
 asm
  sub rsp,16;
  vstmxcsr dword ptr [rsp];
  mov eax,dword ptr[rsp];
  mov edx,$00007900;       // 0111 1001 0000 0000b
  and eax,edx;
  mov dword ptr [rsp],eax;
  vldmxcsr dword ptr [rsp];
  add rsp,16;
end;

{--------------------------------calculations--------------------------------}

procedure SetValueYSingle (out Feld :array of T8Single; constref Value :Single);
  assembler;nostackframe;

asm
 {$IFNDEF WIN64}
  mov rcx,rdi;   //Feld
  mov rdx,rsi;   //length
  mov r8, rdx;   //value
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  vbroadcastss ymm0,dword ptr [r8];
  xor r11,r11;
align 16;
 @Loop:
  vmovups ymmword ptr [rcx+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @loop;
  vzeroupper;
 @ende:
end;

procedure SetValuePlaceYSingle (var Feld :array of T8Single;
                               constref Value :Single; place :Byte);
                               assembler;nostackframe;
asm
 {$IFNDEF WIN64}
  mov rcx,rdi;    // Feld
  mov rdx,rsi;    // length
  mov r8, rdx;    // Value
  mov r9, rcx;    // place
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  mov  r10d,$80000000;
  vbroadcastss ymm1,dword ptr[r8];
  and r9b,$07               // only 7 value position
  cmp r9b,0;
  jne @1;
  vpinsrd xmm0,xmm0,r10d,0;
  jmp @00;
 @1:
  cmp r9b,1;
  jne @2
  vpinsrd xmm0,xmm0,r10d,1;
  jmp @00;
 @2:
  cmp r9b,2;
  jne @3;
  vpinsrd xmm0,xmm0,r10d,2;
  jmp @00;
 @3:
  cmp r9b,3;
  jne @4;
  vpinsrd xmm0,xmm0,r10d,3;
  jmp @00;
 @4:
  cmp r9b,4;
  jne @5;
  vpinsrd xmm0,xmm0,r10d,0;
  vinsertf128 ymm0,ymm0,xmm0,1;
  jmp @00;
 @5:
  cmp r9b,5;
  jne @6;
  vpinsrd xmm0,xmm0,r10d,1;
  vinsertf128 ymm0,ymm0,xmm0,1;
  jmp @00;
 @6:
  cmp r9b,6;
  jne @7;
  vpinsrd xmm0,xmm0,r10d,2;
  vinsertf128 ymm0,ymm0,xmm0,1;
  jmp @00;
 @7:
  vpinsrd xmm0,xmm0,r10d,3;
  vinsertf128 ymm0,ymm0,xmm0,1;
 @00:
  xor r11,r11;
align 16;
 @Loop:
  vmovups ymm2,ymmword ptr [rcx+r11];
  vblendvps ymm2,ymm2,ymm1,ymm0;
  vmovups ymmword ptr [rcx+r11],ymm2;
  add r11,32;
  sub rdx,1;
  jnz @loop;
  vzeroupper;
 @ende:
end;

procedure SetValueYDouble (out Feld :array of T4Double; constref Value :Double);
  assembler;nostackframe;

asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  vbroadcastsd ymm0,[r8];
  xor r11,r11;
align 16;
 @Loop:
  vmovupd ymmword ptr [rcx+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @loop;
  vzeroupper;
 @ende:
end;

procedure SetValuePlaceYDouble (var Feld :array of T4Double;
                               constref Value :Double; place :Byte);
                               assembler;nostackframe;
asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js  @ende;
  add rdx,1;
  vxorpd ymm0,ymm0,ymm0;
  mov rax,$8000000000000000;
  vbroadcastsd ymm1,[r8];
  and r9b,$03;        // only 4 value position
  cmp r9b,0;
  jne @1;
  vpinsrq xmm0,xmm0,rax,0;
  jmp @00;
 @1:
  cmp r9b,1;
  jne @2
  vpinsrq xmm0,xmm0,rax,1;
  jmp @00;
 @2:
  cmp r9b,2;
  jne @3;
  vpinsrq xmm0,xmm0,rax,2;
  vinsertf128 ymm0,ymm0,xmm0,1;
  jmp @00;
 @3:
  vpinsrq xmm0,xmm0,rax,3;
  vinsertf128 ymm0,ymm0,xmm0,1;
  jmp @00;
 @00:
  xor r11,r11;
align 16;
 @Loop:
  vmovupd ymm2,ymmword ptr [rcx+r11];
  vblendvpd ymm2,ymm2,ymm1,ymm0;
  vmovupd ymmword ptr [rcx+r11],ymm2;;
  add r11,32;
  sub rdx,1;
  jnz @loop;
  vzeroupper;
 @ende:
end;

{---------------------------addition----------------------------------------}


// Summ all array cols
function SumVYSingle(const Feld :array of T8Single):T8Single;
     assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;   //result
  mov rdx,rsi;   //Feld
  mov r8, rdx;   //length
  mov r9, rcx;
 {$ENDIF}
  vxorps ymm0,ymm0,ymm0;
  test r8,r8;                     // value < 0 not valid
  js   @ende;
  add  r8,1;
  xor r11,r11;
align 16;
 @Loop:
  vaddps ymm0,ymm0,ymmword [rdx+r11];
  add r11,32;
  sub r8,1;
  jnz @Loop;

  vmovups ymmword ptr [rcx],ymm0;
 @ende:
  vzeroupper;
end;

// Add all array rows with a const value
function AddValueYSingle (const Feld :array of T8Single;out Res :array of T8Single;
                      constref Value :Single):Longbool;assembler;
 asm
  push r12;
 {$IFNDEF WIN64}
  mov r12,r8     // Value
  mov rcx,rdi;   // Feld
  mov rdx,rsi;   // length
  mov r8, rdx;   // Res
  mov r9, rcx;   // length
 {$ENDIF}
 {$IFDEF WIN64}
  mov  r12,qword ptr [Value];
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  vbroadcastss ymm1,dword ptr [r12];
  xor r11,r11;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr [rcx+r11];
  vaddps  ymm0,ymm0,ymm1;
  vmovups ymmword ptr [r8+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
  pop r12;
end;

// Add all array rows with a const value
procedure AddValueYSingle (var Feld :array of T8Single;
                      constref Value :Single);assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;   // Feld
  mov rdx,rsi;   // length
  mov r8, rdx;   // Value
  mov r9, rcx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  vbroadcastss ymm1,dword ptr [r8];
  xor r11,r11;
align 16;
 @Loop:
  vaddps  ymm0,ymm1,ymmword ptr [rcx+r11];
  vmovups ymmword ptr [rcx+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;


{Add 2 or 4 array pairs. You MUST set unused arrays to zero or you
result is incorrect.}
function Add4VYSingle(const Feld :array of T8Single;
                        out Res  :array of T4Single):Longbool;
                       assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;             // check length Feld = Res
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor r11,r11;
  xor r10,r10;
align 16;
 @Loop:
  vmovups ymm0,ymmword [rcx+r11];
  vhaddps ymm0,ymm0,ymm0;
  vshufps ymm0,ymm0,ymm0,00111100b;
  vextractf128 xmm1,ymm0,1;
  vshufps xmm0,xmm0,xmm1,01000100b;
  vmovups xmmword ptr [r8+r10],xmm0;
  add r11,32;
  add r10,16;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;


{Add 2,3,..8 array fields. You MUST set unused arrays to zero or you
result is incorrect.}
function AddVYSingle(const Feld :array of T8Single;
                       out Res :array of Single):Longbool;
                      assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  xor rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js  @ende;
  cmp rdx,r9;             // check length Feld = Res
  jne @ende;
  mov rax,1;
  add rdx,1;
  xor r11,r11;
  xor r10,r10;
align 16;
 @Loop:
  vmovups ymm0,ymmword [rcx+r11];
  vhaddps ymm0,ymm0,ymm0;   //2    haddps only in the 128 lane!
  vhaddps ymm0,ymm0,ymm0;   //4
  vextractf128 xmm1,ymm0,1;
  vaddps  ymm0,ymm0,ymm1;
  vmovss  [r8+r10],xmm0;
  add r11,32;
  add r10,4;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{Add the array fields}
function AddYSingle(const Feld1,Feld2 :array of T8Single;
                      out Res :array of T8Single):Longbool;assembler;
 asm
  push r12;
  push r13;
 {$IFNDEF WIN64}
  mov r12,r8;           // Res
  mov r13,r9;           // length
  mov rcx,rdi;          // Feld1
  mov rdx,rsi;          // length
  mov r8, rdx;          // Feld2
  mov r9, rcx;          // length
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Res];
  mov r13,qword ptr [Res+8];
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  test r9,r9;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  cmp  rdx,r13;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[rcx+r11];
  vaddps  ymm0,ymm0,ymmword ptr[r8+r11];
  vmovups ymmword ptr [r12+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @loop;
  vzeroupper;
 @ende:
  pop r13;
  pop r12;
end;

function Add2TabYSingle (const Tab1,Tab2 :array of T8Single;
                         out ResTab :array of T8Single):Longbool;assembler;

 asm
  push r12;
  push r13;
 {$IFNDEF WIN64}
  mov r12,r8;     // adress ResTab
  mov r13,r9;     // length ResTab
  mov rcx,rdi;    // adress Tab1
  mov rdx,rsi;    // length Tab1
  mov r8, rdx;    // adress Tab2
  mov r9, rcx;    // length Tab2
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [ResTab]
  mov r13,qword ptr [ResTab+8];
 {$ENDIF}
  xor  rax,rax;    // Result
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  test r9,r9;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  cmp  rdx,r13;
  jne  @ende;
  add  rdx,1;
  mov  rax,1;       //true
  xor  r11,r11;
align 16;
 @loop:
  vmovups ymm0,ymmword ptr [rcx+r11];  // Tab1
  vmovups ymm1,ymmword ptr [r8+r11];   // Tab2
  {x0+x1,x2+x3,y0+y1,y2+y3} // order of result
  vhaddps ymm0,ymm0,ymm1;
  vmovups ymmword ptr[r12+r11],ymm0;   // ResTab
  add r11,32;
  sub rdx,1;
  jnz @loop;
  vzeroupper;
 @ende:
  pop r13;
  pop r12;
end;

{Calculate the sum,min and max for the array fields.}
procedure SumMinMaxYSingle(const Feld :array of T8Single;
                      out Sum,Min,Max :Single);assembler;
 asm
  push r12;
 {$IFNDEF WIN64}
  mov r12,r8;         //max
  mov rcx,rdi;        //Feld
  mov rdx,rsi;        //length
  mov r8, rdx;        //sum
  mov r9, rcx;        //min
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr[Max];
 {$ENDIF}
  vxorps ymm0,ymm0,ymm0;
  vmovss dword ptr [r8],xmm0;
  vmovss dword ptr [r9],xmm0;
  vmovss dword ptr [r12],xmm0;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  mov  r10,rdx;
  mov  r11,32;                         // displacement
  vmovups ymm0,ymmword ptr[rcx];      // load aligned 8 single
  vmovaps ymm1,ymm0;                  // load for Min values
  vmovaps ymm2,ymm0;                  // load for Max values
  sub rdx,1;
  jz  @1;                             // only 1 row
align 16;
 @Loop:
  vmovups ymm3,ymmword [rcx+r11];     // load 8 single values
  vaddps  ymm0,ymm0,ymm3;             // add the rows
  vminps  ymm1,ymm1,ymm3;             // calculate Min
  vmaxps  ymm2,ymm2,ymm3;             // calculate Max
  add r11,32;
  sub rdx,1;
  jnz @Loop;

 @1:
  // calculate the sum
  vextractf128 xmm3,ymm0,1;           // Get upper half of array sums
  vaddps  xmm0,xmm0,xmm3;             // add  -> from 8 to 4 values in xmm0
  vhaddps xmm0,xmm0,xmm0;             // horizontal add
  vhaddps xmm0,xmm0,xmm0;             // dito result in all places equal
  // calculate minimum
  vextractf128 xmm3,ymm1,1;           // upper min half -> xmm3
  vminps  xmm1,xmm1,xmm3;             // 4 single min
  vshufps xmm3,xmm3,xmm3,10110001b;
  vminps  xmm1,xmm1,xmm3;             // valid value pos 1 and 3
  vshufps xmm1,xmm1,xmm3,10001111b;   // place 3 over 1
  vminps  xmm1,xmm1,xmm3;             // min in place 1
  // calculate maximum
  vextractf128 xmm3,ymm2,1;           // upper min half -> xmm3
  vmaxps  xmm2,xmm2,xmm3;             // 4 single max
  vshufps xmm3,xmm3,xmm3,10110001b;   // pos 2,1,4,3
  vmaxps  xmm2,xmm2,xmm3;             // max is between 1 and 3
  vshufps xmm5,xmm2,xmm2,10001111b    // place 3 over 1
  vmaxps  xmm2,xmm2,xmm5;             // pos 1 valid

  vmovss [r9],xmm1;                  // min
  vmovss [r8],xmm0;                   // sum
  vmovss [r12],xmm2;                  // max
  vzeroupper;

 @ende:
  pop r12;
end;

{Calculate the sum,average,min and max of the array cols.}
procedure SumMinMaxVYSingle(const Feld :array of T8Single;
                      out Sum,Min,Max :T8Single);assembler;
 asm
  push r12;
  push r13;
 {$IFNDEF WIN64}
  mov r12,r8;         //max
  mov r13,r9;
  mov rcx,rdi;        //Feld
  mov rdx,rsi;        //length
  mov r8, rdx;        //sum
  mov r9,rcx;         //min
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [max];
 {$ENDIF}
  vxorps ymm0,ymm0,ymm0;
  vmovups ymmword ptr [r8],ymm0;
  vmovups ymmword ptr [r9],ymm0;
  vmovups ymmword ptr [r12],ymm0;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add rdx,1;
  mov r10,rdx;
  mov r11,32;                         // displacement
  vmovups ymm0,ymmword ptr[rcx];      // load sum
  vmovaps ymm1,ymm0;                  // load Min
  vmovaps ymm2,ymm0;                  // load Max
  sub rdx,1;
  jz  @1;                             // only 1 row
align 16;
 @Loop:
  vmovups ymm3,ymmword [rcx+r11];     // load 8 single values
  vaddps  ymm0,ymm0,ymm3;             // sum
  vminps  ymm1,ymm1,ymm3;             // Min
  vmaxps  ymm2,ymm2,ymm3;             // Max
  add r11,32;
  sub rdx,1;
  jnz @Loop;

 @1:
  vmovups ymmword ptr [r8],ymm0;      // sum of the cols
  vmovups ymmword ptr [r9],ymm1;      // min of the cols
  vmovups ymmword ptr [r12],ymm2;     // max of the cols

 @ende:
  vzeroupper;
  pop r13;
  pop r12;
end;


// Sum ALL array cols
function SumVYDouble (const Feld :array of T4Double):T4Double;
     assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vxorpd ymm0,ymm0,ymm0;
  test r8,r8;                     // value < 0 not valid
  js   @ende;
  add  r8,1;
  xor r11,r11;
align 16;
 @Loop:
  vaddpd ymm0,ymm0,ymmword ptr [rdx+r11];
  add r11,32;
  sub r8,1;
  jnz @Loop;

 @ende:
  vmovupd ymmword ptr [rcx],ymm0;
  vzeroupper;
end;

// add 2 array fields
function AddYDouble (const Feld1,Feld2 :array of T4Double;
                     out Res :array of T4Double):Longbool;assembler;
 asm
  push r12;
  push r13;
 {$IFNDEF WIN64}
  mov r12,r8;
  mov r13,r9;
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9 ,rcx;
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Res];
  mov r13,qword ptr [Res+8];
 {$ENDIF}
  xor rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp rdx,r9;
  jne @ende;
  cmp rdx,r13;
  jne @ende;
  mov rax,1;
  add rdx,1;
  xor r10,r10;
  xor r11,r11;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr [rcx+r11];
  vaddpd  ymm0,ymm0,ymmword ptr [r8+r11];
  vmovupd ymmword ptr [r12+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
  pop r13;
  pop r12;
end;

{Add 2 array pairs}
function Add2VYDouble (const Feld :array of T4Double;
                       out Res :array of T2Double):Longbool;
                       assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  xor rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js  @ende;
  cmp rdx,r9;             // check length Feld = Res
  jne @ende;
  mov rax,1;
  add rdx,1;
  xor r11,r11;
  xor r10,r10;
align 16;
 @Loop:
  vmovupd ymm0,ymmword [rcx+r11];
  vhaddpd ymm0,ymm0,ymm0;
  vextractf128 xmm1,ymm0,1;
  vshufpd xmm0,xmm0,xmm1,0;
  vmovupd xmmword ptr [r8+r10],xmm0;
  add r11,32;
  add r10,16;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;


{Add 2,3 or 4 array fields for one result. You MUST set unused arrays
 to zero or you or the result is incorrect.}
function AddVYDouble(const Feld :array of T4Double;
                     out Res :array of Double):Longbool;assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  xor rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js  @ende;
  cmp rdx,r9;             // check length Feld = Res
  jne @ende;
  mov rax,1;
  add rdx,1;
  xor r11,r11;
  xor r10,r10;
align 16;
 @Loop:
  vmovupd ymm0,ymmword [rcx+r11];
  vhaddpd ymm0,ymm0,ymm0; //2
  vextractf128 xmm1,ymm0,1;
  vaddpd  xmm0,xmm0,xmm1  //4
  vmovsd  qword ptr [r8+r10],xmm0;
  add r11,32;
  add r10,8;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

function Add2TabYDouble (const Tab1,Tab2 :array of T4Double;
                         out ResTab :array of T4Double):Longbool;assembler;

 asm
  push r12;
  push r13;
 {$IFNDEF WIN64}
  mov r12,r8;     // adress ResTab
  mov r13,r9;     // length ResTab
  mov rcx,rdi;    // adress Tab1
  mov rdx,rsi;    // length Tab1
  mov r8, rdx;    // adress Tab2
  mov r9, rcx;    // length Tab2
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [ResTab]
  mov r13,qword ptr [ResTab+8];
 {$ENDIF}
  xor rax,rax;    // Result
  test rdx,rdx;                     // value < 0 not valid
  js  @ende;
  cmp rdx,r9;
  jne @ende;
  cmp rdx,r13;
  jne @ende;
  add rdx,1;
  mov rax,1;       //true
  xor r11,r11;
align 16;
 @loop:
  vmovupd ymm0,ymmword ptr [rcx+r11];  // Tab1
  vmovupd ymm1,ymmword ptr [r8+r11];   // Tab2
  {x0+x1,x2+x3,y0+y1,y2+y3} // order of result
  vhaddpd ymm0,ymm0,ymm1;
  vmovupd ymmword ptr[r12+r11],ymm0;   // ResTab
  add r11,32;
  sub rdx,1;
  jnz @loop;
  vzeroupper;
 @ende:
  pop r13;
  pop r12;
end;

// add a const value to all array fields
function AddValueYDouble (const Feld :array of T4Double;out Res :array of T4Double;
                          constref Value :Double):Longbool;assembler;

 asm
  push r12;
 {$IFNDEF WIN64}
  mov r12,r8;     // Value
  mov rcx,rdi;    // Felde
  mov rdx,rsi;
  mov r8, rdx;    // Res
  mov r9, rcx;
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Value];
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  vbroadcastsd ymm1,[r12];
  xor r11,r11;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr [rcx+r11];
  vaddpd  ymm0,ymm0,ymm1;
  vmovupd ymmword ptr [r8+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
  pop r12;
end;

// add a const value to all array fields
procedure AddValueYDouble (var Feld :array of T4Double;
                          constref Value :Double);assembler;nostackframe;

 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;    // Felde
  mov rdx,rsi;
  mov r8, rdx;    // value
  mov r9, rcx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  vbroadcastsd ymm1,[r8];
  xor r11,r11;
align 16;
 @Loop:
  vaddpd  ymm0,ymm1,ymmword ptr [rcx+r11];
  vmovupd ymmword ptr [rcx+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;


{calculation of the average, minimum and maximum for the array}
procedure SumMinMaxYDouble(const Feld :array of T4Double;
                      out Sum,Min,Max :Double);assembler;
 asm
  push r12;
 {$IFNDEF WIN64}
  mov r12,r8;      //Max
  mov rcx,rdi;     //Feld
  mov rdx,rsi;     //length
  mov r8, rdx;     //Sum
  mov r9, rcx;     //Min
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr[max];
 {$ENDIF}
  vxorpd ymm0,ymm0,ymm0;
  vmovsd qword ptr [r8],xmm0;
  vmovsd qword ptr [r9],xmm0;
  vmovsd qword ptr [r12],xmm0;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  mov  r10,rdx;
  vmovupd ymm0,ymmword ptr[rcx];  // load 8 double
  vmovapd ymm1,ymm0;              // load for Min
  vmovapd ymm2,ymm0;              // load for Max
  mov r11,32;
  sub rdx,1;
  jz  @1;                         // only 1 row
align 16;
 @Loop:
  vmovupd ymm3,ymmword [rcx+r11];
  vaddpd  ymm0,ymm0,ymm3;         // addition
  vminpd  ymm1,ymm1,ymm3;         // Min
  vmaxpd  ymm2,ymm2,ymm3;         // Max
  add r11,32;
  sub rdx,1;
  jnz @Loop;

 @1:
  // calculate the sum
  vextractf128 xmm3,ymm0,1;       // Get upper half
  vaddpd  xmm0,xmm0,xmm3;         // 4 to 2 value
  vhaddpd xmm0,xmm0,xmm0;
  // calculate the minimum
  vextractf128 xmm3,ymm1,1;    // upper half -> xmm3
  vminpd  xmm1,xmm1,xmm3;
  vshufpd xmm3,xmm3,xmm3,$1;   // change the values save in xmm3
  vminpd  xmm1,xmm1,xmm3;
  // calculate the maximum
  vextractf128 xmm3,ymm2,1;
  vmaxpd  xmm2,xmm2,xmm3;
  vshufpd xmm3,xmm2,xmm2,$1;   // change the values save in xmm3
  vmaxpd  xmm2,xmm2,xmm3;

  vmovsd  qword ptr[r12],xmm2; // max
  vmovsd  qword ptr[r8],xmm0;  // Sum
  vmovsd  qword ptr[r9],xmm1; // min
 @ende:
  vzeroupper;
  pop r12;
end;

// calculation Min,Max,Sum and Average for the array cols
procedure SumMinMaxVYDouble(const Feld :array of T4Double;
                      out Sum,Min,Max :T4Double);assembler;
 asm
  push r12;
 {$IFNDEF WIN64}
  mov r12,r8;      //Max
  mov rcx,rdi;     //Feld
  mov rdx,rsi;     //length
  mov r8, rdx;     //Sum
  mov r9, rcx;     //Min
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [max];
 {$ENDIF}
  vxorpd ymm0,ymm0,ymm0;
  vmovsd qword ptr [r8],xmm0;
  vmovsd qword ptr [r9],xmm0;
  vmovsd qword ptr [r12],xmm0;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add rdx,1;
  mov r10,rdx;
  mov r11,32;
  vmovupd ymm0,ymmword ptr[rcx];     // load 8 double
  vmovapd ymm1,ymm0;                  // load for Min
  vmovapd ymm2,ymm0;                  // load for Max
  sub rdx,1;
  jz  @1;
align 16;
 @Loop:
  vmovupd ymm3,ymmword [rcx+r11];     // load values
  vaddpd  ymm0,ymm0,ymm3;             // addition
  vminpd  ymm1,ymm1,ymm3;             // Min
  vmaxpd  ymm2,ymm2,ymm3;             // Max
  add r11,32;
  sub rdx,1;
  jnz @Loop;

 @1:
  vmovupd ymmword ptr [r8],ymm0;      // sum of the cols
  vmovupd ymmword ptr [r9],ymm1;     // min of the cols
  vmovupd ymmword ptr [r12],ymm2;     // max of the cols

 @ende:
  vzeroupper;
  pop r12;
end;


{-----------------------subtract------------------------------------------}


function SubYSingle (const Feld1,Feld2 :array of T8Single;
                     out Res :array of T8Single):Longbool;assembler;

asm
  push r12;
  push r13;
 {$IFNDEF WIN64}
  mov r12,r8;        //Res
  mov r13,r9;        //length
  mov rcx,rdi;       //Feld1
  mov rdx,rsi;       //length
  mov r8, rdx;       //Feld2
  mov r9 ,rcx;       //length
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Res];
  mov r13,qword ptr [Res+8];
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js  @ende;
  cmp  rdx,r9;
  jne  @ende;
  cmp  rdx,r13;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[rcx+r11];
  vsubps  ymm0,ymm0,ymmword ptr[r8+r11];
  vmovups ymmword ptr [r12+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
  pop r13;
  pop r12;
end;

{res = (Feld1-Feld2)/Value}
function SubDivValueYSingle (const Feld1,Feld2 :array of T8Single;
                        out Res :array of T8Single;
                        constref Value :Single):Longbool;assembler;

asm
  push r12;
  push r13;
  push r14;
 {$IFNDEF WIN64}
  mov r12,r8;        //Res
  mov r13,r9;        //length
  mov rcx,rdi;       //Feld1
  mov rdx,rsi;       //length
  mov r8, rdx;       //Feld2
  mov r9 ,rcx;       //length
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Res];
  mov r13,qword ptr [Res+8];
 {$ENDIF}
  mov r14,qword ptr [Value];
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js  @ende;
  cmp  rdx,r9;
  jne  @ende;
  cmp  rdx,r13;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor  r11,r11;
  vmovd xmm1,dword ptr [r14];
  vshufps xmm1,xmm1,xmm1,0;
  vinsertf128 ymm1,ymm1,xmm1,1;
  vpcmpeqw xmm0,xmm0,xmm0;
  vpslld   xmm0,xmm0,25;
  vpsrld   xmm0,xmm0,2;
  vinsertf128 ymm0,ymm0,xmm0,1;
  vdivps  ymm0,ymm0,ymm1;
align 16;
 @Loop:
  vmovups ymm1,ymmword ptr[rcx+r11];
  vsubps  ymm1,ymm1,ymmword ptr[r8+r11];
  vmulps  ymm1,ymm1,ymm0;
  vmovups ymmword ptr [r12+r11],ymm1;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
  pop r14;
  pop r13;
  pop r12;
end;

{Res = Feld1 * (Feld2 - Feld3)}
function MulDiffYSingle (const Feld1,Feld2,Feld3 :array of T8Single;
                         out Res :array of T8Single):Longbool;assembler;

asm
  push r12;
  push r13;
  push r14;
  push r15;
 {$IFNDEF WIN64}
  mov r12,r8;        //Feld3
  mov r13,r9;        //length
  mov rcx,rdi;       //Feld1
  mov rdx,rsi;       //length
  mov r8, rdx;       //Feld2
  mov r9 ,rcx;       //length
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Feld3];
  mov r13,qword ptr [Feld3+8];
 {$ENDIF}
  mov r14,qword ptr [Res];
  mov r15,qword ptr [Res+8];
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;      // all Feld length =
  jne  @ende;
  cmp  rdx,r13;
  jne  @ende;
  cmp  rdx,r15;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[r8+r11];     //Feld2
  vsubps  ymm0,ymm0,ymmword ptr[r12+r11]; // Feld2 - Feld3
  vmulps  ymm0,ymm0,ymmword ptr[rcx+r11]; // Feld1*(Feld2-Feld3)
  vmovups ymmword ptr [r14+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  vzeroupper;
 @ende:
  pop  r15;
  pop  r14;
  pop  r13;
  pop  r12;
end;

{Res = Sum(Feld1 * (Feld2 - Feld3))}
function SumMulDiffYSingle (const Feld1,Feld2,Feld3 :array of T8Single;
                         out Res :Single):Longbool;assembler;
asm
  push r12;
  push r13;
  push r14;
 {$IFNDEF WIN64}
  mov r12,r8;        //Feld3
  mov r13,r9;        //length
  mov rcx,rdi;       //Feld1
  mov rdx,rsi;       //length
  mov r8, rdx;       //Feld2
  mov r9 ,rcx;       //length
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Feld3];
  mov r13,qword ptr [Feld3+8];
 {$ENDIF}
  mov r14,qword ptr [Res];
  xor  rax,rax;
  test rdx,rdx;     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;      // all Feld length =
  jne  @ende;
  cmp  rdx,r13;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor  r11,r11;
  vxorps ymm0,ymm0,ymm0;
align 16;
 @Loop:
  vmovups ymm1,ymmword ptr [r8+r11];      // Feld2
  vsubps  ymm1,ymm1,ymmword ptr[r12+r11]; // Feld2 - Feld3
  vmulps  ymm1,ymm1,ymmword ptr[rcx+r11]; // Feld1*(Feld2-Feld3)
  vaddps  ymm0,ymm0,ymm1;                 // Summ(...)
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  vhaddps ymm0,ymm0,ymm0;
  vhaddps ymm0,ymm0,ymm0;
  vextractf128 xmm1,ymm0,1;
  vaddps xmm0,xmm0,xmm1;
  vmovss dword ptr [r14],xmm0;
  vzeroupper;
 @ende:
  pop  r14;
  pop  r13;
  pop  r12;
end;

{Calculate MAX(1,n)(Abs(Feld1*(Feld2-Feld3)))}
function MaxAbsMulDiffYSingle (const Feld1,Feld2,Feld3 :array of T8Single):Single;
                               assembler;
 asm
  push r12;
  push r13;
  {$IFNDEF WIN64}
  mov r12,r8;             //Feld3
  mov r13,r9;             //lenght
  mov rcx,rdi;            //Feld1
  mov rdx,rsi;            //length
  mov r8, rdx;            //Feld2
  mov r9, rcx;            //length
  {$ENDIF}
  {$IFDEF WIN64}
  mov r12,qword ptr [Feld3];
  mov r13,qword ptr [Feld3+8];
  {$ENDIF}
  vxorps ymm0,ymm0,ymm0;   // result = 0.0
  test rdx,rdx;            // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;             // length Feld1 = Feld2 = Feld3
  jne  @ende;
  cmp  rdx,r13;
  jne  @ende;
  add  rdx,1;
  vpcmpeqw xmm3,xmm3,xmm3;
  vpsrld   xmm3,xmm3,1;        // shift 0 in
  vinsertf128 ymm3,ymm3,xmm3,1;
  vxorps  ymm1,ymm1,ymm1;
  xor  r11,r11;
align 16;
 @loop:
  vmovups ymm0,ymmword ptr [r8+r11];       //Feld2
  vsubps  ymm0,ymm0,ymmword ptr [r12+r11]; //Feld2-Feld3
  vmulps  ymm0,ymm0,ymmword ptr [rcx+r11]; //Feld1 * (Feld2-Feld3)
  vandps  ymm0,ymm0,ymm3;                  //Abs
  vmaxps  ymm1,ymm1,ymm0;                  //Max
  add r11,32;
  sub rdx,1;
  jnz @loop;

  // calculate maximum
  vextractf128 xmm2,ymm1,1;            // read upper half
  vmaxps  xmm1,xmm1,xmm2;
  vmovaps xmm0,xmm1;                   // 1,2,3,4
  vshufps xmm1,xmm1,xmm1,10110001b;    // 2,1,4,3
  vmaxps  xmm0,xmm0,xmm1;
  vmovaps xmm1,xmm0;
  vshufps xmm1,xmm1,xmm1,01001110b;    // 4,3,2,1
  vmaxps  xmm0,xmm0,xmm1;              // max is equal in all places

 @ende:
  vzeroupper;
  pop r13;
  pop r12;
end;

{subtract 2,3 or 4 array pairs x0y0,x1y1,...x4,y4}
function Sub4VYSingle (const Feld :array of T8Single;
                         out Res  :array of T4Single):Longbool;
                       assembler;nostackframe;
 asm
  {$IFNDEF WIN64}
  mov rcx,rdi;            // Feld
  mov rdx,rsi;            // length
  mov r8, rdx;            // Res
  mov r9, rcx;            // length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;            // length Feld = Res
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor  r10,r10;
  xor  r11,r11;
align 16;
 @loop:
  vmovups ymm0,ymmword ptr [rcx+r11];
  vhsubps ymm0,ymm0,ymm0;
  vextractf128 xmm1,ymm0,1;
  vshufps xmm0,xmm0,xmm1,01000100b;
  vmovups xmmword ptr [r8+r10],xmm0; // result res[0],...res[3]
  add r11,32;
  add r10,16;
  sub rdx,1;
  jnz @loop;
  vzeroupper;
 @ende:
end;

{Subtract Table1 by Table2}
function Sub2TabYSingle (const Tab1,Tab2 :array of T8Single;
                         out ResTab :array of T8Single):Longbool;assembler;

 asm
  push r12;
  push r13;
 {$IFNDEF WIN64}
  mov r12,r8;     // adress ResTab
  mov r13,r9;     // length ResTab
  mov rcx,rdi;    // adress Tab1
  mov rdx,rsi;    // length Tab1
  mov r8, rdx;    // adress Tab2
  mov r9, rcx;    // length Tab2
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [ResTab]
  mov r13,qword ptr [ResTab+8];
 {$ENDIF}
  xor rax,rax;    // Result
  test rdx,rdx;                     // value < 0 not valid
  js  @ende;
  cmp rdx,r9;
  jne @ende;
  cmp rdx,r13;
  jne @ende;
  add rdx,1;
  mov rax,1;       //true
  xor r11,r11;
align 16;
 @loop:
  vmovups ymm0,ymmword ptr [rcx+r11];  // Tab1
  vmovups ymm1,ymmword ptr [r8+r11];   // Tab2
  {x0-x1,x2-x3,y0-y1,y2-y3} // order of result
  vhsubps ymm0,ymm0,ymm1;
  vmovups ymmword ptr[r12+r11],ymm0;   // ResTab
  add r11,32;
  sub rdx,1;
  jnz @loop;
  vzeroupper;
 @ende:
  pop r13;
  pop r12;
end;

{Subtract Table1 by Table2}
function Sub2TabYDouble (const Tab1,Tab2 :array of T4Double;
                         out ResTab :array of T4Double):Longbool;assembler;
 asm
  push r12;
  push r13;
 {$IFNDEF WIN64}
  mov r12,r8;     // adress ResTab
  mov r13,r9;     // length ResTab
  mov rcx,rdi;    // adress Tab1
  mov rdx,rsi;    // length Tab1
  mov r8, rdx;    // adress Tab2
  mov r9, rcx;    // length Tab2
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [ResTab]
  mov r13,qword ptr [ResTab+8];
 {$ENDIF}
  xor rax,rax;    // Result
  test rdx,rdx;                     // value < 0 not valid
  js  @ende;
  cmp rdx,r9;
  jne @ende;
  cmp rdx,r13;
  jne @ende;
  add rdx,1;
  mov rax,1;       //true
  xor r11,r11;
align 16;
 @loop:
  vmovupd ymm0,ymmword ptr [rcx+r11];  // Tab1
  vmovupd ymm1,ymmword ptr [r8+r11];   // Tab2
  vhsubpd ymm0,ymm0,ymm1;
  vmovupd ymmword ptr[r12+r11],ymm0;   // ResTab
  add r11,32;
  sub rdx,1;
  jnz @loop;
  vzeroupper;
 @ende:
  pop r13;
  pop r12;
end;

{MAX(1,n)(Abs(Feld1*(Feld2-Feld3)))}
function MaxAbsMulDiffYDouble (const Feld1,Feld2,Feld3 :array of T4Double):Double;
                               assembler;
 asm
  push r12;
  push r13;
  {$IFNDEF WIN64}
  mov r12,r8;             //Feld3
  mov r13,r9;             //lenght
  mov rcx,rdi;            //Feld1
  mov rdx,rsi;            //length
  mov r8, rdx;            //Feld2
  mov r9, rcx;            //length
  {$ENDIF}
  {$IFDEF WIN64}
  mov r12,qword ptr [Feld3];
  mov r13,qword ptr [Feld3+8];
  {$ENDIF}
  vxorpd ymm0,ymm0,ymm0;        // result = 0.0
  test rdx,rdx;                 // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;                  // length Feld1 = Feld2 = Feld3
  jne  @ende;
  cmp  rdx,r13;
  jne  @ende;
  add  rdx,1;
  vpcmpeqw xmm2,xmm2,xmm2;
  vpsrlq   xmm2,xmm2,1;         // shift 0 in sign
  vinsertf128 ymm2,ymm2,xmm2,1;
  xor  r11,r11;
align 16;
 @loop:
  vmovupd ymm1,ymmword ptr [r8+r11];       //Feld2
  vsubpd  ymm1,ymm1,ymmword ptr [r12+r11]; //Feld2-Feld3
  vmulpd  ymm1,ymm1,ymmword ptr [rcx+r11]; //Feld1 * (Feld2-Feld3)
  vandpd  ymm1,ymm1,ymm2;                  //Abs
  vmaxpd  ymm0,ymm0,ymm1;                  //Max
  add  r11,32;
  sub  rdx,1;
  jnz  @loop;

  // calculate maximum
  vextractf128 xmm1,ymm0,1;
  vmaxpd  xmm0,xmm0,xmm1;
  vshufpd xmm1,xmm1,xmm1,1
  vmaxpd  xmm0,xmm0,xmm1;

 @ende:
  vzeroupper;
  pop r13;
  pop r12;
end;


{subtract 2 array pairs}
function Sub2VYDouble (const Feld :array of T4Double;
                         out Res  :array of T2Double):Longbool;
                       assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;          //Feld
  mov rdx,rsi;
  mov r8, rdx;          //Res1
  mov r9, rcx;
 {$ENDIF}
  xor rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js  @ende;
  cmp rdx,r9;
  jne @ende;
  mov rax,1;
  add rdx,1;
  xor r11,r11;
  xor r10,r10;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr[rcx+r11];
  vhsubpd ymm0,ymm0,ymm0;
  vextractf128 xmm1,ymm0,1;
  vshufpd xmm0,xmm0,xmm1,0;
  vmovupd xmmword ptr [r8+r10],xmm0;
  add r11,32;
  add r10,16;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{subtract Feld1 by Feld2}
function SubYDouble (const Feld1,Feld2 :array of T4Double;
                     out Res :array of T4Double):Longbool;assembler;
 asm
  push r12;
  push r13;
 {$IFNDEF WIN64}
  mov r12,r8;        //Res
  mov r13,r9;        //length
  mov rcx,rdi;       //Feld1
  mov rdx,rsi;       //length
  mov r8, rdx;       //Feld2
  mov r9, rcx;       //length
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Res];
  mov r13,qword ptr [Res+8];
 {$ENDIF}
  xor rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js  @ende;
  cmp rdx,r9;
  jne @ende;
  cmp rdx,r13;
  jne @ende;
  mov rax,1;
  add rdx,1;
  xor r11,r11;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr[rcx+r11];
  vsubpd  ymm0,ymm0,ymmword ptr [r8+r11];
  vmovupd ymmword ptr [r12+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
  pop r13;
  pop r12;
end;

{Res = (Feld1-Feld2)/Value}
function SubDivValueYDouble (const Feld1,Feld2 :array of T4Double;
                     out Res :array of T4Double; constref Value :Double):Longbool;
                     assembler;
 asm
  push r12;
  push r13;
  push r14;
 {$IFNDEF WIN64}
  mov r12,r8;        //Res
  mov r13,r9;        //length
  mov rcx,rdi;       //Feld1
  mov rdx,rsi;       //length
  mov r8, rdx;       //Feld2
  mov r9, rcx;       //length
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Res];
  mov r13,qword ptr [Res+8];
 {$ENDIF}
  mov r14,qword ptr [Value];
  xor rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js  @ende;
  cmp rdx,r9;
  jne @ende;
  cmp rdx,r13;
  jne @ende;
  mov rax,1;
  add rdx,1;
  xor r11,r11;
  vmovq xmm1,[r14];
  vmovddup xmm1,xmm1;
  vinsertf128 ymm1,ymm1,xmm1,1;
  vpcmpeqw xmm0,xmm0,xmm0;
  vpsllq   xmm0,xmm0,54;
  vpsrlq   xmm0,xmm0,2;
  vinsertf128 ymm0,ymm0,xmm0,1;
  vdivpd ymm0,ymm0,ymm1;  // 1/value
align 16;
 @Loop:
  vmovupd ymm1,ymmword ptr[rcx+r11];
  vsubpd  ymm1,ymm1,ymmword ptr [r8+r11];
  vmulpd  ymm1,ymm1,ymm0;
  vmovupd ymmword ptr [r12+r11],ymm1;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
  pop r14;
  pop r13;
  pop r12;
end;

{Res = Feld1 * (Feld2 - Feld3)}
function MulDiffYDouble (const Feld1,Feld2,Feld3 :array of T4Double;
                         out Res :array of T4Double):Longbool;assembler;
asm
  push r12;
  push r13;
  push r14;
  push r15;
 {$IFNDEF WIN64}
  mov r12,r8;        //Feld3
  mov r13,r9;        //length
  mov rcx,rdi;       //Feld1
  mov rdx,rsi;       //length
  mov r8, rdx;       //Feld2
  mov r9 ,rcx;       //length
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Feld3];
  mov r13,qword ptr [Feld3+8];
 {$ENDIF}
  mov r14,qword ptr [Res];
  mov r15,qword ptr [Res+8];
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;      // all Feld length =
  jne  @ende;
  cmp  rdx,r13;
  jne  @ende;
  cmp  rdx,r15;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr[r8+r11];       //Feld2
  vsubpd  ymm0,ymm0,ymmword ptr[r12+r11]; // Feld2 - Feld3
  vmulpd  ymm0,ymm0,ymmword ptr[rcx+r11]; // Feld1 *(feld2-feld3)
  vmovupd ymmword ptr [r14+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  vzeroupper;
 @ende:
  pop  r15;
  pop  r14;
  pop  r13;
  pop  r12;
end;

{Res = Sum(Feld1 * (Feld2 - Feld3))}
function SumMulDiffYDouble (const Feld1,Feld2,Feld3 :array of T4Double;
                            out Res :Double):Longbool;assembler;
asm
  push r12;
  push r13;
  push r14;
 {$IFNDEF WIN64}
  mov r12,r8;        //Feld3
  mov r13,r9;        //length
  mov rcx,rdi;       //Feld1
  mov rdx,rsi;       //length
  mov r8, rdx;       //Feld2
  mov r9 ,rcx;       //length
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Feld3];
  mov r13,qword ptr [Feld3+8];
 {$ENDIF}
  mov r14,qword ptr [Res];
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;      // all Feld length =
  jne  @ende;
  cmp  rdx,r13;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor  r11,r11;
  vxorps ymm0,ymm0,ymm0;
align 16;
 @Loop:
  vmovupd ymm1,ymmword ptr[r8+r11];       //Feld2
  vsubpd  ymm1,ymm1,ymmword ptr[r12+r11]; //Feld2 - Feld3
  vmulpd  ymm1,ymm1,ymmword ptr[rcx+r11]; //Feld1*(Feld2-Feld)
  vaddpd  ymm0,ymm0,ymm1;                 //Sum(...)
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  vhaddpd ymm0,ymm0,ymm0;
  vextractf128 xmm1,ymm0,1;
  vaddpd  xmm0,xmm0,xmm1;
  vmovsd  qword ptr [r14],xmm0;
  vzeroupper;
 @ende:
  pop  r14;
  pop  r13;
  pop  r12;
end;


{-----------------------addition and subtracion-----------------------------}


// add and sub array cols
function AddSubYSingle (const Feld1,Feld2 :array of T8Single;
                        out Res :array of T8Single):Longbool;assembler;
 asm
  push r12;
  push r13;
 {$IFNDEF WIN64}
  mov r12,r8;   //Res
  mov r13,r9;   //length
  mov rcx,rdi;  //Feld1
  mov rdx,rsi;  //length
  mov r8, rdx;  //Feld2
  mov r9, rcx;  //length
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Res];
  mov r13,qword ptr [Res+8];
 {$ENDIF}
  xor rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js  @ende;
  cmp rdx,r9;
  jne @ende;
  cmp rdx,r9;
  jne @ende;
  cmp rdx,r13;
  jne @ende;
  mov rax,1;
  add rdx,1;
  xor r11,r11;
align 16;
 @Loop:
  // add odd-numbered from ymm0 and ymm1
  // subtract even-numbered from ymm0 and ymm1
  // save in first ymm0
  vmovups   ymm0,ymmword ptr [rcx+r11];
  vaddsubps ymm0,ymm0,ymmword ptr [r8+r11]; // add and subtract 4 single
  vmovups   ymmword ptr [r12+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
  pop r13;
  pop r12;
end;

// add or sub a const value
procedure AddSubValueYSingle (var Feld :array of T8Single;
                         constref Value :Single);assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  vbroadcastss ymm1,dword ptr [r8]; // value
  xor  r11,r11;
align 16;
 @Loop:
  // add odd-numbered in ymm0 with value
  // subtract even-numbered in ymm0 with value
  // save in first ymm0
  vmovups ymm0,ymmword ptr[rcx+r11];
  vaddsubps ymm0,ymm0,ymm1;           // add and subtract value
  vmovups ymmword ptr [rcx+r11],ymm0; // result
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

function AddSubYDouble (const Feld1,Feld2 :array of T4Double;
                         out Res :array of T4Double):Longbool;assembler;

asm
  push r12;
  push r13;
 {$IFNDEF WIN64}
  mov r12,r8;    //res
  mov r13,r9;
  mov rcx,rdi;   //feld1
  mov rdx,rsi;
  mov r8, rdx;   //feld2
  mov r9, rcx;
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12, qword ptr [Res];
  mov r13,qword ptr [res+8];
 {$ENDIF}
  xor rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js  @ende;
  cmp rdx,r9;
  jne @ende;
  cmp rdx,r13;
  jne @ende;
  mov rax,1;
  add rdx,1;
  xor r11,r11;
align 16;
 @Loop:
  // add odd-numbered from ymm0 and ymm1
  // subtract even-numbered from ymm0 and ymm1
  // save in first ymm0
  vmovupd   ymm0,ymmword ptr [rcx+r11];
  vaddsubpd ymm0,ymm0,ymmword ptr [r8+r11];
  vmovupd   ymmword ptr [r12+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
  pop r13;
  pop r12;
end;

// add or sub a const value
procedure AddSubValueYDouble(var Feld :array of T4Double;constref Value :Double);
         assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;             // value < 0 not valid
  js   @ende;
  add  rdx,1;
  vbroadcastsd ymm1,[r8];   // value
  xor r11,r11;
align 16;
 @Loop:
  // add odd-numbered in ymm0 with value
  // subtract even-numbered in ymm0 with value
  // save in first ymm0
  vmovupd ymm0,ymmword ptr[rcx+r11];
  vaddsubpd ymm0,ymm0,ymm1;           // add and subtract value
  vmovupd ymmword ptr [rcx+r11],ymm0; // result
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;



{------------------------multiply------------------------------------------}

{multiply all the array cols}
function ProductVYSingle(const Feld :array of T8Single):T8Single;
    assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;    //Result
  mov rdx,rsi;    //Feld
  mov r8, rdx;    //length
 {$ENDIF}
  vxorps ymm0,ymm0,ymm0;
  test r8,r8;                     // value < 0 not valid
  js   @ende;
  add  r8,1;
  xor  r11,r11;
  vpcmpeqw xmm0,xmm0,xmm0;
  vpslld   xmm0,xmm0,25;
  vpsrld   xmm0,xmm0,2;       // set 1.0 in xmm0
  vinsertf128 ymm0,ymm0,xmm0,1
align 16;
 @Loop:
  vmulps ymm0,ymm0,ymmword [rdx+r11];    // multiply 8 single
  add  r11,32;
  sub  r8,1;
  jnz  @Loop;

 @ende:
  vmovups ymmword ptr [rcx],ymm0;
  vzeroupper;
end;

{Multiply all array fields of the single floating point array and give
 a single result.}
function ProductYSingle (const Feld :array of T8Single):Single;
           assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vxorps xmm0,xmm0,xmm0;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  vpcmpeqw xmm0,xmm0,xmm0;
  vpslld   xmm0,xmm0,25;
  vpsrld   xmm0,xmm0,2;        // set 1.0
  vinsertf128 ymm0,ymm0,xmm0,1;
  xor  r11,r11;
align 16;
 @loop:
  vmulps ymm0,ymm0,ymmword ptr [rcx+r11];
  add r11,32;
  sub rdx,1;
  jnz @loop;

  // calculate the result
  vextractf128 xmm1,ymm0,1;
  vmulps   xmm0,xmm0,xmm1;
  vshufps  xmm1,xmm0,xmm0,10110001b;  // -> pos 2,1,4,3
  vmulps   xmm0,xmm0,xmm1;            // result valid in place 0 and 2
  vinsertps xmm1,xmm0,xmm0,10001110b   // place 2->0 in xmm0 with zero the rest
  vmulps   xmm0,xmm0,xmm1;            // result in place 0
 @ende:
  vzeroupper;
end;


{Res = Feld1 * Feld2}
function MulYSingle (const Feld1,Feld2 :array of T8Single;
                     out   Res :array of T8Single):Longbool;assembler;
 asm
  push r12;
  push r13;
 {$IFNDEF WIN64}
  mov r12,r8;        //Res
  mov r13,r9;
  mov rcx,rdi;       //Feld1
  mov rdx,rsi;
  mov r8, rdx;       //Feld2
  mov r9, rcx;
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Res];
  mov r13,qword ptr [Res+8];
 {$ENDIF}
  xor rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp rdx,r9;
  jne @ende;
  cmp rdx,r13;
  jne @ende;
  mov rax,1;
  add rdx,1;
  xor r11,r11;
align 16;
 @Loop:
  vmovups ymm0,ymmword [rcx+r11]
  vmulps  ymm0,ymm0,ymmword [r8+r11];
  vmovups ymmword [r12+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
  pop r13;
  pop r12;
end;

{multiply 2 or 4 arrays pairs (x1,y1,x2,y2,...x4,y4;
 unused arry must set to 1.0 not zero!}
function Mul4VYSingle (const Feld :array of T8Single;
                       out   Res  :array of T4Single):Longbool;
                       assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  xor rax,rax;   //false
  test rdx,rdx;                     // value < 0 not valid
  js  @ende;
  cmp rdx,r9;
  jne @ende;
  mov rax,1;     //true
  add rdx,1;
  xor r11,r11;
  xor r10,r10;
align 16;
 @Loop:
  vmovups ymm0,ymmword [rcx+r11]     //Feld
  vmovups ymm1,ymm0;
  vshufps ymm0,ymm0,ymm1,10110001b;  // -> pos 2,1,4,3,6,5,8,7
  vmulps  ymm0,ymm0,ymm1;            // = in pos 12,34,56,78
  vextractf128 xmm2,ymm0,1;
  vshufps xmm0,xmm0,xmm2,10001000b;  // -> pos 1,3,5,7 valid result
  vmovups xmmword ptr [r8+r10],xmm0;
  add r11,32;
  add r10,16;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{multiply 2,3,4,..8 arrays; unused arry must set to 1.0 not zero!
 horizontal multiply}
function MulVYSingle (const Feld :array of T8Single;
                      out Res :array of Single):Longbool;assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;    //Feld
  mov rdx,rsi;    //length
  mov r8, rdx;    //Res
  mov r9, rcx;    //length
 {$ENDIF}
  xor rax,rax;   //false
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp rdx,r9;
  jne @ende;
  mov rax,1;     //true
  add rdx,1;
  xor r10,r10;
  xor r11,r11;
align 16;
 @Loop:
  vmovups ymm0,ymmword [rcx+r11]      //Feld
  vmovaps ymm1,ymm0;
  vshufps ymm0,ymm0,ymm1,10110001b;   // -> pos 2,1,4,3,6,5,8,7
  vmulps  ymm0,ymm0,ymm1;             // = in pos 12,34,56,78
  vextractf128 xmm1,ymm0,1;
  vmulps  xmm0,xmm0,xmm1;             // pos 2*6,1*5,4*8,3*7
  vinsertps xmm1,xmm0,xmm0,10001110b; // pos 3->1
  vmulps  xmm0,xmm0,xmm1;
  vmovss  dword ptr [r8+r10],xmm0;
  add r11,32;
  add r10,4;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

// multiply all array fields with a const value
procedure MulValueYSingle(var Feld :array of T8Single;constref Value :Single);
         assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  mov  rax,[r8];
  vbroadcastss ymm1,dword ptr[r8];  // load constant factor on all places
  xor r11,r11;
align 16;
 @Loop:
  vmulps  ymm0,ymm1,ymmword ptr [rcx+r11]; // multiply 8 single
  vmovups ymmword ptr [rcx+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

// multiply all array fields with a const value
function MulValueYSingle(const Feld :array of T8Single;out Res :array of T8Single;
                           constref Value :Single):Longbool;assembler;
 asm
  push r12;
 {$IFNDEF WIN64}
  mov r12,r8;   //Value
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //Res
  mov r9, rcx;  //length
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Value];
 {$ENDIF}
  xor rax,rax;      //false
  test rdx,rdx;                     // value < 0 not valid
  js  @ende;
  cmp rdx,r9;
  jne @ende;
  mov rax,1;
  add rdx,1;
  vbroadcastss ymm1,dword ptr[r12];  // load constant factor on all places
  xor r11,r11;
align 16;
 @Loop:
  vmulps  ymm0,ymm1,ymmword ptr [rcx+r11]; // multiply 8 single
  vmovups ymmword ptr [r8+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
  pop r12;
end;


{Res = (Feld1 * Feld2) + Feld3; adapted for FMADD }
function FMulAddYSingle (const Feld1,Feld2,Feld3 :array of T8Single;
                         out Res :array of T8Single):Longbool;assembler;
 asm
  push r12;
  push r13;
  push r14;
  push r15;
  {$IFNDEF WIN64}
  mov r12,r8;             //Feld3
  mov r13,r9;             //lenght
  mov rcx,rdi;            //Feld1
  mov rdx,rsi;            //length
  mov r8, rdx;            //Feld2
  mov r9, rcx;            //length
  {$ENDIF}
  {$IFDEF WIN64}
  mov r12,qword ptr [Feld3];
  mov r13,qword ptr [Feld3+8];
  {$ENDIF}
  mov r14,qword ptr [Res];
  mov r15,qword ptr [Res+8];
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;              // lenght Feld1 = Feld2 = Feld3 = Res
  jne  @ende;
  cmp  rdx,r13;
  jne  @ende;
  cmp  rdx,r15;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor r11,r11;
align 16;
 @loop:
  vmovups ymm0,ymmword ptr [rcx+r11];       //Feld1
  vmulps  ymm0,ymm0,ymmword ptr [r8+r11];   //Feld1 * Feld2
  vaddps  ymm0,ymm0,ymmword ptr [r12+r11];  //Feld1 + Feld3
  vmovups ymmword ptr [r14+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @loop;
  vzeroupper;
 @ende:
  pop r15;
  pop r14;
  pop r13;
  pop r12;
end;

{Result = (Feld1 * Feld2) + Feld3; Result in Feld1}
function FMulAddYSingle (var Feld1 :array of T8Single;
                         const Feld2,Feld3 :array of T8Single):Longbool;assembler;
 asm
  push r12;
  push r13;
  {$IFNDEF WIN64}
  mov r12,r8;             //Feld3
  mov r13,r9;             //lenght
  mov rcx,rdi;            //Feld1
  mov rdx,rsi;            //length
  mov r8, rdx;            //Feld2
  mov r9, rcx;            //length
  {$ENDIF}
  {$IFDEF WIN64}
  mov r12,qword ptr [Feld3];
  mov r13,qword ptr [Feld3+8];
  {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;              // lenght Feld1 = Feld2 = Feld3
  jne  @ende;
  cmp  rdx,r13;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor r11,r11;
align 16;
 @loop:
  vmovups ymm0,ymmword ptr [rcx+r11];       //Feld1
  vmulps  ymm0,ymm0,ymmword ptr [r8+r11];   //Feld1 * Feld2
  vaddps  ymm0,ymm0,ymmword ptr [r12+r11];  //Feld1 + Feld3
  vmovups ymmword ptr [rcx+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @loop;
  vzeroupper;
 @ende:
  pop r13;
  pop r12;
end;


{Res = (Feld1 * Feld2) - Feld3; adapted for FMSUB}
function FMulSubYSingle (const Feld1,Feld2,Feld3 :array of T8Single;
                         out Res :array of T8Single):Longbool;assembler;
 asm
  push r12;
  push r13;
  push r14;
  push r15;
  {$IFNDEF WIN64}
  mov r12,r8;             //Feld3
  mov r13,r9;             //lenght
  mov rcx,rdi;            //Feld1
  mov rdx,rsi;            //length
  mov r8, rdx;            //Feld2
  mov r9, rcx;            //length
  {$ENDIF}
  {$IFDEF WIN64}
  mov r12,qword ptr [Feld3];
  mov r13,qword ptr [Feld3+8];
  {$ENDIF}
  mov r14,qword ptr [Res];
  mov r15,qword ptr [Res+8];
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;              // lenght Feld1 = Feld2 = Feld3 = Res
  jne  @ende;
  cmp  rdx,r13;
  jne  @ende;
  cmp  rdx,r15;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor r11,r11;
align 16;
 @loop:
  vmovups ymm0,ymmword ptr [rcx+r11];       //Feld1
  vmulps  ymm0,ymm0,ymmword ptr [r8+r11];   //Feld1 * Feld2
  vsubps  ymm0,ymm0,ymmword ptr [r12+r11];  //Feld1 - Feld3
  vmovups ymmword ptr [r14+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @loop;
  vzeroupper;
 @ende:
  pop r15;
  pop r14;
  pop r13;
  pop r12;
end;

{Result = (Feld1 * Feld2) - Feld3; Result in Feld1}
function FMulSubYSingle (var Feld1 :array of T8Single;
                         const Feld2,Feld3 :array of T8Single):Longbool;assembler;
 asm
  push r12;
  push r13;
  {$IFNDEF WIN64}
  mov r12,r8;             //Feld3
  mov r13,r9;             //lenght
  mov rcx,rdi;            //Feld1
  mov rdx,rsi;            //length
  mov r8, rdx;            //Feld2
  mov r9, rcx;            //length
  {$ENDIF}
  {$IFDEF WIN64}
  mov r12,qword ptr [Feld3];
  mov r13,qword ptr [Feld3+8];
  {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;              // lenght Feld1 = Feld2 = Feld3
  jne  @ende;
  cmp  rdx,r13;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor r11,r11;
align 16;
 @loop:
  vmovups ymm0,ymmword ptr [rcx+r11];       //Feld1
  vmulps  ymm0,ymm0,ymmword ptr [r8+r11];   //Feld1 * Feld2
  vsubps  ymm0,ymm0,ymmword ptr [r12+r11];  //Res - Feld3
  vmovups ymmword ptr [rcx+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @loop;
  vzeroupper;
 @ende:
  pop r13;
  pop r12;
end;


// product of the array cols
function ProductVYDouble (const Feld :array of T4Double):T4Double;
   assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vxorpd  ymm0,ymm0,ymm0;
  test r8,r8;                     // value < 0 not valid
  js   @ende;
  add  r8,1;
  vpcmpeqw xmm0,xmm0,xmm0;
  vpsllq   xmm0,xmm0,54;
  vpsrlq   xmm0,xmm0,2;       // set 1.0
  vinsertf128 ymm0,ymm0,xmm0,1
  xor r11,r11;
align 16;
 @Loop:
  vmulpd ymm0,ymm0,ymmword ptr [rdx+r11];
  add r11,32;
  sub r8,1;
  jnz @Loop;
  vmovupd ymmword ptr [rcx],ymm0;
 @ende:
  vzeroupper;
end;

{product all the array fields}
function ProductYDouble (const Feld :array of T4Double):Double;
   assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vxorpd xmm0,xmm0,xmm0;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  vpcmpeqw xmm0,xmm0,xmm0;
  vpsllq   xmm0,xmm0,54;
  vpsrlq   xmm0,xmm0,2;       // set 1.0
  vinsertf128 ymm0,ymm0,xmm0,1
  xor r11,r11;
align 16;
 @Loop:
  vmulpd ymm0,ymm0,ymmword ptr [rcx+r11];
  add r11,32;
  sub rdx,1;
  jnz @Loop;

  vextractf128 xmm1,ymm0,1;
  vmulpd  xmm0,xmm0,xmm1;
  vshufpd xmm0,xmm0,xmm0,00000001b;
  vmulpd  xmm0,xmm0,xmm1;              // result in pos 0
 @ende:
  vzeroupper;
end;

{multiply 2,3 or 4 arrays; unused array set to 1.0
 horizontal multiply}
function MulVYDouble (const Feld :array of T4Double;
                      out Res :array of Double):Longbool;assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;     //feld
  mov rdx,rsi;     //length
  mov r8, rdx;     //Res
  mov r9, rcx;     //length
 {$ENDIF}
  xor rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js  @ende;
  cmp rdx,r9;
  jne @ende;
  mov rax,1;
  add rdx,1;
  xor r10,r10;
  xor r11,r11;
align 16;
 @Loop:
  vmovupd ymm0,ymmword [rcx+r11];
  vmovapd ymm1,ymm0;
  vshufpd ymm0,ymm0,ymm1,00000101b;
  vmulpd  ymm0,ymm0,ymm1;
  vextractf128 xmm1,ymm0,1;
  vmulpd  xmm0,xmm0,xmm1;
  vmovsd  qword ptr [r8+r10],xmm0;
  add r11,32;
  add r10,8;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{multiply 2 array pairs}
function Mul2VYDouble (const Feld :array of T4Double;
                       out Res :array of T2Double):Longbool;
                       assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  mov  rax,1;
  jne  @ende;
  add  rdx,1;
  xor  r10,r10;
  xor  r11,r11;
align 16;
 @Loop:
  vmovupd ymm0,ymmword [rcx+r11];
  vmovapd ymm1,ymm0;
  vshufpd ymm0,ymm0,ymm1,00000101b;    // pos 2,1,4,3
  vmulpd  ymm0,ymm0,ymm1;
  vextractf128 xmm1,ymm0,1;
  vshufpd xmm0,xmm0,xmm1,00000001b;    // pos 1,3
  vmovupd xmmword ptr [r8+r10],xmm0;
  add r11,32;
  add r10,16;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{Res = Feld1 * Feld2}
function MulYDouble (const Feld1,Feld2 :array of T4Double;
                     out Res :array of T4Double):Longbool;assembler;
 asm
  push r12;
  push r13;
 {$IFNDEF WIN64}
  mov r12,r8;      //Res
  mov r13,r9;      //Length
  mov rcx,rdi;     //Feld1
  mov rdx,rsi;     //length
  mov r8, rdx;     //Feld2
  mov r9, rcx;     //length
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Res];
  mov r13,qword ptr [Res+8];
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  cmp  rdx,r13;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor r11,r11;
align 16;
 @Loop:
  vmovupd ymm0,ymmword [rcx+r11];
  vmulpd  ymm0,ymm0,ymmword [r8+r11];
  vmovupd ymmword ptr [r12+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
  pop r13;
  pop r12;
end;

// multiply all array fields with a const value
procedure MulValueYDouble(var Feld :array of T4Double;
                         constref Value :Double);assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  vbroadcastsd ymm1,[r8];           // load value in all places
  xor r11,r11;
align 16;
 @Loop:
  vmulpd  ymm0,ymm1,ymmword ptr [rcx+r11];  // multiply 4 doble
  vmovupd ymmword ptr [rcx+r11],ymm0;       // result in Feld
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{Res = Feld * Value for all array fields}
function MulValueYDouble(const Feld :array of T4Double;out Res :array of T4Double;
                          constref Value :Double):Longbool;assembler;
 asm
  push r12;
 {$IFNDEF WIN64}
  mov r12,r8;     //value
  mov rcx,rdi;    //Feld
  mov rdx,rsi;    //length
  mov r8, rdx;    //Res
  mov r9, rcx;    //length
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Value];
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  mov  rax,1;
  jne  @ende;
  add  rdx,1;
  vbroadcastsd ymm1, [r12];
  xor r11,r11;
align 16;
 @Loop:
  vmulpd  ymm0,ymm1,ymmword ptr [rcx+r11];  // multiply with value
  vmovupd ymmword ptr [r8+r11],ymm0;        // result
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
  pop r12;
end;

{Res = (Feld1 * Feld2) + Feld3}
function FMulAddYDouble (const Feld1,Feld2,Feld3 :array of T4Double;
                     out Res :array of T4Double):Longbool;assembler;
 asm
  push r12;
  push r13;
  push r14;
  push r15;
 {$IFNDEF WIN64}
  mov r12,r8;             //Feld3
  mov r13,r9;             //lenght
  mov rcx,rdi;            //Feld1
  mov rdx,rsi;            //
  mov r8, rdx;            //Feld2
  mov r9, rcx;
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Feld3];
  mov r13,qword ptr [Feld3+8];
 {$ENDIF}
  mov r14,qword ptr [Res];
  mov r15,qword ptr [Res+8];
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;            // lenght Feld1 = Feld2 = Res
  jne  @ende;
  cmp  rdx,r13;
  jne  @ende;
  cmp  rdx,r15;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor r11,r11;
align 16;
 @loop:
  vmovupd ymm0,ymmword ptr [rcx+r11];      //Feld1
  vmulpd  ymm0,ymm0,ymmword ptr [r8+r11];  // Feld1 * Feld2
  vaddpd  ymm0,ymm0,ymmword ptr [r12+r11]; // Feld1*Feld2+Feld3
  vmovupd ymmword ptr [r14+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @loop;
  vzeroupper;
 @ende:
  pop r15;
  pop r14;
  pop r13;
  pop r12;
end;

{Feld1 = (Feld1 * Feld2) + Feld3}
function FMulAddYDouble (var Feld1 :array of T4Double;
                         const Feld2,Feld3 :array of T4Double):Longbool;assembler;
 asm
  push r12;
  push r13;
 {$IFNDEF WIN64}
  mov r12,r8;             //Feld3
  mov r13,r9;             //lenght
  mov rcx,rdi;            //Feld1
  mov rdx,rsi;            //
  mov r8, rdx;            //Feld2
  mov r9, rcx;
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Feld3];
  mov r13,qword ptr [Feld3+8];
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;            // lenght Feld1 = Feld2 = Feld3
  jne  @ende;
  cmp  rdx,r13;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor r11,r11;
align 16;
 @loop:
  vmovupd ymm0,ymmword ptr [rcx+r11];      // Feld1
  vmulpd  ymm0,ymm0,ymmword ptr [r8+r11];  // Feld1 * Feld2
  vaddpd  ymm0,ymm0,ymmword ptr [r12+r11]; // Feld1*Feld2+Feld3
  vmovupd ymmword ptr [rcx+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @loop;
  vzeroupper;
 @ende:
  pop r13;
  pop r12;
end;

{Res = (Feld1 * Feld2) - Feld3}
function FMulSubYDouble (const Feld1,Feld2,Feld3 :array of T4Double;
                     out Res :array of T4Double):Longbool;assembler;
 asm
  push r12;
  push r13;
  push r14;
  push r15;
 {$IFNDEF WIN64}
  mov r12,r8;             //Feld3
  mov r13,r9;             //lenght
  mov rcx,rdi;            //Feld1
  mov rdx,rsi;            //
  mov r8, rdx;            //Feld2
  mov r9, rcx;
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Feld3];
  mov r13,qword ptr [Feld3+8];
 {$ENDIF}
  mov r14,qword ptr [Res];
  mov r15,qword ptr [Res+8];
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;            // lenght Feld1 = Feld2 = Res
  jne  @ende;
  cmp  rdx,r13;
  jne  @ende;
  cmp  rdx,r15;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @loop:
  vmovupd ymm0,ymmword ptr [rcx+r11];      // Feld1
  vmulpd  ymm0,ymm0,ymmword ptr [r8+r11];  // Feld1 * Feld2
  vsubpd  ymm0,ymm0,ymmword ptr [r12+r11]; // Feld1*Feld2 - Feld3
  vmovupd ymmword ptr [r14+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @loop;
  vzeroupper;
 @ende:
  pop r15;
  pop r14;
  pop r13;
  pop r12;
end;

{Feld1 = (Feld1 * Feld2) - Feld3}
function FMulSubYDouble (var Feld1 :array of T4Double;
                         const Feld2,Feld3 :array of T4Double):Longbool;assembler;
 asm
  push r12;
  push r13;
 {$IFNDEF WIN64}
  mov r12,r8;             //Feld3
  mov r13,r9;             //lenght
  mov rcx,rdi;            //Feld1
  mov rdx,rsi;            //
  mov r8, rdx;            //Feld2
  mov r9, rcx;
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Feld3];
  mov r13,qword ptr [Feld3+8];
 {$ENDIF}
  xor rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;            // lenght Feld1 = Feld2 = Feld3
  jne  @ende;
  cmp  rdx,r13;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor r11,r11;
align 16;
 @loop:
  vmovupd ymm0,ymmword ptr [rcx+r11];      // Feld1
  vmulpd  ymm0,ymm0,ymmword ptr [r8+r11];  // Feld1 * Feld2
  vsubpd  ymm0,ymm0,ymmword ptr [r12+r11]; // Feld1*Feld2 - Feld3
  vmovupd ymmword ptr [rcx+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @loop;
  vzeroupper;
 @ende:
  pop r13;
  pop r12;
end;


{-------------------------division----------------------------------------}

{Res = Feld1 / Feld2}
function DivYSingle (const Feld1,Feld2 :array of T8Single;
                      out  Res :array of T8Single):Longbool;assembler;

 asm
  push r12;
  push r13;
 {$IFNDEF WIN64}
  mov r12,r8;
  mov r13,r9,
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8,rdx;
  mov r9,rcx;
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Res];
  mov r13,qword ptr [Res+8];
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  cmp  rdx,r13;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[rcx+r11];
  vdivps  ymm0,ymm0,ymmword ptr [r8+r11];
  vmovups ymmword ptr [r12+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  vzeroupper;
 @ende:
  pop r13;
  pop r12;
end;

{Res(1,2,3,4) = Feld(pos1/pos2) and Feld(pos3/pos4) and ...
                Feld(pos7/pos8)
                div 3 or 4 array pairs; set unused arrys to 1.0!}
function Div4VYSingle (const Feld :array of T8Single;
                         out Res  :array of T4Single):Longbool;assembler;
                      nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;   //Feld
  mov rdx,rsi;   //length
  mov r8, rdx;   //Res
  mov r9, rcx;   //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor  r10,r10;
  xor  r11,r11;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[rcx+r11];    //Feld
  vmovaps ymm1,ymm0;
  vshufps ymm1,ymm0,ymm0,10110001b;     // -> pos 2,1,3,4,6,5,8,7
  vdivps  ymm0,ymm0,ymm1;               // in pos 1,3,5,7 valid result
  vextractf128 xmm1,ymm0,1;
  vshufps xmm0,xmm0,xmm1,10001000b;     // pos 1,2,3,4
  vmovups xmmword ptr [r8+r10],xmm0;
  add  r11,32;
  add  r10,16;
  sub  rdx,1;
  jnz  @Loop;
  vzeroupper;
 @ende:
end;

{Res = Feld1 / Feld2}
function DivYDouble (const Feld1,Feld2 :array of T4Double;
                      out Res :array of T4Double):Longbool;assembler;
 asm
  push r12;
  push r13;
 {$IFNDEF WIN64}
  mov r12,r8;
  mov r13,r9;
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Res];
  mov r13,qword ptr [Res+8];
 {$ENDIF}
  xor  rax,rax;        // false
  test rdx,rdx;        // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;         // feld1 = feld2 = res
  jne  @ende;
  cmp  rdx,r13;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr [rcx+r11];     // Feld1
  vdivpd  ymm0,ymm0,ymmword ptr [r8+r11]; // Feld1 / Feld2
  vmovupd ymmword ptr [r12+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  vzeroupper;
 @ende:
  pop r13;
  pop r12;
end;

{Res(1,2) = Feld(pos1/pos2) and Feld(pos3/pos4)}
function Div2VYDouble (const Feld :array of T4Double;
                       out Res :array of T2Double):Longbool;assembler;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;       //Feld
  mov rdx,rsi;
  mov r8, rdx;       //Res1
  mov r9, rcx;
 {$ENDIF}
  xor  rax,rax;       // false
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;        // feld = res
  jne  @ende;
  mov  rax,1;         // true
  add  rdx,1;
  xor  r10,r10;
  xor  r11,r11;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr [rcx+r11]; //Feld
  vmovapd ymm1,ymm0;
  vshufpd ymm1,ymm1,ymm0,00000101b;   // -> pos 2,1,4,3
  vdivpd  ymm0,ymm0,ymm1;             // pos1 = pos1/pos2 and pos3 = pos3/pos4
  vextractf128 xmm1,ymm0,1;           // load pos 3 and 4
  vshufpd xmm0,xmm0,xmm1,0;           // Res in = pos1 and pos2
  vmovupd xmmword ptr [r8+r10],xmm0;
  add r11,32;
  add r10,16;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{--------------------------functions--------------------------------------}

{Feld = Feld * Feld}
procedure SQRYSingle (var Feld :array of T8Single);assembler; nostackframe;

asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[rcx+r11];
  vmulps  ymm0,ymm0,ymm0;
  vmovups ymmword ptr[rcx+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{Res = Feld * Feld}
function SQRYSingle (const Feld :array of T8Single;
                     out Res :array of T8Single):Longbool;
                    assembler; nostackframe;
asm
 {$IFNDEF WIN64}
  mov rcx,rdi;    //Feld
  mov rdx,rsi;
  mov r8, rdx;    //Res
  mov r9, rcx;
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[rcx+r11];
  vmulps  ymm0,ymm0,ymm0;
  vmovups ymmword ptr[r8+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{Res = (Feld1 * (Feld2 - Feld3))^2}
function SQRMulDiffYSingle (const Feld1,Feld2,Feld3 :array of T8Single;
                             out Res :array of T8Single):Longbool;assembler;

asm
  push r12;
  push r13;
  push r14;
  push r15;
 {$IFNDEF WIN64}
  mov r12,r8;  //Feld3
  mov r13,r9   //length
  mov rcx,rdi; //Feld1
  mov rdx,rsi; //length
  mov r8, rdx; //Feld2
  mov r9  rcx; //length
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Feld3];
  mov r13,qword ptr [Feld3+8];
 {$ENDIF}
  mov r14,qword ptr [Res];
  mov r15,qword ptr [Res+8];
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;      // compare array length must are equal!
  jne  @ende;
  cmp  rdx,r13;
  jne  @ende;
  cmp  rdx,r15;
  jne  @ende;
  mov  rax,1;      //true
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovups ymm1,ymmword ptr[r8+r11];        // Feld2
  vsubps  ymm1,ymm1,ymmword ptr[r12+r11];  // Temp = Feld2 - Feld3
  vmulps  ymm1,ymm1,ymmword ptr[rcx+r11];  // Feld1 * Temp
  vmulps  ymm0,ymm1,ymm1;                  // Temp * Temp
  vmovups ymmword ptr[r14+r11],ymm0;       // SQR(Feld1*(Feld2-Feld3)
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
  pop r15;
  pop r14;
  pop r13;
  pop r12;
end;

{Res = (Sum(1,n)(Feld1 * (Feld2 - Feld3))^2)}
function SumSQRMulDiffYSingle (const Feld1,Feld2,Feld3 :array of T8Single):Single;
                               assembler;
asm
  push r12;
  push r13;
 {$IFNDEF WIN64}
  mov r12,r8;  //Feld3
  mov r13,r9   //length
  mov rcx,rdi; //Feld1
  mov rdx,rsi; //length
  mov r8, rdx; //Feld2
  mov r9  rcx; //length
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Feld3];
  mov r13,qword ptr [Feld3+8];
 {$ENDIF}
  vxorps xmm0,xmm0,xmm0;
  test rdx,rdx;                     // value < 0 not valid
  js  @ende;
  cmp rdx,r9;      // compare array length must are equal!
  jne @ende;
  cmp rdx,r13;
  jne @ende;
  add rdx,1;
  vxorps ymm0,ymm0,ymm0;
  xor r11,r11;
align 16;
 @Loop:
  vmovups ymm1,ymmword ptr[r8+r11];   // Feld2
  vsubps  ymm1,ymm1,ymmword ptr[r12+r11]; // Feld2 -Feld3
  vmulps  ymm1,ymm1,ymmword ptr[rcx+r11]; // Feld1 * (Feld2 - Feld3)
  vmulps  ymm1,ymm1,ymm1;                 // (Feld1 * (Feld2 - Feld3))^2
  vaddps  ymm0,ymm0,ymm1;                 // Sum(SQR(Feld1*(Feld2-Feld3))
  add r11,32;
  sub rdx,1;
  jnz @Loop;

  vhaddps ymm0,ymm0,ymm0;
  vhaddps ymm0,ymm0,ymm0;
  vextractf128 xmm1,ymm0,1;
  vaddps  xmm0,xmm0,xmm1;
 @ende:
  vzeroupper;
  pop r13;
  pop r12;
end;

{Res = (Sum(1,n)(Feld * Feld))}
function SumSQRYSingle (const Feld :array of T8Single):Single;
                         assembler; nostackframe;
asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vxorps xmm0,xmm0,xmm0;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  xor  r11,r11;
  vxorps ymm0,ymm0,ymm0;
align 16;
 @Loop:
  vmovups ymm1,ymmword ptr[rcx+r11];
  vmulps  ymm1,ymm1,ymm1;
  vaddps  ymm0,ymm0,ymm1;
  add r11,32;
  sub rdx,1;
  jnz @Loop;

  vhaddps ymm0,ymm0,ymm0;
  vhaddps ymm0,ymm0,ymm0;
  vextractf128 xmm1,ymm0,1;
  vaddps  xmm0,xmm0,xmm1;
 @ende:
  vzeroupper;
end;

{Result = (Sum(1,n)(Feld * Feld)) sum of the array cols}
function SumSQRVYSingle (const Feld :array of T8Single):T8Single;
                         assembler; nostackframe;
asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vxorps ymm0,ymm0,ymm0;
  test r8,r8;                     // value < 0 not valid
  js   @ende;
  add  r8,1;
  xor  r11,r11;
  vxorps ymm0,ymm0,ymm0;
align 16;
 @Loop:
  vmovups ymm1,ymmword ptr[rdx+r11];
  vmulps  ymm1,ymm1,ymm1;
  vaddps  ymm0,ymm0,ymm1;
  add r11,32;
  sub r8,1;
  jnz @Loop;

  vmovups ymmword ptr[rcx],ymm0;
  vzeroupper;
 @ende:
end;

{Feld = Feld* Feld}
procedure SQRYDouble (var Feld :array of T4Double);assembler; nostackframe;

asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovupd ymm1,ymmword ptr[rcx+r11];
  vmulpd  ymm0,ymm1,ymm1;
  vmovupd ymmword ptr[rcx+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{Res = (Feld * Feld)}
function SQRYDouble (const Feld :array of T4Double;
                     out Res :array of T4Double):Longbool;assembler; nostackframe;

asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr[rcx+r11];
  vmulpd  ymm0,ymm0,ymm0;
  vmovupd ymmword ptr[r8+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{Res = (Feld1 * (Feld2 - Feld3))^2}
function SQRMulDiffYDouble (const Feld1,Feld2,Feld3 :array of T4Double;
                              out Res :array of T4Double):Longbool;assembler;
asm
  push r12;
  push r13;
  push r14;
  push r15;
 {$IFNDEF WIN64}
  mov r12,r8;  //Feld3
  mov r13,r9   //length
  mov rcx,rdi; //Feld1
  mov rdx,rsi; //length
  mov r8, rdx; //Feld2
  mov r9  rcx; //length
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Feld3];
  mov r13,qword ptr [Feld3+8];
 {$ENDIF}
  mov r14,qword ptr [Res];
  mov r15,qword ptr [Res+8];
  xor rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js  @ende;
  cmp rdx,r9;      // compare array length must are equal!
  jne @ende;
  cmp rdx,r13;
  jne @ende;
  cmp rdx,r15;
  jne @ende;
  mov rax,1;      //true
  add rdx,1;
  xor r11,r11;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr[rcx+r11];  // Feld1
  vmovupd ymm1,ymmword ptr[r8+r11];   // Feld2
  vmovupd ymm2,ymmword ptr[r12+r11];  // Feld3
  vsubpd  ymm1,ymm1,ymm2;             // Feld2 - Feld3
  vmulpd  ymm0,ymm0,ymm1;             // Feld1 * Temp
  vmulpd  ymm0,ymm0,ymm0;             // Temp*Temp
  vmovupd ymmword ptr[r14+r11],ymm0;  // SQR(Feld1*(Feld2-Feld3)
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
  pop r15;
  pop r14;
  pop r13;
  pop r12;
end;

{Res = (Sum(1,n)(Feld1 * (Feld2 - Feld3))^2)}
function SumSQRMulDiffYDouble (const Feld1,Feld2,Feld3 :array of T4Double):Double;
                               assembler;
asm
  push r12;
  push r13;
 {$IFNDEF WIN64}
  mov r12,r8;  //Feld3
  mov r13,r9   //length
  mov rcx,rdi; //Feld1
  mov rdx,rsi; //length
  mov r8, rdx; //Feld2
  mov r9  rcx; //length
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Feld3];
  mov r13,qword ptr [Feld3+8];
 {$ENDIF}
  vxorpd xmm0,xmm0,xmm0;
  test rdx,rdx;                     // value < 0 not valid
  js  @ende;
  cmp rdx,r9;      // compare array length must are equal!
  jne @ende;
  cmp rdx,r13;
  jne @ende;
  add rdx,1;
  vxorps ymm0,ymm0,ymm0;
  xor r11,r11;
align 16;
 @Loop:
  vmovupd ymm1,ymmword ptr[rcx+r11];  // Feld1
  vmovupd ymm2,ymmword ptr[r8+r11];   // Feld2
  vmovupd ymm3,ymmword ptr[r12+r11];  // Feld3
  vsubpd  ymm2,ymm2,ymm3;             // Feld2 - Feld3
  vmulpd  ymm1,ymm1,ymm2;             // Feld1 * Temp
  vmulpd  ymm1,ymm1,ymm1;             // Temp*Temp
  vaddpd  ymm0,ymm0,ymm1;             // Sum(SQR(Feld1*(Feld2-Feld3))
  add r11,32;
  sub rdx,1;
  jnz @Loop;

  vhaddpd ymm0,ymm0,ymm0;
  vextractf128 xmm1,ymm0,1;
  vaddpd xmm0,xmm0,xmm1;
 @ende:
  vzeroupper;
  pop r13;
  pop r12;
end;

{Res = (Sum(1,n)(Feld * Feld))}
function SumSQRYDouble (const Feld :array of T4Double):Double;
                       assembler; nostackframe;
asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vxorpd ymm0,ymm0,ymm0;
  test rdx,rdx;                     // value < 0 not valid
  js  @ende;
  add rdx,1;
  xor r11,r11;
align 16;
 @Loop:
  vmovupd ymm1,ymmword ptr[rcx+r11];
  vmulpd  ymm1,ymm1,ymm1;
  vaddpd  ymm0,ymm0,ymm1;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vhaddpd ymm0,ymm0,ymm0;
  vextractf128 xmm1,ymm0,1;
  vaddpd  xmm0,xmm0,xmm1;
  vzeroupper;
 @ende:
end;

{Res = (Sum(1,n)(Feld * Feld)) result of the array cols}
function SumSQRVYDouble (const Feld :array of T4Double):T4Double;
                       assembler; nostackframe;
asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vxorpd ymm0,ymm0,ymm0;
  test r8,r8;                     // value < 0 not valid
  js   @ende;
  add  r8,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovupd ymm1,ymmword ptr[rdx+r11];
  vmulpd  ymm1,ymm1,ymm1;
  vaddpd  ymm0,ymm0,ymm1;
  add r11,32;
  sub r8,1;
  jnz @Loop;

  vmovupd ymmword ptr [rcx],ymm0;
  vzeroupper;
 @ende:
end;

{Feld = Feld^3}
procedure CubicYSingle (var Feld :array of T8Single);assembler; nostackframe;

asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovups ymm1,ymmword ptr[rcx+r11];
  vmulps  ymm0,ymm1,ymm1;
  vmulps  ymm0,ymm0,ymm1;
  vmovups ymmword ptr[rcx+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{Res = (Feld^3}
function CubicYSingle (const Feld :array of T8Single;
                     out Res :array of T8Single):Longbool;
                    assembler; nostackframe;

asm
 {$IFNDEF WIN64}
  mov rcx,rdi;    //Feld
  mov rdx,rsi;
  mov r8, rdx;    //Res
  mov r9, rcx;
 {$ENDIF}
  xor rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js  @ende;
  cmp rdx,r9;
  jne @ende;
  mov rax,1;
  add rdx,1;
  xor r11,r11;
align 16;
 @Loop:
  vmovups ymm1,ymmword ptr[rcx+r11];
  vmulps  ymm0,ymm1,ymm1;
  vmulps  ymm0,ymm0,ymm1;
  vmovups ymmword ptr[r8+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{Feld = Feld^3}
procedure CubicYDouble (var Feld :array of T4Double);assembler; nostackframe;

asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovupd ymm1,ymmword ptr[rcx+r11];
  vmulpd  ymm0,ymm1,ymm1;
  vmulpd  ymm0,ymm0,ymm1;
  vmovupd ymmword ptr[rcx+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{Res = Feld^3}
function CubicYDouble (const Feld :array of T4Double;
                       out   Res  :array of T4Double):Longbool;
                       assembler; nostackframe;

asm
 {$IFNDEF WIN64}
  mov rcx,rdi;    //Feld
  mov rdx,rsi;
  mov r8, rdx;    //Res
  mov r9, rcx;
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovupd ymm1,ymmword ptr[rcx+r11];
  vmulpd  ymm0,ymm1,ymm1;
  vmulpd  ymm0,ymm0,ymm1;
  vmovupd ymmword ptr[r8+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{Feld = 1.0/Feld}
procedure RecYSingle (var Feld :array of T8Single);assembler;
         nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  xor  r11,r11;
  vpcmpeqw xmm1,xmm1,xmm1;
  vpslld   xmm1,xmm1,25;
  vpsrld   xmm1,xmm1,2;
  vinsertf128 ymm1,ymm1,xmm1,1; // set 1.0
align 16;
 @Loop:
  vdivps  ymm0,ymm1,ymmword ptr [rcx+r11];  // divide 1/ymmword
  vmovups ymmword ptr [rcx+r11],ymm0;  // result in Feld
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{Res = 1.0/Feld}
function RecYSingle (const Feld :array of T8Single;
                     out Res :array of T8Single):Longbool;assembler;
                     nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;   //Feld
  mov rdx,rsi;
  mov r8, rdx;   //Res
  mov r9, rcx;
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor  r11,r11;
  vpcmpeqw xmm1,xmm1,xmm1;
  vpslld   xmm1,xmm1,25;
  vpsrld   xmm1,xmm1,2;
  vinsertf128 ymm1,ymm1,xmm1,1; // set 1.0
align 16;
 @Loop:
  vdivps  ymm0,ymm1,ymmword ptr [rcx+r11];  // divide 1/ymmword
  vmovups ymmword ptr [r8+r11],ymm0;  // result in Feld
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

// fast reciprocial for the array cols but less accuracy
// when you have zeros you receive +-oo and the compiler give a exception!
procedure FastRecYSingle (var Feld :array of T8Single);assembler;
         nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vrcpps  ymm0,ymmword ptr [rcx+r11];  // divide 1/ymmword
  vmovups ymmword ptr [rcx+r11],ymm0;  // result in Feld
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

// fast reciprocial for the array cols but less accuracy
// when you have zeros you receive +-oo and the compiler give a exception!
function FastRecYSingle (const Feld :array of T8Single;
                           out Res  :array of T8Single):Longbool;
                        assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;    // Feld
  mov rdx,rsi;
  mov r8, rdx;    // Res
  mov r9, rcx;
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vrcpps  ymm0,ymmword ptr [rcx+r11];  // divide 1/ymmword
  vmovups ymmword ptr [r8+r11],ymm0;   // result in Res
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;


{Feld = 1.0/Feld; when in Feld zeros -> 0 in Feld}
procedure SRecYSingle (var Feld :array of T8Single);assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;               // value < 0 not valid
  js   @ende;
  add  rdx,1;
  sub  rsp,16;

  vstmxcsr dword ptr [rsp];
  mov r10d,dword ptr [rsp];
  or  r10d,$0000200;          // set bit 9 to 1 ,d.h. div 0 -> oo
  mov dword ptr [rsp+8],r10d;
  vldmxcsr dword ptr [rsp+8];

  vbroadcastf128 ymm3,xmmword ptr [rip+QNANS16];
  vbroadcastf128 ymm2,xmmword ptr [rip+_QNANS16];
  vpcmpeqw xmm5,xmm5,xmm5;
  vpslld   xmm5,xmm5,25;
  vpsrld   xmm5,xmm5,2;
  vinsertf128 ymm5,ymm5,xmm5,1;  // set 1.0
  xor  r11,r11;
align 16;
 @Loop:
  vdivps  ymm4,ymm5,ymmword ptr [rcx+r11];
  vcmpps  ymm0,ymm4,ymm3,0;      // is +oo ?
  vcmpps  ymm1,ymm4,ymm2,0;      // is -oo ?
  vorps   ymm0,ymm0,ymm1;        // add value from =/- oo
  vandnps ymm0,ymm0,ymm4;        // set oo to 0; rest ok
  vmovups ymmword ptr [rcx+r11],ymm0;  // result in Feld
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vldmxcsr dword ptr[rsp];      // set old mxcsr
  add rsp,16;
  vzeroupper;
 @ende:
end;

{Res = 1.0/Feld; when in Feld zeros -> 0 in Feld}
// secure reciprocial for the array fields
function SRecYSingle (const Feld :array of T8Single;
                      out Res :array of T8Single):Longbool;assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;
  mov r8, rdx;  //res
  mov r9, rcx;
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  sub  rsp,16;

  vstmxcsr dword ptr [rsp];
  mov  r10d,dword ptr [rsp];
  or   r10d,$0000200;          // set bit 9 to 1 ,d.h. div 0 -> +oo
  mov  dword ptr [rsp+8],r10d;
  vldmxcsr dword ptr [rsp+8];

  vbroadcastf128 ymm3,xmmword ptr [rip+QNANS16];
  vbroadcastf128 ymm2,xmmword ptr [rip+_QNANS16];
  vpcmpeqw xmm5,xmm5,xmm5;
  vpslld   xmm5,xmm5,25;
  vpsrld   xmm5,xmm5,2;
  vinsertf128 ymm5,ymm5,xmm5,1;  // set 1.0
  xor  r11,r11;
align 16;
 @Loop:
  vdivps  ymm4,ymm5,ymmword ptr [rcx+r11];
  vcmpps  ymm0,ymm4,ymm3,0;      // is +oo ?
  vcmpps  ymm1,ymm4,ymm2,0;      // is -oo ?
  vorps   ymm0,ymm0,ymm1;
  vandnps ymm0,ymm0,ymm4;        // set oo to 0; rest ok
  vmovups ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  vldmxcsr dword ptr [rsp];
  add  rsp,16;
  vzeroupper;
 @ende:
end;

{Result = (Sum(1,n)(1.0/Feld)) for the array cols}
function SumRecVYSingle (const Feld :array of T8Single):T8Single;
    assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vxorps ymm0,ymm0,ymm0;
  test r8,r8;                     // value < 0 not valid
  js   @ende;
  add  r8,1;
  vpcmpeqw xmm1,xmm1,xmm1;
  vpslld   xmm1,xmm1,25;
  vpsrld   xmm1,xmm1,2;
  vinsertf128 ymm1,ymm1,xmm1,1; // set 1.0
  xor r11,r11;
align 16;
 @Loop:
  vdivps ymm2,ymm1,ymmword ptr [rdx+r11];
  vaddps ymm0,ymm0,ymm2;
  add r11,32;
  sub r8,1;
  jnz @Loop;

  vmovups ymmword ptr[rcx],ymm0;   // sum of all places
  vzeroupper;
 @ende:
end;

{Result = (Sum(1,n)(1.0/Feld);when zeros in Feld -> 0 in Res)}
// secure reciprocal
function SumSRecVYSingle (const Feld :array of T8Single):T8Single;
         assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  // Result
  mov rdx,rsi;  // feld
  mov r8, rdx;
 {$ENDIF}
 {$IFDEF WIN64}
  sub rsp,32;
  vmovdqu ymmword ptr [rsp],ymm6;
 {$ENDIF}
  vxorps ymm0,ymm0,ymm0;
  test r8,r8;                     // value < 0 not valid
  js  @ende;
  add r8,1;
  sub rsp,16;

  vstmxcsr dword ptr [rsp];
  mov  r10d,dword ptr [rsp];
  or   r10d,$0000200;          // set bit 9 to 1 ,d.h. div 0 -> +oo
  mov  dword ptr [rsp+8],r10d;
  vldmxcsr dword ptr [rsp+8];

  vbroadcastf128 ymm3,xmmword ptr [rip+QNANS16];
  vbroadcastf128 ymm2,xmmword ptr [rip+_QNANS16];
  vpcmpeqw xmm5,xmm5,xmm5;
  vpslld   xmm5,xmm5,25;
  vpsrld   xmm5,xmm5,2;        // set 1.0
  vinsertf128 ymm5,ymm5,xmm5,1;
  xor  r11,r11;
align 16;
 @Loop:
  vdivps  ymm4,ymm5,ymmword ptr[rdx+r11];
  vcmpps  ymm1,ymm4,ymm3,0;             // +oo?
  vcmpps  ymm6,ymm4,ymm2,0;             // -oo?
  vorps   ymm1,ymm1,ymm6;
  vandnps ymm1,ymm1,ymm4;               // set oo to 0 rest ok
  vaddps  ymm0,ymm0,ymm1;
  add     r11,32;
  sub     r8,1;
  jnz     @loop;

  vldmxcsr dword ptr [rsp];
  add  rsp,16;

 @ende:
  vmovups ymmword ptr [rcx],ymm0;
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  add rsp,32;
 {$ENDIF}
  vzeroupper;
end;

{Result = (Sum(1,n)(1.0/Feld))}
function SumRecYSingle (const Feld :array of T8Single):Single;
   assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vxorps ymm0,ymm0,ymm0;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  xor  r11,r11;
  vpcmpeqw xmm1,xmm1,xmm1;
  vpslld   xmm1,xmm1,25;
  vpsrld   xmm1,xmm1,2;
  vinsertf128 ymm1,ymm1,xmm1,1; // set 1.0
align 16;
 @Loop:
  vdivps ymm2,ymm1,ymmword ptr [rcx+r11];
  vaddps ymm0,ymm0,ymm2;              // add 8 single
  add r11,32;                          // next row
  sub rdx,1;
  jnz @Loop;

  // calculate the result
  vextractf128 xmm1,ymm0,1;            // Get upper half
  vaddps  xmm0,xmm0,xmm1;              // 8 to 4 value
  vhaddps xmm0,xmm0,xmm0;
  vhaddps xmm0,xmm0,xmm0;              // result equal in all places
  vzeroupper;
 @ende:
end;

{Result = (Sum(1,n)(1.0/Feld);when zeros in Feld -> 0 in Result)}
function SumSRecYSingle (const Feld :array of T8Single):Single;
         assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  // Feld
  mov rdx,rsi;  // length
  mov r8, rdx;
 {$ENDIF}
 {$IFDEF WIN64}
  sub rsp,32;
  vmovdqu ymmword ptr [rsp],ymm6;
 {$ENDIF}
  vxorps  ymm0,ymm0,ymm0;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  sub  rsp,16;

  vstmxcsr dword ptr [rsp];
  mov  r10d,dword ptr [rsp];
  or   r10d,$0000200;          // set bit 9 to 1 ,d.h. div 0 -> +oo
  mov  dword ptr [rsp+8],r10d;
  vldmxcsr dword ptr [rsp+8];

  vbroadcastf128 ymm3,xmmword ptr [rip+QNANS16];
  vbroadcastf128 ymm2,xmmword ptr [rip+_QNANS16];
  vpcmpeqw xmm5,xmm5,xmm5;
  vpslld   xmm5,xmm5,25;
  vpsrld   xmm5,xmm5,2;        // set 1.0
  vinsertf128 ymm5,ymm5,xmm5,1;
  xor  r11,r11;
align 16;
 @Loop:
  vdivps  ymm4,ymm5,ymmword ptr[rcx+r11];
  vcmpps  ymm1,ymm4,ymm3,0;     // +oo?
  vcmpps  ymm6,ymm4,ymm2,0;     //-oo?
  vorps   ymm1,ymm1,ymm6;
  vandnps ymm1,ymm1,ymm4;       // set oo to 0, rest ok
  vaddps  ymm0,ymm0,ymm1;
  add     r11,32;
  sub     rdx,1;
  jnz     @loop;

  vldmxcsr dword ptr [rsp];    // load old mxcsr
  add  rsp,16;
  vextractf128 xmm1,ymm0,1;
  vaddps  xmm0,xmm0,xmm1;
  vhaddps xmm0,xmm0,xmm0;
  vhaddps xmm0,xmm0,xmm0;

 @ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  add rsp,32;
 {$ENDIF}
  vzeroupper;
end;


{Feld = SQRT(Feld)}
procedure SQRTYSingle (var Feld :array of T8Single);assembler;
         nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vsqrtps ymm0,ymmword ptr[rcx+r11];   // sqrt the mem and save in ymm0
  vmovups ymmword ptr [rcx+r11],ymm0;  // result in Feld
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{Res = SQRT(Feld)}
function SQRTYSingle (const Feld :array of T8Single;
                      out Res :array of T8Single):Longbool;assembler;
                      nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vsqrtps ymm0,ymmword ptr[rcx+r11];   // sqrt the mem and save in ymm0
  vmovups ymmword ptr [r8+r11],ymm0;  // result in Feld
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{Feld = (Sum(1,n(SQRT(Feld))))}
function SumSQRTYSingle (const Feld :array of T8Single):Single;
    assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vxorps ymm0,ymm0,ymm0;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vsqrtps ymm1,ymmword ptr[rcx+r11];   // sqrt the mem and save in ymm1
  vaddps  ymm0,ymm0,ymm1;
  add r11,32;
  sub rdx,1;
  jnz @Loop;

  vhaddps ymm0,ymm0,ymm0;
  vhaddps ymm0,ymm0,ymm0;
  vextractf128 xmm1,ymm0,1;
  vaddps xmm0,xmm0,xmm1;

 @ende:
  vzeroupper;
end;

{Result = (Sum(1,n)(SQRT(Feld))); for array cols}
function SumSQRTVYSingle (const Feld :array of T8Single):T8Single;
    assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vxorps ymm0,ymm0,ymm0;
  test r8,r8;                     // value < 0 not valid
  js   @ende;
  add  r8,1;
  xor  r11,r11;
align 16;
 @Loop:
  vsqrtps ymm1,ymmword ptr[rdx+r11];   // sqrt the mem and save in ymm1
  vaddps  ymm0,ymm0,ymm1;
  add r11,32;
  sub r8,1;
  jnz @Loop;

 @ende:
  vmovups ymmword ptr[rcx],ymm0;
  vzeroupper;
end;

{Feld = (1.0/SQRT(Feld))}
// Here the fast routine but lack of precision
procedure FastRecSQRTYSingle(var Feld :array of T8Single);assembler;nostackframe;

asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add rdx,1;
  xor r11,r11;
align 16;
 @Loop:
  vrsqrtps ymm0,ymmword ptr [rcx+r11];
  vmovups  ymmword ptr [rcx+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{Feld = (1.0/SQRT(Feld))}
// Here the fast routine but lack of precision
function FastRecSQRTYSingle (const Feld :array of T8Single;
                             out   Res :array of T8Single):Longbool;
                             assembler;nostackframe;
asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vrsqrtps ymm0,ymmword ptr [rcx+r11];
  vmovups  ymmword ptr [r8+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{Feld = (1.0/SQRT(Feld))}
// reciprocial for all array fields. I no use vrsqrtps it is no exact!
procedure RecSQRTYSingle(var Feld :array of T8Single);assembler;nostackframe;

asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  vpcmpeqw xmm1,xmm1,xmm1;
  vpslld   xmm1,xmm1,25;
  vpsrld   xmm1,xmm1,2;
  vinsertf128 ymm1,ymm1,xmm1,1;    // set 1.0
  add rdx,1;
  xor r11,r11;
align 16;
 @Loop:
  vsqrtps ymm0,ymmword ptr [rcx+r11];
  vdivps  ymm0,ymm1,ymm0;
  vmovups ymmword ptr [rcx+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  vzeroupper;
 @ende:
end;

{Res = (1.0/SQRT(Feld))}
// reciprocial for all array cols I no use vrsqrtps it is no exact!
function RecSQRTYSingle(const Feld :array of T8Single;
                        out Res :array of T8Single):Longbool;
                        assembler;nostackframe;
asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  vpcmpeqw xmm1,xmm1,xmm1;
  vpslld   xmm1,xmm1,25;
  vpsrld   xmm1,xmm1,2;
  vinsertf128 ymm1,ymm1,xmm1,1;    // set 1.0
  xor r11,r11;
align 16;
 @Loop:
  vsqrtps ymm0,ymmword ptr [rcx+r11];
  vdivps  ymm0,ymm1,ymm0;
  vmovups ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  vzeroupper;
 @ende:
end;

{Feld = (1.0/SQRT(Feld)); when zeros in feld -> 0 on this position}
// secure reciprocial of square root for the array fields
procedure SRecSQRTYSingle (var Feld :array of T8Single);assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
 {$IFDEF WIN64}
  sub rsp,32;
  vmovdqu ymmword ptr [rsp],ymm6;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  sub rsp,16;

  vstmxcsr dword ptr [rsp];
  mov  r10d,dword ptr [rsp];
  or   r10d,$0000200;          // set bit 9 to 1 ,d.h. div 0 -> +oo
  mov  dword ptr [rsp+8],r10d;
  vldmxcsr dword ptr [rsp+8];

  vbroadcastf128 ymm3,xmmword ptr [rip+QNANS16];
  vbroadcastf128 ymm2,xmmword ptr [rip+_QNANS16];
  //vmovups ymm3,ymmword ptr [rip+QNANS32]; //+oo
  //vmovups ymm2,ymmword ptr [rip+_QNANS32];//-oo
  vpcmpeqw xmm5,xmm5,xmm5;
  vpslld   xmm5,xmm5,25;
  vpsrld   xmm5,xmm5,2;
  vinsertf128 ymm5,ymm5,xmm5,1;  // set 1.0
  xor  r11,r11;
align 16;
 @Loop:
  vsqrtps ymm4,ymmword ptr [rcx+r11];
  vdivps  ymm1,ymm5,ymm4;        // divide 1/ymmword
  vcmpps  ymm0,ymm1,ymm3,0;      // +oo?
  vcmpps  ymm6,ymm1,ymm2,0;      // -oo?
  vorps   ymm0,ymm0,ymm6;
  vandnps ymm0,ymm0,ymm1;        // set oo to 0 rest ok
  vmovups ymmword ptr [rcx+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vldmxcsr dword ptr [rsp];
  add  rsp,16;

 @ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  add rsp,32;
 {$ENDIF}
  vzeroupper;
end;

{Res = (1.0/SQRT(Feld)); when zeros -> 0 on Res position}
// secure reciprocial of square root for the array fields
function SRecSQRTYSingle (const Feld :array of T8Single;
                          out Res :array of T8Single):Longbool;
                          assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
 {$IFDEF WIN64}
  sub rsp,32;
  vmovdqu ymmword ptr [rsp],ymm6;
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  sub  rsp,16;

  vstmxcsr dword ptr [rsp];
  mov  r10d,dword ptr [rsp];
  or   r10d,$0000200;          // set bit 9 to 1 ,d.h. div 0 -> +oo
  mov  dword ptr [rsp+8],r10d;
  vldmxcsr dword ptr [rsp+8];

  vbroadcastf128 ymm3,xmmword ptr [rip+QNANS16];
  vbroadcastf128 ymm2,xmmword ptr [rip+_QNANS16];
  //vmovups  ymm3,ymmword ptr [rip+QNANS32];  // +oo
  //vmovups  ymm2,ymmword ptr [rip+_QNANS32]; // -oo
  vpcmpeqw xmm5,xmm5,xmm5;
  vpslld   xmm5,xmm5,25;
  vpsrld   xmm5,xmm5,2;
  vinsertf128 ymm5,ymm5,xmm5,1;  // set 1.0
  xor  r11,r11;
align 16;
 @Loop:
  vsqrtps ymm4,ymmword ptr [rcx+r11];
  vdivps  ymm1,ymm5,ymm4;        // divide 1/ymmword
  vcmpps  ymm0,ymm1,ymm3,0;      // +oo?
  vcmpps  ymm6,ymm1,ymm2,0;      // -oo?
  vorps   ymm0,ymm0,ymm6;
  vandnps ymm0,ymm0,ymm1;        // set oo to 0 rest ok
  vmovups ymmword ptr [r8+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vldmxcsr dword ptr [rsp];
  add  rsp,16;

 @ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  add rsp,32;
 {$ENDIF}
  vzeroupper;
end;

{Feld = (Sum(1,n)(1.0/SQRT(Feld)))}
function SumRecSQRTYSingle (const Feld :array of T8Single):Single;
    assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vxorps ymm0,ymm0,ymm0;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  vpcmpeqw xmm1,xmm1,xmm1;
  vpslld   xmm1,xmm1,25;
  vpsrld   xmm1,xmm1,2;
  vinsertf128 ymm1,ymm1,xmm1,1;    // set 1.0
  add rdx,1;
  xor r11,r11;
align 16;
 @Loop:
  vsqrtps ymm2,ymmword ptr[rcx+r11];  // 1/ sqrt mem and save in ymm0
  vdivps  ymm2,ymm1,ymm2;
  vaddps  ymm0,ymm0,ymm2;
  add r11,32;
  sub rdx,1;
  jnz @Loop;

  vhaddps ymm0,ymm0,ymm0;
  vhaddps ymm0,ymm0,ymm0;
  vextractf128 xmm1,ymm0,1;
  vaddps  xmm0,xmm0,xmm1;
  vzeroupper;
 @ende:
end;

{Result = (Sum(1,n)(1.0/SQRT(Feld))); when zeros in Feld -> 0 in this position}
// Sum secure reciprocial of square root for the array fields
function SumSRecSQRTYSingle (const Feld :array of T8Single):Single;
                              assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  // length
  mov r8, rdx;
 {$ENDIF}
 {$IFDEF WIN64}
  sub rsp,32;
  vmovdqu ymmword ptr [rsp],ymm6;
 {$ENDIF}
  vxorps  ymm0,ymm0,ymm0;        // for sum
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  sub  rsp,16;

  vstmxcsr dword ptr [rsp];
  mov  r10d,dword ptr [rsp];
  or   r10d,$0000200;          // set bit 9 to 1 ,d.h. div 0 -> +oo
  mov  dword ptr [rsp+8],r10d;
  vldmxcsr dword ptr [rsp+8];

  vbroadcastf128 ymm3,xmmword ptr [rip+QNANS16];
  vbroadcastf128 ymm2,xmmword ptr [rip+_QNANS16];
  vpcmpeqw xmm5,xmm5,xmm5;
  vpslld   xmm5,xmm5,25;
  vpsrld   xmm5,xmm5,2;
  vinsertf128 ymm5,ymm5,xmm5,1;  // set 1.0
  xor  r11,r11;
align 16;
 @Loop:
  vsqrtps ymm4,ymmword ptr [rcx+r11];
  vdivps  ymm4,ymm5,ymm4;        // divide 1/ymmword
  vcmpps  ymm1,ymm4,ymm3,0;      // +oo?
  vcmpps  ymm6,ymm4,ymm2,0;      // -oo?
  vorps   ymm1,ymm1,ymm6;
  vandnps ymm1,ymm1,ymm4;        // set oo to 0 rest ok
  vaddps  ymm0,ymm0,ymm1;        // sum
  add r11,32;
  sub rdx,1;
  jnz @Loop;

  vldmxcsr dword ptr [rsp];
  vhaddps  ymm0,ymm0,ymm0;
  vhaddps  ymm0,ymm0,ymm0;
  vextractf128 xmm1,ymm0,1;
  vaddps   xmm0,xmm0,xmm1;
  add  rsp,16;

 @ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  add rsp,32;
 {$ENDIF}
  vzeroupper;
end;

{Result = (Sum(1,n)(1.0/SQRT(Feld))); of the array cols}
function SumRecSQRTVYSingle (const Feld :array of T8Single):T8Single;
    assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi; //result
  mov rdx,rsi; //Feld
  mov r8, rdx; //length
 {$ENDIF}
  vxorps ymm0,ymm0,ymm0;
  test r8,r8;                     // value < 0 not valid
  js   @ende;
  vpcmpeqw xmm1,xmm1,xmm1;
  vpslld   xmm1,xmm1,25;
  vpsrld   xmm1,xmm1,2;
  vinsertf128 ymm1,ymm1,xmm1,1;    // set 1.0
  add  r8,1;
  xor  r11,r11;
align 16;
 @Loop:
  vsqrtps ymm2,ymmword ptr[rdx+r11];
  vdivps  ymm2,ymm1,ymm2;
  vaddps  ymm0,ymm0,ymm2;
  add r11,32;
  sub r8,1;
  jnz @Loop;
  vmovups ymmword ptr [rcx],ymm0;
  vzeroupper;
 @ende:
end;

{Result = (Sum(1,n)(1.0/SQRT(Feld))); when zeros in Feld -> 0 in this position}
// Sum secure reciprocial of square root for the array cols
function SumSRecSQRTVYSingle (const Feld :array of T8Single):T8Single;
                              assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //result
  mov rdx,rsi;  //Feld
  mov r8, rdx;  //length
 {$ENDIF}
 {$IFDEF WIN64}
  sub rsp,32;
  vmovdqu ymmword ptr [rsp],ymm6;
 {$ENDIF}
  vxorps ymm0,ymm0,ymm0;        // for sum
  test r8,r8;                     // value < 0 not valid
  js   @ende;
  add  r8,1;
  sub  rsp,16;

  vstmxcsr dword ptr [rsp];
  mov  r10d,dword ptr [rsp];
  or   r10d,$0000200;          // set bit 9 to 1 ,d.h. div 0 -> +oo
  mov  dword ptr [rsp+8],r10d;
  vldmxcsr dword ptr [rsp+8];

  vbroadcastf128 ymm3,xmmword ptr [rip+QNANS16];
  vbroadcastf128 ymm2,xmmword ptr [rip+_QNANS16];
  vpcmpeqw xmm5,xmm5,xmm5;
  vpslld   xmm5,xmm5,25;
  vpsrld   xmm5,xmm5,2;
  vinsertf128 ymm5,ymm5,xmm5,1;  // set 1.0
  xor  r11,r11;
align 16;
 @Loop:
  vsqrtps ymm4,ymmword ptr [rdx+r11];
  vdivps  ymm4,ymm5,ymm4;        // divide 1/ymmword
  vcmpps  ymm1,ymm4,ymm3,0;      // +oo?
  vcmpps  ymm6,ymm4,ymm2,0;      // -oo?
  vorps   ymm1,ymm1,ymm6;
  vandnps ymm1,ymm1,ymm4;        // set oo to 0 rest ok
  vaddps  ymm0,ymm0,ymm1;        // sum
  add r11,32;
  sub r8,1;
  jnz @Loop;
  vldmxcsr dword ptr [rsp];      // load old mxcsr
  add  rsp,16;

 @ende:
  vmovups ymmword ptr [rcx],ymm0;
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  add rsp,32;
 {$ENDIF}
  vzeroupper;
end;


{Feld = 1.0/Feld}
procedure RecYDouble (var Feld :array of T4Double);assembler;nostackframe;

asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  xor  r11,r11;
  vpcmpeqw xmm1,xmm1,xmm1;
  vpsllq   xmm1,xmm1,54;
  vpsrlq   xmm1,xmm1,2;       // set 1.0
  vinsertf128 ymm1,ymm1,xmm1,1;
align 16;
 @Loop:
  vdivpd  ymm0,ymm1,ymmword ptr [rcx+r11];
  vmovupd ymmword ptr [rcx+r11],ymm0;  // result
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{Res = 1.0/Feld}
function RecYDouble (const Feld :array of T4Double;
                     out Res :array of T4Double):Longbool;assembler;nostackframe;
asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor  r11,r11;
  vpcmpeqw xmm1,xmm1,xmm1;
  vpsllq   xmm1,xmm1,54;
  vpsrlq   xmm1,xmm1,2;       // set 1.0
  vinsertf128 ymm1,ymm1,xmm1,1;
align 16;
 @Loop:
  vdivpd  ymm0,ymm1,ymmword ptr [rcx+r11];
  vmovupd ymmword ptr [r8+r11],ymm0;  // result
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{Feld = 1.0/Feld; when zeros in Feld -> 0 on this position}
// secure reciprocial for the array fields
procedure SRecYDouble (var Feld :array of T4Double);assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  sub  rsp,16;

  vstmxcsr dword ptr [rsp];
  mov  r10d,dword ptr [rsp];
  or   r10d,$0000200;          // set bit 9 to 1 ,d.h. div 0 -> +oo
  mov  dword ptr [rsp+8],r10d;
  vldmxcsr dword ptr [rsp+8];

  vbroadcastf128 ymm3,xmmword ptr [rip+QNAND16];
  vbroadcastf128 ymm2,xmmword ptr [rip+_QNAND16];
  vpcmpeqw xmm5,xmm5,xmm5;
  vpsllq   xmm5,xmm5,54;
  vpsrlq   xmm5,xmm5,2;
  vinsertf128 ymm5,ymm5,xmm5,1;  // set 1.0
  xor  r11,r11;
align 16;
 @Loop:
  vdivpd  ymm4,ymm5,ymmword ptr [rcx+r11];
  vcmppd  ymm0,ymm4,ymm3,0;      // +oo?
  vcmppd  ymm1,ymm4,ymm2,0;      // -oo?
  //vorpd   ymm0,ymm0,ymm1;
  DB $C5,$FD,$56,$C1;
  vandnpd ymm0,ymm0,ymm4;
  vmovupd ymmword ptr [rcx+r11],ymm0;  // result in Feld
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vldmxcsr dword ptr [rsp];
  add  rsp,16;
  vzeroupper;
 @ende:
end;

{Res = 1.0/Feld; when zeros in Feld -> 0 on this position in Res}
// secure reciprocial for the array fields
function SRecYDouble (const Feld :array of T4Double;
                      out Res :array of T4Double):Longbool;
                      assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  sub  rsp,16;

  vstmxcsr dword ptr [rsp];
  mov  r10d,dword ptr [rsp];
  or   r10d,$0000200;          // set bit 9 to 1 ,d.h. div 0 -> +oo
  mov  dword ptr [rsp+8],r10d;
  vldmxcsr dword ptr [rsp+8];

  vbroadcastf128 ymm3,xmmword ptr [rip+QNAND16];
  vbroadcastf128 ymm2,xmmword ptr [rip+_QNAND16];
  vpcmpeqw xmm5,xmm5,xmm5;
  vpsllq   xmm5,xmm5,54;
  vpsrlq   xmm5,xmm5,2;
  vinsertf128 ymm5,ymm5,xmm5,1;  // set 1.0
  xor  r11,r11;
align 16;
 @Loop:
  vdivpd  ymm4,ymm5,ymmword ptr [rcx+r11];
  vcmppd  ymm0,ymm4,ymm3,0;      // +oo?
  vcmppd  ymm1,ymm4,ymm2,0;      // -oo?
  //vorpd   ymm0,ymm0,ymm1;
  DB $C5,$FD,$56,$C1;
  vandnpd ymm0,ymm0,ymm4;        // set +oo to 0 rest ok
  vmovupd ymmword ptr [r8+r11],ymm0;
  add r11,32;
  sub rdx,1;
  vldmxcsr dword ptr [rsp];
  add  rsp, 16;
  vzeroupper;
 @ende:
end;

{Result = (Sum(1,n(1.0/Feld)))}
function SumRecYDouble (const Feld :array of T4Double):Double;
                        assembler;nostackframe;
asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vxorpd ymm0,ymm0,ymm0;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  xor  r11,r11;
  vpcmpeqw xmm1,xmm1,xmm1;
  vpsllq   xmm1,xmm1,54;
  vpsrlq   xmm1,xmm1,2;       // set 1.0
  vinsertf128 ymm1,ymm1,xmm1,1;
align 16;
 @Loop:
  vdivpd ymm2,ymm1,ymmword ptr [rcx+r11];
  vaddpd ymm0,ymm0,ymm2;
  add r11,32;
  sub rdx,1;
  jnz @Loop;

  vhaddpd ymm0,ymm0,ymm0;
  vextractf128 xmm1,ymm0,1;
  vaddpd  xmm0,xmm0,xmm1;
  vzeroupper;
 @ende:
end;

{Result = (Sum(1,n)(1.0/Feld)); when zeros in Feld ->0 on this position}
function SumSRecYDouble (const Feld :array of T4Double):Double;
         assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  // Result
  mov rdx,rsi;  // feld
  mov r8, rdx;
 {$ENDIF}
 {$IFDEF WIN64}
  sub rsp,32;
  vmovdqu ymmword ptr [rsp],ymm6;
 {$ENDIF}
  vxorpd ymm0,ymm0,ymm0;    // for sum
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  sub  rsp,16;

  vstmxcsr dword ptr [rsp];
  mov  r10d,dword ptr [rsp];
  or   r10d,$0000200;          // set bit 9 to 1 ,d.h. div 0 -> +oo
  mov  dword ptr [rsp+8],r10d;
  vldmxcsr dword ptr [rsp+8];

  vbroadcastf128 ymm3,xmmword ptr [rip+QNAND16];
  vbroadcastf128 ymm2,xmmword ptr [rip+_QNAND16];
  vpcmpeqw xmm5,xmm5,xmm5;
  vpsllq   xmm5,xmm5,54;
  vpsrlq   xmm5,xmm5,2;        // set 1.0
  vinsertf128 ymm5,ymm5,xmm5,1;
  xor  r11,r11;
align 16;
 @Loop:
  vdivpd  ymm4,ymm5,ymmword ptr[rcx+r11];
  vcmppd  ymm1,ymm4,ymm3,0;        // +oo?
  vcmppd  ymm6,ymm4,ymm2,0;        // -oo?
  //vorpd   ymm1,ymm1,ymm6;
  DB $C5,$F5,$56,$CE;
  vandnpd ymm1,ymm1,ymm4;          // set oo to 0 rest ok
  vaddpd  ymm0,ymm0,ymm1;
  add     r11,32;
  sub     rdx,1;
  jnz     @loop;

  vldmxcsr dword ptr [rsp];
  add  rsp,16;
  vextractf128 xmm1,ymm0,1;
  vaddpd  xmm0,xmm0,xmm1;
  vhaddpd xmm0,xmm0,xmm0;

 @ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  add rsp,32;
 {$ENDIF}
  vzeroupper;
end;

{Result = (Sum(1,n(1.0/Feld))) for the array cols}
function SumRecVYDouble (const Feld :array of T4Double):T4Double;
                        assembler;nostackframe;
asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vxorpd ymm0,ymm0,ymm0;
  test r8,r8;                     // value < 0 not valid
  js   @ende;
  add  r8,1;
  xor  r11,r11;
  vpcmpeqw xmm1,xmm1,xmm1;
  vpsllq   xmm1,xmm1,54;
  vpsrlq   xmm1,xmm1,2;       // set 1.0
  vinsertf128 ymm1,ymm1,xmm1,1;
align 16;
 @Loop:
  vdivpd ymm2,ymm1,ymmword ptr [rdx+r11];
  vaddpd ymm0,ymm0,ymm2;
  add r11,32;
  sub r8,1;
  jnz @Loop;

 @ende:
  vmovupd ymmword ptr [rcx],ymm0;  // result
  vzeroupper;
end;

{Result = (Sum(1,n(1.0/Feld))); when zeros in Feld -> 0 on this position}
function SumSRecVYDouble (const Feld :array of T4Double):T4Double;
         assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  // Result
  mov rdx,rsi;  // feld
  mov r8, rdx;
 {$ENDIF}
 {$IFDEF WIN64}
  sub rsp,32;
  vmovdqu ymmword ptr [rsp],ymm6;
 {$ENDIF}
  vxorpd ymm0,ymm0,ymm0;     // for sum
  test r8,r8;                     // value < 0 not valid
  js   @ende;
  add  r8,1;
  sub  rsp,16;

  vstmxcsr dword ptr [rsp];
  mov  r10d,dword ptr [rsp];
  or   r10d,$0000200;          // set bit 9 to 1 ,d.h. div 0 -> +oo
  mov  dword ptr [rsp+8],r10d;
  vldmxcsr dword ptr [rsp+8];

  vbroadcastf128 ymm3,xmmword ptr [rip+QNAND16];
  vbroadcastf128 ymm2,xmmword ptr [rip+_QNAND16];
  vpcmpeqw xmm5,xmm5,xmm5;
  vpsllq   xmm5,xmm5,54;
  vpsrlq   xmm5,xmm5,2;        // set 1.0
  vinsertf128 ymm5,ymm5,xmm5,1;
  xor  r11,r11;
align 16;
 @Loop:
  vdivpd  ymm4,ymm5,ymmword ptr[rdx+r11];
  vcmppd  ymm1,ymm4,ymm3,0;      // +oo?
  vcmppd  ymm6,ymm4,ymm2,0;      // -oo?
  //vorpd   ymm1,ymm1,ymm6;
  DB $C5,$F5,$56,$CE;
  vandnpd ymm1,ymm1,ymm4;        // set +oo to 0 rest ok
  vaddpd  ymm0,ymm0,ymm1;
  add     r11,32;
  sub     r8,1;
  jnz     @loop;

  vldmxcsr dword ptr [rsp];
  add  rsp,16;

 @ende:
  vmovupd ymmword ptr [rcx],ymm0;
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  add rsp,32;
 {$ENDIF}
  vzeroupper;
end;


{Feld = SQRT(Feld)}
procedure SQRTYDouble (var Feld :array of T4Double);assembler;nostackframe;

asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  xor r11,r11;
align 16;
 @Loop:
  vsqrtpd ymm0,ymmword ptr[rcx+r11];  // sqrt im mem and save in ymm0
  vmovupd ymmword ptr [rcx+r11],ymm0;  // result
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{Res = SQRT(Feld)}
function SQRTYDouble (const Feld :array of T4Double;
                      out Res :array of T4Double):Longbool;
                      assembler;nostackframe;
asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vsqrtpd ymm0,ymmword ptr[rcx+r11];  // sqrt im mem and save in ymm0
  vmovupd ymmword ptr [r8+r11],ymm0;  // result
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{Result = (Sum(1,n)(SQRT(Feld)))}
function SumSQRTYDouble (const Feld :array of T4Double):Double;
    assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vxorpd ymm0,ymm0,ymm0;
  test rdx,rdx;                     // value < 0 not valid
  js  @ende;
  add rdx,1;
  xor r11,r11;
align 16;
 @Loop:
  vsqrtpd ymm1,ymmword ptr[rcx+r11]; // sqrt im mem and save in ymm0
  vaddpd  ymm0,ymm0,ymm1;
  add r11,32;
  sub rdx,1;
  jnz @Loop;

  vhaddpd ymm0,ymm0,ymm0;
  vextractf128 xmm1,ymm0,1;
  vaddpd  xmm0,xmm0,xmm1;
  vzeroupper;
 @ende:
end;

{Result = (Sum(1,n)(SQRT(Feld))); for the array cols}
function SumSQRTVYDouble (const Feld :array of T4Double):T4Double;
    assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vxorpd ymm0,ymm0,ymm0;
  test r8,r8;                     // value < 0 not valid
  js  @ende;
  add r8,1;
  xor r11,r11;
align 16;
 @Loop:
  vsqrtpd ymm1,ymmword ptr[rdx+r11]; // sqrt im mem and save in ymm1
  vaddpd  ymm0,ymm0,ymm1;
  add r11,32;
  sub r8,1;
  jnz @Loop;

 @ende:
  vmovupd ymmword ptr [rcx],ymm0;
  vzeroupper;
end;

{Feld = 1.0/SQRT(Feld)}
procedure RecSQRTYDouble (var Feld :array of T4Double);assembler;nostackframe;

asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  xor  r11,r11;
  vpcmpeqw xmm1,xmm1,xmm1;
  vpsllq   xmm1,xmm1,54;
  vpsrlq   xmm1,xmm1,2;       // set 1.0
  vinsertf128 ymm1,ymm1,xmm1,1;
align 16;
 @Loop:
  vsqrtpd ymm2,ymmword ptr[rcx+r11];  // sqrt im mem and save in ymm2
  vdivpd  ymm0,ymm1,ymm2;
  vmovupd ymmword ptr [rcx+r11],ymm0;  // result
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{Res = 1.0/SQRT(Feld)}
function RecSQRTYDouble (const Feld :array of T4Double;
                         out   Res  :array of T4Double):Longbool;
                         assembler;nostackframe;
asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor  r11,r11;
  vpcmpeqw xmm1,xmm1,xmm1;
  vpsllq   xmm1,xmm1,54;
  vpsrlq   xmm1,xmm1,2;       // set 1.0
  vinsertf128 ymm1,ymm1,xmm1,1;
align 16;
 @Loop:
  vsqrtpd ymm2,ymmword ptr[rcx+r11];  // sqrt im mem and save in ymm2
  vdivpd  ymm0,ymm1,ymm2;
  vmovupd ymmword ptr [r8+r11],ymm0;  // result
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{Feld = 1.0/SQRT(Feld); when zeros in Feld -> 0 on this position}
procedure SRecSQRTYDouble (var Feld :array of T4Double);assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  sub  rsp,16;

  vstmxcsr dword ptr [rsp];
  mov  r10d,dword ptr [rsp];
  or   r10d,$0000200;          // set bit 9 to 1 ,d.h. div 0 -> +oo
  mov  dword ptr [rsp+8],r10d;
  vldmxcsr dword ptr [rsp+8];

  vbroadcastf128 ymm3,xmmword ptr [rip+QNAND16];
  vbroadcastf128 ymm2,xmmword ptr [rip+_QNAND16];
  vpcmpeqw xmm5,xmm5,xmm5;
  vpsllq   xmm5,xmm5,54;
  vpsrlq   xmm5,xmm5,2;
  vinsertf128 ymm5,ymm5,xmm5,1;  // set 1.0
  xor  r11,r11;
align 16;
 @Loop:
  vsqrtpd ymm4,ymmword ptr [rcx+r11];
  vdivpd  ymm4,ymm5,ymm4;        // divide 1/ymmword
  vcmppd  ymm0,ymm4,ymm3,0;      // +oo?
  vcmppd  ymm1,ymm4,ymm2,0;      // -oo?
  //vorpd   ymm0,ymm0,ymm1;
  DB $C5,$FD,$56,$C1;
  vandnpd ymm0,ymm0,ymm4;        // set oo to 0 rest ok
  vmovupd ymmword ptr [rcx+r11],ymm0;  // result in Feld
  add r11,32;
  sub rdx,1;
  jnz @Loop;

  vldmxcsr dword ptr [rsp];
  vzeroupper;
  add rsp,16;
 @ende:
end;

{Res = 1.0/SQRT(Feld); when zeros in Feld -> 0 on this position}
function SRecSQRTYDouble (const Feld :array of T4Double;
                          out   Res  :array of T4Double):Longbool;
                          assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  sub  rsp,16;

  vstmxcsr dword ptr [rsp];
  mov  r10d,dword ptr [rsp];
  or   r10d,$0000200;          // set bit 9 to 1 ,d.h. div 0 -> oo
  mov  dword ptr [rsp+8],r10d;
  vldmxcsr dword ptr [rsp+8];

  vbroadcastf128 ymm3,xmmword ptr [rip+QNAND16];
  vbroadcastf128 ymm2,xmmword ptr [rip+_QNAND16];
  vpcmpeqw xmm5,xmm5,xmm5;
  vpsllq   xmm5,xmm5,54;
  vpsrlq   xmm5,xmm5,2;
  vinsertf128 ymm5,ymm5,xmm5,1;  // set 1.0
  xor  r11,r11;
align 16;
 @Loop:
  vsqrtpd ymm4,ymmword ptr [rcx+r11];
  vdivpd  ymm4,ymm5,ymm4;         // divide 1/ymmword
  vcmppd  ymm0,ymm4,ymm3,0;       // +oo?
  vcmppd  ymm1,ymm4,ymm2,0;       // -oo?
  //vorpd   ymm0,ymm0,ymm1;
  DB $C5,$FD,$56,$C1;
  vandnpd ymm0,ymm0,ymm4;         // set +oo to 0 rest ok
  vmovupd ymmword ptr [r8+r11],ymm0;  // result in Feld
  add r11,32;
  sub rdx,1;
  jnz @Loop;

  vldmxcsr dword ptr [rsp];
  vzeroupper;
  add  rsp,16;
 @ende:
end;

{Result = (Sum(1,n(1.0/SQRT(Feld))))}
function SumRecSQRTYDouble (const Feld :array of T4Double):Double;
                             assembler;nostackframe;
asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vxorpd ymm0,ymm0,ymm0;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  xor  r11,r11;
  vpcmpeqw xmm1,xmm1,xmm1;
  vpsllq   xmm1,xmm1,54;
  vpsrlq   xmm1,xmm1,2;       // set 1.0
  vinsertf128 ymm1,ymm1,xmm1,1;
align 16;
 @Loop:
  vsqrtpd ymm2,ymmword ptr[rcx+r11];  // sqrt im mem and save in ymm2
  vdivpd  ymm2,ymm1,ymm2;
  vaddpd  ymm0,ymm0,ymm2;
  add r11,32;
  sub rdx,1;
  jnz @Loop;

  vhaddpd ymm0,ymm0,ymm0;
  vextractf128 xmm1,ymm0,1;
  vaddpd xmm0,xmm0,xmm1;
  vzeroupper;
 @ende:
end;

{Result = Sum(1,n(1.0/SQRT(Feld))); when zeros in Feld -> 0 in this position}
function SumSRecSQRTYDouble (const Feld :array of T4Double):Double;
                          assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;
 {$ENDIF}
 {$IFDEF WIN64}
  sub rsp,32;
  vmovdqu ymmword ptr [rsp],ymm6;
 {$ENDIF}
  vxorpd ymm0,ymm0,ymm0;       // for sum
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  sub  rsp,16;

  vstmxcsr dword ptr [rsp];
  mov  r10d,dword ptr [rsp];
  or   r10d,$0000200;          // set bit 9 to 1 ,d.h. div 0 -> +oo
  mov  dword ptr [rsp+8],r10d;
  vldmxcsr dword ptr [rsp+8];

  vbroadcastf128 ymm3,xmmword ptr [rip+QNAND16];
  vbroadcastf128 ymm2,xmmword ptr [rip+_QNAND16];
  vpcmpeqw xmm5,xmm5,xmm5;
  vpsllq   xmm5,xmm5,54;
  vpsrlq   xmm5,xmm5,2;
  vinsertf128 ymm5,ymm5,xmm5,1;  // set 1.0
  xor  r11,r11;
align 16;
 @Loop:
  vsqrtpd ymm4,ymmword ptr [rcx+r11];
  vdivpd  ymm4,ymm5,ymm4;        // divide 1/ymmword
  vcmppd  ymm1,ymm4,ymm3,0;      // +oo?
  vcmppd  ymm6,ymm4,ymm2,0;      // -oo?
  //vorpd   ymm1,ymm1,ymm6;
  DB $C5,$F5,$56,$CE;
  vandnpd ymm1,ymm1,ymm4;        // set +oo to 0 rest ok
  vaddpd  ymm0,ymm0,ymm1;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;

  vldmxcsr dword ptr [rsp];
  add  rsp,16;
  vextractf128 xmm1,ymm0,1;
  vaddpd  xmm0,xmm0,xmm1;
  vhaddpd xmm0,xmm0,xmm0;

 @ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  add rsp,32;
 {$ENDIF}
  vzeroupper;
end;

{Result = Sum(1,n(1.0/SQRT(Feld))) for the array cols}
function SumRecSQRTVYDouble (const Feld :array of T4Double):T4Double;
                             assembler;nostackframe;
asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vxorpd ymm0,ymm0,ymm0;
  test r8,r8;                     // value < 0 not valid
  js   @ende;
  add  r8,1;
  xor  r11,r11;
  vpcmpeqw xmm1,xmm1,xmm1;
  vpsllq   xmm1,xmm1,54;
  vpsrlq   xmm1,xmm1,2;       // set 1.0
  vinsertf128 ymm1,ymm1,xmm1,1;
align 16;
 @Loop:
  vsqrtpd ymm2,ymmword ptr[rdx+r11];  // sqrt im mem and save in ymm2
  vdivpd  ymm2,ymm1,ymm2;
  vaddpd  ymm0,ymm0,ymm2;
  add  r11,32;
  sub  r8,1;
  jnz  @Loop;

 @ende:
  vmovupd ymmword ptr [rcx],ymm0;  // result
  vzeroupper;
end;

{Result = Sum(1,n(1.0/SQRT(Feld))); when zeros in Feld -> 0 in this position}
function SumSRecSQRTVYDouble (const Feld :array of T4Double):T4Double;
                          assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;   //result
  mov rdx,rsi;  //feld
  mov r8, rdx;  //length
 {$ENDIF}
 {$IFDEF WIN64}
  sub rsp,32;
  vmovdqu ymmword ptr [rsp],ymm6;
 {$ENDIF}
  vxorpd ymm0,ymm0,ymm0;       // for sum
  test r8,r8;                     // value < 0 not valid
  js   @ende;
  add  r8,1;
  sub  rsp,16;

  vstmxcsr dword ptr [rsp];
  mov  r10d,dword ptr [rsp];
  or   r10d,$0000200;          // set bit 9 to 1 ,d.h. div 0 -> +oo
  mov  dword ptr [rsp+8],r10d;
  vldmxcsr dword ptr [rsp+8];

  vbroadcastf128 ymm3,xmmword ptr [rip+QNAND16];
  vbroadcastf128 ymm2,xmmword ptr [rip+_QNAND16];
  vpcmpeqw xmm5,xmm5,xmm5;
  vpsllq   xmm5,xmm5,54;
  vpsrlq   xmm5,xmm5,2;
  vinsertf128 ymm5,ymm5,xmm5,1;  // set 1.0
  xor  r11,r11;
align 16;
 @Loop:
  vsqrtpd ymm4,ymmword ptr [rdx+r11];
  vdivpd  ymm4,ymm5,ymm4;        // divide 1/ymmword
  vcmppd  ymm1,ymm4,ymm3,0;      // +oo?
  vcmppd  ymm6,ymm4,ymm2,0;      // -oo?
  //vorpd   ymm1,ymm1,ymm6;
  DB $C5,$F5,$56,$CE;
  vandnpd ymm1,ymm1,ymm4;        // set -oo to 0 rest ok
  vaddpd  ymm0,ymm0,ymm1;
  add  r11,32;
  sub  r8,1;
  jnz  @Loop;

  vldmxcsr dword ptr [rsp];     // load old mxcsr
  add  rsp,16;

 @ende:
  vmovupd ymmword ptr [rcx],ymm0;
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  add rsp,32;
 {$ENDIF}
  vzeroupper;
end;


{set the sign bit to 0 when 1 or 1 when 0}
procedure SignFlipFlopYSingle (var Feld :array of T8Single);
  assembler; nostackframe;

asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  vpcmpeqw xmm1,xmm1,xmm1;
  vpslld   xmm1,xmm1,31;
  vinsertf128 ymm1,ymm1,xmm1,1;
  xor  r11,r11;
align 16;
 @Loop:
  vxorps  ymm0,ymm1,ymmword ptr[rcx+r11];
  vmovups ymmword ptr[rcx+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

procedure SetSignYSingle (var Feld :array of T8Single);assembler;nostackframe;

asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  vpcmpeqw xmm1,xmm1,xmm1;
  vpslld   xmm1,xmm1,31;
  vinsertf128 ymm1,ymm1,xmm1,1;
  xor  r11,r11;
align 16;
 @Loop:
  vorps ymm0,ymm1,ymmword ptr[rcx+r11];
  vmovups ymmword ptr[rcx+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

procedure AbsYSingle (var Feld :array of T8Single);assembler; nostackframe;

asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  vpcmpeqw xmm1,xmm1,xmm1;
  vpsrld   xmm1,xmm1,1;
  vinsertf128 ymm1,ymm1,xmm1,1;
  xor  r11,r11;
align 16;
 @Loop:
  vandps ymm0,ymm1,ymmword ptr[rcx+r11];
  vmovups ymmword ptr[rcx+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

procedure SignFlipFlopYDouble (var Feld :array of T4Double);
  assembler; nostackframe;

asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  vpcmpeqw xmm1,xmm1,xmm1;
  vpsllq   xmm1,xmm1,63;
  vinsertf128 ymm1,ymm1,xmm1,1;
  xor  r11,r11;
align 16;
 @Loop:
  vxorpd ymm0,ymm1,ymmword ptr[rcx+r11];
  vmovupd ymmword ptr[rcx+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

procedure SetSignYDouble (var Feld :array of T4Double);assembler; nostackframe;

asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  vpcmpeqw xmm1,xmm1,xmm1;
  vpsllq   xmm1,xmm1,63;
  vinsertf128 ymm1,ymm1,xmm1,1;
  xor     r11,r11;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr[rcx+r11];
//  vorpd   ymm0,ymm0,ymm1;
  db $C5,$FD,$56,$C1;
  vmovupd ymmword ptr[rcx+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

procedure AbsYDouble (var Feld :array of T4Double);assembler; nostackframe;

asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  vpcmpeqw xmm1,xmm1,xmm1;
  vpsrlq   xmm1,xmm1,1;
  vinsertf128 ymm1,ymm1,xmm1,1;
  xor     r11,r11;
align 16;
 @Loop:
  vandpd ymm0,ymm1,ymmword ptr[rcx+r11];
  vmovupd ymmword ptr[rcx+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{Res = Feld^(exponent)}
function IntPowYSingle (const Feld :array of T8Single;
                          out Res  :array of T8Single;
                              exponent :Longint):Longbool;assembler;
 asm
  push r12;
  {$IFNDEF WIN64}
   mov r12,r8;   //exponent
   mov rcx,rdi;  //Feld
   mov edx,esi;  //length
   mov r8, rdx;  //Res
   mov r9, rcx;  //length
  {$ENDIF}
  {$IFDEF WIN64}
   mov r12,qword ptr [exponent];
  {$ENDIF}
   xor  rax,rax;                      // false
   test rdx,rdx;                     // value < 0 not valid
   js   @ende;
   cmp  rdx,r9;                       // Feld length = Res length
   jne  @ende;
   add  rdx,1;
   xor  r11,r11;
   vpcmpeqw xmm2,xmm2,xmm2;
   vpslld   xmm2,xmm2,25;
   vpsrld   xmm2,xmm2,2;             // set 1.0
   vinsertf128 ymm2,ymm2,xmm2,1;
   cmp     r12d,1;
   je      @Loop1;
   cmp     r12d,-1;
   je      @Loop_1;
   test    r12d,r12d;                // exponent 0?
   jz      @Loop0;
   jns     @Loop;
   neg     r12d;
   jo      @ende;

align 16;
  @Loop:
   vmovups ymm0,ymmword ptr[rcx+r11];
   vmovaps ymm3,ymm2;
   mov r9d,r12d;          // give exponent for the round
align 16;
  @Loop2:
   test r9d,$00000001;    // is odd?
   jnz  @2;
   shr  r9d,1;             // exponent div 2
   vmulps ymm0,ymm0,ymm0;  // *2
   jnz  @Loop2;
align 16;
  @2:
   vmulps ymm3,ymm3,ymm0;
   sub  r9d,1;
   jnz  @Loop2;

   test r12d,r12d;   //exponent negativ?
   js   @negexp;
   vmovups ymmword ptr [r8+r11],ymm3;
   add  r11,32;
   sub  rdx,1;
   jnz  @Loop;
   mov  rax,1;
   jz   @ende;

align 16;
  @negexp:
   vdivps ymm0,ymm2,ymm3;   // 1/result
   vmovups ymmword ptr [r8+r11],ymm0;
   add  r11,32;
   sub  rdx,1;
   jnz  @Loop;
   mov  rax,1;
   jz   @ende;

   // exponent = 0
align 16;
  @Loop0:
   vmovups ymmword ptr[r8+r11],ymm2; // x^0 def = 1.0
   add  r11,32;
   sub  rdx,1;
   jnz  @Loop0;
   mov  rax,1;
   jz   @ende;

  //exponent = 1
align 16;
  @loop1:
   vmovups ymm0,ymmword ptr[rcx+r11];  // x^1 = x
   vmovups ymmword ptr [r8+r11],ymm0;
   add  r11,32;
   sub  rdx,1;
   jnz  @Loop1;
   mov  rax,1;
   jz   @ende;

  // exponent = -1
align 16;
  @loop_1:
   vmovups ymm0,ymmword ptr[rcx+r11];
   vdivps  ymm0,ymm2,ymm0;
   vmovups ymmword ptr [r8+r11],ymm0;
   add r11,32;
   sub rdx,1;
   jnz @Loop_1;
   mov rax,1;
   jz  @ende;

align 16;
  @ende:
   pop r12;
   vzeroupper;
end;

{Res = Feld^(exponent)}
function IntPowYDouble (const Feld :array of T4Double;
                          out Res  :array of T4Double; exponent :Longint):Longbool;
                        assembler;
 asm
   push r12;
  {$IFNDEF WIN64}
   mov r12,r8;   //exponent
   mov rcx,rdi;  //Feld
   mov rdx,rsi;  //length
   mov r8, rdx;  //res
   mov r9, rcx;  //length
  {$ENDIF}
  {$IFDEF WIN64}
   mov r12,qword ptr [exponent];
  {$ENDIF}
   xor  rax,rax;                     //false
   test rdx,rdx;                     // value < 0 not valid
   js   @ende;
   cmp  rdx,r9;
   jne  @ende;
   add  rdx,1;
   xor  r11,r11;
   vpcmpeqw xmm2,xmm2,xmm2;
   vpsllq   xmm2,xmm2,54;
   vpsrlq   xmm2,xmm2,2;             // set 1.0
   vinsertf128 ymm2,ymm2,xmm2,1;
   cmp  r12d,1;
   je   @Loop1;
   cmp  r12d,-1;
   je   @Loop_1;
   test r12d,r12d;
   jz   @Loop0;
   jns  @Loop;
   neg  r12d;                      // abs(exponent)
   jo   @ende;

align 16;
  @Loop:
   vmovupd ymm0,ymmword ptr[rcx+r11];
   vmovapd ymm3,ymm2;
   mov r9d,r12d;
align 16;
  @Loop2:
   test r9d,1;
   jnz  @2;
   shr  r9d,1;
   vmulpd ymm0,ymm0,ymm0;
   jnz  @Loop2;
align 16;
  @2:
   vmulpd ymm3,ymm3,ymm0;
   sub  r9d,1;
   jnz  @Loop2;

   test r12d,r12d;
   js   @negexp;
   vmovupd ymmword ptr [r8+r11],ymm3;
   add  r11,32;
   sub  rdx,1;
   jnz  @Loop;
   mov  rax,1;  //true
   jz   @ende;

align 16;
  @negexp:
   vdivpd  ymm0,ymm2,ymm3;               // 1/result
   vmovupd ymmword ptr [r8+r11],ymm0;
   add  r11,32;
   sub  rdx,1;
   jnz  @Loop;
   mov  rax,1;
   jz   @ende;

 //exponent = 0
align 16;
  @Loop0:
   vmovupd ymmword ptr [r8+r11],ymm2;
   add r11,32;
   sub rdx,1;
   jnz @Loop0;
   mov  rax,1;
   jz  @ende;

 //exponent = 1
align 16;
  @loop1:
   vmovupd ymm0,ymmword ptr[rcx+r11];
   vmovupd ymmword ptr [r8+r11],ymm0;
   add r11,32;
   sub rdx,1;
   jnz @Loop1;
   mov  rax,1;
   jz  @ende;

   // exponent = -1
align 16;
  @loop_1:
   vmovupd ymm0,ymmword ptr[rcx+r11];
   vdivpd  ymm0,ymm2,ymm0;
   vmovupd ymmword ptr [r8+r11],ymm0;
   add r11,32;
   sub rdx,1;
   jnz @Loop_1;
   mov  rax,1;
   jz  @ende;

align 16;
  @ende:
   pop r12;
   vzeroupper;
end;

{Res = Ln(Feld)}
function LnYSingle (const Feld :array of T8Single;
                    out   Res  :array of T8Single):Longbool;
                    assembler;nostackframe;
 asm
  {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
  {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[rcx+r11];
  vmovups ymmword ptr [rsp],ymm0;
  mov     r10d,8;             // counter
  call    FN_LN_SINGLE;
  vmovups ymm0,ymmword ptr [rsp];
  vmovups ymmword ptr [r8+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  add rsp,32;
  vzeroupper;
 @ende:
end;

{Res = Ln(Feld)}
function LnYDouble (const Feld :array of T4Double;
                     out  Res  :array of T4Double):Longbool;
                    assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr[rcx+r11];
  vmovupd ymmword ptr[rsp],ymm0;
  mov     r10d,4;               // counter
  call    FN_LN_DOUBLE;
  vmovupd ymm0,ymmword ptr[rsp];
  vmovupd ymmword ptr [r8+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  add rsp,32;
  vzeroupper;
 @ende:
end;

{Res = Ld(Feld)}
function LdYSingle (const Feld :array of T8Single;
                     out  Res  :array of T8Single):Longbool;
                    assembler;nostackframe;
 asm
  {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
  {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[rcx+r11];
  vmovups ymmword ptr [rsp],ymm0;
  mov     r10d,8;             // counter
  call    FN_LD_SINGLE;
  vmovups ymm0,ymmword ptr [rsp];
  vmovups ymmword ptr [r8+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  add rsp,32;
  vzeroupper;
 @ende:
end;

{Res = Ld(Feld)}
function LdYDouble (const Feld :array of T4Double;
                     out  Res  :array of T4Double):Longbool;
                    assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr[rcx+r11];
  vmovupd ymmword ptr[rsp],ymm0;
  mov     r10d,4;               // counter
  call    FN_LD_DOUBLE;
  vmovupd ymm0,ymmword ptr[rsp];
  vmovupd ymmword ptr [r8+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  add rsp,32;
  vzeroupper;
 @ende:
end;

{Res = Log(Feld)}
function LogYSingle (const Feld :array of T8Single;
                      out  Res  :array of T8Single):Longbool;
                     assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[rcx+r11];
  vmovups ymmword ptr [rsp],ymm0;
  mov     r10d,8;              // counter
  call    FN_LOG_SINGLE;
  vmovups ymm0,ymmword ptr [rsp];
  vmovups ymmword ptr [r8+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  add rsp,32;
  vzeroupper;
 @ende:
end;

{Res = Log(Feld}
function LogYDouble (const Feld :array of T4Double;
                      out  Res  :array of T4Double):Longbool;
                      assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr[rcx+r11];
  vmovupd ymmword ptr [rsp],ymm0;
  mov     r10d,4;               // counter
  call    FN_LOG_DOUBLE;
  vmovupd ymm0,ymmword ptr [rsp];
  vmovupd ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,32;
  vzeroupper;
 @ende:
end;

{Res = Feld^(exponent)}
function PowYSingle (const Feld :array of T8Single;out Res :array of T8Single;
                     constref exponent :Single):Longbool;assembler;
 asm
   push r12;
  {$IFNDEF WIN64}
   mov r12,r8;  //exponent
   mov rcx,rdi; //Feld
   mov rdx,rsi; //length
   mov r8, rdx; //Res
   mov r9, rcx; //length
  {$ENDIF}
  {$IFDEF WIN64}
   mov r12,qword ptr [exponent];
  {$ENDIF}
   xor  rax,rax;
   sub  rsp,32;
   test rdx,rdx;                     // value < 0 not valid
   js   @ende;
   cmp  rdx,r9;
   jne  @ende;
   add  rdx,1;
   xor  r11,r11;
   vpcmpeqw xmm2,xmm2,xmm2;
   vpslld   xmm2,xmm2,25;
   vpsrld   xmm2,xmm2,2;                   // = 1.0
   vinsertf128 ymm2,ymm2,xmm2,1;
   vbroadcastss ymm1,dword ptr [r12];      // exponent
   mov  r10d,dword ptr [r12];
   cmp  r10d,1;                            // exponent 1?
   je   @Loop1;
   cmp  r10d,-1;                           // exponent -1?
   je   @Loop_1;
   test r10d,r10d;                         // exponent 0?
   jz   @Loop0;

   // exp(exponent * ln(Feld))
align 16;
  @Loop:
   vmovups ymm0,ymmword ptr[rcx+r11];
   vmovups ymmword ptr [rsp],ymm0;
   mov     r10d,8;
   call    FN_LN_SINGLE;
   vmovups ymm0,ymmword ptr[rsp];
   vmulps  ymm0,ymm0,ymm1;                // * Exp
   vmovups ymmword ptr [rsp],ymm0;
   mov     r10d,8;
   call    FN_EXP_SINGLE;
   vmovups ymm0,ymmword ptr[rsp];
   vmovups ymmword ptr [r8+r11],ymm0;
   add  r11,32;
   sub  rdx,1;
   jnz  @Loop;
   mov  rax,1;
   jz   @ende;

  // exponent = 0
align 16;
  @Loop0:
   vmovups ymmword ptr[r8+r11],ymm2;   //set 1.0
   add  r11,32;
   sub  rdx,1;
   jnz  @Loop0;
   mov  rax,1;
   jz   @ende;

  // exponent = 1
align 16;
  @Loop1:
   vmovups ymm0,ymmword ptr [rcx+r11];
   vmovups ymmword ptr [r8+r11],ymm0;
   add r11,32;
   sub rdx,1;
   jnz @Loop1;
   mov rax,1;
   jz  @ende;

  // exponent = -1
align 16;
  @Loop_1:
   vmovups ymm0,ymmword ptr [rcx+r11];
   vdivps  ymm0,ymm2,ymm0;             // 1/ymm0
   vmovups ymmword ptr [r8+r11],ymm0;
   add r11,32;
   sub rdx,1;
   jnz @Loop_1;
   mov rax,1;
   jz  @ende;

align 16;
 @ende:
  add  rsp,32;
  pop  r12;
  vzeroupper;
end;

{Res = Feld^(exponent)}
function PowYDouble (const Feld :array of T4Double;out Res :array of T4Double;
                     constref exponent :Double):Longbool;assembler;
 asm
   push r12;
  {$IFNDEF WIN64}
   mov r12, r8;  //exponent
   mov rcx,rdi;  //Feld
   mov rdx,rsi;  //
   mov r8, rdx;  //Res
   mov r9, rcx;
  {$ENDIF}
  {$IFDEF WIN64}
   mov r12,qword ptr [exponent];
  {$ENDIF}
   xor  rax,rax;
   sub  rsp,32;
   test rdx,rdx;                     // value < 0 not valid
   js   @ende;
   cmp  rdx,r9;
   jne  @ende;
   add  rdx,1;
   xor  r11,r11;
   vpcmpeqw  xmm2,xmm2,xmm2;
   vpsllq    xmm2,xmm2,54;
   vpsrlq    xmm2,xmm2,2;                   // = 1.0
   vinsertf128 ymm2,ymm2,xmm2,1;
   vbroadcastsd  ymm1,[r12];     //exponent
   mov  r10,qword ptr [r12];
   cmp  r10,1;
   je   @Loop1;
   cmp  r10,-1;
   je   @Loop_1;
   test r10,r10;
   jz   @Loop0;

   // exp(exponent * ln(Feld))
   xor  r11,r11;
align 16;
  @Loop:
   vmovupd ymm0,ymmword ptr[rcx+r11];
   vmovupd ymmword ptr [rsp],ymm0;
   mov     r10d,4;
   call    FN_LN_DOUBLE;
   vmovupd ymm0,ymmword ptr [rsp];
   vmulpd  ymm0,ymm0,ymm1;               // *Exp
   vmovupd ymmword ptr [rsp],ymm0;
   mov     r10d,4;
   call    FN_EXP_DOUBLE;
   vmovupd ymm0,ymmword ptr [rsp];
   vmovupd ymmword ptr [r8+r11],ymm0;
   add  r11,32;
   sub  rdx,1;
   jnz  @Loop;
   mov  rax,1;
   jz   @ende;

align 16;
  @Loop0:
   vmovupd ymmword ptr [r8+r11],ymm2;   // set 1.0
   add r11,32;
   sub rdx,1;
   jnz @Loop0;
   mov rax,1;
   jz  @ende;

  //exponent = -1
align 16;
  @Loop_1:
   vmovupd ymm0,ymmword ptr [rcx+r11];
   vdivpd  ymm0,ymm2,ymm0;        // 1/ymm0
   vmovupd ymmword ptr [r8+r11],ymm0;
   add  r11,32;
   sub  rdx,1;
   jnz  @Loop;
   mov  rax,1;
   jz   @ende;

  // exponent = 1
align 16;
  @Loop1:
   vmovupd ymm0,ymmword ptr [rcx+r11];
   vmovupd ymmword ptr [r8+r11],ymm0;
   add  r11,32;
   sub  rdx,1;
   jnz  @Loop;
   mov rax,1;   //true

align 16;
 @ende:
  add  rsp,32;
  pop  r12;
  vzeroupper;
end;

{Res = 10^(Feld)}
function Exp10YSingle (const Feld :array of T8Single;
                       out   Res  :array of T8Single):Longbool;
                       assembler;nostackframe;
 asm
  {$IFNDEF WIN64}
   mov rcx,rdi;
   mov rdx,rsi;
   mov r8, rdx;
   mov r9, rcx;
  {$ENDIF}
   xor  rax,rax;
   test rdx,rdx;                     // value < 0 not valid
   js   @ende;
   cmp  rdx,r9;
   jne  @ende;
   mov  rax,1;
   add  rdx,1;
   sub  rsp,32;
   xor  r11,r11;
align 16;
  @Loop:
   vmovups ymm0,ymmword ptr[rcx+r11];
   // 10^(values)
   vmovups ymmword ptr [rsp],ymm0;
   mov     r10d,8;                   // 8 values
   call    FN_EXP10_SINGLE;
   vmovups ymm0,ymmword ptr [rsp];
   vmovups ymmword ptr [r8+r11],ymm0;
   add r11,32;
   sub rdx,1
   jnz @Loop;
   add rsp,32;
   vzeroupper;
 @ende:
end;

{Res = 10^(Feld)}
function Exp10YDouble (const Feld :array of T4Double;
                       out   Res  :array of T4Double):Longbool;
                      assembler;nostackframe;
 asm
  {$IFNDEF WIN64}
   mov rcx,rdi;
   mov rdx,rsi;
   mov r8, rdx;
   mov r9, rcx;
  {$ENDIF}
   xor  rax,rax;
   test rdx,rdx;                     // value < 0 not valid
   js   @ende;
   cmp  rdx,r9;
   jne  @ende;
   mov  rax,1;
   add  rdx,1;
   sub  rsp,32;
   xor  r11,r11;
align 16;
  @Loop:
   vmovupd ymm0,ymmword ptr[rcx+r11];
   // 10^(exponent)
   vmovupd ymmword ptr [rsp],ymm0;
   mov     r10d,4;                   // 4 value
   call    FN_EXP10_DOUBLE;
   vmovupd ymm0,ymmword ptr [rsp];
   vmovupd ymmword ptr [r8+r11],ymm0;
   add r11,32;
   sub rdx,1;
   jnz @Loop;
   add rsp,32;
   vzeroupper;
  @ende:
end;

{Res = 2^(Feld)}
function Exp2YSingle (const Feld :array of T8Int32;
                       out  Res  :array of T8Single):Longbool;
                       assembler;nostackframe;
 asm
  {$IFNDEF WIN64}
   mov rcx,rdi;
   mov rdx,rsi;
   mov r8, rdx;
   mov r9, rcx;
  {$ENDIF}
   xor  rax,rax;
   test rdx,rdx;                     // value < 0 not valid
   js   @ende;
   cmp  rdx,r9;
   jne  @ende;
   mov  rax,1;
   add  rdx,1;
   sub  rsp,32;
   xor  r11,r11;
align 16;
  @Loop:
   vmovdqu ymm0,ymmword ptr[rcx+r11];
   // 2^(values)
   vmovdqu ymmword ptr [rsp],ymm0;
   mov     r10d,8;                   // 8 values
   call    FN_EXP2_SINGLE;
   vmovups ymm0,ymmword ptr [rsp];
   vmovups ymmword ptr [r8+r11],ymm0;
   add r11,32;
   sub rdx,1
   jnz @Loop;
   add rsp,32;
   vzeroupper;
 @ende:
end;

{Res = 2^(Feld)}
function Exp2YDouble (const Feld :array of T4Int32;
                       out Res :array of T4Double):Longbool;
                      assembler;nostackframe;
 asm
  {$IFNDEF WIN64}
   mov rcx,rdi;
   mov rdx,rsi;
   mov r8, rdx;
   mov r9, rcx;
  {$ENDIF}
   xor  rax,rax;
   test rdx,rdx;                     // value < 0 not valid
   js   @ende;
   cmp  rdx,r9;
   jne  @ende;
   mov  rax,1;
   add  rdx,1;
   sub  rsp,64;
   xor  r11,r11;
align 16;
  @Loop:
   vmovdqu xmm0,xmmword ptr[rcx+r11];
   // 2^(Feld)
   vmovdqu xmmword ptr [rsp],xmm0;
   mov     r10d,4;                   // 4 value
   call    FN_EXP2_DOUBLE;
   vmovupd ymm0,ymmword ptr [rsp+32];
   vmovupd ymmword ptr [r8+r11*2],ymm0;
   add r11,16;
   sub rdx,1;
   jnz @Loop;
   add rsp,64;
   vzeroupper;
  @ende:
end;

{Result = exponent of Feld}
function ExponentYSingle (const Feld: T8Single):T8Int32;
  assembler;nostackframe;

 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  sub      rsp,32;
  vmovups  ymm0,ymmword ptr[rdx];
  vmovups  ymmword ptr[rsp],ymm0;
  mov      r10d,8;
  call     FN_EXTR_SINGLE;
  vcvttps2dq ymm0,ymmword ptr [rsp]; // convert single in Longint
  vmovdqu  ymmword ptr[rcx],ymm0;
  add      rsp,32;
  vzeroupper;
end;

{Result exponent of Feld}
function ExponentYDouble (const Feld: T4Double):T4Int32;
  assembler;nostackframe;

 asm
  {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  {$ENDIF}
  sub      rsp,32;
  vmovupd  ymm0,ymmword ptr[rdx];
  vmovupd  ymmword ptr [rsp],ymm0;
  mov      r10d,4;
  call     FN_EXTR_DOUBLE;
  vmovupd  ymm0,ymmword ptr [rsp];
  DB $C5,$FF,$E6,$C8
  //vcvtpd2dq xmm1,ymm0;        // convert double in Longint
  //vcvttpd2dq xmm2,ymmword ptr [rsp];     // convert double in Longint
  vmovdqu  xmmword ptr[rcx],xmm1;
  add      rsp,32;
  vzeroupper;
end;

{Res = e^(Feld)}
function ExpYSingle (const Feld :array of T8Single;
                     out   Res  :array of T8Single):Longbool;
                     assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;
  mov r8, rdx;  //Res
  mov r9, rcx;
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[rcx+r11];
  vmovups ymmword ptr [rsp],ymm0;
  mov     r10d,8;
  call    FN_EXP_SINGLE;
  vmovups ymm0,ymmword ptr [rsp];
  vmovups ymmword ptr [r8+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  add rsp,32;
  vzeroupper;
 @ende:
end;

{Res = e^(Feld)}
function ExpYDouble (const Feld :array of T4Double;
                     out   Res  :array of T4Double):Longbool;
                     assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr[rcx+r11];
  vmovupd ymmword ptr [rsp],ymm0;
  mov     r10d,4;
  call    FN_EXP_DOUBLE;
  vmovupd ymm0,ymmword ptr [rsp];
  vmovupd ymmword ptr [r8+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  add rsp,32;
  vzeroupper;
 @ende:
end;

{---------------------------trigonometrie---------------------------------}


{conversion radian in degree}
procedure RadInDegYSingle (var Feld :array of T8Single);
                           assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  xor  r11,r11;
  mov  eax,$40490FDB                // Phi as single
  vmovd   xmm1,eax;
  vshufps xmm1,xmm1,xmm1,0;
  vinsertf128 ymm1,ymm1,xmm1,1;
  mov     eax,$43340000;            // 180 as single
  vmovd   xmm2,eax;
  vshufps xmm2,xmm2,xmm2,0;
  vinsertf128 ymm2,ymm2,xmm2,1;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[rcx+r11];
  vmulps  ymm0,ymm0,ymm2;
  vdivps  ymm0,ymm0,ymm1;
  vmovups ymmword ptr [rcx+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  vzeroupper;
 @ende:
end;

{conversion radian in gon}
procedure RadInGonYSingle (var Feld :array of T8Single);
                           assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add rdx,1;
  xor r11,r11;
  mov     eax,$40490FDB                // Phi
  vmovd   xmm1,eax;
  vshufps xmm1,xmm1,xmm1,0;
  vinsertf128 ymm1,ymm1,xmm1,1;
  mov     eax,$43480000;               // 200
  vmovd   xmm2,eax;
  vshufps xmm2,xmm2,xmm2,0;
  vinsertf128 ymm2,ymm2,xmm2,1;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[rcx+r11];
  vmulps  ymm0,ymm0,ymm2;
  vdivps  ymm0,ymm0,ymm1;
  vmovups ymmword ptr [rcx+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  vzeroupper;
 @ende:
end;

procedure RadInDegYDouble (var Feld :array of T4Double);
                           assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  xor  r11,r11;
  mov  rax,$4066800000000000;       // 180.0
  vmovq    xmm2,rax;
  vmovddup xmm2,xmm2;
  vinsertf128 ymm2,ymm2,xmm2,1;
  mov  rax,$400921FB54442D18;       // Phi
  vmovq    xmm1,rax;
  vmovddup xmm1,xmm1;
  vinsertf128 ymm1,ymm1,xmm1,1;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr[rcx+r11];
  vmulpd  ymm0,ymm0,ymm2;
  vdivpd  ymm0,ymm0,ymm1;
  vmovupd ymmword ptr [rcx+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  vzeroupper;
 @ende:
end;

procedure RadInGonYDouble (var Feld :array of T4Double);
                           assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add rdx,1;
  xor r11,r11;
  mov      rax,$4069000000000000;        // 200.0
  vmovq    xmm2,rax;
  vmovddup xmm2,xmm2;
  vinsertf128 ymm2,ymm2,xmm2,1;
  mov      rax,$400921FB54442D18;            // Phi
  vmovq    xmm1,rax;
  vmovddup xmm1,xmm1;
  vinsertf128 ymm1,ymm1,xmm1,1;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr[rcx+r11];
  vmulpd  ymm0,ymm0,ymm2;
  vdivpd  ymm0,ymm0,ymm1;
  vmovupd ymmword ptr [rcx+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  vzeroupper;
 @ende:
end;

{conversion degree in radian}
procedure DegInRadYSingle (var Feld :array of T8Single);
                           assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add rdx,1;
  xor r11,r11;
  mov     eax,$40490FDB                // Phi
  vmovd   xmm1,eax;
  vshufps xmm1,xmm1,xmm1,0;
  vinsertf128 ymm1,ymm1,xmm1,1;
  mov     eax,$43340000;          // 180
  vmovd   xmm2,eax;
  vshufps xmm2,xmm2,xmm2,0;
  vinsertf128 ymm2,ymm2,xmm2,1;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[rcx+r11];
  vmulps  ymm0,ymm0,ymm1;
  vdivps  ymm0,ymm0,ymm2;
  vmovups ymmword ptr [rcx+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  vzeroupper;
 @ende:
end;

{conversion gon in radian}
procedure GonInRadYSingle (var Feld :array of T8Single);
                           assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  xor  r11,r11;
  mov     eax,$40490FDB                // Phi
  vmovd   xmm1,eax;
  vshufps xmm1,xmm1,xmm1,0;
  vinsertf128 ymm1,ymm1,xmm1,1;
  mov     eax,$43480000;               // 200
  vmovd   xmm2,eax;
  vshufps xmm2,xmm2,xmm2,0;
  vinsertf128 ymm2,ymm2,xmm2,1;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[rcx+r11];
  vmulps  ymm0,ymm0,ymm1;
  vdivps  ymm0,ymm0,ymm2;
  vmovups ymmword ptr [rcx+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  vzeroupper;
 @ende:
end;

procedure DegInRadYDouble (var Feld :array of T4Double);
                           assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  xor  r11,r11;
  mov      rax,$4066800000000000;        // 180.0
  vmovq    xmm2,rax;
  vmovddup xmm2,xmm2;
  vinsertf128 ymm2,ymm2,xmm2,1;
  mov      rax,$400921FB54442D18;        // Phi
  vmovq    xmm1,rax;
  vmovddup xmm1,xmm1;
  vinsertf128 ymm1,ymm1,xmm1,1;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr[rcx+r11];
  vmulpd  ymm0,ymm0,ymm1;               // * 180
  vdivpd  ymm0,ymm0,ymm2;               // / phi
  vmovupd ymmword ptr [rcx+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  vzeroupper;
 @ende:
end;

procedure GonInRadYDouble (var Feld :array of T4Double);
                           assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  xor  r11,r11;
  mov      rax,$4069000000000000;        // 200.0
  vmovq    xmm2,rax;
  vmovddup xmm2,xmm2;
  vinsertf128 ymm2,ymm2,xmm2,1;
  mov      rax,$400921FB54442D18;        // Phi
  vmovq    xmm1,rax;
  vmovddup xmm1,xmm1;
  vinsertf128 ymm1,ymm1,xmm1,1;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr[rcx+r11];
  vmulpd  ymm0,ymm0,ymm1;
  vdivpd  ymm0,ymm0,ymm2;
  vmovupd ymmword ptr [rcx+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  vzeroupper;
 @ende:
end;

{Res = sin(Feld)}
function SinYSingle (const Feld :array of T8Single;
                       out Res  :array of T8Single):Longbool;
                      assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[rcx+r11];
  vmovups ymmword ptr [rsp],ymm0;
  mov    r10d,8;
  call   FN_SIN_SINGLE;
  vmovups ymm0,ymmword ptr [rsp];
  vmovups ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,32;
  vzeroupper;
 @ende:
end;

{calculate sinus and cosinus}
function SinCosYSingle (const Feld :array of T8Single;
                        out Sin,Cos :array of T8Single):Longbool;assembler;
 asm
  push r12;
  push r13;
 {$IFNDEF WIN64}
  mov r12,r8;   //Cos
  mov r13,r9;   //length
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //Sin
  mov r9, rcx;  //length
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Cos];
  mov r13,qword ptr [Cos+8];
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  cmp  rdx,r13;
  jne  @ende;
  mov  rax,1;
  sub  rsp,64;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[rcx+r11];
  vmovups ymmword ptr [rsp],ymm0;
  mov     r10d,8;
  call    FN_SINCOS_Y_SINGLE;
  vmovups ymm0,ymmword ptr [rsp];
  vmovups ymm1,ymmword ptr [rsp+32];
  vmovups ymmword ptr [r8+r11],ymm0;  // sin
  vmovups ymmword ptr [r12+r11],ymm1; //cos
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,64;
  vzeroupper;
 @ende:
  pop r13;
  pop r12;
end;

{Res = sin(Feld)}
function SinYDouble (const Feld :array of T4Double;
                       out Res  :array of T4Double):Longbool;
                      assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr[rcx+r11];
  vmovupd ymmword ptr [rsp],ymm0;
  mov     r10d,4;
  call    FN_SIN_DOUBLE;
  vmovupd ymm0,ymmword ptr [rsp];
  vmovupd ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,32;
  vzeroupper;
 @ende:
end;

{calculate sinus and cosinus}
function SinCosYDouble (const Feld :array of T4Double;
                        out Sin,Cos :array of T4Double):Longbool;assembler;
 asm
  push r12;
  push r13;
 {$IFNDEF WIN64}
  mov r12,r8;   //Cos
  mov r13,r9;   //length
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //Sin
  mov r9, rcx;  //length
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Cos];
  mov r13,qword ptr [Cos+8];
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  cmp  rdx,r13;
  jne  @ende;
  mov  rax,1;
  sub  rsp,64;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr[rcx+r11];
  vmovupd ymmword ptr [rsp],ymm0;
  mov     r10d,4;
  call    FN_SINCOS_Y_DOUBLE;
  vmovupd ymm0,ymmword ptr [rsp];
  vmovupd ymm1,ymmword ptr [rsp+32];
  vmovupd ymmword ptr [r8+r11],ymm0;  // sin
  vmovupd ymmword ptr [r12+r11],ymm1; //cos
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,64;
  vzeroupper;
 @ende:
  pop r13;
  pop r12;
end;


{Res = cosec(Feld)}
function CosYSingle (const Feld :array of T8Single;
                       out Res  :array of T8Single):Longbool;
                      assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[rcx+r11];
  vmovups ymmword ptr [rsp],ymm0;
  mov     r10d,8;
  call    FN_COS_SINGLE;
  vmovups ymm0,ymmword ptr [rsp];
  vmovups ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,32;
  vzeroupper;
 @ende:
end;

{Res = Cos(Feld)}
function CosYDouble (const Feld :array of T4Double;
                       out Res  :array of T4Double):Longbool;
                      assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr[rcx+r11];
  vmovupd ymmword ptr [rsp],ymm0;
  mov     r10d,4;
  call    FN_COS_DOUBLE;
  vmovupd ymm0,ymmword ptr [rsp];
  vmovupd ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,32;
  vzeroupper;
 @ende:
end;


{Res = tan(Feld)}
function TanYSingle (const Feld :array of T8Single;
                       out Res  :array of T8Single):Longbool;
                      assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[rcx+r11];
  vmovups ymmword ptr [rsp],ymm0;
  mov     r10d,8;
  call    FN_TAN_SINGLE;
  vmovups ymm0,ymmword ptr [rsp];
  vmovups ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,32;
  vzeroupper;
 @ende:
end;

{Res = tan(Feld}
function TanYDouble (const Feld :array of T4Double;
                       out Res  :array of T4Double):Longbool;
                      assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr[rcx+r11];
  vmovupd ymmword ptr [rsp],ymm0;
  mov     r10d,4;
  call    FN_TAN_DOUBLE;
  vmovupd ymm0,ymmword ptr [rsp];
  vmovupd ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,32;
  vzeroupper;
 @ende:
end;

{Res = cotan(Feld)}
function CotanYSingle (const Feld :array of T8Single;
                       out   Res  :array of T8Single):Longbool;
                      assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[rcx+r11];
  vmovups ymmword ptr [rsp],ymm0;
  mov     r10d,8;
  call    FN_COTAN_SINGLE;
  vmovups ymm0,ymmword ptr [rsp];
  vmovups ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,32;
  vzeroupper;
 @ende:
end;

{Res = cotan(Feld)}
function CotanYDouble (const Feld :array of T4Double;
                       out   Res  :array of T4Double):Longbool;
                      assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr[rcx+r11];
  vmovupd ymmword ptr [rsp],ymm0;
  mov     r10d,4;
  call    FN_COTAN_DOUBLE;
  vmovupd ymm0,ymmword ptr [rsp];
  vmovupd ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,32;
  vzeroupper;
 @ende:
end;

{Res = arctan(Feld)}
function ArctanYSingle (const Feld :array of T8Single;
                        out   Res  :array of T8Single):Longbool;assembler;
                        nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //Res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,64;
  add  rdx,1;
  xor  r11,r11;
  vpcmpeqw xmm1,xmm1,xmm1;
  vpslld   xmm1,xmm1,25;
  vpsrld   xmm1,xmm1,2;         // 1.0
  vinsertf128 ymm1,ymm1,xmm1,1;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[rcx+r11];
  vmovups ymmword ptr [rsp],ymm0;
  vmovups ymmword ptr [rsp+32],ymm1;
  mov     r10d,8;
  call    FN_ARCTAN_Y_SINGLE;
  vmovups ymm0,ymmword ptr [rsp];
  vmovups ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,64;
  vzeroupper;
 @ende:
end;

{Res = arctan(Feld)}
function ArctanYDouble (const Feld :array of T4Double;
                          out Res  :array of T4Double):Longbool;assembler;
                        nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //Res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,64;
  add  rdx,1;
  xor  r11,r11;
  vpcmpeqw xmm1,xmm1,xmm1;
  vpsllq   xmm1,xmm1,54;
  vpsrlq   xmm1,xmm1,2;        // 1.0
  vinsertf128 ymm1,ymm1,xmm1,1;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr[rcx+r11];
  vmovupd ymmword ptr [rsp],ymm0;
  vmovupd ymmword ptr [rsp+32],ymm1;
  mov     r10d,4;
  call    FN_ARCTAN_Y_DOUBLE;
  vmovupd ymm0,ymmword ptr [rsp];
  vmovupd ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,64;
  vzeroupper;
 @ende:
end;

{Res = arcsin(Feld)}
function ArcsinYSingle (const Feld :array of T8Single;
                          out Res  :array of T8Single):Longbool;
                      assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //Res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,64;
  vpcmpeqw  xmm1,xmm1,xmm1;
  vpslld    xmm1,xmm1,25;
  vpsrld    xmm1,xmm1,2;
  vinsertf128 ymm1,ymm1,xmm1,1;  //set 1.0
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[rcx+r11];
  vaddps  ymm2,ymm0,ymm1;       // 1.0 + x
  vsubps  ymm3,ymm1,ymm0;       // 1.0 - x
  vmulps  ymm4,ymm2,ymm3;       // (1+x) * (1-x)
  vsqrtps ymm4,ymm4;            // sqrt(...)
  vmovups ymmword ptr [rsp],ymm0;
  vmovups ymmword ptr [rsp+32],ymm4;
  mov     r10d,8;
  call    FN_ARCTAN_Y_SINGLE;
  vmovups ymm0,ymmword ptr [rsp];
  vmovups ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,64;
  vzeroupper;
 @ende:
end;

{Res = arcsin(Feld)}
function ArcsinYDouble (const Feld :array of T4Double;
                          out Res  :array of T4Double):Longbool;
                      assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //Res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  vpcmpeqw  xmm1,xmm1,xmm1;
  vpsllq    xmm1,xmm1,54;
  vpsrlq    xmm1,xmm1,2;
  vinsertf128 ymm1,ymm1,xmm1,1;  //set 1.0
  sub  rsp,64;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr[rcx+r11];
  vaddpd  ymm2,ymm0,ymm1;       // 1.0 + x
  vsubpd  ymm3,ymm1,ymm0;       // 1.0 - x
  vmulpd  ymm4,ymm2,ymm3;       // (1+x) * (1-x)
  vsqrtpd ymm4,ymm4;            // sqrt(...)
  vmovupd ymmword ptr [rsp],ymm0;
  vmovupd ymmword ptr [rsp+32],ymm4;
  mov     r10d,4;
  call    FN_ARCTAN_Y_DOUBLE;
  vmovupd ymm0,ymmword ptr [rsp];
  vmovupd ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,64;
  vzeroupper;
 @ende:
end;

{Res = arccos(Feld)}
function ArccosYSingle (const Feld :array of T8Single;
                        out   Res  :array of T8Single):Longbool;
                      assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //Res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  vpcmpeqw  xmm1,xmm1,xmm1;
  vpslld    xmm1,xmm1,25;
  vpsrld    xmm1,xmm1,2;
  vinsertf128 ymm1,ymm1,xmm1,1;  //set 1.0
  sub  rsp,64;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[rcx+r11];
  vaddps  ymm2,ymm0,ymm1;       // 1.0 + x
  vsubps  ymm3,ymm1,ymm0;       // 1.0 - x
  vmulps  ymm4,ymm2,ymm3;       // (1+x) * (1-x)
  vsqrtps ymm4,ymm4;            // sqrt(...)
  vmovups ymmword ptr [rsp],ymm4;
  vmovups ymmword ptr [rsp+32],ymm0;
  mov     r10d,8;
  call    FN_ARCTAN_Y_SINGLE;
  vmovups ymm0,ymmword ptr [rsp];
  vmovups ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,64;
  vzeroupper;
 @ende:
end;

{Res = arccos(Feld)}
function ArccosYDouble (const Feld :array of T4Double;
                          out Res  :array of T4Double):Longbool;
                      assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //Res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  vpcmpeqw xmm1,xmm1,xmm1;
  vpsllq   xmm1,xmm1,54;
  vpsrlq   xmm1,xmm1,2;
  vinsertf128 ymm1,ymm1,xmm1,1;  //set 1.0
  sub  rsp,64;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr[rcx+r11];
  vaddpd  ymm2,ymm0,ymm1;       // 1.0 + x
  vsubpd  ymm3,ymm1,ymm0;       // 1.0 - x
  vmulpd  ymm4,ymm2,ymm3;       // (1+x) * (1-x)
  vsqrtpd ymm4,ymm4;            // sqrt(...)
  vmovupd ymmword ptr [rsp],ymm4;
  vmovupd ymmword ptr [rsp+32],ymm0;
  mov     r10d,4;
  call    FN_ARCTAN_Y_DOUBLE;
  vmovupd ymm0,ymmword ptr [rsp];
  vmovupd ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,64;
  vzeroupper;
 @ende:
end;

{Res = arccot(Feld)}
function ArcCotYSingle (const Feld :array of T8Single;
                        out   Res  :array of T8Single):Longbool;assembler;
                        nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //Res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,64;
  add  rdx,1;
  vpcmpeqw xmm1,xmm1,xmm1;
  vpslld   xmm1,xmm1,25;
  vpsrld   xmm1,xmm1,2;       //set 1.0
  vinsertf128 ymm1,ymm1,xmm1,1;
  xor r11,r11;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[rcx+r11];
  vmovups ymmword ptr [rsp+32],ymm0;
  vmovups ymmword ptr [rsp],ymm1;
  mov     r10d,8;
  call    FN_ARCTAN_Y_SINGLE;
  vmovups ymm0,ymmword ptr [rsp];
  vmovups ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,64;
  vzeroupper;
 @ende:
end;

{res = arccot(Feld)}
function ArcCotYDouble (const Feld :array of T4Double;
                        out   Res  :array of T4Double):Longbool;assembler;
                        nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //Res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,64;
  vpcmpeqw xmm1,xmm1,xmm1;
  vpsllq   xmm1,xmm1,54;
  vpsrlq   xmm1,xmm1,2;       //set 1.0
  vinsertf128 ymm1,ymm1,xmm1,1;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr[rcx+r11];
  vmovupd ymmword ptr [rsp+32],ymm0;
  vmovupd ymmword ptr [rsp],ymm1;
  mov     r10d,4;
  call    FN_ARCTAN_Y_DOUBLE;
  vmovupd ymm0,ymmword ptr [rsp];
  vmovupd ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,64;
  vzeroupper;
 @ende:
end;

{Res = sinh(Feld)}
function SinhYSingle (const Feld :array of T8Single;
                        out Res  :array of T8Single):Longbool;
                      assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //Res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[rcx+r11];
  vmovups ymmword ptr [rsp],ymm0;
  mov     r10d,8;
  call    FN_SINH_SINGLE;
  vmovups ymm0,ymmword ptr [rsp];
  vmovups ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,32;
  vzeroupper;
 @ende:
end;

{Res = sinh(Feld)}
function SinhYDouble (const Feld :array of T4Double;
                        out Res  :array of T4Double):Longbool;
                      assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //Res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr[rcx+r11];
  vmovupd ymmword ptr [rsp],ymm0;
  mov     r10d,4;
  call    FN_SINH_DOUBLE;
  vmovupd ymm0,ymmword ptr [rsp];
  vmovupd ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,32;
  vzeroupper;
 @ende:
end;

{Res = sech(Feld)}
function SechYSingle (const Feld :array of T8Single;
                        out Res  :array of T8Single):Longbool;
                      assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //Res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[rcx+r11];
  vmovups ymmword ptr [rsp],ymm0;
  mov     r10d,8;
  call    FN_SECH_SINGLE;
  vmovups ymm0,ymmword ptr [rsp];
  vmovups ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,32;
  vzeroupper;
 @ende:
end;

{Res = sech(Feld)}
function SechYDouble (const Feld :array of T4Double;
                       out  Res  :array of T4Double):Longbool;
                      assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //Res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr[rcx+r11];
  vmovupd ymmword ptr [rsp],ymm0;
  mov     r10d,4;
  call    FN_SECH_DOUBLE;
  vmovupd ymm0,ymmword ptr [rsp];
  vmovupd ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,32;
  vzeroupper;
 @ende:
end;

{Res = cosech(Feld)}
function CschYSingle (const Feld :array of T8Single;
                        out   Res  :array of T8Single):Longbool;
                      assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //Res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[rcx+r11];
  vmovups ymmword ptr [rsp],ymm0;
  mov     r10d,8;
  call    FN_COSECH_SINGLE;
  vmovups ymm0,ymmword ptr [rsp];
  vmovups ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,32;
  vzeroupper;
 @ende:
end;

{Res = cosech(Feld)}
function CschYDouble (const Feld :array of T4Double;
                          out Res  :array of T4Double):Longbool;
                      assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //Res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr[rcx+r11];
  vmovupd ymmword ptr [rsp],ymm0;
  mov     r10d,4;
  call    FN_COSECH_DOUBLE;
  vmovupd ymm0,ymmword ptr [rsp];
  vmovupd ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,32;
  vzeroupper;
 @ende:
end;

{Res = cosh(Feld)}
function CoshYSingle (const Feld :array of T8Single;
                        out Res  :array of T8Single):Longbool;
                      assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //Res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[rcx+r11];
  vmovups ymmword ptr [rsp],ymm0;
  mov     r10d,8;
  call    FN_COSH_SINGLE;
  vmovups ymm0,ymmword ptr [rsp];
  vmovups ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,32;
  vzeroupper;
 @ende:
end;

{Res = cosh(Feld)}
function CoshYDouble (const Feld :array of T4Double;
                        out Res  :array of T4Double):Longbool;
                      assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //Res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr[rcx+r11];
  vmovupd ymmword ptr [rsp],ymm0;
  mov     r10d,4;
  call    FN_COSH_DOUBLE;
  vmovupd ymm0,ymmword ptr [rsp];
  vmovupd ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,32;
  vzeroupper;
 @ende:
end;

{Res = tanh(Feld)}
function TanhYSingle (const Feld :array of T8Single;
                        out Res  :array of T8Single):Longbool;
                      assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //Res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[rcx+r11];
  vmovups ymmword ptr [rsp],ymm0;
  mov     r10d,8;
  call    FN_TANH_SINGLE;
  vmovups ymm0,ymmword ptr [rsp];
  vmovups ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,32;
  vzeroupper;
 @ende:
end;

{Res = tanh(Feld)}
function TanhYDouble (const Feld :array of T4Double;
                        out Res  :array of T4Double):Longbool;
                      assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //Res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr[rcx+r11];
  vmovupd ymmword ptr [rsp],ymm0;
  mov     r10d,4;
  call    FN_TANH_DOUBLE;
  vmovupd ymm0,ymmword ptr [rsp];
  vmovupd ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,32;
  vzeroupper;
 @ende:
end;

{Res = coth(Feld)}
function CothYSingle (const Feld :array of T8Single;
                        out Res  :array of T8Single):Longbool;
                      assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //Res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
  vpcmpeqw xmm2,xmm2,xmm2;
  vpslld   xmm2,xmm2,25;
  vpsrld   xmm2,xmm2,2;         // set 1.0
  vinsertf128 ymm2,ymm2,xmm2,1;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[rcx+r11];
  vmovups ymmword ptr [rsp],ymm0;
  mov     r10d,8;
  call    FN_TANH_SINGLE;
  vmovups ymm0,ymmword ptr [rsp];
  vdivps  ymm0,ymm2,ymm0;
  vmovups ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,32;
  vzeroupper;
 @ende:
end;

{Res = coth(Feld)}
function CothYDouble (const Feld :array of T4Double;
                        out Res  :array of T4Double):Longbool;
                      assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //Res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
  vpcmpeqw xmm2,xmm2,xmm2;
  vpsllq   xmm2,xmm2,54;
  vpsrlq   xmm2,xmm2,2;     //set 1.0;
  vinsertf128 ymm2,ymm2,xmm2,1;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr[rcx+r11];
  vmovupd ymmword ptr [rsp],ymm0;
  mov     r10d,4;
  call    FN_TANH_DOUBLE;
  vmovupd ymm0,ymmword ptr [rsp];
  vdivpd  ymm0,ymm2,ymm0;
  vmovupd ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,32;
  vzeroupper;
 @ende:
end;

{Res = arsinh(Feld)}
function ArSinhYSingle (const Feld :array of T8Single;
                        out   Res  :array of T8Single):Longbool;
                        assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //Res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
  vpcmpeqw xmm2,xmm2,xmm2;
  vpslld   xmm2,xmm2,25;
  vpsrld   xmm2,xmm2,2;         // set 1.0
  vinsertf128 ymm2,ymm2,xmm2,1;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[rcx+r11];
  vmovaps ymm1,ymm0;
  vmulps  ymm1,ymm1,ymm0;      // x^2
  vaddps  ymm1,ymm1,ymm2;      // + 1
  vsqrtps ymm1,ymm1;
  vaddps  ymm0,ymm1,ymm0;      // x + sqrt(1+x^2)
  vmovups ymmword ptr [rsp],ymm0;
  mov     r10d,8;
  call    FN_LN_SINGLE;
  vmovups ymm0,ymmword ptr [rsp];
  vmovups ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,32;
  vzeroupper;
 @ende:
end;

{Res = arsinh(Feld)}
function ArSinhYDouble (const Feld :array of T4Double;
                        out   Res  :array of T4Double):Longbool;
                        assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //Res
  mov r9, rcx;  //length
 {$ENDIF}
  xor rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp rdx,r9;
  jne @ende;
  mov rax,1;
  sub rsp,32;
  add rdx,1;
  xor r11,r11;
  vpcmpeqw xmm2,xmm2,xmm2;
  vpsllq   xmm2,xmm2,54;
  vpsrlq   xmm2,xmm2,2;     //set 1.0;
  vinsertf128 ymm2,ymm2,xmm2,1;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr[rcx+r11];
  vmovapd ymm1,ymm0;
  vmulpd  ymm1,ymm1,ymm0;      // x^2
  vaddpd  ymm1,ymm1,ymm2;      // + 1
  vsqrtpd ymm1,ymm1;
  vaddpd  ymm0,ymm1,ymm0;      // x + sqrt(1+x^2)
  vmovupd ymmword ptr [rsp],ymm0;
  mov     r10d,4;
  call    FN_LN_DOUBLE;
  vmovupd ymm0,ymmword ptr [rsp];
  vmovupd ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,32;
  vzeroupper;
 @ende:
end;

{Res = arcosh(Feld)}
function ArCoshYSingle (const Feld :array of T8Single;
                        out   Res  :array of T8Single):Longbool;
                        assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //Res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
  vpcmpeqw xmm2,xmm2,xmm2;
  vpslld   xmm2,xmm2,25;
  vpsrld   xmm2,xmm2,2;         // set 1.0
  vinsertf128 ymm2,ymm2,xmm2,1;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[rcx+r11];
  vmovaps ymm1,ymm0;
  vmulps  ymm1,ymm1,ymm0;      // x^2
  vsubps  ymm1,ymm1,ymm2;      // - 1
  vsqrtps ymm1,ymm1;
  vaddps  ymm0,ymm1,ymm0;      // x + sqrt(x^2-1)
  vmovups ymmword ptr [rsp],ymm0;
  mov     r10d,8;
  call    FN_LN_SINGLE;     // calc only the ln(x+sqrt(x^2-1)
  vmovups ymm0,ymmword ptr [rsp];
  vmovups ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,32;
  vzeroupper;
 @ende:
end;

{Res = arcosh(Feld)}
function ArCoshYDouble (const Feld :array of T4Double;
                        out   Res  :array of T4Double):Longbool;
                        assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //Res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
  vpcmpeqw xmm2,xmm2,xmm2;
  vpsllq   xmm2,xmm2,54;
  vpsrlq   xmm2,xmm2,2;     //set 1.0;
  vinsertf128 ymm2,ymm2,xmm2,1;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr[rcx+r11];
  vmovapd ymm1,ymm0;
  vmulpd  ymm1,ymm1,ymm0;      // x^2
  vsubpd  ymm1,ymm1,ymm2;      // - 1
  vsqrtpd ymm1,ymm1;
  vaddpd  ymm0,ymm1,ymm0;      // x + sqrt(x^2-1)
  vmovupd ymmword ptr [rsp],ymm0;
  mov     r10d,4;
  call    FN_LN_DOUBLE;    // calc only the ln(x+sqrt(x^2-1)
  vmovupd ymm0,ymmword ptr [rsp];
  vmovupd ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,32;
  vzeroupper;
 @ende:
end;

{Res = artanh(Feld)}
function ArTanhYSingle (const Feld :array of T8Single;
                        out   Res  :array of T8Single):Longbool;
                        assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //Res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
  vpcmpeqw xmm2,xmm2,xmm2;
  vpslld   xmm2,xmm2,25;
  vpsrld   xmm2,xmm2,2;         // set 1.0
  vinsertf128 ymm2,ymm2,xmm2,1;
  vpcmpeqw xmm3,xmm3,xmm3;
  vpslld   xmm3,xmm3,26;
  vpsrld   xmm3,xmm3,2;              // set 0.5
  vinsertf128 ymm3,ymm3,xmm3,1;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr[rcx+r11];
  vmovaps ymm1,ymm0;
  vaddps  ymm1,ymm2,ymm0;      // 1 + x
  vsubps  ymm4,ymm2,ymm0;      // 1 - x;
  vdivps  ymm0,ymm1,ymm4;      // (1+x) / (1-x)
  vmovups ymmword ptr [rsp],ymm0;
  mov     r10d,8;
  call    FN_LN_SINGLE;     // calc only the ln(ymm0)
  vmovups ymm0,ymmword ptr [rsp];
  vmulps  ymm0,ymm0,ymm3;       // 1/2 * result
  vmovups ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,32;
  vzeroupper;
 @ende:
end;

{Res = artanh(Feld)}
function ArTanhYDouble (const Feld :array of T4Double;
                        out   Res  :array of T4Double):Longbool;
                        assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;  //Feld
  mov rdx,rsi;  //length
  mov r8, rdx;  //Res
  mov r9, rcx;  //length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  sub  rsp,32;
  add  rdx,1;
  xor  r11,r11;
  vpcmpeqw xmm2,xmm2,xmm2;
  vpsllq   xmm2,xmm2,54;
  vpsrlq   xmm2,xmm2,2;       //set 1.0;
  vinsertf128 ymm2,ymm2,xmm2,1;
  vpcmpeqw xmm3,xmm3,xmm3;
  vpsllq   xmm3,xmm3,55;
  vpsrlq   xmm3,xmm3,2;       // set 0.5
  vinsertf128 ymm3,ymm3,xmm3,1;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr[rcx+r11];
  vmovapd ymm1,ymm0;
  vaddpd  ymm1,ymm2,ymm0;      // 1 + x
  vsubpd  ymm4,ymm2,ymm0;      // 1 - x;
  vdivpd  ymm0,ymm1,ymm4;      // (1+x) / (1-x)
  vmovupd ymmword ptr [rsp],ymm0;
  mov     r10d,4;
  call    FN_LN_DOUBLE;    // calc only the ln(ymm0)
  vmovupd ymm0,ymmword ptr [rsp];
  vmulpd  ymm0,ymm0,ymm3;     // 1/2 * result
  vmovupd ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
  add  rsp,32;
  vzeroupper;
 @ende:
end;

{--------------------------rounding---------------------------------------}


{round to integer; result is single}
procedure RoundYSingle (var Feld :array of T8Single);assembler;nostackframe;

asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  xor r11,r11;
align 16;
 @Loop:
  vroundps ymm0,ymmword ptr [rcx+r11],$0;
  vmovups  ymmword ptr [rcx+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{round to integer with chop; result is single}
procedure TruncateYSingle (var Feld :array of T8Single);assembler;nostackframe;

asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  xor r11,r11;
align 16;
 @Loop:
  vroundps ymm0,ymmword ptr [rcx+r11],$3;
  vmovups  ymmword ptr [rcx+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{round to integer to -oo ; result is single}
procedure FloorYSingle (var Feld :array of T8Single);assembler;nostackframe;

 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  xor r11,r11;
align 16;
 @Loop:
  vroundps ymm0,ymmword ptr [rcx+r11],$1;                   // -oo
  vmovups  ymmword ptr [rcx+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{round to integer to +oo; result is single}
procedure CeilYSingle (var Feld :array of T8Single);assembler;nostackframe;

 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  xor r11,r11;
align 16;
 @Loop:
  vroundps ymm0,ymmword ptr [rcx+r11],$2;                     // +oo
  vmovups  ymmword ptr [rcx+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{round to integer to nearest; result is double}
procedure RoundYDouble (var Feld :array of T4Double);assembler;nostackframe;

 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  xor r11,r11;
align 16;
 @Loop:
  vroundpd ymm0,ymmword ptr [rcx+r11],$0;
  vmovupd  ymmword ptr [rcx+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{round to integer with chop; result is double}
procedure TruncateYDouble (var Feld :array of T4Double);assembler;nostackframe;

 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  xor r11,r11;
align 16;
 @Loop:
  vroundpd ymm0,ymmword ptr [rcx+r11],$3;
  vmovupd  ymmword ptr [rcx+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{round to integer to -oo; result is double}
procedure FloorYDouble (var Feld :array of T4Double);assembler;nostackframe;

 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  xor r11,r11;
align 16;
 @Loop:
  vroundpd ymm0,ymmword ptr [rcx+r11],$1; // -oo
  vmovupd  ymmword ptr [rcx+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{round to integer to +oo; result is double}
procedure CeilYDouble (var Feld :array of T4Double);assembler;nostackframe;

 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  add  rdx,1;
  xor r11,r11;
align 16;
 @Loop:
  vroundpd ymm0,ymmword ptr [rcx+r11],$2;  //+oo
  vmovupd  ymmword ptr [rcx+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{round a single by digits; round nearest}
procedure RoundYSingle (var Feld :array of T8Single; Digits :Byte);
  assembler;nostackframe;

 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;    //Feld
  mov rdx,rsi;    //length
  mov r8, rdx;    //digits
 {$ENDIF}
  test  rdx,rdx;      // value < 0 not valid
  js    @ende;
  test  r8b,r8b;
  jz    @ende;
  movzx eax,r8b;
  cmp   eax,6;        // only 6 digits
  jbe   @1;
  mov   eax,6;
 @1:
  sub   eax,1;
  lea r10,dword ptr [rip+Potenz10_S];
  vbroadcastss ymm1,[r10+rax*4];
  lea r9,dword ptr [rip+SPotenz10];
  vbroadcastss ymm2,[r9+rax*4];
  mov rax,6;
  vbroadcastss ymm5,[r9+rax*4];
  add rdx,1;
  xor r11,r11;
align 16;
 @Loop:
  vmovups  ymm0,ymmword ptr [rcx+r11];
  vmulps   ymm0,ymm0,ymm1;
  vroundps ymm0,ymm0,0;         // round to integer as float
  vmulps   ymm0,ymm0,ymm2;
  vaddps   ymm0,ymm0,ymm5;     // add up +1.0E-7
  vmovups  ymmword ptr [rcx+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{round single value by digits. convert in double round and convert in single.
 better rounding.}
function RoundYSingle (constref Value :Single; Digits :Byte):Single;
  assembler;nostackframe;

 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;    //Value
  mov rdx,rsi;    //Digits
  mov r8, rdx;
 {$ENDIF}
  vxorps ymm0,ymm0,ymm0;
  test  dl,dl;
  jz    @ende;
  movzx eax,dl;
  cmp   eax,6;        // max 6 digits
  jbe   @1;
  mov   eax,6;
 @1:
  sub   eax,1;
  lea   r10,qword ptr [rip+Potenz10_D];
  movq  xmm1,[r10+rax*8];
  lea   r9,qword ptr [rip+DPotenz10];
  movq  xmm2,[r9+rax*8];
  vmovss    xmm0,[rcx];
  vcvtss2sd xmm0,xmm0,xmm0;       // single in double
  vmulsd    xmm0,xmm0,xmm1;
  vroundsd  xmm0,xmm0,xmm0,0;     // round to integer as double
  vmulsd    xmm0,xmm0,xmm2;
  vcvtsd2ss xmm0,xmm0,xmm0;       // convert in single
 @ende:
  vzeroupper;
end;

{round array by digits; round nearest}
procedure RoundYDouble (var Feld :array of T4Double; Digits :Byte);
  assembler;nostackframe;

 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;    //Feld
  mov rdx,rsi;    //length
  mov r8, rdx;    //digits
 {$ENDIF}
  test  rdx,rdx;                     // value < 0 not valid
  js    @ende;
  test  r8b,r8b;
  jz    @ende;
  movzx eax,r8b;
  cmp   eax,15;         // only 15 digits for rounding
  jbe   @1;
  mov   eax,15;
 @1:
  sub  eax,1;
  lea r10,qword ptr [rip+Potenz10_D];
  vbroadcastsd ymm1,[r10+rax*8];
  lea r9,qword ptr [rip+DPotenz10];
  vbroadcastsd ymm2,[r9+rax*8];
  mov rax,14;
  vbroadcastsd ymm5,[r9+rax*8];
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovupd  ymm0,ymmword ptr [rcx+r11];
  vmulpd   ymm0,ymm0,ymm1;
  vroundpd ymm0,ymm0,0;
  vmulpd   ymm0,ymm0,ymm2;
  vaddpd   ymm0,ymm0,ymm5;     // round up +1.0E-14
  vmovupd  ymmword ptr [rcx+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{round a value by digits; round nearest}
function RoundYDouble (constref Value :Double; Digits :Byte):Double;
  assembler;nostackframe;

 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;    //Value
  mov rdx,rsi;    //Digits
  mov r8, rdx;
 {$ENDIF}
  vxorpd ymm0,ymm0,ymm0;
  test  dl,dl;
  jz    @ende;
  movzx eax,dl;
  cmp   eax,15;         // only 15 digits for rounding
  jbe   @1;
  mov   eax,15;
 @1:
  sub   eax,1;
  lea   r10,qword ptr [rip+Potenz10_D];
  movq  xmm1,[r10+rax*8];
  lea   r9,qword ptr [rip+DPotenz10];
  movq  xmm2,[r9+rax*8];
  vmovsd  xmm0,[rcx];
  vmulsd  xmm0,xmm0,xmm1;
  vroundsd xmm0,xmm0,xmm0,0;
  vmulsd  xmm0,xmm0,xmm2;
  vzeroupper;
 @ende:
end;

{round array by digits; round chop}
procedure RoundChopYSingle (var Feld :array of T8Single; Digits :Byte);
  assembler;nostackframe;

 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;    //Feld
  mov rdx,rsi;    //length
  mov r8, rdx;    //digits
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  test  r8b,r8b;
  jz    @ende;
  movzx eax,r8b;
  cmp   eax,6;        // only 6 digits
  jbe   @1;
  mov   eax,6;
 @1:
  sub   eax,1;
  lea r10,dword ptr [rip+Potenz10_S];
  vbroadcastss ymm1,[r10+rax*4];
  lea r9,dword ptr [rip+SPotenz10];
  vbroadcastss ymm2,[r9+rax*4];
  mov rax,5;
  vbroadcastss ymm5,[r9+rax*4];
  add rdx,1;
  xor r11,r11;
align 16;
@Loop:
  vmovups  ymm0,ymmword ptr [rcx+r11];
  vmulps   ymm0,ymm0,ymm1;
  vroundps ymm0,ymm0,$3;       // truncate
  vmulps   ymm0,ymm0,ymm2;
  vaddps   ymm0,ymm0,ymm5;      // round up +1.0e-6
  vmovups  ymmword ptr [rcx+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{chop single value, convert to double and chop then convert to single.
 Better rounding!}
function RoundChopYSingle (constref Value :Single; Digits :Byte):Single;
  assembler;nostackframe;

 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;    // Feld
  mov rdx,rsi;    // digits
  mov r8, rdx;
 {$ENDIF}
  vxorps ymm0,ymm0,ymm0;
  test dl,dl;
  jz   @ende;
  movzx eax,dl;
  cmp  eax,6;        // only 6 digits
  jbe  @1;
  mov  eax,6;
 @1:
  sub   eax,1;
  lea   r10,qword ptr [rip+Potenz10_D];
  movq  xmm1,qword ptr [r10+rax*8];
  lea   r9,qword ptr [rip+DPotenz10];
  movq  xmm2,dword ptr [r9+rax*8];
  vmovss    xmm0,dword ptr [rcx];
  vcvtss2sd xmm0,xmm0,xmm0;       // make double
  vmulsd    xmm0,xmm0,xmm1;
  vroundsd  xmm0,xmm0,xmm0,$3;       // truncate
  vmulsd    xmm0,xmm0,xmm2;
  vcvtsd2ss xmm0,xmm0,xmm0;
  vzeroupper;
 @ende:
end;

{round array by digits; round chop}
procedure RoundChopYDouble (var Feld :array of T4Double; Digits :Byte);
  assembler;nostackframe;

 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;    //Feld
  mov rdx,rsi;    //length
  mov r8, rdx;    //digits
 {$ENDIF}
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  test  r8b,r8b;
  jz    @ende;
  movzx eax,r8b;
  cmp   eax,15;        // only 15 digits
  jbe   @1;
  mov   eax,15;
 @1:
  sub   eax,1;
  lea r10,qword ptr [rip+Potenz10_D];
  vbroadcastsd ymm1,[r10+rax*8];
  lea r9,qword ptr [rip+DPotenz10];
  vbroadcastsd ymm2,[r9+rax*8];
  mov rax,14;
  vbroadcastsd ymm5,[r9+rax*8];  // for rounding
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr [rcx+r11];
  vmulpd  ymm0,ymm0,ymm1;
  vroundpd ymm0,ymm0,$3;    //truncate
  vmulpd  ymm0,ymm0,ymm2;
  vaddpd  ymm0,ymm0,ymm5;   // Round up +1.0E-14
  vmovupd ymmword ptr [rcx+r11],ymm0;
  add r11,32;
  sub rdx,1;
  jnz @Loop;
  vzeroupper;
 @ende:
end;

{round a value by digits; round chop}
function RoundChopYDouble (constref Value :Double; Digits :Byte):Double;
  assembler;nostackframe;

 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;    //Value
  mov rdx,rsi;    //digits
  mov r8, rdx;
 {$ENDIF}
  vxorpd ymm0,ymm0,ymm0;
  test  dl,dl;
  jz    @ende;
  movzx eax,dl;
  cmp   eax,15;        // only 15 digits
  jbe   @1;
  mov   eax,15;
 @1:
  sub   eax,1;
  lea   r10,qword ptr [rip+Potenz10_D];
  movq  xmm1,qword ptr [r10+rax*8];
  lea   r9,qword ptr [rip+DPotenz10];
  movq  xmm2,qword ptr [r9+rax*8];
  vmovsd   xmm0,[rcx];
  vmulsd   xmm0,xmm0,xmm1;
  vroundsd xmm0,xmm0,xmm0,$3;    //truncate
  vmulsd   xmm0,xmm0,xmm2;
  vzeroupper;
 @ende:
end;


{-------------------------logical-----------------------------------------}


// test are ALL values in Feld of zeros
function TestYSingle (const Feld :T8Single):Boolean;assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vmovups ymm0,ymmword ptr [rcx];
  vptest  ymm0,ymm0; // set ZF flag ymm0 not changed
  setz    al;
  vzeroupper;
end;

function TestYDouble (const Feld :T4Double):Boolean;assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vmovupd ymm0,ymmword ptr [rcx];
  vptest  ymm0,ymm0; // set ZF flag ymm0 not changed
  setz    al;
  vzeroupper;
end;



{------------------------compare------------------------------------------}

{True when a = b}
function CmpYSingleEQ (const a,b :T8Single):T8YBool;assembler;nostackframe;
asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rdx;
 {$ENDIF}
  vmovups ymm0,ymmword ptr [rdx];
  vcmpps  ymm0,ymm0,ymmword ptr [r8],0;
  vmovdqu ymmword ptr [rcx],ymm0;
  vzeroupper;
end;

{True when a < b}
function CmpYSingleLT (const a,b :T8Single):T8YBool;assembler;nostackframe;

asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vmovups ymm0,ymmword ptr [rdx];
  vcmpps  ymm0,ymm0,ymmword ptr [r8],$1;
  vmovdqu ymmword ptr [rcx],ymm0;
  vzeroupper;
end;

{True when a <= b}
function CmpYSingleLE (const a,b :T8Single):T8YBool;assembler;nostackframe;

asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vmovups ymm0,ymmword ptr [rdx];
  vcmpps  ymm0,ymm0,ymmword ptr [r8],$2;
  vmovdqu ymmword ptr [rcx],ymm0;
  vzeroupper;
end;

{True when a > b}
function CmpYSingleGT (const a,b :T8Single):T8YBool;assembler;nostackframe;

asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vmovups ymm0,ymmword ptr [rdx];
  vcmpps  ymm0,ymm0,ymmword ptr [r8],$6; // emulate GT is not LT or EQ
  vmovdqu ymmword ptr [rcx],ymm0;
  vzeroupper;
end;

{True when a >= b}
function CmpYSingleGE (const a,b :T8Single):T8YBool;assembler;nostackframe;
asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vmovups ymm0,ymmword ptr [rdx];
  vcmpps  ymm0,ymm0,ymmword ptr [r8],$5; // xmm0 >= xmm1
  vmovdqu ymmword ptr [rcx],ymm0;
  vzeroupper;
end;

{True when a = b}
function CmpYDoubleEQ (const a,b :T4Double):T4YBool;assembler;nostackframe;

asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vmovupd ymm0,ymmword ptr [rdx];
  vcmppd  ymm0,ymm0,ymmword ptr [r8],0;
  vmovdqu ymmword ptr [rcx],ymm0;
  vzeroupper;
end;

{True when a < b}
function CmpYDoubleLT (const a,b :T4Double):T4YBool;assembler;nostackframe;

asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vmovupd ymm0,ymmword ptr [rdx];
  vcmppd  ymm0,ymm0,ymmword ptr [rdx+32],$1;
  vmovdqu ymmword ptr [rcx],ymm0;
  vzeroupper;
end;

{True when a <= b}
function CmpYDoubleLE (const a,b :T4Double):T4YBool;assembler;nostackframe;

asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vmovupd ymm0,ymmword ptr [rdx];
  vcmppd  ymm0,ymm0,ymmword ptr [r8],$2; // ymm0 < ymm1
  vmovdqu ymmword ptr [rcx],ymm0;
  vzeroupper;
end;

{True when a > b}
function CmpYDoubleGT (const a,b :T4Double):T4YBool;assembler;nostackframe;

asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vmovupd ymm0,ymmword ptr [rdx];
  vcmppd  ymm0,ymm0,ymmword ptr [r8],$6; // emulate GT is not LT or EQ
  vmovdqu ymmword ptr [rcx],ymm0;
  vzeroupper;
end;

{True when a >= b}
function CmpYDoubleGE (const a,b :T4Double):T4YBool;assembler;nostackframe;
asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vmovupd ymm0,ymmword ptr [rdx];
  vcmppd  ymm0,ymm0,ymmword ptr [r8],$5; // xmm0 >= xmm1
  vmovdqu ymmword ptr [rcx],ymm0;
  vzeroupper;
end;


{--------------------------convert-----------------------------------------}

{convert Single in Longint }
function ConvertYSingleToInt32 (const Feld :T8Single):T8Int32;assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vcvtps2dq ymm0,ymmword ptr [rdx];
  vmovdqu   ymmword ptr [rcx],ymm0;
  vzeroupper;
end;

{convert Single in Double }
function ConvertYSingleToDouble (const Feld :T4Single):T4Double;assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vcvtps2pd ymm0,xmmword ptr [rdx];
  vmovdqu ymmword ptr [rcx],ymm0;
  vzeroupper;
end;

{convert double in Longint }
function ConvertYDoubleToInt32 (const Feld :T4Double):T4Int32;assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi; //result
  mov rdx,rsi; //Feld
  mov r8, rdx; //length
 {$ENDIF}
  DB $C5,$FF,$E6,$02
//  vcvtpd2dq xmm0,ymmword ptr [rdx];
  vmovdqu xmmword ptr [rcx],xmm0;
  vzeroupper;
end;

{convert double in single}
function ConvertYDoubleToSingle (const Feld :T4Double):T4Single;assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  DB $C5,$FD,$5A,$02
  //vcvtpd2ps xmm0,ymmword ptr [rdx];
  vmovdqu xmmword ptr [rcx],xmm0;
  vzeroupper;
end;

{convert Longint in single}
function ConvertYInt32ToSingle (const Feld :T8Int32):T8Single;assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vcvtdq2ps ymm0,ymmword ptr [rdx];
  vmovups ymmword ptr [rcx],ymm0;
  vzeroupper;
end;

{convert Longint in double}
function ConvertYInt32ToDouble (const Feld :T4Int32):T4Double;assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vcvtdq2pd ymm0,xmmword ptr [rdx];
  vmovupd ymmword ptr [rcx],ymm0;
  vzeroupper;
end;

{convert Single by chop in Longint }
function ChopYSingleToInt32 (const Feld :T8Single):T8Int32;assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vcvttps2dq ymm0,ymmword ptr [rdx];
  vmovdqu ymmword ptr [rcx],ymm0;
  vzeroupper;
end;

{convert double by chop in Longint }
function ChopYDoubleToInt32 (const Feld :T4Double):T4Int32;assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  DB $C5,$FD,$E6,$02
  //vcvttpd2dq xmm0,ymmword ptr [rdx];
  vmovdqu xmmword ptr [rcx],xmm0;
  vzeroupper;
end;


{convert Single in Longint }
function ConvertYSingleToInt32 (const Feld :array of T8Single;
                                  out Res  :array of T8Int32) :Longbool;
                                assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;    // feld
  mov rdx,rsi;    // length
  mov r8, rdx;    // res
  mov r9, rcx;
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vcvtps2dq ymm0,ymmword ptr [rcx+r11];
  vmovdqu   ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @loop;
 @ende:
end;

{convert Single in Double }
function ConvertYSingleToDouble (const Feld :array of T8Single;
                                   out Res  :array of T4Double):Longbool;
                                assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;
  js   @ende;
  test r9,r9;
  js   @ende;
  add  rdx,1;
  add  r9,1;
  shr  r9,1;  //div 2
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  xor  r10,r10;
  xor  r11,r11;
align 16;
 @Loop:
  vcvtps2pd ymm0,xmmword ptr [rcx+r11];
  vmovupd   ymmword ptr [r8+r10],ymm0;
  add  r11,16;
  add  r10,32;
  vcvtps2pd ymm0,xmmword ptr [rcx+r11];
  vmovupd   ymmword ptr [r8+r10],ymm0;
  add  r11,16;
  add  r10,32;
  sub  rdx,1;
  jnz  @Loop;
 @ende:
end;

{convert double in Longint }
function ConvertYDoubleToInt32 (const Feld :array of T4Double;
                                  out Res  :array of T4Int32):Longbool;
                      assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi; //Feld
  mov rdx,rsi; //length
  mov r8, rdx; //Res
  mov r9, rcx;
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor  r10,r10;
  xor  r11,r11;
align 16;
 @Loop:
  DB $C4,$A1,$7F,$E6,$04,$11
  //vcvtpd2dq xmm0,ymmword ptr [rcx+r10];
  vmovdqu   xmmword ptr [r8+r11],xmm0;
  add  r10,32;
  add  r11,16;
  sub  rdx,1;
  jnz  @loop;
 @ende:
end;

{convert double in single}
function ConvertYDoubleToSingle (const Feld :array of T4Double;
                                   out Res  :array of T4Single):longbool;
                           assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor  r10,r10;
  xor  r11,r11;
align 16;
 @Loop:
  DB $C4,$A1,$7D,$5A,$04,$11
  //vcvtpd2ps xmm0,ymmword ptr [rcx+r10];
  vmovups xmmword ptr [r8+r11],xmm0;
  add  r10,32;
  add  r11,16;
  sub  rdx,1
  jnz  @loop;
 @ende:
end;

{convert Longint in single}
function ConvertYInt32ToSingle (const Feld :array of T8Int32;
                                  out Res  :array of T8Single):Longbool;
                        assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;    // Feld
  mov rdx,rsi;    // length
  mov r8, rdx;    // Res
  mov r9, rcx;    // length
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vcvtdq2ps ymm0,ymmword ptr [rcx+r11];
  vmovups   ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
 @ende:
end;

{convert Longint in double}
function ConvertYInt32ToDouble (const Feld :array of T8Int32;
                                  out Res  :array of T4Double):Longbool;
                            assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;
  js   @ende;
  test r9,r9;
  js   @ende;
  add  rdx,1;
  add  r9,1;
  shr  r9,1;  // div 2
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  xor  r10,r10;
  xor  r11,r11;
align 16;
 @Loop:
  vcvtdq2pd ymm0,xmmword ptr [rcx+r10];
  vmovupd   ymmword ptr [r8+r11],ymm0;
  add  r10,16
  add  r11,32;
  vcvtdq2pd ymm0,xmmword ptr [rcx+r10];
  vmovupd   ymmword ptr [r8+r11],ymm0;
  add  r10,16
  add  r11,32;
  sub  rdx,1;
  jnz  @loop;
 @ende:
end;

{convert Single by chop in Longint }
function ChopYSingleToInt32 (const Feld :array of T8Single;
                               out Res  :array of T8Int32):longbool;
                             assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vcvttps2dq ymm0,ymmword ptr [rcx+r11];
  vmovdqu ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;
 @ende:
end;

{convert double by chop in Longint }
function ChopYDoubleToInt32 (const Feld :array of T4Double;
                               out Res  :array of T4Int32):Longbool;
                             assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
  mov r9, rcx;
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor  r10,r10;
  xor  r11,r11;
align 16;
 @Loop:
  DB $C4,$A1,$7D,$E6,$04,$11
  //vcvttpd2dq xmm0,ymmword ptr [rcx+r10];
  vmovdqu xmmword ptr [r8+r11],xmm0;
  add  r10,32;
  add  r11,16;
  sub  rdx,1;
  jnz  @Loop;
 @ende:
end;


{-------------------------diverses----------------------------------------}

{extract the sign of the T8Single as bit array of Longint}
function SignExtractYSingle (const Feld :T8Single):Longint;
                             assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vmovups ymm0,ymmword ptr [rcx];
  vmovmskps eax,ymm0;  // sign is in ax
  vzeroupper;
end;

{extract the sign of the T4Double as bit array of Longint}
function SignExtractYDouble (const Feld :T4Double):Longint;assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;
  mov rdx,rsi;
  mov r8, rdx;
 {$ENDIF}
  vmovupd ymm0,ymmword ptr [rcx];
  vmovmskpd eax,ymm0;  // sign is in al
  vzeroupper;
end;

{Test the array of values +/-oo and give a boolean result}
function Is_InfYSingle (const Feld :T8Single):T8YBool;
     assembler; nostackframe;
asm
  vmovups ymm0,ymmword ptr[rdx];
  vbroadcastf128 ymm3,xmmword ptr [rip+QNANS16];
  vbroadcastf128 ymm2,xmmword ptr [rip+_QNANS16];
  vcmpps  ymm1,ymm0,ymm3,0; // +oo
  vcmpps  ymm2,ymm0,ymm2,0; // -oo
  vorps   ymm0,ymm1,ymm2;
  vmovdqu ymmword ptr[rcx],ymm0;
  vzeroupper;
end;

{Test the array of values +/-oo and give a boolean result}
function Is_InfYDouble (const Feld :T4Double):T4YBool;
     assembler; nostackframe;
asm
  vmovupd ymm0,ymmword ptr[rdx];
  vbroadcastf128 ymm3,xmmword ptr [rip+QNAND16];
  vbroadcastf128 ymm2,xmmword ptr [rip+_QNAND16];
  vcmppd  ymm2,ymm0,ymm3,0; // +oo
  vcmppd  ymm3,ymm0,ymm2,0; // -oo
  DB $C5,$ED,$56,$C3
  //vorpd    ymm0,ymm2,ymm3;
  vmovdqu  ymmword ptr[rcx],ymm0;
  vzeroupper;
end;

{Test the array of NAN (not a number) values and give a boolean result}
function Is_NANYSingle (const Feld :T8Single):T8YBool;assembler;nostackframe;
asm
  vmovups ymm0,ymmword ptr[rdx];
  vcmpps  ymm1,ymm0,ymm0,$3;
  vmovdqu ymmword ptr[rcx],ymm1;
  vzeroupper;
end;

{Test the array of NAN (not a number) values and give a boolean result}
function Is_NANYDouble (const Feld :T4Double):T4YBool;assembler;nostackframe;
asm
  vmovupd ymm0,ymmword ptr[rdx];
  vcmppd  ymm1,ymm0,ymm0,$3;
  vmovdqu ymmword ptr[rcx],ymm1;
  vzeroupper;
end;


{------------------------statistic functions------------------------------}

{Calculate statistical datas of the array.}
procedure StatCalcYSingle (const Feld :array of T8Single; Count :Longint;
                           out average,sDev,variance,skew,Excess :Single);
                           assembler;
 asm
  push r12;
  push r13;
  push r14;
  push r15;
 {$IFNDEF WIN64}
  mov r12,r8;         //sdev
  mov r13,r9;         //variance
  mov rcx,rdi;        //Feld
  mov rdx,rsi;        //length
  mov r8, rdx;        //count
  mov r9, rcx;        //average
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr[sdev];
  mov r13,qword ptr[variance];
  sub rsp,64;
  vmovdqu ymmword ptr [rsp],ymm6;
  vmovdqu ymmword ptr [rsp+32],ymm7;
 {$ENDIF}
  mov r14,qword ptr[skew];
  mov r15,qword ptr[Excess];
  vxorps ymm0,ymm0,ymm0;
  vmovss dword ptr [r9],xmm0;
  vmovss dword ptr [r12],xmm0;
  vmovss dword ptr [r13],xmm0;
  vmovss dword ptr [r14],xmm0;
  vmovss dword ptr [r15],xmm0;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  test r8d,r8d;
  jz   @ende;
  jns  @1;
  neg  r8d;
 @1:
  cmp r8d,8;                    // min 8 value needed
  jb  @ende;
  vmovd   xmm7,r8d;
  vpshufd xmm7,xmm7,0;
  vinsertf128 ymm7,ymm7,xmm7,1;
  vcvtdq2ps ymm7,ymm7;        // convert longint in single
  add  rdx,1;
  mov  r10,rdx;
  xor  r11,r11;

align 16;
 @Loop:
  vaddps ymm0,ymm0,ymmword ptr [rcx+r11];
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;

  vhaddps ymm0,ymm0,ymm0;
  vhaddps ymm0,ymm0,ymm0;
  vextractf128 xmm1,ymm0,1;
  vaddps  xmm0,xmm0,xmm1;
  vinsertf128 ymm0,ymm0,xmm0,1;

  vdivps ymm0,ymm0,ymm7;    // average

  // calculate statistik (skew,excess,standard deviation,variance)
  xor    r11,r11;
  vxorps ymm2,ymm2,ymm2;   // for sum(x-xm)**2
  vxorps ymm3,ymm3,ymm3;   // for sum(x-xm)**3
  vxorps ymm4,ymm4,ymm4;   // for sum(x-xm)**4

  vpcmpeqw xmm5,xmm5,xmm5;
  vpslld   xmm5,xmm5,31;
  vinsertf128 ymm5,ymm5,xmm5,1;
  vxorps   ymm6,ymm0,ymm5;   // set xm to -xm for compare

align 16;
 @Loop1:
  vmovups ymm1,ymmword ptr[rcx+r11];
  vsubps  ymm1,ymm1,ymm0;    // (x-xm)
  vmovaps ymm5,ymm1;
  vmulps  ymm5,ymm5,ymm1;    // (x-xm)**2
  vaddps  ymm2,ymm2,ymm5;
  vmulps  ymm5,ymm5,ymm1     // (x-xm)**3
  vaddps  ymm3,ymm3,ymm5;
  vmulps  ymm5,ymm5,ymm1     // (x-xm)**4
  vaddps  ymm4,ymm4,ymm5;
  add     r11,32;
  sub     r10,1;
  cmp     r10,1;            // for last round
  jne     @Loop1

  {Only zeros on the last round are fill values.}
  vmovups ymm1,ymmword ptr[rcx+r11];
  vsubps  ymm1,ymm1,ymm0;    // (x-xm)
  vcmpps  ymm5,ymm1,ymm6,0;  // search of -xm  (0-xm) = -xm
  vandnps ymm1,ymm5,ymm1;    // set value (0-xm) = -xm to 0!
  vmovaps ymm5,ymm1;
  vmulps  ymm5,ymm5,ymm1;    // (x-xm)**2
  vaddps  ymm2,ymm2,ymm5;
  vmulps  ymm5,ymm5,ymm1     // (x-xm)**3
  vaddps  ymm3,ymm3,ymm5;
  vmulps  ymm5,ymm5,ymm1     // (x-xm)**4
  vaddps  ymm4,ymm4,ymm5;

  vhaddps ymm2,ymm2,ymm2;     // calculate the summ
  vhaddps ymm2,ymm2,ymm2;
  vextractf128 xmm1,ymm2,1;
  vaddps  xmm2,xmm2,xmm1;
  vhaddps ymm3,ymm3,ymm3;
  vhaddps ymm3,ymm3,ymm3;
  vextractf128 xmm1,ymm3,1;
  vaddps  xmm3,xmm3,xmm1;
  vhaddps ymm4,ymm4,ymm4;
  vhaddps ymm4,ymm4,ymm4;
  vextractf128 xmm1,ymm4,1;
  vaddps  xmm4,xmm4,xmm1;

  vmovss dword ptr [r9],xmm0;  //average

  vpcmpeqw xmm1,xmm1,xmm1;
  vpslld  xmm1,xmm1,25;
  vpsrld  xmm1,xmm1,2;       // set 1.0
  vsubss  xmm5,xmm7,xmm1;    // n-1
  vdivss  xmm1,xmm2,xmm5;    // sum(x-xm)**2/(n-1)  variance
  vmovss  [r13],xmm1;        // variance
  vsqrtss xmm1,xmm1,xmm1;
  vmovss  dword ptr [r12],xmm1; // sdev

  vdivss  xmm2,xmm2,xmm7;    // sum(x-xm)**2/n
  vsqrtss xmm5,xmm2,xmm2;
  vmulss  xmm1,xmm5,xmm2;    // s**3
  vmulss  xmm1,xmm1,xmm7;    // n*s**3
  vdivss  xmm3,xmm3,xmm1;    // skew
  vmovss  dword ptr [r14],xmm3;

  vmulss  xmm2,xmm2,xmm2;    // s**4
  vmulss  xmm5,xmm7,xmm2;    // n*s**4
  vdivss  xmm4,xmm4,xmm5;
  mov     r10,3;
  vcvtsi2ss xmm3,xmm3,r10;
  vsubss  xmm4,xmm4,xmm3;    // Excess
  vmovss  dword ptr [r15],xmm4;

 @ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  vmovdqu ymm7,ymmword ptr [rsp+32];
  add rsp,64;
 {$ENDIF}
  vzeroupper;
  pop r15;
  pop r14;
  pop r13;
  pop r12;
end;

{calculate statistical datas for 5 and up to 8 arrays in cols order. Set unused
 arrays to zero. Use the convert routines ArrayXToT8Single for correct
 cols order.                                   ^ count of arrays 5,6,7,8
 The parameter count give the count of fields for the calculation.
 For details see unit Test_ymm!}
procedure StatCalcVYSingle (const Feld :array of T8Single;const count :T8Int32;
                          out average,sDev,variance,skew,excess:T8Single);
                          assembler;
 asm
  push r12;
  push r13;
  push r14;
  push r15;
 {$IFNDEF WIN64}
  mov r12,r8;         // sDev
  mov r13,r9;         // variance
  mov rcx,rdi;        // Feld
  mov rdx,rsi;        // length
  mov r8, rdx;        // count
  mov r9, rcx;        // average
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [sDev];
  mov r13,qword ptr [variance];
  sub rsp,192;
  vmovdqu ymmword ptr[rsp],ymm6;
  vmovdqu ymmword ptr[rsp+32],ymm7;
  vmovdqu ymmword ptr[rsp+64],ymm8;
  vmovdqu ymmword ptr[rsp+96],ymm9;
  vmovdqu ymmword ptr[rsp+128],ymm10;
  vmovdqu ymmword ptr[rsp+160],ymm11;
 {$ENDIF}
  mov r14,qword ptr [skew];
  mov r15,qword ptr [Excess];
  vxorps  ymm0,ymm0,ymm0;
  vmovups ymmword ptr [r9],ymm0;
  vmovups ymmword ptr [r12],ymm0;
  vmovups ymmword ptr [r13],ymm0;
  vmovups ymmword ptr [r14],ymm0;
  vmovups ymmword ptr [r15],ymm0;
  test  rdx,rdx;                     // value < 0 not valid
  js    @ende;
  cmp   rdx,7;                      //min 8 value needed
  jb    @ende;
  vmovdqu ymm1,ymmword ptr [r8];
  call  CHECK_INTYZERO;             // check input parameter count
  test  eax,eax;
  jz    @ende;

  vcvtdq2ps ymm7,ymm1;            // convert Integer to Single
  vmovaps   ymm11,ymm7;
  add  rdx,1;
  mov  r10,rdx;
  vxorps ymm0,ymm0,ymm0;
  xor  r11,r11;
align 16;
 @Loop:
  vaddps ymm0,ymm0,ymmword ptr [rcx+r11];
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;

  vdivps ymm0,ymm0,ymm7;    // average
  // calculate statistik (skew,excess,standard deviation,variance)
  xor    r11,r11;
  vxorps ymm2,ymm2,ymm2;   // for sum(x-xm)**2
  vxorps ymm3,ymm3,ymm3;   // for sum(x-xm)**3
  vxorps ymm4,ymm4,ymm4;   // for sum(x-xm)**4

  {The fill values with zero must are cleared or
   the calculation is incorrect. We calculate only the real values from
   count.}
  vpcmpeqw xmm6,xmm6,xmm6;
  vpslld   xmm6,xmm6,31;
  vxorps   xmm6,xmm6,xmm0;   // set xm to -xm for compare
  vinsertf128 ymm6,ymm6,xmm6,1;
  vpcmpeqw xmm8,xmm8,xmm8;
  vpslld   xmm8,xmm8,25;
  vpsrld   xmm8,xmm8,2;     // set 1.0
  vinsertf128 ymm8,ymm8,xmm8,1;
  vxorps   ymm9,ymm9,ymm9;

align 16;
 @Loop1:
  vmovups ymm1,ymmword ptr[rcx+r11];
  vsubps  ymm7,ymm7,ymm8;    // sub count
  vcmpps  ymm10,ymm7,ymm9,1; // when < 0 then all bits = 1
  vsubps  ymm1,ymm1,ymm0;    // (x-xm)
  vcmpps  ymm5,ymm1,ymm6,0;  // search for -xm,-ym values
  vandps  ymm5,ymm5,ymm10;   // clear only the fill values
  vandnps ymm1,ymm5,ymm1;    // set correct values
  vmovaps ymm5,ymm1;
  vmulps  ymm5,ymm5,ymm1;    // (x-xm)**2
  vaddps  ymm2,ymm2,ymm5;
  vmulps  ymm5,ymm5,ymm1     // (x-xm)**3
  vaddps  ymm3,ymm3,ymm5;
  vmulps  ymm5,ymm5,ymm1     // (x-xm)**4
  vaddps  ymm4,ymm4,ymm5;
  add     r11,32;
  sub     r10,1;
  jnz     @Loop1

  vmovups  ymmword ptr [r9],ymm0;  // average
  vsubps   ymm1,ymm11,ymm8 ;       // n-1
  {we must set 1 for the unused arrays
   div x/0 -> error}
  vcmpps   ymm10,ymm11,ymm8,0;     // cmp parameter count for 1, d.h. unused
  vandps   ymm10,ymm10,ymm8;       // set 1 rest to 0
  vorps    ymm10,ymm10,ymm1;       // set rest with correct values
  vdivps   ymm1,ymm2,ymm10         // sum(x-xm)**2/(n-1)
  vmovups  ymmword ptr [r13],ymm1; // variance
  vsqrtps  ymm5,ymm1;
  vmovups  ymmword ptr [r12],ymm5; //sdev

  vdivps   ymm2,ymm2,ymm11;        // sum(x-xm)**2/n
  vsqrtps  ymm5,ymm2;
  vmulps   ymm0,ymm5,ymm2;         // s**3
  vmulps   ymm0,ymm0,ymm11;        // ns**3
  vcmpps   ymm10,ymm11,ymm8,0;
  vandps   ymm10,ymm10,ymm8;
  vorps    ymm10,ymm10,ymm0;
  vdivps   ymm3,ymm3,ymm10;        // sum(x-xm)**3 /(ns**3)
  vmovups  ymmword ptr [r14],ymm3; //skew

  vmulps   ymm0,ymm2,ymm2;         // s**4
  vmulps   ymm0,ymm0,ymm11;        // n*s**4
  vcmpps   ymm10,ymm11,ymm8,0;
  vandps   ymm10,ymm10,ymm8;
  vorps    ymm10,ymm10,ymm0;
  vdivps   ymm4,ymm4,ymm10;        // (sum(x-xm)**4)/(n*s**4)
  mov      r10d,3;
  vcvtsi2ss xmm1,xmm1,r10d;
  vshufps  xmm1,xmm1,xmm1,0;
  vinsertf128 ymm1,ymm1,xmm1,1;
  vsubps   ymm4,ymm4,ymm1;         // ((sum(x-xm)**4)/(n*s**4))- 3
  vmovups  ymmword ptr [r15],ymm4; // Excess

 @ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr[rsp];
  vmovdqu ymm7,ymmword ptr[rsp+32];
  vmovdqu ymm8,ymmword ptr[rsp+64];
  vmovdqu ymm9,ymmword ptr[rsp+96];
  vmovdqu ymm10,ymmword ptr[rsp+128];
  vmovdqu ymm11,ymmword ptr[rsp+160];
  add rsp,192;
 {$ENDIF}
  vzeroupper;
  pop r15;
  pop r14;
  pop r13;
  pop r12;
end;

{Calculate statistical datas of the array.}
procedure StatCalcYDouble (const Feld :array of T4Double; count :Longint;
                          out average,sDev,variance,skew,Excess :Double);
                          assembler;
 asm
  push r12;
  push r13;
  push r14;
  push r15;
 {$IFNDEF WIN64}
  mov r12,r8;          // sDev
  mov r13,r8;          // variance
  mov rcx,rdi;         // adress Feld
  mov rdx,rsi;         // length Feld
  mov r8, rdx;         // count
  mov r9, rcx;         // average
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr[sDev];
  mov r13,qword ptr[variance];
  sub rsp,64;
  vmovdqu ymmword ptr [rsp],ymm6;
  vmovdqu ymmword ptr [rsp+32],ymm7;
 {$ENDIF}
  mov r14,qword ptr [skew];
  mov r15,qword ptr [Excess];
  vxorpd ymm0,ymm0,ymm0;
  vmovsd qword ptr [r9], xmm0;
  vmovsd qword ptr [r12],xmm0;
  vmovsd qword ptr [r13],xmm0;
  vmovsd qword ptr [r14],xmm0;
  vmovsd qword ptr [r15],xmm0;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  test r8d,r8d;
  jz   @ende;
  jns  @1;
  neg  r8d;
 @1:
  cmp  r8d,4;                   // min 4 value needed
  jb   @ende;
  vmovd   xmm2,r8d;
  vpshufd xmm2,xmm2,0;
  vcvtdq2pd ymm7,xmm2;          // convert integer in double
  add  rdx,1;
  mov  r10,rdx;
  xor  r11,r11;
align 16;
 @Loop:
  vaddpd ymm0,ymm0,ymmword ptr [rcx+r11];
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;

  vhaddpd ymm0,ymm0,ymm0;
  vextractf128 xmm1,ymm0,1;
  vaddpd  xmm0,xmm0,xmm1;
  vinsertf128 ymm0,ymm0,xmm0,1;

  vdivpd  ymm0,ymm0,ymm7;    // average

  // calculate statistik (skew,excess,standard deviation,variance)
  xor  r11,r11;
  vxorpd ymm2,ymm2,ymm2;   // for sum(x-xm)**2
  vxorpd ymm3,ymm3,ymm3;   // for sum(x-xm)**3
  vxorpd ymm4,ymm4,ymm4;   // for sum(x-xm)**4

  vpcmpeqw xmm5,xmm5,xmm5;
  vpsllq xmm5,xmm5,63;
  vinsertf128 ymm5,ymm5,xmm5,1;
  vxorpd ymm6,ymm0,ymm5;   // set xm to -xm for compare

align 16;
 @Loop1:
  vmovupd ymm1,ymmword ptr[rcx+r11];
  vsubpd  ymm1,ymm1,ymm0;    // (x-xm)
  vmovapd ymm5,ymm1;
  vmulpd  ymm5,ymm5,ymm1;    // (x-xm)**2
  vaddpd  ymm2,ymm2,ymm5;
  vmulpd  ymm5,ymm5,ymm1     // (x-xm)**3
  vaddpd  ymm3,ymm3,ymm5;
  vmulpd  ymm5,ymm5,ymm1     // (x-xm)**4
  vaddpd  ymm4,ymm4,ymm5;
  add     r11,32;
  sub     r10,1;
  cmp     r10,1;
  jne     @Loop1

  {Only the last round can have fill values}
  vmovupd ymm1,ymmword ptr[rcx+r11];
  vsubpd  ymm1,ymm1,ymm0;    // (x-xm)
  vcmppd  ymm5,ymm1,ymm6,0;  // search of -xm  (0-xm) = -xm
  vandnpd ymm1,ymm5,ymm1;    // set value (0-xm) = -xm to 0!
  vmovapd ymm5,ymm1;
  vmulpd  ymm5,ymm5,ymm1;    // (x-xm)**2
  vaddpd  ymm2,ymm2,ymm5;
  vmulpd  ymm5,ymm5,ymm1     // (x-xm)**3
  vaddpd  ymm3,ymm3,ymm5;
  vmulpd  ymm5,ymm5,ymm1     // (x-xm)**4
  vaddpd  ymm4,ymm4,ymm5;

  vhaddpd ymm2,ymm2,ymm2;
  vextractf128 xmm1,ymm2,1;
  vaddpd  xmm2,xmm2,xmm1;
  vhaddpd ymm3,ymm3,ymm3;
  vextractf128 xmm1,ymm3,1;
  vaddpd  xmm3,xmm3,xmm1;
  vhaddpd ymm4,ymm4,ymm4;
  vextractf128 xmm1,ymm4,1;
  vaddpd  xmm4,xmm4,xmm1;

  vmovsd qword ptr [r9],xmm0;          //average

  vpcmpeqw xmm1,xmm1,xmm1;
  vpsllq  xmm1,xmm1,54;
  vpsrlq  xmm1,xmm1,2;       // 1.0
  vsubpd  ymm5,ymm7,ymm1;
  vdivsd  xmm1,xmm2,xmm5;    // sum(x-xm)**2/(n-1)
  vmovsd  qword ptr [r13],xmm1;         //variance

  vsqrtsd xmm1,xmm1,xmm1;    // sdev
  vmovsd  qword ptr [r12],xmm1;         //sdev

  vdivsd  xmm2,xmm2,xmm7;    // sum(x-xm)**2/n  = s**2
  vsqrtsd xmm5,xmm2,xmm2;
  vmulsd  xmm1,xmm5,xmm2;    // s**3
  vmulsd  xmm1,xmm1,xmm7;    // n*sdev**3
  vdivsd  xmm3,xmm3,xmm1;    // sum(x-xm)**3/(n*sdev**3)

  vmovsd  qword ptr [r14],xmm3;         //skew

  vmulsd  xmm2,xmm2,xmm2;    // sdev**4
  vmulsd  xmm2,xmm2,xmm7;    // n*sdev**4
  vdivsd  xmm4,xmm4,xmm2;    // sum(x-xm)**4/(n*sdev**4)
  mov     r10,3;
  vcvtsi2sd xmm3,xmm3,r10;
  vsubsd  xmm4,xmm4,xmm3;     // -3
  vmovsd  qword ptr [r15],xmm4;         // Excess

 @ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  vmovdqu ymm7,ymmword ptr [rsp+32];
  add rsp,64;
 {$ENDIF}
  vzeroupper;
  pop r15;
  pop r14;
  pop r13;
  pop r12;
end;

{calculate statistical datas for 3 or 4 arrays in cols order. Set unused
 arrays to zero. Use the convert routines ArrayXToT4Double for correct
 cols order.                                   ^ count of arrays 3,4
 The parameter count give the count of fields for the calculation.
 For details see unit Test_ymm!}
procedure StatCalcVYDouble (const Feld :array of T4Double;const count :T4Int32;
                           out average,sDev,variance,skew,Excess :T4Double);
                           assembler;
 asm
  push r12;
  push r13;
  push r14;
  push r15;
 {$IFNDEF WIN64}
  mov r12,r8;          // adress sDev
  mov r13,r8;          // adress variance
  mov rcx,rdi;         // adress Feld
  mov rdx,rsi;         // length Feld
  mov r8, rdx;         // adress count
  mov r9  rcx;         // adress average
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [sDev];
  mov r13,qword ptr [variance];
  sub rsp,192;
  vmovdqu ymmword ptr[rsp],ymm6;
  vmovdqu ymmword ptr[rsp+32],ymm7;
  vmovdqu ymmword ptr[rsp+64],ymm8;
  vmovdqu ymmword ptr[rsp+96],ymm9;
  vmovdqu ymmword ptr[rsp+128],ymm10;
  vmovdqu ymmword ptr[rsp+160],ymm11;
 {$ENDIF}
  mov r14,qword ptr [skew];
  mov r15,qword ptr [Excess];
  vxorpd  ymm0,ymm0,ymm0;
  vmovupd ymmword ptr [r9],ymm0;
  vmovupd ymmword ptr [r12],ymm0;
  vmovupd ymmword ptr [r13],ymm0;
  vmovupd ymmword ptr [r14],ymm0;
  vmovupd ymmword ptr [r15],ymm0;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,3;                      // min 4 value needed
  jb   @ende;
  vmovdqu  xmm1,xmmword ptr [r8];
  vpabsd   xmm1,xmm1;        // abs(xmm1)
  vpxor    xmm2,xmm2,xmm2;   // set 0
  vpcmpeqd xmm2,xmm1,xmm2;   // result all bits 1 when =
  vptest   xmm2,xmm2;
  jnz   @ende;
  vcvtdq2pd ymm7,xmm1;
  vmovapd   ymm11,ymm7;
  add  rdx,1;
  mov  r10,rdx;
  mov  rax,rdx;
  vxorpd ymm0,ymm0,ymm0;
  xor  r11,r11;
align 16;
 @Loop:
  vaddpd ymm0,ymm0,ymmword ptr [rcx+r11];
  add   r11,32;
  sub   rax,1;
  jnz   @Loop;

  vdivpd ymm0,ymm0,ymm7;    // average

  // calculate statistik (skew,excess,standard deviation,variance)
  xor  r11,r11;
  vxorpd ymm2,ymm2,ymm2;   // for sum(x-xm)**2
  vxorpd ymm3,ymm3,ymm3;   // for sum(x-xm)**3
  vxorpd ymm4,ymm4,ymm4;   // for sum(x-xm)**4
  {The fill values with zero must are cleared or
   the calculation is incorrect. We calculate only the real values from
   count.}
  vpcmpeqw xmm6,xmm6,xmm6;
  vpsllq   xmm6,xmm6,63;
  vxorpd   xmm6,xmm6,xmm0;   // set xm to -xm for compare
  vinsertf128 ymm6,ymm6,xmm6,1;
  vpcmpeqw xmm8,xmm8,xmm8;
  vpsllq   xmm8,xmm8,54;
  vpsrlq   xmm8,xmm8,2;     // for count - 1.0
  vinsertf128 ymm8,ymm8,xmm8,1;
  vxorpd   ymm9,ymm9,ymm9;

align 16;
 @Loop1:
  vmovupd ymm1,ymmword ptr[rcx+r11];
  vsubpd  ymm7,ymm7,ymm8;    // sub count
  vcmppd  ymm10,ymm7,ymm9,1; // when < 0 then all bits = 1
  vsubpd  ymm1,ymm1,ymm0;    // (x-xm)
  vcmppd  ymm5,ymm1,ymm6,0;  // search for -xm,-ym values
  vandpd  ymm5,ymm5,ymm10;   // clear only the fill values
  vandnpd ymm1,ymm5,ymm1;    // set the correct values
  vmovapd ymm5,ymm1;
  vmulpd  ymm5,ymm5,ymm1;    // (x-xm)**2
  vaddpd  ymm2,ymm2,ymm5;
  vmulpd  ymm5,ymm5,ymm1     // (x-xm)**3
  vaddpd  ymm3,ymm3,ymm5;
  vmulpd  ymm5,ymm5,ymm1     // (x-xm)**4
  vaddpd  ymm4,ymm4,ymm5;
  add     r11,32;
  sub     rdx,1;
  jnz     @Loop1

  vmovupd ymmword ptr [r9],ymm0;  // average
  vinsertf128 ymm0,ymm0,xmm0,1;
  vsubpd  ymm6,ymm11,ymm8;        // n-1
  vdivpd  ymm1,ymm2,ymm6;         // sum(x-xm)**2/(n-1)
  vmovupd ymmword ptr [r13],ymm1; //variance
  vsqrtpd ymm5,ymm1;
  vmovupd ymmword ptr [r12],ymm5; //sdev

  vdivpd  ymm2,ymm2,ymm11;        // sum(x-xm)**2/n
  vsqrtpd ymm1,ymm2;              // s
  vmulpd  ymm0,ymm1,ymm2          // s**3
  vmulpd  ymm0,ymm0,ymm11;        // n*s**3
  vmovapd ymm7,ymm11;
  vcmppd  ymm7,ymm7,ymm8,0;      // = 1?
  vandpd  ymm7,ymm7,ymm8;        // set 1 for 0
  // scheiss compiler
  //vorpd   ymm7,ymm7,ymm0;        // set the rest with correct values
  db $C5,$C5,$56,$F8
  vdivpd  ymm3,ymm3,ymm7;         // (sum(x-xm)**3)/(n*s**3)
  vmovupd ymmword ptr [r14],ymm3; //skew

  vmulpd  ymm0,ymm2,ymm2;         // s**4
  vmulpd  ymm0,ymm0,ymm11;        // n*s**4
  vmovapd ymm7,ymm11;
  vcmppd  ymm7,ymm7,ymm8,0;
  vandpd  ymm7,ymm7,ymm8;
  //vorpd   ymm7,ymm7,ymm0;
  db $C5,$C5,$56,$F8
  vdivpd  ymm4,ymm4,ymm7;         // (sum(x-xm)**4)/(n*s**4)
  mov     r10,3;
  vcvtsi2sd xmm1,xmm1,r10;
  vshufpd xmm1,xmm1,xmm1,0;
  vinsertf128 ymm1,ymm1,xmm1,1;
  vsubpd  ymm4,ymm4,ymm1;         // Excess
  vmovupd ymmword ptr [r15],ymm4; //Excess

 @ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr[rsp];
  vmovdqu ymm7,ymmword ptr[rsp+32];
  vmovdqu ymm8,ymmword ptr[rsp+64];
  vmovdqu ymm9,ymmword ptr[rsp+96];
  vmovdqu ymm10,ymmword ptr[rsp+128];
  vmovdqu ymm11,ymmword ptr[rsp+160];
  add rsp,192;
 {$ENDIF}
  vzeroupper;
  pop r15;
  pop r14;
  pop r13;
  pop r12;
end;

{Korrelationskoeffizient -1<= r <= +1, bei error r = 2 The calculation
 needed min 8 value pairs. In parameter count is the count of the fields for
 the calculation.}
function KorrAnalyseYSingle (const x,y :array of T8Single;count :Longint):Single;
                          assembler;
 asm
  push r12;
  push r13;
 {$IFNDEF WIN64}
  mov r12d,r8d;      //count
  mov rcx,rdi;       //x
  mov rdx,rsi;
  mov r8, rdx;       //y
  mov r9, rcx;
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12d,dword ptr[count];
  sub rsp,96;
  vmovdqu ymmword ptr [rsp],ymm6;
  vmovdqu ymmword ptr [rsp+32],ymm7;
  vmovdqu ymmword ptr [rsp+64],ymm8;
 {$ENDIF}
  mov  r10d,2          // for error
  vcvtsi2ss xmm0,xmm0,r10d;
  test r12d,r12d;
  jz   @ende;
  jns  @1;
  neg  r12d;
 @1:
  cmp  r12d,8;       // min 8 values needed
  jb   @ende;
  test rdx,rdx;      // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;       // cmp length x and y
  jne  @ende;
  add  rdx,1;        // length x
  mov  r10,rdx;
  vxorps ymm0,ymm0,ymm0;
  vxorps ymm1,ymm1,ymm1;
  xor    r11,r11;
align 16;
 @Loop:
  vaddps ymm0,ymm0,ymmword ptr [rcx+r11];  // x
  vaddps ymm1,ymm1,ymmword ptr [r8+r11];  // y
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;

  vhaddps ymm0,ymm0,ymm0;
  vhaddps ymm0,ymm0,ymm0;       // sum over all fields
  vextractf128 xmm2,ymm0,1;
  vaddps  xmm0,xmm0,xmm2;
  vinsertf128 ymm0,ymm0,xmm0,1;

  vhaddps ymm1,ymm1,ymm1
  vhaddps ymm1,ymm1,ymm1;
  vextractf128 xmm2,ymm1,1;
  vaddps  xmm1,xmm1,xmm2;
  vinsertf128 ymm1,ymm1,xmm1,1;

  vcvtsi2ss xmm2,xmm2,r12d;
  vshufps xmm2,xmm2,xmm2,0;
  vinsertf128 ymm2,ymm2,xmm2,1;
  vdivps  ymm0,ymm0,ymm2;    // average x
  vdivps  ymm1,ymm1,ymm2;    // average y

  // calculate korrelation
  xor    r11,r11;
  vxorps ymm2,ymm2,ymm2;   // for sum((x-xm)*(y-ym))
  vxorps ymm3,ymm3,ymm3;   // for sum(x-xm)**2
  vxorps ymm4,ymm4,ymm4;   // for sum(y-ym)**2

  {The fill values with zero must are cleared or
   the calculation is incorrect. We calculate only the real values from
   count.}
  vpcmpeqw xmm7,xmm7,xmm7;
  vpslld   xmm7,xmm7,31;
  vxorps   xmm7,xmm0,xmm7;  // set -xm
  vinsertf128 ymm7,ymm7,xmm7,1;
  vpcmpeqw xmm8,xmm8,xmm8;
  vpslld   xmm8,xmm8,31;
  vxorps   xmm8,xmm1,xmm8;  // set -ym
  vinsertf128 ymm8,ymm8,xmm8,1;

align 16;
 @Loop1:
  vmovups ymm6,ymmword ptr [rcx+r11];
  vsubps  ymm6,ymm6,ymm0;    // (x-xm)
  vmovaps ymm5,ymm6;
  vmulps  ymm6,ymm6,ymm6;    // (x-xm)**2
  vaddps  ymm3,ymm3,ymm6;
  vmovups ymm6,ymmword ptr [r8+r11];
  vsubps  ymm6,ymm6,ymm1;    // (y-ym)
  vmulps  ymm5,ymm5,ymm6;
  vaddps  ymm2,ymm2,ymm5;
  vmulps  ymm6,ymm6,ymm6;
  vaddps  ymm4,ymm4,ymm6;    // (y-ym)**2
  add     r11,32;
  sub     r10,1;
  cmp     r10,1;
  jne     @Loop1

  {only zeros at the end are fill values.}
  vmovups ymm6,ymmword ptr [rcx+r11];
  vsubps  ymm6,ymm6,ymm0;    // (x-xm)
  vcmpps  ymm5,ymm6,ymm7,0;  // search of -xm  (0-xm) = -xm
  vandnps ymm6,ymm5,ymm6;    // set value (0-xm) = -xm to 0!
  vmovaps ymm5,ymm6;
  vmulps  ymm6,ymm6,ymm6;    // (x-xm)**2
  vaddps  ymm3,ymm3,ymm6;
  vmovups ymm6,ymmword ptr [r8+r11];
  vsubps  ymm6,ymm6,ymm1;    // (y-ym)
  vcmpps  ymm7,ymm6,ymm8,0;  // search of -ym  (0-ym) = -ym
  vandnps ymm6,ymm7,ymm6;    // set value (0-ym) = -ym to 0!
  vmulps  ymm5,ymm5,ymm6;
  vaddps  ymm2,ymm2,ymm5;
  vmulps  ymm6,ymm6,ymm6;
  vaddps  ymm4,ymm4,ymm6;    // (y-ym)**2

  vhaddps ymm2,ymm2,ymm2;  // calculate the field sums
  vhaddps ymm2,ymm2,ymm2;
  vextractf128 xmm1,ymm2,1;
  vaddps  xmm2,xmm2,xmm1;

  vhaddps ymm3,ymm3,ymm3;
  vhaddps ymm3,ymm3,ymm3;
  vextractf128 xmm1,ymm3,1;
  vaddps  xmm3,xmm3,xmm1;

  vhaddps ymm4,ymm4,ymm4;
  vhaddps ymm4,ymm4,ymm4;
  vextractf128 xmm1,ymm4,1;
  vaddps  xmm4,xmm4,xmm1;

  vmulss  xmm3,xmm3,xmm4;   // divisor
  vsqrtss xmm0,xmm3,xmm3;
  vdivss  xmm0,xmm2,xmm0;   // r koeffizient

 @ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  vmovdqu ymm7,ymmword ptr [rsp+32];
  vmovdqu ymm8,ymmword ptr [rsp+64];
  add rsp,96;
 {$ENDIF}
  vzeroupper;
  pop r13;
  pop r12;
end;

{Korrelationskoeffizient -1<= r <= +1, bei error r = 2. Calculate the corr
 coeffizient for 3 or 4 array pairs in cols order. Use the convert routines
 ArrayXToT8Single for correct order. Set unused arrays to zero. For details
      ^ 6,8
 see unit Test_ymm!}
function KorrAnalyse4VYSingle (const Feld :array of T8Single;
                               const count :T8Int32):T4Single;
                               assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;     //Result
  mov rdx,rsi;     //Feld
  mov r8, rdx;     //length
  mov r9, rcx;     //count
 {$ENDIF}
 {$IFDEF WIN64}
  sub rsp,192;
  vmovdqu ymmword ptr [rsp],ymm6;
  vmovdqu ymmword ptr [rsp+32],ymm7;
  vmovdqu ymmword ptr [rsp+64],ymm8;
  vmovdqu ymmword ptr [rsp+96],ymm9;
  vmovdqu ymmword ptr [rsp+128],ymm10;
  vmovdqu ymmword ptr [rsp+160],ymm11;
 {$ENDIF}
  mov  r10d,2;
  vcvtsi2ss xmm0,xmm0,r10d;
  vshufps xmm0,xmm0,xmm0,0;    //for error
  test r8,r8;                  // value < 0 not valid
  js   @ende;
  cmp  r8,1;                   // min 2 array fields needed
  jb   @ende;
  vmovdqu ymm1,ymmword ptr [r9];
  call CHECK_T8INT32;
  test eax,eax;                // is check ok?
  jz   @ende;
  vcvtdq2ps ymm7,ymm1;         // convert integer to single
  vmovaps   ymm11,ymm7;
  add  r8,1;
  mov  r10,r8;
  vxorps ymm0,ymm0,ymm0;
  xor  r11,r11;
align 16;
 @Loop:
  vaddps ymm0,ymm0,ymmword ptr [rdx+r11];  // Feld
  add  r11,32;
  sub  r8,1;
  jnz  @Loop;

  vdivps ymm0,ymm0,ymm7;              // average

  // calculate korrelation
  xor    r11,r11;
  vxorps ymm2,ymm2,ymm2;             // for sum((x-xm)*(y-ym))
  vxorps ymm3,ymm3,ymm3;             // for sum(x-xm)**2

  {The fill values with zero must are cleared or
   the calculation is incorrect. We calculate only the real values from
   count.}
  vpcmpeqw xmm6,xmm6,xmm6;
  vpslld   xmm6,xmm6,31;
  vxorps   xmm6,xmm6,xmm0;      // set -xm and -ym for compare
  vinsertf128 ymm6,ymm6,xmm6,1;
  vpcmpeqw xmm8,xmm8,xmm8;
  vpslld   xmm8,xmm8,25;
  vpsrld   xmm8,xmm8,2;              // set 1.0
  vinsertf128 ymm8,ymm8,xmm8,1;
  vxorps   ymm9,ymm9,ymm9;

align 16;
 @Loop1:
  vmovups ymm1,ymmword ptr [rdx+r11];
  vsubps  ymm7,ymm7,ymm8;            // sub count
  vcmpps  ymm10,ymm7,ymm9,1;         // when < 0 then all bits = 1
  vsubps  ymm1,ymm1,ymm0;            // (x-xm) and (y-ym)
  vcmpps  ymm5,ymm1,ymm6,0;          // search for -xm,-ym values
  vandps  ymm5,ymm5,ymm10;           // clear only the fill values
  vandnps ymm1,ymm5,ymm1;
  vmovaps ymm5,ymm1;
  vshufps ymm4,ymm1,ymm1,10110001b;  // all y value over x value
  vmulps  ymm4,ymm4,ymm1;
  vaddps  ymm2,ymm2,ymm4;            // valid in 1,3,5,7
  vmulps  ymm5,ymm5,ymm5;            // (x-xm)**2 and (y-ym)**2
  vaddps  ymm3,ymm3,ymm5;
  add     r11,32;
  sub     r10,1;
  jnz     @Loop1

  vmovaps ymm0,ymm3;
  vshufps ymm4,ymm3,ymm3,10110001b;  // 2,1,4,3  sqrt(x) * sqrt(y)
  vmulps  ymm0,ymm0,ymm4;
  vsqrtps ymm0,ymm0;                 // sqrt(sum(x-xm)^2 * sum(y-ym)^2)
  vcmpps  ymm11,ymm11,ymm8,0;        // cmp count values with 1
  vandps  ymm11,ymm11,ymm8;          // set 1, rest 0
  vorps   ymm11,ymm11,ymm0;          // set the correct values for the rest
  vdivps  ymm0,ymm2,ymm11;
  vextractf128 xmm1,ymm0,1;
  vshufps xmm0,xmm0,xmm1,10001000b;  // set correct value in pos 1..4

 @ende:
  vmovups xmmword ptr [rcx],xmm0;
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  vmovdqu ymm7,ymmword ptr [rsp+32];
  vmovdqu ymm8,ymmword ptr [rsp+64];
  vmovdqu ymm9,ymmword ptr [rsp+96];
  vmovdqu ymm10,ymmword ptr[rsp+128];
  vmovdqu ymm11,ymmword ptr[rsp+160];
  add rsp,192;
 {$ENDIF}
  vzeroupper;
end;


{Calculate the average from 5 up to 8 arrays in cols order. Use the convert
 routines ArrayXToT8Single for correct order. In count is the count of fields
               ^ 5,6,7,8
 for calculation.}
function AverageVYSingle(const Feld :array of T8Single;
                         const count :T8Int32):T8Single;assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;     //Result
  mov rdx,rsi;     //Feld
  mov r8, rdx;     //length
  mov r9 ,rcx;     //count
 {$ENDIF}
  vxorps ymm0,ymm0,ymm0;
  test r8,r8;                     // value < 0 not valid
  js   @ende;
  vmovups ymm1,ymmword ptr [r9];
  call CHECK_INTYZERO;
  test eax,eax;
  jz   @ende;
  vcvtdq2ps  ymm2,ymm1;
  add  r8,1;
  xor  r11,r11;
  vxorps ymm0,ymm0,ymm0;
align 16;
 @loop:
  vaddps ymm0,ymm0,ymmword [rdx+r11];
  add  r11,32;
  sub  r8,1;
  jnz  @Loop;
  vdivps ymm0,ymm0,ymm2;

 @ende:
  vmovups ymmword ptr [rcx],ymm0;
  vzeroupper;
end;

{Get average of the fields in array. Parameter count has the count of fields
 for calculation.}
function AverageYSingle (const Feld :array of T8Single; count :Longint):Single;
   assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;   //Feld
  mov rdx,rsi;   //length
  mov r8, rdx;   //count
 {$ENDIF}
  vxorps ymm0,ymm0,ymm0;     // result
  test rdx,rdx;              // value < 0 not valid
  js   @ende;
  test r8d,r8d;
  jz   @ende;
  jns  @1;
  neg  r8d;
 @1:
  vcvtsi2ss xmm2,xmm2,r8d;    // only 1 place needed
  add  rdx,1;
  xor  r11,r11;
align 16;
 @Loop:
  vaddps ymm0,ymm0,ymmword [rcx+r11];
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;

  vextractf128 xmm1,ymm0,1;            //Get upper half
  vaddps  xmm0,xmm0,xmm1;              // 8 to 4 value
  vhaddps xmm0,xmm0,xmm0;
  vhaddps xmm0,xmm0,xmm0;              // all 4 places have equal sum
  vdivss  xmm0,xmm0,xmm2;              // div 1 value byy the divisor
  vzeroupper;                          // result in xmm0; all values equal
 @ende:
end;

{Calculate the average of 3 or 4 arrays in cols order. Use the convert
 routines ArrayXToT4Double for correct order. In count is the count of fields
               ^ 3,4
 for calculation.}
function AverageVYDouble (const Feld :array of T4Double;
                           const count :T4Int32):T4Double;
                           assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;    //Result
  mov rdx,rsi;    //Feld
  mov r8, rdx;    //length
  mov r9, rcx;    //count
 {$ENDIF}
  vxorpd ymm0,ymm0,ymm0; //for error
  test r8,r8;                     // value < 0 not valid
  js   @ende;
  vmovdqu  xmm1,xmmword ptr [r9];
  vpabsd   xmm1,xmm1;        // abs(xmm1)
  vpxor    xmm2,xmm2,xmm2;   // set 0
  vpcmpeqd xmm2,xmm1,xmm2;   // result all bits 1 when =
  vptest   xmm2,xmm2;
  jnz  @ende;
  vcvtdq2pd ymm2,xmm1;
  add  r8,1;
  mov  r10,r8;
  vxorpd ymm0,ymm0,ymm0;
  xor r11,r11;
align 16;
 @Loop:
  vaddpd ymm0,ymm0,ymmword [rdx+r11];
  add r11,32;
  sub r8,1;
  jnz @Loop;
  vdivpd  ymm0,ymm0,ymm2;

 @ende:
  vmovupd ymmword ptr [rcx],ymm0;
  vzeroupper;
end;

{Get average of the fields in array. Parameter count has the count of fields
 for calculation.}
function AverageYDouble (const Feld :array of T4Double; count :Longint):Double;
                         assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;   //Feld
  mov rdx,rsi;   // length
  mov r8, rdx;   //count
 {$ENDIF}
  vxorpd  ymm0,ymm0,ymm0;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  test r8d,r8d;
  jz   @ende;
  jns  @1;
  neg  r8d;
 @1:
  vmovd   xmm1,r8d;
  vpshufd xmm1,xmm1,0;
  vcvtdq2pd xmm1,xmm1;             // convert in double
  add  rdx,1;
  mov  r10,rdx;
  xor r11,r11;
align 16;
 @Loop:
  vaddpd ymm0,ymm0,ymmword [rcx+r11];
  add r11,32;
  sub rdx,1;
  jnz @Loop;

  vextractf128 xmm2,ymm0,1;       //Get upper half
  vaddpd  xmm0,xmm0,xmm2;         // 4 to 2 value
  vhaddpd xmm0,xmm0,xmm0
  vdivsd  xmm0,xmm0,xmm1;

 @ende:
  vzeroupper;
end;

{Calculate the geometrical average from 5 and up to 8 arrays in cols order.
 Use the convert routines ArrayXToT8Single for correct order.
                               ^ 5,6,7,8
 In count is the count of fields for calculation. Unused arrays set to 1}
function GeoAverageVYSingle (const Feld :array of T8Single;
                             const count :T8Int32):T8Single;
                              assembler;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;    //Result
  mov rdx,rsi;    //Feld
  mov r8, rdx;    //length
  mov r9, rcx;    //count
 {$ENDIF}
  vxorps ymm0,ymm0,ymm0;    // for error
  test r8,r8;                     // value < 0 not valid
  js   @ende;
  vmovdqu ymm1,ymmword ptr [r9];
  call CHECK_INTYZERO;
  test eax,eax;
  jz   @ende;
  vcvtdq2ps ymm2,ymm1;
  add  r8,1;
  mov  r10,r8;
  vpcmpeqw xmm1,xmm1,xmm1;
  vpslld   xmm1,xmm1,25;
  vpsrld   xmm1,xmm1,2;          // set 1.0
  vinsertf128 ymm1,ymm1,xmm1,1;
  vdivps   ymm2,ymm1,ymm2;       // 1/count in all places
  vmovaps  ymm0,ymm1;            // set 1.0 for start
  xor r11,r11;
align 16;
 @Loop:
  vmulps ymm0,ymm0,ymmword ptr [rdx+r11];
  add  r11,32;
  sub  r8,1;
  jnz  @Loop;

  sub  rsp,32;
  // calculate ln(ymm0) * 1/n
  vmovups ymmword ptr [rsp],ymm0;
  mov     r10d,8;
  call    FN_LN_SINGLE;
  vmovups ymm0,ymmword ptr [rsp];
  vmulps  ymm0,ymm0,ymm2;          // result = ln(ymm0) * 1/n

  // calculate EXP(ln(ymm0) * 1/N)
  vmovups ymmword ptr [rsp],ymm0;
  mov     r10d,8;
  call    FN_EXP_SINGLE;
  vmovups ymm0,ymmword ptr [rsp];
  add rsp,32;

 @ende:
  vmovups ymmword ptr [rcx],ymm0;
  vzeroupper;
end;

{Get geometrical average of the fields in array. Parameter count has the
 count of fields for calculation.}
function GeoAverageYSingle(const Feld :array of T8Single; count :Longint):Single;
    assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;        //Feld
  mov rdx,rsi;        //length
  mov r8, rdx;        //count
 {$ENDIF}
  vxorps  ymm0,ymm0,ymm0;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  test r8d,r8d;
  jz   @ende;
  jns  @1;
  neg  r8d;
 @1:
  add  rdx,1;
  mov  r10,rdx;
  vpcmpeqw xmm1,xmm1,xmm1;
  vpslld   xmm1,xmm1,25;
  vpsrld   xmm1,xmm1,2;             // set 1.0
  vinsertf128 ymm1,ymm1,xmm1,1
  vmovd    xmm0,r8d;
  vpshufd  xmm0,xmm0,0;
  vcvtdq2ps xmm0,xmm0;
  vinsertf128 ymm0,ymm0,xmm0,1;
  vdivps   ymm2,ymm1,ymm0;            // 1/n
  vmovaps  ymm0,ymm1;
  xor  r11,r11;
align 16;
 @Loop:
  vmulps ymm0,ymm0,ymmword [rcx+r11];
  add r11,32;
  sub rdx,1;
  jnz @Loop;

  // calculate the result
  vextractf128 xmm1,ymm0,1;           // upper half -> xmm1
  vmulps    xmm0,xmm0,xmm1;           // all factors in xmm0
  vshufps   xmm1,xmm0,xmm0,10110001b; // pos 2,1,4,3
  vmulps    xmm1,xmm1,xmm0;           // result = 12,34
  vinsertps xmm0,xmm1,xmm1,10001110b  // place 2->0 in xmm0 with zero the rest
  vmulps    xmm0,xmm0,xmm1;           // result in place 0

  sub    rsp,8;
  // calculate ln(ymm0) * 1/n
  vmovss [rsp],xmm0;
  mov    r10d,1;
  call   FN_LN_SINGLE;
  vmovss xmm0,[rsp];
  vmulss xmm0,xmm0,xmm2;          // result = ln(ymm0) * 1/n
  // calculate EXP(ln(ymm0) * 1/N)
  vmovss [rsp],xmm0;
  mov    r10d,1;
  call   FN_EXP_SINGLE;
  vmovss xmm0,[rsp];
  add    rsp,8;
 @ende:
  vzeroupper;
end;

{Calculate the geometrical average for 3 or 4 arrays in cols order. Use the
 convert routines ArrayXToT4Double for correct order.
                       ^ 3,4
In count is the count of fields for calculation. Unused arrays set to 1}
function GeoAverageVYDouble (const Feld :array of T4Double;
                             const count :T4Int32):T4Double;
                              assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;    //Result
  mov rdx,rsi;    //feld
  mov r8, rdx;    //length
  mov r9, rcx;    //count
 {$ENDIF}
  vxorpd ymm0,ymm0,ymm0;          // for error
  test r8,r8;                     // value < 0 not valid
  js   @ende;
  vmovdqu xmm1,xmmword ptr [r9];  // count of the Fields
  vpabsd   xmm1,xmm1;        // abs(xmm1)
  vpxor    xmm2,xmm2,xmm2;   // set 0
  vpcmpeqd xmm2,xmm1,xmm2;   // result all bits 1 when =
  vptest   xmm2,xmm2;
  jnz    @ende;
  vcvtdq2pd ymm2,xmm1;   // integer in double
  add  r8,1;
  mov  r10,r8;

  // calculate 1/N
  vpcmpeqw xmm1,xmm1,xmm1;
  vpsllq   xmm1,xmm1,54;
  vpsrlq   xmm1,xmm1,2;           // set 1.0
  vinsertf128 ymm1,ymm1,xmm1,1
  vdivpd ymm2,ymm1,ymm2;          // result 1/n in all places
  vmovapd ymm0,ymm1;              // set start value 1.0
  xor  r11,r11;
align 16;
 @Loop:
  vmulpd ymm0,ymm0,ymmword ptr [rdx+r11];
  add r11,32;
  sub r8,1;
  jnz @Loop;

  // calculate ln(ymm0) * 1/n
  sub     rsp,32;
  vmovupd ymmword ptr [rsp],ymm0;
  mov     r10d,4;
  call    FN_LN_DOUBLE;
  vmovupd ymm0,ymmword ptr [rsp];
  vmulpd  ymm0,ymm0,ymm2;

  // calculate EXP(ln(ymm0) * 1/N)
  vmovupd ymmword ptr [rsp],ymm0;
  mov     r10d,4;
  call    FN_EXP_DOUBLE;
  vmovupd ymm0,ymmword ptr [rsp];
  add rsp,32;

 @ende:
  vmovupd ymmword ptr [rcx],ymm0;  // result
  vzeroupper;
end;

{Get geometrical average of the fields in array. Parameter count has the
 count of fields for calculation.}
function GeoAverageYDouble (const Feld :array of T4Double; count :Longint):Double;
                            assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;        //Feld
  mov rdx,rsi;        //length
  mov r8d edx;        //count
 {$ENDIF}
  vxorpd ymm0,ymm0,ymm0;             // for error
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  test r8d,r8d;
  jz   @ende;
  jns  @1;
  neg  r8d;
 @1:
  add  rdx,1;
  mov  r10,rdx;
  vpcmpeqw xmm1,xmm1,xmm1;
  vpsllq   xmm1,xmm1,54;
  vpsrlq   xmm1,xmm1,2;       // set 1.0
  vinsertf128 ymm1,ymm1,xmm1,1
  vmovd    xmm0,r8d;
  vpshufd  xmm0,xmm0,0;
  vcvtdq2pd ymm0,xmm0;
  vdivpd   ymm2,ymm1,ymm0;       // calc 1/count
  vmovapd  ymm0,ymm1;            // set 1.0
  xor  r11,r11;
align 16;
 @Loop:
  vmulpd ymm0,ymm0,ymmword ptr [rcx+r11];
  add r11,32;
  sub rdx,1;
  jnz @Loop;

  // calculate the result
  vextractf128 xmm1,ymm0,1;            // upper half -> xmm1
  vmulpd  xmm0,xmm0,xmm1;              // all 2 factors in xmm0
  vmovapd xmm1,xmm0;
  vshufpd xmm0,xmm0,xmm0,00000001b;
  vmulpd  xmm0,xmm0,xmm1;

  // only in xmm0,0  is the correct value!
  sub rsp,8;
  vmovsd qword ptr [rsp],xmm0;
  mov    r10d,1;
  call   FN_LN_DOUBLE;               // ln(ymm)
  vmovsd xmm0,[rsp];
  vmulsd xmm0,xmm0,xmm2;             // ln(ymm) * 1/n
  vmovsd qword ptr [rsp],xmm0;
  mov    r10d,1;
  call   FN_EXP_DOUBLE;              // EXP(ln(ymm) * 1/n)
  vmovsd xmm0, [rsp];
  add rsp,8;

 @ende:
  vzeroupper;
end;

{exponential regresion y = ae^(bx)
 calculate ln(y) = ln(a) + b*x}
function ExpRegYSingle (const x,y :array of T8Single;count :Longint;
                        out a,b :Single):Longbool;assembler;
 asm
  push r12;
  push r13;
  push r14;
  push r15;
 {$IFNDEF WIN64}
  mov r12d,r8d;    //count
  mov r13,r9;      //a
  mov rcx,rdi;     //x
  mov rdx,rsi;
  mov r8, rdx;     //y
  mov r9, rcx;
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12d,dword ptr [count];
  mov r13,qword ptr [a];
  sub rsp,32;
  vmovdqu ymmword ptr [rsp],ymm6;
 {$ENDIF}
  mov  r14,qword ptr [b];
  xor  rax,rax;
  vxorps ymm0,ymm0,ymm0;
  vmovss dword ptr [r13],xmm0;
  vmovss dword ptr [r14],xmm0;     // for error
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  test r12d,r12d;
  jz   @ende;
  jns  @1;
  neg  r12d;
 @1:
  cmp  r12d,2;      // min 2 values
  jb   @ende;
  cmp  rdx,r9;     // cmp length x and y
  jne  @ende;
  push r14;        // save adress b
  mov  rax,1;
  add  rdx,1;
  mov  r9,rdx;
  mov  r10,rdx;
  imul r10,32;
  add  r10,64;     // + byte for ln calculation in FN_LN_SINGLE
  mov  r15,rsp;    // save stack addres
  sub  rsp,r10;    // need for ln(y) values
  vxorps ymm0,ymm0,ymm0;
  vxorps ymm1,ymm1,ymm1;
  xor  r11,r11;
  mov  r14,32;     // for distance in stack for ln(y) result
align 16;
 @Loop:
  vaddps  ymm0,ymm0,ymmword ptr [rcx+r11];  // x
  vmovups ymm2,ymmword ptr [r8+r11];  // y
  vmovups ymmword ptr [rsp],ymm2;
  mov     r10d,8;                    // calculate 8 ln(y) value
  call    FN_LN_SINGLE;
  vmovups ymm2,ymmword ptr [rsp];
  vaddps  ymm1,ymm1,ymm2;
  vmovups ymmword ptr [rsp+r14],ymm2;  // save ln(ymm2) on stack for lather
  add     r11,32;
  add     r14,32;
  sub     rdx,1;
  jnz     @Loop;

  vhaddps ymm0,ymm0,ymm0;    // sum over all fields
  vhaddps ymm0,ymm0,ymm0;
  vextractf128 xmm2,ymm0,1;
  vaddps  xmm0,xmm0,xmm2;
  vinsertf128 ymm0,ymm0,xmm0,1;

  vhaddps ymm1,ymm1,ymm1
  vhaddps ymm1,ymm1,ymm1;
  vextractf128 xmm2,ymm1,1;
  vaddps  xmm1,xmm1,xmm2;
  vinsertf128 ymm1,ymm1,xmm1,1;

  vpinsrd xmm2,xmm2,r12d,0;
  vpshufd xmm2,xmm2,0;
  vpabsd  xmm2,xmm2;
  vcvtdq2ps xmm2,xmm2;
  vinsertf128 ymm2,ymm2,xmm2,1;
  vdivps  ymm0,ymm0,ymm2;    // average x
  vdivps  ymm1,ymm1,ymm2;    // average y

  // calculate regresion
  xor    r11,r11;
  mov    r14,32;
  vxorps ymm2,ymm2,ymm2;    // for sum(x)
  vxorps ymm3,ymm3,ymm3;    // for sum(x)**2
  vxorps ymm4,ymm4,ymm4;    // for sum(xy)

align 16;
 @Loop1:
  vmovups ymm6,ymmword ptr [rcx+r11];
  vaddps  ymm2,ymm2,ymm6;    // sum(x)
  vmovaps ymm5,ymm6;
  vmulps  ymm6,ymm6,ymm6;    // (x)**2
  vaddps  ymm3,ymm3,ymm6;
  vmulps  ymm6,ymm5,ymmword ptr [rsp+r14]; // load ln(y) from stack
  vaddps  ymm4,ymm4,ymm6;    // sum(xy)
  add     r11,32;
  add     r14,32;
  sub     r9,1;
  jnz    @Loop1

  vhaddps ymm2,ymm2,ymm2;  // calculate the field sums
  vhaddps ymm2,ymm2,ymm2;
  vextractf128 xmm5,ymm2,1;
  vaddps  xmm2,xmm2,xmm5;

  vhaddps ymm3,ymm3,ymm3;
  vhaddps ymm3,ymm3,ymm3;
  vextractf128 xmm5,ymm3,1;
  vaddps  xmm3,xmm3,xmm5;

  vhaddps ymm4,ymm4,ymm4;
  vhaddps ymm4,ymm4,ymm4;
  vextractf128 xmm5,ymm4,1;
  vaddps  xmm4,xmm4,xmm5;

  vmulss  xmm5,xmm0,xmm2;   // xm*sum(x)
  vmulss  xmm6,xmm1,xmm2    // ym*sum(x)
  vsubss  xmm4,xmm4,xmm6;   // sum(x*ln(y)) - ym*sum(x)
  vsubss  xmm3,xmm3,xmm5;   // sum(x)**2 - xm*sum(x)
  vdivss  xmm4,xmm4,xmm3;   // b
  vmulss  xmm5,xmm0,xmm4;   // xm*b
  vsubss  xmm6,xmm1,xmm5;   // ln(a) = ym - xm*b
  vmovss  dword ptr [rsp],xmm6;
  mov     r10d,1;
  call    FN_EXP_SINGLE     // ln (a) -> a
  vmovss  xmm6,dword ptr [rsp];
  mov  rsp,r15;             // correct stack
  pop  r14;                 // load adress b

  vmovss  dword ptr [r13],xmm6;
  vmovss  dword ptr [r14],xmm4;

@ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  add rsp,32;
 {$ENDIF}
  vzeroupper;
  pop r15;
  pop r14;
  pop r13;
  pop r12;
end;

{exponential regresion y = ae^(bx)
 calculate ln(y) = ln(a) + bx
 Calculate this for 3 or 4 array pairs in cols order. When < 3 pairs use xmm
 Use the convert routines for correct order. ArrayXToT8Single
                                                  ^ 6,8}
function ExpReg4VYSingle (const Feld :array of T8Single;
                          const count :T8Int32):T8Single;
                          assembler;nostackframe;
 asm
  push r12;
  push r13;
 {$IFNDEF WIN64}
  mov rcx,rdi;      //Result
  mov rdx,rsi;      //Feld
  mov r8, rdx;      //length
  mov r9, rcx;      //count
 {$ENDIF}
 {$IFDEF WIN64}
  sub rsp,96;
  vmovdqu ymmword ptr [rsp],ymm6;
  vmovdqu ymmword ptr [rsp+32],ymm7;
  vmovdqu ymmword ptr [rsp+64],ymm8;
 {$ENDIF}
  vxorps  ymm0,ymm0,ymm0;  //for error
  test r8,r8;              // value < 0 not valid
  js   @ende;
  cmp  r8,1;               //min 2 values
  jl   @ende;
  vmovdqu ymm1,ymmword ptr [r9];
  call CHECK_T8INT32;
  test eax,eax;
  jz   @ende;
  vcvtdq2ps ymm5,ymm1;     // integer in single
  add  r8,1;
  mov  r9,r8;     // for lather
  mov  r10,r8;
  imul r10,32;
  add  r10,32;     // + byte for ln calculation in FN_LN_SINGLE
  mov  r13,rsp;    // save stack addres
  sub  rsp,r10;    // need for ln(y) values
  vxorps  ymm0,ymm0,ymm0;
  vxorps  ymm1,ymm1,ymm1;
  xor    r11,r11;
  mov    r12,16;     // for distance in stack
align 16;
 @Loop:
  vmovups ymm2,ymmword ptr [rdx+r11];  // Feld
  vextractf128 xmm3,ymm2,1;
  vshufps xmm4,xmm2,xmm3,10001000b;    // 1,3,5,7;  all x values
  vaddps  xmm0,xmm0,xmm4;
  vmovups xmmword ptr [rsp+r12],xmm4;  // save x on stack for lather
  add     r12,16;
  vshufps xmm4,xmm2,xmm3,11011101b;    // 2,4,6,8   all y values
  vmovups xmmword ptr [rsp],xmm4;
  mov     r10d,4;                      // calculate 4 ln(y) value
  call    FN_LN_SINGLE;
  vmovups xmm4,xmmword ptr [rsp];
  vaddps  xmm1,xmm1,xmm4;
  vmovups xmmword ptr [rsp+r12],xmm4;  // save ln(y) on stack for lather
  add     r11,32;
  add     r12,16;
  sub     r8,1;
  jnz     @Loop;

  vextractf128 xmm3,ymm5,1;
  vshufps xmm4,xmm5,xmm3,10001000b;    // 1,3,5,7;  all x values
  vmovaps xmm7,xmm4;
  vdivps  xmm0,xmm0,xmm4;    // average x
  vdivps  xmm1,xmm1,xmm4;    // average ln(y) we have pairs from xy

  // calculate regresion
  mov     r11,16;
  vxorps  xmm2,xmm2,xmm2;    // for sum(x)
  vxorps  xmm3,xmm3,xmm3;    // for sum(x)**2
  vxorps  xmm4,xmm4,xmm4;    // for sum(xy)

align 16;
 @Loop1:
  vmovups xmm6,xmmword ptr[rsp+r11];
  vaddps  xmm2,xmm2,xmm6;   // sum(x)
  vmovaps xmm5,xmm6;
  vmulps  xmm6,xmm6,xmm6;   // (x)**2
  vaddps  xmm3,xmm3,xmm6;
  add     r11,16;
  vmulps  xmm6,xmm5,xmmword ptr[rsp+r11];
  vaddps  xmm4,xmm4,xmm6;   // sum(xy)
  add     r11,16;
  sub     r9,1;
  jnz     @Loop1

  vpcmpeqw xmm6,xmm6,xmm6;
  vpslld  xmm6,xmm6,25;
  vpsrld  xmm6,xmm6,2;      // set 1
  vcmpps  xmm7,xmm7,xmm6,0; // count = 1?
  vandps  xmm7,xmm7,xmm6;   // set 1 for 0
  vmovaps xmm8,xmm7;
  vxorps  xmm8,xmm8,xmm6;   // set unused to 0 rest1
  vmulps  xmm0,xmm0,xmm8;   // set unused average to 0
  vmulps  xmm3,xmm3,xmm8;   // set unused sum(x)^2 to 0

  vmulps  xmm5,xmm0,xmm2;   // xm*sum(x)
  vmulps  xmm6,xmm1,xmm2    // ym*sum(x)
  vsubps  xmm4,xmm4,xmm6;   // sum(x*ln(y)) - ym*sum(x)
  vsubps  xmm3,xmm3,xmm5;   // sum(x)**2 - xm*sum(x)
  vorps   xmm7,xmm7,xmm3;   // set the correct value for the rest
  vdivps  xmm4,xmm4,xmm7;   // b
  vmulps  xmm5,xmm0,xmm4;   // xm*b
  vsubps  xmm6,xmm1,xmm5;   // ln(a) = ym - xm*b
  vmovups xmmword ptr [rsp],xmm6;
  mov     r10d,4;
  call    FN_EXP_SINGLE        // ln (a) -> a
  vmovups xmm6,xmmword ptr [rsp];
  mov     rsp,r13;             // correct stack

  // we must correct the order
  //                   xmm6 = 1,3,5,7
  //                   xmm4 = 2,4,6,8
  vshufps xmm1,xmm6,xmm4,01000100b;    //1,3,2,4,
  vshufps xmm2,xmm4,xmm6,10111011b;    //8,6,7,5
  vshufps xmm1,xmm1,xmm1,11011000b;    //1,2,3,4
  vshufps xmm2,xmm2,xmm2,00100111b;    //5,6,7,8
  vinsertf128 ymm1,ymm1,xmm2,1;
  vmovaps ymm0,ymm1;

@ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  vmovdqu ymm7,ymmword ptr [rsp+32];
  vmovdqu ymm8,ymmword ptr [rsp+96];
  add rsp,96;
 {$ENDIF}
  vmovups ymmword ptr [rcx],ymm0;
  vzeroupper;
  pop r13;
  pop r12;
end;

{regresion y = ax^(b)
calculate ln(y) = ln(a) + b*ln(x)}
function BPotenzRegYSingle (const x,y :array of T8Single;count :Longint;
                            out a,b :Single):Longbool;assembler;
 asm
  push r12;
  push r13;
  push r14;
  push r15;
 {$IFNDEF WIN64}
  mov r12d,r8d;         // count
  mov r13,r9;           // adress a
  mov rcx,rdi;          // adress x
  mov rdx,rsi;          // length x
  mov r8, rdx;          // adress y
  mov r9, rcx;          // length y
 {$ENDIF}
 {$IFDEF WIN64}
  mov  r12d,dword ptr [count];
  mov  r13,qword ptr [a];
  sub  rsp,32;
  vmovdqu ymmword ptr [rsp],ymm6;
 {$ENDIF}
  mov  r14,qword ptr [b];
  xor  rax,rax;
  vxorps ymm0,ymm0,ymm0;
  vmovss dword ptr [r13],xmm0;
  vmovss dword ptr [r14],xmm0;     // for error
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  test r12d,r12d;
  jz   @ende;
  jns  @1;
  neg  r12d;
 @1:
  cmp  r12d,2;      // min 2 values
  jb   @ende;
  cmp  rdx,r9;     // cmp length x and y
  jne  @ende;
  mov  rax,1;
  push r14;        // save adress b
  add  rdx,1;
  mov  r10,rdx;
  imul r10,64;     // for stack place for ln(x) and ln(y)
  add  r10,64;     // + byte for ln calculation in FN_LN_SINGLE
  mov  r15,rsp;    // save stack addres
  sub  rsp,r10;    // need for ln values
  vxorps ymm0,ymm0,ymm0;
  vxorps ymm1,ymm1,ymm1;
  mov   r9,rdx;     // we not need length of y array for lather
  xor   r11,r11;
  mov   r14,32;     // for distance in stack for ly(y) result
align 16;
 @Loop:
  vmovups ymm2,ymmword ptr [rcx+r11];  // x
  vmovups ymmword ptr [rsp],ymm2;
  mov    r10d,8;                    // calculate ln(x) 4 value
  call   FN_LN_SINGLE;
  vmovups ymm2,ymmword ptr [rsp];
  vaddps  ymm0,ymm0,ymm2;
  vmovups ymmword ptr [rsp+r14],ymm2;  // save ln(x) on stack
  vmovups ymm2,ymmword ptr [r8+r11];  // y
  vmovups ymmword ptr [rsp],ymm2;
  mov    r10d,8;                    // calculate ln(y) 4 value
  call   FN_LN_SINGLE;
  vmovups ymm2,ymmword ptr [rsp];
  vaddps  ymm1,ymm1,ymm2;
  add    r14,32;
  vmovups ymmword ptr [rsp+r14],ymm2; // save ln(y) on stack
  add    r11,32;
  add    r14,32;
  sub    rdx,1;
  jnz    @Loop;

  vhaddps ymm0,ymm0,ymm0;    // sum over all fields
  vhaddps ymm0,ymm0,ymm0;
  vextractf128 xmm2,ymm0,1;
  vaddps  xmm0,xmm0,xmm2;
  vinsertf128 ymm0,ymm0,xmm0,1;

  vhaddps ymm1,ymm1,ymm1;
  vhaddps ymm1,ymm1,ymm1;
  vextractf128 xmm2,ymm1,1;
  vaddps  xmm1,xmm1,xmm2;
  vinsertf128 ymm1,ymm1,xmm1,1;

  vpinsrd xmm2,xmm2,r12d,0;
  vpshufd xmm2,xmm2,0;
  vpabsd  xmm2,xmm2;
  vcvtdq2ps xmm2,xmm2;
  vinsertf128 ymm2,ymm2,xmm2,1;
  vdivps  ymm0,ymm0,ymm2;    // average x
  vdivps  ymm1,ymm1,ymm2;    // average y

  // calculate regresion
  mov    r11,32;             // start value on stack for ln(x) values
  vxorps ymm2,ymm2,ymm2;     // for sum(x)
  vxorps ymm3,ymm3,ymm3;     // for sum(x)**2
  vxorps ymm4,ymm4,ymm4;     // for sum(xy)

align 16;
 @Loop1:
  vmovups ymm6,ymmword ptr[rsp+r11]; // load ln(x) from stack
  vaddps  ymm2,ymm2,ymm6;    // sum(x)
  vmovaps ymm5,ymm6;
  vmulps  ymm6,ymm6,ymm6;    // (x)**2
  vaddps  ymm3,ymm3,ymm6;
  add     r11,32;
  vmulps  ymm6,ymm5,ymmword ptr[rsp+r11]; // load ln(y) from stack
  vaddps  ymm4,ymm4,ymm6;    // sum(xy)
  add     r11,32;
  sub     r9,1;
  jnz     @Loop1

  vhaddps ymm2,ymm2,ymm2;    // sum over all fields
  vhaddps ymm2,ymm2,ymm2;
  vextractf128 xmm5,ymm2,1;
  vaddps  xmm2,xmm2,xmm5;

  vhaddps ymm3,ymm3,ymm3
  vhaddps ymm3,ymm3,ymm3
  vextractf128 xmm5,ymm3,1;
  vaddps  xmm3,xmm3,xmm5;

  vhaddps ymm4,ymm4,ymm4
  vhaddps ymm4,ymm4,ymm4
  vextractf128 xmm5,ymm4,1;
  vaddps  xmm4,xmm4,xmm5;

  vmovss  xmm5,xmm0,xmm0;
  vmovss  xmm6,xmm1,xmm1;
  vmulss  xmm1,xmm1,xmm2    // ln(ym)*sum(ln(x))
  vmulss  xmm0,xmm0,xmm2;   // ln(xm)*sum(ln(x))
  vsubss  xmm4,xmm4,xmm1;   // sum(ln(x)*ln(y)) - ln(ym)*sum(ln(x))
  vsubss  xmm3,xmm3,xmm0;   // sum(ln(x))**2 - ln(xm)*sum(ln(x))
  vdivss  xmm4,xmm4,xmm3;   // b
  vmulss  xmm5,xmm5,xmm4;   // ln(xm)*b
  vsubss  xmm6,xmm6,xmm5;   // ln(a) = ln(ym) -ln(xm)*b
  vmovss  dword ptr [rsp],xmm6;
  mov     r10d,1;
  call    FN_EXP_SINGLE        // ln (a) -> a
  vmovss  xmm6,dword ptr [rsp];
  mov     rsp,r15;       // stack correct
  pop     r14;           // load adress b

  vmovss dword ptr [r13],xmm6;
  vmovss dword ptr [r14],xmm4;

 @ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  add rsp,32;
 {$ENDIF}
  vzeroupper;
  pop r15;
  pop r14;
  pop r13;
  pop r12;
end;

{regresion y = ax^(b)
 calculate ln(y) = ln(a) + b*ln(x)
 Calculate this for up 3 or 4 array pairs in cols order. Use the convert routines
 for the correct order. ArrayXToT8Single
                             ^ 6,8}
function BPotenzReg4VYSingle (const Feld :array of T8Single;
                              const count :T8Int32):T8Single;
                             assembler;nostackframe;
 asm
  push r14;
  push r15;
 {$IFNDEF WIN64}
  mov rcx,rdi;          // Result
  mov rdx,rsi;          // Feld
  mov r8, rdx;          // length
  mov r9, rcx;          // count
 {$ENDIF}
 {$IFDEF WIN64}
  sub rsp,64;
  vmovdqu ymmword ptr [rsp],ymm6;
  vmovdqu ymmword ptr [rsp+32],ymm7;
 {$ENDIF}
  vxorps ymm0,ymm0,ymm0;
  test r8,r8;                     // value < 0 not valid
  js   @ende;
  cmp  r8,1;                // min 2 values
  jl   @ende;
  vmovdqu ymm1,ymmword ptr [r9];
  call CHECK_T8INT32;
  test eax,eax;
  jz   @ende;
  vcvtdq2ps  ymm5,ymm1;

  add  r8,1;         // length Feld
  mov  r9,r8;
  mov  r10,r8;
  imul r10,32;      // stack place for ln(x) and ln(y)
  add  r10,32;      // +  byte for ln calculation in FN_LN_SINGLE
  mov  r15,rsp;     // save stack addres
  sub  rsp,r10;     // need for ln values
  vxorps ymm0,ymm0,ymm0;
  vxorps ymm1,ymm1,ymm1;
  xor   r11,r11;
  mov   r14,16;     // distance in stack for ly(y) result
align 16;
 @Loop:
  vmovups ymm2,ymmword ptr [rdx+r11];  // Feld
  vextractf128 xmm3,ymm2,1;
  vshufps xmm4,xmm2,xmm3,10001000b;    // 1,3,5,7;
  vmovups xmmword ptr [rsp],xmm4;
  mov     r10d,4;                    // calculate ln(x) 4 value
  call    FN_LN_SINGLE;
  vmovups xmm4,xmmword ptr [rsp];
  vaddps  xmm0,xmm0,xmm4;
  vmovups xmmword ptr [rsp+r14],xmm4;  // save ln(x) on stack
  add     r14,16;
  vshufps xmm4,xmm2,xmm3,11011101b;    // 2,4,6,8
  vmovups xmmword ptr [rsp],xmm4;
  mov     r10d,4;                    // calculate ln(y) 4 value
  call    FN_LN_SINGLE;
  vmovups xmm4,xmmword ptr [rsp];
  vaddps  xmm1,xmm1,xmm4;
  vmovups xmmword ptr [rsp+r14],xmm4; // save ln(y) on stack
  add    r11,32;
  add    r14,16;
  sub    r8,1;
  jnz    @Loop;

  vextractf128 xmm3,ymm5,1;
  vshufps xmm4,xmm5,xmm3,10001000b;    // 1,3,5,7;
  vmovaps xmm7,xmm4;
  vdivps  xmm0,xmm0,xmm4;    // average x
  vdivps  xmm1,xmm1,xmm4;    // average y we have array pairs

  // calculate regresion
  mov  r11,16;               // start value on stack for ln(x) values
  vxorps ymm2,ymm2,ymm2;     // for sum(x)
  vxorps ymm3,ymm3,ymm3;     // for sum(x)**2
  vxorps ymm4,ymm4,ymm4;     // for sum(xy)

align 16;
 @Loop1:
  vmovups xmm6,xmmword ptr [rsp+r11]; // load ln(x) from stack
  vaddps  xmm2,xmm2,xmm6;    // sum(x)
  vmovaps xmm5,xmm6;
  vmulps  xmm6,xmm6,xmm6;    // (x)**2
  vaddps  xmm3,xmm3,xmm6;
  add     r11,16;
  vmulps  xmm6,xmm5,xmmword ptr [rsp+r11];
  vaddps  xmm4,xmm4,xmm6;    // sum(xy)
  add     r11,16;
  sub     r9,1;
  jnz     @Loop1

  vmulps  xmm5,xmm0,xmm2;   // ln(xm)*sum(ln(x))
  vmulps  xmm2,xmm1,xmm2    // ln(ym)*sum(ln(x))
  vsubps  xmm4,xmm4,xmm2;   // sum(ln(x)*ln(y)) - ln(ym)*sum(ln(x))
  vsubps  xmm3,xmm3,xmm5;   // sum(ln(x))**2 - ln(xm)*sum(ln(x))
  vpcmpeqw xmm6,xmm6,xmm6;
  vpslld  xmm6,xmm6,25;
  vpsrld  xmm6,xmm6,2;        // set 1
  vcmpps  xmm7,xmm7,xmm6,0;   // = 1?
  vandps  xmm7,xmm7,xmm6;     // set 1 for 0
  vorps   xmm7,xmm7,xmm3;     // set the rest with correct values
  vdivps  xmm4,xmm4,xmm7;   // b
  vmulps  xmm5,xmm0,xmm4;   // ln(xm)*b
  vsubps  xmm6,xmm1,xmm5;   // ln(a) = ln(ym) -ln(xm)*b
  vmovups xmmword ptr [rsp],xmm6;
  mov     r10d,4;
  call    FN_EXP_SINGLE        // ln (a) -> a
  vmovups xmm6,xmmword ptr [rsp];
  mov     rsp,r15;       // stack correct

  // correct positions
  //                  xmm6 = a = 1,3,5,7
  //                  xmm4 = b = 2,4,6,8
  vshufps xmm1,xmm6,xmm4,01000100b;    //1,3,2,4,
  vshufps xmm2,xmm4,xmm6,10111011b;    //8,6,7,5
  vshufps xmm1,xmm1,xmm1,11011000b;    //1,2,3,4
  vshufps xmm2,xmm2,xmm2,00100111b;    //5,6,7,8
  vinsertf128 ymm1,ymm1,xmm2,1;
  vmovaps ymm0,ymm1;

 @ende:
  vmovups ymmword ptr [rcx],ymm0;
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  vmovdqu ymm7,ymmword ptr [rsp+32];
  add rsp,64;
 {$ENDIF}
  vzeroupper;
  pop r15;
  pop r14;
end;


{potenz regresion y = ab^(x)
calculate ln(y) = ln(a) + x*ln(b)}
function XPotenzRegYSingle (const x,y :array of T8Single;count :Longint;
                            out a,b :Single):Longbool;assembler;
 asm
  push r12;
  push r13;
  push r14;
  push r15;
 {$IFNDEF WIN64}
  mov r12d,r8d;    // count
  mov r13,r9;      // adress a
  mov rcx,rdi;     // adress x
  mov rdx,rsi;     // length x
  mov r8, rdx;     // adress y
  mov r9, rcx;     // length y
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12d,dword ptr [count];
  mov r13,qword ptr [a];
  sub rsp,32;
  vmovdqu ymmword ptr [rsp],ymm6;
 {$ENDIF}
  mov  r14,qword ptr [b];
  xor  rax,rax;
  vxorps ymm0,ymm0,ymm0;
  vmovss dword ptr [r13],xmm0;
  vmovss dword ptr [r14],xmm0;     // for error
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  test r12d,r12d;
  jz   @ende;
  jns  @1;
  neg  r12d;
 @1:
  cmp  r12d,2;        // min 2 values
  jb   @ende;
  cmp  rdx,r9;       // length x = y
  jne  @ende;
  mov  rax,1;
  push r14;          // save adress b
  add  rdx,1;
  mov  r10,rdx;
  imul r10,32;
  add  r10,64;     // + byte for ln calculation in FN_LN_SINGLE
  mov  r15,rsp;    // save stack addres
  sub  rsp,r10;    // need for ln(y) values
  vxorps ymm0,ymm0,ymm0;
  vxorps ymm1,ymm1,ymm1;
  mov  r9,rdx;     // no need  y array length for lather
  xor  r11,r11;
  mov  r14,32;     // for distance in stack for ly(y) result
align 16;
 @Loop:
  vaddps  ymm0,ymm0,ymmword ptr [rcx+r11];  // x
  vmovups ymm2,ymmword ptr [r8+r11];  // y
  vmovups ymmword ptr [rsp],ymm2;
  mov    r10d,8;                    // calculate 8 ln(y) value
  call   FN_LN_SINGLE;
  vmovups ymm2,ymmword ptr [rsp];
  vaddps  ymm1,ymm1,ymm2;
  vmovups ymmword ptr [rsp+r14],ymm2; // save ln(xmm2) on stack for lather
  add    r11,32;
  add    r14,32;
  sub    r9,1;
  jnz    @Loop;

  vhaddps ymm0,ymm0,ymm0;    // sum over all fields
  vhaddps ymm0,ymm0,ymm0;
  vextractf128 xmm2,ymm0,1;
  vaddps  xmm0,xmm0,xmm2;
  vinsertf128 ymm0,ymm0,xmm0,1;

  vhaddps ymm1,ymm1,ymm1
  vhaddps ymm1,ymm1,ymm1
  vextractf128 xmm2,ymm1,1;
  vaddps  xmm1,xmm1,xmm2;
  vinsertf128 ymm1,ymm1,xmm1,1;

  vpinsrd xmm2,xmm2,r12d,0;
  vpshufd xmm2,xmm2,0;
  vpabsd  xmm2,xmm2;
  vcvtdq2ps xmm2,xmm2;
  vinsertf128 ymm2,ymm2,xmm2,1;
  vdivps  ymm0,ymm0,ymm2;    // average x
  vdivps  ymm1,ymm1,ymm2;    // average y

  // calculate regresion
  xor    r11,r11;
  mov    r14,32;
  vxorps ymm2,ymm2,ymm2;   // for sum(x)
  vxorps ymm3,ymm3,ymm3;   // for sum(x)**2
  vxorps ymm4,ymm4,ymm4;   // for sum(xy)

align 16;
 @Loop1:
  vmovups ymm6,ymmword ptr[rcx+r11];
  vaddps  ymm2,ymm2,ymm6;    // sum(x)
  vmovaps ymm5,ymm6;
  vmulps  ymm6,ymm6,ymm6;    // (x)**2
  vaddps  ymm3,ymm3,ymm6;
  vmulps  ymm6,ymm5,ymmword ptr[rsp+r14]; // load ln(y) from stack
  vaddps  ymm4,ymm4,ymm6;    // sum(xy)
  add     r11,32;
  add     r14,32;
  sub     rdx,1;
  jnz     @Loop1

  vhaddps ymm2,ymm2,ymm2;  // calculate the field sums
  vhaddps ymm2,ymm2,ymm2;
  vextractf128 xmm5,ymm2,1;
  vaddps  xmm2,xmm2,xmm5;

  vhaddps ymm3,ymm3,ymm3;
  vhaddps ymm3,ymm3,ymm3;
  vextractf128 xmm5,ymm3,1;
  vaddps  xmm3,xmm3,xmm5;

  vhaddps ymm4,ymm4,ymm4;
  vhaddps ymm4,ymm4,ymm4;
  vextractf128 xmm5,ymm4,1;
  vaddps  xmm4,xmm4,xmm5;

  vmovss xmm5,xmm0,xmm0;
  vmovss xmm6,xmm1,xmm1;
  vmulss xmm1,xmm1,xmm2    // ym*sum(x)
  vmulss xmm0,xmm0,xmm2;   // xm*sum(x)
  vsubss xmm4,xmm4,xmm1;   // sum(x*ln(y)) - ym*sum(x)
  vsubss xmm3,xmm3,xmm0;   // sum(x)**2 - xm*sum(x)
  vdivss xmm4,xmm4,xmm3;   // ln(b)
  vmulss xmm5,xmm5,xmm4;   // xm*ln(b)
  vsubss xmm6,xmm6,xmm5;   // ln(a) = ln(ym) -xm*ln(b)
  vmovss dword ptr [rsp],xmm4;
  mov    r10d,1;
  call   FN_EXP_SINGLE       // ln(b) -> b
  vmovss xmm4,dword ptr [rsp];
  vmovss dword ptr [rsp],xmm6;
  mov    r10d,1;
  call   FN_EXP_SINGLE       // ln(a) -> a
  vmovss xmm6,dword ptr [rsp];
  mov    rsp,r15;            // correct stack
  pop    r14;                // load adress b

  vmovss dword ptr [r13],xmm6;
  vmovss dword ptr [r14],xmm4;

 @ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  add rsp,32;
 {$ENDIF}
  vzeroupper;
  pop r15;
  pop r14;
  pop r13;
  pop r12;
end;

{potenz regresion y = ab^(x)
 calc ln(y) = ln(a) + x*ln(b)
 calculate this for 3 or 4 array pairs in cols order. Use the convert routines
 for correct order. ArrayXToT8Single
                         ^ 6 or 8}
function XPotenzReg4VYSingle (const Feld :array of T8Single;
                              const count :T8Int32):T8Single;
                              assembler;nostackframe;
 asm
  push r14;
  push r15;
 {$IFNDEF WIN64}
  mov rcx,rdi;     // Result
  mov rdx,rsi;     // Feld
  mov r8, rdx;     // length
  mov r9, rcx;     // count
 {$ENDIF}
 {$IFDEF WIN64}
  sub rsp,32;
  vmovdqu ymmword ptr [rsp],ymm6;
 {$ENDIF}
  vxorps  ymm0,ymm0,ymm0;
  test r8,r8;                     // value < 0 not valid
  js   @ende;
  cmp  r8,1;            // min 2 values
  jl   @ende;
  vmovdqu ymm1,ymmword ptr [r9];
  call CHECK_T8INT32;   // check for equal counts for the pairs
  test eax,eax;
  jz   @ende;
  vcvtdq2ps ymm5,ymm1;   // set integer to single

  add  r8,1;
  mov  r9,r8;
  mov  r10,r8;
  imul r10,32;
  add  r10,32;     // + byte for ln calculation in FN_LN_SINGLE
  mov  r15,rsp;    // save stack addres
  sub  rsp,r10;    // need for ln(y) values
  vxorps ymm0,ymm0,ymm0;
  vxorps ymm1,ymm1,ymm1;
  xor  r11,r11;
  mov  r14,16;     // for distance in stack for ly(y) result
align 16;
 @Loop:
  vmovups ymm2,ymmword ptr [rdx+r11];  // Feld
  // we separate the array in x and y value
  vextractf128 xmm3,ymm2,1;
  vshufps xmm4,xmm2,xmm3,10001000b;    // 1,3,5,7;   x value
  vaddps  xmm0,xmm0,xmm4;
  vmovups xmmword ptr [rsp+r14],xmm4;  // save x values
  add     r14,16;
  vshufps xmm4,xmm2,xmm3,11011101b;    // 2,4,6,8    y value
  vmovups xmmword ptr [rsp],xmm4;
  mov     r10d,4;                    // calculate 4 ln(y) value
  call    FN_LN_SINGLE;
  vmovups xmm4,xmmword ptr [rsp];
  vaddps  xmm1,xmm1,xmm4;
  vmovups xmmword ptr [rsp+r14],xmm4; // save ln(y) on stack for lather
  add  r11,32;
  add  r14,16;
  sub  r8,1;
  jnz  @Loop;

  vextractf128 xmm3,ymm5,1;
  vshufps xmm4,xmm5,xmm3,10001000b;    // 1,3,5,7;   x value
  vdivps  xmm0,xmm0,xmm4;    // average x
  vdivps  xmm1,xmm1,xmm4;    // average y  we have array pairs

  // calculate regresion
  mov  r11,16;
  vxorps ymm2,ymm2,ymm2;   // for sum(x)
  vxorps ymm3,ymm3,ymm3;   // for sum(x)**2
  vxorps ymm4,ymm4,ymm4;   // for sum(xy)

align 16;
 @Loop1:
  vmovups xmm6,xmmword ptr[rsp+r11];
  vaddps  xmm2,xmm2,xmm6;    // sum(x)
  vmovaps xmm5,xmm6;
  vmulps  xmm6,xmm6,xmm6;    // (x)**2
  vaddps  xmm3,xmm3,xmm6;
  add     r11,16;
  vmulps  xmm6,xmm5,xmmword ptr[rsp+r11];
  vaddps  xmm4,xmm4,xmm6;    // sum(xy)
  add     r11,16;
  sub     r9,1;
  jnz     @Loop1

  vmovaps xmm5,xmm0;        //xm
  vmovaps xmm6,xmm1;        //ym
  vmulps  xmm5,xmm0,xmm2;   // xm*sum(x)
  vmulps  xmm2,xmm1,xmm2    // ym*sum(x)
  vsubps  xmm4,xmm4,xmm2;   // sum(x*ln(y)) - ym*sum(x)
  vsubps  xmm3,xmm3,xmm5;   // sum(x)**2 - xm*sum(x)
  vdivps  xmm4,xmm4,xmm3;   // ln(b)
  vmulps  xmm5,xmm0,xmm4;   // xm*ln(b)
  vsubps  xmm6,xmm1,xmm5;   // ln(a) = ln(ym) -xm*ln(b)
  vmovups xmmword ptr [rsp],xmm4;
  mov     r10d,4;
  call    FN_EXP_SINGLE       // ln(b) -> b
  vmovups xmm4,xmmword ptr [rsp];
  vmovups xmmword ptr [rsp],xmm6;
  mov     r10d,4;
  call    FN_EXP_SINGLE       // ln(a) -> a
  vmovups xmm6,xmmword ptr [rsp];
  mov     rsp,r15;            // correct stack

  //correct
  // a = 1,3,5,7
  // b = 2,4,6,8
  vshufps xmm1,xmm6,xmm4,01000100b;    //1,3,2,4,
  vshufps xmm2,xmm4,xmm6,10111011b;    //8,6,7,5
  vshufps xmm1,xmm1,xmm1,11011000b;    //1,2,3,4
  vshufps xmm2,xmm2,xmm2,00100111b;    //5,6,7,8
  vinsertf128 ymm1,ymm1,xmm2,1;
  vmovaps ymm0,ymm1;

 @ende:
  vmovups ymmword ptr [rcx],ymm0;
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  add rsp,32;
 {$ENDIF}
  vzeroupper;
  pop r15;
  pop r14;
end;


{Potenz regresion y = ab^(x)
calculate ln(y) = ln(a) + x*ln(b)}
function XPotenzRegYDouble (const x,y :array of T4Double;count :Longint;
                            out a,b :Double):Longbool;assembler;
 asm
  push r12;
  push r13;
  push r14;
  push r15;
 {$IFNDEF WIN64}
  mov r12d,r8d;     //count
  mov r13,r9;       //a
  mov rcx,rdi;      //x
  mov rdx,rsi;
  mov r8, rdx;      //y
  mov r9, rcx;
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12d,dword ptr [count];
  mov r13,qword ptr [a];
  sub rsp,32;
  vmovdqu ymmword ptr [rsp],ymm6;
 {$ENDIF}
  mov r14,qword ptr [b];
  xor  rax,rax;
  vxorps ymm0,ymm0,ymm0;
  vmovsd qword ptr [r13],xmm0;
  vmovsd qword ptr [r14],xmm0;     // for error
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  test r12d,r12d;
  jz   @ende;
  jns  @1;
  neg  r12d;
 @1:
  cmp  r12d,2;     // min 2 values
  jb   @ende;
  cmp  rdx,r9;     // cmp length x and y
  jne  @ende;
  mov  rax,1;
  push r14;        // save adress b
  add  rdx,1;
  mov  r10,rdx;
  imul r10,32;
  add  r10,32;     // + 16 byte for ln calculation in FN_LN_SINGLE
  add  r10,32;
  mov  r15,rsp;    // save stack addres
  sub  rsp,r10;    // need for ln(y) values
  vxorpd ymm0,ymm0,ymm0;
  vxorpd ymm1,ymm1,ymm1;
  mov  r9,rdx;
  xor  r11,r11;
  mov  r14,32;     // for distance in stack for ly(y) result
align 16;
 @Loop:
  vaddpd  ymm0,ymm0,ymmword ptr [rcx+r11];  // x
  vmovupd ymm2,ymmword ptr [r8+r11];   // y
  vmovupd ymmword ptr [rsp],ymm2;
  mov     r10d,4;                       // calculate 4 double value
  call    FN_LN_DOUBLE;
  vmovupd ymm2,ymmword ptr [rsp];
  vaddpd  ymm1,ymm1,ymm2;
  vmovupd ymmword ptr [rsp+r14],ymm2; // save ln(xmm2) on stack for lather
  add  r11,32;
  add  r14,32;
  sub  r9,1;
  jnz  @Loop;

  vhaddpd ymm0,ymm0,ymm0;
  vextractf128 xmm2,ymm0,1;
  vaddpd xmm0,xmm0,xmm2;
  vinsertf128 ymm0,ymm0,xmm0,1;

  vhaddpd ymm1,ymm1,ymm1;
  vextractf128 xmm2,ymm1,1;
  vaddpd xmm1,xmm1,xmm2;
  vinsertf128 ymm1,ymm1,xmm1,1;

  vpinsrd  xmm2,xmm2,r12d,0;
  vmovddup xmm2,xmm2;
  vpabsd   xmm2,xmm2;
  vcvtdq2pd ymm2,xmm2;
  vdivpd  ymm0,ymm0,ymm2;    // average x
  vdivpd  ymm1,ymm1,ymm2;    // average y

  // calculate regresion
  xor    r11,r11;
  mov    r14,32;
  vxorps ymm2,ymm2,ymm2;   // for sum(x)
  vxorps ymm3,ymm3,ymm3;   // for sum(x)**2
  vxorps ymm4,ymm4,ymm4;   // for sum(xy)

align 16;
 @Loop1:
  vmovupd ymm6,ymmword ptr[rcx+r11];
  vaddpd  ymm2,ymm2,ymm6;    // sum(x)
  vmovapd ymm5,ymm6;
  vmulpd  ymm6,ymm6,ymm6;    // (x)**2
  vaddpd  ymm3,ymm3,ymm6;    // sum(x**2)
  vmulpd  ymm6,ymm5,ymmword ptr[rsp+r14]; // load ln(y) from stack
  vaddpd  ymm4,ymm4,ymm6;    // sum(x*ln(y))
  add     r11,32;
  add     r14,32;
  sub     rdx,1;
  jnz     @Loop1

  vhaddpd ymm2,ymm2,ymm2;
  vextractf128 xmm5,ymm2,1;
  vaddpd xmm2,xmm2,xmm5;

  vhaddpd ymm3,ymm3,ymm3;
  vextractf128 xmm5,ymm3,1;
  vaddpd xmm3,xmm3,xmm5;

  vhaddpd ymm4,ymm4,ymm4;
  vextractf128 xmm5,ymm4,1;
  vaddpd xmm4,xmm4,xmm5;

  vmovsd xmm5,xmm0,xmm0;
  vmovsd xmm6,xmm1,xmm1;
  vmulsd xmm1,xmm1,xmm2    // ym*sum(x)
  vmulsd xmm0,xmm0,xmm2;   // xm*sum(x)
  vsubsd xmm4,xmm4,xmm1;   // sum(x*ln(y)) - ym*sum(x)
  vsubsd xmm3,xmm3,xmm0;   // sum(x)**2 - xm*sum(x)
  vdivsd xmm4,xmm4,xmm3;   // ln(b)
  vmulsd xmm5,xmm5,xmm4;   // xm*b
  vsubsd xmm6,xmm6,xmm5;   // ln(a) = ym -xm*b
  vmovsd qword ptr [rsp],xmm4;
  mov    r10d,1;
  call   FN_EXP_DOUBLE       // ln(b) -> b
  vmovsd xmm4,[rsp];
  vmovsd qword ptr [rsp],xmm6;
  mov r10d,1;
  call FN_EXP_DOUBLE       // ln (a) -> a
  vmovsd xmm6,[rsp];
  mov  rsp,r15;      // stack correct
  pop  r14;

  vmovsd qword ptr [r13],xmm6;
  vmovsd qword ptr [r14],xmm4;

 @ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  add rsp,32;
 {$ENDIF}
  vzeroupper;
  pop r15;
  pop r14;
  pop r13;
  pop r12;
end;


{Potenz regresion y = ab^(x)
 calculate ln(y) = ln(a) + x*ln(b)
 Calculation for 2 array pairs in cols order. Use the convert routines
 for the correct order (Array4ToT4Double).}
function XPotenzReg2VYDouble (const Feld :array of T4Double;
                              const count :T4Int32):T4Double;
                              assembler;nostackframe;
 asm
  push r14;
  push r15;
 {$IFNDEF WIN64}
  mov rcx,rdi;        //Result
  mov rdx,rsi;        //feld
  mov r8, rdx;        //length
  mov r9, rcx;        //count
 {$ENDIF}
 {$IFDEF WIN64}
  sub rsp,32;
  vmovdqu ymmword ptr [rsp],ymm6;
 {$ENDIF}
  vxorpd  ymm0,ymm0,ymm0;   //for error
  test r8,r8;               // value < 0 not valid
  js   @ende;
  cmp  r8,1;                // min 2 values
  jl   @ende;
  vmovdqu xmm1,xmmword ptr [r9];
  call CHECK_T4INT32;
  test eax,eax;
  jz   @ende;
  vcvtdq2pd   xmm5,xmm1;  // only need lower lane

  add  r8,1;
  mov  r9,r8;
  mov  r10,r8;
  imul r10,32;
  add  r10,32;     // + byte for ln calculation in FN_LN_SINGLE
  mov  r15,rsp;    // save stack addres
  sub  rsp,r10;    // need for ln(y) values
  vxorpd ymm0,ymm0,ymm0;
  vxorpd ymm1,ymm1,ymm1;
  xor  r11,r11;
  mov  r14,16;     // for distance in stack for ly(y) result
align 16;
 @Loop:
  vmovupd ymm2,ymmword ptr [rdx+r11];  // Feld
  vextractf128 xmm3,ymm2,1;
  vshufpd xmm4,xmm2,xmm3,0;            //1,3  x values
  vaddpd  xmm0,xmm0,xmm4;
  vmovupd xmmword ptr [rsp+r14],xmm4;
  add     r14,16;
  vshufpd xmm4,xmm2,xmm3,00000011b;    //2,4  y values
  vmovupd xmmword ptr [rsp],xmm4;
  mov     r10d,2;                       // calculate 2 ln(y) value
  call    FN_LN_DOUBLE;
  vmovupd xmm4,xmmword ptr [rsp];
  vaddpd  xmm1,xmm1,xmm4;
  vmovupd xmmword ptr [rsp+r14],xmm4; // save ln(xmm2) on stack for lather
  add  r11,32;
  add  r14,16;
  sub  r8,1;
  jnz  @Loop;

  vshufpd xmm4,xmm5,xmm5,00000000b;
  vdivpd  xmm0,xmm0,xmm4;    // average x
  vdivpd  xmm1,xmm1,xmm4;    // average y

  // calculate regresion
  mov    r14,16;
  vxorps ymm2,ymm2,ymm2;   // for sum(x)
  vxorps ymm3,ymm3,ymm3;   // for sum(x)**2
  vxorps ymm4,ymm4,ymm4;   // for sum(xy)

align 16;
 @Loop1:
  vmovupd xmm6,xmmword ptr[rsp+r14];
  vaddpd  xmm2,xmm2,xmm6;    // sum(x)
  vmovapd xmm5,xmm6;
  vmulpd  xmm6,xmm6,xmm6;    // (x)**2
  vaddpd  xmm3,xmm3,xmm6;    // sum(x**2)
  add r14,16;
  vmulpd  xmm6,xmm5,xmmword ptr[rsp+r14]; // load ln(y) from stack
  vaddpd  xmm4,xmm4,xmm6;    // sum(x*ln(y))
  add     r14,16;
  sub     r9,1;
  jnz     @Loop1

  vmovapd xmm5,xmm0;        //xm
  vmovapd xmm6,xmm1;        //ym
  vmulpd  xmm5,xmm0,xmm2;   // xm*sum(x)
  vmulpd  xmm2,xmm1,xmm2    // ym*sum(x)
  vsubpd  xmm4,xmm4,xmm2;   // sum(x*ln(y)) - ym*sum(x)
  vsubpd  xmm3,xmm3,xmm5;   // sum(x)**2 - xm*sum(x)
  vdivpd  xmm4,xmm4,xmm3;   // ln(b)
  vmulpd  xmm5,xmm0,xmm4;   // xm*b
  vsubpd  xmm6,xmm1,xmm5;   // ln(a) = ym -xm*b
  vmovupd xmmword ptr [rsp],xmm4;
  mov     r10d,2;
  call    FN_EXP_DOUBLE       // ln(b) -> b
  vmovupd xmm4,xmmword ptr [rsp];
  vmovupd xmmword ptr [rsp],xmm6;
  mov     r10d,2;
  call    FN_EXP_DOUBLE       // ln (a) -> a
  vmovupd xmm6,xmmword ptr [rsp];
  mov     rsp,r15;      // stack correct

  // correct
  // a 1,3
  // b 2,4
  vshufpd xmm1,xmm6,xmm4,00000000b;
  vshufpd xmm2,xmm6,xmm4,00000011b;
  vinsertf128 ymm0,ymm0,xmm1,0;
  vinsertf128 ymm0,ymm0,xmm2,1;

 @ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  add rsp,32;
 {$ENDIF}
  vmovupd ymmword ptr [rcx],ymm0;
  vzeroupper;
  pop r15;
  pop r14;
end;

{regresion y = ax^(b)
calculate ln(y) = ln(a) + b*ln(x)}
function BPotenzRegYDouble (const x,y :array of T4Double;count :Longint;
                            out a,b :Double):Longbool;assembler;
 asm
  push r12;
  push r13;
  push r14;
  push r15;
 {$IFNDEF WIN64}
  mov r12d,r8d;     //count
  mov r13,r9;       //a
  mov rcx,rdi;      //x
  mov rdx,rsi;
  mov r8, rdx;      //y
  mov r9, rcx;
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12d,dword ptr [count];
  mov r13,qword ptr [a];
  sub rsp,32;
  vmovdqu ymmword ptr [rsp],ymm6;
 {$ENDIF}
  mov r14,qword ptr [b];
  xor  rax,rax;
  vxorpd ymm0,ymm0,ymm0;
  vmovsd qword ptr [r13],xmm0;
  vmovsd qword ptr [r14],xmm0;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  test r12d,r12d;
  jz   @ende;
  jns  @1;
  neg  r12d;
 @1:
  cmp  r12d,2;      // min 2 values
  jb   @ende;
  cmp  rdx,r9;     // cmp length x and y
  jne  @ende;
  mov  rax,1;
  push r14;
  add  rdx,1;
  mov  r10,rdx;
  imul r10,64;     // for 2* stack place
  add  r10,32;     // + 16 byte for ln calculation in FN_LN_SINGLE
  add  r10,32;
  mov  r15,rsp;    // save stack addres
  sub  rsp,r10;    // need for ln(y) values
  vxorpd ymm0,ymm0,ymm0;
  vxorpd ymm1,ymm1,ymm1;
  xor  r11,r11;
  mov  r14,32;     // for distance in stack for ly(y) result
  mov  r9,rdx;
align 16;
 @Loop:
  vmovupd ymm2,ymmword ptr [rcx+r11];  // x
  vmovupd ymmword ptr [rsp],ymm2;
  mov    r10d,4;                    // calculate 4 ln(x) value
  call   FN_LN_DOUBLE;
  vmovupd ymm2,ymmword ptr [rsp];
  vaddpd  ymm0,ymm0,ymm2;
  vmovupd ymmword ptr [rsp+r14],ymm2;
  vmovupd ymm2,ymmword ptr [r8+r11];  // y
  vmovupd ymmword ptr [rsp],ymm2;
  mov    r10d,4;                    // calculate 4 ln(y) value
  call   FN_LN_DOUBLE;
  vmovupd ymm2,ymmword ptr [rsp];
  vaddpd  ymm1,ymm1,ymm2;
  add    r14,32;
  vmovupd ymmword ptr [rsp+r14],ymm2; // save ln(xmm2) on stack for lather
  add    r11,32;
  add    r14,32;
  sub    r9,1;
  jnz    @Loop;

  vhaddpd ymm0,ymm0,ymm0;    // sum over all fields
  vextractf128 xmm2,ymm0,1;
  vaddpd  xmm0,xmm0,xmm2;
  vinsertf128 ymm0,ymm0,xmm0,1;

  vhaddpd ymm1,ymm1,ymm1;
  vextractf128 xmm2,ymm1,1;
  vaddpd  xmm1,xmm1,xmm2;
  vinsertf128 ymm1,ymm1,xmm1,1;

  vpinsrd xmm2,xmm2,r12d,0;
  vmovddup xmm2,xmm2;
  vpabsd  xmm2,xmm2;
  vcvtdq2pd ymm2,xmm2;
  vdivpd  ymm0,ymm0,ymm2;    // average x
  vdivpd  ymm1,ymm1,ymm2;    // average y

  // calculate regresion
  mov    r11,32;             // start value on stack for ln(x) values
  vxorpd ymm2,ymm2,ymm2;     // for sum(x)
  vxorpd ymm3,ymm3,ymm3;     // for sum(x)**2
  vxorpd ymm4,ymm4,ymm4;     // for sum(xy)

align 16;
 @Loop1:
  vmovupd ymm6,ymmword ptr[rsp+r11]; // load ln(x) from stack
  vaddpd  ymm2,ymm2,ymm6;    // sum(x)
  vmovapd ymm5,ymm6;
  vmulpd  ymm6,ymm6,ymm6;    // (x)**2
  vaddpd  ymm3,ymm3,ymm6;
  add     r11,32;
  vmulpd  ymm6,ymm5,ymmword ptr[rsp+r11]; // load ln(y) from stack
  vaddpd  ymm4,ymm4,ymm6;    // sum(xy)
  add     r11,32;
  sub     rdx,1;
  jnz     @Loop1

  vhaddpd ymm2,ymm2,ymm2;    // sum over all fields
  vextractf128 xmm5,ymm2,1;
  vaddpd  xmm2,xmm2,xmm5;

  vhaddpd ymm3,ymm3,ymm3;
  vextractf128 xmm5,ymm3,1;
  vaddpd  xmm3,xmm3,xmm5;

  vhaddpd ymm4,ymm4,ymm4
  vextractf128 xmm5,ymm4,1;
  vaddpd  xmm4,xmm4,xmm5;

  vmovsd xmm5,xmm0,xmm0;
  vmovsd xmm6,xmm1,xmm1;
  vmulsd xmm1,xmm1,xmm2    // ln(ym)*sum(ln(x))
  vmulsd xmm0,xmm0,xmm2;   // ln(xm)*sum(ln(x))
  vsubsd xmm4,xmm4,xmm1;   // sum(ln(x)*ln(y)) - ln(ym)*sum(ln(x))
  vsubsd xmm3,xmm3,xmm0;   // sum(ln(x))**2 - ln(xm)*sum(ln(x))
  vdivsd xmm4,xmm4,xmm3;   // b
  vmulsd xmm5,xmm5,xmm4;   // ln(xm)*b
  vsubsd xmm6,xmm6,xmm5;   // ln(a) = ln(ym) -ln(xm)*b
  vmovsd qword ptr [rsp],xmm6;
  mov    r10d,1;
  call   FN_EXP_DOUBLE       // ln (a) -> a
  vmovsd xmm6,[rsp];
  mov  rsp,r15;            // stack correct
  pop  r14;                // load adress b

  vmovsd qword ptr [r13],xmm6;
  vmovsd qword ptr [r14],xmm4;

 @ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  add rsp,32;
 {$ENDIF}
  vzeroupper;
  pop r15;
  pop r14;
  pop r13;
  pop r12;
end;


{regresion y = ax^(b)
 calculate ln(y) = ln(a) + b*ln(x)
 Calculation for 2 array pairs in cols order. Use the convert function
 Array4ToT4Double for correct order.}
function BPotenzReg2VYDouble (const Feld :array of T4Double;
                              const count :T4Int32):T4Double;
                              assembler;nostackframe;
 asm
  push r14;
  push r15;
 {$IFNDEF WIN64}
  mov rcx,rdi;     //result
  mov rdx,rsi;     //Feld
  mov r8, rdx;     //length
  mov r9, rcx;     //count
 {$ENDIF}
 {$IFDEF WIN64}
  sub rsp,32;
  vmovdqu ymmword ptr [rsp],ymm6;
 {$ENDIF}
  vxorpd ymm0,ymm0,ymm0;     // for error
  test r8,r8;                // value < 0 not valid
  js   @ende;
  cmp  r8,1;                  // min 2 values
  jl   @ende;
  vmovdqu xmm1,xmmword ptr [r9];
  call CHECK_T4INT32;
  test eax,eax;
  jz   @ende;
  vcvtdq2pd xmm5,xmm1;     // only need the lower lane

  add  r8,1;
  mov  r9,r8;
  mov  r10,r8;
  imul r10,32;     // for 2* stack place
  add  r10,32;     // + byte for ln calculation in FN_LN_SINGLE
  mov  r15,rsp;    // save stack addres
  sub  rsp,r10;    // need for ln(y) values
  vxorpd ymm0,ymm0,ymm0;
  vxorpd ymm1,ymm1,ymm1;
  xor  r11,r11;
  mov  r14,16;     // for distance in stack for ly(y) result
align 16;
 @Loop:
  vmovupd ymm2,ymmword ptr [rdx+r11];  // Feld
  vextractf128 xmm3,ymm2,1;
  vshufpd xmm4,xmm2,xmm3,00000000b;    // x value
  vmovupd xmmword ptr [rsp],xmm4;
  mov    r10d,2;                    // calculate 2 ln(x) value
  call   FN_LN_DOUBLE;
  vmovupd xmm4,xmmword ptr [rsp];
  vaddpd  xmm0,xmm0,xmm4;
  vmovupd xmmword ptr [rsp+r14],xmm4;
  add r14,16;
  vshufpd xmm4,xmm2,xmm3,00000011b;    // y value
  vmovupd xmmword ptr [rsp],xmm4;
  mov    r10d,2;                    // calculate 2 ln(y) value
  call   FN_LN_DOUBLE;
  vmovupd xmm4,xmmword ptr [rsp];
  vaddpd  xmm1,xmm1,xmm4;
  vmovupd xmmword ptr [rsp+r14],xmm4;
  add    r11,32;
  add    r14,16;
  sub    r8,1;
  jnz    @Loop;

  vshufpd xmm4,xmm5,xmm5,00000000b;
  vdivpd  xmm0,xmm0,xmm4;    // average x
  vdivpd  xmm1,xmm1,xmm4;    // average y

  // calculate regresion
  mov  r11,16       ;        // start value on stack for ln(x) values
  vxorpd ymm2,ymm2,ymm2;     // for sum(x)
  vxorpd ymm3,ymm3,ymm3;     // for sum(x)**2
  vxorpd ymm4,ymm4,ymm4;     // for sum(xy)

align 16;
 @Loop1:
  vmovupd xmm6,xmmword ptr[rsp+r11]; // load ln(x) from stack
  vaddpd  xmm2,xmm2,xmm6;    // sum(x)
  vmovapd xmm5,xmm6;
  vmulpd  xmm6,xmm6,xmm6;    // (x)**2
  vaddpd  xmm3,xmm3,xmm6;
  add     r11,16;
  vmulpd  xmm6,xmm5,xmmword ptr[rsp+r11];
  vaddpd  xmm4,xmm4,xmm6;    // sum(xy)
  add     r11,16;
  sub     r9,1;
  jnz     @Loop1

  vmovapd xmm5,xmm0;
  vmovapd xmm6,xmm1;
  vmulpd  xmm5,xmm0,xmm2;   // ln(xm)*sum(ln(x))
  vmulpd  xmm2,xmm1,xmm2    // ln(ym)*sum(ln(x))
  vsubpd  xmm4,xmm4,xmm2;   // sum(ln(x)*ln(y)) - ln(ym)*sum(ln(x))
  vsubpd  xmm3,xmm3,xmm5;   // sum(ln(x))**2 - ln(xm)*sum(ln(x))
  vdivpd  xmm4,xmm4,xmm3;   // b
  vmulpd  xmm5,xmm0,xmm4;   // ln(xm)*b
  vsubpd  xmm6,xmm1,xmm5;   // ln(a) = ln(ym) -ln(xm)*b
  vmovupd xmmword ptr [rsp],xmm6;
  mov     r10d,2;
  call    FN_EXP_DOUBLE       // ln (a) -> a
  vmovupd xmm6,xmmword ptr [rsp];
  mov     rsp,r15;            // stack correct

  //correct
  // a = 1,3 b = 1,3
  vshufpd xmm1,xmm6,xmm4,00000000b;
  vshufpd xmm2,xmm6,xmm4,00000011b;
  vinsertf128 ymm0,ymm0,xmm1,0;
  vinsertf128 ymm0,ymm0,xmm2,1;

 @ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  add rsp,32;
 {$ENDIF}
  vmovupd ymmword ptr [rcx],ymm0;
  vzeroupper;
  pop r15;
  pop r14;
end;

{exponential regresion y = ae^(bx)
calculate ln(y) = ln(a0 + b*x }
function ExpRegYDouble (const x,y :array of T4Double;count :Longint;
                          out a,b :Double):Longbool;assembler;
 asm
  push r12;
  push r13;
  push r14;
  push r15;
 {$IFNDEF WIN64}
  mov r12d,r8d;    //count
  mov r13,r9;      //a
  mov rcx,rdi;     //x
  mov rdx,rsi;
  mov r8, rdx;     //y
  mov r9, rcx;
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12d,dword ptr [count];
  mov r13,qword ptr [a];
  sub rsp,32;
  vmovdqu ymmword ptr [rsp],ymm6;
 {$ENDIF}
  mov r14,qword ptr [b];
  xor  rax,rax;
  vxorpd ymm0,ymm0,ymm0;
  vmovsd qword ptr [r13],xmm0;
  vmovsd qword ptr [r14],xmm0;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  test r12d,r12d;
  jz   @ende;
  jns  @1;
  neg  r12d;
 @1:
  cmp  r12d,2;     // min 2 values
  jb   @ende;
  cmp  rdx,r9;     // cmp length x and y
  jne  @ende;
  mov  rax,1;
  push r14;        // save adress b
  add  rdx,1;      // length x
  mov  r9,rdx;     // for lather
  mov  r10,rdx;
  imul r10,32;
  add  r10,32;     // + 16 byte for ln calculation in FN_LN_SINGLE
  add  r10,32;     // for alignment;
  mov  r15,rsp;    // save stack addres
  sub  rsp,r10;    // need for ln(y) values
  vxorpd ymm0,ymm0,ymm0;
  vxorpd ymm1,ymm1,ymm1;
  mov  rdx,r9;
  xor  r11,r11;
  mov  r14,32;     // for distance in stack for ln(y) result
align 16;
 @Loop:
  vaddpd  ymm0,ymm0,ymmword ptr [rcx+r11];  // x
  vmovupd ymm2,ymmword ptr [r8+r11];  // y
  vmovupd ymmword ptr [rsp],ymm2;
  mov     r10d,4;                    // calculate 4 ln(y) value
  call    FN_LN_DOUBLE;
  vmovupd ymm2,ymmword ptr [rsp];
  vaddpd  ymm1,ymm1,ymm2;
  vmovupd ymmword ptr [rsp+r14],ymm2;  // save ln(ymm2) on stack for lather
  add     r11,32;
  add     r14,32;
  sub     rdx,1;
  jnz     @Loop;

  vhaddpd ymm0,ymm0,ymm0;    // sum over all fields
  vextractf128 xmm2,ymm0,1;
  vaddpd  xmm0,xmm0,xmm2;
  vinsertf128 ymm0,ymm0,xmm0,1;

  vhaddpd ymm1,ymm1,ymm1
  vextractf128 xmm2,ymm1,1;
  vaddpd  xmm1,xmm1,xmm2;
  vinsertf128 ymm1,ymm1,xmm1,1;

  vpinsrd  xmm2,xmm2,r12d,0;
  vmovddup xmm2,xmm2;
  vpabsd   xmm2,xmm2;
  vcvtdq2pd ymm2,xmm2;
  vdivpd  ymm0,ymm0,ymm2;    // average x
  vdivpd  ymm1,ymm1,ymm2;    // average y

  // calculate regresion
  xor    r11,r11;
  mov    r14,32;
  vxorpd ymm2,ymm2,ymm2;   // for sum(x)
  vxorpd ymm3,ymm3,ymm3;   // for sum(x)**2
  vxorpd ymm4,ymm4,ymm4;   // for sum(xy)

align 16;
 @Loop1:
  vmovupd ymm6,ymmword ptr[rcx+r11];
  vaddpd  ymm2,ymm2,ymm6;   // sum(x)
  vmovapd ymm5,ymm6;
  vmulpd  ymm6,ymm6,ymm6;   // (x)**2
  vaddpd  ymm3,ymm3,ymm6;
  vmulpd  ymm6,ymm5,ymmword ptr[rsp+r14]; // load ln(y) from stack
  vaddpd  ymm4,ymm4,ymm6;   // sum(xy)
  add     r11,32;
  add     r14,32;
  sub     r9,1;
  jnz     @Loop1

  vhaddpd ymm2,ymm2,ymm2;  // calculate the field sums
  vextractf128 xmm5,ymm2,1;
  vaddpd  xmm2,xmm2,xmm5;

  vhaddpd ymm3,ymm3,ymm3;
  vextractf128 xmm5,ymm3,1;
  vaddpd  xmm3,xmm3,xmm5;

  vhaddpd ymm4,ymm4,ymm4;
  vextractf128 xmm5,ymm4,1;
  vaddpd  xmm4,xmm4,xmm5;

  vmulsd  xmm5,xmm0,xmm2;   // xm*sum(x)
  vmulsd  xmm6,xmm1,xmm2    // ym*sum(x)
  vsubsd  xmm4,xmm4,xmm6;   // sum(x*ln(y)) - ym*sum(x)
  vsubsd  xmm3,xmm3,xmm5;   // sum(x)**2 - xm*sum(x)
  vdivsd  xmm4,xmm4,xmm3;   // b
  vmulsd  xmm5,xmm0,xmm4;   // xm*b
  vsubsd  xmm6,xmm1,xmm5;   // ln(a) = ym - xm*b
  vmovsd  qword ptr [rsp],xmm6;
  mov     r10d,1;
  call    FN_EXP_DOUBLE     // ln (a) -> a
  vmovsd  xmm0,[rsp];
  mov     rsp,r15;         // correct stack
  pop     r14;

  vmovsd  qword ptr [r13],xmm0;
  vmovsd  qword ptr [r14],xmm4;

@ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  add rsp,32;
 {$ENDIF}
  vzeroupper;
  pop r15;
  pop r14;
  pop r13;
  pop r12;
end;


{exponential regresion y = ae^(bx)
 calculate ln(y) = ln(a) + b*x
 Calculation for 2 array pairs in cols order. Use the convert function
 Array4ToT4Double for correct order.}
function ExpReg2VYDouble (const Feld :array of T4Double;
                          const count :T4Int32):T4Double;
                          assembler;nostackframe;
 asm
  push r14;
  push r15;
 {$IFNDEF WIN64}
  mov rcx,rdi;    //Result
  mov rdx,rsi;    //Feld
  mov r8, rdx;    //length
  mov r9, rcx;    //count
 {$ENDIF}
 {$IFDEF WIN64}
  sub rsp,32;
  vmovdqu ymmword ptr [rsp],ymm6;
 {$ENDIF}
  vxorpd  ymm0,ymm0,ymm0;      // for error;
  test r8,r8;                  // value < 0 not valid
  js   @ende;
  cmp  r8,1;                   // min 2 values
  jl   @ende;
  vmovdqu xmm1,xmmword ptr [r9];
  call CHECK_T4INT32;
  test eax,eax;
  jz   @ende;
  vcvtdq2pd ymm5,xmm1;

  add  r8,1;      // length x
  mov  r9,r8;     // for lather
  mov  r10,r8;
  imul r10,32;
  add  r10,32;     // + byte for ln calculation in FN_LN_SINGLE
  mov  r15,rsp;    // save stack addres
  sub  rsp,r10;    // need for ln(y) values
  vxorpd ymm0,ymm0,ymm0;
  vxorpd ymm1,ymm1,ymm1;
  xor  r11,r11;
  mov  r14,16;     // for distance in stack for ln(y) result
align 16;
 @Loop:
  vmovupd ymm2,ymmword ptr [rdx+r11];  // Feld
  vextractf128 xmm3,ymm2,1;
  vshufpd xmm4,xmm2,xmm3,00000000b;   // x values
  vaddpd  xmm0,xmm0,xmm4;
  vmovupd xmmword ptr [rsp+r14],xmm4;  // save x on stack
  add     r14,16;
  vshufpd xmm4,xmm2,xmm3,00000011b;   // y value
  vmovupd xmmword ptr [rsp],xmm4;
  mov     r10d,2;                     // calculate 2 ln(y) value
  call    FN_LN_DOUBLE;
  vmovupd xmm4,xmmword ptr [rsp];
  vaddpd  xmm1,xmm1,xmm4;
  vmovupd xmmword ptr [rsp+r14],xmm4;  // save ln(y) on stack
  add  r11,32;
  add  r14,16;
  sub  r8,1;
  jnz  @Loop;

  vextractf128 xmm3,ymm5,1;
  vshufpd xmm4,xmm5,xmm3,00000000b;
  vdivpd  xmm0,xmm0,xmm4;    // average x
  vdivpd  xmm1,xmm1,xmm4;    // average y

  // calculate regresion
  mov    r14,16;
  vxorpd xmm2,xmm2,xmm2;   // for sum(x)
  vxorpd xmm3,xmm3,xmm3;   // for sum(x)**2
  vxorpd xmm4,xmm4,xmm4;   // for sum(xy)

align 16;
 @Loop1:
  vmovupd xmm6,xmmword ptr[rsp+r14];
  vaddpd  xmm2,xmm2,xmm6;   // sum(x)
  vmovapd xmm5,xmm6;
  vmulpd  xmm6,xmm6,xmm6;   // (x)**2
  vaddpd  xmm3,xmm3,xmm6;
  add     r14,16;
  vmulpd  xmm6,xmm5,xmmword ptr[rsp+r14]; // load ln(y) from stack
  vaddpd  xmm4,xmm4,xmm6;   // sum(xy)
  add     r14,16;
  sub     r9,1;
  jnz     @Loop1

  vmulpd  xmm5,xmm0,xmm2;   // xm*sum(x)
  vmulpd  xmm6,xmm1,xmm2    // ym*sum(x)
  vsubpd  xmm4,xmm4,xmm6;   // sum(x*ln(y)) - ym*sum(x)
  vsubpd  xmm3,xmm3,xmm5;   // sum(x)**2 - xm*sum(x)
  vdivpd  xmm4,xmm4,xmm3;   // b
  vmulpd  xmm5,xmm0,xmm4;   // xm*b
  vsubpd  xmm6,xmm1,xmm5;   // ln(a) = ym - xm*b
  vmovupd xmmword ptr [rsp],xmm6;
  mov     r10d,2;
  call    FN_EXP_DOUBLE     // ln (a) -> a
  vmovupd xmm6,xmmword ptr [rsp];
  mov     rsp,r15;         // correct stack

  vshufpd xmm1,xmm6,xmm4,00000000b;
  vshufpd xmm2,xmm6,xmm4,00000011b;
  vinsertf128 ymm0,ymm0,xmm1,0;
  vinsertf128 ymm0,ymm0,xmm2,1;

@ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  add rsp,32;
 {$ENDIF}
  vmovupd ymmword ptr [rcx],ymm0;
  vzeroupper;
  pop r15;
  pop r14;
end;

{linear regresion y = a + bx}
function LinRegYSingle (const x,y :array of T8Single;count :Longint;
                          out a,b :Single):Longbool;assembler;
 asm
  push r12;
  push r13;
  push r14;
 {$IFNDEF WIN64}
  mov r12d,r8d;     //count
  mov r13,r9;       //a
  mov rcx,rdi;      //x
  mov rdx,rsi;
  mov r8, rdx;      //y
  mov r9, rcx;
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12d,dword ptr[count];
  mov r13,qword ptr [a];
  sub rsp,32;
  vmovdqu ymmword ptr [rsp],ymm6;
 {$ENDIF}
  mov r14,qword ptr [b];
  xor  rax,rax;
  vxorps ymm0,ymm0,ymm0;
  vmovss dword ptr [r13],xmm0;
  vmovss dword ptr [r14],xmm0;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  test r12d,r12d;
  jz   @ende;
  jns  @1;
  neg  r12d;
 @1:
  cmp  r12d,2;      // min 2 values
  jb   @ende;
  cmp  rdx,r9;     // cmp length x and y
  jne  @ende;
  mov  rax,1;
  add  rdx,1;      // length x
  mov  r10,rdx;    // for lather
  vxorps  ymm0,ymm0,ymm0;
  vxorps  ymm1,ymm1,ymm1;
  xor  r11,r11;
align 16;
 @Loop:
  vaddps ymm0,ymm0,ymmword ptr [rcx+r11];  // x
  vaddps ymm1,ymm1,ymmword ptr [r8+r11];  // y
  add    r11,32;
  sub    rdx,1;
  jnz    @Loop;

  vhaddps ymm0,ymm0,ymm0;
  vhaddps ymm0,ymm0,ymm0;
  vextractf128 xmm2,ymm0,1;
  vaddps  xmm0,xmm0,xmm2;
  vinsertf128 ymm0,ymm0,xmm0,1;

  vhaddps ymm1,ymm1,ymm1
  vhaddps ymm1,ymm1,ymm1;
  vextractf128 xmm2,ymm1,1;
  vaddps  xmm1,xmm1,xmm2;
  vinsertf128 ymm1,ymm1,xmm1,1;

  vpinsrd  xmm2,xmm2,r12d,0;
  vpshufd xmm2,xmm2,0;
  vpabsd  xmm2,xmm2;
  vcvtdq2ps xmm2,xmm2;
  vinsertf128 ymm2,ymm2,xmm2,1;
  vdivps  ymm0,ymm0,ymm2;    // average x
  vdivps  ymm1,ymm1,ymm2;    // average y

  // calculate regresion
  xor     r11,r11;
  vxorps ymm2,ymm2,ymm2;   // for sum(x)
  vxorps ymm3,ymm3,ymm3;   // for sum(x)**2
  vxorps ymm4,ymm4,ymm4;   // for sum(xy)

align 16;
 @Loop1:
  vmovups ymm6,ymmword ptr[rcx+r11];
  vaddps  ymm2,ymm2,ymm6;    // sum(x)
  vmovaps ymm5,ymm6;
  vmulps  ymm6,ymm6,ymm6;    // (x)**2
  vaddps  ymm3,ymm3,ymm6;
  vmulps  ymm6,ymm5,ymmword ptr[r8+r11];  //xy
  vaddps  ymm4,ymm4,ymm6;    // sum(xy)
  add  r11,32;
  sub  r10,1;
  jnz  @Loop1

  vhaddps ymm2,ymm2,ymm2;  // calculate the field sums
  vhaddps ymm2,ymm2,ymm2;
  vextractf128 xmm5,ymm2,1;
  vaddps  xmm2,xmm2,xmm5;

  vhaddps ymm3,ymm3,ymm3;
  vhaddps ymm3,ymm3,ymm3;
  vextractf128 xmm5,ymm3,1;
  vaddps  xmm3,xmm3,xmm5;

  vhaddps ymm4,ymm4,ymm4;
  vhaddps ymm4,ymm4,ymm4;
  vextractf128 xmm5,ymm4,1;
  vaddps  xmm4,xmm4,xmm5;

  vmulss  xmm5,xmm0,xmm2;   // xm*sum(x)
  vmulss  xmm6,xmm1,xmm2    // ym*sum(x)
  vsubss  xmm4,xmm4,xmm6;   // sum(xy) - ym*sum(x)
  vsubss  xmm3,xmm3,xmm5;   // sum(x)**2 - xm*sum(x)
  vdivss  xmm4,xmm4,xmm3;   // b
  vmulss  xmm5,xmm0,xmm4;   // b*xm
  vsubss  xmm6,xmm1,xmm5;   // a = ym - b*xm

  vmovss  dword ptr [r13],xmm6;
  vmovss  dword ptr [r14],xmm4;

@ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  add rsp,32;
 {$ENDIF}
  vzeroupper;
  pop r14;
  pop r13;
  pop r12;
end;

{linear regresion y = a + bx; x1,y1,x2,y2,x3,y3,x4,y4
 Calculate this for 3 or 4 array pairs in cols order. Use the convert routines
 for correct order. ArrayXToT8Single
                         ^ 4 or 8}
function LinReg4VYSingle (const Feld :array of T8Single;
                          const count :T8Int32):T8Single;assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;      //result
  mov rdx,rsi;      //Feld
  mov r8, rdx;      //length
  mov r9, rcx;      //count
 {$ENDIF}
 {$IFDEF WIN64}
  sub rsp,64;
  vmovdqu ymmword ptr [rsp],ymm6;
  vmovdqu ymmword ptr [rsp+32],ymm7;
 {$ENDIF}
  vxorps ymm0,ymm0,ymm0;          // for error
  test r8,r8;                     // value < 0 not valid
  js   @ende;
  cmp  r8,1;                       // min 2 value pairs needed
  jb   @ende;
  vmovdqu ymm1,ymmword ptr [r9];
  call CHECK_T8INT32;
  test eax,eax;
  jz   @ende;
  vcvtdq2ps ymm2,ymm1;   // integer in single
  vmovaps   ymm6,ymm2;

  add  r8,1;       // length x
  mov  r10,r8;     // for lather
  vxorps ymm0,ymm0,ymm0;
  xor  r11,r11;
align 16;
 @Loop:
  vaddps ymm0,ymm0,ymmword ptr [rdx+r11];
  add  r11,32;
  sub  r8,1;
  jnz  @Loop;

  vdivps ymm0,ymm0,ymm2;         // average

  // calculate regresion
  xor    r11,r11;
  vxorps ymm2,ymm2,ymm2;          // for sum(x)
  vxorps ymm3,ymm3,ymm3;          // for sum(x)**2
  vxorps ymm4,ymm4,ymm4;          // for sum(xy)

align 16;
 @Loop1:
  vmovups ymm1,ymmword ptr [rdx+r11];
  vaddps  ymm2,ymm2,ymm1;    // sum(x) pos 1,3,5,7
  vmovaps ymm5,ymm1;
  vshufps ymm5,ymm5,ymm5,10110001b;
  vmulps  ymm5,ymm5,ymm1;
  vaddps  ymm4,ymm4,ymm5;    // sum(xy)
  vmulps  ymm1,ymm1,ymm1;    // (x)**2    pos 1,3,5,7
  vaddps  ymm3,ymm3,ymm1;
  add     r11,32;
  sub     r10,1;
  jnz     @Loop1

  vmulps  ymm5,ymm0,ymm2;   // xm*sum(x)  pos 1,3,5,7
  vshufps ymm1,ymm0,ymm0,10110001b;  //ym     pos 1,3,5,7
  vmulps  ymm2,ymm1,ymm2    // ym*sum(x)
  vsubps  ymm4,ymm4,ymm2;   // sum(xy) - ym*sum(x)  pos 1,3,5,7
  vsubps  ymm3,ymm3,ymm5;   // sum(x)**2 - xm*sum(x) pos 1,3,5,7
  vpcmpeqw xmm6,xmm6,xmm6;
  vpslld  xmm6,xmm6,25;
  vpsrld  xmm6,xmm6,2;
  vinsertf128 ymm6,ymm6,xmm6,1;   // set 1
  vxorps  ymm7,ymm7,ymm7;
  vcmpps  ymm7,ymm3,ymm7,0; // = 0?
  vandps  ymm7,ymm7,ymm6;   // set 1.0
  vorps   ymm7,ymm7,ymm3    // set rest
  vdivps  ymm4,ymm4,ymm7;   // b          pos 1,3,5,7
  vmulps  ymm5,ymm0,ymm4;   // b*xm       pos 1,3,5,7
  vsubps  ymm1,ymm1,ymm5;   // a = ym - b*xm   pos 1,3,5,7

  vshufps  ymm4,ymm4,ymm4,10110001b;
  vblendps ymm0,ymm1,ymm4,10101010b;

 @ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  vmovdqu ymm7,ymmword ptr [rsp+32];
  add rsp,64;
 {$ENDIF}
  vmovups ymmword ptr [rcx],ymm0;
  vzeroupper;
end;


{log regresion y = a + b*ln(x)
calculate y = a + b*ln(x)}
function LogRegYSingle (const x,y :array of T8Single;count :Longint;
                          out a,b :Single):Longbool;assembler;
 asm
  push r12;
  push r13;
  push r14;
  push r15;
 {$IFNDEF WIN64}
  mov r12d,r8d;     // count
  mov r13,r9;       // adress a
  mov rcx,rdi;      // adress x
  mov rdx,rsi;      // length x
  mov r8, rdx;      // adress y
  mov r9, rcx;      // length y
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12d,dword ptr [count];
  mov r13,qword ptr [a];
  sub rsp,32;
  vmovdqu ymmword ptr [rsp],ymm6;
 {$ENDIF}
  mov r14,qword ptr [b];
  xor  rax,rax;
  vxorps ymm0,ymm0,ymm0;
  vmovss dword ptr [r13],xmm0;
  vmovss dword ptr [r14],xmm0;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  test r12d,r12d;
  jz   @ende;
  jns  @1;
  neg  r12d;
 @1:
  cmp  r12d,2;       // min 2 values
  jb   @ende;
  cmp  rdx,r9;       // cmp length x and y
  jne  @ende;
  mov  rax,1;
  push r14;
  add  rdx,1;        // length x
  mov  r10,rdx;
  imul r10,32;
  add  r10,32;
  add r10,32;
  mov  r15,rsp;
  sub  rsp,r10;       // for ln(x)
  vxorps ymm0,ymm0,ymm0;
  vxorps ymm1,ymm1,ymm1;
  xor  r11,r11;
  mov  r14,32;
  mov  r9,rdx;
align 16;
 @Loop:
  vmovups ymm2,ymmword ptr [rcx+r11];  // x
  vmovups ymmword ptr [rsp],ymm2;
  mov     r10d,8;
  call    FN_LN_SINGLE;                  // 8 lx(x) value
  vmovups ymm2,ymmword ptr [rsp];
  vaddps  ymm0,ymm0,ymm2;
  vmovups ymmword ptr [rsp+r14],ymm2;
  vaddps  ymm1,ymm1,ymmword ptr [r8+r11];  // y
  add  r11,32;
  add  r14,32;
  sub  r9,1;
  jnz  @Loop;

  vhaddps ymm0,ymm0,ymm0;       // sum over all fields
  vhaddps ymm0,ymm0,ymm0;
  vextractf128 xmm2,ymm0,1;
  vaddps  xmm0,xmm0,xmm2;
  vinsertf128 ymm0,ymm0,xmm0,1;

  vhaddps ymm1,ymm1,ymm1
  vhaddps ymm1,ymm1,ymm1
  vextractf128 xmm2,ymm1,1;
  vaddps  xmm1,xmm1,xmm2;
  vinsertf128 ymm1,ymm1,xmm1,1;

  vpinsrd xmm2,xmm2,r12d,0;
  vpshufd xmm2,xmm2,0;
  vcvtdq2ps xmm2,xmm2;
  vinsertf128 ymm2,ymm2,xmm2,1;
  vdivps  ymm0,ymm0,ymm2;    // average x
  vdivps  ymm1,ymm1,ymm2;    // average y

  // calculate regresion
  xor  r11,r11;
  mov  r14,32;
  vxorps ymm2,ymm2,ymm2;   // for sum(x)
  vxorps ymm3,ymm3,ymm3;   // for sum(x)**2
  vxorps ymm4,ymm4,ymm4;   // for sum(xy)

align 16;
 @Loop1:
  vmovups ymm6,ymmword ptr [rsp+r14];
  vaddps  ymm2,ymm2,ymm6;    // sum(x)
  vmovaps ymm5,ymm6;
  vmulps  ymm6,ymm6,ymm6;    // (x)**2
  vaddps  ymm3,ymm3,ymm6;
  vmulps  ymm6,ymm5,ymmword ptr [r8+r11];
  vaddps  ymm4,ymm4,ymm6;    // sum(xy)
  add     r11,32;
  add     r14,32;
  sub     rdx,1;
  jnz     @Loop1

  vhaddps ymm2,ymm2,ymm2;  // calculate the field sums
  vhaddps ymm2,ymm2,ymm2;
  vextractf128 xmm5,ymm2,1;
  vaddps  xmm2,xmm2,xmm5;

  vhaddps ymm3,ymm3,ymm3;
  vhaddps ymm3,ymm3,ymm3;
  vextractf128 xmm5,ymm3,1;
  vaddps  xmm3,xmm3,xmm5;

  vhaddps ymm4,ymm4,ymm4;
  vhaddps ymm4,ymm4,ymm4;
  vextractf128 xmm5,ymm4,1;
  vaddps  xmm4,xmm4,xmm5;

  vmovss  xmm5,xmm0,xmm0;   // xm
  vmovss  xmm6,xmm1,xmm1;   // ym
  vmulss  xmm6,xmm6,xmm2    // ym*sum(x)
  vmulss  xmm5,xmm5,xmm2;   // xm*sum(x)
  vsubss  xmm4,xmm4,xmm6;   // sum(xy) - ym*sum(x)
  vsubss  xmm3,xmm3,xmm5;   // sum(x)**2 - xm*sum(x)
  vdivss  xmm4,xmm4,xmm3;   // b
  vmulss  xmm0,xmm0,xmm4;   // b*xm
  vsubss  xmm1,xmm1,xmm0;   // a = ym - b*xm
  mov     rsp,r15;     // correct stack
  pop     r14;         // adress b
  vmovss  dword ptr [r13],xmm1;
  vmovss  dword ptr [r14],xmm4;

 @ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  add rsp,32;
 {$ENDIF}
  vzeroupper;
  pop r15;
  pop r14;
  pop r13;
  pop r12;
end;


{log regresion y = a + b*ln(x)
 calculate y = a + b*ln(x) x1,y1,x2,y2,x3,y3,x4,y4
 Calculation for 3 or 4 array pairs in cols order. Use the convert function
 ArrayXToT8Single for corrext order. For < 3 pairs use xmm unit.
      ^ 6 or 8}
function LogReg4VYSingle (const Feld :array of T8Single;
                          const Count :T8Int32):T8Single;assembler;
 asm
  push r14;
  push r15;
 {$IFNDEF WIN64}
  mov rcx,rdi;      // Result
  mov rdx,rsi;      // Feld
  mov r8, rdx;      // length Feld
  mov r9, rcx;      // count
 {$ENDIF}
 {$IFDEF WIN64}
  sub rsp,64;
  vmovdqu ymmword ptr [rsp],ymm6;
  vmovdqu ymmword ptr [rsp+32],ymm7;
 {$ENDIF}
  vxorps ymm0,ymm0,ymm0;          // for error
  test r8,r8;                     // value < 0 not valid
  js   @ende;
  cmp  r8,1;                      // min 2 value pairs needed
  jb   @ende;
  vmovdqu ymm1,ymmword ptr [r9];  // count of the Fields
  call CHECK_T8INT32;
  test eax,eax;
  jz   @ende;
  vcvtdq2ps ymm5,ymm1;   // integer in single
  add  r8,1;
  mov  r10,r8;
  imul r10,32;
  add  r10,32;
  mov  r15,rsp;
  sub  rsp,r10;       // for ln(x)
  vxorps ymm0,ymm0,ymm0;
  vxorps ymm1,ymm1,ymm1;
  xor  r11,r11;
  mov  r14,16;
  mov  r9,r8;
align 16;
 @Loop:
  vmovups  ymm2,ymmword ptr [rdx+r11];  // Feld
  vextractf128 xmm3,ymm2,1;
  vshufps  xmm4,xmm2,xmm3,10001000b;   // all the x in lower lane
  vmovups  xmmword ptr [rsp],xmm4;
  mov      r10,4;
  call     FN_LN_SINGLE;                  // 4 lx(x) value
  vmovups  xmm4,xmmword ptr [rsp];
  vaddps   xmm0,xmm0,xmm4;
  vmovups  xmmword ptr [rsp+r14],xmm4; // save x value on stack
  add      r14,16;
  vshufps  xmm4,xmm2,xmm3,11011101b;    // all the y in lower lane
  vaddps   xmm1,xmm1,xmm4;
  vmovups  xmmword ptr [rsp+r14],xmm4;  // save the y value on stack
  add  r11,32;
  add  r14,16;
  sub  r8,1;
  jnz  @Loop;


  vextractf128 xmm3,ymm5,1;         // the upper pair values
  vshufps xmm4,xmm5,xmm3,10001000b; // all pairs
  vmovaps xmm7,xmm4;
  vdivps  xmm0,xmm0,xmm4;    // average x
  vdivps  xmm1,xmm1,xmm4;    // average y

  // calculate regresion
  xor  r11,r11;
  mov  r14,16;
  vxorps ymm2,ymm2,ymm2;   // for sum(x)
  vxorps ymm3,ymm3,ymm3;   // for sum(x)**2
  vxorps ymm4,ymm4,ymm4;   // for sum(xy)

align 16;
 @Loop1:
  vmovups xmm6,xmmword ptr[rsp+r14];
  vaddps  xmm2,xmm2,xmm6;    // sum(x)
  vmovaps xmm5,xmm6;
  vmulps  xmm6,xmm6,xmm6;    // (x)**2
  vaddps  xmm3,xmm3,xmm6;
  add     r14,16;
  vmulps  xmm6,xmm5,xmmword ptr[rsp+r14];
  vaddps  xmm4,xmm4,xmm6;    // sum(xy)
  add     r14,16;
  sub     r9,1;
  jnz     @Loop1

  vmulps  xmm6,xmm1,xmm2    // ym*sum(x)
  vmulps  xmm2,xmm0,xmm2;   // xm*sum(x)
  vsubps  xmm4,xmm4,xmm6;   // sum(xy) - ym*sum(x)
  vsubps  xmm3,xmm3,xmm2;   // sum(x)**2 - xm*sum(x)
  vpcmpeqw xmm6,xmm6,xmm6;
  vpslld  xmm6,xmm6,25;
  vpsrld  xmm6,xmm6,2;      // set 1
  vcmpps  xmm7,xmm7,xmm6,0; // pairs = 1? d.h. unused
  vandps  xmm7,xmm7,xmm6;   // set 1 where all bits = 1
  vmovaps xmm5,xmm7;
  vxorps  xmm5,xmm5,xmm6;   // set 0 where 1 = 1
  vmulps  xmm1,xmm1,xmm5;   // clear the false sum, where array not used!
  vorps   xmm7,xmm7,xmm3;   // set the rest
  vdivps  xmm4,xmm4,xmm7;   // b
  vmulps  xmm0,xmm0,xmm4;   // b*xm
  vsubps  xmm1,xmm1,xmm0;   // a = ym - b*xm

  mov     rsp,r15;     // correct stack

  // need rigth order   a value pos 1,3,5,7
  //                    b value pos 2,4,6,8

  vshufps xmm0,xmm1,xmm4,01000100b;    //1,3,2,4,
  vshufps xmm2,xmm4,xmm1,10111011b;    //8,6,7,5
  vshufps xmm0,xmm0,xmm0,11011000b;    //1,2,3,4
  vshufps xmm2,xmm2,xmm2,00100111b;    //5,6,7,8
  vinsertf128 ymm1,ymm1,xmm2,1;
  vinsertf128 ymm1,ymm1,xmm0,0;
  vmovaps ymm0,ymm1;
 @ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  vmovdqu ymm7,ymmword ptr [rsp+32];
  add rsp,64;
 {$ENDIF}
  vmovups ymmword ptr [rcx],ymm0;
  vzeroupper;
  pop r15;
  pop r14;
end;


{linear regresion y = a + bx}
function LinRegYDouble (const x,y :array of T4Double;count :Longint;
                          out a,b :Double):Longbool;assembler;
 asm
  push r12;
  push r13;
  push r14;
 {$IFNDEF WIN64}
  mov r12d,r8d;      //count
  mov r13, r9;
  mov rcx,rdi;       //x
  mov rdx,rsi;
  mov r8, rdx;       //y
  mov r9, rcx;
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12d,dword ptr[count];
  mov r13,qword ptr [a];
  sub rsp,32;
  vmovdqu ymmword ptr [rsp],ymm6;
 {$ENDIF}
  mov r14,qword ptr [b];
  xor  rax,rax;
  vxorpd ymm0,ymm0,ymm0;
  vmovsd qword ptr [r13],xmm0;
  vmovsd qword ptr [r14],xmm0;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  test r12d,r12d;
  jz   @ende;
  jns  @1;
  neg  r12d;
 @1:
  cmp  r12d,2;     // min 2 values
  jb   @ende;
  cmp  rdx,r9;     // cmp length x and y
  jne  @ende;
  mov  rax,1;
  add  rdx,1;      // length x
  mov  r10,rdx;    // for lather
  vxorpd ymm0,ymm0,ymm0;
  vxorpd ymm1,ymm1,ymm1;
  xor    r11,r11;
align 16;
 @Loop:
  vaddpd ymm0,ymm0,ymmword ptr [rcx+r11];  // x
  vaddpd ymm1,ymm1,ymmword ptr [r8+r11];  // y
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;

  vhaddpd ymm0,ymm0,ymm0;
  vextractf128 xmm2,ymm0,1;
  vaddpd  xmm0,xmm0,xmm2;
  vinsertf128 ymm0,ymm0,xmm0,1;

  vhaddpd ymm1,ymm1,ymm1
  vextractf128 xmm2,ymm1,1;
  vaddpd  xmm1,xmm1,xmm2;
  vinsertf128 ymm1,ymm1,xmm1,1;

  vpinsrd xmm2,xmm2,r12d,0;
  vmovddup xmm2,xmm2;
  vcvtdq2pd ymm2,xmm2;
  vdivpd  ymm0,ymm0,ymm2;    // average x
  vdivpd  ymm1,ymm1,ymm2;    // average y

  // calculate regresion
  xor    r11,r11;
  vxorpd ymm2,ymm2,ymm2;     // for sum(x)
  vxorpd ymm3,ymm3,ymm3;     // for sum(x)**2
  vxorpd ymm4,ymm4,ymm4;     // for sum(xy)

align 16;
 @Loop1:
  vmovupd ymm6,ymmword ptr [rcx+r11];
  vaddpd  ymm2,ymm2,ymm6;    // sum(x)
  vmovapd ymm5,ymm6;
  vmulpd  ymm6,ymm6,ymm6;    // (x)**2
  vaddpd  ymm3,ymm3,ymm6;
  vmulpd  ymm6,ymm5,ymmword ptr [r8+r11];
  vaddpd  ymm4,ymm4,ymm6;    // sum(xy)
  add     r11,32;
  sub     r10,1;
  jnz     @Loop1

  vhaddpd ymm2,ymm2,ymm2;  // calculate the field sums
  vextractf128 xmm5,ymm2,1;
  vaddpd  xmm2,xmm2,xmm5;

  vhaddpd ymm3,ymm3,ymm3;
  vextractf128 xmm5,ymm3,1;
  vaddpd  xmm3,xmm3,xmm5;

  vhaddpd ymm4,ymm4,ymm4;
  vextractf128 xmm5,ymm4,1;
  vaddpd  xmm4,xmm4,xmm5;

  vmulsd  xmm5,xmm0,xmm2;   // xm*sum(x)
  vmulsd  xmm6,xmm1,xmm2    // ym*sum(x)
  vsubsd  xmm4,xmm4,xmm6;   // sum(xy) - ym*sum(x)
  vsubsd  xmm3,xmm3,xmm5;   // sum(x)**2 - xm*sum(x)
  vdivsd  xmm4,xmm4,xmm3;   // b
  vmulsd  xmm5,xmm0,xmm4;   // b*xm
  vsubsd  xmm6,xmm1,xmm5;   // a = ym - b*xm

  vmovsd  qword ptr [r13],xmm6;
  vmovsd  qword ptr [r14],xmm4;

@ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  add rsp,32;
 {$ENDIF}
  vzeroupper;
  pop r14;
  pop r13;
  pop r12;
end;

{linear regresion y = a + bx
 Calculation for 2 array pairs in cols order. Use the convert function
 Array4ToT4Double for correct order.}
function LinReg2VYDouble (const Feld :array of T4Double;
                          const count :T4Int32):T4Double;
                          assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;   //Result
  mov rdx,rsi;   //Feld
  mov r8, rdx;   //length
  mov r9, rcx;   //count
 {$ENDIF}
  vxorpd ymm0,ymm0,ymm0;          // for error
  test r8,r8;                     // value < 0 not valid
  js   @ende;
  cmp  r8,1;                       // min 2 value pairs needed
  jb   @ende;
  vmovdqu xmm1,xmmword ptr [r9];  // count of the Fields
  call CHECK_T4INT32;
  test eax,eax;
  jz   @ende;
  vcvtdq2pd ymm2,xmm1;   // integer in double
  add  r8,1;
  mov  r10,r8;    // for lather
  vxorpd ymm0,ymm0,ymm0;
  xor    r11,r11;
align 16;
 @Loop:
  vaddpd ymm0,ymm0,ymmword ptr [rdx+r11];  // Feld
  add  r11,32;
  sub  r8,1;
  jnz  @Loop;

  vdivpd ymm0,ymm0,ymm2;    // average
  // calculate regresion
  xor     r11,r11;
  vxorpd ymm2,ymm2,ymm2;   // for sum(x)
  vxorpd ymm3,ymm3,ymm3;   // for sum(x)**2
  vxorpd ymm4,ymm4,ymm4;   // for sum(xy)

align 16;
 @Loop1:
  vmovupd ymm1,ymmword ptr [rdx+r11];
  vaddpd  ymm2,ymm2,ymm1;    // sum(x)
  vmovapd ymm5,ymm1;
  vshufpd ymm5,ymm5,ymm5,00000101b;
  vmulpd  ymm5,ymm5,ymm1;    // xy
  vaddpd  ymm4,ymm4,ymm5;    // sum(xy)
  vmulpd  ymm1,ymm1,ymm1;    // (x)**2
  vaddpd  ymm3,ymm3,ymm1;
  add     r11,32;
  sub     r10,1;
  jnz     @Loop1

  vmulpd  ymm5,ymm0,ymm2;   // xm*sum(x)
  vshufpd ymm1,ymm0,ymm0,00000101b;
  vmulpd  ymm2,ymm1,ymm2    // ym*sum(x)
  vsubpd  ymm4,ymm4,ymm2;   // sum(xy) - ym*sum(x)
  vsubpd  ymm3,ymm3,ymm5;   // sum(x)**2 - xm*sum(x)
  vdivpd  ymm4,ymm4,ymm3;   // b              pos 1,3
  vmulpd  ymm5,ymm0,ymm4;   // b*xm
  vsubpd  ymm0,ymm1,ymm5;   // a = ym - b*xm  pos 1,3

  // correct a = 1,3; b = 1,3
  vextractf128 xmm1,ymm0,1;
  vextractf128 xmm2,ymm4,1;
  vshufpd xmm3,xmm0,xmm4,00000000b;  //a1,b1
  vshufpd xmm5,xmm1,xmm2,00000000b;  //a2,b2
  vinsertf128 ymm0,ymm0,xmm3,0;
  vinsertf128 ymm0,ymm0,xmm5,1;

 @ende:
  vmovupd ymmword ptr [rcx],ymm0;
  vzeroupper;
end;


{log regresion y = a + b*ln(x) ;x > 0}
function LogRegYDouble (const x,y :array of T4Double;count :Longint;
                          out a,b :Double):Longbool;assembler;
 asm
  push r12;
  push r13;
  push r14;
  push r15;
 {$IFNDEF WIN64}
  mov r12d,r8d;     //count
  mov r13,r9;       //a
  mov rcx,rdi;      //x
  mov rdx,rsi;
  mov r8, rdx;      //y
  mov r9, rcx;
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12d,dword ptr [count];
  mov r13,qword ptr [a];
  sub rsp,32;
  vmovdqu ymmword ptr [rsp],ymm6;
 {$ENDIF}
  mov r14,qword ptr [b];
  xor  rax,rax;
  vxorpd ymm0,ymm0,ymm0;
  vmovsd qword ptr [r13],xmm0;
  vmovsd qword ptr [r14],xmm0;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  test r12d,r12d;
  jz   @ende;
  jns  @1;
  neg  r12d;
 @1:
  cmp  r12d,2;     // min 2 values
  jb   @ende;
  cmp  rdx,r9;     // cmp length x and y
  jne  @ende;
  mov  rax,1;
  push r14;
  add  rdx,1;      // length x
  mov  r10,rdx;
  imul r10,32;
  add  r10,64;     // for alignment
  mov  r15,rsp;
  sub  rsp,r10;
  vxorpd ymm0,ymm0,ymm0;
  vxorpd ymm1,ymm1,ymm1;
  xor  r11,r11;
  mov  r14,32;
  mov  r9,rdx;
align 16;
 @Loop:                // calculation for average
  vmovupd ymm2,ymmword ptr [rcx+r11];  // x
  vmovupd ymmword ptr [rsp],ymm2;
  mov     r10d,4;                      // calculate 4 ln(y) value
  call    FN_LN_DOUBLE;
  vmovupd ymm2,ymmword ptr [rsp];
  vaddpd  ymm0,ymm0,ymm2;
  vmovupd ymmword ptr [rsp+r14],ymm2; // save ln(xmm2) on stack for lather
  vaddpd  ymm1,ymm1,ymmword ptr [r8+r11];   // y
  add  r11,32;
  add  r14,32;
  sub  r9,1;
  jnz  @Loop;

  vhaddpd ymm0,ymm0,ymm0;
  vextractf128 xmm2,ymm0,1;
  vaddpd  xmm0,xmm0,xmm2;
  vinsertf128 ymm0,ymm0,xmm0,1;

  vhaddpd ymm1,ymm1,ymm1;
  vextractf128 xmm2,ymm1,1;
  vaddpd  xmm1,xmm1,xmm2;
  vinsertf128 ymm1,ymm1,xmm1,1;

  vpinsrd xmm2,xmm2,r12d,0;
  vmovddup xmm2,xmm2;
  vcvtdq2pd ymm2,xmm2;
  vdivpd  ymm0,ymm0,ymm2;    // average x
  vdivpd  ymm1,ymm1,ymm2;    // average y

  // calculate regresion
  xor  r11,r11;
  mov  r14,32;
  vxorpd ymm2,ymm2,ymm2;   // for sum(x)
  vxorpd ymm3,ymm3,ymm3;   // for sum(x)**2
  vxorpd ymm4,ymm4,ymm4;   // for sum(xy)

align 16;
 @Loop1:
  vmovupd ymm6,ymmword ptr[rsp+r14];
  vaddpd  ymm2,ymm2,ymm6;    // sum(x)
  vmovapd ymm5,ymm6;
  vmulpd  ymm6,ymm6,ymm6;    // (x)**2
  vaddpd  ymm3,ymm3,ymm6;
  vmulpd  ymm6,ymm5,ymmword ptr[r8+r11];
  vaddpd  ymm4,ymm4,ymm6;    // sum(xy)
  add    r11,32;
  add    r14,32;
  sub    rdx,1;
  jnz    @Loop1

  vhaddpd ymm2,ymm2,ymm2;
  vextractf128 xmm5,ymm2,1;
  vaddpd  xmm2,xmm2,xmm5;

  vhaddpd ymm3,ymm3,ymm3;
  vextractf128 xmm5,ymm3,1;
  vaddpd  xmm3,xmm3,xmm5;

  vhaddpd ymm4,ymm4,ymm4;
  vextractf128 xmm5,ymm4,1;
  vaddpd  xmm4,xmm4,xmm5;

  vmovsd xmm5,xmm0,xmm0;   // xm
  vmovsd xmm6,xmm1,xmm1;   // ym
  vmulsd xmm1,xmm1,xmm2    // ym*sum(x)
  vmulsd xmm0,xmm0,xmm2;   // xm*sum(x)
  vsubsd xmm4,xmm4,xmm1;   // sum(xy) - ym*sum(x)
  vsubsd xmm3,xmm3,xmm0;   // sum(x)**2 - xm*sum(x)
  vdivsd xmm4,xmm4,xmm3;   // b
  vmulsd xmm5,xmm5,xmm4;   // b*xm
  vsubsd xmm6,xmm6,xmm5;   // a = ym - b*xm

  mov  rsp,r15;            // correct stack
  pop  r14;                // adress b
  vmovsd qword ptr [r13],xmm6;
  vmovsd qword ptr [r14],xmm4;

 @ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  add rsp,32;
 {$ENDIF}
  vzeroupper;
  pop r15;
  pop r14;
  pop r13;
  pop r12;
end;


{log regresion y = a + b*ln(x) ;x > 0 Feld = x1,y1,x2,y2
Result a1,b1,a2,b2
 Calculation for 2 array pairs in cols order. Use the convert routine
 Array4ToT4Double for correct order.}
function LogReg2VYDouble (const Feld :array of T4Double;
                          const count :T4Int32):T4Double;
                          assembler;nostackframe;
 asm
  push r14;
  push r15;
 {$IFNDEF WIN64}
  mov rcx,rdi;        //Result
  mov rdx,rsi;        //Feld
  mov r8, rdx;        //length
  mov r9, rcx;        //count
 {$ENDIF}
 {$IFDEF WIN64}
  sub rsp,32;
  vmovdqu ymmword ptr [rsp],ymm6;
 {$ENDIF}
  vxorpd  ymm0,ymm0,ymm0;     //for error;
  test r8,r8;                     // value < 0 not valid
  js   @ende;
  cmp  r8,1;                  // min 2 value pairs needed
  jb   @ende;
  vmovdqu ymm1,ymmword ptr [r9];
  call CHECK_T4INT32;
  test eax,eax;
  jz   @ende;
  vcvtdq2pd ymm5,xmm1;

  add  r8,1;
  mov  r10,r8;
  imul r10,32;
  add  r10,32;
  mov  r15,rsp;
  sub  rsp,r10;
  vxorpd ymm0,ymm0,ymm0;
  vxorpd ymm1,ymm1,ymm1;
  xor  r11,r11;
  mov  r14,16;
  mov  r9,r8;
align 16;
 @Loop:                // calculation for average
  vmovupd ymm2,ymmword ptr [rdx+r11];  // Feld
  vextractf128 xmm3,ymm2,1;
  vshufpd xmm4,xmm2,xmm3,00000000b;    // 1,3   x value
  vmovupd xmmword ptr [rsp],xmm4;
  mov     r10d,2;                      // calculate 2 ln(x) value
  call    FN_LN_DOUBLE;
  vmovupd xmm4,xmmword ptr [rsp];
  vaddpd  xmm0,xmm0,xmm4;
  vmovupd xmmword ptr [rsp+r14],xmm4;
  add     r14,16;
  vshufpd xmm4,xmm2,xmm3,00000011b;    // 2,4   y value
  vmovupd xmmword ptr [rsp+r14],xmm4; // save y value on stack for lather
  vaddpd  xmm1,xmm1,xmm4;
  add  r11,32;
  add  r14,16;
  sub  r8,1;
  jnz  @Loop;

  vextractf128 xmm2,ymm5,1;
  vshufpd xmm4,xmm5,xmm2,00000000b;
  vdivpd  xmm0,xmm0,xmm4;    // average x
  vdivpd  xmm1,xmm1,xmm4;    // average y   we have pairs d.h. x count = ycount

  // calculate regresion
  mov  r14,16;
  vxorpd ymm2,ymm2,ymm2;   // for sum(x)
  vxorpd ymm3,ymm3,ymm3;   // for sum(x)**2
  vxorpd ymm4,ymm4,ymm4;   // for sum(xy)

align 16;
 @Loop1:
  vmovupd xmm6,xmmword ptr [rsp+r14];
  vaddpd  xmm2,xmm2,xmm6;    // sum(x)
  vmovapd xmm5,xmm6;
  vmulpd  xmm6,xmm6,xmm6;    // (x)**2
  vaddpd  xmm3,xmm3,xmm6;
  add r14,16;
  vmulpd  xmm6,xmm5,xmmword ptr [rsp+r14];
  vaddpd  xmm4,xmm4,xmm6;    // sum(xy)
  add     r14,16;
  sub     r9,1;
  jnz     @Loop1

  vmovapd ymm6,ymm0;       // xm
  vmovapd xmm5,xmm1;       // ym
  vmulpd xmm5,xmm1,xmm2    // ym*sum(x)
  vmulpd xmm2,xmm0,xmm2;   // xm*sum(x)
  vsubpd xmm4,xmm4,xmm5;   // sum(xy) - ym*sum(x)
  vsubpd xmm3,xmm3,xmm2;   // sum(x)**2 - xm*sum(x)
  vdivpd xmm4,xmm4,xmm3;   // b
  vmulpd xmm5,xmm0,xmm4;   // b*xm
  vsubpd xmm6,xmm1,xmm5;   // a = ym - b*xm
  mov  rsp,r15;            // correct stack

  // correct result order
  vshufpd xmm1,xmm6,xmm4,00000000b;
  vshufpd xmm2,xmm6,xmm4,00000011b;
  vinsertf128 ymm0,ymm0,xmm1,0;
  vinsertf128 ymm0,ymm0,xmm2,1;

 @ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  add rsp,32;
 {$ENDIF}
  vmovupd ymmword ptr [rcx],ymm0;
  vzeroupper;
  pop r15;
  pop r14;
end;


{Korrelationskoeffizient -1<= r <= +1, bei error r = 2 }
function KorrAnalyseYDouble (const x,y :array of T4Double;count :Longint):Double;
                              assembler;
 asm
  push r12;
 {$IFNDEF WIN64}
  mov r12d,r8d;        //count
  mov rcx,rdi;         //x
  mov rdx,rsi;
  mov r8, rdx;         //y
  mov r9, rcx;
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12d,dword ptr [count];
  sub rsp,96;
  vmovdqu ymmword ptr [rsp],ymm6;
  vmovdqu ymmword ptr [rsp+32],ymm7;
  vmovdqu ymmword ptr [rsp+64],ymm8;
 {$ENDIF}
  mov r10,2          // for error
  vcvtsi2sd xmm0,xmm0,r10;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  test r12d,r12d;
  jz   @ende;
  jns  @1;
  neg  r12d;
 @1:
  cmp  r12d,4;     // min 4 values
  jb   @ende;
  cmp  rdx,r9;     // cmp length x and y
  jne  @ende;
  add  rdx,1;      // length x
  mov  r10,rdx;    // for lather
  vxorpd xmm0,xmm0,xmm0;
  vxorpd xmm1,xmm1,xmm1;
  xor  r11,r11;
align 16;
 @Loop:
  vaddpd ymm0,ymm0,ymmword ptr [rcx+r11];  // x
  vaddpd ymm1,ymm1,ymmword ptr [r8+r11];  // y
  add  r11,32;
  sub  rdx,1;
  jnz  @Loop;

  vhaddpd ymm0,ymm0,ymm0;
  vextractf128 xmm2,ymm0,1;
  vaddpd  xmm0,xmm0,xmm2;
  vinsertf128 ymm0,ymm0,xmm0,1;

  vhaddpd ymm1,ymm1,ymm1
  vextractf128 xmm2,ymm1,1;
  vaddpd  xmm1,xmm1,xmm2;
  vinsertf128 ymm1,ymm1,xmm1,1;

  vpinsrd xmm2,xmm2,r12d,0;
  vpshufd xmm2,xmm2,0;
  vpabsd  xmm2,xmm2;
  vcvtdq2pd ymm2,xmm2;
  vinsertf128 ymm2,ymm2,xmm2,1;
  vdivpd  ymm0,ymm0,ymm2;    // average x
  vdivpd  ymm1,ymm1,ymm2;    // average y

  // calculate korrelation
  xor    r11,r11;
  vxorpd ymm2,ymm2,ymm2;   // for sum((x-xm)*(y-ym))
  vxorpd ymm3,ymm3,ymm3;   // for sum(x-xm)**2
  vxorpd ymm4,ymm4,ymm4;   // for sum(y-ym)**2

  {The fill values with zero must are cleared or
   the calculation is incorrect. We calculate only the real values from
   count.}
  vpcmpeqw xmm7,xmm7,xmm7;
  vpsllq   xmm7,xmm7,63;
  vxorpd   xmm7,xmm0,xmm7;  // set -xm
  vinsertf128 ymm7,ymm7,xmm7,1;
  vpcmpeqw xmm8,xmm8,xmm8;
  vpsllq   xmm8,xmm8,63;
  vxorpd   xmm8,xmm1,xmm8;  // set -ym
  vinsertf128 ymm8,ymm8,xmm8,1;

align 16;
 @Loop1:
  vmovupd ymm6,ymmword ptr[x+r11];
  vsubpd  ymm6,ymm6,ymm0;    // (x-xm)
  vmovapd ymm5,ymm6;
  vmulpd  ymm6,ymm6,ymm6;    // (x-xm)**2
  vaddpd  ymm3,ymm3,ymm6;
  vmovupd ymm6,ymmword ptr[y+r11];
  vsubpd  ymm6,ymm6,ymm1;    // (y-ym)
  vmulpd  ymm5,ymm5,ymm6;
  vaddpd  ymm2,ymm2,ymm5;    // (x-xm)(y-ym)
  vmulpd  ymm6,ymm6,ymm6;
  vaddpd  ymm4,ymm4,ymm6;    // (y-ym)**2
  add  r11,32;
  sub  r10,1;
  cmp  r10,1;
  jne  @Loop1;

 {Only zeros on the last round are fill values.}
  vmovupd ymm6,ymmword ptr[rcx+r11];
  vsubpd  ymm6,ymm6,ymm0;    // (x-xm)
  vcmppd  ymm5,ymm6,ymm7,0;  // search of -xm  (0-xm) = -xm
  vandnpd ymm6,ymm5,ymm6;    // set value (0-xm) = -xm to 0!
  vmovapd ymm5,ymm6;
  vmulpd  ymm6,ymm6,ymm6;    // (x-xm)**2
  vaddpd  ymm3,ymm3,ymm6;
  vmovupd ymm6,ymmword ptr[r8+r11];
  vsubpd  ymm6,ymm6,ymm1;    // (y-ym)
  vcmppd  ymm7,ymm6,ymm8,0;  // search of -ym  (0-ym) = -ym
  vandnpd ymm6,ymm7,ymm6;    // set value (0-ym) = -ym to 0!
  vmulpd  ymm5,ymm5,ymm6;
  vaddpd  ymm2,ymm2,ymm5;    // (x-xm)(y-ym)
  vmulpd  ymm6,ymm6,ymm6;
  vaddpd  ymm4,ymm4,ymm6;    // (y-ym)**2

  vhaddpd ymm2,ymm2,ymm2;   // calculate the field sums
  vextractf128 xmm5,ymm2,1;
  vaddpd  xmm2,xmm2,xmm5;

  vhaddpd ymm3,ymm3,ymm3;
  vextractf128 xmm5,ymm3,1;
  vaddpd  xmm3,xmm3,xmm5;

  vhaddpd ymm4,ymm4,ymm4;
  vextractf128 xmm5,ymm4,1;
  vaddpd  xmm4,xmm4,xmm5;

  vmulsd  xmm3,xmm3,xmm4;
  vsqrtsd xmm0,xmm3,xmm3;
  vdivsd  xmm0,xmm2,xmm0;   // r koeffizient

@ende:
 {$IFDEF WIN64}
 vmovdqu ymm6,ymmword ptr [rsp];
 vmovdqu ymm7,ymmword ptr [rsp+32];
 vmovdqu ymm8,ymmword ptr [rsp+64];
 add rsp,96;
 {$ENDIF}
 vzeroupper;
 pop r12;
end;

{Korrelationskoeffizient -1<= r <= +1, bei error r = 2
 Calculation for 2 array pairs in cols order. Use the convert function
 Array4ToT4Double for correct order.}
function KorrAnalyse2VYDouble (const Feld :array of T4Double;
                               const count :T4Int32):T2Double;
                              assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;        //result
  mov rdx,rsi;        //Feld
  mov r8, rdx;        //length
  mov r9, rcx;        //count
 {$ENDIF}
 {$IFDEF WIN64}
  sub rsp,160;
  vmovdqu ymmword ptr [rsp],ymm6;
  vmovdqu ymmword ptr [rsp+32],ymm7;
  vmovdqu ymmword ptr [rsp+64],ymm8;
  vmovdqu ymmword ptr [rsp+96],ymm9;
  vmovdqu ymmword ptr [rsp+128],ymm10;
 {$ENDIF}
  mov r10d,2;
  vcvtsi2sd xmm0,xmm0,r10d;
  vmovddup xmm0,xmm0;          //for error
  test r8,r8;                     // value < 0 not valid
  js   @ende;
  cmp  r8,1;           // we need min 2 value pairs
  jb   @ende;
  vmovdqu  xmm1,xmmword ptr [r9];
  call CHECK_T4INT32;
  test eax,eax;
  jz   @ende;
  vcvtdq2pd  ymm7,xmm1;
  add r8,1;
  mov r10,r8;
  vxorps xmm0,xmm0,xmm0;
  xor r11,r11;
align 16;
 @Loop:
  vaddpd ymm0,ymm0,ymmword ptr [rdx+r11];  // Feld
  add r11,32;
  sub r8,1;
  jnz @Loop;

  vdivpd  ymm0,ymm0,ymm7;    // average
  // calculate korrelation
  xor    r11,r11;
  vxorps ymm2,ymm2,ymm2;   // for sum((x-xm)*(y-ym))
  vxorps ymm3,ymm2,ymm3;   // for sum(x-xm)**2 and (y-ym)**2

  {The fill values with zero must are cleared or
   the calculation is incorrect. We calculate only the real values from
   count.}
  vpcmpeqw xmm6,xmm6,xmm6;
  vpsllq   xmm6,xmm6,63;
  vxorpd   xmm6,xmm6,xmm0;   // set xm to -xm for compare
  vinsertf128 ymm6,ymm6,xmm6,1;
  vpcmpeqw xmm8,xmm8,xmm8;
  vpsllq   xmm8,xmm8,54;
  vpsrlq   xmm8,xmm8,2;     // for count - 1.0
  vinsertf128 ymm8,ymm8,xmm8,1;
  vxorpd   ymm9,ymm9,ymm9;

align 16;
 @Loop1:
  vmovupd ymm1,ymmword ptr[rdx+r11];
  vsubpd  ymm7,ymm7,ymm8;     //sub count
  vcmppd  ymm10,ymm7,ymm9,1;  // when < 0 det all bits = 1
  vsubpd  ymm1,ymm1,ymm0;     // (x-xm) and (y-ym)
  vcmppd  ymm5,ymm1,ymm6,0;   // search for -xm, -ym values
  vandpd  ymm5,ymm5,ymm10;    // clear only fill values
  vandnpd ymm1,ymm5,ymm1;     // set the correct values
  vmovapd ymm5,ymm1;
  vshufpd ymm4,ymm1,ymm1,00000101b;
  vmulpd  ymm4,ymm4,ymm1;
  vaddpd  ymm2,ymm2,ymm4;
  vmulpd  ymm1,ymm1,ymm1;    // (x-xm)**2 and (y-ym)**2
  vaddpd  ymm3,ymm3,ymm1;
  add  r11,32;
  sub  r10,1;
  jnz  @Loop1

  vmovapd ymm1,ymm3;
  vshufpd ymm4,ymm3,ymm3,00000101b;
  vmulpd  ymm0,ymm1,ymm4;   // valid in pos 1 and 3
  vsqrtpd ymm0,ymm0;
  vdivpd  ymm0,ymm2,ymm0;   // r koeffizient in pos 1 and 3
  vextractf128 xmm1,ymm0,1;
  vshufpd xmm0,xmm0,xmm1,00000000b;

 @ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  vmovdqu ymm7,ymmword ptr [rsp+32];
  vmovdqu ymm8,ymmword ptr [rsp+64];
  vmovdqu ymm9,ymmword ptr [rsp+96];
  vmovdqu ymm10,ymmword ptr [rsp+128];
  add rsp,160;
 {$ENDIF}
  vmovupd xmmword ptr [rcx],xmm0; // result for return
  vzeroupper;
end;

{$ENDIF}

{$UNDEF SIMD256}


end.


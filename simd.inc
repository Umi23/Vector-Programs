{include simd.inc}
{ This include is part of the units xmmfloat,xmmint and ymmfloat.

  Copyright (C) 2020 Klaus Stöhr mail: k.stoehr@gmx.de

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Lesser General Public License as published by
  the Free Software Foundation; either version 3 of the License, or (at your
  option) any later version with the following modification:

  As a special exception, the copyright holder of this library give you
  permission to link this library with independent modules to produce an
  executable, regardless of the license terms of these independent modules,and
  to copy and distribute the resulting executable under terms of your choice,
  provided that you also meet, for each linked independent module, the terms
  and conditions of the license of that module. An independent module is a
  module which is not derived from or based on this library.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser Public License
  for more details.

  You should have received a copy of the GNU Lesser General Public License
  along with this program. If not, see <http://www.gnu.org/licenses/>.
}

 type
  {new definition use only arrays.}
  p128Rec  = ^T128Rec;
  T128Rec = packed record
    case Integer of
    0: (QWords :array[0..1]  of QWord);
    1: (DWords :array[0..3]  of DWord);
    2: (Words  :array[0..7]  of Word);
    3: (Bytes  :array[0..15] of Byte);
  end;

  p256Rec  = ^T256Rec;
  T256Rec = packed record
    case Integer of
    0: (QWords :array[0..3]  of QWord);
    1: (DWords :array[0..7]  of DWord);
    2: (Words  :array[0..15] of Word);
    3: (Bytes  :array[0..31] of Byte);
  end;

  // for the endianess in ByteXSwap
  // LE - little endian, BE - big endian
  TEndian   = (LE,BE);

  // structur for the compare result
  T32Bool   = packed array[0..31] of ByteBool;
  T16YBool  = packed array[0..15] of WordBool;
  T16Bool   = packed array[0..15] of ByteBool;
  T8YBool   = packed array[0..7]  of LongBool;
  T8Bool    = packed array[0..7]  of WordBool;
  T4YBool   = packed array[0..3]  of QWordBool;
  T4Bool    = packed array[0..3]  of LongBool;
  T2Bool    = packed array[0..1]  of QWordBool;

  // structur for 128-bit (XMM)
  T16Byte   = packed array[0..15] of Byte;
  T16Short  = packed array[0..15] of Shortint;
  T8Word    = packed array[0..7]  of Word;
  T8Small   = packed array[0..7]  of Smallint;
  T4Int32   = packed array[0..3]  of Longint;
  T4DWord   = packed array[0..3]  of Longword;
  T2Int64   = packed array[0..1]  of Int64;
  T2Qword   = packed array[0..1]  of QWord;
  T4Single  = packed array[0..3]  of Single;
  T2Single  = packed array[0..1]  of Single;
  T2Double  = packed array[0..1]  of Double;

  // structur for 256-bit (YMM)
  T32Byte   = packed array[0..31] of Byte;
  T32Short  = packed array[0..31] of Shortint;
  T16Word   = packed array[0..15] of Word;
  T16Small  = packed array[0..15] of Smallint;
  T8DWord   = packed array[0..7]  of Longword;
  T8Int32   = packed array[0..7]  of Longint;
  T4Qword   = packed array[0..3]  of QWord;
  T4Int64   = packed array[0..3]  of Int64;
  T8Single  = packed array[0..7]  of Single;
  T4Double  = packed array[0..3]  of Double;

  // for conversion routines and results
  T2Int32   = packed array[0..1]  of Longint;


 const
   AlignMask16   = $FFFFFFFFFFFFFFF0;
   AlignMask32   = $FFFFFFFFFFFFFF20;

   // MXCSR Bit mask              Bit
   MDAZ   :Longword = $00000040;  //6      denormal as zero
   MINV   :Longword = $00000080;  //7      invalid
   MDEN   :Longword = $00000100;  //8      denormal
   MDIVZ  :Longword = $00000200;  //9      div by zero
   MOVER  :Longword = $00000400;  //10     overflow
   MUnder :Longword = $00000800;  //11     underflow
   MPREZ  :Longword = $00001000;  //12     precision
   MROUND :Longword = $00006000;  //13,14  rounding standard is 00 64 bit
   MFLZ   :Longword = $00008000;  //15     flush denormals to zero

   {Potenz 10 for Double }
   Potenz10_D :array[1..16] of QWord =
     ($4024000000000000,   //1E+1
      $4059000000000000,   //1E+2
      $408f400000000000,   //1E+3
      $40c3880000000000,   //1e+4
      $40f86a0000000000,   //1e+5
      $412e848000000000,   //1e+6
      $416312d000000000,   //1e+7
      $4197d78400000000,   //1e+8
      $41cdcd6500000000,   //1e+9
      $4202a05f20000000,   //1e+10
      $42374876e8000000,   //1e+11
      $426d1a94a2000000,   //1e+12
      $42a2309ce5400000,   //1e+13
      $42d6bcc41e900000,   //1e+14
      $430c6bf526340000,   //1e+15
      $4341c37937e08000);  //1e+16

   {Potenz 10 for Single}
   Potenz10_S :array[1..8] of Longword =
     ($41200000,   // 10
      $42c80000,   // 100
      $447a0000,   // 1000
      $461c4000,   // 10000
      $47c35000,   // 100000
      $49742400,   // 1000000
      $4b189680,   // 10000000
      $4cbebc20);  // 100000000

   Potenz10 :array[1..14] of Int64  =  (10,
                                        100,
                                        1000,
                                        10000,
                                        100000,
                                        1000000,
                                        10000000,
                                        100000000,
                                        1000000000,
                                        10000000000,
                                        100000000000,
                                        1000000000000,
                                        10000000000000,
                                        100000000000000);
   {Here we must correct(round) value to p.e 0.001 -> we use Hexvalue}
   SPotenz10 :array[1..10] of Longword = ($3DCCCCCD,   //0.1
                                         $3C23D70B,    //0.01;
                                         $3A83126F,    //0.001
                                         $38D1B718,    //0.0001
                                         $3727C5AD,    //0.00001
                                         $358637BE,    //0.000001
                                         $33D6BF95,    //0.0000001
                                         $322BCC78,    //0.00000001
                                         $30897061,    //0.000000001
                                         $2EDBE6FF);   //0.0000000001
   DPotenz10 :array[1..16] of QWord =  ($3FB999999999999A,     //1E-1
                                        $3F847AE147AE147B,     //1E-2
                                        $3F50624DD2F1A9FC,     //1E-3
                                        $3F1A36E2EB1C432D,     //1e-4
                                        $3ee4f8b588e368f1,     //1e-5
                                        $3eb0c6f7a0b5ed8E,     //1e-6
                                        $3e7ad7f29abcaf49,     //1e-7
                                        $3e45798ee2308c3a,     //1e-8
                                        $3e112e0be826d695,     //1e-9
                                        $3ddb7cdfd9d7bdbb,     //1e-10
                                        $3da5fd7fe1796496,     //1e-11
                                        $3d719799812dea12,     //1e-12
                                        $3d3c25c268497682,     //1e-13
                                        $3d06849b86a12b9b,     //1e-14
                                        $3cd203af9ee75616,     //1e-15
                                        $3c9cd2b297d889bD);    //1e-16

{$CODEALIGN CONSTMIN=32} // need for ymm

   QNANS16 :T16Byte =  ($00,$00,$80,$7F,$00,$00,$80,$7F,
                        $00,$00,$80,$7F,$00,$00,$80,$7F); // +oo
   QNAND16 :T16Byte =  ($00,$00,$00,$00,$00,$00,$F0,$7F,
                        $00,$00,$00,$00,$00,$00,$F0,$7F); // +oo
   _QNANS16 :T16Byte = ($00,$00,$80,$FF,$00,$00,$80,$FF,
                        $00,$00,$80,$FF,$00,$00,$80,$FF); // -oo
   _QNAND16 :T16Byte = ($00,$00,$00,$00,$00,$00,$F0,$FF,
                        $00,$00,$00,$00,$00,$00,$F0,$FF); // -oo


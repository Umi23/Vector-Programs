{include simdconv.inc}

{ This unit is part of the xmmfloat and ymmfloat unit.
  The unit has the convert routines for the rigth order for the arrays
  used in the procedures in the xmmfloat or ymmfloat unit.
  Only single and double floating point convert routines are implemented.

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
{Remark: when you have a ymm unit please use the converts structure with the
         lower count of unused arrays p.e. xmm unit and not the ymm unit.}

unit simdconv;

{$mode objfpc}{$H+}
{$CODEPAGE UTF8}
{$ASMMODE INTEL}
{$GOTO ON}
{$OPTIMIZATION OFF}  // assembler is optimized!

interface

{$include simd.inc}

// when you NOT HAVE a YMM unit in processor
// please deaktivate the define SIMD256
{$DEFINE SIMD256}

{$IFDEF CPUX86_64}


{------------set the arrays from row in col direction (transpose)-----------}

function Array4ToT4Single   (const Feld1,Feld2,Feld3,Feld4 :array of Single;
                             out   Res :array of T4Single):Longbool;
{set 3 arrays from row in col position Flag = true set unused cols to 1.0
 in other case to 0.0}
function Array3ToT4Single   (const Feld1,Feld2,Feld3 :array of Single;
                             out   Res :array of T4Single;Flag :Boolean):Longbool;
function Array2ToT4Single   (const Feld1,Feld2 :array of Single;
                             out   Res :array of T4Single;Flag :Boolean):Longbool;
function ArrayToT4Single    (const Feld :array of Single;
                             out   Res :array of T4Single; Flag :Boolean):Longbool;

function Array2ToT2Double   (const Feld1,Feld2 :array of Double;
                             out   Res :array of T2Double):Longbool;
function ArrayToT2Double    (const Feld :array of Double;
                             out Res :array of T2Double; Flag :Boolean):Longbool;

{---------give from T4Single or T2Double the separate arrays----------------}

function T4SingleTo4Single  (const Feld :array of T4Single;
                             out   Res1,Res2,Res3,Res4 :array of Single):Longbool;
function T4SingleTo3Single  (const Feld :array of T4Single;
                             out   Res1,Res2,Res3 :array of Single):Longbool;
function T4SingleTo2Single  (const Feld :array of T4Single;
                             out   Res1,Res2 :array of Single):Longbool;
function T4SingleToSingle   (const Feld :array of T4Single;
                             out   Res :array of Single):Longbool;
function T2DoubleTo2Double  (const Feld :array of T2Double;
                             out   Res1,Res2 :array of Double):Longbool;
function T2DoubleToDouble   (const Feld :array of T2Double;
                             out   Res :array of Double):Longbool;

{$IFDEF SIMD256}

{----set the arrays from row in cols direction-------------------------------}

function Array8ToT8Single   (const Feld1,Feld2,Feld3,Feld4,
                                   Feld5,Feld6,Feld7,Feld8 :array of Single;
                             out Res :array of T8Single):Longbool;
 {set 7 arrays from row in col position Flag = true set unused cols to 1.0
  in other case to 0.0}
function Array7ToT8Single   (const Feld1,Feld2,Feld3,Feld4,
                                   Feld5,Feld6,Feld7 :array of Single;
                             out Res :array of T8Single; Flag:Boolean):Longbool;
function Array6ToT8Single   (const Feld1,Feld2,Feld3,Feld4,
                                   Feld5,Feld6 :array of Single;
                             out   Res :array of T8Single;Flag :Boolean):Longbool;
function Array5ToT8Single   (const Feld1,Feld2,Feld3,Feld4,
                                   Feld5 :array of Single;
                             out   Res :array of T8Single;Flag :Boolean):Longbool;
function ArrayToT8Single    (const Feld :array of Single;
                             out   Res :array of T8Single; Flag :Boolean):Longbool;
function Array4ToT4Double   (const Feld1,Feld2,Feld3,Feld4 :array of Double;
                             out   Res :array of T4Double):Longbool;
function Array3ToT4Double   (const Feld1,Feld2,Feld3 :array of Double;
                             out   Res :array of T4Double; Flag :Boolean):Longbool;
function ArrayToT4Double    (const Feld :array of Double;
                             out   Res :array of T4Double; Flag :Boolean):Longbool;

{------convert from T8Single or T4Double to simple arrays---------------------}

function T8SingleYTo8Single (const Feld :array of T8Single;
                             out   Res1,Res2,Res3,Res4,Res5,
                                      Res6,Res7,Res8 :array of Single):Longbool;
function T8SingleYTo7Single (const Feld :array of T8Single;
                             out   Res1,Res2,Res3,Res4,Res5,
                                      Res6,Res7 :array of Single):Longbool;
function T8SingleYTo6Single (const Feld :array of T8Single;
                             out   Res1,Res2,Res3,Res4,Res5,
                                      Res6 :array of Single):Longbool;
function T8SingleYTo5Single (const Feld :array of T8Single;
                             out   Res1,Res2,Res3,
                                      Res4,Res5 :array of Single):Longbool;
function T8SingleYToSingle  (const Feld :array of T8Single;
                             out   Res :array of Single):Longbool;
function T4DoubleTo4Double  (const Feld :array of T4Double;
                             out   Res1,Res2,Res3,Res4 :array of Double):Longbool;
function T4DoubleTo3Double  (const Feld :array of T4Double;
                             out   Res1,Res2,Res3 :array of Double):Longbool;
function T4DoubleToDouble   (const Feld :array of T4Double;
                             out   Res  :array of Double):Longbool;
{$ENDIF SIMD256}
{$ENDIF CPUX86_64}

implementation

{$IFDEF CPUX86_64}
{$FPUTYPE SSE64}

{--------------------------convert for xmm arrays-----------------------------}

{-----------------------convert arrays in cols direction---------------------}

function Array4ToT4Single (const Feld1,Feld2,Feld3,Feld4 :array of Single;
                                out Res :array of T4Single):Longbool;assembler;
 asm
  push r12;
  push r13;
  {$IFNDEF WIN64}
  mov r12,r8;             // adress Feld3
  mov r13,r9;             // lenght Feld3
  mov rcx,rdi;            // adress Feld1
  mov rdx,rsi;            // length Feld1
  mov r8, rdx;            // adress Feld2
  mov r9, rcx;            // lenght Feld2
  {$ENDIF}
  {$IFDEF WIN64}
  mov r12,qword ptr [Feld3];
  mov r13,qword ptr [Feld3+8];
  {$ENDIF}
  xor rax,rax;            // set result = false
  test rdx,rdx;
  js  @ende;
  cmp rdx,r9;             // length Feld1 = Length Feld2;
  jne @ende;
  cmp rdx,r13;            // lenght Feld1 =  lenght Feld3
  jne @ende;
  mov r10,qword ptr [Feld4+8]; // lenght Feld1 = lenght Feld4
  cmp rdx,r10;
  jne @ende;
  mov r10,qword ptr [Res+8];
  cmp rdx,r10             // lenght Feld1  = lenght Res
  jne @ende;
  mov rax,1;
  add rdx,1;
  mov r11,qword ptr [Feld4];
  mov r13,qword ptr [Res];
  xor r10,r10;
  cmp rdx,4;              // when < 4 work with movss
  jb  @rest;
align 16;
 @Loop:
  movups xmm0,xmmword ptr [rcx+r10];  //Feld1
  movups xmm1,xmmword ptr [r8+r10];   //Feld2
  movups xmm2,xmmword ptr [r12+r10];  //Feld3
  movups xmm3,xmmword ptr [r11+r10];  //Feld4

  insertps xmm4,xmm0,00001110b;
  insertps xmm4,xmm1,00010000b;
  insertps xmm4,xmm2,00100000b;
  insertps xmm4,xmm3,00110000b;
  movaps xmmword ptr [r13],xmm4;  // first col of T4single
  add r13,16;
  insertps xmm4,xmm0,01000000b;
  insertps xmm4,xmm1,01010000b;
  insertps xmm4,xmm2,01100000b;
  insertps xmm4,xmm3,01110000b;
  movaps   xmmword ptr [r13],xmm4; // two col of T4Single
  add r13,16;
  insertps xmm4,xmm0,10000000b;
  insertps xmm4,xmm1,10010000b;
  insertps xmm4,xmm2,10100000b;
  insertps xmm4,xmm3,10110000b;
  movaps   xmmword ptr [r13],xmm4;  //tree col of T4Single
  add r13,16;
  insertps xmm4,xmm0,11000000b;
  insertps xmm4,xmm1,11010000b;
  insertps xmm4,xmm2,11100000b;
  insertps xmm4,xmm3,11110000b;
  movaps   xmmword ptr [r13],xmm4;  // four col of T4Single
  add r13,16;
  add r10,16;
  sub rdx,4;
  jz  @ende;
  cmp rdx,4;
  jae @Loop;

align 16;
 @rest:
  movss xmm0,dword ptr [rcx+r10];
  movss xmm1,dword ptr [r8+r10];
  movss xmm2,dword ptr [r12+r10];
  movss xmm3,dword ptr [r11+r10];
  insertps xmm4,xmm0,00001110b;
  insertps xmm4,xmm1,00010000b;
  insertps xmm4,xmm2,00100000b;
  insertps xmm4,xmm3,00110000b;
  movaps xmmword ptr [r13],xmm4;  // first col of T4single
  add r13,16;
  add r10,4;
  sub rdx,1;
  jnz @rest;

 @ende:
  pop r13;
  pop r12;
end;

{Set 3 pos vertical and pos 4 when Flag true = 1.0; Flag = false = 0.0 }
function Array3ToT4Single (const Feld1,Feld2,Feld3 :array of Single;
                  out Res :array of T4Single;Flag :Boolean):Longbool;assembler;
 asm
  push r12;
  push r13;
  push r14;
  {$IFNDEF WIN64}
  mov r12,r8;             // adress Feld3
  mov r13,r9;             // lenght Feld3
  mov rcx,rdi;            // adress Feld1
  mov rdx,rsi;            // length Feld1
  mov r8, rdx;            // adress Feld2
  mov r9, rcx;            // lenght Feld2
  {$ENDIF}
  {$IFDEF WIN64}
  mov r12,qword ptr [Feld3];
  mov r13,qword ptr [Feld3+8];
  {$ENDIF}
  xor  rax,rax;            // set result = false
  test rdx,rdx;
  js   @ende;
  cmp  rdx,r9;             // length Feld1 = Length Feld2;
  jne  @ende;
  cmp  rdx,r13;            // lenght Feld1 = Lenght Feld3
  jne  @ende;
  mov  r10,qword ptr [Res+8];
  cmp  rdx,r10;            // length Feld1 = length Res
  jne  @ende;
  mov  rax,1;           // true
  add  rdx,1;
  mov  r11,qword ptr [Res];
  xor  r10,r10;
  xorps xmm3,xmm3;
  movsx r14d,byte ptr [Flag];
  cmp  r14d,1;
  jne  @1;
  pcmpeqw xmm3,xmm3;
  pslld   xmm3,25;
  psrld   xmm3,2;     // set 1.0 in place 3 see remark
 @1:
  cmp  rdx,4;
  jb   @rest;
align 16;
 @Loop:
  movups xmm0,xmmword ptr [rcx+r10];  //Feld1
  movups xmm1,xmmword ptr [r8+r10];   //Feld2
  movups xmm2,xmmword ptr [r12+r10];  //Feld4

  insertps xmm4,xmm0,00000000b;
  insertps xmm4,xmm1,00010000b;
  insertps xmm4,xmm2,00100000b;
  insertps xmm4,xmm3,00110000b;
  movaps   xmmword ptr [r11],xmm4;  // first col of T4single
  add r11,16;
  insertps xmm4,xmm0,01000000b;
  insertps xmm4,xmm1,01010000b;
  insertps xmm4,xmm2,01100000b;
  insertps xmm4,xmm3,01110000b;
  movaps   xmmword ptr [r11],xmm4; // two col of T4Single
  add r11,16;
  insertps xmm4,xmm0,10000000b;
  insertps xmm4,xmm1,10010000b;
  insertps xmm4,xmm2,10100000b;
  insertps xmm4,xmm3,10110000b;
  movaps   xmmword ptr [r11],xmm4;  //tree col of T4Single
  add r11,16;
  insertps xmm4,xmm0,11000000b;
  insertps xmm4,xmm1,11010000b;
  insertps xmm4,xmm2,11100000b;
  insertps xmm4,xmm3,11110000b;
  movaps   xmmword ptr [r11],xmm4;  // four col of T4Single
  add r11,16;
  add r10,16;
  sub rdx,4;
  jz  @ende;
  cmp rdx,4;
  jae @Loop;

align 16;
 @rest:
  movss xmm0,dword ptr [rcx+r10];
  movss xmm1,dword ptr [r8+r10];
  movss xmm2,dword ptr [r12+r10];
  insertps xmm4,xmm0,00001110b;
  insertps xmm4,xmm1,00010000b;
  insertps xmm4,xmm2,00100000b;
  insertps xmm4,xmm3,00110000b;
  movaps   xmmword ptr [r11],xmm4;  // first col of T4single
  add r11,16;
  add r10,4;
  sub rdx,1;
  jnz @rest;

 @ende:
  pop r14;
  pop r13;
  pop r12;
end;


{Set 2 pos vertical and pos 3,4 when Flag true = 1.0; Flag = false = 0.0 }
{Remark: the pos 2 and 3 in T4Single set to 1.0 when not addition or
         subtrac. This is important, when you use the exponential or
         ln functions. zero -> exception!}
function Array2ToT4Single (const Feld1,Feld2 :array of Single;
                   out Res :array of T4Single;Flag :Boolean):Longbool;assembler;
 asm
  push r12;
  push r13;
  push r14;
  {$IFNDEF WIN64}
  mov r12,r8;             // adress Res
  mov r13,r9;             // lenght Res
  mov rcx,rdi;            // adress Feld1
  mov rdx,rsi;            // length Feld1
  mov r8, rdx;            // adress Feld2
  mov r9, rcx;            // lenght Feld2
  {$ENDIF}
  {$IFDEF WIN64}
  mov r12,qword ptr [Res];
  mov r13,qword ptr [Res+8];
  {$ENDIF}
  xor rax,rax;            // set result = false
  test rdx,rdx;
  js  @ende;
  cmp rdx,r9;             // length Feld1 = Length Feld2;
  jne @ende;
  cmp rdx,r13;
  jne @ende;
  mov r10,qword ptr [res+8];
  cmp rdx,r10;
  jne @ende;
  add rdx,1;
  mov rax,1;             //true
  xor  r10,r10;
  xorps xmm2,xmm2;
  movsx r14,byte ptr [Flag];
  cmp  r14,1;
  jne  @1;
  pcmpeqw xmm2,xmm2;
  pslld   xmm2,25;
  psrld   xmm2,2;      // set 1.0 on all places
 @1:
  cmp  rdx,4;
  jb   @rest;
align 16;
 @Loop:
  movups   xmm0,xmmword ptr [rcx+r10];  //Feld1
  movups   xmm1,xmmword ptr [r8+r10];   //feld2

  insertps xmm4,xmm0,00000000b;
  insertps xmm4,xmm1,00010000b;
  insertps xmm4,xmm2,00100000b;
  insertps xmm4,xmm2,00110000b;
  movaps   xmmword ptr [r12],xmm4;  // first col of T4single
  add r12,16;
  insertps xmm4,xmm0,01000000b;
  insertps xmm4,xmm1,01010000b;
  insertps xmm4,xmm2,01100000b;
  insertps xmm4,xmm2,01110000b;
  movaps   xmmword ptr [r12],xmm4; // two col of T4Single
  add r12,16;
  insertps xmm4,xmm0,10000000b;
  insertps xmm4,xmm1,10010000b;
  insertps xmm4,xmm2,10100000b;
  insertps xmm4,xmm2,10110000b;
  movaps   xmmword ptr [r12],xmm4;  //tree col of T4Single
  add r12,16;
  insertps xmm4,xmm0,11000000b;
  insertps xmm4,xmm1,11010000b;
  insertps xmm4,xmm2,11100000b;
  insertps xmm4,xmm2,11110000b;
  movaps   xmmword ptr [r12],xmm4;  // four col of T4Single
  add r12,16;
  add r10,16;
  sub rdx,4;
  jz  @ende;
  cmp rdx,4;
  jae @Loop;

align 16;
 @rest:
  movss xmm0,dword ptr [rcx+r10];
  movss xmm1,dword ptr [r8+r10];
  insertps xmm4,xmm0,00001110b;
  insertps xmm4,xmm1,00010000b;
  insertps xmm4,xmm2,00100000b;
  insertps xmm4,xmm2,00110000b;
  movaps xmmword ptr [r12],xmm4;  // first col of T4single
  add r12,16;
  add r10,4;
  sub rdx,1;
  jnz @rest;

 @ende:
  pop r14;
  pop r13;
  pop r12;
end;

function ArrayToT4Single (const Feld :array of Single;
                            out Res  :array of T4Single;
                                Flag :Boolean):Longbool;assembler;
 asm
  push r12;
  {$IFNDEF WIN64}
  movsx r12d,r8b;         // Flag
  mov rcx,rdi;            // adress Feld
  mov rdx,rsi;            // length Feld
  mov r8, rdx;            // adress res
  mov r9, rcx;            // length Res
  {$ENDIF}
  {$IFDEF WIN64}
  movsx r12d,byte ptr [Flag];
  {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;
  js   @ende;
  test r9,r9;
  js   @ende;
  add  rdx,1;
  add  r9,1;
  shl  r9,2;              // * 4
  cmp  rdx,r9;            // length Feld = Length Res;
  je   @ok;
  jg   @ende;             // Feld > res
  mov  r10,r9;
  sub  r10,rdx;
  cmp  r10,4;             // when diff >= error res is to long
  jge  @ende;
 @ok:
  mov  rax,1;
  xor  r11,r11;
  pxor xmm1,xmm1;       // set 0
  cmp  r12d,1;
  jne  @1;
  pcmpeqw xmm1,xmm1;
  pslld   xmm1,25;
  psrld   xmm1,2;       // set 1.0 on all places
 @1:
  cmp rdx,4;
  jl  @rest;
align 16;
 @Loop:
  movups xmm0,xmmword ptr [rcx+r11];
  movaps xmmword ptr [r8+r11],xmm0;
  add  r11,16;
  sub  rdx,4;
  jz   @ende;
  cmp  rdx,4;
  jae  @Loop;

align 16;
 @rest:
  movaps xmmword ptr [r8+r11],xmm1; // set all 0 or 1
align 16;
 @rest0:
  movss xmm0,dword ptr [rcx+r11];  // load and fill the rest
  movss dword ptr [r8+r11],xmm0;
  add   r11,4;
  sub   rdx,1;
  jnz   @rest0;

 @ende:
  pop r12;
end;

{-----------------------convert arrays in rows direction---------------------}

function T4SingleTo4Single (const Feld :array of T4Single;
                   out Res1,Res2,Res3,Res4 :array of Single):Longbool;assembler;
 asm
  push r12;
  push r13;
 {$IFNDEF WIN64}
  mov r12,r8;             // adress Res2
  mov r13,r9;             // lenght res2
  mov rcx,rdi;            // adress Feld
  mov rdx,rsi;            // length Feld
  mov r8, rdx;            // adress Res1
  mov r9, rcx;            // length Res1
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Res2];
  mov r13,qword ptr [Res2+8];
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;
  js   @ende;
  cmp  rdx,r9;            // length Feld = length Res1
  jne  @ende;
  cmp  rdx,r13;           // lenght Feld = Lenght Res2
  jne  @ende;
  mov  r10,qword ptr [Res3+8]; // lenght Feld = lenght Res3
  cmp  rdx,r10;
  jne  @ende;
  mov  r10,qword ptr [Res4+8]; // lenght Feld = lenght Res4
  cmp  rdx,r10;
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  mov  r11,qword ptr [Res3];
  mov  r13,qword ptr [Res4];
  xor  r10,r10;
  cmp  rdx,4;
  jb   @rest;
align 16;
 @Loop:
  movaps   xmm0,xmmword ptr [rcx];
  add rcx,16;
  insertps xmm1,xmm0,00001110b;
  insertps xmm2,xmm0,01000000b;
  insertps xmm3,xmm0,10000000b;
  insertps xmm4,xmm0,11000000b;
  movaps   xmm0,xmmword ptr [rcx];
  add rcx,16;
  insertps xmm1,xmm0,00010000b;
  insertps xmm2,xmm0,01010000b;
  insertps xmm3,xmm0,10010000b;
  insertps xmm4,xmm0,11010000b;
  movaps   xmm0,xmmword ptr [rcx];
  add rcx,16;
  insertps xmm1,xmm0,00100000b;
  insertps xmm2,xmm0,01100000b;
  insertps xmm3,xmm0,10100000b;
  insertps xmm4,xmm0,11100000b;
  movaps   xmm0,xmmword ptr [rcx];
  add rcx,16;
  insertps xmm1,xmm0,00110000b;
  insertps xmm2,xmm0,01110000b;
  insertps xmm3,xmm0,10110000b;
  insertps xmm4,xmm0,11110000b;
  movups  xmmword ptr [r8+r10],xmm1;
  movups  xmmword ptr [r12+r10],xmm2;
  movups  xmmword ptr [r11+r10],xmm3;
  movups  xmmword ptr [r13+r10],xmm4;
  add r10,16;
  sub rdx,4;
  jz  @ende;
  cmp rdx,4;
  jb  @rest;
  jae @Loop;

align 16;
 @rest:
  movaps xmm0,xmmword ptr [rcx];
  add rcx,16;
  insertps xmm1,xmm0,00001110b;
  insertps xmm2,xmm0,01000000b;
  insertps xmm3,xmm0,10000000b;
  insertps xmm4,xmm0,11000000b;
  movss dword ptr [r8+r10],xmm1;
  movss dword ptr [r12+r10],xmm2;
  movss dword ptr [r11+r10],xmm3;
  movss dword ptr [r13+r10],xmm4;
  add r10,4;
  sub rdx,1;
  jnz @rest;

 @ende:
  pop r13;
  pop r12;
end;

{Remark: we reading only the first 3 cols of the Feld array!}
function T4SingleTo3Single (const Feld :array of T4Single;
                   out Res1,Res2,Res3 :array of Single):Longbool;assembler;
 asm
  push r12;
  push r13;
 {$IFNDEF WIN64}
  mov r12,r8;             // adress Res2
  mov r13,r9;             // lenght Res2
  mov rcx,rdi;            // adress Feld
  mov rdx,rsi;            // length Feld
  mov r8, rdx;            // adress Res1
  mov r9, rcx;            // length Res1
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Res2];
  mov r13,qword ptr [Res2+8];
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;
  js   @ende;
  cmp  rdx,r9;            // length Feld = length Res1
  jne  @ende;
  cmp  rdx,r13;           // lenght Feld = Lenght Res2
  jne  @ende;
  mov  r10,qword ptr [Res3+8];
  cmp  rdx,r10;           // lenght Feld = lenght Res3
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  mov  r11,qword ptr [Res3];
  xor  r10,r10;
  cmp  rdx,4;
  jb   @rest;
align 16;
 @Loop:
  movaps   xmm0,xmmword ptr [rcx];
  add rcx,16;
  insertps xmm1,xmm0,00001110b;
  insertps xmm2,xmm0,01000000b;
  insertps xmm3,xmm0,10000000b;
  movaps   xmm0,xmmword ptr [rcx];
  add rcx,16;
  insertps xmm1,xmm0,00010000b;
  insertps xmm2,xmm0,01010000b;
  insertps xmm3,xmm0,10010000b;
  movaps   xmm0,xmmword ptr [rcx];
  add rcx,16;
  insertps xmm1,xmm0,00100000b;
  insertps xmm2,xmm0,01100000b;
  insertps xmm3,xmm0,10100000b;
  movaps   xmm0,xmmword ptr [rcx];
  add rcx,16;
  insertps xmm1,xmm0,00110000b;
  insertps xmm2,xmm0,01110000b;
  insertps xmm3,xmm0,10110000b;
  movups xmmword ptr [r8+r10],xmm1;
  movups xmmword ptr [r12+r10],xmm2;
  movups xmmword ptr [r11+r10],xmm3;
  add r10,16;
  sub rdx,4;
  jz  @ende;
  cmp rdx,4;
  jb  @rest;
  jae @Loop;

align 16;
 @rest:
  movaps xmm0,xmmword ptr [rcx];
  add rcx,16;
  insertps xmm1,xmm0,00001110b;
  insertps xmm2,xmm0,01000000b;
  insertps xmm3,xmm0,10000000b;
  movss dword ptr [r8+r10],xmm1;
  movss dword ptr [r12+r10],xmm2;
  movss dword ptr [r11+r10],xmm3;
  add r10,4;
  sub rdx,1;
  jnz @rest;

 @ende:
  pop r13;
  pop r12;
end;


function T4SingleTo2Single (const Feld :array of T4Single;
                   out Res1,Res2 :array of Single):Longbool;assembler;
 asm
  push r12;
  push r13;
 {$IFNDEF WIN64}
  mov r12,r8;             // adress Res2
  mov r13,r9;             // lenght Res2
  mov rcx,rdi;            // adress Feld
  mov rdx,rsi;            // length Feld
  mov r8, rdx;            // adress Res1
  mov r9, rcx;            // length Res1
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Res2];
  mov r13,qword ptr [Res2+8];
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;
  js   @ende;
  cmp  rdx,r9;            // length Feld = length Res1
  jne  @ende;
  mov  rdx,r13;           // lenght Feld = lenght Res2
  jne  @ende;
  mov  rax,1;
  add  rdx,1;
  xor  r10,r10;
  cmp  rdx,4;
  jb   @rest;
align 16;
 @Loop:
  movaps   xmm0,xmmword ptr [rcx];
  add rcx,16;
  insertps xmm1,xmm0,00001110b;
  insertps xmm2,xmm0,01000000b;
  movaps   xmm0,xmmword ptr [rcx];
  add rcx,16;
  insertps xmm1,xmm0,00010000b;
  insertps xmm2,xmm0,01010000b;
  movaps   xmm0,xmmword ptr [rcx];
  add rcx,16;
  insertps xmm1,xmm0,00100000b;
  insertps xmm2,xmm0,01100000b;
  movaps   xmm0,xmmword ptr [rcx];
  add rcx,16;
  insertps xmm1,xmm0,00110000b;
  insertps xmm2,xmm0,01110000b;
  movups  xmmword ptr [r8+r10],xmm1;
  movups  xmmword ptr [r12+r10],xmm2;
  add r10,16;
  sub rdx,4;
  jz  @ende;
  cmp rdx,4;
  jb  @rest;
  jae @Loop;

align 16;
 @rest:
  movaps xmm0,xmmword ptr [rcx];
  add rcx,16;
  insertps xmm1,xmm0,00001110b;
  insertps xmm2,xmm0,01000000b;
  movss dword ptr [r8+r10],xmm1;
  movss dword ptr [r12+r10],xmm2;
  add r10,4;
  sub rdx,1;
  jnz @rest;

 @ende:
  pop r13;
  pop r12;
end;

function T4SingleToSingle (const Feld :array of T4Single;
                             out Res  :array of Single):Longbool;
                                assembler;nostackframe;
 asm
  {$IFNDEF WIN64}
  mov rcx,rdi;            // adress Feld
  mov rdx,rsi;            // length Feld
  mov r8, rdx;            // adress Res
  mov r9, rcx;            // length Res
  {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;
  js   @ende;
  test r9,r9;
  js   @ende;
  add  rdx,1;
  add  r9,1;
  shr  r9,2;              // div 4
  cmp  rdx,r9;            // length Feld = Length Res1;
  jne  @ende;
  xor  r10,r10;
  mov  rax,1;            //true
align 16;
 @Loop:
  movaps xmm0,xmmword ptr [rcx+r10];
  movups xmmword ptr [r8+r10],xmm0;
  add r10,16;
  sub rdx,1;
  jnz @Loop;
 @ende:
end;

{-----------------------convert arrays in cols direction---------------------}

function Array2ToT2Double (const Feld1,Feld2 :array of Double;
                             out Res :array of T2Double):Longbool;assembler;
 asm
  push r12;
  push r13;
 {$IFNDEF WIN64}
  mov  r12,r8;             // adress Res
  mov  r13,r9;             // lenght Res
  mov  rcx,rdi;            // adress Feld1
  mov  rdx,rsi;            // length feld1
  mov  r8, rdx;            // adress Feld2
  mov  r9, rcx;            // length feld2
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Res];
  mov r13,qword ptr [Res+8];
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;
  js  @ende;
  cmp  rdx,r9;             // length Feld1 = Length Feld2;
  jne  @ende;
  cmp  rdx,r13;           // length Res = length Feld1
  jne  @ende;
  add  rdx,1;
  mov  rax,1;             // true
  xor  r10,r10;
  cmp  rdx,2;
  jb   @rest
align 16;
 @Loop:
  movupd xmm0,xmmword ptr [rcx+r10];  // feld1
  movupd xmm1,xmmword ptr [r8+r10];   // feld2
  movapd xmm2,xmm0;
  shufpd xmm0,xmm1,00000000b;
  shufpd xmm2,xmm1,00000011b;
  movapd xmmword ptr [r12],xmm0;
  add r12,16;
  movapd xmmword ptr [r12],xmm2;
  add r12,16;
  add r10,16;
  sub rdx,2;
  jz  @ende;
  cmp rdx,2;
  jae @Loop;

align 16;
 @rest:
  movsd  xmm0,qword ptr [rcx+r10];
  movsd  xmm1,qword ptr [r8+r10];
  shufpd xmm0,xmm1,00000000b;
  movapd xmmword ptr [r12],xmm0;
  add r12,16;
  add r10,8;
  sub rdx,1;
  jnz @Rest;

 @ende:
  pop r13;
  pop r12;
end;

function ArrayToT2Double (const Feld :array of Double;
                           out Res :array of T2Double;Flag :Boolean):Longbool;
                              assembler;nostackframe;
 asm
  push r12;
 {$IFNDEF WIN64}
  movsx r12d,r8b;         //Flag
  mov rcx,rdi;            // adress Feld
  mov rdx,rsi;            // length feld
  mov r8, rdx;            // adress Res
  mov r9, rcx;            // length Res
 {$ENDIF}
 {$IFDEF WIN64}
  movsx r12d,byte ptr [Flag];
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;
  js   @ende;
  test r9,r9;
  js   @ende;
  add  rdx,1;
  add  r9,1;
  shl  r9,1;              // *2
  cmp  rdx,r9;            // length Feld = Length Res;
  je   @ok;
  jg   @ende;             // Feld > Res
  mov  r10,r9;
  sub  r10,rdx;
  cmp  r10,2;             // when diff >= error res is to long
  jge  @ende;
 @ok:
  mov  rax,1;
  xor  r11,r11;
  pxor xmm1,xmm1;       // set 0
  cmp  r12b,1;           // flag = True fill value 1
  jne  @1;
  pcmpeqw xmm1,xmm1;
  psllq   xmm1,54;
  psrlq   xmm1,2;       // set 1.0 on all places
 @1:
  cmp rdx,2;
  jl  @rest;
align 16;
 @Loop:
  movupd xmm0,xmmword ptr [rcx+r11];
  movapd xmmword ptr [r8+r11],xmm0;
  add r11,16;
  sub rdx,2;
  jz  @ende;
  cmp rdx,2;
  jae @Loop;

align 16;
 @rest:        // only 1 times posibility
  movsd xmm0,qword ptr [rcx+r11];
  movsd xmm1,xmm0;                  //fill rest with 0 or 1
  movapd xmmword ptr [r8+r11],xmm1;

 @ende:
  pop r12;
end;

{-----------------------convert arrays in rows direction---------------------}

function T2DoubleTo2Double (const Feld :array of T2Double;
                             out Res1,Res2 :array of Double):Longbool;assembler;
 asm
  push r12;
  push r13;
 {$IFNDEF WIN64}
  mov r12,r8;             // adress Res2
  mov r13,r9;             // lenght Res2
  mov rcx,rdi;            // adress Feld
  mov rdx,rsi;            // length Feld
  mov r8, rdx;            // adress Res1
  mov r9, rcx;            // length Res1
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Res2];
  mov r13,qword ptr [Res2+8];
 {$ENDIF}
  xor  rax,rax
  test rdx,rdx;
  js  @ende;
  cmp  rdx,r9;
  jne  @ende;
  cmp  rdx,r13;
  jne  @ende;
  add  rdx,1;
  mov  rax,1;
  xor  r10,r10;
  cmp  rdx,2;
  jb   @rest;
align 16;
 @Loop:
  movapd  xmm0,xmmword ptr [rcx];
  add rcx,16;
  movapd xmm1,xmm0;
  movapd xmm2,xmm0;
  shufpd xmm1,xmm0,00000000b;
  shufpd xmm2,xmm0,00000001b;
  movapd xmm0,xmmword ptr [rcx];
  add rcx,16;
  shufpd xmm1,xmm0,00000001b;
  shufpd xmm2,xmm0,00000010b;
  movupd xmmword ptr [r8+r10],xmm1;
  movupd xmmword ptr [r12+r10],xmm2;
  add r10,16;
  sub rdx,2;
  jz  @ende;
  cmp rdx,2;
  jb  @rest;
  jae @Loop;

align 16;
 @rest:
  movapd xmm0,xmmword ptr [rcx];
  add rcx,16;
  movapd xmm1,xmm0;
  movapd xmm2,xmm0;
  shufpd xmm1,xmm0,00000000b;
  shufpd xmm2,xmm0,00000001b;
  movsd dword ptr [r8+r10],xmm1;
  movsd dword ptr [r12+r10],xmm2;
  add r10,8;
  sub rdx,1;
  jnz @rest;

align 16;
 @ende:
  pop r13;
  pop r12;
end;

function T2DoubleToDouble (const Feld :array of T2Double;
                             out Res  :array of Double):Longbool;
                                assembler;nostackframe;

 asm
  {$IFNDEF WIN64}
  mov rcx,rdi;            // adress Feld
  mov rdx,rsi;            // length Feld
  mov r8, rdx;            // adress Res
  mov r9, rcx;            // length Res
  {$ENDIF}
  xor  rax,rax
  test rdx,rdx;
  js   @ende;
  test r9,r9;
  js   @ende;
  add  rdx,1;
  add  r9,1;
  shr  r9,1;
  cmp  rdx,r9;            // length Feld *2 = Length Res;
  jne  @ende;
  xor  r10,r10;
  mov  rax,1;
align 16;
 @Loop:
  movapd xmm0,xmmword ptr [rcx+r10];
  movupd xmmword ptr [r8+r10],xmm0;
  add r10,16;
  sub rdx,1;
  jnz @Loop;
 @ende:
end;



{$IFDEF SIMD256}

{$FPUTYPE AVX}  // from here use avx

{----------------------convert for ymm arrays--------------------------------}

{-----------------------convert arrays in cols direction---------------------}

function Array8ToT8Single (const Feld1,Feld2,Feld3,Feld4,
                                 Feld5,Feld6,Feld7,Feld8 :array of Single;
                            out Res :array of T8Single):Longbool;assembler;
 asm
  push r12;
  push r13;
  push r14;
  push r15;
  push rbx;
 {$IFNDEF WIN64}
  mov r12,r8;             // adress Feld3
  mov r13,r9;             // lenght Feld3
  mov rcx,rdi;            // adress Feld1
  mov rdx,rsi;            // length Feld1
  mov r8, rdx;            // adress Feld2
  mov r9, rcx;            // lenght Feld2
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Feld3];
  mov r13,qword ptr [Feld3+8];
  sub rsp,128;
  vmovdqu ymmword ptr [rsp],ymm6;
  vmovdqu ymmword ptr [rsp+32],ymm7;
  vmovdqu ymmword ptr [rsp+64],ymm8;
  vmovdqu ymmword ptr [rsp+96],ymm9;
 {$ENDIF}
  xor rax,rax;                      // set result = false
  test rdx,rdx;                     // value < 0 not valid
  js  @ende;
  cmp rdx,r9;                       // length Feld1 = Length Feld2;
  jne @ende;
  cmp rdx,r13;                      // lenght Feld1 = lenght Feld3
  jne @ende;
  mov r10,qword ptr [Feld4+8];      // lenght Feld1 = lenght Feld4
  cmp rdx,r10;
  jne @ende;
  mov r10,qword ptr [Feld5+8];      // lenght Feld1 = lenght Feld5
  cmp rdx,r10;
  jne @ende;
  mov r10,qword ptr [Feld6+8];      // lenght Feld1 = lenght Feld6
  cmp rdx,r10;
  jne @ende;
  mov r10,qword ptr [Feld7+8];      // lenght Feld1 = lenght Feld7
  cmp rdx,r10;
  jne @ende;
  mov r10,qword ptr [Feld8+8];      // lenght Feld1 = lenght Feld8
  cmp rdx,r10;
  jne @ende;
  mov r10,[Res+8];                  // length Feld1 = length Res
  cmp rdx,r10;
  jne @ende;
  mov rax,1;
  mov r11,qword ptr [Feld4];
  mov r9, qword ptr [Feld5];
  mov r14,qword ptr [Feld6];
  mov r15,qword ptr [Feld7];
  mov rbx,qword ptr [Feld8];
  mov r13,qword ptr [Res];
  push rax;
  add rdx,1;
  xor r10,r10;
  cmp rdx,8;              // when < 8 work with movss
  jb  @rest;

align 16;
 @Loop:
  mov  rax,2;
  vmovups ymm0,ymmword ptr [rcx+r10];  //Feld1
  vmovups ymm1,ymmword ptr [r8+r10];   //Feld2
  vmovups ymm2,ymmword ptr [r12+r10];  //Feld3
  vmovups ymm3,ymmword ptr [r11+r10];  //Feld4
  vmovups ymm4,ymmword ptr [r9+r10];   //feld5
  vmovups ymm5,ymmword ptr [r14+r10];  //feld6
  vmovups ymm6,ymmword ptr [r15+r10];  //feld7
  vmovups ymm7,ymmword ptr [rbx+r10];  //Feld8

align 16;
 @Loop1:
  vinsertps xmm8,xmm8,xmm0,00000000b;
  vinsertps xmm8,xmm8,xmm1,00010000b;
  vinsertps xmm8,xmm8,xmm2,00100000b;
  vinsertps xmm8,xmm8,xmm3,00110000b;
  vinsertps xmm9,xmm9,xmm4,00000000b;
  vinsertps xmm9,xmm9,xmm5,00010000b;
  vinsertps xmm9,xmm9,xmm6,00100000b;
  vinsertps xmm9,xmm9,xmm7,00110000b;
  vinsertf128 ymm8,ymm8,xmm9,1;
  vmovups  ymmword ptr [r13],ymm8; // first col of T8Single
  add r13,32;
  vinsertps xmm8,xmm8,xmm0,01000000b;
  vinsertps xmm8,xmm8,xmm1,01010000b;
  vinsertps xmm8,xmm8,xmm2,01100000b;
  vinsertps xmm8,xmm8,xmm3,01110000b;
  vinsertps xmm9,xmm9,xmm4,01000000b;
  vinsertps xmm9,xmm9,xmm5,01010000b;
  vinsertps xmm9,xmm9,xmm6,01100000b;
  vinsertps xmm9,xmm9,xmm7,01110000b;
  vinsertf128 ymm8,ymm8,xmm9,1;
  vmovups  ymmword ptr [r13],ymm8; // 2 col of T8Single
  add r13,32;
  vinsertps xmm8,xmm8,xmm0,10000000b;
  vinsertps xmm8,xmm8,xmm1,10010000b;
  vinsertps xmm8,xmm8,xmm2,10100000b;
  vinsertps xmm8,xmm8,xmm3,10110000b;
  vinsertps xmm9,xmm9,xmm4,10000000b;
  vinsertps xmm9,xmm9,xmm5,10010000b;
  vinsertps xmm9,xmm9,xmm6,10100000b;
  vinsertps xmm9,xmm9,xmm7,10110000b;
  vinsertf128 ymm8,ymm8,xmm9,1;
  vmovups  ymmword ptr [r13],ymm8; // 3 col of T8Single
  add r13,32;
  vinsertps xmm8,xmm8,xmm0,11000000b;
  vinsertps xmm8,xmm8,xmm1,11010000b;
  vinsertps xmm8,xmm8,xmm2,11100000b;
  vinsertps xmm8,xmm8,xmm3,11110000b;
  vinsertps xmm9,xmm9,xmm4,11000000b;
  vinsertps xmm9,xmm9,xmm5,11010000b;
  vinsertps xmm9,xmm9,xmm6,11100000b;
  vinsertps xmm9,xmm9,xmm7,11110000b;
  vinsertf128 ymm8,ymm8,xmm9,1;
  vmovups  ymmword ptr [r13],ymm8; // 4 col of T8Single
  add r13,32;
  // need upper values from ymm
  vextractf128 xmm0,ymm0,1;
  vextractf128 xmm1,ymm1,1;
  vextractf128 xmm2,ymm2,1;
  vextractf128 xmm3,ymm3,1;
  vextractf128 xmm4,ymm4,1;
  vextractf128 xmm5,ymm5,1;
  vextractf128 xmm6,ymm6,1;
  vextractf128 xmm7,ymm7,1;
  sub rax,1;
  jnz @loop1;
  add r10,32;
  sub rdx,8;
  jz  @ende;
  cmp rdx,8;
  jae @Loop;

align 16;
 @rest:
  vmovd xmm0,dword ptr [rcx+r10];  //Feld1
  vmovd xmm1,dword ptr [r8+r10];   //Feld2
  vmovd xmm2,dword ptr [r12+r10];  //Feld3
  vmovd xmm3,dword ptr [r11+r10];  //Feld4
  vmovd xmm4,dword ptr [r9+r10];   //feld5
  vmovd xmm5,dword ptr [r14+r10];  //feld6
  vmovd xmm6,dword ptr [r15+r10];  //feld7
  vmovd xmm7,dword ptr [rbx+r10];  //Feld8
  vinsertps xmm8,xmm8,xmm0,00000000b;
  vinsertps xmm8,xmm8,xmm1,00010000b;
  vinsertps xmm8,xmm8,xmm2,00100000b;
  vinsertps xmm8,xmm8,xmm3,00110000b;
  vinsertps xmm9,xmm9,xmm4,00000000b;
  vinsertps xmm9,xmm9,xmm5,00010000b;
  vinsertps xmm9,xmm9,xmm6,00100000b;
  vinsertps xmm9,xmm9,xmm7,00110000b;
  vinsertf128 ymm8,ymm8,xmm9,1;
  vmovups ymmword ptr [r13],ymm8;
  add r13,32;
  add r10,4;
  sub rdx,1;
  jnz @rest;

align 16;
 @ende:
  pop rax;
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  vmovdqu ymm7,ymmword ptr [rsp+32];
  vmovdqu ymm8,ymmword ptr [rsp+64];
  vmovdqu ymm9,ymmword ptr [rsp+96];
  add rsp,128;
 {$ENDIF}
  vzeroupper;
  pop rbx;
  pop r15;
  pop r14;
  pop r13;
  pop r12;
end;

function Array7ToT8Single (const Feld1,Feld2,Feld3,Feld4,
                                 Feld5,Feld6,Feld7 :array of Single;
                           out Res :array of T8Single;Flag :Boolean):Longbool;
                                assembler;
 asm
  push r12;
  push r13;
  push r14;
  push r15;
  push rbx;
 {$IFNDEF WIN64}
  mov r12,r8;             // adress Feld3
  mov r13,r9;             // lenght Feld3
  mov rcx,rdi;            // adress Feld1
  mov rdx,rsi;            // length Feld1
  mov r8, rdx;            // adress Feld2
  mov r9, rcx;            // lenght Feld2
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Feld3];
  mov r13,qword ptr [Feld3+8];
  sub rsp,128;
  vmovdqu ymmword ptr [rsp],   ymm6;
  vmovdqu ymmword ptr [rsp+32],ymm7;
  vmovdqu ymmword ptr [rsp+64],ymm8;
  vmovdqu ymmword ptr [rsp+64],ymm9;
 {$ENDIF}
  xor  rax,rax;                  // set result = false
  test rdx,rdx;                  // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;                   // length Feld1 = Length Feld2;
  jne  @ende;
  cmp  rdx,r13;                  // length Feld1 = length Feld3
  jne  @ende;
  mov  r10,qword ptr [Feld4+8];  // lenght Feld1 = lenght Feld4
  cmp  rdx,r10;
  jne  @ende;
  mov  r10,qword ptr [Feld5+8];  // lenght Feld1 = lenght Feld5
  cmp  rdx,r10;
  jne  @ende;
  mov  r10,qword ptr [Feld6+8];  // lenght Feld1 = lenght Feld6
  cmp  rdx,r10;
  jne  @ende;
  mov  r10,qword ptr [Feld7+8];  // lenght Feld1 = lenght Feld7
  cmp  rdx,r10;
  jne  @ende;
  mov  r10,qword ptr [Res+8];
  cmp  rdx,r10                   // lenght Feld1  = lenght Res
  jne  @ende;
  mov  rax,1;                    // true
  mov  r9, qword ptr [Feld4];
  mov  r11,qword ptr [Feld5];
  mov  r13,qword ptr [Feld6];
  mov  r14,qword ptr [Feld7];
  mov  r15,qword ptr [Res];
  add  rdx,1;
  xor  r10,r10;
  vpxor xmm7,xmm7,xmm7;
  movsx ebx,byte ptr [Flag];
  cmp  ebx,1;                 //true
  jne  @1;
  vpcmpeqw xmm7,xmm7,xmm7;
  vpslld   xmm7,xmm7,25;
  vpsrld   xmm7,xmm7,2;     // set 1.0
  cmp  rdx,8;              // when < 8 work with vsmovss
  jb   @rest;
  jmp  @Loop;
 @1:
  cmp  rdx,8;              // when < 8 work with vsmovss
  jb   @rest;

align 16;
 @Loop:
  mov  ebx,2;
  vmovups ymm0,ymmword ptr [rcx+r10];  //Feld1
  vmovups ymm1,ymmword ptr [r8 +r10];  //Feld2
  vmovups ymm2,ymmword ptr [r12+r10];  //Feld3
  vmovups ymm3,ymmword ptr [r9 +r10];  //Feld4
  vmovups ymm4,ymmword ptr [r11+r10];  //Feld5
  vmovups ymm5,ymmword ptr [r13+r10];  //Feld6
  vmovups ymm6,ymmword ptr [r14+r10];  //Feld7

align 16;
 @Loop1:
  vinsertps xmm8,xmm8,xmm0,00000000b;
  vinsertps xmm8,xmm8,xmm1,00010000b;
  vinsertps xmm8,xmm8,xmm2,00100000b;
  vinsertps xmm8,xmm8,xmm3,00110000b;
  vinsertps xmm9,xmm9,xmm4,00000000b;
  vinsertps xmm9,xmm9,xmm5,00010000b;
  vinsertps xmm9,xmm9,xmm6,00100000b;
  vinsertps xmm9,xmm9,xmm7,00110000b;
  vinsertf128 ymm8,ymm8,xmm9,1;
  vmovups  ymmword ptr [r15],ymm8; // first col of T8Single
  add r15,32;
  vinsertps xmm8,xmm8,xmm0,01000000b;
  vinsertps xmm8,xmm8,xmm1,01010000b;
  vinsertps xmm8,xmm8,xmm2,01100000b;
  vinsertps xmm8,xmm8,xmm3,01110000b;
  vinsertps xmm9,xmm9,xmm4,01000000b;
  vinsertps xmm9,xmm9,xmm5,01010000b;
  vinsertps xmm9,xmm9,xmm6,01100000b;
  vinsertps xmm9,xmm9,xmm7,01110000b;
  vinsertf128 ymm8,ymm8,xmm9,1;
  vmovups  ymmword ptr [r15],ymm8; // 2 col of T8Single
  add r15,32;
  vinsertps xmm8,xmm8,xmm0,10000000b;
  vinsertps xmm8,xmm8,xmm1,10010000b;
  vinsertps xmm8,xmm8,xmm2,10100000b;
  vinsertps xmm8,xmm8,xmm3,10110000b;
  vinsertps xmm9,xmm9,xmm4,10000000b;
  vinsertps xmm9,xmm9,xmm5,10010000b;
  vinsertps xmm9,xmm9,xmm6,10100000b;
  vinsertps xmm9,xmm9,xmm7,10110000b;
  vinsertf128 ymm8,ymm8,xmm9,1;
  vmovups  ymmword ptr [r15],ymm8; // 3 col of T8Single
  add r15,32;
  vinsertps xmm8,xmm8,xmm0,11000000b;
  vinsertps xmm8,xmm8,xmm1,11010000b;
  vinsertps xmm8,xmm8,xmm2,11100000b;
  vinsertps xmm8,xmm8,xmm3,11110000b;
  vinsertps xmm9,xmm9,xmm4,11000000b;
  vinsertps xmm9,xmm9,xmm5,11010000b;
  vinsertps xmm9,xmm9,xmm6,11100000b;
  vinsertps xmm9,xmm9,xmm7,11110000b;
  vinsertf128 ymm8,ymm8,xmm9,1;
  vmovups  ymmword ptr [r15],ymm8; // 4 col of T8Single
  add r15,32;
  // need upper values from ymm
  vextractf128 xmm0,ymm0,1;
  vextractf128 xmm1,ymm1,1;
  vextractf128 xmm2,ymm2,1;
  vextractf128 xmm3,ymm3,1;
  vextractf128 xmm4,ymm4,1;
  vextractf128 xmm5,ymm5,1;
  vextractf128 xmm6,ymm6,1;
  sub ebx,1;
  jnz @loop1;
  add r10,32;
  sub rdx,8;
  jz  @ende;
  cmp rdx,8;
  jae @Loop;

align 16;
 @rest:
  vmovd xmm0,dword ptr [rcx+r10];  //Feld1
  vmovd xmm1,dword ptr [r8 +r10];  //Feld2
  vmovd xmm2,dword ptr [r12+r10];  //Feld3
  vmovd xmm3,dword ptr [r9 +r10];  //Feld4
  vmovd xmm4,dword ptr [r11+r10];  //feld5
  vmovd xmm5,dword ptr [r13+r10];  //feld6
  vmovd xmm6,dword ptr [r14+r10];  //feld7
  vinsertps xmm8,xmm8,xmm0,00000000b;
  vinsertps xmm8,xmm8,xmm1,00010000b;
  vinsertps xmm8,xmm8,xmm2,00100000b;
  vinsertps xmm8,xmm8,xmm3,00110000b;
  vinsertps xmm9,xmm9,xmm4,00000000b;
  vinsertps xmm9,xmm9,xmm5,00010000b;
  vinsertps xmm9,xmm9,xmm6,00100000b;
  vinsertps xmm9,xmm9,xmm7,00110000b;
  vinsertf128 ymm8,ymm8,xmm9,1;
  vmovups  ymmword ptr [r15],ymm8;
  add r15,32;
  add r10,4;
  sub rdx,1;
  jnz @rest;

align 16;
 @ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  vmovdqu ymm7,ymmword ptr [rsp+32];
  vmovdqu ymm8,ymmword ptr [rsp+64];
  vmovdqu ymm9,ymmword ptr [rsp+96];
  add rsp,128;
 {$ENDIF}
  vzeroupper;
  pop rbx;
  pop r15;
  pop r14;
  pop r13;
  pop r12;
end;

function Array6ToT8Single (const Feld1,Feld2,Feld3,Feld4,
                                 Feld5,Feld6 :array of Single;
                           out Res :array of T8Single;Flag :Boolean):Longbool;
                                assembler;
 asm
  push r12;
  push r13;
  push r14;
  push r15;
 {$IFNDEF WIN64}
  mov r12,r8;             // adress Feld3
  mov r13,r9;             // lenght Feld3
  mov rcx,rdi;            // adress Feld1
  mov rdx,rsi;            // length Feld1
  mov r8, rdx;            // adress Feld2
  mov r9, rcx;            // lenght Feld2
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Feld3];
  mov r13,qword ptr [Feld3+8];
  sub rsp,96;
  vmovdqu ymmword ptr [rsp],ymm6;
  vmovdqu ymmword ptr [rsp+32],ymm7;
  vmovdqu ymmword ptr [rsp+64],ymm8;
 {$ENDIF}
  xor  rax,rax;                     // set result = false
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;                      // length Feld1 = Length Feld2;
  jne  @ende;
  cmp  rdx,r13;                     // length feld1 = length Feld3
  jne  @ende;
  mov  r10,qword ptr [Feld4+8];     // lenght Feld1 = lenght Feld4
  cmp  rdx,r10;
  jne  @ende;
  mov  r10,qword ptr [Feld5+8];     // lenght Feld1 = lenght Feld5
  cmp  rdx,r10;
  jne  @ende;
  mov  r10,qword ptr [Feld6+8];     // lenght Feld1 = lenght Feld6
  cmp  rdx,r10;
  jne  @ende;
  mov  r10,qword ptr [Res+8];
  cmp  rdx,r10                       // lenght Feld1  = lenght Res
  jne  @ende;
  mov  rax,1;
  mov  r11,qword ptr [Feld4];
  mov  r13,qword ptr [Res];
  mov  r9, qword ptr [Feld5];
  mov  r14,qword ptr [Feld6];
  add  rdx,1;
  xor  r10,r10;
  movsx r15d,byte ptr [Flag];
  cmp  r15d,1;                 //true
  jne  @1;
  vpcmpeqw xmm6,xmm6,xmm6;
  vpslld   xmm6,xmm6,25;
  vpsrld   xmm6,xmm6,2;     // set 1.0
  cmp  rdx,8;              // when < 8 work with vsmovss
  jb   @rest;
  jmp  @Loop;
 @1:
  vpxor xmm6,xmm6,xmm6;
  cmp  rdx,8;              // when < 8 work with vsmovss
  jb   @rest;

align 16;
 @Loop:
  mov  r15d,2;
  vmovups ymm0,ymmword ptr [rcx+r10];  //Feld1
  vmovups ymm1,ymmword ptr [r8+r10];   //Feld2
  vmovups ymm2,ymmword ptr [r12+r10];  //Feld3
  vmovups ymm3,ymmword ptr [r11+r10];  //Feld4
  vmovups ymm4,ymmword ptr [r9+r10];   //Feld5
  vmovups ymm5,ymmword ptr [r14+r10];  //Feld6

align 16;
 @Loop1:
  vinsertps xmm7,xmm7,xmm0,00000000b;
  vinsertps xmm7,xmm7,xmm1,00010000b;
  vinsertps xmm7,xmm7,xmm2,00100000b;
  vinsertps xmm7,xmm7,xmm3,00110000b;
  vinsertps xmm8,xmm8,xmm4,00000000b;
  vinsertps xmm8,xmm8,xmm5,00010000b;
  vinsertps xmm8,xmm8,xmm6,00100000b;
  vinsertps xmm8,xmm8,xmm6,00110000b;
  vinsertf128 ymm7,ymm7,xmm8,1;
  vmovups  ymmword ptr [r13],ymm7; // first col of T8Single
  add r13,32;
  vinsertps xmm7,xmm7,xmm0,01000000b;
  vinsertps xmm7,xmm7,xmm1,01010000b;
  vinsertps xmm7,xmm7,xmm2,01100000b;
  vinsertps xmm7,xmm7,xmm3,01110000b;
  vinsertps xmm8,xmm8,xmm4,01000000b;
  vinsertps xmm8,xmm8,xmm5,01010000b;
  vinsertps xmm8,xmm8,xmm6,01100000b;
  vinsertps xmm8,xmm8,xmm6,01110000b;
  vinsertf128 ymm7,ymm7,xmm8,1;
  vmovups  ymmword ptr [r13],ymm7; // 2 col of T8Single
  add r13,32;
  vinsertps xmm7,xmm7,xmm0,10000000b;
  vinsertps xmm7,xmm7,xmm1,10010000b;
  vinsertps xmm7,xmm7,xmm2,10100000b;
  vinsertps xmm7,xmm7,xmm3,10110000b;
  vinsertps xmm8,xmm8,xmm4,10000000b;
  vinsertps xmm8,xmm8,xmm5,10010000b;
  vinsertps xmm8,xmm8,xmm6,10100000b;
  vinsertps xmm8,xmm8,xmm6,10110000b;
  vinsertf128 ymm7,ymm7,xmm8,1;
  vmovups  ymmword ptr [r13],ymm7; // 3 col of T8Single
  add r13,32;
  vinsertps xmm7,xmm7,xmm0,11000000b;
  vinsertps xmm7,xmm7,xmm1,11010000b;
  vinsertps xmm7,xmm7,xmm2,11100000b;
  vinsertps xmm7,xmm7,xmm3,11110000b;
  vinsertps xmm8,xmm8,xmm4,11000000b;
  vinsertps xmm8,xmm8,xmm5,11010000b;
  vinsertps xmm8,xmm8,xmm6,11100000b;
  vinsertps xmm8,xmm8,xmm6,11110000b;
  vinsertf128 ymm7,ymm7,xmm8,1;
  vmovups  ymmword ptr [r13],ymm7; // 4 col of T8Single
  add r13,32;
  // need upper values from ymm
  vextractf128 xmm0,ymm0,1;
  vextractf128 xmm1,ymm1,1;
  vextractf128 xmm2,ymm2,1;
  vextractf128 xmm3,ymm3,1;
  vextractf128 xmm4,ymm4,1;
  vextractf128 xmm5,ymm5,1;
  sub r15d,1;
  jnz @loop1;
  add r10,32;
  sub rdx,8;
  jz  @ende;
  cmp rdx,8;
  jae @Loop;

align 16;
 @rest:
  vmovd xmm0,dword ptr [rcx+r10];  //Feld1
  vmovd xmm1,dword ptr [r8+r10];   //Feld2
  vmovd xmm2,dword ptr [r12+r10];  //Feld3
  vmovd xmm3,dword ptr [r11+r10];  //Feld4
  vmovd xmm4,dword ptr [r9+r10];   //feld5
  vmovd xmm5,dword ptr [r14+r10];  //feld6
  vinsertps xmm7,xmm7,xmm0,00000000b;
  vinsertps xmm7,xmm7,xmm1,00010000b;
  vinsertps xmm7,xmm7,xmm2,00100000b;
  vinsertps xmm7,xmm7,xmm3,00110000b;
  vinsertps xmm8,xmm8,xmm4,00000000b;
  vinsertps xmm8,xmm8,xmm5,00010000b;
  vinsertps xmm8,xmm8,xmm6,00100000b;
  vinsertps xmm8,xmm8,xmm6,00110000b;
  vinsertf128 ymm7,ymm7,xmm8,1;
  vmovups  ymmword ptr [r13],ymm7;
  add r13,32;
  add r10,4;
  sub rdx,1;
  jnz @rest;

align 16;
 @ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  vmovdqu ymm7,ymmword ptr [rsp+32];
  vmovdqu ymm8,ymmword ptr [rsp+64];
  add rsp,96;
 {$ENDIF}
  vzeroupper;
  pop r15;
  pop r14;
  pop r13;
  pop r12;
end;


function Array5ToT8Single (const Feld1,Feld2,Feld3,Feld4,Feld5 :array of Single;
                           out Res :array of T8Single;Flag :Boolean):Longbool;
                                assembler;
 asm
  push r12;
  push r13;
  push r14;
  push r15;
 {$IFNDEF WIN64}
  mov r12,r8;             // adress Feld3
  mov r13,r9;             // lenght Feld3
  mov rcx,rdi;            // adress Feld1
  mov rdx,rsi;            // length Feld1
  mov r8, rdx;            // adress Feld2
  mov r9, rcx;            // lenght Feld2
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Feld3];
  mov r13,qword ptr [Feld3+8];
  sub rsp,96;
  vmovdqu ymmword ptr [rsp],ymm6;
  vmovdqu ymmword ptr [rsp+32],ymm7;
  vmovdqu ymmword ptr [rsp+64],ymm8;
 {$ENDIF}
  xor  rax,rax;                     // set result = false
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;                      // length Feld1 = Length Feld2;
  jne  @ende;
  cmp  rdx,r13;                     // length Feld1 = length Feld3
  jne  @ende;
  mov  r10,qword ptr [Feld4+8];     // lenght Feld1 = lenght Feld4
  cmp  rdx,r10;
  jne  @ende;
  mov  r10,qword ptr [Feld5+8];     // lenght Feld1 = lenght Feld5
  cmp  rdx,r10;
  jne  @ende;
  mov  r10,qword ptr [Res+8];
  cmp  rdx,r10                      // lenght Feld1  = lenght Res
  jne  @ende;
  mov  rax,1;
  mov  r11,qword ptr [Feld4];
  mov  r13,qword ptr [Res];
  mov  r9, qword ptr [Feld5];
  add  rdx,1;
  xor  r10,r10;
  movsx r15d,byte ptr [Flag];
  cmp  r15d,1;                 //true
  jne  @1;
  vpcmpeqw xmm6,xmm6,xmm6;
  vpslld   xmm6,xmm6,25;
  vpsrld   xmm6,xmm6,2;     // set 1.0
  cmp  rdx,8;              // when < 8 work with vsmovss
  jb   @rest;
  jmp  @Loop;
 @1:
  vpxor xmm6,xmm6,xmm6;
  cmp  rdx,8;              // when < 8 work with vsmovss
  jb   @rest;

align 16;
 @Loop:
  mov  r15d,2;
  vmovups ymm0,ymmword ptr [rcx+r10];  //Feld1
  vmovups ymm1,ymmword ptr [r8 +r10];  //Feld2
  vmovups ymm2,ymmword ptr [r12+r10];  //Feld3
  vmovups ymm3,ymmword ptr [r11+r10];  //Feld4
  vmovups ymm4,ymmword ptr [r9 +r10];  //Feld5

align 16;
 @Loop1:
  vinsertps xmm7,xmm7,xmm0,00000000b;
  vinsertps xmm7,xmm7,xmm1,00010000b;
  vinsertps xmm7,xmm7,xmm2,00100000b;
  vinsertps xmm7,xmm7,xmm3,00110000b;
  vinsertps xmm8,xmm8,xmm4,00000000b;
  vinsertps xmm8,xmm8,xmm6,00010000b;
  vinsertps xmm8,xmm8,xmm6,00100000b;
  vinsertps xmm8,xmm8,xmm6,00110000b;
  vinsertf128 ymm7,ymm7,xmm8,1;
  vmovups  ymmword ptr [r13],ymm7; // first col of T8Single
  add r13,32;
  vinsertps xmm7,xmm7,xmm0,01000000b;
  vinsertps xmm7,xmm7,xmm1,01010000b;
  vinsertps xmm7,xmm7,xmm2,01100000b;
  vinsertps xmm7,xmm7,xmm3,01110000b;
  vinsertps xmm8,xmm8,xmm4,01000000b;
  vinsertps xmm8,xmm8,xmm6,01010000b;
  vinsertps xmm8,xmm8,xmm6,01100000b;
  vinsertps xmm8,xmm8,xmm6,01110000b;
  vinsertf128 ymm7,ymm7,xmm8,1;
  vmovups  ymmword ptr [r13],ymm7; // 2 col of T8Single
  add r13,32;
  vinsertps xmm7,xmm7,xmm0,10000000b;
  vinsertps xmm7,xmm7,xmm1,10010000b;
  vinsertps xmm7,xmm7,xmm2,10100000b;
  vinsertps xmm7,xmm7,xmm3,10110000b;
  vinsertps xmm8,xmm8,xmm4,10000000b;
  vinsertps xmm8,xmm8,xmm6,10010000b;
  vinsertps xmm8,xmm8,xmm6,10100000b;
  vinsertps xmm8,xmm8,xmm6,10110000b;
  vinsertf128 ymm7,ymm7,xmm8,1;
  vmovups  ymmword ptr [r13],ymm7; // 3 col of T8Single
  add r13,32;
  vinsertps xmm7,xmm7,xmm0,11000000b;
  vinsertps xmm7,xmm7,xmm1,11010000b;
  vinsertps xmm7,xmm7,xmm2,11100000b;
  vinsertps xmm7,xmm7,xmm3,11110000b;
  vinsertps xmm8,xmm8,xmm4,11000000b;
  vinsertps xmm8,xmm8,xmm6,11010000b;
  vinsertps xmm8,xmm8,xmm6,11100000b;
  vinsertps xmm8,xmm8,xmm6,11110000b;
  vinsertf128 ymm7,ymm7,xmm8,1;
  vmovups  ymmword ptr [r13],ymm7; // 4 col of T8Single
  add r13,32;
  // need upper values from ymm
  vextractf128 xmm0,ymm0,1;
  vextractf128 xmm1,ymm1,1;
  vextractf128 xmm2,ymm2,1;
  vextractf128 xmm3,ymm3,1;
  vextractf128 xmm4,ymm4,1;
  vextractf128 xmm5,ymm5,1;
  sub r15d,1;
  jnz @loop1;
  add r10,32;
  sub rdx,8;
  jz  @ende;
  cmp rdx,8;
  jae @Loop;

align 16;
 @rest:
  vmovd xmm0,dword ptr [rcx+r10];  //Feld1
  vmovd xmm1,dword ptr [r8 +r10];  //Feld2
  vmovd xmm2,dword ptr [r12+r10];  //Feld3
  vmovd xmm3,dword ptr [r11+r10];  //Feld4
  vmovd xmm4,dword ptr [r9 +r10];  //feld5
  vinsertps xmm7,xmm7,xmm0,00000000b;
  vinsertps xmm7,xmm7,xmm1,00010000b;
  vinsertps xmm7,xmm7,xmm2,00100000b;
  vinsertps xmm7,xmm7,xmm3,00110000b;
  vinsertps xmm8,xmm8,xmm4,00000000b;
  vinsertps xmm8,xmm8,xmm6,00010000b;
  vinsertps xmm8,xmm8,xmm6,00100000b;
  vinsertps xmm8,xmm8,xmm6,00110000b;
  vinsertf128 ymm7,ymm7,xmm8,1;
  vmovups  ymmword ptr [r13],ymm7;
  add r13,32;
  add r10,4;
  sub rdx,1;
  jnz @rest;

align 16;
 @ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  vmovdqu ymm7,ymmword ptr [rsp+32];
  vmovdqu ymm8,ymmword ptr [rsp+64];
  add rsp,96;
 {$ENDIF}
  vzeroupper;
  pop r15;
  pop r14;
  pop r13;
  pop r12;
end;


function ArrayToT8Single (const Feld :array of Single;
                          out   Res  :array of T8Single; Flag :Boolean):Longbool;
                              assembler;
 asm
  push r12;
 {$IFNDEF WIN64}
  mov r12,r8;             // Flag
  mov rcx,rdi;            // adress Feld
  mov rdx,rsi;            // length Feld
  mov r8, rdx;            // adress Res
  mov r9, rcx;            // lenght Res
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Flag];
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;           // value < 0 not valid
  js   @ende;
  test r9,r9;
  js   @ende;
  add  rdx,1;
  add  r9,1;
  shl  r9,3;              // * 8
  cmp  rdx,r9;            // length Feld = Length Res;
  je   @Ok;
  jg   @ende;             // Feld > Res
  mov  r10,r9;
  sub  r10,rdx;
  cmp  r10,8;             // when diff >= error res is to long
  jge  @ende;
 @ok:
  mov  rax,1;
  xor  r11,r11;
  vxorps ymm1,ymm1,ymm1;   // set 0
  cmp  r12b,1;             // test Flag
  jne  @1;
  vpcmpeqw xmm1,xmm1,xmm1;
  vpslld   xmm1,xmm1,25;
  vpsrld   xmm1,xmm1,2;       // set 1.0 on all places
  vinsertf128 ymm1,ymm1,xmm1,1;
 @1:
  cmp  rdx,8;                // when Feld < 8
  jl   @rest;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr [rcx+r11];
  vmovups ymmword ptr [r8+r11],ymm0;
  add  r11,32;
  sub  rdx,8;
  jz   @ende;
  cmp  rdx,8;
  jge  @Loop;
align 16;
 @rest:
  vmovups ymmword ptr [r8+r11],ymm1;   // fill 0 or 1 in mem
align 16;
 @rest0:
  vmovd xmm0,dword ptr [rcx+r11];
  vmovd dword ptr [r8+r11],xmm0;
  add  r11,4;
  sub  rdx,1;
  jnz  @rest0;
  vzeroupper;

 @ende:
  pop r12;
end;

function Array4ToT4Double (const Feld1,Feld2,Feld3,Feld4 :array of Double;
                             out Res :array of T4Double):Longbool;assembler;
 asm
  push r12;
  push r13;
 {$IFNDEF WIN64}
  mov  r12,r8;             // adress Feld3
  mov  r13,r9;             // lenght Feld3
  mov  rcx,rdi;            // adress Feld1
  mov  rdx,rsi;            // length feld1
  mov  r8, rdx;            // adress Feld2
  mov  r9, rcx;            // length feld2
 {$ENDIF}
 {$IFDEF WIN64}
  mov  r12,qword ptr [Feld3];
  mov  r13,qword ptr [Feld3+8];
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                 // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;                  // length Feld1 = Length Feld2;
  jne  @ende;
  cmp  rdx,r13;                 // length Feld1 = Length Feld3;
  jne  @ende;
  mov  r10,qword ptr [Feld4+8]; // lenght Feld1 = lenght Feld4
  cmp  rdx,r10;
  jne  @ende;
  mov  r10,qword ptr [Res+8];
  cmp  rdx,r10;                 // length Res with Feld1
  jne  @ende;

  mov  rax,1;                   // true
  mov  r9,qword ptr [Feld4];
  mov  r13,qword ptr [Res];
  xor  r10,r10;
  add  rdx,1;
  cmp  rdx,4;
  jb   @rest

align 16;
 @Loop:
  mov r11,2;
  vmovupd ymm0,ymmword ptr [rcx+r10];  //Feld1
  vmovupd ymm1,ymmword ptr [r8 +r10];  //Feld2
  vmovupd ymm2,ymmword ptr [r12+r10];  //Feld3
  vmovupd ymm3,ymmword ptr [r9 +r10];  //Feld4

align 16;
 @1:
  vmovq   xmm4,xmm0;
  vshufpd xmm4,xmm4,xmm1,0;
  vmovq   xmm5,xmm2;
  vshufpd xmm5,xmm5,xmm3,0;
  vinsertf128 ymm4,ymm4,xmm5,1;
  vmovupd ymmword ptr [r13],ymm4;
  add r13,32;
  vshufpd xmm4,xmm0,xmm0,00000001b;
  vshufpd xmm4,xmm4,xmm1,00000010b;
  vshufpd xmm5,xmm2,xmm2,00000001b;
  vshufpd xmm5,xmm5,xmm3,00000010b;
  vinsertf128 ymm4,ymm4,xmm5,1;
  vmovupd ymmword ptr [r13],ymm4;
  add r13,32;
  vextractf128 xmm0,ymm0,1;
  vextractf128 xmm1,ymm1,1;
  vextractf128 xmm2,ymm2,1;
  vextractf128 xmm3,ymm3,1;
  sub r11,1;
  jnz @1;
  add r10,32;
  sub rdx,4;
  jz  @ende;
  cmp rdx,4;
  jae @Loop;

align 16;
 @rest:
  vmovsd xmm0,[rcx+r10];
  vmovsd xmm1,[r8+r10];
  vmovsd xmm2,[r12+r10];
  vmovsd xmm3,[r9+r10];
  vmovsd  xmm4,xmm4,xmm0;
  vshufpd xmm4,xmm4,xmm1,00000000b;
  vmovsd  xmm5,xmm5,xmm2;
  vshufpd xmm5,xmm5,xmm3,00000000b;
  vinsertf128 ymm4,ymm4,xmm5,1;
  vmovupd ymmword ptr [r13],ymm4;
  add r13,32;
  add r10,8;
  sub rdx,1;
  jnz @Rest;

align 16;
 @ende:
  vzeroupper;
  pop r13;
  pop r12;
end;

function Array3ToT4Double (const Feld1,Feld2,Feld3 :array of Double;
                             out Res :array of T4Double;
                             Flag: Boolean):Longbool;assembler;
 asm
  push r12;
  push r13;
 {$IFNDEF WIN64}
  mov  r12,r8;             // adress Feld3
  mov  r13,r9;             // lenght Feld3
  mov  rcx,rdi;            // adress Feld1
  mov  rdx,rsi;            // length feld1
  mov  r8, rdx;            // adress Feld2
  mov  r9, rcx;            // length feld2
 {$ENDIF}
 {$IFDEF WIN64}
  mov  r12,qword ptr [Feld3];
  mov  r13,qword ptr [Feld3+8];
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                 // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;                  // length Feld1 = Length Feld2;
  jne  @ende;
  cmp  rdx,r13;                 // length Feld1 = Length Feld3;
  jne  @ende;
  mov  r10,qword ptr [Res+8];
  cmp  rdx,r10;                 // length Res with Feld1
  jne  @ende;

  mov  rax,1;                   // true
  movsx r10d,byte ptr [Flag];
  vpxor xmm3,xmm3,xmm3;
  cmp  r10d,1;
  jne  @1;
  vpcmpeqw xmm3,xmm3,xmm3;
  vpsllq   xmm3,xmm3,54;
  vpsrlq   xmm3,xmm3,2;             // set 1.0
 @1:
  mov  r13,qword ptr [Res];
  xor  r10,r10;
  add  rdx,1;
  cmp  rdx,4;
  jb   @rest

align 16;
 @Loop:
  mov r11,2;
  vmovupd ymm0,ymmword ptr [rcx+r10];  //Feld1
  vmovupd ymm1,ymmword ptr [r8 +r10];  //Feld2
  vmovupd ymm2,ymmword ptr [r12+r10];  //Feld3

align 16;
 @2:
  vmovq   xmm4,xmm0;
  vshufpd xmm4,xmm4,xmm1,0;
  vmovq   xmm5,xmm2;
  vshufpd xmm5,xmm5,xmm3,0;
  vinsertf128 ymm4,ymm4,xmm5,1;
  vmovupd ymmword ptr [r13],ymm4;
  add r13,32;
  vshufpd xmm4,xmm0,xmm0,00000001b;
  vshufpd xmm4,xmm4,xmm1,00000010b;
  vshufpd xmm5,xmm2,xmm2,00000001b;
  vshufpd xmm5,xmm5,xmm3,00000010b;
  vinsertf128 ymm4,ymm4,xmm5,1;
  vmovupd ymmword ptr [r13],ymm4;
  add r13,32;
  vextractf128 xmm0,ymm0,1;
  vextractf128 xmm1,ymm1,1;
  vextractf128 xmm2,ymm2,1;
  sub r11,1;
  jnz @2;
  add r10,32;
  sub rdx,4;
  jz  @ende;
  cmp rdx,4;
  jae @Loop;

align 16;
 @rest:
  vmovsd xmm0,[rcx+r10];
  vmovsd xmm1,[r8+r10];
  vmovsd xmm2,[r12+r10];
  vmovsd  xmm4,xmm4,xmm0;
  vshufpd xmm4,xmm4,xmm1,00000000b;
  vmovsd  xmm5,xmm5,xmm2;
  vshufpd xmm5,xmm5,xmm3,00000000b;
  vinsertf128 ymm4,ymm4,xmm5,1;
  vmovupd ymmword ptr [r13],ymm4;
  add r13,32;
  add r10,8;
  sub rdx,1;
  jnz @Rest;

align 16;
 @ende:
  vzeroupper;
  pop r13;
  pop r12;
end;

function ArrayToT4Double (const Feld :array of Double;
                            out Res :array of T4Double; Flag :Boolean):Longbool;
                              assembler;
 asm
  push r12;
 {$IFNDEF WIN64}
  movsx r12d,r8d;             //Flag
  mov rcx,rdi;            // adress Feld
  mov rdx,rsi;            // length feld
  mov r8, rdx;            // adress Res
  mov r9, rcx;            // length
 {$ENDIF}
 {$IFDEF WIN64}
  movsx r12d,byte ptr [Flag];
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;           // value < 0 not valid
  js   @ende;
  test r9,r9;
  js   @ende;
  add  rdx,1;
  add  r9,1;
  shl  r9,2;               // * 4
  cmp  rdx,r9;
  je   @ok;
  jg   @ende;             // Feld > Res
  mov r10,r9;
  sub r10,rdx;
  cmp r10,4;             // when diff >= error res is to long
  jge @ende;
 @ok:
  mov rax,1;
  xor r11,r11;
  vxorpd ymm1,ymm1,ymm1;  // set 0
  cmp r12b,1;           // flag = True fill value 1
  jne  @1;
  vpcmpeqw xmm1,xmm1,xmm1;
  vpsllq   xmm1,xmm1,54;
  vpsrlq   xmm1,xmm1,2;       // set 1.0 on all places
  vinsertf128 ymm1,ymm1,xmm1,1;
 @1:
  cmp rdx,4;
  jb  @rest;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr [rcx+r11];
  vmovupd ymmword ptr [r8+r11],ymm0;
  add r11,32;
  sub rdx,4;
  jz  @ende;
  cmp rdx,4;
  jae @Loop;

 @rest:
  vmovupd ymmword ptr [r8+r11],ymm1;  //set o or 1
 @rest0:
  movsd xmm0,qword ptr [rcx+r11];
  movsd qword ptr [r8+r11],xmm0;
  add r11,8;
  sub rdx,1;
  jnz @rest0;
  vzeroupper;

 @ende:
  pop r12;
end;

{-------------------------convert array in rows direction---------------------}


function T8SingleYToSingle (const Feld :array of T8Single;
                             out Res :array of Single):Longbool;
                               assembler;nostackframe;
 asm
  {$IFNDEF WIN64}
  mov rcx,rdi;            // adress Feld
  mov rdx,rsi;            // length Feld
  mov r8, rdx;            // adress Res
  mov r9, rcx;            // length Res
  {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;           // value < 0 not valid
  js   @ende;
  test r9,r9;
  js   @ende;
  add  r9,1;
  shr  r9,3;              // div 8
  add  rdx,1;
  cmp  rdx,r9;            // length Feld = Length Res1;
  jne  @ende;
  mov  rax,1;             //true
  xor  r10,r10;
align 16;
 @Loop:
  vmovups ymm0,ymmword ptr [rcx+r10];
  vmovups ymmword ptr [r8+r10],ymm0;
  add r10,32;
  sub rdx,1;
  jnz @Loop;
 @ende:
 vzeroupper;
end;


function T8SingleYTo8Single (const Feld :array of T8Single;
                            out Res1,Res2,Res3,Res4,Res5,Res6,
                                Res7,Res8 :array of Single):Longbool;assembler;
 asm
  push r12;
  push r13;
  push r14;
  push r15;
  push rbx;
 {$IFNDEF WIN64}
  mov r12,r8;             // adress Res2
  mov r13,r9;             // lenght Res2
  mov rcx,rdi;            // adress Feld
  mov rdx,rsi;            // length Feld
  mov r8, rdx;            // adress Res1
  mov r9, rcx;            // lenght Res1
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Res2];
  mov r13,qword ptr [Res2+8];
  sub rsp,128;
  vmovdqu ymmword ptr [rsp],ymm6;
  vmovdqu ymmword ptr [rsp+32],ymm7;
  vmovdqu ymmword ptr [rsp+64],ymm8;
  vmovdqu ymmword ptr [rsp+96],ymm9;
 {$ENDIF}
  xor  rax,rax;                    // set result = false
  test rdx,rdx;
  js   @ende;                      // not neg length
  cmp  rdx,r9;                     // length Feld = Length Res1;
  jne  @ende;
  cmp  rdx,r13;                    // lenght Feld = lenght Res2
  jne  @ende;
  mov r10,qword ptr [Res3+8];      // lenght Feld = lenght Res3
  cmp rdx,r10;
  jne @ende;
  mov r10,qword ptr [Res4+8];      // lenght Feld = lenght Res4
  cmp rdx,r10;
  jne @ende;
  mov r10,qword ptr [Res5+8];      // lenght Feld = lenght Res5
  cmp rdx,r10;
  jne @ende;
  mov r10,qword ptr [Res6+8];      // lenght Feld = lenght Res6
  cmp rdx,r10;
  jne @ende;
  mov r10,qword ptr [Res7+8];      // lenght Feld = lenght Res7
  cmp rdx,r10;
  jne @ende;
  mov r10,qword ptr [Res8+8];       // length Feld = length Res8
  cmp rdx,r10;
  jne @ende;
  mov rax,1;
  mov r9, qword ptr [Res3];
  mov r11,qword ptr [Res4];
  mov r13,qword ptr [Res5];
  mov r14,qword ptr [Res6];
  mov r15,qword ptr [Res7];
  mov rbx,qword ptr [Res8];
  add rdx,1;
  xor r10,r10;
  cmp rdx,4;              // when < 4 work with movss
  jb  @rest;

align 16;
 @Loop:
  vmovups   ymm0,ymmword ptr [rcx];
  add rcx,32;
  vinsertps xmm1,xmm1,xmm0,00000000b;
  vinsertps xmm2,xmm2,xmm0,01000000b;
  vinsertps xmm3,xmm3,xmm0,10000000b;
  vinsertps xmm4,xmm4,xmm0,11000000b;
  vextractf128 xmm9,ymm0,1;
  vinsertps xmm5,xmm5,xmm9,00000000b;
  vinsertps xmm6,xmm6,xmm9,01000000b;
  vinsertps xmm7,xmm7,xmm9,10000000b;
  vinsertps xmm8,xmm8,xmm9,11000000b;

  vmovups   ymm0,ymmword ptr [rcx];
  add rcx,32;
  vinsertps xmm1,xmm1,xmm0,00010000b;
  vinsertps xmm2,xmm2,xmm0,01010000b;
  vinsertps xmm3,xmm3,xmm0,10010000b;
  vinsertps xmm4,xmm4,xmm0,11010000b;
  vextractf128 xmm9,ymm0,1;
  vinsertps xmm5,xmm5,xmm9,00010000b;
  vinsertps xmm6,xmm6,xmm9,01010000b;
  vinsertps xmm7,xmm7,xmm9,10010000b;
  vinsertps xmm8,xmm8,xmm9,11010000b;

  vmovups   ymm0,ymmword ptr [rcx];
  add rcx,32;
  vinsertps xmm1,xmm1,xmm0,00100000b;
  vinsertps xmm2,xmm2,xmm0,01100000b;
  vinsertps xmm3,xmm3,xmm0,10100000b;
  vinsertps xmm4,xmm4,xmm0,11100000b;
  vextractf128 xmm9,ymm0,1;
  vinsertps xmm5,xmm5,xmm9,00100000b;
  vinsertps xmm6,xmm6,xmm9,01100000b;
  vinsertps xmm7,xmm7,xmm9,10100000b;
  vinsertps xmm8,xmm8,xmm9,11100000b;

  vmovups   ymm0,ymmword ptr [rcx];
  add rcx,32;
  vinsertps xmm1,xmm1,xmm0,00110000b;
  vinsertps xmm2,xmm2,xmm0,01110000b;
  vinsertps xmm3,xmm3,xmm0,10110000b;
  vinsertps xmm4,xmm4,xmm0,11110000b;
  vextractf128 xmm9,ymm0,1;
  vinsertps xmm5,xmm5,xmm9,00110000b;
  vinsertps xmm6,xmm6,xmm9,01110000b;
  vinsertps xmm7,xmm7,xmm9,10110000b;
  vinsertps xmm8,xmm8,xmm9,11110000b;

  vmovups xmmword ptr [r8 +r10],xmm1;  //Res1
  vmovups xmmword ptr [r12+r10],xmm2;  //Res2
  vmovups xmmword ptr [r9 +r10],xmm3;  //Res3
  vmovups xmmword ptr [r11+r10],xmm4;  //Res4
  vmovups xmmword ptr [r13+r10],xmm5;  //Res5
  vmovups xmmword ptr [r14+r10],xmm6;  //Res6
  vmovups xmmword ptr [r15+r10],xmm7;  //Res7
  vmovups xmmword ptr [rbx+r10],xmm8;  //Res8
  add r10,16;
  sub rdx,4;
  jz  @ende;
  cmp rdx,4;
  jae @Loop;

align 16;
 @rest:
  vmovups   ymm0,ymmword ptr [rcx];
  add rcx,32;
  vinsertps xmm1,xmm0,xmm0,00000000b;
  vinsertps xmm2,xmm0,xmm0,01000000b;
  vinsertps xmm3,xmm0,xmm0,10000000b;
  vinsertps xmm4,xmm0,xmm0,11000000b;
  vextractf128 xmm9,ymm0,1;
  vinsertps xmm5,xmm9,xmm9,00000000b;
  vinsertps xmm6,xmm9,xmm9,01000000b;
  vinsertps xmm7,xmm9,xmm9,10000000b;
  vinsertps xmm8,xmm9,xmm9,11000000b;
  vmovd dword ptr [r8 +r10],xmm1;  //Res1
  vmovd dword ptr [r12+r10],xmm2;  //Res2
  vmovd dword ptr [r9 +r10],xmm3;  //Res3
  vmovd dword ptr [r11+r10],xmm4;  //Res4
  vmovd dword ptr [r13+r10],xmm5;  //Res5
  vmovd dword ptr [r14+r10],xmm6;  //Res6
  vmovd dword ptr [r15+r10],xmm7;  //Res7
  vmovd dword ptr [rbx+r10],xmm8;  //Res8
  add r10,4;
  sub rdx,1;
  jnz @rest;

align 16;
 @ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  vmovdqu ymm7,ymmword ptr [rsp+32];
  vmovdqu ymm8,ymmword ptr [rsp+64];
  vmovdqu ymm9,ymmword ptr [rsp+96];
  add rsp,128;
 {$ENDIF}
  vzeroupper;
  pop rbx;
  pop r15;
  pop r14;
  pop r13;
  pop r12;
end;


function T8SingleYTo7Single (const Feld :array of T8Single;
                            out Res1,Res2,Res3,Res4,Res5,Res6,
                                Res7 :array of Single):Longbool;assembler;
 asm
  push r12;
  push r13;
  push r14;
  push r15;
 {$IFNDEF WIN64}
  mov r12,r8;             // adress Res2
  mov r13,r9;             // lenght Res2
  mov rcx,rdi;            // adress Feld
  mov rdx,rsi;            // length Feld
  mov r8, rdx;            // adress Res1
  mov r9, rcx;            // lenght Res1
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Res2];
  mov r13,qword ptr [Res2+8];
  sub rsp,128;
  vmovdqu ymmword ptr [rsp],ymm6;
  vmovdqu ymmword ptr [rsp+32],ymm7;
  vmovdqu ymmword ptr [rsp+64],ymm8;
  vmovdqu ymmword ptr [rsp+96],ymm9;
 {$ENDIF}
  xor  rax,rax;                    // set result = false
  test rdx,rdx;
  js   @ende;                      // not neg length
  cmp  rdx,r9;                     // length Feld = Length Res1;
  jne  @ende;
  cmp  rdx,r13;                    // lenght Feld = lenght Res2
  jne  @ende;
  mov r10,qword ptr [Res3+8];      // lenght Feld = lenght Res3
  cmp rdx,r10;
  jne @ende;
  mov r10,qword ptr [Res4+8];      // lenght Feld = lenght Res4
  cmp rdx,r10;
  jne @ende;
  mov r10,qword ptr [Res5+8];      // lenght Feld = lenght Res5
  cmp rdx,r10;
  jne @ende;
  mov r10,qword ptr [Res6+8];      // lenght Feld = lenght Res6
  cmp rdx,r10;
  jne @ende;
  mov r10,qword ptr [Res7+8];      // lenght Feld = lenght Res7
  cmp rdx,r10;
  jne @ende;
  mov rax,1;
  mov r9, qword ptr [Res3];
  mov r11,qword ptr [Res4];
  mov r13,qword ptr [Res5];
  mov r14,qword ptr [Res6];
  mov r15,qword ptr [Res7];
  add rdx,1;
  xor r10,r10;
  cmp rdx,4;              // when < 4 work with movss
  jb  @rest;

align 16;
 @Loop:
  vmovups   ymm0,ymmword ptr [rcx];
  add rcx,32;
  vinsertps xmm1,xmm1,xmm0,00000000b;
  vinsertps xmm2,xmm2,xmm0,01000000b;
  vinsertps xmm3,xmm3,xmm0,10000000b;
  vinsertps xmm4,xmm4,xmm0,11000000b;
  vextractf128 xmm9,ymm0,1;
  vinsertps xmm5,xmm5,xmm9,00000000b;
  vinsertps xmm6,xmm6,xmm9,01000000b;
  vinsertps xmm7,xmm7,xmm9,10000000b;

  vmovups   ymm0,ymmword ptr [rcx];
  add rcx,32;
  vinsertps xmm1,xmm1,xmm0,00010000b;
  vinsertps xmm2,xmm2,xmm0,01010000b;
  vinsertps xmm3,xmm3,xmm0,10010000b;
  vinsertps xmm4,xmm4,xmm0,11010000b;
  vextractf128 xmm9,ymm0,1;
  vinsertps xmm5,xmm5,xmm9,00010000b;
  vinsertps xmm6,xmm6,xmm9,01010000b;
  vinsertps xmm7,xmm7,xmm9,10010000b;

  vmovups   ymm0,ymmword ptr [rcx];
  add rcx,32;
  vinsertps xmm1,xmm1,xmm0,00100000b;
  vinsertps xmm2,xmm2,xmm0,01100000b;
  vinsertps xmm3,xmm3,xmm0,10100000b;
  vinsertps xmm4,xmm4,xmm0,11100000b;
  vextractf128 xmm9,ymm0,1;
  vinsertps xmm5,xmm5,xmm9,00100000b;
  vinsertps xmm6,xmm6,xmm9,01100000b;
  vinsertps xmm7,xmm7,xmm9,10100000b;

  vmovups   ymm0,ymmword ptr [rcx];
  add rcx,32;
  vinsertps xmm1,xmm1,xmm0,00110000b;
  vinsertps xmm2,xmm2,xmm0,01110000b;
  vinsertps xmm3,xmm3,xmm0,10110000b;
  vinsertps xmm4,xmm4,xmm0,11110000b;
  vextractf128 xmm9,ymm0,1;
  vinsertps xmm5,xmm5,xmm9,00110000b;
  vinsertps xmm6,xmm6,xmm9,01110000b;
  vinsertps xmm7,xmm7,xmm9,10110000b;

  vmovups xmmword ptr [r8 +r10],xmm1;  //Res1
  vmovups xmmword ptr [r12+r10],xmm2;  //Res2
  vmovups xmmword ptr [r9 +r10],xmm3;  //Res3
  vmovups xmmword ptr [r11+r10],xmm4;  //Res4
  vmovups xmmword ptr [r13+r10],xmm5;  //Res5
  vmovups xmmword ptr [r14+r10],xmm6;  //Res6
  vmovups xmmword ptr [r15+r10],xmm7;  //Res7
  add r10,16;
  sub rdx,4;
  jz  @ende;
  cmp rdx,4;
  jae @Loop;

align 16;
 @rest:
  vmovups   ymm0,ymmword ptr [rcx];
  add rcx,32;
  vinsertps xmm1,xmm1,xmm0,00000000b;
  vinsertps xmm2,xmm2,xmm0,01000000b;
  vinsertps xmm3,xmm3,xmm0,10000000b;
  vinsertps xmm4,xmm4,xmm0,11000000b;
  vextractf128 xmm9,ymm0,1;
  vinsertps xmm5,xmm5,xmm9,00000000b;
  vinsertps xmm6,xmm6,xmm9,01000000b;
  vinsertps xmm7,xmm7,xmm9,10000000b;
  vmovd dword ptr [r8 +r10],xmm1;  //Res1
  vmovd dword ptr [r12+r10],xmm2;  //Res2
  vmovd dword ptr [r9 +r10],xmm3;  //Res3
  vmovd dword ptr [r11+r10],xmm4;  //Res4
  vmovd dword ptr [r13+r10],xmm5;  //Res5
  vmovd dword ptr [r14+r10],xmm6;  //Res6
  vmovd dword ptr [r15+r10],xmm7;  //Res7
  add r10,4;
  sub rdx,1;
  jnz @rest;

align 16;
 @ende:
 {$IFDEF WIN64}
  vmovdqu ymm6,ymmword ptr [rsp];
  vmovdqu ymm7,ymmword ptr [rsp+32];
  vmovdqu ymm8,ymmword ptr [rsp+64];
  vmovdqu ymm9,ymmword ptr [rsp+96];
  add rsp,128;
 {$ENDIF}
  vzeroupper;
  pop r15;
  pop r14;
  pop r13;
  pop r12;
end;


function T8SingleYTo6Single (const Feld :array of T8Single;
         out Res1,Res2,Res3,Res4,Res5,Res6 :array of Single):Longbool;assembler;
 asm
  push r12;
  push r13;
  push r14;
  push r15;
 {$IFNDEF WIN64}
  mov r12,r8;             // adress Res2
  mov r13,r9;             // lenght res2
  mov rcx,rdi;            // adress Feld
  mov rdx,rsi;            // length Feld
  mov r8, rdx;            // adress Res1
  mov r9, rcx;            // length Res1
 {$ENDIF}
 {$IFDEF WIN64}
  mov  r12,qword ptr [Res2];
  mov  r13,qword ptr [Res2+8];
  sub rsp,64;
  vmovups ymmword ptr [rsp],ymm6;
  vmovups ymmword ptr [rsp+32],ymm7;
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                  // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;                   // length Feld = length Res1
  jne  @ende;
  cmp  rdx,r13;                  // length Feld = length Res2
  jne  @ende;
  mov  r10,qword ptr [Res3+8];   // lenght Feld = lenght Res3
  cmp  rdx,r10;
  jne  @ende;
  mov  r10,qword ptr [Res4+8];   // lenght Feld = lenght Res4
  cmp  rdx,r10;
  jne  @ende;
  mov  r10,qword ptr [Res4+8];   // lenght Feld = lenght Res5
  cmp  rdx,r10;
  jne  @ende;
  mov  r10,qword ptr [Res4+8];   // lenght Feld = lenght Res6
  cmp  rdx,r10;
  jne  @ende;

  mov  rax,1;
  mov  r9, qword ptr [Res3];
  mov  r13,qword ptr [Res4];
  mov  r14,qword ptr [Res5];
  mov  r15,qword ptr [Res6];
  xor  r10,r10;
  xor  r11,r11;
  add  rdx,1;
  cmp  rdx,4;
  jb   @rest;

align 16;
 @Loop:
  vmovups   ymm0,ymmword ptr [rcx];        //Feld
  add rcx,32;
  vinsertps xmm1,xmm1,xmm0,00000000b;
  vinsertps xmm2,xmm2,xmm0,01000000b;
  vinsertps xmm3,xmm3,xmm0,10000000b;
  vinsertps xmm4,xmm4,xmm0,11000000b;
  vextractf128 xmm7,ymm0,1;
  vinsertps xmm5,xmm5,xmm7,00000000b;
  vinsertps xmm6,xmm6,xmm7,01000000b;

  vmovups   ymm0,ymmword ptr [rcx];
  add rcx,32;
  vinsertps xmm1,xmm1,xmm0,00010000b;
  vinsertps xmm2,xmm2,xmm0,01010000b;
  vinsertps xmm3,xmm3,xmm0,10010000b;
  vinsertps xmm4,xmm4,xmm0,11010000b;
  vextractf128 xmm7,ymm0,1;
  vinsertps xmm5,xmm5,xmm7,00010000b;
  vinsertps xmm6,xmm6,xmm7,01010000b;

  vmovups   ymm0,ymmword ptr [rcx];
  add rcx,32
  vinsertps xmm1,xmm1,xmm0,00100000b;
  vinsertps xmm2,xmm2,xmm0,01100000b;
  vinsertps xmm3,xmm3,xmm0,10100000b;
  vinsertps xmm4,xmm4,xmm0,11100000b;
  vextractf128 xmm7,ymm0,1;
  vinsertps xmm5,xmm5,xmm7,00100000b;
  vinsertps xmm6,xmm6,xmm7,01100000b;

  vmovups   ymm0,ymmword ptr [rcx];
  add rcx,32;
  vinsertps xmm1,xmm1,xmm0,00110000b;
  vinsertps xmm2,xmm2,xmm0,01110000b;
  vinsertps xmm3,xmm3,xmm0,10110000b;
  vinsertps xmm4,xmm4,xmm0,11110000b;
  vextractf128 xmm7,ymm0,1;
  vinsertps xmm5,xmm5,xmm7,00110000b;
  vinsertps xmm6,xmm6,xmm7,01110000b;

  vmovups xmmword ptr [r8+r10], xmm1;
  vmovups xmmword ptr [r12+r10],xmm2;
  vmovups xmmword ptr [r9+r10], xmm3;
  vmovups xmmword ptr [r13+r10],xmm4;
  vmovups xmmword ptr [r14+r10],xmm5;
  vmovups xmmword ptr [r15+r10],xmm6;

  add r10,16;
  add r11,32;
  sub rdx,4;
  jz  @ende;
  cmp rdx,4;
  jae @Loop;

align 16;
 @rest:
  vmovups   ymm0,ymmword ptr [rcx];
  add rcx,32;
  vinsertps xmm1,xmm1,xmm0,00000000b;
  vinsertps xmm2,xmm2,xmm0,01000000b;
  vinsertps xmm3,xmm3,xmm0,10000000b;
  vinsertps xmm4,xmm4,xmm0,11000000b;
  vextractf128 xmm7,ymm0,1;
  vinsertps xmm5,xmm5,xmm7,00000000b;
  vinsertps xmm6,xmm6,xmm7,01000000b;
  vmovd dword ptr [r8+r10], xmm1;
  vmovd dword ptr [r12+r10],xmm2;
  vmovd dword ptr [r9+r10], xmm3;
  vmovd dword ptr [r13+r10],xmm4;
  vmovd dword ptr [r14+r10],xmm5;
  vmovd dword ptr [r15+r10],xmm6;
  add r10,4;
  sub rdx,1;
  jnz @rest;

 @ende:
 {$IFDEF WIN64}
  vmovups ymm6,ymmword ptr [rsp];
  vmovups ymm7,ymmword ptr [rsp+32];
  add rsp,64;
 {$ENDIF}
  vzeroupper;
  pop r15;
  pop r14;
  pop r13;
  pop r12;
end;

function T8SingleYTo5Single (const Feld :array of T8Single;
         out Res1,Res2,Res3,Res4,Res5 :array of Single):Longbool;assembler;
 asm
  push r12;
  push r13;
  push r14;
 {$IFNDEF WIN64}
  mov r12,r8;             // adress Res2
  mov r13,r9;             // lenght res2
  mov rcx,rdi;            // adress Feld
  mov rdx,rsi;            // length Feld
  mov r8, rdx;            // adress Res1
  mov r9, rcx;            // length Res1
 {$ENDIF}
 {$IFDEF WIN64}
  mov  r12,qword ptr [Res2];
  mov  r13,qword ptr [Res2+8];
  sub rsp,64;
  vmovups ymmword ptr [rsp],ymm6;
  vmovups ymmword ptr [rsp+32],ymm7;
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                  // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;                   // length Feld = length Res1
  jne  @ende;
  cmp  rdx,r13;                  // length Feld = length Res2
  jne  @ende;
  mov  r10,qword ptr [Res3+8];   // lenght Feld = lenght Res3
  cmp  rdx,r10;
  jne  @ende;
  mov  r10,qword ptr [Res4+8];   // lenght Feld = lenght Res4
  cmp  rdx,r10;
  jne  @ende;
  mov  r10,qword ptr [Res4+8];   // lenght Feld = lenght Res5
  cmp  rdx,r10;
  jne  @ende;

  mov  rax,1;
  mov  r9, qword ptr [Res3];
  mov  r13,qword ptr [Res4];
  mov  r14,qword ptr [Res5];
  xor  r10,r10;
  xor  r11,r11;
  add  rdx,1;
  cmp  rdx,4;
  jb   @rest;

align 16;
 @Loop:
  vmovups   ymm0,ymmword ptr [rcx];        //Feld
  add rcx,32;
  vinsertps xmm1,xmm1,xmm0,00000000b;
  vinsertps xmm2,xmm2,xmm0,01000000b;
  vinsertps xmm3,xmm3,xmm0,10000000b;
  vinsertps xmm4,xmm4,xmm0,11000000b;
  vextractf128 xmm7,ymm0,1;
  vinsertps xmm5,xmm5,xmm7,00000000b;

  vmovups   ymm0,ymmword ptr [rcx];
  add rcx,32;
  vinsertps xmm1,xmm1,xmm0,00010000b;
  vinsertps xmm2,xmm2,xmm0,01010000b;
  vinsertps xmm3,xmm3,xmm0,10010000b;
  vinsertps xmm4,xmm4,xmm0,11010000b;
  vextractf128 xmm7,ymm0,1;
  vinsertps xmm5,xmm5,xmm7,00010000b;

  vmovups   ymm0,ymmword ptr [rcx];
  add rcx,32;
  vinsertps xmm1,xmm1,xmm0,00100000b;
  vinsertps xmm2,xmm2,xmm0,01100000b;
  vinsertps xmm3,xmm3,xmm0,10100000b;
  vinsertps xmm4,xmm4,xmm0,11100000b;
  vextractf128 xmm7,ymm0,1;
  vinsertps xmm5,xmm5,xmm7,00100000b;

  vmovups   ymm0,ymmword ptr [rcx];
  add rcx,32;
  vinsertps xmm1,xmm1,xmm0,00110000b;
  vinsertps xmm2,xmm2,xmm0,01110000b;
  vinsertps xmm3,xmm3,xmm0,10110000b;
  vinsertps xmm4,xmm4,xmm0,11110000b;
  vextractf128 xmm7,ymm0,1;
  vinsertps xmm5,xmm5,xmm7,00110000b;

  vmovups xmmword ptr [r8+r10], xmm1;
  vmovups xmmword ptr [r12+r10],xmm2;
  vmovups xmmword ptr [r9+r10], xmm3;
  vmovups xmmword ptr [r13+r10],xmm4;
  vmovups xmmword ptr [r14+r10],xmm5;
  add r10,16;
  sub rdx,4;
  jz  @ende;
  cmp rdx,4;
  jae @Loop;

align 16;
 @rest:
  vmovups   ymm0,ymmword ptr [rcx];
  add rcx,32;
  vinsertps xmm1,xmm1,xmm0,00000000b;
  vinsertps xmm2,xmm2,xmm0,01000000b;
  vinsertps xmm3,xmm3,xmm0,10000000b;
  vinsertps xmm4,xmm4,xmm0,11000000b;
  vextractf128 xmm7,ymm0,1;
  vinsertps xmm5,xmm5,xmm7,00000000b;
  vmovd dword ptr [r8+r10], xmm1;
  vmovd dword ptr [r12+r10],xmm2;
  vmovd dword ptr [r9+r10], xmm3;
  vmovd dword ptr [r13+r10],xmm4;
  vmovd dword ptr [r14+r10],xmm5;
  add r10,4;
  sub rdx,1;
  jnz @rest;

 @ende:
 {$IFDEF WIN64}
  vmovups ymm6,ymmword ptr [rsp];
  vmovups ymm7,ymmword ptr [rsp+32];
  add rsp,64;
 {$ENDIF}
  vzeroupper;
  pop r14;
  pop r13;
  pop r12;
end;


function T4DoubleTo4Double (const Feld :array of T4Double;
                              out Res1,Res2,Res3,Res4 :array of Double):Longbool;
                             assembler;
 asm
  push r12;
  push r13;
  push r14;
 {$IFNDEF WIN64}
  mov r12,r8;             // adress Res2
  mov r13,r9;             // lenght Res2
  mov rcx,rdi;            // adress Feld
  mov rdx,rsi;            // length Feld
  mov r8, rdx;            // adress Res1
  mov r9, rcx;            // length Res1
 {$ENDIF}
  xor  rax,rax
  cmp  rdx,r9;
  jne  @ende;
 {$IFDEF WIN64}
  mov  r12,qword ptr [Res2];
  mov  r13,qword ptr [Res2+8];
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;                      // lenght Feld = lenght Res1
  jne  @ende;
  cmp  rdx,r13;                     // length Feld = length Res2;
  jne  @ende;
  mov  r10,qword ptr [Res3+8];      // lenght Feld = lenght Res3
  cmp  rdx,r10;
  jne  @ende;
  mov  r10,qword ptr [Res4+8];      // lenght Feld = lenght Res4
  cmp  rdx,r10;
  jne  @ende;
  mov  rax,1;
  mov  r13,qword ptr [Res3];
  mov  r14,qword ptr [Res4];
  xor  r10,r10;
  add  rdx,1;
  cmp  rdx,2;
  jb   @rest;

align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr [rcx];   //Feld
  add rcx,32;
  vshufpd xmm1,xmm0,xmm0,00000000b;
  vshufpd xmm2,xmm0,xmm0,00000001b;
  vextractf128 xmm0,ymm0,1;
  vshufpd xmm3,xmm0,xmm0,00000000b;
  vshufpd xmm4,xmm0,xmm0,00000001b;

  vmovupd ymm0,ymmword ptr [rcx];
  add rcx,32;
  vshufpd xmm1,xmm1,xmm0,00000000b;
  vshufpd xmm2,xmm2,xmm0,00000010b;
  vextractf128 xmm0,ymm0,1;
  vshufpd xmm3,xmm3,xmm0,00000000b;
  vshufpd xmm4,xmm4,xmm0,00000010b;
  vmovupd xmmword ptr [r8+r10], xmm1;   //Res1
  vmovupd xmmword ptr [r12+r10],xmm2;   //res2
  vmovupd xmmword ptr [r13+r10],xmm3;   //Res3
  vmovupd xmmword ptr [r14+r10],xmm4;   //Res4
  add r10,16;
  sub rdx,2;
  jz  @ende;
  cmp rdx,2;
  jae @Loop;

align 16;
 @rest:
  vmovupd ymm0,ymmword ptr [rcx];
  add rdx,32;
  vshufpd xmm1,xmm0,xmm0,00000000b;
  vshufpd xmm2,xmm0,xmm0,00000011b
  vextractf128 xmm0,ymm0,1;
  vshufpd xmm3,xmm0,xmm0,00000000b;
  vshufpd xmm4,xmm0,xmm0,00000011b
  vmovsd [r8+r10], xmm1;
  vmovsd [r12+r10],xmm2;
  vmovsd [r13+r10],xmm3;
  vmovsd [r14+r10],xmm4;
  add r10,8;
  sub rdx,1;
  jnz @Loop;

 @ende:
  vzeroupper;
  pop r14;
  pop r13;
  pop r12;
end;


function T4DoubleTo3Double (const Feld :array of T4Double;
                             out Res1,Res2,Res3 :array of Double):Longbool;assembler;
 asm
  push r12;
  push r13;
 {$IFNDEF WIN64}
  mov r12,r8;             // adress Res2
  mov r13,r9;             // lenght Res2
  mov rcx,rdi;            // adress Feld
  mov rdx,rsi;            // length Feld
  mov r8, rdx;            // adress Res1
  mov r9, rcx;            // length Res1
 {$ENDIF}
 {$IFDEF WIN64}
  mov r12,qword ptr [Res2];
  mov r13,qword ptr [Res2+8];      // lenght Feld =  lenght Res2
 {$ENDIF}
  xor  rax,rax;
  test rdx,rdx;                     // value < 0 not valid
  js   @ende;
  cmp  rdx,r9;
  jne  @ende;
  cmp  rdx,r13;
  jne  @ende;
  mov  r10,qword ptr [Res3+8];
  cmp  rdx,r10;
  jne  @ende;
  mov  r9,qword ptr [Res3];

  mov  rax,1;
  xor  r10,r10;
  mov  r11,4;
  add  rdx,1;
  cmp  rdx,4;
  jb   @rest;

align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr [rcx];
  add rcx,32;
  vshufpd xmm1,xmm0,xmm0,0;
  vshufpd xmm2,xmm0,xmm0,1;
  vextractf128 xmm0,ymm0,1;
  vshufpd xmm3,xmm0,xmm0,0;

  vmovupd ymm0,ymmword ptr [rcx];
  add rcx,32;
  vshufpd xmm1,xmm1,xmm0,00000000b;
  vshufpd xmm2,xmm2,xmm0,00000010b;
  vextractf128 xmm0,ymm0,1;
  vshufpd xmm3,xmm3,xmm0,00000000b;

  vmovupd xmmword ptr [r8+r10], xmm1;
  vmovupd xmmword ptr [r12+r10],xmm2;
  vmovupd xmmword ptr [r9+r10], xmm3;
  add r10,16;
  sub rdx,4;
  jz  @ende;
  cmp rdx,4;
  jae @Loop;

align 16;
 @rest:
  vmovupd ymm0,ymmword ptr [rcx];
  add rcx,32;
  vshufpd xmm1,xmm0,xmm0,00000000b;
  vshufpd xmm2,xmm0,xmm0,00000001b;
  vextractf128 xmm0,ymm0,1;
  vshufpd xmm3,xmm0,xmm0,00000000b;
  vmovq qword ptr [r8 +r10],xmm1;
  vmovq qword ptr [r12+r10],xmm2;
  vmovq qword ptr [r9 +r10],xmm3;
  add r10,8;
  sub rdx,1;
  jnz @rest;

 @ende:
  vzeroupper;
  pop r13;
  pop r12;
end;


function T4DoubleToDouble (const Feld :array of T4Double;
                             out Res :array of Double):Longbool;
                                assembler;nostackframe;
 asm
 {$IFNDEF WIN64}
  mov rcx,rdi;            // adress Feld
  mov rdx,rsi;            // length Feld
  mov r8, rdx;            // adress Res1
  mov r9, rcx;            // length Res1
 {$ENDIF}
  xor  rax,rax
  test rdx,rdx;           // value < 0 not valid
  js   @ende;
  add  rdx,1;
  test r9,r9;
  js   @ende;
  add  r9,1;
  shr  r9,2;
  cmp  rdx,r9;
  jne  @ende;
  mov  rax,1;
  xor  r10,r10;
align 16;
 @Loop:
  vmovupd ymm0,ymmword ptr [rcx+r10];   //Feld
  vmovupd ymmword ptr [r8+r10],ymm0;
  add r10,32;
  sub rdx,1;
  jnz @Loop;
 @ende:
  vzeroupper;
end;

{$ENDIF SIMD256}
{$ENDIF CPUX86_64}

{$UNDEF SIMD256}

end.


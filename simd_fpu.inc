{include simd_fpu}

{ This include is part of the unit xmmfloat,xmmint and ymmfloat.

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

{Remark: register r10d is loop counter
}

{give the exponent as float}
procedure FN_EXTR_SINGLE;assembler;nostackframe;
 asm
  push rax;
  mov  rax,16;
align 16;
 @Loop:
  fld  dword ptr [rsp+rax];
  fxtract;
  fstp st;
  fstp dword ptr [rsp+rax];
  add rax,4;
  sub r10d,1;
  jnz @Loop;
  pop rax;
end;

procedure FN_EXTR_DOUBLE; assembler;nostackframe;
 asm
  push rax;
  mov  rax,16;
align 16;
 @Loop:
  fld  qword ptr [rsp+rax];
  fxtract;
  fstp st;
  fstp qword ptr [rsp+rax];
  add  rax,8;
  sub  r10d,1;
  jnz  @Loop;
  pop  rax;
end;

{calculate LN(x)}
procedure FN_LN_SINGLE;assembler;nostackframe;
 asm
  push rax;
  mov  rax,32;
  sub  rsp,16;
align 16;
 @Loop:
  fldln2;
  fld  dword ptr [rsp+rax];
  fld st;
  fstp tbyte ptr [rsp];
  fwait;
  cmp  word ptr [rsp+8],$3FFF;  // Exponent = 1?
  je   @1;
  fyl2x;
  fstp dword ptr [rsp+rax];
  add  rax,4;
  sub  r10d,1;
  jnz  @Loop;
  jz   @ende;
align 16;
 @1:
  cmp word ptr [rsp],$8000;  // mantisse = 1.0000 or lower?
  jne  @2;
  fld1;
  fsubp st(1),st;           //subtract the 1.0
  fyl2xp1;
  fstp dword ptr [rsp+rax];
  add  rax,4;
  sub  r10d,1;
  jnz  @Loop;
  jz   @ende;
align 16;
 @2:
  fyl2x;
  fstp dword ptr [rsp+rax];
  add  rax,4;
  sub  r10d,1;
  jnz  @Loop;
align 16;
 @ende:
  add rsp,16;
  pop rax;
end;


procedure FN_LN_DOUBLE;assembler;nostackframe;
 asm
  push rax;
  mov  rax,32;
  sub  rsp,16;
align 16;
 @Loop:
  fldln2;
  fld  qword ptr [rsp+rax];
  fld st;
  fstp tbyte ptr [rsp];
  fwait;
  cmp  word ptr [rsp+8],$3FFF;   // exponent = 1?
  je   @1;
  fyl2x;
  fstp qword ptr [rsp+rax];
  add  rax,8;
  sub  r10d,1;
  jnz  @Loop;
  jz   @ende;
align 16;
 @1:
  cmp word ptr [rsp+6],$8000;  // is mantissa = 1.0000 or lower?
  jne @2;
  fld1;
  fsubp st(1),st;
  fyl2xp1;
  fstp qword ptr [rsp+rax];
  add  rax,8;
  sub  r10d,1;
  jnz  @Loop;
  jz   @ende;
align 16;
 @2:
  fyl2x;
  fstp qword ptr [rsp+rax];
  add  rax,8;
  sub  r10d,1;
  jnz  @Loop;
align 16;
 @ende:
  add rsp,16;
  pop rax;
end;

{calculate log(x)}
procedure FN_LOG_SINGLE;assembler;nostackframe;
 asm
  push rax;
  mov  rax,32;
  sub  rsp,16;
align 16;
 @Loop:
  fldlg2;
  fld  dword ptr [rsp+rax];
  fld  st;
  fstp tbyte ptr [rsp];
  fwait;
  cmp  word ptr [rsp+8],$3FFF;    // Exponent = 1?
  je   @1;
  fyl2x;
  fstp dword ptr [rsp+rax];
  add  rax,4;
  sub  r10d,1;
  jnz  @Loop;
  jz   @ende;
 @1:
  cmp word ptr [rsp+6],$8000;   // mantissa = 1.0000 or lower?
  jne @2;
  fld1;
  fsubp st(1),st;
  fyl2xp1;
  fstp dword ptr [rsp+rax];
  add  rax,4;
  sub  r10d,1;
  jnz  @Loop;
  jz   @ende;
align 16;
 @2:
  fyl2x;
  fstp dword ptr [rsp+rax];
  add  rax,4;
  sub  r10d,1;
  jnz  @Loop;
align 16;
 @ende:
  add  rsp,16;
  pop  rax;
end;

{calculate the Log(x) log for base 10}
procedure FN_LOG_DOUBLE ;assembler;nostackframe;
 asm
  push rax;
  mov  rax,32;
  sub  rsp,16;
align 16;
 @Loop:
  fldlg2;
  fld  qword ptr [rsp+rax];
  fld  st;
  fstp tbyte ptr [rsp];
  fwait;
  cmp  word ptr [rsp+8],$3FFF;    // exponent = 1?
  je   @1;
  fyl2x;
  fstp qword ptr [rsp+rax];
  add  rax,8;
  sub  r10d,1;
  jnz  @Loop;
  jz   @ende;
align 16;
 @1:
  cmp word ptr [rsp+6],$8000;   // mantissa = 1.0000 or lower?
  jne @2;
  fld1;
  fsubp st(1),st;
  fyl2xp1;
  fstp qword ptr [rsp+rax];
  add  rax,8;
  sub  r10d,1;
  jnz  @Loop;
  jz   @ende;
align 16;
 @2:
  fyl2x;
  fstp qword ptr [rsp+rax];
  add  rax,8;
  sub  r10d,1;
  jnz  @Loop;
align 16;
 @ende:
  add rsp,16;
  pop  rax;
end;

{calculate ld(x) log for base 2}
procedure FN_LD_SINGLE;assembler;nostackframe;
 asm
  push rax;
  mov  rax,32;
  sub  rsp,16;
align 16;
 @Loop:
  fld1;
  fld  dword ptr [rsp+rax];
  fld  st;
  fstp tbyte ptr [rsp];
  fwait;
  cmp  word ptr [rsp+8],$3FFF;    // Exponent = 1?
  je   @1;
  fyl2x;
  fstp dword ptr [rsp+rax];
  add  rax,4;
  sub  r10d,1;
  jnz  @Loop;
  jz   @ende;
 @1:
  cmp word ptr [rsp+6],$8000;   // mantissa = 1.0000 or lower?
  jne @2;
  fld1;
  fsubp st(1),st;
  fyl2xp1;
  fstp dword ptr [rsp+rax];
  add  rax,4;
  sub  r10d,1;
  jnz  @Loop;
  jz   @ende;
align 16;
 @2:
  fyl2x;
  fstp dword ptr [rsp+rax];
  add  rax,4;
  sub  r10d,1;
  jnz  @Loop;
align 16;
 @ende:
  add  rsp,16;
  pop  rax;
end;

{calculate the Ld(x) log for base 2}
procedure FN_LD_DOUBLE ;assembler;nostackframe;
 asm
  push rax;
  mov  rax,32;
  sub  rsp,16;
align 16;
 @Loop:
  fld1;
  fld  qword ptr [rsp+rax];
  fld  st;
  fstp tbyte ptr [rsp];
  fwait;
  cmp  word ptr [rsp+8],$3FFF;    // exponent = 1?
  je   @1;
  fyl2x;
  fstp qword ptr [rsp+rax];
  add  rax,8;
  sub  r10d,1;
  jnz  @Loop;
  jz   @ende;
align 16;
 @1:
  cmp word ptr [rsp+6],$8000;   // mantissa = 1.0000 or lower?
  jne @2;
  fld1;
  fsubp st(1),st;
  fyl2xp1;
  fstp qword ptr [rsp+rax];
  add  rax,8;
  sub  r10d,1;
  jnz  @Loop;
  jz   @ende;
align 16;
 @2:
  fyl2x;
  fstp qword ptr [rsp+rax];
  add  rax,8;
  sub  r10d,1;
  jnz  @Loop;
align 16;
 @ende:
  add rsp,16;
  pop  rax;
end;

{calculate 10**(x)}
procedure FN_EXP10_SINGLE ;assembler;nostackframe;
 asm
  push rax;
  sub  rsp,8;
  mov  rax,24;
align 16;
 @Loop:
  fld dword ptr [rsp+rax];
  fldz;
  fcomip;
  jp     @NAN;
  fldl2t;
  fmulp  st(1),st(0);        { z = d * log2(10) }
  fld    st(0);
  fisttp qword ptr [rsp];    // CHOP  = frndint
  fwait;
  fild   qword ptr [rsp];
  fld    st(0);
  fxch   st(2);
  fsubrp st(1),st(0);       // frac in st(1)
  f2xm1;
  fld1;
  faddp  st(1),st(0);       // corr the -1
  fscale;
  fstp   st(1);             // clear st(1)
 @NAN:
  fstp dword ptr[rsp+rax];   // give a exception when NAN!
  add rax,4;
  sub r10d,1;
  jnz @Loop;
  add rsp,8;
  pop rax;
end;

procedure FN_EXP10_DOUBLE;assembler;nostackframe;
 asm
  push rax;
  sub  rsp,8;
  mov  rax,24;
align 16;
 @Loop:
  fld  qword ptr [rsp+rax];
  fldz;
  fcomip;
  jp     @NAN;
  fldl2t;
  fmulp  st(1),st(0);        { z = d * log2(10) }
  fld    st(0);
  fisttp qword ptr [rsp];    // CHOP  = frndint
  fwait;
  fild   qword ptr [rsp];
  fld    st(0);
  fxch   st(2);
  fsubrp st(1),st(0);       // frac in st(1)
  f2xm1;
  fld1;
  faddp  st(1),st(0);       // corr the -1
  fscale;
  fstp   st(1);             // clear st(1)
 @NAN:
  fstp  qword ptr[rsp+rax];
  add rax,8;
  sub r10d,1;
  jnz @Loop;
  add rsp,8;
  pop rax;
end;

{calculate 2^(x)}
procedure FN_EXP2_SINGLE ;assembler;nostackframe;
 asm
  push rax;
  sub  rsp,8;
  mov  rax,24;
align 16;
 @Loop:
  fild  dword ptr [rsp+rax];
  fld1
  fscale;
  fstp  st(1);
  fstp  dword ptr[rsp+rax];
  add rax,4;
  sub r10d,1;
  jnz @Loop;
  add rsp,8;
  pop rax;
end;

procedure FN_EXP2_DOUBLE;assembler;nostackframe;
 asm
  push rax;
  sub  rsp,8;
  mov  rax,24;
  mov  r9,56;
align 16;
 @Loop:
  fild  dword ptr [rsp+rax];
  fld1
  fscale;
  fstp  st(1);
  fstp  qword ptr[rsp+r9];
  add  r9,8;
  add  rax,4;
  sub  r10d,1;
  jnz  @Loop;
  add  rsp,8;
  pop  rax;
end;

procedure FN_SIN_SINGLE ;assembler;nostackframe;
 asm
  push rax;
  mov  rax,16;
align 16;
 @Loop:
  fld  dword ptr [rsp+rax];
  fsin;
  fstp dword ptr [rsp+rax];
  add  rax,4;
  sub  r10d,1;
  jnz  @Loop;
  pop  rax;
end;

procedure FN_SIN_DOUBLE ;assembler;nostackframe;
 asm
  push rax;
  mov  rax,16;
align 16;
 @Loop:
  fld  qword ptr [rsp+rax];
  fsin;
  fstp qword ptr [rsp+rax];
  add  rax,8;
  sub  r10d,1;
  jnz  @Loop;
  pop  rax;
end;

procedure FN_SINCOS_Y_SINGLE ;assembler;nostackframe;
 asm
  push rax;
  mov  rax,16;
align 16;
 @Loop:
  fld  dword ptr [rsp+rax];
  fsincos;
  fstp dword ptr [rsp+rax+32]; // cos
  fstp dword ptr [rsp+rax];    // sin
  add  rax,4;
  sub  r10d,1;
  jnz  @Loop;
  pop  rax;
end;

procedure FN_SINCOS_Y_DOUBLE ;assembler;nostackframe;
 asm
  push rax;
  mov  rax,16;
align 16;
 @Loop:
  fld  qword ptr [rsp+rax];
  fsincos;
  fstp qword ptr [rsp+rax+32]; //cos
  fstp qword ptr [rsp+rax];    //sin
  add  rax,8;
  sub  r10d,1;
  jnz  @Loop;
  pop  rax;
end;

procedure FN_SINCOS_SINGLE ;assembler;nostackframe;
 asm
  push rax;
  mov  rax,16;
align 16;
 @Loop:
  fld  dword ptr [rsp+rax];
  fsincos;
  fstp dword ptr [rsp+rax+16]; // cos
  fstp dword ptr [rsp+rax];    // sin
  add  rax,4;
  sub  r10d,1;
  jnz  @Loop;
  pop  rax;
end;

procedure FN_SINCOS_DOUBLE ;assembler;nostackframe;
 asm
  push rax;
  mov  rax,16;
align 16;
 @Loop:
  fld  qword ptr [rsp+rax];
  fsincos;
  fstp qword ptr [rsp+rax+16]; // cos
  fstp qword ptr [rsp+rax];    // sin
  add  rax,8;
  sub  r10d,1;
  jnz  @Loop;
  pop  rax;
end;

procedure FN_COS_SINGLE ;assembler;nostackframe;
 asm
  push rax;
  mov  rax,16;
align 16;
 @Loop:
  fld  dword ptr [rsp+rax];
  fcos;
  fstp dword ptr [rsp+rax];
  add  rax,4;
  sub  r10d,1;
  jnz  @Loop;
  pop  rax;
end;

procedure FN_COS_DOUBLE ;assembler;nostackframe;
 asm
  push rax;
  mov  rax,16;
align 16;
 @Loop:
  fld  qword ptr [rsp+rax];
  fcos;
  fstp qword ptr [rsp+rax];
  add  rax,8;
  sub  r10d,1;
  jnz  @Loop;
  pop  rax;
end;

procedure FN_TAN_SINGLE ;assembler;nostackframe;
 asm
  push rax;
  mov  rax,16;
align 16;
 @Loop:
  fld  dword ptr [rsp+rax];
  fptan;
  fstp st;
  fstp dword ptr [rsp+rax];
  add  rax,4;
  sub  r10d,1;
  jnz  @Loop;
  pop  rax;
end;

procedure FN_TAN_DOUBLE ;assembler;nostackframe;
 asm
  push rax;
  mov  rax,16;
align 16;
 @Loop:
  fld  qword ptr [rsp+rax];
  fptan;
  fstp st;
  fstp qword ptr [rsp+rax];
  add  rax,8;
  sub  r10d,1;
  jnz  @Loop;
  pop  rax;
end;

procedure FN_COTAN_SINGLE ;assembler;nostackframe;
 asm
  push rax;
  mov  rax,16;
align 16;
 @Loop:
  fld  dword ptr [rsp+rax];
  fptan;                      //st(1) = tan
                              //st0   = 1.0
  fdivrp st(1),st;            //cotan = 1.0/tan
  fstp dword ptr [rsp+rax];
  add  rax,4;
  sub  r10d,1;
  jnz  @Loop;
  pop  rax;
end;

procedure FN_COTAN_DOUBLE ;assembler;nostackframe;
 asm
  push rax;
  mov  rax,16;
align 16;
 @Loop:
  fld  qword ptr [rsp+rax];
  fptan;
  fdivrp st(1),st;
  fstp qword ptr [rsp+rax];
  add  rax,8;
  sub  r10d,1;
  jnz  @Loop;
  pop  rax;
end;

procedure FN_ARCTAN_SINGLE ;assembler;nostackframe;
 asm
  push rax;
  mov  rax,16;
align 16;
 @Loop:
  fld  dword ptr [rsp+rax];
  fld  dword ptr [rsp+rax+16];
  fpatan;
  fstp dword ptr [rsp+rax];
  add  rax,4;
  sub  r10d,1;
  jnz  @Loop;
  pop  rax;
end;

procedure FN_ARCTAN_DOUBLE ;assembler;nostackframe;
 asm
  push rax;
  mov  rax,16;
align 16;
 @Loop:
  fld  qword ptr [rsp+rax];
  fld  qword ptr [rsp+rax+16];
  fpatan;
  fstp qword ptr [rsp+rax];
  add  rax,8;
  sub  r10d,1;
  jnz  @Loop;
  pop  rax;
end;

procedure FN_ARCTAN_Y_SINGLE ;assembler;nostackframe;
 asm
  push rax;
  mov  rax,16;
align 16;
 @Loop:
  fld  dword ptr [rsp+rax];
  fld  dword ptr [rsp+rax+32];
  fpatan;
  fstp dword ptr [rsp+rax];
  add  rax,4;
  sub  r10d,1;
  jnz  @Loop;
  pop  rax;
end;

procedure FN_ARCTAN_Y_DOUBLE ;assembler;nostackframe;
 asm
  push rax;
  mov  rax,16;
align 16;
 @Loop:
  fld  qword ptr [rsp+rax];
  fld  qword ptr [rsp+rax+32];
  fpatan;
  fstp qword ptr [rsp+rax];
  add  rax,8;
  sub  r10d,1;
  jnz  @Loop;
  pop  rax;
end;

procedure FN_ARCSIN_SINGLE ;assembler;nostackframe;
 asm
  push rax;
  mov  rax,16;
align 16;
 @Loop:
  fld  dword ptr [rsp+rax];
  fld  st;
  fld  st;
  fld1;
  faddp st(3),st;    // 1+x
  fld1;
  fsubrp st(2),st  // 1-x
  fxch   st(2);
  fmulp st(1),st;
  fsqrt;
  fpatan;
  fstp dword ptr [rsp+rax];
  add  rax,4;
  sub  r10d,1;
  jnz  @Loop;
  pop  rax;
end;

procedure FN_ARCSIN_DOUBLE ;assembler;nostackframe;
 asm
  push rax;
  mov  rax,16;
align 16;
 @Loop:
  fld  qword ptr [rsp+rax];
  fld  st;
  fld  st;
  fld1;
  faddp st(3),st;    // 1+x
  fld1;
  fsubrp st(2),st  // 1-x
  fxch   st(2);
  fmulp st(1),st;
  fsqrt;
  fpatan;
  fstp qword ptr [rsp+rax];
  add  rax,8;
  sub  r10d,1;
  jnz  @Loop;
  pop  rax;
end;

procedure FN_ARCOS_SINGLE ;assembler;nostackframe;
 asm
  push rax;
  mov  rax,16;
align 16;
 @Loop:
  fld  dword ptr [rsp+rax];
  fld  st;
  fld  st;
  fld1;
  faddp st(3),st;    // 1+x
  fld1;
  fsubrp st(2),st  // 1-x
  fxch   st(2);
  fmulp st(1),st;
  fsqrt;
  fxch  st(1);
  fpatan;
  fstp dword ptr [rsp+rax];
  add  rax,4;
  sub  r10d,1;
  jnz  @Loop;
  pop  rax;
end;

procedure FN_ARCOS_DOUBLE ;assembler;nostackframe;
 asm
  push rax;
  mov  rax,16;
align 16;
 @Loop:
  fld  qword ptr [rsp+rax];
  fld  st;
  fld  st;
  fld1;
  faddp st(3),st;    // 1+x
  fld1;
  fsubrp st(2),st  // 1-x
  fxch   st(2);
  fmulp  st(1),st;
  fsqrt;
  fxch   st(1);
  fpatan;
  fstp qword ptr [rsp+rax];
  add  rax,8;
  sub  r10d,1;
  jnz  @Loop;
  pop  rax;
end;

procedure FN_DIV_INT16;assembler;nostackframe;
 asm
  push rax;
  push rdx;
  mov  rax,24;
  mov  rdx,40;
align 16;
 @Loop:
  fild   word ptr [rsp+rax];
  fidiv  word ptr [rsp+rdx];
  fisttp word ptr [rsp+rax];   // integer with truncation
  add  rax,2;
  add  rdx,2;
  sub  r10d,1;
  jnz  @Loop;
  pop  rdx;
  pop  rax;
end;

procedure FN_DIV_INT32;assembler;nostackframe;
 asm
  push rax;
  push rdx;
  mov  rax,24;
  mov  rdx,40;
align 16;
 @Loop:
  fild  dword ptr [rsp+rax];
  fidiv dword ptr [rsp+rdx];
  fisttp dword ptr[rsp+rax];
  add  rax,4;
  add  rdx,4;
  sub  r10d,1;
  jnz  @Loop;
  pop  rdx;
  pop  rax;
end;

procedure FN_DIV_INT64;assembler;nostackframe;
 asm
  push rax;
  push rdx;
  mov  rax,24;
  mov  rdx,40;
align 16;
 @Loop:
  fild  qword ptr [rsp+rax];  // st1
  fild  qword ptr [rsp+rdx];  // st0
  fdivp st(1),st(0);
  fisttp qword ptr[rsp+rax];
  add  rax,8;
  add  rdx,8;
  sub  r10d,1;
  jnz  @Loop;
  pop  rdx;
  pop  rax;
end;

procedure FN_EXP_SINGLE;assembler;nostackframe;

asm
  push    rax;
  push    r12;
  sub     rsp,16;
  mov     r12,40;
align 16;
 @Loop:
  fld     dword ptr [rsp+r12];
  fldz;
  fcomip;               // when here a NAN -> when fst or fstp a exception!
  jp      @NAN;
  fldl2e;
  fmulp  st(1),st(0);
  fld    st(0);
  fisttp qword ptr [rsp];
  fwait;
  fild   qword ptr [rsp];
  fld    st(0);
  fxch   st(2);
  fsubrp st(1),st(0);
  f2xm1;
  fld1;
  faddp st(1),st(0);
  fscale;
  fstp    st(1);
@NAN:
  fstp    dword ptr [rsp+r12];
  add     r12,4;
  sub     r10d,1;
  jnz     @Loop;
  add     rsp,16;
  pop     r12;
  pop     rax;
end;

procedure FN_EXP_DOUBLE;assembler;nostackframe;

 asm
  push    rax;
  push    r12;
  sub     rsp,16;
  mov     r12,40;
align 16;
 @Loop:
  fld     qword ptr [rsp+r12];
  fldz;
  fcomip;               // when here a NAN -> when fst or fstp a exception!
  jp      @NAN;
  fldl2e;
  fmulp  st(1),st(0);
  fld    st(0);
  fisttp qword ptr [rsp];
  fwait;
  fild   qword ptr [rsp];
  fld    st(0);
  fxch   st(2);
  fsubrp st(1),st(0);
  f2xm1;
  fld1;
  faddp st(1),st(0);
  fscale;
  fstp    st(1);
@NAN:
  fstp    qword ptr [rsp+r12];
  add     r12,8;
  sub     r10d,1;
  jnz     @Loop;
  add     rsp,16;
  pop     r12;
  pop     rax;
end;

procedure FN_EXP0_SINGLE;assembler;nostackframe;
asm
  push rax;             // save call
  fldl2e;
  fmulp  st(1),st(0);
  fld    st(0);
  fisttp dword ptr [rsp+16];     //chop;
  fwait;
  fild   dword ptr [rsp+16];
  fld    st;
  fxch   st(2);
  fsubrp st(1),st(0);
  f2xm1;
  fld1;
  faddp st(1),st(0);
  fscale;
  fstp    st(1);
  pop rax;
end;

procedure FN_EXP0_DOUBLE;assembler;nostackframe;
asm
  push rax;               // save call
  fldl2e;
  fmulp  st(1),st(0);
  fld    st(0);
  fisttp qword ptr [rsp+16];
  fwait;
  fild   qword ptr [rsp+16];
  fld    st;
  fxch   st(2);
  fsubrp st(1),st(0);
  f2xm1;
  fld1;
  faddp st(1),st(0);
  fscale;
  fstp    st(1);
  pop rax;
end;

procedure FN_SINH_SINGLE ;assembler;nostackframe;
 asm
  push rax;
  mov  rax,32;
  sub  rsp,16;
align 16;
 @Loop:
  fld  dword ptr [rsp+rax];
  fldz;
  fcomip;               // when here a NAN -> when fst or fstp a exception!
  jp @NAN;
  call FN_EXP0_SINGLE;
  fld st;
  fld1;
  fdivrp st(1),st;
  fsubp  st(1),st;
  fld1;
  fld1;
  fadd  st,st;
  fdivp st(1),st;
  fmulp st(1),st;
 @NAN:
  fstp dword ptr [rsp+rax];
  add  rax,4;
  sub  r10d,1;
  jnz  @Loop;
  add  rsp,16;
  pop  rax;
  end;

procedure FN_SINH_DOUBLE ;assembler;nostackframe;
 asm
  push rax;
  mov  rax,32;
  sub  rsp,16;
align 16;
 @Loop:
  fld  qword ptr [rsp+rax];
  fldz;
  fcomip;               // when here a NAN -> when fst or fstp a exception!
  jp @NAN;
  call FN_EXP0_DOUBLE;  // exp(x)
  fld st;
  fld1;
  fdivrp st(1),st;      // 1/exp(x)
  fsubp st(1),st;       // e^x - e^-x
  fld1;
  fld1;
  fadd st,st;
  fdivp st(1),st;      // 1/2
  fmulp st(1),st;      // 1/2*(e^x - e^-x)
 @NAN:
  fstp qword ptr [rsp+rax];
  add  rax,8;
  sub  r10d,1;
  jnz  @Loop;
  add  rsp,16;
  pop  rax;
end;

procedure FN_SECH_SINGLE ;assembler;nostackframe;
 asm
  push rax;
  mov  rax,32;
  sub  rsp,16;
align 16;
 @Loop:
  fld  dword ptr [rsp+rax];
  fldz;
  fcomip;               // when here a NAN -> when fst or fstp a exception!
  jp @NAN;
  call FN_EXP0_SINGLE;
  fld st;
  fld1;
  fdivrp st(1),st;     // 1/e^x
  faddp  st(1),st;     // e^x + e^(-x)
  fld1;
  fadd st,st;          // 2
  fdivrp st(1),st;     // 2/(e^x + e^-x)
 @NAN:
  fstp dword ptr [rsp+rax];
  add  rax,4;
  sub  r10d,1;
  jnz  @Loop;
  add  rsp,16;
  pop  rax;
  end;

procedure FN_SECH_DOUBLE ;assembler;nostackframe;
 asm
  push rax;
  mov  rax,32;
  sub  rsp,16;
align 16;
 @Loop:
  fld  qword ptr [rsp+rax];
  fldz;
  fcomip;               // when here a NAN -> when fst or fstp a exception!
  jp @NAN;
  call FN_EXP0_DOUBLE;
  fld st;
  fld1;
  fdivrp st(1),st;
  faddp st(1),st;
  fld1;
  fadd st,st;
  fdivrp st(1),st;
 @NAN:
  fstp qword ptr [rsp+rax];
  add  rax,8;
  sub  r10d,1;
  jnz  @Loop;
  add  rsp,16;
  pop  rax;
end;

procedure FN_COSECH_SINGLE ;assembler;nostackframe;
 asm
  push rax;
  mov  rax,32;
  sub  rsp,16;
align 16;
 @Loop:
  fld  dword ptr [rsp+rax];
  fldz;
  fcomip;               // when here a NAN -> when fst or fstp a exception!
  jp @NAN;
  call FN_EXP0_SINGLE;
  fld st;
  fld1;
  fdivrp st(1),st;     // 1/e^x
  fsubp  st(1),st;     // e^x - e^(-x)
  fld1;
  fadd st,st;          // 2
  fdivrp st(1),st;     // 2/(e^x + e^-x)
 @NAN:
  fstp dword ptr [rsp+rax];
  add  rax,4;
  sub  r10d,1;
  jnz  @Loop;
  add  rsp,16;
  pop  rax;
  end;

procedure FN_COSECH_DOUBLE ;assembler;nostackframe;
 asm
  push rax;
  mov  rax,32;
  sub  rsp,16;
align 16;
 @Loop:
  fld  qword ptr [rsp+rax];
  fldz;
  fcomip;               // when here a NAN -> when fst or fstp a exception!
  jp @NAN;
  call FN_EXP0_DOUBLE;
  fld st;
  fld1;
  fdivrp st(1),st;
  fsubp  st(1),st;
  fld1;
  fadd st,st;
  fdivrp st(1),st;
 @NAN:
  fstp qword ptr [rsp+rax];
  add  rax,8;
  sub  r10d,1;
  jnz  @Loop;
  add  rsp,16;
  pop  rax;
end;

procedure FN_COSH_SINGLE ;assembler;nostackframe;
 asm
  push rax;
  mov  rax,32;
  sub  rsp,16;
align 16;
 @Loop:
  fld  dword ptr [rsp+rax];
  fldz;
  fcomip;               // when here a NAN -> when fst or fstp a exception!
  jp @NAN;
  call FN_EXP0_SINGLE;
  fld st;
  fld1;
  fdivrp st(1),st;
  faddp st(1),st;
  fld1;
  fld1;
  fadd st,st;
  fdivp st(1),st;
  fmulp st(1),st;
 @NAN:
  fstp dword ptr [rsp+rax];
  add  rax,4;
  sub  r10d,1;
  jnz  @Loop;
  add rsp,16;
  pop  rax;
  end;

procedure FN_COSH_DOUBLE ;assembler;nostackframe;
 asm
  push rax;
  mov  rax,32;
  sub  rsp,16;
align 16;
 @Loop:
  fld  qword ptr [rsp+rax];
  fldz;
  fcomip;               // when here a NAN -> when fst or fstp a exception!
  jp @NAN;
  call FN_EXP0_DOUBLE;
  fld st;
  fld1;
  fdivrp st(1),st;
  faddp st(1),st;
  fld1;
  fld1;
  fadd st,st;
  fdivp st(1),st;
  fmulp st(1),st;
 @NAN:
  fstp qword ptr [rsp+rax];
  add  rax,8;
  sub  r10d,1;
  jnz  @Loop;
  add  rsp,16;
  pop  rax;
end;

procedure FN_TANH_SINGLE ;assembler;nostackframe;
 asm
  push rax;
  mov  rax,32;
  sub  rsp,16;
align 16;
 @Loop:
  fld  dword ptr [rsp+rax];
  fldz;
  fcomip;               // when here a NAN -> when fst or fstp a exception!
  jp @NAN;
  fld1;
  fadd st,st;
  fchs;                   //-2.0
  fmulp st(1),st;
  call FN_EXP0_SINGLE;
  fld st;
  fld1;
  faddp st(1),st;
  fld1;
  fsubrp st(2),st;
  fdivp st(1),st;
 @NAN:
  fstp dword ptr [rsp+rax];
  add  rax,4;
  sub  r10d,1;
  jnz  @Loop;
  add rsp,16;
  pop  rax;
  end;

procedure FN_TANH_DOUBLE ;assembler;nostackframe;
 asm
  push rax;
  mov  rax,32;
  sub  rsp,16;
align 16;
 @Loop:
  fld  qword ptr [rsp+rax];
  fldz;
  fcomip;               // when here a NAN -> when fst or fstp a exception!
  jp @NAN;
  fld1;
  fadd st,st;
  fchs;
  fmulp st(1),st;
  call FN_EXP0_DOUBLE;
  fld  st;
  fld1;
  faddp st(1),st;
  fld1;
  fsubrp st(2),st;
  fdivp  st(1),st;
 @NAN:
  fstp qword ptr [rsp+rax];
  add  rax,8;
  sub  r10d,1;
  jnz  @Loop;
  add  rsp,16;
  pop  rax;
end;

{input ymm1}
function Check_IntYZero:Longbool;assembler;nostackframe;
  asm
   xor rax,rax;
   vextractf128 xmm2,ymm1,1;
   vpabsd   xmm1,xmm1;        // abs(xmm1)
   vpabsd   xmm2,xmm2;
   vpxor    xmm5,xmm5,xmm5;   // set 0
   vpcmpeqd xmm4,xmm1,xmm5;   // result all bits 1 when =
   vptest   xmm4,xmm4;
   jnz      @error;
   vpcmpeqd xmm4,xmm2,xmm5;
   vptest   xmm4,xmm4;
   jnz      @error;
   vinsertf128 ymm1,ymm1,xmm2,1;  // upper value for abs
   mov rax,1;
  @error:
 end;

{input/output in xmm1}
function Check_TX4Int32:Longbool;assembler;nostackframe;
 asm
  xor rax,rax;
  {test for zeros in xmm1}
  pxor    xmm2,xmm2;
  pcmpeqd xmm2,xmm1;
  ptest   xmm2,xmm2;
  jnz     @error;
  {The count of the x,y pairs must are equal.}
  pabsd  xmm1,xmm1;         // make  abs values
  movdqa xmm2,xmm1;
  pshufd xmm2,xmm2,10110001b;
  psubd  xmm2,xmm1;
  ptest  xmm2,xmm2;
  jnz    @error;
  mov eax,1;
 @error:
 end;

{input/output in xmm1}
function Check_T4Int32:Longbool;assembler;nostackframe;
 asm
  xor rax,rax;
  {test for zeros in xmm1}
  vpxor    xmm2,xmm2,xmm2;
  vpcmpeqd xmm3,xmm1,xmm2;
  vpsubd   xmm3,xmm3,xmm2;
  vptest   xmm3,xmm3;
  jnz      @error;
  {The count of the x,y pairs must are equal.}
  vpabsd  xmm1,xmm1;         // make  abs values
  vmovdqa xmm2,xmm1;
  vpshufd xmm2,xmm2,10110001b;
  vpsubd  xmm2,xmm2,xmm1;
  vptest  xmm2,xmm2;
  jnz     @error;
  mov eax,1;
 @error:
 end;

{The count of the x,y pairs must are equal and check for zero.
  input/output in ymm1}
function Check_T8Int32:Longbool;assembler;nostackframe;
 asm
  xor rax,rax;
  vextractf128 xmm5,ymm1,1;  // upper half for lather
  // make  abs values
  vpabsd  xmm1,xmm1;        // abs(xmm1)
  vpabsd  xmm5,xmm5;        // abs(xmm5)
  {test for zeros in ymm1}
  vpxor   xmm2,xmm2,xmm2;
  vpcmpeqd xmm3,xmm1,xmm2;    // test for 0
  vpsubd  xmm3,xmm3,xmm2;
  vptest  xmm3,xmm3;
  jnz     @error;
  vpcmpeqd xmm3,xmm5,xmm2;
  vpsubd  xmm3,xmm3,xmm2;
  vptest  xmm3,xmm3;
  jnz     @error;
  {test for equal count value in x,y pairs}
  vmovdqa xmm2,xmm1;
  vpshufd xmm2,xmm2,10110001b;   //2,1,4,3
  vsubpd  xmm2,xmm2,xmm1;
  vpabsd  xmm2,xmm2;
  vptest  xmm2,xmm2;
  jnz     @error;
  vmovdqa xmm2,xmm5;
  vpshufd xmm2,xmm2,10110001b;
  vsubpd  xmm2,xmm2,xmm5;
  vpabsd  xmm2,xmm2;
  vptest  xmm2,xmm2;
  jnz     @error;
  vinsertf128 ymm1,ymm1,xmm5,1;    // upper value
  mov eax,1;
 @error:
 end;


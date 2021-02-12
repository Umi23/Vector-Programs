unit Test_ymm;

{ This unit is part of unit ymmfloat an MUST distributed together with the
  unit ymmfloat. This unit is the documentation of the routines in the ymm unit.

  Copyright (C) 2020 Klaus Stöhr  mail: k.stoehr@gmx.de

  This source is free software; you can redistribute it and/or modify it under
  the terms of the GNU General Public License as published by the Free
  Software Foundation; either version 3 of the License, or (at your option)
  any later version.

  This code is distributed in the hope that it will be useful, but WITHOUT ANY
  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
  details.

  You should have received a copy of the GNU General Public License
  along with this program. If not, see <http://www.gnu.org/licenses/>.
}

{The following hints are not removable.}

{Remark: all YMM arrays shold align on 32 byte adresses, but on FPC <= 3.2
         the directive LOCALMIN=32 for arrays NOT WORK. This is a compiler error.
         The routines in ymmfloat but work with aligned and unaligned arrays
         and so you have not problems with align.
         All calculations work with T8Single or T4Double arrays. You can
         construct this with the convert routines. (p.e. ArrayToT8Single input
         single array output T8Single array)
         The trigonometric functions need input values in radian
}

{$mode objfpc}{$H+}
{$CODEPAGE UTF8}
{$ASMMODE INTEL}
{$FPUTYPE AVX}
{$OPTIMIZATION OFF}

interface

{$IFDEF CPUX86_64}


{convert array direction}
function TestArray8ToT8Single      :Boolean;
function TestArray7ToT8Single      :Boolean;
function TestArray6ToT8Single      :Boolean;
function TestArray5ToT8Single      :Boolean;
function TestArrayToT8Single       :Boolean;

function TestArray4ToT4Double      :Boolean;
function TestArray3ToT4Double      :Boolean;
function TestArrayToT4Double       :Boolean;

function TestT8SingleTo8Single     :Boolean;
function TestT8SingleTo7Single     :Boolean;
function TestT8SingleTo6Single     :Boolean;
function TestT8SingleTo5Single     :Boolean;
function TestT8SingleToSingle      :Boolean;

function TestT4DoubleTo4Double     :Boolean;
function TestT4DoubleTo3Double     :Boolean;
function TestT4DoubleToDouble      :Boolean;

{set value}
function TestSetValueYSingle       :Boolean;
function TestSetValueYPlaceSingle  :Boolean;
function TestSetValueYDouble       :Boolean;
function TestSetValueYPlaceDouble  :Boolean;


{addition}
function TestSumVYSingle           :Boolean;
function TestAddVYSingle           :Boolean;
function TestAdd4VYSingle          :Boolean;
function TestAddYSingle            :Boolean;
function TestAdd2TabYSingle        :Boolean;
function TestAddValueYSingle       :Boolean;
function TestAddValueYSingle1      :Boolean;
function TestSumMinMaxYSingle      :Boolean;
function TestSumMinMaxVYSingle     :Boolean;

function TestSumVYDouble           :Boolean;
function TestAddYDouble            :Boolean;
function TestAdd2VYDouble          :Boolean;
function TestAddVYDouble           :Boolean;
function TestAdd2TabYDouble        :Boolean;
function TestAddValueYDouble       :Boolean;
function TestAddValueYDouble1      :Boolean;
function TestSumMinMaxYDouble      :Boolean;
function TestSumMinMaxVYDouble     :Boolean;


{subtract}

function TestSubYSingle            :Boolean;
function TestSubDivValueYSingle    :Boolean;
function TestMulDiffYSingle        :Boolean;
function TestSumMulDiffYSingle     :Boolean;
function TestMaxAbsMulDiffYSingle  :Boolean;
function TestSub4VYSingle          :Boolean;
function TestSub2TabYSingle        :Boolean;

function TestSubYDouble            :Boolean;
function TestSubDivValueYDouble    :Boolean;
function TestMulDiffYDouble        :Boolean;
function TestSumMulDiffYDouble     :Boolean;
function TestMaxAbsMulDiffYDouble  :Boolean;
function TestSub2VYDouble          :Boolean;
function TestSub2TabYDouble        :Boolean;

{add and subtract}

function TestAddSubYSingle         :Boolean;
function TestAddSubValueYSingle    :Boolean;
function TestAddSubYDouble         :Boolean;
function TestAddSubValueYDouble    :Boolean;

{multiply}

function TestProductVYSingle       :Boolean;
function TestProductYSingle        :Boolean;
function TestMulYSingle            :Boolean;
function TestFMulAddYSingle        :Boolean;
function TestFMulAddYSingle1       :Boolean;
function TestFMulSubYSingle        :Boolean;
function TestFMulSubYSingle1       :Boolean;
function TestMul4VYSingle          :Boolean;
function TestMulVYSingle           :Boolean;
function TestMulValueYSingle       :Boolean;
function TestMulValueYSingle1      :Boolean;

function TestProductVYDouble       :Boolean;
function TestProductYDouble        :Boolean;
function TestMulVYDouble           :Boolean;
function TestFMulAddYDouble        :Boolean;
function TestFMulAddYDouble1       :Boolean;
function TestFMulSubYDouble        :Boolean;
function TestFMulSubYDouble1       :Boolean;
function TestMul2VYDouble          :Boolean;
function TestMulYDouble            :Boolean;
function TestMulValueYDouble       :Boolean;
function TestMulValueYDouble1      :Boolean;

{division}

function TestDivYSingle            :Boolean;
function TestDiv4VYSingle          :Boolean;
function TestDivYDouble            :Boolean;
function TestDiv2VYDouble          :Boolean;

{functions}

function TestSQRYSingle            :Boolean;
function TestSQRYSingle1           :Boolean;
function TestSQRMulDiffYSingle     :Boolean;
function TestSumSQRYSingle         :Boolean;
function TestSumSQRMulDiffYSingle  :Boolean;
function TestSumSqrVYSingle        :Boolean;

function TestSQRYDouble            :Boolean;
function TestSQRYDouble1           :Boolean;
function TestSQRMulDiffYDouble     :Boolean;
function TestSumSQRMulDiffYDouble  :Boolean;
function TestSumSqrYDouble         :Boolean;
function TestSumSqrVYDouble        :Boolean;

function TestCubicYSingle          :Boolean;
function TestCubicYSingle1         :Boolean;
function TestCubicYDouble          :Boolean;
function TestCubicYDouble1         :Boolean;

function TestRecYSingle            :Boolean;
function TestRecYSingle1           :Boolean;
function TestSRecYSingle           :Boolean;
function TestSRecYSingle1          :Boolean;
function TestFastRecYSingle        :Boolean;
function TestFastRecYSingle1       :Boolean;
function TestSumRecYSingle         :Boolean;
function TestSumSRecYSingle        :Boolean;
function TestSumRecVYSingle        :Boolean;
function TestSumSRecVYSingle       :Boolean;

function TestRecYDouble            :Boolean;
function TestRecYDouble1           :Boolean;
function TestSumRecYDouble         :Boolean;
function TestSumSRecYDouble        :Boolean;
function TestSumRecVYDouble        :Boolean;
function TestSumSRecVYDouble       :Boolean;

function TestSQRTYSingle            :Boolean;
function TestSQRTYSingle1           :Boolean;
function TestSumSqrtYSingle         :Boolean;
function TestSumSqrtVYSingle        :Boolean;
function TestFastRecSQRTYSingle     :Boolean;
function TestFastRecSQRTYSingle1    :Boolean;
function TestRecSqrtYSingle         :Boolean;
function TestRecSqrtYSingle1        :Boolean;
function TestSRecSqrtYSingle        :Boolean;
function TestSRecSqrtYSingle1       :Boolean;
function TestSumRecSqrtYSingle      :Boolean;
function TestSumSRecSqrtYSingle     :Boolean;
function TestSumRecSqrtVYSingle     :Boolean;
function TestSumSRecSqrtVYSingle    :Boolean;

function TestSQRTYDouble            :Boolean;
function TestSQRTYDouble1           :Boolean;
function TestSumSqrtYDouble         :Boolean;
function TestSumSqrtVYDouble        :Boolean;

function TestRecSqrtYDouble         :Boolean;
function TestRecSqrtYDouble1        :Boolean;
function TestSRecSqrtYDouble        :Boolean;
function TestSRecSqrtYDouble1       :Boolean;
function TestSumRecSqrtYDouble      :Boolean;
function TestSumSRecSqrtYDouble     :Boolean;
function TestSumRecSqrtVYDouble     :Boolean;
function TestSumSRecSqrtVYDouble    :Boolean;

function TestSignFlipFlopYSingle   :Boolean;
function TestSetSignYSingle        :Boolean;
function TestAbsYSingle            :Boolean;
function TestSignFlipFlopYDouble   :Boolean;
function TestSetSignYDouble        :Boolean;
function TestAbsYDouble            :Boolean;

{------------------trigonometrie--------------------------------------------}

function TestRadInDegYSingle         :Boolean;
function TestRadInDegYDouble         :Boolean;
function TestRadInGonYSingle         :Boolean;
function TestRadInGonYDouble         :Boolean;
function TestDegInRadYSingle         :Boolean;
function TestDegInRadYDouble         :Boolean;
function TestGonInRadYSingle         :Boolean;
function TestGonInRadYDouble         :Boolean;

function TestSinYSingle              :Boolean;
function TestSinYDouble              :Boolean;
function TestSinCosYSingle           :Boolean;
function TestSinCosYDouble           :Boolean;
function TestCosYSingle              :Boolean;
function TestCosYDouble              :Boolean;
function TestTanySingle              :Boolean;
function TestTanYDouble              :Boolean;
function TestCotanYSingle            :Boolean;
function TestCotanYDouble            :Boolean;
function TestArcSinYSingle           :Boolean;
function TestArcSinYDouble           :Boolean;
function TestArcCosYSingle           :Boolean;
function TestArcCosYDouble           :Boolean;
function TestArcTanYSingle           :Boolean;
function TestArcTanYDouble           :Boolean;
function TestArcCotYSingle           :Boolean;
function TestArcCotYDouble           :Boolean;

function TestSinhYSingle             :Boolean;
function TestSinhYDouble             :Boolean;
function TestSechYSingle             :Boolean;
function TestSechYDouble             :Boolean;
function TestCschYSingle             :Boolean;
function TestCschYDouble             :Boolean;
function TestCoshySingle             :Boolean;
function TestCoshYDouble             :Boolean;
function TestTanhYSingle             :Boolean;
function TestTanhYDouble             :Boolean;
function TestCothYSingle             :Boolean;
function TestCothYDouble             :Boolean;

function TestArSinhYSingle             :Boolean;
function TestArSinhYDouble             :Boolean;
function TestArCoshySingle             :Boolean;
function TestArCoshYDouble             :Boolean;
function TestArTanhYSingle             :Boolean;
function TestArTanhYDouble             :Boolean;

{rounding}

function TestRoundYSingle          :Boolean;
function TestTruncateYSingle       :Boolean;
function TestFloorYSingle          :Boolean;
function TestCeilYSingle           :Boolean;
function TestRoundYDouble          :Boolean;
function TestTruncateYDouble       :Boolean;
function TestFloorYDouble          :Boolean;
function TestCeilYDouble           :Boolean;

function TestRoundYSingle1         :Boolean;
function TestRoundYSingle2         :Boolean;
function TestRoundYDouble1         :Boolean;
function TestRoundYDouble2         :Boolean;
function TestRoundChopYSingle      :Boolean;
function TestRoundChopYSingle1     :Boolean;
function TestRoundChopYDouble      :Boolean;
function TestRoundChopYDouble1     :Boolean;


{logical}

function TestYSingle1               :Boolean;
function TestYDouble1               :Boolean;

{other functions}

function TestIntPowYSingle         :Boolean;
function TestExpYSingle            :Boolean;
function TestLnYSingle             :Boolean;
function TestLdYSingle             :Boolean;
function TestLogYSingle            :Boolean;
function TestPowYSingle            :Boolean;
function TestExp10YSingle          :Boolean;
function TestExp2YSingle           :Boolean;
function TestIntPowYDouble         :Boolean;
function TestExpYDouble            :Boolean;
function TestLnYDouble             :Boolean;
function TestLdYDouble             :Boolean;
function TestLogYDouble            :Boolean;
function TestPowYDouble            :Boolean;
function TestExp10YDouble          :Boolean;
function TestExp2YDouble           :Boolean;
function TestExponentYSingle       :Boolean;
function TestExponentYDouble       :Boolean;

{convert}

function TestConvertYSingleToInt32 :Boolean;
function TestConvertYSingleToDouble:Boolean;
function TestConvertYDoubleToInt32 :Boolean;
function TestConvertYDoubleToSingle:Boolean;
function TestConvertYInt32ToSingle :Boolean;
function TestConvertYInt32ToDouble :Boolean;
function TestChopYSingleToInt32    :Boolean;
function TestChopYDoubleToInt32    :Boolean;

{convert for arrays abbrev convert... to conv only here}
function TestConvYSingleToInt32    :Boolean;
function TestConvYSingleToDouble   :Boolean;
function TestConvYDoubleToInt32    :Boolean;
function TestConvYDoubleToSingle   :Boolean;
function TestConvYInt32ToSingle    :Boolean;
function TestConvYInt32ToDouble    :Boolean;
function TestChopYSingleToInt32_1  :Boolean;
function TestChopYDoubleToInt32_1  :Boolean;

{compare}

function TestCmpYSingleEQ          :Boolean;
function TestCmpYSingleLT          :Boolean;
function TestCmpYSingleGE          :Boolean;
function TestCmpYSingleGT          :Boolean;
function TestCmpYDoubleEQ          :Boolean;
function TestCmpYDoubleLT          :Boolean;
function TestCmpYDoubleGE          :Boolean;
function TestCmpYDoubleGT          :Boolean;

{diverses}

function TestSignExtractYSingle    :Boolean;
function TestSignExtractYDouble    :Boolean;
function TestIsInfYSingle          :Boolean;
function TestIsInfYDouble          :Boolean;
function TestIsNANYSingle          :Boolean;
function TestIsNANYDouble          :Boolean;


{statistic functions}

function TestStatCalcYSingle       :Boolean;
function TestAverageYSingle        :Boolean;
function TestGeoAverageYSingle     :Boolean;
function TestStatCalcYDouble       :Boolean;
function TestAverageYDouble        :Boolean;
function TestGeoAverageYDouble     :Boolean;

function TestKorrAnalyseYSingle    :Boolean;
function TestLinRegYSingle         :Boolean;
function TestLogRegYSingle         :Boolean;
function TestExpRegYSingle         :Boolean;
function TestBPotenzRegYSingle     :Boolean;
function TestXPotenzRegYSingle     :Boolean;

function TestKorrAnalyseYDouble    :Boolean;
function TestLinRegYDouble         :Boolean;
function TestLogRegYDouble         :Boolean;
function TestExpRegYDouble         :Boolean;
function TestBPotenzRegYDouble     :Boolean;
function TestXPotenzRegYDouble     :Boolean;

{statistic functions for up to 4 or 8 parallel arrays}

function TestStatCalcVYSingle      :Boolean;
function TestStatCalcVYDouble      :Boolean;
function TestAverageVYSingle       :Boolean;
function TestAverageVYDouble       :Boolean;
function TestGeoAverageVYSingle    :Boolean;
function TestGeoAverageVYDouble    :Boolean;

{statistic functions for up to 2 or 4 array pairs}

function TestKorrAnalyse4VYSingle :Boolean;
function TestKorrAnalyse2VYDouble :Boolean;
function TestLinReg4VYSingle      :Boolean;
function TestLinReg2VYDouble      :Boolean;
function TestLogReg4VYSingle      :Boolean;
function TestLogReg2VYDouble      :Boolean;
function TestExpReg4VYSingle      :Boolean;
function TestExpReg2VYDouble      :Boolean;
function TestBPotenzReg4VYSingle  :Boolean;
function TestBPotenzReg2VYDouble  :Boolean;
function TestXPotenzReg4VYSingle  :Boolean;
function TestXPotenzReg2VYDouble  :Boolean;

{$ENDIF}

implementation
 uses sysutils,math,simdconv,ymmfloat;

{$IFDEF CPUX86_64}

{Remark for the follow convert routines:
 - all the array fields must have the equal length (array fields)
 - fill divrent array length with zeros for add and sub and with 1.0
   for mul and div.
 - the array length must have a multiply of 8 for T8Single and 4 for T4Double }

function TestArray8ToT8Single :Boolean;
{Convert 8 arrays in cols order.}
 const
   Feld1 :array[0..9] of Single =(1,2,3,4,33,34,35,36,100,200);
   Feld2 :array[0..9] of Single =(5,6,7,8,37,38,39,40,101,201);
   Feld3 :array[0..9] of Single =(9,10,11,12,41,42,43,44,102,202);
   Feld4 :array[0..9] of Single =(13,14,15,16,45,46,47,48,103,203);
   Feld5 :array[0..9] of Single =(17,18,19,20,49,50,51,52,104,204);
   Feld6 :array[0..9] of Single =(21,22,23,24,53,54,55,56,105,205);
   Feld7 :array[0..9] of Single =(25,26,27,28,57,58,59,60,106,206);
   Feld8 :array[0..9] of Single =(29,30,31,32,61,62,63,64,107,207);

   Soll :array[0..9] of T8Single = ((1,5,9,13,17,21,25,29),
                                    (2,6,10,14,18,22,26,30),
                                    (3,7,11,15,19,23,27,31),
                                    (4,8,12,16,20,24,28,32),
                                    (33,37,41,45,49,53,57,61),
                                    (34,38,42,46,50,54,58,62),
                                    (35,39,43,47,51,55,59,63),
                                    (36,40,44,48,52,56,60,64),
                                    (100,101,102,103,104,105,106,107),
                                    (200,201,202,203,204,205,206,207));
 var
  i,j :Integer;
  Res :array[0..9] of T8Single;

 begin
  Result := True;
  if Array8ToT8Single(Feld1,Feld2,Feld3,Feld4,Feld5,Feld6,Feld7,Feld8,
                            Res) then begin
    for i := 0 to 9 do
      for j := 0 to 7 do
        if Res[i,j] <> Soll[i,j] then
          Result := False;
   end
  else
    Result := False;
end;

function TestArray7ToT8Single :Boolean;
{Convert 8 arrays in cols order.}
 const
   Feld1 :array[0..9] of Single =(1,2,3,4,33,34,35,36,100,200);
   Feld2 :array[0..9] of Single =(5,6,7,8,37,38,39,40,101,201);
   Feld3 :array[0..9] of Single =(9,10,11,12,41,42,43,44,102,202);
   Feld4 :array[0..9] of Single =(13,14,15,16,45,46,47,48,103,203);
   Feld5 :array[0..9] of Single =(17,18,19,20,49,50,51,52,104,204);
   Feld6 :array[0..9] of Single =(21,22,23,24,53,54,55,56,105,205);
   Feld7 :array[0..9] of Single =(25,26,27,28,57,58,59,60,106,206);

   Soll :array[0..9] of T8Single = ((1,5,9,13,17,21,25,0),
                                    (2,6,10,14,18,22,26,0),
                                    (3,7,11,15,19,23,27,0),
                                    (4,8,12,16,20,24,28,0),
                                    (33,37,41,45,49,53,57,0),
                                    (34,38,42,46,50,54,58,0),
                                    (35,39,43,47,51,55,59,0),
                                    (36,40,44,48,52,56,60,0),
                                    (100,101,102,103,104,105,106,0),
                                    (200,201,202,203,204,205,206,0));

 var
  i,j :Integer;
  Flag :Boolean = False;    // set unused array to zero
  Res :array[0..9] of T8Single;

 begin
  Result := True;
  if Array7ToT8Single (Feld1,Feld2,Feld3,Feld4,Feld5,Feld6,Feld7,Res,Flag) then begin
    for i := 0 to 9 do
      for j := 0 to 7 do
        if Res[i,j] <> Soll[i,j] then
          Result := False;
   end
  else
    Result := False;
end;


function TestArray6ToT8Single :Boolean;
{Convert 6 arrys in cols order}
 const
   Feld1 :array[0..9] of Single =(1,2,3,4,33,34,35,36,100,200);
   Feld2 :array[0..9] of Single =(5,6,7,8,37,38,39,40,101,201);
   Feld3 :array[0..9] of Single =(9,10,11,12,41,42,43,44,102,202);
   Feld4 :array[0..9] of Single =(13,14,15,16,45,46,47,48,103,203);
   Feld5 :array[0..9] of Single =(17,18,19,20,49,50,51,52,104,204);
   Feld6 :array[0..9] of Single =(21,22,23,24,53,54,55,56,105,205);

   Soll :array[0..9] of T8Single = ((1,5,9,13,17,21,0,0),
                                    (2,6,10,14,18,22,0,0),
                                    (3,7,11,15,19,23,0,0),
                                    (4,8,12,16,20,24,0,0),
                                    (33,37,41,45,49,53,0,0),
                                    (34,38,42,46,50,54,0,0),
                                    (35,39,43,47,51,55,0,0),
                                    (36,40,44,48,52,56,0,0),
                                    (100,101,102,103,104,105,0,0),
                                    (200,201,202,203,204,205,0,0));

 var
  i,j :Integer;
  Res :array[0..9] of T8Single;
  Flag :Boolean = False;  //clear unused arrays to 0; when True set 1.0

 begin
  Result := True;
  if Array6ToT8Single (Feld1,Feld2,Feld3,Feld4,Feld5,Feld6,Res,flag) then begin
    for i := 0 to 9 do
     for j := 0 to 7 do
      if Res[i,j] <> Soll[i,j] then
        Result := False;
    end
   else
      Result := False;
end;

function TestArray5ToT8Single :Boolean;
{Convert 5 arrys in cols order}
 const
   Feld1 :array[0..9] of Single =(1,2,3,4,33,34,35,36,100,200);
   Feld2 :array[0..9] of Single =(5,6,7,8,37,38,39,40,101,201);
   Feld3 :array[0..9] of Single =(9,10,11,12,41,42,43,44,102,202);
   Feld4 :array[0..9] of Single =(13,14,15,16,45,46,47,48,103,203);
   Feld5 :array[0..9] of Single =(17,18,19,20,49,50,51,52,104,204);
   Soll  :array[0..9] of T8Single = ((1,5,9,13,17,0,0,0),
                                    (2,6,10,14,18,0,0,0),
                                    (3,7,11,15,19,0,0,0),
                                    (4,8,12,16,20,0,0,0),
                                    (33,37,41,45,49,0,0,0),
                                    (34,38,42,46,50,0,0,0),
                                    (35,39,43,47,51,0,0,0),
                                    (36,40,44,48,52,0,0,0),
                                    (100,101,102,103,104,0,0,0),
                                    (200,201,202,203,204,0,0,0));

 var
  i,j :Integer;
  Res :array[0..9] of T8Single;
  Flag :Boolean = False;  //clear unused arrays to 0; when True set 1.0

 begin
  Result := True;
  if Array5ToT8Single(Feld1,Feld2,Feld3,Feld4,Feld5,Res,flag) then begin
    for i := 0 to 9 do
     for j := 0 to 7 do
      if Res[i,j] <> Soll[i,j] then
        Result := False;
    end
   else
      Result := False;
end;


function TestArrayToT8Single :Boolean;
{Set a single array to T8Single order. Is count of array fields div 8 <
 then the rest is fill with 0 or 1. The parameter flag set this.}
 const
   Feld :array[0..8] of Single   = (1,2,3,4,5,6,7,8,9);
   Soll :array[0..1] of T8Single = ((1,2,3,4,5,6,7,8),(9,0,0,0,0,0,0,0));

 var
  i,j :Integer;
  Res :array[0..1] of T8Single;
  Flag :Boolean = False;  //set 0  True = set 1

 begin
  Result := True;
  if ArrayToT8Single (Feld,Res,Flag) then begin
    for i := 0 to 1 do
     for j := 0 to 7 do
      if Res[i,j] <> Soll[i,j] then
        Result := False;
    end
   else
      Result := False;
end;

function TestArray4ToT4Double :Boolean;
{Set 4 double arrays to cols order.}
 const
   Feld1 :array[0..9] of Double =(1,2,3,4,17,18,19,20,100,200);
   Feld2 :array[0..9] of Double =(5,6,7,8,21,22,23,24,101,201);
   Feld3 :array[0..9] of Double =(9,10,11,12,25,26,27,28,102,202);
   Feld4 :array[0..9] of Double =(13,14,15,16,29,30,31,32,103,203);
   Soll  :array[0..9] of T4Double = ((1,5,9,13),
                                     (2,6,10,14),
                                     (3,7,11,15),
                                     (4,8,12,16),
                                     (17,21,25,29),
                                     (18,22,26,30),
                                     (19,23,27,31),
                                     (20,24,28,32),
                                     (100,101,102,103),
                                     (200,201,202,203));

 var
  i,j :Integer;
  Res :array[0..9] of T4Double;

 begin
  Result := True;
  if Array4ToT4Double (Feld1,Feld2,Feld3,Feld4,Res) then begin
    for i := 0 to 9 do
     for j := 0 to 3 do
      if Res[i,j] <> Soll[i,j] then
        Result := False;
    end
   else
      Result := False;
end;

function TestArray3ToT4Double :Boolean;
{Set 4 double arrays to cols order.}
 const
   Feld1 :array[0..9] of Double =(1,2,3,4,17,18,19,20,100,200);
   Feld2 :array[0..9] of Double =(5,6,7,8,21,22,23,24,101,201);
   Feld3 :array[0..9] of Double =(9,10,11,12,25,26,27,28,102,202);
   Soll  :array[0..9] of T4Double = ((1,5,9,0),
                                     (2,6,10,0),
                                     (3,7,11,0),
                                     (4,8,12,0),
                                     (17,21,25,0),
                                     (18,22,26,0),
                                     (19,23,27,0),
                                     (20,24,28,0),
                                     (100,101,102,0),
                                     (200,201,202,0));

 var
  i,j :Integer;
  Flag :Boolean = False;  // set unused array to zero
  Res :array[0..9] of T4Double;

 begin
  Result := True;
  if Array3ToT4Double (Feld1,Feld2,Feld3,Res,Flag) then begin
    for i := 0 to 9 do
     for j := 0 to 3 do
      if Res[i,j] <> Soll[i,j] then
        Result := False;
    end
   else
      Result := False;
end;


function TestArrayToT4Double :Boolean;
{Set a double array to T4Double order.}
 const
   Feld :array[0..9] of Double = (1,2,3,4,5,6,7,8,9,10);
   Soll :array[0..2] of T4Double = ((1,2,3,4),(5,6,7,8),
                                    (9,10,0,0));

 var
  i,j :Integer;
  Res :array[0..2] of T4Double;
  Flag :Boolean = False; // fill incomplete T4Doubles with 0

 begin
  Result := True;
  if ArrayToT4Double(Feld,Res,Flag) then begin
    for i := 0 to 1 do
     for j := 0 to 3 do
      if Res[i,j] <> Soll[i,j] then
        Result := False;
    end
   else
      Result := False;
end;


function TestT8SingleToSingle :Boolean;
{convert from T8Single to a single array}
 const
    Soll :array[0..63] of Single = (1,5,9,13,17,21,25,29,
                                    2,6,10,14,18,22,26,30,
                                    3,7,11,15,19,23,27,31,
                                    4,8,12,16,20,24,28,32,
                                    33,37,41,45,49,53,57,61,
                                    34,38,42,46,50,54,58,62,
                                    35,39,43,47,51,55,59,63,
                                    36,40,44,48,52,56,60,64);

   Feld :array[0..7] of T8Single = ((1,5,9,13,17,21,25,29),
                                    (2,6,10,14,18,22,26,30),
                                    (3,7,11,15,19,23,27,31),
                                    (4,8,12,16,20,24,28,32),
                                    (33,37,41,45,49,53,57,61),
                                    (34,38,42,46,50,54,58,62),
                                    (35,39,43,47,51,55,59,63),
                                    (36,40,44,48,52,56,60,64));

 var
  i :Integer;
  Res : array[0..63] of Single;

 begin
  Result := True;
  if T8SingleYToSingle (Feld,Res) then begin
    for i := 0 to 63 do
     if Res[i] <> Soll[i] then
        Result := False;
    end
   else
      Result := False;
end;


function TestT8SingleTo8Single :Boolean;
 const
   Feld1 :array[0..9] of Single =(1,2,3,4,33,34,35,36,100,200);
   Feld2 :array[0..9] of Single =(5,6,7,8,37,38,39,40,101,201);
   Feld3 :array[0..9] of Single =(9,10,11,12,41,42,43,44,102,202);
   Feld4 :array[0..9] of Single =(13,14,15,16,45,46,47,48,103,203);
   Feld5 :array[0..9] of Single =(17,18,19,20,49,50,51,52,104,204);
   Feld6 :array[0..9] of Single =(21,22,23,24,53,54,55,56,105,205);
   Feld7 :array[0..9] of Single =(25,26,27,28,57,58,59,60,106,206);
   Feld8 :array[0..9] of Single =(29,30,31,32,61,62,63,64,107,207);

   Feld  :array[0..9] of T8Single = ((1,5,9,13,17,21,25,29),
                                    (2,6,10,14,18,22,26,30),
                                    (3,7,11,15,19,23,27,31),
                                    (4,8,12,16,20,24,28,32),
                                    (33,37,41,45,49,53,57,61),
                                    (34,38,42,46,50,54,58,62),
                                    (35,39,43,47,51,55,59,63),
                                    (36,40,44,48,52,56,60,64),
                                    (100,101,102,103,104,105,106,107),
                                    (200,201,202,203,204,205,206,207));


var
 i  :Integer;
 Res1,Res2,Res3,Res4,Res5,Res6,Res7,Res8 :array[0..9] of Single;

begin
 Result := True;
 if T8SingleYTo8Single(Feld,Res1,Res2,Res3,Res4,Res5,Res6,Res7,Res8) then begin
   for i := 0 to 9 do begin
       if Res1[i] <> Feld1[i] then
         Result := False;
       if Res2[i] <> Feld2[i] then
         Result := False;
       if Res3[i] <> Feld3[i] then
         Result := False;
       if Res4[i] <> Feld4[i] then
         Result := False;
       if Res5[i] <> Feld5[i] then
         Result := False;
       if Res6[i] <> Feld6[i] then
         Result := False;
       if Res7[i] <> Feld7[i] then
         Result := False;
       if Res8[i] <> Feld8[i] then
         Result := False;
     end;
  end
 else
   Result := False;
end;

function TestT8SingleTo7Single :Boolean;
const
  Feld1 :array[0..9] of Single =(1,2,3,4,33,34,35,36,100,200);
  Feld2 :array[0..9] of Single =(5,6,7,8,37,38,39,40,101,201);
  Feld3 :array[0..9] of Single =(9,10,11,12,41,42,43,44,102,202);
  Feld4 :array[0..9] of Single =(13,14,15,16,45,46,47,48,103,203);
  Feld5 :array[0..9] of Single =(17,18,19,20,49,50,51,52,104,204);
  Feld6 :array[0..9] of Single =(21,22,23,24,53,54,55,56,105,205);
  Feld7 :array[0..9] of Single =(25,26,27,28,57,58,59,60,106,206);
  Feld  :array[0..9] of T8Single = ((1,5,9,13,17,21,25,29),
                                   (2,6,10,14,18,22,26,30),
                                   (3,7,11,15,19,23,27,31),
                                   (4,8,12,16,20,24,28,32),
                                   (33,37,41,45,49,53,57,61),
                                   (34,38,42,46,50,54,58,62),
                                   (35,39,43,47,51,55,59,63),
                                   (36,40,44,48,52,56,60,64),
                                   (100,101,102,103,104,105,106,107),
                                   (200,201,202,203,204,205,206,207));

var
 i  :Integer;
 Res1,Res2,Res3,Res4,Res5,Res6,Res7 :array[0..9] of Single;

begin
 Result := True;
 if T8SingleYTo7Single(Feld,Res1,Res2,Res3,Res4,Res5,Res6,Res7) then begin
   for i := 0 to 9 do begin
       if Res1[i] <> Feld1[i] then
         Result := False;
       if Res2[i] <> Feld2[i] then
         Result := False;
       if Res3[i] <> Feld3[i] then
         Result := False;
       if Res4[i] <> Feld4[i] then
         Result := False;
       if Res5[i] <> Feld5[i] then
         Result := False;
       if Res6[i] <> Feld6[i] then
         Result := False;
       if Res7[i] <> Feld7[i] then
         Result := False;
     end;
  end
 else
   Result := False;
end;

function TestT8SingleTo6Single :Boolean;
const
  Feld1 :array[0..9] of Single =(1,2,3,4,33,34,35,36,100,200);
  Feld2 :array[0..9] of Single =(5,6,7,8,37,38,39,40,101,201);
  Feld3 :array[0..9] of Single =(9,10,11,12,41,42,43,44,102,202);
  Feld4 :array[0..9] of Single =(13,14,15,16,45,46,47,48,103,203);
  Feld5 :array[0..9] of Single =(17,18,19,20,49,50,51,52,104,204);
  Feld6 :array[0..9] of Single =(21,22,23,24,53,54,55,56,105,205);
  Feld  :array[0..9] of T8Single = ((1,5,9,13,17,21,25,29),
                                   (2,6,10,14,18,22,26,30),
                                   (3,7,11,15,19,23,27,31),
                                   (4,8,12,16,20,24,28,32),
                                   (33,37,41,45,49,53,57,61),
                                   (34,38,42,46,50,54,58,62),
                                   (35,39,43,47,51,55,59,63),
                                   (36,40,44,48,52,56,60,64),
                                   (100,101,102,103,104,105,106,107),
                                   (200,201,202,203,204,205,206,207));

var
 i  :Integer;
 Res1,Res2,Res3,Res4,Res5,Res6 :array[0..9] of Single;

begin
 Result := True;
 if T8SingleYTo6Single(Feld,Res1,Res2,Res3,Res4,Res5,Res6) then begin
   for i := 0 to 9 do begin
       if Res1[i] <> Feld1[i] then
         Result := False;
       if Res2[i] <> Feld2[i] then
         Result := False;
       if Res3[i] <> Feld3[i] then
         Result := False;
       if Res4[i] <> Feld4[i] then
         Result := False;
       if Res5[i] <> Feld5[i] then
         Result := False;
       if Res6[i] <> Feld6[i] then
         Result := False;
     end;
  end
 else
   Result := False;
end;

function TestT8SingleTo5Single :Boolean;
const
  Feld1 :array[0..9] of Single =(1,2,3,4,33,34,35,36,100,200);
  Feld2 :array[0..9] of Single =(5,6,7,8,37,38,39,40,101,201);
  Feld3 :array[0..9] of Single =(9,10,11,12,41,42,43,44,102,202);
  Feld4 :array[0..9] of Single =(13,14,15,16,45,46,47,48,103,203);
  Feld5 :array[0..9] of Single =(17,18,19,20,49,50,51,52,104,204);
  Feld  :array[0..9] of T8Single = ((1,5,9,13,17,21,25,29),
                                   (2,6,10,14,18,22,26,30),
                                   (3,7,11,15,19,23,27,31),
                                   (4,8,12,16,20,24,28,32),
                                   (33,37,41,45,49,53,57,61),
                                   (34,38,42,46,50,54,58,62),
                                   (35,39,43,47,51,55,59,63),
                                   (36,40,44,48,52,56,60,64),
                                   (100,101,102,103,104,105,106,107),
                                   (200,201,202,203,204,205,206,207));

var
 i  :Integer;
 Res1,Res2,Res3,Res4,Res5 :array[0..9] of Single;

begin
 Result := True;
 if T8SingleYTo5Single(Feld,Res1,Res2,Res3,Res4,Res5) then begin
   for i := 0 to 9 do begin
       if Res1[i] <> Feld1[i] then
         Result := False;
       if Res2[i] <> Feld2[i] then
         Result := False;
       if Res3[i] <> Feld3[i] then
         Result := False;
       if Res4[i] <> Feld4[i] then
         Result := False;
       if Res5[i] <> Feld5[i] then
         Result := False;
     end;
  end
 else
   Result := False;
end;

function TestT4DoubleTo4Double :Boolean;
{convert from T4Double to 4 double arrays}
 const
   Feld1 :array[0..9] of Double =(1,2,3,4,17,18,19,20,100,200);
   Feld2 :array[0..9] of Double =(5,6,7,8,21,22,23,24,101,201);
   Feld3 :array[0..9] of Double =(9,10,11,12,25,26,27,28,102,202);
   Feld4 :array[0..9] of Double =(13,14,15,16,29,30,31,32,103,203);

   Feld  :array[0..9] of T4Double = ((1,5,9,13),
                                     (2,6,10,14),
                                     (3,7,11,15),
                                     (4,8,12,16),
                                     (17,21,25,29),
                                     (18,22,26,30),
                                     (19,23,27,31),
                                     (20,24,28,32),
                                     (100,101,102,103),
                                     (200,201,202,203));

 var
  i  :Integer;
  Res1 :array[0..9] of Double;
  Res2 :array[0..9] of Double;
  Res3 :array[0..9] of Double;
  Res4 :array[0..9] of Double;

 begin
  Result := True;
  if T4DoubleTo4Double(Feld,Res1,Res2,Res3,Res4) then begin
    for i := 0 to 9 do begin
     if Res1[i] <> Feld1[i] then
        Result := False;
     if Res2[i] <> Feld2[i] then
       Result := False;
     if Res3[i] <> Feld3[i] then
       Result := False;
     if Res4[i] <> Feld4[i] then
       Result := False;
    end;
    end
   else
      Result := False;
end;

function TestT4DoubleTo3Double :Boolean;
{convert from T4Double to 3 double arrays}
 const
   Feld1 :array[0..9] of Double =(1,2,3,4,17,18,19,20,100,200);
   Feld2 :array[0..9] of Double =(5,6,7,8,21,22,23,24,101,201);
   Feld3 :array[0..9] of Double =(9,10,11,12,25,26,27,28,102,202);
   Feld  :array[0..9] of T4Double = ((1,5,9,13),
                                     (2,6,10,14),
                                     (3,7,11,15),
                                     (4,8,12,16),
                                     (17,21,25,29),
                                     (18,22,26,30),
                                     (19,23,27,31),
                                     (20,24,28,32),
                                     (100,101,102,103),
                                     (200,201,202,203));

 var
  i  :Integer;
  Res1 :array[0..9] of Double;
  Res2 :array[0..9] of Double;
  Res3 :array[0..9] of Double;

 begin
  Result := True;
  if T4DoubleTo3Double(Feld,Res1,Res2,Res3) then begin
    for i := 0 to 9 do begin
     if Res1[i] <> Feld1[i] then
        Result := False;
     if Res2[i] <> Feld2[i] then
       Result := False;
     if Res3[i] <> Feld3[i] then
       Result := False;
    end;
   end
  else
      Result := False;
end;


function TestT4DoubleToDouble :Boolean;
{convert from T4Double to a double array}
 const
   SollFeld :array[0..11] of Double =(1,2,3,4,5,6,7,8,9,10,11,0);
   Feld :array[0..2] of T4Double = ((1,2,3,4),(5,6,7,8),
                                    (9,10,11,0));
 var
  i   :Integer;
  Erg :array[0..11] of Double;

 begin
  Result := True;
  if T4DoubleToDouble(Feld,Erg) then begin
    for i := 0 to 11 do
     if Erg[i] <> SollFeld[i] then
        Result := False;
   end
  else Result := False;
end;


function TestSetValueYSingle :Boolean;
{Set a const value to T8Single array. You can fill the array with
 this value.}
 const
   Value :Single = 100.0;

 var
  i,j  :Integer;
  Feld :array[0..1] of T8Single;

 begin
  Result := True;
  SetValueYSingle(Feld,Value);
  for i := 0 to 1 do
    for j := 0 to 7 do
     if Feld[i,j] <> Value then
        Result := False;
end;


function TestSetValueYPlaceSingle :Boolean;
{set a const value on a T8Single array on definite place. (cols 1..8)}
 const
   Value :Single = 100.0;
   Value1:Single = 6.0;

 var
  i,j  :Integer;
  Feld :array[0..1] of T8Single;

 begin
  Result := True;
  // first fiill the array with 100
  SetValueYSingle(Feld,Value);
  j := 1;  // place = 1 start with zero
  SetValuePlaceYSingle(Feld,Value1,j);
  for i := 0 to 1 do
    if Feld[i,j] <> Value1 then
        Result := False;
end;

function TestSetValueYDouble :Boolean;
{Set a const value on T4Double array. You can fill the array with this value.}
 const
   Value :Double = 100.0;

 var
  i,j  :Integer;
  Feld :array[0..1] of T4Double;

 begin
  Result := True;
  SetValueYDouble(Feld,Value);
  for i := 0 to 1 do
    for j := 0 to 3 do
     if Feld[i,j] <> Value then
        Result := False;
end;

function TestSetValueYPlaceDouble :Boolean;
{Set the value on a definite place in a T4Double array.}
 const
   Value :Single = 0.0;
   Value1:Single = 6.0;

 var
  i,j  :Integer;
  Feld :array[0..1] of T4Double;

 begin
  Result := True;
  SetValueYDouble(Feld,Value);
  j := 1;  // Place = 1 start with zero.
  SetValuePlaceYDouble(Feld,Value1,j);
  for i := 0 to 1 do
     if Feld[i,j] <> Value1 then
        Result := False;
end;


{-------------------addition-----------------------------------------------}


function TestSumVYSingle :Boolean;
{Sum of 8 array cols of the 8 arrays}
 const
   Soll  :T8Single =(148,180,212,244,276,308,340,372);
   Feld1 :array[0..7] of Single =(1,2,3,4,33,34,35,36);
   Feld2 :array[0..7] of Single =(5,6,7,8,37,38,39,40);
   Feld3 :array[0..7] of Single =(9,10,11,12,41,42,43,44);
   Feld4 :array[0..7] of Single =(13,14,15,16,45,46,47,48);
   Feld5 :array[0..7] of Single =(17,18,19,20,49,50,51,52);
   Feld6 :array[0..7] of Single =(21,22,23,24,53,54,55,56);
   Feld7 :array[0..7] of Single =(25,26,27,28,57,58,59,60);
   Feld8 :array[0..7] of Single =(29,30,31,32,61,62,63,64);

 var
  i    :Integer;
  Res  :T8Single;
  Res0 :array[0..7] of T8Single;

begin
 Result := True;
 {change the arrays in cols order and we add 8 arrays to 1 result of 8 cols.}
 if Array8ToT8Single(Feld1,Feld2,Feld3,Feld4,Feld5,Feld6,Feld7,Feld8,Res0) then
   begin
   Res := SumVYSingle(Res0);
   for i := 0 to 7 do
     if Res[i] <> Soll[i] then
        Result := False;
  end
  else result := False;
end;


function TestAddVYSingle :Boolean;
{add the array cols to a single result for the col.}
 const
   Soll  :array[0..7] of Single =(120,128,136,144,376,384,392,400);
   Feld1 :array[0..7] of Single =(1,2,3,4,33,34,35,36);
   Feld2 :array[0..7] of Single =(5,6,7,8,37,38,39,40);
   Feld3 :array[0..7] of Single =(9,10,11,12,41,42,43,44);
   Feld4 :array[0..7] of Single =(13,14,15,16,45,46,47,48);
   Feld5 :array[0..7] of Single =(17,18,19,20,49,50,51,52);
   Feld6 :array[0..7] of Single =(21,22,23,24,53,54,55,56);
   Feld7 :array[0..7] of Single =(25,26,27,28,57,58,59,60);
   Feld8 :array[0..7] of Single =(29,30,31,32,61,62,63,64);

 var
  i    :Integer;
  Res  :array[0..7] of Single;
  Res0 :array[0..7] of T8Single;

begin
 Result := True;
 {set the 8 cols to on T8single array for calculation}
 if Array8ToT8Single(Feld1,Feld2,Feld3,Feld4,Feld5,Feld6,Feld7,Feld8,Res0) then
   begin
   if AddVYSingle(Res0,Res) then begin
     for i := 0 to 7 do
      if Res[i] <> Soll[i] then
        Result := False;
  end
   else Result := false;
  end
  else Result := False;
end;

function TestAdd4VYSingle :Boolean;
{addition of 4 array pairs}
 const
   Soll  :array[0..7] of T4Single = ((6,22,38,54),
                                     (8,24,40,56),
                                     (10,26,42,58),
                                     (12,28,44,60),
                                     (70,86,102,118),
                                     (72,88,104,120),
                                     (74,90,106,122),
                                     (76,92,108,124));
   {add Feld1 and Feld2,Feld3 and Feld4, Feld5 and Feld6, Feld7 and Feld8}
   Feld1 :array[0..7] of Single =(1,2,3,4,33,34,35,36);
   Feld2 :array[0..7] of Single =(5,6,7,8,37,38,39,40);
   Feld3 :array[0..7] of Single =(9,10,11,12,41,42,43,44);
   Feld4 :array[0..7] of Single =(13,14,15,16,45,46,47,48);
   Feld5 :array[0..7] of Single =(17,18,19,20,49,50,51,52);
   Feld6 :array[0..7] of Single =(21,22,23,24,53,54,55,56);
   Feld7 :array[0..7] of Single =(25,26,27,28,57,58,59,60);
   Feld8 :array[0..7] of Single =(29,30,31,32,61,62,63,64);

 var
  i,j    :Integer;
  Res  :array[0..7] of T4Single;
  Res0 :array[0..7] of T8Single;

begin
 Result := True;
 // all 8 arrays in cols order as T8Single array
 if Array8ToT8Single(Feld1,Feld2,Feld3,Feld4,Feld5,Feld6,Feld7,Feld8,Res0) then
   begin
   if Add4VYSingle(Res0,Res) then begin
     for i := 0 to 7 do
      for j := 0 to 3 do
      if Res[i,j] <> Soll[i,j] then
        Result := False;
  end
   else Result := False;
  end
  else Result := False;
end;

function TestAddYSingle :Boolean;
{Res = Feld1 + Feld2}
 const
   Soll  :array[0..1] of T8Single = ((6,8,10,12,70,72,74,76),
                                     (90,92,94,96,98,100,102,104));
   Feld1 :array[0..1] of T8Single = ((1,2,3,4,33,34,35,36),
                                     (41,42,43,44,45,46,47,48));
   Feld2 :array[0..1] of T8Single = ((5,6,7,8,37,38,39,40),
                                     (49,50,51,52,53,54,55,56));

 var
  i,j  :Integer;
  Res  :array[0..1] of T8Single;

begin
 Result := True;
 if AddYSingle(Feld1,Feld2,Res) then begin
   for i := 0 to 1 do
     for j := 0 to 7 do
      if Res[i,j] <> Soll[i,j] then
        Result := False;
  end
  else Result := False;
end;


function TestAdd2TabYSingle :Boolean;
{add two tables with equal cols.}
 const
   Soll :array[0..0] of T8Single = ((3,7,11,15,67,71,75,79));

 var
  i    :Integer;
  Res  :array[0..0] of T8Single;
  Tab1 :array[0..0] of T8Single = ((1,2,3,4,33,34,35,36));
  Tab2 :array[0..0] of T8Single = ((5,6,7,8,37,38,39,40));

begin
 Result := True;
 if Add2TabYSingle(Tab1,Tab2,Res) then begin
   for i := 0 to 7 do
     if Res[0,i] <> Soll[0,i] then
        Result := False;
  end
 else Result := False;
end;

function TestAddValueYSingle :Boolean;
{add a constant value to array fields.}
 const
   Value :Single = 100.0;
   Soll :array[0..1] of T8Single = ((101,102,103,104,133,134,135,136),
                                    (137,138,139,140,141,142,143,144));

 var
  i,j :Integer;
  Res :array[0..1] of T8Single;
  Feld :array[0..1] of T8Single = ((1,2,3,4,33,34,35,36),
                                   (37,38,39,40,41,42,43,44));

begin
 Result := True;
 if AddValueYSingle(Feld,Res,Value) then begin
   for i := 0 to 1 do
     for j := 0 to 7 do
       if Res[i,j] <> Soll[i,j] then
         Result := False;
  end
 else Result := False;
end;

function TestAddValueYSingle1 :Boolean;
{add a constant value to array fields.}
 const
   Value :Single = 100.0;
   Soll :array[0..1] of T8Single = ((101,102,103,104,133,134,135,136),
                                    (137,138,139,140,141,142,143,144));

 var
  i,j :Integer;
  Feld :array[0..1] of T8Single = ((1,2,3,4,33,34,35,36),
                                   (37,38,39,40,41,42,43,44));

begin
 Result := True;
 AddValueYSingle(Feld,Value);
   for i := 0 to 1 do
     for j := 0 to 7 do
       if Feld[i,j] <> Soll[i,j] then
         Result := False;
end;


function TestSumMinMaxYSingle :Boolean;
{calculate the sum,min and max of the array fields}
 const
   Feld :array[0..0] of T8Single = ((41,43,39,42,42,44,41,36));
   Sollsum :Single = 328;
   Sollmin :Single = 36;
   Sollmax :Single = 44;

 var
  sum,min,max :Single;

begin
  Result := True;
  SumMinMaxYSingle(Feld,Sum,Min,Max);
  if sum <> Sollsum then
     Result := False;
  if min <> Sollmin then
    Result := False;
  if max <> Sollmax then
    Result := False;
end;


function TestSumVYDouble :Boolean;
{sum the array cols}
 const
   Feld  :array[0..7] of T4Double = ((6,22,38,54),
                                     (8,24,40,56),
                                     (10,26,42,58),
                                     (12,28,44,60),
                                     (70,86,102,118),
                                     (72,88,104,120),
                                     (74,90,106,122),
                                     (76,92,108,124));
   Soll :T4Double = (328,456,584,712);

 var
  i :Integer;
  Res :T4Double;

begin
 Result := True;
 Res := SumVYDouble(Feld);
 for i := 0 to 3 do
   if Res[i] <> Soll[i] then
        Result := False;
end;

function TestAddYDouble :Boolean;
{Res = Feld1 + Feld2}
 const
   Soll  :array[0..0] of T4Double = ((6,8,10,12));
   Feld1 :array[0..0] of T4Double = ((1,2,3,4));
   Feld2 :array[0..0] of T4Double = ((5,6,7,8));

 var
  i   :Integer;
  Res :T4Double;

begin
 Result := True;
 if AddYDouble(Feld1,Feld2,Res) then begin
   for i := 0 to 3 do
     if Res[i] <> Soll[0,i] then
          Result := False;
   end
  else Result := False;
end;

function TestAdd2VYDouble :Boolean;
{add two array pairs (x1y1,x2,y2,...)}
 const
   Soll  :array[0..5] of T2Double = ((10,24),
                                     (12,26),
                                     (14,28),
                                     (16,30),
                                     (18,32),
                                     (20,34));
   Feld1 :array[0..5] of Double = (1,2,3,4,5,6);
   Feld2 :array[0..5] of Double = (9,10,11,12,13,14);
   Feld3 :array[0..5] of Double = (15,16,17,18,19,20);
   Feld4 :array[0..5] of Double = (9,10,11,12,13,14);


 var
  i,j  :Integer;
  Res0 :array[0..5] of T4Double;
  Res  :array[0..5] of T2Double;

begin
 Result := True;
 // make the T4Double array from Feld1,Feld2,Feld3,Feld4
 if Array4ToT4Double(Feld1,Feld2,Feld3,Feld4,Res0) then begin
   if Add2VYDouble(Res0,Res) then begin
     for i := 0 to 5 do
       for j := 0 to 1 do
         if Res[i,j] <> Soll[i,j] then
           Result := False;
     end
   else Result := False;
  end
 else result := False;
end;

function TestAddVYDouble :Boolean;
{add up to 4 array cols to one single col result}
 const
   Soll  :array[0..4] of Double =(28,32,36,40,156);
   Feld1 :array[0..4] of Double =(1,2,3,4,33);
   Feld2 :array[0..4] of Double =(5,6,7,8,37);
   Feld3 :array[0..4] of Double =(9,10,11,12,41);
   Feld4 :array[0..4] of Double =(13,14,15,16,45);


 var
  i :Integer;
  Res0 :array[0..4] of T4Double;
  Res  :array[0..4] of Double;

begin
 Result := True;
 if Array4ToT4Double(Feld1,Feld2,Feld3,Feld4,Res0) then begin
   if AddVYDouble(Res0,Res) then begin
     for i := 0 to 4 do
       if Res[i] <> Soll[i] then
         Result := False;
    end
   else Result := False;
  end
 else Result := False;
end;


function TestAdd2TabYDouble :Boolean;
{add 2 tables with equal count of cols}
 const
   Soll :array[0..0] of T4Double = ((3,11,7,15));
   Tab1 :array[0..0] of T4Double = ((1,2,3,4));
   Tab2 :array[0..0] of T4double = ((5,6,7,8));

 var
  j :Integer;
  Res :array[0..0] of T4Double;

begin
 Result := True;
 if Add2TabYDouble(Tab1,Tab2,Res) then begin
   for j := 0 to 3 do
     if Res[0,j] <> Soll[0,j] then
          Result := False;
  end
  else Result := False;
end;

function TestAddValueYDouble :Boolean;
{add a const value to the array fields}
 const
   Value = 100.0;
   Soll :array[0..1] of T4Double = ((101,102,103,104),(105,106,107,108));

 var
  i,j  :Integer;
  Res  :array[0..1] of T4Double;
  Feld :array[0..1] of T4Double = ((1,2,3,4),(5,6,7,8));

begin
 Result := True;
 if AddValueYDouble(Feld,Res,Value) then begin
   for i := 0 to 1 do
     for j := 0 to 3 do
       if Res[i,j] <> Soll[i,j] then
         Result := False;
  end
 else Result := False;
end;

function TestAddValueYDouble1 :Boolean;
{add a const value to the array fields}
 const
   Value = 100.0;
   Soll :array[0..1] of T4Double = ((101,102,103,104),(105,106,107,108));

 var
  i,j  :Integer;
  Feld :array[0..1] of T4Double = ((1,2,3,4),(5,6,7,8));

begin
 Result := True;
 AddValueYDouble(Feld,Value);
   for i := 0 to 1 do
     for j := 0 to 3 do
       if Feld[i,j] <> Soll[i,j] then
         Result := False;
end;

function TestSumMinMaxYDouble :Boolean;
{calculate the sum,min and max of the array fields.}
 const
   Feld :array[0..2] of T4Double = ((41,43,39,42),
                                    (42,44,41,36),
                                    (32,35,45,31));
   Sollsum :Double = 471;
   Sollmin :Double = 31;
   Sollmax :Double = 45;

 var
  sum,min,max :Double;

begin
  Result := True;
  SumMinMaxYDouble(Feld,Sum,Min,Max);
  if sum <> Sollsum then
     Result := False;
  if min <> Sollmin then
    Result := False;
  if max <> Sollmax then
    Result := False;
end;

function TestSumMinMaxVYSingle :Boolean;
{Calculate the sum,min and max values for 5 and up to 8 arrays simultaneous.
 When < 5 arrays use the xmm unit.}
 const
   Zn :array[1..13] of Single = (41.1,43.3,39.2,42.3,42.8,44.8,41.5,36.6,
                                 32.9,35.4,45.5,31.8,42.0);
   Cd :array[1..13] of Single = (0.04,0.03,0.04,0.05,0.04,0.04,0.03,0.03,
                                 0.04,0.08,0.06,0.05,0.04);
   Pb :array[1..13] of Single = (0.18,0.17,0.16,0.20,0.14,0.24,0.19,0.14,
                                 0.12,0.22,0.17,0.17,0.12);
   Cu :array[1..13] of Single = (5.1,4.4,5.5,5.0,4.9,5.0,4.6,4.6,5.6,3.8,
                                 6.5,4.1,5.7);
   Fe :array[1..13] of Single = (1,6,8,5,3,10,3,7,8,2,9,2,7);
   Sollsum :T8Single = (519.20,0.57,2.22,64.80,71.00,0,0,0);
   Sollmin :T8Single = (31.80,0.03,0.12,3.80,1,0,0,0);
   Sollmax :T8Single = (45.50,0.08,0.24,6.50,10,0,0,0);
                      //  Zn   Cd   Pb   Cu  Fe
 var
  Res0 :array[0..12] of T8Single;
  sum,min,max :T8Single;
  Flag :Boolean = False;  // set unused arrays to zero
  i :Integer;

begin
  Result := True;
  {Set arrays in cols order.}
  if Array5ToT8Single(Zn,Cd,Pb,Cu,Fe,Res0,Flag) then begin
    SumMinMaxVYSingle(Res0,sum,min,max);
    for i := 0 to 7 do begin
      if SimpleRoundTo(sum[i],-2) <> Sollsum[i] then
       Result := False;
      if SimpleRoundTo(min[i],-2) <> Sollmin[i] then
       Result := False;
      if SimpleRoundTo(max[i],-2) <> Sollmax[i] then
       Result := False;
    end;
  end;
end;

function TestSumMinMaxVYDouble :Boolean;
{see upper for 3 or 4 arrays, when < 3 arrays use the xmm unit.}
 const
   Zn :array[1..13] of Double = (41.1,43.3,39.2,42.3,42.8,44.8,41.5,36.6,
                                 32.9,35.4,45.5,31.8,42.0);
   Cd :array[1..13] of Double = (0.04,0.03,0.04,0.05,0.04,0.04,0.03,0.03,
                                 0.04,0.08,0.06,0.05,0.04);
   Pb :array[1..13] of Double = (0.18,0.17,0.16,0.20,0.14,0.24,0.19,0.14,
                                 0.12,0.22,0.17,0.17,0.12);
   Cu :array[1..13] of Double = (5.1,4.4,5.5,5.0,4.9,5.0,4.6,4.6,5.6,3.8,
                                 6.5,4.1,5.7);
   Sollsum :T4Double = (519.20,0.57,2.22,64.80);
   Sollmin :T4Double = (31.80,0.03,0.12,3.80);
   Sollmax :T4Double = (45.50,0.08,0.24,6.50);
                       // Zn   Cd    Pb  Cu
 var
  Res0 :array[0..12] of T4Double;
  sum,min,max :T4Double;
  i :Integer;

begin
  Result := True;
  if Array4ToT4Double(Zn,Cd,Pb,Cu,Res0) then begin
    SumMinMaxVYDouble(Res0,sum,min,max);
    for i := 0 to 3 do begin
      if SimpleRoundTo(sum[i],-2) <> Sollsum[i] then
       Result := False;
      if SimpleRoundTo(min[i],-2) <> Sollmin[i] then
       Result := False;
      if SimpleRoundTo(max[i],-2) <> Sollmax[i] then
       Result := False;
    end;
  end;
end;



{---------------------------subtract----------------------------------------}


function TestSubYSingle :Boolean;
{Res = Feld1 - Feld2}
 const
   Soll  :array[0..0] of T8Single = ((1,2,9,10,-8,46,55,64));
   Feld1 :array[0..0] of T8Single = ((10,12,20,22,5,60,70,80));
   Feld2 :array[0..0] of T8Single = ((9,10,11,12,13,14,15,16));

 var
  j :Integer;
  Res :array[0..0] of T8Single;

begin
 Result := True;
 if SubYSingle(Feld1,Feld2,Res) then begin
   for j := 0 to 7 do
     if Res[0,j] <> Soll[0,j] then
           Result := False;
  end
  else Result := False;
end;

function TestSubDivValueYSingle :Boolean;
{Res = Feld1 - Feld2/Value}
 const
   Feld1 :array[0..0] of T8Single = ((10,12,20,22, 5,60,70,80));
   Feld2 :array[0..0] of T8Single = (( 0,10,10,12,13,14,10,16));
   Soll  :array[0..0] of T8Single = (( 5, 1, 5, 5,-4,23,30,32));
   Value :Single = 2.0;

 var
  j :Integer;
  Res :array[0..0] of T8Single;

begin
 Result := True;
 if SubdivValueYSingle(Feld1,Feld2,Res,Value) then begin
   for j := 0 to 7 do
     if Res[0,j] <> Soll[0,j] then
           Result := False;
  end
  else Result := False;
end;


function TestMulDiffYSingle :Boolean;
 {Res = Feld1 * (Feld2 - Feld3)}
 const
   Feld1 :array[0..1] of T8Single = ((10,12,20,22,5,60,70,80),
                                     (81,82,83,83,85,86,87,88));
   Feld2 :array[0..1] of T8Single = ((9,10,11,12,13,14,15,16),
                                     (17,18,19,20,21,22,23,24));
   Feld3 :array[0..1] of T8Single = ((1,2,3,4,5,6,7,8),
                                     (9,10,11,12,13,14,15,16));
   Soll  :array[0..1] of T8Single = ((80,96,160,176,40,480,560,640),
                                     (648,656,664,664,680,688,696,704));

 var
  i,j :Integer;
  Res :array[0..1] of T8Single;

begin
 Result := True;
 if MulDiffYSingle(Feld1,Feld2,Feld3,Res) then begin
   for i := 0 to 1 do
     for j := 0 to 7 do
       if Res[i,j] <> Soll[i,j] then
         Result := False;
  end
  else Result := False;
end;

function TestSumMulDiffYSingle :Boolean;
 {Res = Sum(Feld1 * (Feld2 - Feld3))}
 const
   Feld1 :array[0..1] of T8Single = ((10,12,20,22,5,60,70,80),
                                     (81,82,83,83,85,86,87,88));
   Feld2 :array[0..1] of T8Single = ((9,10,11,12,13,14,15,16),
                                     (17,18,19,20,21,22,23,24));
   Feld3 :array[0..1] of T8Single = ((1,2,3,4,5,6,7,8),
                                     (9,10,11,12,13,14,15,16));
   Soll  :Single = 7632;

 var
  Res :Single;

begin
 Result := True;
 if SumMulDiffYSingle(Feld1,Feld2,Feld3,Res) then begin
   if Res <> Soll then
     Result := False;
  end
 else Result := False;
end;

function TestMaxAbsMulDiffYSingle :Boolean;
 {Res = Max(1,n(Feld1 * (Feld2 - Feld3)))}
 const
   Feld1 :array[0..1] of T8Single = ((10,12,20,22,5,60,70,80),
                                     (81,82,83,83,85,86,87,88));
   Feld2 :array[0..1] of T8Single = ((9,10,11,12,13,14,15,16),
                                     (17,18,19,20,21,22,23,24));
   Feld3 :array[0..1] of T8Single = ((1,2,3,4,5,6,7,8),
                                     (9,10,11,12,13,14,15,16));
   Soll  :Single = 704;

 var
  Res :Single;

begin
 Result := True;
 Res := MaxAbsMulDiffYSingle(Feld1,Feld2,Feld3);
   if Res <> Soll then
     Result := False;
end;


function TestSub4VYSingle :Boolean;
 {subtract 4 array pairs x1-y1,x2-y2,...x4-y4 result is array of T4Single}
 const
   Feld1 :array[0..7] of Single =(10,20,30,40,43,54,65,86);
   Feld2 :array[0..7] of Single =(5,6,7,8,37,38,39,40);
   Feld3 :array[0..7] of Single =(90,16,11,12,48,62,73,64);
   Feld4 :array[0..7] of Single =(13,14,15,16,45,46,47,48);
   Feld5 :array[0..7] of Single =(91,17,12,13,50,61,57,58);
   Feld6 :array[0..7] of Single =(13,14,15,16,45,46,47,48);
   {For 3 array pairs yo need 6 arrays}
   Soll  :array[0..7] of T4Single = ((5,77,78,0),
                                     (14,2,3,0),
                                     (23,-4,-3,0),
                                     (32,-4,-3,0),
                                     (6,3,5,0),
                                     (16,16,15,0),
                                     (26,26,10,0),
                                     (46,16,10,0));

 var
  i,j  :Integer;
  Flag :Boolean = False;   // set 0.0 in unused arrays 5,6,7,8)
  Res0 :array[0..7] of T8Single;
  Res  :array[0..7] of T4Single; // xmm array

begin
 Result := True;
 if Array6ToT8Single(Feld1,Feld2,Feld3,Feld4,Feld5,Feld6,Res0,Flag) then begin
   if Sub4VYSingle(Res0,Res) then begin
     for i := 0 to 7 do
      for j := 0 to 3 do
       if Res[i,j] <> Soll[i,j] then
         Result := False;
    end
   else Result := False;
  end
 else Result := False;
end;


function TestSub2TabYSingle :Boolean;
{subtract 2 array pairs with equal cols}
 const
   Soll :array[0..0] of T8Single = ((10,5,49,62,-1,-4,1,-3));
   Tab1 :array[0..0] of T8Single = ((20,10,40,35,33,34,35,39));
   Tab2 :array[0..0] of T8Single = ((55,6,70,8,39,38,39,42));

 var
  i   :Integer;
  Res :array[0..0] of T8Single;

begin
 Result := True;
 if Sub2TabYSingle(Tab1,Tab2,Res) then begin
   for i := 0 to 7 do
     if Res[0,i] <> Soll[0,i] then
       Result := False;
    end
 else Result := False;
end;


function TestSubYDouble :Boolean;
{Res = Feld1 - Feld2}
 const
   Soll  :array[0..0] of T4Double = ((10,40,0,-1));
   Feld1 :array[0..0] of T4Double = ((30,50,40,34));
   Feld2 :array[0..0] of T4Double = ((20,10,40,35));

 var
  i   :Integer;
  Res :array[0..0] of T4Double;

begin
 Result := True;
 if SubYDouble(Feld1,Feld2,Res) then begin
   for i := 0 to 3 do
    if Res[0,i] <> Soll[0,i] then
      Result := False;
  end
 else Result := False;
end;


function TestSubDivValueYDouble :Boolean;
{Res = Feld1 - Feld2/Value}
 const
   Feld1 :array[0..1] of T4Double = ((10,12,20,22),( 5,60,70,80));
   Feld2 :array[0..1] of T4Double = (( 0,10,10,12),(13,14,10,16));
   Soll  :array[0..1] of T4Double = (( 5, 1, 5, 5),(-4,23,30,32));
   Value :Double = 2.0;

 var
  i,j :Integer;
  Res :array[0..1] of T4Double;

begin
 Result := True;
 if SubDivValueYDouble(Feld1,Feld2,Res,Value) then begin
   for i := 0 to 1 do
     for j := 0 to 3 do
       if Res[0,j] <> Soll[0,j] then
         Result := False;
   end
  else Result := False;
end;

function TestMulDiffYDouble :Boolean;
 {Res = Feld1 * (Feld2 - Feld3)}
 const
   Feld1 :array[0..1] of T4Double = ((10,12,20,22),(5,60,70,80));
   Feld2 :array[0..1] of T4Double = ((9,10,11,12),(13,14,15,16));
   Feld3 :array[0..1] of T4Double = ((1,2,3,4),(5,6,7,8));
   Soll  :array[0..1] of T4Double = ((80,96,160,176),(40,480,560,640));

 var
  i,j :Integer;
  Res :array[0..1] of T4Double;

begin
 Result := True;
 if MulDiffYDouble(Feld1,Feld2,Feld3,Res) then begin
   for i := 0 to 1 do
     for j := 0 to 3 do
       if Res[i,j] <> Soll[i,j] then
         Result := False;
  end
  else Result := False;
end;

function TestSumMulDiffYDouble :Boolean;
 {Res = Sum(Feld1 * (Feld2 - Feld3))}
 const
   Feld1 :array[0..1] of T4Double = ((10,12,20,22),(5,60,70,80));
   Feld2 :array[0..1] of T4Double = ((9,10,11,12),(13,14,15,16));
   Feld3 :array[0..1] of T4Double = ((1,2,3,4),(5,6,7,8));
   Soll  :Double = 2232;

 var
  Res :Double;

begin
 Result := True;
 if SumMulDiffYDouble(Feld1,Feld2,Feld3,Res) then begin
   if Res <> Soll then
     Result := False;
  end
  else Result := False;
end;

function TestMaxAbsMulDiffYDouble :Boolean;
 {Res = Max(1,n(Feld1 * (Feld2 - Feld3)))}
 const
   Feld1 :array[0..1] of T4Double = ((10,12,20,22),(5,60,70,80));
   Feld2 :array[0..1] of T4Double = ((9,10,11,12),(13,14,15,16));
   Feld3 :array[0..1] of T4Double = ((1,2,3,4),(5,6,7,8));
   Soll  :Double = 640;

 var
  Res :Double;

begin
 Result := True;
 Res := MaxAbsMulDiffYDouble(Feld1,Feld2,Feld3);
 if Res <> Soll then
   Result := False;
end;

function TestSub2VYDouble :Boolean;
{subtract 2 array pairs feld1 - Feld2 and Feld3 - feld4}
 const
   Soll  :array[0..7] of T2Double = ((-9,5),
                                     (-18,14),
                                     (-27,23),
                                     (-36,32),
                                     (-45,41),
                                     (-54,50),
                                     (-63,59),
                                     (-72,68));
   Feld1 :array[0..7] of Double = (1,  2, 3, 4, 5, 6, 7, 8);
   Feld2 :array[0..7] of Double = (10,20,30,40,50,60,70,80);
   Feld3 :array[0..7] of Double = (10,20,30,40,50,60,70,80);
   Feld4 :array[0..7] of Double = (5,  6, 7, 8, 9,10,11,12);

 var
  i,j  :Integer;
  Res0 :array[0..7] of T4Double;
  Res  :array[0..7] of T2Double;

begin
 Result := True;
 // set the 4 arrays in cols order
 if Array4ToT4Double(Feld1,Feld2,Feld3,Feld4,Res0) then begin
   if Sub2VYDouble(Res0,Res) then begin
     for i := 0 to 7 do
       for j := 0 to 1 do
         if Res[i,j] <> Soll[i,j] then
           Result := False;
    end
   else Result := False;
  end
 else Result := false;
end;

function TestSub2TabYDouble :Boolean;
{subtract 2 tables with equal count of cols}
 const
   Soll  :array[0..0] of T4Double = ((40,20,35,-7));
   Tab1  :array[0..0] of T4Double = ((50,10,40,5));
   Tab2  :array[0..0] of T4Double = ((40,20,35,42));

 var
  i,j :Integer;
  Res :array[0..0] of T4Double;

begin
 Result := True;
 if Sub2TabYDouble(Tab1,Tab2,Res) then begin
 for i := 0 to 0 do
   for j := 0 to 3 do
     if Res[i,j] <> Soll[i,j] then
      Result := False;
  end
 else Result := False;
end;


{------------------------add and sub--------------------------------------}

function TestAddSubYSingle :Boolean;
{add odd array cols and sub even array cols}
 const
   Feld1 :array[0..0] of T8Single = ((10,20,30,40,50,60,70,80));
   Feld2 :array[0..0] of T8Single = (( 5,10,15,20,25,30,35,40));
   Soll  :array[0..0] of T8Single = (( 5,30,15,60,25,90,35,120));
                                    // ^sub    ^add
 var
  i,j :Integer;
  Res :array[0..0] of T8Single;

begin
 Result := True;
 if AddSubYSingle(Feld1,Feld2,Res) then begin
  for i := 0 to 0 do
    for j := 0 to 7 do
      if Res[i,j] <> Soll[i,j] then
       Result := False;
  end
 else Result := False;
end;

function TestAddSubValueYSingle :Boolean;
{Add const value to odd array cols sub const value on even array cols}
 const
   Soll  :array[0..0] of T8Single = ((-50,110,-60,105,-6,120,-65,142));
   Value :Single = 100.0;

 var
  i,j  :Integer;
  Feld :array[0..0] of T8Single = (( 50, 10, 40,  5,40, 20, 35, 42));

begin
 Result := True;
 AddSubValueYSingle(Feld,Value);
 for i := 0 to 0 do
   for j := 0 to 3 do
     if Feld[i,j] <> Soll[i,j] then
       Result := False;
end;

function TestAddSubYDouble :Boolean;
{add odd array cols and sub even array cols}
 const
   Feld1 :array[0..1] of T4Double = ((10,20,30,40),(50,60,70,80));
   Feld2 :array[0..1] of T4Double = (( 5,10,15,20),(25,30,35,40));
   Soll  :array[0..1] of T4Double = (( 5,30,15,60),(25,90,35,120));

 var
  i,j :Integer;
  Res :array[0..1] of T4Double;

begin
 Result := True;
 if AddSubYDouble(Feld1,Feld2,Res) then begin
  for i := 0 to 1 do
    for j := 0 to 3 do
      if Res[i,j] <> Soll[i,j] then
       Result := False;
  end
  else Result := False;
end;

function TestAddSubValueYDouble :Boolean;
{Add a const value to odd  and subtract on even array cols.}
 const
   Soll  :array[0..0] of T4Double = ((-50,110,-60,105));
   Value :Double = 100.0;

 var
  i,j  :Integer;
  Feld :array[0..0] of T4Double = ((50,10,40,5));

begin
 Result := True;
 AddSubValueYDouble(Feld,Value);
  for i := 0 to 0 do
    for j := 0 to 3 do
      if Feld[i,j] <> Soll[i,j] then
       Result := False;
end;


{----------------------------multiply-------------------------------------}


function TestProductVYSingle :Boolean;
 {Product of 8 arrays on cols order. All arrays must have the equal length.
  fill with 1 for lack array length}
 const
   Feld1 :array[0..7] of Single =(1,2,3,4,33,34,35,36);
   Feld2 :array[0..7] of Single =(5,6,7,8,37,38,39,40);
   Feld3 :array[0..7] of Single =(9,10,11,12,41,42,43,44);
   Feld4 :array[0..7] of Single =(13,14,15,16,45,46,47,48);
   Feld5 :array[0..7] of Single =(17,18,19,20,49,50,51,52);
   Feld6 :array[0..7] of Single =(21,22,23,24,53,54,55,56);
   Feld7 :array[0..7] of Single =(25,26,27,28,57,58,59,60);
   Feld8 :array[0..7] of Single =(29,30,31,32,61,62,63,64);

   Soll  :T8Single = (33929280,3.6848448E+09,
                      3.8705324E+10,2.03982111E+11,
                      7.55517686E+11,2.24802636E+12,
                      5.75097222E+12,1.3160518E+13);
   // we multiply all the array fields in Feld1,..Feld8.
   // D.h. 1*2,....*36 = poduct Field1 usw.

 var
  i    :Integer;
  Res  :T8Single;
  Res0 :array[0..7] of T8single;

begin
 Result := True;
 // set the arrays in cols order as T8Single
 if Array8ToT8Single(Feld1,Feld2,Feld3,Feld4,Feld5,Feld6,Feld7,Feld8,Res0) then
   begin
     Res := ProductVYSingle(Res0);
     for i := 0 to 7 do
       if Res[i] <> Soll[i] then
       Result := False;
  end
 else Result := False;
end;


function TestProductYSingle :Boolean;
{Product of all the array fields}
 const
   Feld1 :array[0..7] of Single =(1,2,3,4,17,18,19,20);
   Feld2 :array[0..7] of Single =(5,6,7,8,21,22,23,24);
   Feld3 :array[0..7] of Single =(9,10,11,12,25,26,27,28);
   Feld4 :array[0..7] of Single =(13,14,15,16,29,30,31,32);
   Feld5 :array[0..7] of Single =(1,1,1,1,1,1,1,1);
   Feld6 :array[0..7] of Single =(1,1,1,1,1,1,1,1);

   Soll  :Single = 2.6313085E+35;
   // we multiply all the array fields in Feld1,..Feld4 and
   // receiving a single result

 var
  Res  :Single;
  Res0 :array[0..7] of T8single;
  Flag :Boolean = True;   // set 1.0 in unused arrays(5,6,7,8)

begin
 Result := True;
 // set 4 arrays to T8Single on cols order.
 if Array6ToT8Single(Feld1,Feld2,Feld3,Feld4,Feld5,Feld6,Res0,Flag) then
   begin
     Res := ProductYSingle(Res0);
     if Res <> Soll then
       Result := False;
  end
 else Result := False;
end;

function TestMulYSingle :Boolean;
{Res = Feld1 * Feld2}
 const
   Feld1 :array[0..7] of Single =(1,2,3,4,17,18,19,20);
   Feld2 :array[0..7] of Single =(5,6,7,8,21,22,23,24);
   Soll  :array[0..0] of T8Single = ((5,12,21,32,357,396,437,480));

 var
  i :Integer;
  Res :array[0..0] of T8Single;

begin
 Result := True;
 if MulYSingle(Feld1,Feld2,Res) then begin
   for i := 0 to 7 do
    if Res[0,i] <> Soll[0,i] then
       Result := False;
  end
 else Result := False;
end;

function TestFMulAddYSingle :Boolean;
{adapted fused multiply add; (res = (Feld1*Feld2) + Feld3}
 const
   Feld1 :array[0..1] of T8Single = ((1,2,3,4,5,6,7,8),
                                     (9,10,11,12,13,14,15,16));
   Feld2 :array[0..1] of T8Single = ((17,18,19,20,21,22,23,24),
                                     (25,26,27,28,29,30,31,32));
   Feld3 :array[0..1] of T8Single = ((33,34,35,36,37,38,39,40),
                                     (41,42,43,44,45,46,47,48));
   Soll  :array[0..1] of T8Single = ((50,70,92,116,142,170,200,232),
                                     (266,302,340,380,422,466,512,560));

 var
  i,j :Integer;
  Res :array[0..1] of T8Single;

begin
 Result := True;
 if FMulAddYSingle(Feld1,Feld2,Feld3,Res) then begin
   for i := 0 to 1 do
     for j := 0 to 7 do
       if Res[i,j] <> Soll[i,j] then
         Result := False;
  end
 else Result := False;
end;

function TestFMulAddYSingle1 :Boolean;
{adapted fused multiply add; (res in Feld1 = (Feld1*Feld2) + Feld3}
 const
   Feld2 :array[0..1] of T8Single = ((17,18,19,20,21,22,23,24),
                                     (25,26,27,28,29,30,31,32));
   Feld3 :array[0..1] of T8Single = ((33,34,35,36,37,38,39,40),
                                     (41,42,43,44,45,46,47,48));
   Soll  :array[0..1] of T8Single = ((50,70,92,116,142,170,200,232),
                                     (266,302,340,380,422,466,512,560));

 var
  i,j :Integer;
  Feld1 :array[0..1] of T8Single = ((1,2,3,4,5,6,7,8),
                                    (9,10,11,12,13,14,15,16));

begin
 Result := True;
 if FMulAddYSingle(Feld1,Feld2,Feld3) then begin
   for i := 0 to 1 do
     for j := 0 to 7 do
       if Feld1[i,j] <> Soll[i,j] then
         Result := False;
  end
 else Result := False;
end;

function TestFMulSubYSingle :Boolean;
{adapted fused multiply sub; (res = (Feld1*Feld2) - Feld3}
 const
   Feld1 :array[0..1] of T8Single = ((1,2,3,4,5,6,7,8),
                                     (9,10,11,12,13,14,15,16));
   Feld2 :array[0..1] of T8Single = ((17,18,19,20,21,22,23,24),
                                     (25,26,27,28,29,30,31,32));
   Feld3 :array[0..1] of T8Single = ((33,34,35,36,37,38,39,40),
                                     (41,42,43,44,45,46,47,48));
   Soll  :array[0..1] of T8Single = ((-16,2,22,44,68,94,122,152),
                                     (184,218,254,292,332,374,418,464));

 var
  i,j :Integer;
  Res :array[0..1] of T8Single;

begin
 Result := True;
 if FMulSubYSingle(Feld1,Feld2,Feld3,Res) then begin
   for i := 0 to 1 do
     for j := 0 to 7 do
       if Res[i,j] <> Soll[i,j] then
         Result := False;
  end
 else Result := False;
end;

function TestFMulSubYSingle1 :Boolean;
{adapted fused multiply sub; (res in Feld1 = (Feld1*Feld2) - Feld3}
 const
   Feld2 :array[0..1] of T8Single = ((17,18,19,20,21,22,23,24),
                                     (25,26,27,28,29,30,31,32));
   Feld3 :array[0..1] of T8Single = ((33,34,35,36,37,38,39,40),
                                     (41,42,43,44,45,46,47,48));
   Soll  :array[0..1] of T8Single = ((-16,2,22,44,68,94,122,152),
                                     (184,218,254,292,332,374,418,464));

 var
  i,j   :Integer;
  Feld1 :array[0..1] of T8Single = ((1,2,3,4,5,6,7,8),
                                    (9,10,11,12,13,14,15,16));

begin
 Result := True;
 if FMulSubYSingle(Feld1,Feld2,Feld3) then begin
   for i := 0 to 1 do
     for j := 0 to 7 do
       if Feld1[i,j] <> Soll[i,j] then
         Result := False;
  end
 else Result := False;
end;

function TestMul4VYSingle :Boolean;
{multiply 4 array pairs; when you have only 2 pairs use the xmm unit
 res1 = Feld1*feld2 and res2 = Feld3*Feld4 unused arrays MUST set to 1 or all
 the result is zero!}
 const
   Feld1 :array[0..7] of Single =(1,2,3,4,17,18,19,20);
   Feld2 :array[0..7] of Single =(5,6,7,8,21,22,23,24);
   Feld3 :array[0..7] of Single =(9,10,11,12,25,26,27,28);
   Feld4 :array[0..7] of Single =(13,14,15,16,29,30,31,32);
   Feld5 :array[0..7] of Single =(9,10,11,12,25,26,27,28);
   Feld6 :array[0..7] of Single =(13,14,15,16,29,30,31,32);
   Soll  :array[0..7] of T4Single = ((5,117,117,1),
                                     (12,140,140,1),
                                     (21,165,165,1),
                                     (32,192,192,1),
                                     (357,725,725,1),
                                     (396,780,780,1),
                                     (437,837,837,1),
                                     (480,896,896,1));
 var
  i,j :Integer;
  Res  :array[0..7] of T4Single;  // xmm array
  Res0 :array[0..7] of T8Single;
  Flag :Boolean = True; // set 1.0 in unused arrays(5,6,7,8)

begin
 Result := True;
 if Array6ToT8Single(Feld1,Feld2,Feld3,Feld4,Feld5,Feld6,Res0,Flag) then begin
   if Mul4VYSingle(Res0,Res) then begin
     for i := 0 to 7 do
       for j := 0 to 3 do
        if Res[i,j] <> Soll[i,j] then
          Result := False;
   end
   else Result := False;
  end
  else Result := False;
end;

function TestMulVYSingle :Boolean;
{multiply 6,7or 8 arrays in cols order; when < 6 use the xmm unit}
 const
   Feld1 :array[0..7] of Single =(1,2,3,4,17,18,19,20);
   Feld2 :array[0..7] of Single =(5,6,7,8,21,22,23,24);
   Feld3 :array[0..7] of Single =(9,10,11,12,25,26,27,28);
   Feld4 :array[0..7] of Single =(13,14,15,16,29,30,31,32);
   Feld5 :array[0..7] of Single =(1,1,1,1,1,1,1,1);
   Feld6 :array[0..7] of Single =(1,1,1,1,1,1,1,1);
   Soll  :array[0..7] of Single = (585,1680,3465,6144,258825,308880,365769,
                                   430080);
 var
  i    :Integer;
  Res  :array[0..7] of Single;
  Res0 :array[0..7] of T8Single;
  Flag :Boolean = True; // set 1.0 in unused arrays 5,6,7,8)

begin
 Result := True;
 // set T8Single in cols order, d.h. Feld1 pos 0,...Feld4 on pos 3
 if Array6ToT8Single(Feld1,Feld2,Feld3,Feld4,Feld5,Feld6,Res0,Flag) then begin
   if MulVYSingle(Res0,Res) then begin
     for i := 0 to 7 do
        if Res[i] <> Soll[i] then
          Result := False;
  end
  else Result := False;
 end
 else Result := False;
end;

function TestMulValueYSingle :Boolean;
{multiply a const value to all array fields}
 const
   Soll  :array[0..1] of T8Single = ((100,200,300,400,1700,1800,1900,2000),
                                     (2100,2200,2300,2400,2500,2600,2700,2800));
   Value :Single = 100.0;

 var
  i,j  :Integer;
  Feld :array[0..1] of T8Single = ((1,2,3,4,17,18,19,20),
                                    (21,22,23,24,25,26,27,28));

begin
 Result := True;
 MulValueYSingle(Feld,Value);
 for i := 0 to 1 do
   for j := 0 to 7 do
   if Feld[i,j] <> Soll[i,j] then
     Result := False;
end;

function TestMulValueYSingle1 :Boolean;
 {multiply the array with a const value.}
 const
   Feld  :array[0..1] of T8Single = ((1,2,3,4,17,18,19,20),
                                     (21,22,23,24,25,26,27,28));
   Soll  :array[0..1] of T8Single = ((100,200,300,400,1700,1800,1900,2000),
                                     (2100,2200,2300,2400,2500,2600,2700,2800));
   Value :Single = 100.0;

 var
  i,j  :Integer;
  Res  :array[0..1] of T8Single;

begin
 Result := True;
 MulValueYSingle(Feld,Res,Value);
 for i := 0 to 1 do
   for j := 0 to 7 do
     if Res[i,j] <> Soll[i,j] then
       Result := False;
end;

function TestProductVYDouble :Boolean;
 {Calculating the product of each the 4 arrays.}
 const
   Feld1 :array[0..7] of Double =(1,2,3,4,17,18,19,20); // product the Feld1
   Feld2 :array[0..7] of Double =(5,6,7,8,21,22,23,24);
   Feld3 :array[0..7] of Double =(9,10,11,12,25,26,27,28);
   Feld4 :array[0..7] of Double =(13,14,15,16,29,30,31,32);
   Soll  :T4Double = (2790720,428440320,5837832000,37697587200);

 var
  i    :Integer;
  Res0 :array[0..7] of T4Double;
  Res  :T4Double;

begin
 Result := True;
 if Array4ToT4Double(Feld1,Feld2,Feld3,Feld4,Res0) then begin
   Res := ProductVYDouble(Res0);
     for i := 0 to 3 do
       if Res[i] <> Soll[i] then
         Result := False;
  end
 else Result := False;
end;

function TestProductYDouble :Boolean;
{Calculating the product of each arrays.}
 const
   Feld1 :array[0..7] of Double =(1,2,3,4,17,18,19,20);
   Feld2 :array[0..7] of Double =(5,6,7,8,21,22,23,24);
   Feld3 :array[0..7] of Double =(9,10,11,12,25,26,27,28);
   Feld4 :array[0..7] of Double =(13,14,15,16,29,30,31,32);
   Soll  :Double = 9.4287795598875385E+28;

 var
  Res0 :array[0..7] of T4Double;
  Res  :Double;

begin
 Result := True;
 if Array4ToT4Double(Feld1,Feld2,Feld3,Feld4,Res0) then begin
   Res := ProductYDouble(Res0);
   if Res <> Soll then
     Result := False;
  end
 else Result := False;
end;

function TestMulVYDouble :Boolean;
{multiply the 4 arrays horizontal. field1*field2*field3*field4}
 const
   Feld1 :array[0..7] of Double =(1,2,3,4,17,18,19,20);
   Feld2 :array[0..7] of Double =(5,6,7,8,21,22,23,24);
   Feld3 :array[0..7] of Double =(9,10,11,12,25,26,27,28);
   Feld4 :array[0..7] of Double =(13,14,15,16,29,30,31,32);
   Soll  :array[0..7] of Double = (585,1680,3465,6144,258825,308880,365769,
                                   430080);
 var
  i :Integer;
  Res0 :array[0..7] of T4Double;
  Res  :array[0..7] of Double;

begin
 Result := True;
 if Array4ToT4Double(Feld1,Feld2,Feld3,Feld4,Res0) then begin
  if MulVYDouble(Res0,Res) then begin
    for i := 0 to 7 do
      if Res[i] <> Soll[i] then
         Result := False;
   end
   else Result := False;
  end
 else Result := False;
end;

function TestFMulAddYDouble :Boolean;
{adapted from multiply and add; Res = (Feld1 * Feld2) + Feld3}
 const
   Feld1 :array[0..1] of T4Double = ((1,2,3,4),(5,6,7,8));
   Feld2 :array[0..1] of T4Double = ((5,6,7,8),(9,10,11,12));
   Feld3 :array[0..1] of T4Double = ((90,100,110,120),(25,26,27,28));
   Soll  :array[0..1] of T4Double = ((95,112,131,152),(70,86,104,124));

 var
  i,j :Integer;
  Res :array[0..1] of T4Double;

begin
 Result := True;
 if FMulAddYDouble(Feld1,Feld2,Feld3,Res) then begin
   for i := 0 to 1 do
     for j := 0 to 3 do
       if Res[i,j] <> Soll[i,j] then
         Result := False;
   end
 else Result := False;
end;

function TestFMulAddYDouble1 :Boolean;
{adapted from multiply and add; Feld1 = (Feld1 * Feld2) + Feld3}
 const
   Feld2 :array[0..1] of T4Double = ((5,6,7,8),(9,10,11,12));
   Feld3 :array[0..1] of T4Double = ((90,100,110,120),(25,26,27,28));
   Soll  :array[0..1] of T4Double = ((95,112,131,152),(70,86,104,124));

 var
  i,j   :Integer;
  Feld1 :array[0..1] of T4Double = ((1,2,3,4),(5,6,7,8));

begin
 Result := True;
 if FMulAddYDouble(Feld1,Feld2,Feld3) then begin
   for i := 0 to 1 do
     for j := 0 to 3 do
       if Feld1[i,j] <> Soll[i,j] then
         Result := False;
   end
 else Result := False;
end;

function TestFMulSubYDouble :Boolean;
{adapted from multiply and sub; Res = (Feld1 * Feld2) - Feld3}
 const
   Feld1 :array[0..1] of T4Double = ((1,2,3,4),(5,6,7,8));
   Feld2 :array[0..1] of T4Double = ((5,6,7,8),(9,10,11,12));
   Feld3 :array[0..1] of T4Double = ((90,100,110,120),(25,26,27,28));
   Soll  :array[0..1] of T4Double = ((-85,-88,-89,-88),(20,34,50,68));

 var
  i,j :Integer;
  Res :array[0..1] of T4Double;

begin
 Result := True;
 if FMulSubYDouble(Feld1,Feld2,Feld3,Res) then begin
   for i := 0 to 1 do
     for j := 0 to 3 do
       if Res[i,j] <> Soll[i,j] then
         Result := False;
   end
 else Result := False;
end;

function TestFMulSubYDouble1 :Boolean;
{adapted from multiply and sub; Feld1 = (Feld1 * Feld2) - Feld3}
 const
   Feld2 :array[0..1] of T4Double = ((5,6,7,8),(9,10,11,12));
   Feld3 :array[0..1] of T4Double = ((90,100,110,120),(25,26,27,28));
   Soll  :array[0..1] of T4Double = ((-85,-88,-89,-88),(20,34,50,68));

 var
  i,j   :Integer;
  Feld1 :array[0..1] of T4Double = ((1,2,3,4),(5,6,7,8));

begin
 Result := True;
 if FMulSubYDouble(Feld1,Feld2,Feld3) then begin
   for i := 0 to 1 do
     for j := 0 to 3 do
       if Feld1[i,j] <> Soll[i,j] then
         Result := False;
   end
 else Result := False;
end;

function TestMul2VYDouble :Boolean;
{multiply 2 array pairs Res1 = Feld1*Feld2 and res2 = Feld3*Feld4}
 const
   Soll  :array[0..7] of T2Double = ((5,117),
                                     (12,140),
                                     (21,165),
                                     (32,192),
                                     (357,725),
                                     (396,780),
                                     (437,837),
                                     (480,896));
   Feld1 :array[0..7] of Double =(1,2,3,4,17,18,19,20);
   Feld2 :array[0..7] of Double =(5,6,7,8,21,22,23,24);
   Feld3 :array[0..7] of Double =(9,10,11,12,25,26,27,28);
   Feld4 :array[0..7] of Double =(13,14,15,16,29,30,31,32);

 var
  i,j :Integer;
  Res0 :array[0..7] of T4Double;
  Res  :array[0..7] of T2Double;  //xmm array

begin
 Result := True;
 // set the arrays in cols order.
 if Array4ToT4Double(Feld1,Feld2,Feld3,Feld4,Res0) then begin
   if Mul2VYDouble(Res0,Res) then begin
     for i := 0 to 7 do
       for j := 0 to 1 do
         if Res[i,j] <> Soll[i,j] then
           Result := False;
    end
   else Result := False;
  end
 else Result := False;
end;

function TestMulYDouble :Boolean;
{Res = Feld1*Feld2}
 const
   Feld1 :array[0..0] of T4Double = ((1,2,3,4));
   Feld2 :array[0..0] of T4Double = ((5,6,7,8));
   Soll  :array[0..0] of T4Double = ((5,12,21,32));

 var
  i,j :Integer;
  Res  :array[0..0] of T4Double;

begin
 Result := True;
 if MulYDouble(Feld1,Feld2,Res) then begin
   for i := 0 to 0 do
     for j := 0 to 3 do
       if Res[i,j] <> Soll[i,j] then
         Result := False;
  end
 else Result := False;
end;

function TestMulvalueYDouble :Boolean;
{multiply a const value on array fields}
 const
   Soll  :array[0..0] of T4Double = ((100,200,300,400));
   Value :Double = 100.0;

 var
  i,j  :Integer;
  Feld :array[0..0] of T4Double = ((1,2,3,4));

begin
 Result := True;
 MulValueYDouble(Feld,Value);
 for i := 0 to 0 do
   for j := 0 to 3 do
    if Feld[i,j] <> Soll[i,j] then
       Result := False;
end;

function TestMulvalueYDouble1 :Boolean;
{multiply a const value on array fields}
 const
   Feld  :array[0..0] of T4Double = ((1,2,3,4));
   Soll  :array[0..0] of T4Double = ((100,200,300,400));
   Value :Double = 100.0;

 var
  i,j  :Integer;
  Res :array[0..0] of T4Double;

begin
 Result := True;
 if MulValueYDouble(Feld,Res,Value) then begin
 for i := 0 to 0 do
   for j := 0 to 3 do
    if Res[i,j] <> Soll[i,j] then
       Result := False;
  end
 else Result := False;
end;

{------------------------------division-------------------------------------}


function TestDivYSingle :Boolean;
{Res = Feld1 / Feld2}
 const
   Feld1 :array[0..0] of T8Single = ((5,20,21,40,50,56,80,88));
   Feld2 :array[0..0] of T8Single = ((1,2, 7,8,10,8,10,2));
   Soll  :array[0..0] of T8Single = ((5,10,3,5,5,7,8,44));

 var
  i,j :Integer;
  Res  :array[0..0] of T8Single;

begin
 Result := True;
 if DivYSingle(Feld1,Feld2,Res) then begin
   for i := 0 to 0 do
     for j := 0 to 7 do
       if Res[i,j] <> Soll[i,j] then
         Result := False;
  end
 else Result := False;
end;

function TestDiv4VYSingle :Boolean;
{division of 3 or 4 array pairs. Here 3 array pairs
 Res1 = Feld1/Feld2 and Res2 = Feld2 / Feld3}
 const
   Feld1 :array[0..3] of Single = (5,20,21,40);
   Feld2 :array[0..3] of Single = (1, 2, 7, 8);
   Feld3 :array[0..3] of Single = (50,56,80,88);
   Feld4 :array[0..3] of Single = (10, 8,10,22);
   Feld5 :array[0..3] of Single = (50,56,80,88);
   Feld6 :array[0..3] of Single = (10, 8,10,22);
   Soll  :array[0..3] of T4Single = ((5,5,5,1),
                                     (10,7,7,1),
                                     (3,8,8,1),
                                     (5,4,4,1));

 var
  i,j :Integer;
  Res0 :array[0..3] of T8Single;
  Res  :array[0..3] of T4Single; // xmm array
  Flag :Boolean = True;   // set unused array 5,6,7,8 to 1.0)

begin
 Result := True;
 // set arays in cols order
 if Array6ToT8Single(Feld1,Feld2,Feld3,Feld4,Feld5,Feld6,Res0,Flag) then begin
   if Div4VYSingle(Res0,Res) then begin
     for i := 0 to 3 do
       for j := 0 to 3 do
        if Res[i,j] <> Soll[i,j] then
          Result := False;
   end
   else Result := False;
  end
  else result := False;
end;

function TestDivYDouble :Boolean;
{Res = Feld1 / Feld2}
 const
   Feld1 :array[0..0] of T4Double = ((5,20,21,40));
   Feld2 :array[0..0] of T4Double = ((1,2, 7,8));
   Soll  :array[0..0] of T4Double = ((5,10,3,5));

 var
  i,j :Integer;
  Res  :array[0..0] of T4Double;

begin
 Result := True;
 if DivYDouble(Feld1,Feld2,Res) then begin
   for i := 0 to 0 do
     for j := 0 to 3 do
       if Res[i,j] <> Soll[i,j] then
         Result := False;
  end
 else Result := False;
end;

function TestDiv2VYDouble :Boolean;
{division of 2 array pairs Res1 = Feld1 /Feld2 and Res2 = Feld3 /Feld4}
 const
   Feld1 :array[0..3] of Double = (5,20,21,40);
   Feld2 :array[0..3] of Double = (1, 2, 7, 8);
   Feld3 :array[0..3] of Double = (50,56,80,88);
   Feld4 :array[0..3] of Double = (10, 8,10,22);
   Soll  :array[0..3] of T2Double = ((5,5),
                                     (10,7),
                                     (3,8),
                                     (5,4));

 var
  i,j :Integer;
  Res0 :array[0..3] of T4Double;
  Res  :array[0..3] of T2Double;  // xmm array

begin
 Result := True;
 // arrays in cols order
 if Array4ToT4Double(Feld1,Feld2,Feld3,Feld4,Res0) then begin
   if Div2VYDouble(Res0,Res) then begin
     for i := 0 to 3 do
       for j := 0 to 1 do
         if Res[i,j] <> Soll[i,j] then
           Result := False;
    end
   else Result := False;
  end
 else result := False;
end;


{----------------------------functions-------------------------------------}


function TestSQRYSingle :Boolean;
{Calculate the square of each array field. Result is on input array.}
 const
   Soll :array[0..1] of T8Single = ((1,4,9,16,25,36,49,64),
                                   (81,100,121,144,169,196,225,256));


 var
  i,j  :Integer;
  Feld :array[0..1] of T8Single = ((1,2,3,4,5,6,7,8),
                                   (9,10,11,12,13,14,15,16));

begin
 Result := True;
 SQRYSingle(Feld);
 for i := 0 to 1 do
   for j := 0 to 7 do
     if Feld[i,j] <> Soll[i,j] then
       Result := False;
end;

function TestSQRYSingle1 :Boolean;
 {Calculate the square of each array field. Result is new array.}
 const
   Feld :array[0..1] of T8Single = ((1,2,3,4,5,6,7,8),
                                    (9,10,11,12,13,14,15,16));
   Soll :array[0..1] of T8Single = ((1,4,9,16,25,36,49,64),
                                   (81,100,121,144,169,196,225,256));


 var
  i,j :Integer;
  Res :array[0..1] of T8Single;

begin
 Result := True;
 if SQRYSingle(Feld,Res) then begin
 for i := 0 to 1 do
   for j := 0 to 7 do
     if Res[i,j] <> Soll[i,j] then
       Result := False;
 end
 else Result := False;
end;

function TestSQRMulDiffYSingle :Boolean;
 { Res = SQR(Feld1*(Feld2-Feld3)) }
 const
   Feld1 :array[0..1] of T8Single = ((1,2,3,4,5,6,7,8),
                                     (9,10,11,12,13,14,15,16));
   Feld2 :array[0..1] of T8Single = ((17,18,19,20,21,22,23,24),
                                     (25,26,27,28,29,30,31,32));
   Feld3 :array[0..1] of T8Single = ((33,34,35,36,37,38,39,40),
                                     (41,42,43,44,45,46,47,48));
   Soll  :array[0..1] of T8Single = ((256,1024,2304,4096,6400,9216,12544,16384),
                                   (20736,25600,30976,36864,43264,50176,57600,65536));


 var
  i,j :Integer;
  Res :array[0..1] of T8Single;

begin
 Result := True;
 if SQRMulDiffYSingle(Feld1,Feld2,Feld3,Res) then begin
 for i := 0 to 1 do
   for j := 0 to 7 do
     if Res[i,j] <> Soll[i,j] then
       Result := False;
 end
 else Result := False;
end;


function TestSumSQRYSingle :Boolean;
{sum of the square of all fields}
 const
   Feld :array[0..1] of T8Single = ((1,2,3,4,5,6,7,8),(9,10,11,12,13,14,15,16));
   Soll :Single = 1496;

 var
  Res :Single;

begin
  Result := True;
  Res := SumSQRYSingle(Feld);
  if Res <> Soll then
    Result := False;
end;

function TestSumSQRMulDiffYSingle :Boolean;
{ Res = Sum(SQR(Feld1*(Feld2-Feld3))) }
const
  Feld1 :array[0..1] of T8Single = ((1,2,3,4,5,6,7,8),
                                    (9,10,11,12,13,14,15,16));
  Feld2 :array[0..1] of T8Single = ((17,18,19,20,21,22,23,24),
                                    (25,26,27,28,29,30,31,32));
  Feld3 :array[0..1] of T8Single = ((33,34,35,36,37,38,39,40),
                                    (41,42,43,44,45,46,47,48));
  Soll :Single = 382976;

 var
  Res :Single;

begin
  Result := True;
  Res := SumSQRMulDiffYSingle(Feld1,Feld2,Feld3);
  if Res <> Soll then
    Result := False;
end;


function TestSumSQRVYSingle :Boolean;
{Sum of the square the array cols}
 const
   Feld :array[0..1] of T8Single = ((1,2,3,4,5,6,7,8),
                                    (9,10,11,12,13,14,15,16));
   Soll :T8Single = (82,104,130,160,194,232,274,320);

 var
  j   :Integer;
  Res :T8Single;

begin
  Result := True;
  Res := SumSQRVYSingle(Feld);
  for j := 0 to 7 do
  if Res[j] <> Soll[j] then
    Result := False;
end;

function TestSQRYDouble :Boolean;
{Calculate square of the array fields. Result is on input array.}
 const
   Soll :array[0..1] of T4Double = ((1,4,9,16),(25,36,49,64));

 var
  i,j  :Integer;
  Feld :array[0..1] of T4Double = ((1,2,3,4),(5,6,7,8));

begin
  Result := True;
  SQRYDouble(Feld);
  for i := 0 to 1 do
    for j := 0 to 3 do
      if Feld[i,j] <> Soll[i,j] then
         Result := False;
end;

function TestSQRYDouble1 :Boolean;
{Calculate square of the array fields. Result is on new array.}
 const
   Feld :array[0..1] of T4Double = ((1,2,3,4),(5,6,7,8));
   Soll :array[0..1] of T4Double = ((1,4,9,16),(25,36,49,64));

 var
  i,j :Integer;
  Res :array[0..1] of T4Double;

begin
  Result := True;
  SQRYDouble(Feld,Res);
  for i := 0 to 0 do
    for j := 0 to 3 do
      if Res[i,j] <> Soll[i,j] then
         Result := False;
end;

function TestSumSQRYDouble :Boolean;
{sum of square of the array fields.}

 const
   Feld :array[0..0] of T4Double = ((1,2,3,4));
   Soll :Double = 30.0;

 var
  Res :Double;

begin
 Result := True;
 Res := SumSQRYDouble(Feld);
 if Res <> Soll then
  Result := False;
end;

function TestSQRMulDiffYDouble :Boolean;
{Result = SQR(Feld1*(Feld2-Feld3))}
 const
   Feld1 :array[0..1] of T4Double = ((1,2,3,4),(5,6,7,8));
   Feld2 :array[0..1] of T4Double = ((17,18,19,20),(21,22,23,24));
   Feld3 :array[0..1] of T4Double = ((33,34,35,36),(37,38,39,40));
   Soll  :array[0..1] of T4Double = ((256,1024,2304,4096),(6400,9216,12544,16384));

 var
  i,j :Integer;
  Res :array[0..1] of T4Double;

begin
 Result := True;
 if SQRMulDiffYDouble(Feld1,Feld2,Feld3,Res) then begin
   for i := 0 to 1 do
     for j := 0 to 3 do
       if Res[i,j] <> Soll[i,j] then
  Result := False;
  end
 else Result := False;
end;

function TestSumSQRMulDiffYDouble :Boolean;
{Result = Sum(1,n(SQR(Feld1*(Feld2-Feld3))))}
 const
   Feld1 :array[0..1] of T4Double = ((1,2,3,4),(5,6,7,8));
   Feld2 :array[0..1] of T4Double = ((17,18,19,20),(21,22,23,24));
   Feld3 :array[0..1] of T4Double = ((33,34,35,36),(37,38,39,40));
   Soll  :Double =  52224;

 var
  Res :Double;

begin
 Result := True;
 Res := SumSQRMulDiffYDouble(Feld1,Feld2,Feld3);
  if Res <> Soll then
    Result := False;
end;

function TestSumSQRVYDouble :Boolean;
{Result = Sum(1,n(SQR(x1)+SQR(x2),...))}
 const
   Feld :array[0..1] of T4Double = ((1,2,3,4),
                                    (9,10,11,12));
   Soll :T4Double = (82,104,130,160);

 var
  j   :Integer;
  Res :T4Double;

begin
  Result := True;
  Res := SumSQRVYDouble(Feld);
  for j := 0 to 3 do
  if Res[j] <> Soll[j] then
    Result := False;
end;

function TestCubicYSingle :Boolean;
{Calculate y = x^3. Result in Feld.}
 const
   Soll :array[0..1] of T8Single = ((1,8,27,64,125,216,343,512),
                             (-729,-1000,-1728,-2197,-2744,-3375,-4096,-4913));

 var
  i,j  :Integer;
  Feld :array[0..1] of T8Single = ((1,2,3,4,5,6,7,8),
                                   (-9,-10,-12,-13,-14,-15,-16,-17));

begin
  Result := True;
  CubicYSingle(Feld);
  for i := 0 to 1 do
    for j := 0 to 7 do
      if Feld[i,j] <> Soll[i,j] then
        Result := False;
end;

function TestCubicYSingle1 :Boolean;
{Calculate y = x^3. Result in new array.}
 const
   Feld :array[0..1] of T8Single = ((1,2,3,4,5,6,7,8),
                                    (-9,-10,-12,-13,-14,-15,-16,-17));
   Soll :array[0..1] of T8Single = ((1,8,27,64,125,216,343,512),
                             (-729,-1000,-1728,-2197,-2744,-3375,-4096,-4913));

 var
  i,j  :Integer;
  Res  :array[0..1] of T8Single;

begin
  Result := True;
  if CubicYSingle(Feld,Res) then begin
    for i := 0 to 1 do
      for j := 0 to 7 do
        if Res[i,j] <> Soll[i,j] then
          Result := False;
  end;
end;

function TestCubicYDouble :Boolean;
{Calculate y = x^3. Result in Feld.}
 const
   Soll :array[0..3] of T4Double = ((1,8,27,64),(125,216,343,512),
                             (-729,-1000,-1728,-2197),(-2744,-3375,-4096,-4913));

 var
  i,j  :Integer;
  Feld :array[0..3] of T4Double = ((1,2,3,4),(5,6,7,8),
                                   (-9,-10,-12,-13),(-14,-15,-16,-17));

begin
  Result := True;
  CubicYDouble(Feld);
  for i := 0 to 3 do
    for j := 0 to 3 do
      if Feld[i,j] <> Soll[i,j] then
        Result := False;
end;

function TestCubicYDouble1 :Boolean;
{Calculate y = x^3. Result in new array}
 const
   Feld :array[0..3] of T4Double = ((1,2,3,4),(5,6,7,8),
                                    (-9,-10,-12,-13),(-14,-15,-16,-17));
   Soll :array[0..3] of T4Double = ((1,8,27,64),(125,216,343,512),
                             (-729,-1000,-1728,-2197),(-2744,-3375,-4096,-4913));

 var
  i,j  :Integer;
  Res  :array[0..3] of T4Double;

begin
  Result := True;
  if CubicYDouble(Feld,Res) then begin
    for i := 0 to 3 do
      for j := 0 to 3 do
        if Res[i,j] <> Soll[i,j] then
          Result := False;
  end;
end;

function TestRecYSingle :Boolean;
{Result = (1/x1,...1/xn). Result on input array.}
 const
   Soll :array[0..1] of T8Single = ((1,0.5,0.25,0.2,0.1,0.0625,0.04,0.025),
                            (0.02,0.0125,0.01,0.005,0.0025,0.00125,0.001,0.0005));


 var
  i,j  :Integer;
  Feld :array[0..1] of T8Single = ((1,2,4,5,10,16,25,40),
                                   (50,80,100,200,400,800,1000,2000));

begin
  Result := True;
  RecYSingle(Feld);
  RoundYSingle(Feld,3);
  RoundYSingle(Soll,3);
  for i := 0 to 1 do
    for j := 0 to 7 do
      if Feld[i,j] <> Soll[i,j] then
         Result := False;
end;

function TestRecYSingle1 :Boolean;
{Result = (1/x1,...1/xn). Result in new array.}
 const
   Feld :array[0..1] of T8Single = ((1,2,4,5,10,16,25,40),
                                    (50,80,100,200,400,800,1000,2000));
   Soll :array[0..1] of T8Single = ((1,0.5,0.25,0.2,0.1,0.0625,0.04,0.025),
                            (0.02,0.0125,0.01,0.005,0.0025,0.00125,0.001,0.0005));

 var
  i,j :Integer;
  Res :array[0..1] of T8Single;

begin
  Result := True;
  if RecYSingle(Feld,Res) then begin
    RoundYSingle(Soll,3);
    RoundYSingle(Res,3);
    for i := 0 to 1 do
      for j := 0 to 7 do
        if Res[i,j] <> Soll[i,j] then
           Result := False;
   end
  else Result := False;
end;

function TestSRecYSingle :Boolean;
{Result = (1/x1,...1/xn). Result on input array. Secure reciprocal, when
 on input field is zero, not exception. (zeros in +oo -> 1/+oo = 0) }
 const
   Soll :array[0..1] of T8Single = ((0,0,0.25,0.2,0.1,0.0625,0.04,0.025),
                            (0.02,0.0125,0.01,0.005,0.0025,0.00125,0.001,0.0005));

 var
  i,j  :Integer;
  Feld :array[0..1] of T8Single = ((0,0,4,5,10,16,25,40),
                                   (50,80,100,200,400,800,1000,2000));

begin
  Result := True;
  SRecYSingle(Feld);    // secure reciprocal
  RoundYSingle(Feld,3);
  RoundYSingle(Soll,3);
  for i := 0 to 1 do
    for j := 0 to 7 do
      if Feld[i,j] <> Soll[i,j] then
        Result := False;
end;

function TestSRecYSingle1 :Boolean;
{Result = (1/x1,...1/xn). Result on input array. Secure reciprocal, when
 on input field is zero, not exception. (zeros in +oo -> 1/+oo = 0) }

 const
   Feld :array[0..1] of T8Single = ((0,-0,4,5,10,16,25,40),
                                    (50,80,100,200,400,800,1000,2000));
   Soll :array[0..1] of T8Single = ((0,0,0.25,0.2,0.1,0.0625,0.04,0.025),
                            (0.02,0.0125,0.01,0.005,0.0025,0.00125,0.001,0.0005));

 var
  i,j :Integer;
  Res :array[0..1] of T8Single;

begin
  Result := True;
  if SRecYSingle(Feld,Res) then begin
  RoundYSingle(Res,3);
  RoundYSingle(Soll,3);
  for i := 0 to 1 do
    for j := 0 to 7 do
      if Res[i,j] <> Soll[i,j] then
        Result := False;
  end
  else Result := False;
end;


function TestFastRecYSingle :Boolean;
{Fast reciprocal for single, but inexact.
 When a value is zero -> +oo for this value and the compiler give on exception}
 const
   Soll :array[0..1] of T8Single = ((1,0.5,0.25,0.2,0.1,0.0625,0.04,0.025),
                            (0.02,0.0125,0.01,0.005,0.0025,0.00125,0.001,0.0005));

 var
  i,j :Integer;
  Feld :array[0..1] of T8Single = ((1,2,4,5,10,16,25,40),
                                   (50,80,100,200,400,800,1000,2000));

begin
  Result := True;
  FastRecYSingle(Feld);
  RoundYSingle(Feld,3);
  RoundYSingle(Soll,3);
  for i := 0 to 1 do
    for j := 0 to 7 do
      if Feld[i,j] <> Soll[i,j] then
        Result := False;
end;

function TestFastRecYSingle1 :Boolean;
{Fast reciprocal for single, but inexact.
 When a value is zero -> +oo for this value and the compiler give on exception}
 const
   Feld :array[0..1] of T8Single = ((1,2,4,5,10,16,25,40),
                                    (50,80,100,200,400,800,1000,2000));
   Soll :array[0..1] of T8Single = ((1,0.5,0.25,0.2,0.1,0.0625,0.04,0.025),
                            (0.02,0.0125,0.01,0.005,0.0025,0.00125,0.001,0.0005));

 var
  i,j :Integer;
  Res :array[0..1] of T8Single;

begin
  Result := True;
  if FastRecYSingle(Feld,Res) then begin
    RoundYSingle(Res,3);
    RoundYSingle(Soll,3);
    for i := 0 to 1 do
      for j := 0 to 7 do
        if Res[i,j] <> Soll[i,j] then
          Result := False;
   end
  else Result := False;
end;


function TestSumRecYSingle :Boolean;
{Result = Sum 1,n(1/x1,...1/xn)}
 const
   Feld :array[0..0] of T8Single = ((1,2,4,5,10,16,25,40));
   Soll :Single = 2.1775;

 var
  Res :Single;

begin
  Result := True;
  Res := SumRecYSingle(Feld);
  if Res <> Soll then
    Result := False;
end;

function TestSumSRecYSingle :Boolean;
{Result = Sum 1,n(1/x1,...1/xn)}
 const
   Feld :array[0..0] of T8Single = ((0,2,4,5,10,16,25,40));
   Soll :Single = 1.1775;

 var
  Res :Single;

begin
  Result := True;
  Res := SumSRecYSingle(Feld);
  if Res <> Soll then
    Result := False;
end;


function TestSumRecVYSingle :Boolean;
{Result = Sum(1,n(1/x1,...1/xn)) of the array cols}

 const
   Feld :array[0..1] of T8Single = ((1,2,4,5,10,16,25,40),
                                    (100,200,400,500,250,800,1000,160));
   Soll :T8Single = (1.01,0.505,0.252,0.202,0.104,0.0640,0.041,0.031);

 var
  j :Integer;
  Res :T8Single;

begin
  Result := True;
  Res := SumRecVYSingle(Feld);
  RoundYSingle(Res,3);
  RoundYSingle(Soll,3);
  for j := 0 to 7 do
    if Res[j] <> Soll[j] then
       Result := False;
end;

function TestSumSRecVYSingle :Boolean;
{Secure zeros in input -> 0 in result.
 Result = Sum(1,n(1/x1,...1/xn)) of the array fields vertical.}
 const
   Feld :array[0..1] of T8Single = ((0,-0,4,5,10,16,25,40),
                                    (100,200,400,500,250,800,1000,160));
   Soll :T8Single = (0.01,0.005,0.252,0.202,0.104,0.0640,0.041,0.031);

 var
  j   :Integer;
  Res :T8Single;

begin
  Result := True;
  Res := SumSRecVYSingle(Feld);
  RoundYSingle(Res,3);
  RoundYSingle(Soll,3);
  for j := 0 to 7 do
    if Res[j] <> Soll[j] then
       Result := False;
end;


function TestRecYDouble :Boolean;
{ Result = (1/x1,...1/xn)) of the array fields in input array.}

 const
   Soll :array[0..1] of T4Double = ((1,0.5,0.333,0.250),(0.2,0.167,0.143,0.125));

 var
  i,j  :Integer;
  Feld :array[0..1] of T4Double = ((1,2,3,4),(5,6,7,8));

begin
  Result := True;
  RecYDouble(Feld);
  RoundYDouble(Feld,3);
  RoundYDouble(Soll,3);
  for i := 0 to 1 do
    for j := 0 to 3 do
      if Feld[i,j] <> Soll[i,j] then
         Result := False;
end;

function TestRecYDouble1 :Boolean;
{Result = (1/x1,...1/xn)) of the array fields.}
 const
   Feld :array[0..1] of T4Double = ((1,2,3,4),(5,6,7,8));
   Soll :array[0..1] of T4Double = ((1,0.5,0.333,0.250),(0.2,0.167,0.143,0.125));

 var
  i,j :Integer;
  Res :array[0..1] of T4Double;

begin
  Result := True;
  if RecYDouble(Feld,Res) then begin
    RoundYDouble(Res,3);
    RoundYDouble(Soll,3);
    for i := 0 to 1 do
      for j := 0 to 3 do
        if Res[i,j] <> Soll[i,j] then
           Result := False;
  end
  else Result := False;
end;

function TestSumRecYDouble :Boolean;
{ Result = Sum(1,n(1/x1,...1/xn)) of the array fields.}
 const
   Feld :array[0..0] of T4Double = ((1,2,4,5));
   Soll :Double = 1.95;

 var
  Res :Double;

begin
  Result := True;
  Res := SumRecYDouble(Feld);
  if Res <> Soll then
    Result := False;
end;

function TestSumSRecYDouble :Boolean;
{secure Result = (1/x1,...1/xn)) of the array fields. zeros = zeros}

 const
   Feld :array[0..1] of T4Double = ((0,-0,3,4),(5,6,7,8));
   Soll :Double = 1.22;

 var
  Res :Double;

begin
  Result := True;
  Res := SumSRecYDouble(Feld);
  if SimpleRoundTo(Res,-2) <> Soll then
    Result := False;
end;

function TestSumRecVYDouble :Boolean;
{ Result = (1/x1,...1/xn)) of the array fields vertical.}

 const
   Feld :array[0..1] of T4Double = ((1,2,4,5),(100,200,400,500));
   Soll :T4Double = (1.01,0.505,0.252,0.202);

 var
  j   :Integer;
  Res :T4Double;

begin
  Result := True;
  Res := SumRecVYDouble(Feld);
  RoundYDouble(res,3);
  RoundYDouble(Soll,3);
  for j := 0 to 3 do
    if Res[j] <> Soll[j] then
      Result := False;
end;

function TestSumSRecVYDouble :Boolean;
{Secure Result = (1/x1,...1/xn)) of the array fields. zeros = zeros}

 const
   Feld :array[0..1] of T4Double = ((0,-0,4,5),
                                    (100,200,400,500));
   Soll :T4Double = (0.01,0.005,0.252,0.202);

 var
  j   :Integer;
  Res :T4Double;

begin
  Result := True;
  Res := SumSRecVYDouble(Feld);
  RoundYDouble(Res,3);
  RoundYDouble(Soll,3);
  for j := 0 to 3 do
    if Res[j] <> Soll[j] then
      Result := False;
end;

function TestSQRTYSingle :Boolean;
{SQRT of all array fields, Res on Feld}
 const
   Soll :array[0..1] of T8Single = ((1,2,5,7,8,9,10,20),
                                    (22,24,26,28,30,32,33,35));

 var
  i,j :Integer;
  Feld :array[0..1] of T8Single = ((1,4,25,49,64,81,100,400),
                                   (500,600,700,800,900,1000,1100,1200));

begin
  Result := True;
  SqrtYSingle(Feld);
  RoundYSingle(Feld);  // round to integer
  for i := 0 to 1 do
    for j := 0 to 7 do
      if Feld[i,j] <> Soll[i,j] then
         Result := False;
end;

function TestSQRTYSingle1 :Boolean;
{square root of all array fields, result in new array}
 const
   Soll :array[0..1] of T8Single = ((1,2,5,7,8,9,10,20),
                                    (22,24,26,28,30,32,33,35));
   Feld :array[0..1] of T8Single = ((1,4,25,49,64,81,100,400),
                                    (500,600,700,800,900,1000,1100,1200));

 var
  i,j :Integer;
  Res :array[0..1] of T8Single;

begin
  Result := True;
  if SqrtYSingle(Feld,Res) then begin
    RoundYSingle(Res);    // round to Integer
    for i := 0 to 1 do
      for j := 0 to 7 do
        if Res[i,j] <> Soll[i,j] then
           Result := False;
   end
  else Result := False;
end;

function TestSumSQRTYSingle :Boolean;
{Sum of all square root of the array fields.}
 const
   Feld :array[0..0] of T8Single = ((1,4,25,49,64,81,100,400));
   Soll :Single = 62.0;

 var
  Res :Single;

begin
  Result := True;
  Res := SumSqrtYSingle(Feld);
  if Res <> Soll then
    Result := False;
end;

function TestSumSQRTVYSingle :Boolean;
{Sum of all square root of the array cols.}
 const
   Feld :array[0..1] of T8Single = ((1,4,25,49,64,81,100,400),
                                    (1,4,25,49,64,81,100,400));
   Soll :T8Single = (2,4,10,14,16,18,20,40);

 var
  i   :Integer;
  Res :T8Single;

begin
  Result := True;
  Res := SumSqrtVYSingle(Feld);
  for i := 0 to 7 do
    if Res[i] <> Soll[i] then
      Result := False;
end;

function TestRecSQRTYSingle :Boolean;
{reciprocal square root of the array fields. result in Feld}
 const
   Soll :array[0..0] of T8Single = ((1,0.5,0.2,0.125,0.1,0.05,0.04,0.01));

 var
  i,j  :Integer;
  Feld :array[0..0] of T8Single = ((1,4,25,64,100,400,625,10000));

begin
  Result := True;
  RecSqrtYSingle(Feld);
  for i := 0 to 0 do
    for j := 0 to 7 do
      if Feld[i,j] <> Soll[i,j] then
        Result := False;
end;

function TestRecSQRTYSingle1 :Boolean;
{reciprocal square root of all array fields. result in new array}
 const
   Feld :array[0..1] of T8Single = ((1,4,25,64,100,400,625,10000),
                                    (2,3,4,5,6,7,8,9));
   Soll :array[0..1] of T8Single = ((1,0.5,0.2,0.125,0.1,0.05,0.04,0.01),
                                    (0.707,0.577,0.5,0.447,0.408,0.377,0.353,0.333));

 var
  i,j :Integer;
  Res :array[0..1] of T8Single;

begin
  Result := True;
  if RecSqrtYSingle(Feld,Res) then begin
    RoundYSingle(Res,2);
    RoundYSingle(Soll,2);
  for i := 0 to 1 do
    for j := 0 to 7 do
      if Res[i,j] <> Soll[i,j] then
        Result := False;
  end
  else Result := False;
end;

function TestSRecSQRTYSingle :Boolean;
{secure reciprocal square root of the array fields. Is a field zero ->
 no exception. zero = zero}
 const
   Soll :array[0..1] of T8Single = ((0,0,200,125,100,50,40,10),
                                    (707,577,500,447,408,378,354,333));

 var
  i,j :Integer;
  Feld :array[0..1] of T8Single = ((0,-0,25,64,100,400,625,10000),
                                   (2,3,4,5,6,7,8,9));

begin
  Result := True;
  SRecSqrtYSingle(Feld);
  MulvalueYSingle(Feld,1000);  // for compare
  RoundYSingle(Feld);
  for i := 0 to 1 do
    for j := 0 to 7 do
      if Feld[i,j] <> Soll[i,j] then
        Result := False;
end;

function TestSRecSQRTYSingle1 :Boolean;
{secure reciprocal square root of the array fields. Is a field zero ->
 no exception. zero = zero result in new array}
 const
   Feld :array[0..1] of T8Single = ((0,-0,25,64,100,400,625,10000),
                                    (2,3,4,5,6,7,8,9));
   Soll :array[0..1] of T8Single = ((0,0,200,125,100,50,40,10),
                                    (707,577,500,447,408,378,354,333));

 var
  i,j :Integer;
  Res :array[0..1] of T8Single;

begin
  Result := True;
  if SRecSqrtYSingle(Feld,Res) then begin
    MulvalueYSingle(Res,1000);  // for compare
    RoundYSingle(Res);
    for i := 0 to 1 do
      for j := 0 to 7 do
        if Res[i,j] <> Soll[i,j] then
          Result := False;
  end
  else Result := False;
end;

function TestSumSRecSQRTYSingle :Boolean;
{Sum of secure reciprocal square root. Is a field zero ->
 no exception. zero = zero}
 const
   Feld :array[0..1] of T8Single = ((0,-0,25,64,100,400,625,10000),
                                    (2,3,4,5,6,7,8,9));
   Soll :Single = 4.23;

 var
  Res :Single;

begin
  Result := True;
  Res := SumSRecSqrtYSingle(Feld);
  Res := RoundYSingle(Res,2);
  if Res <> Soll then
    Result := False;
end;

function TestFastRecSQRTYSingle :Boolean;
{reciprocal of the square root.}
 const
   Soll :array[0..1] of T8Single = ((1,0.5,0.2,0.12,0.1,0.05,0.04,0.01),
                                    (1,0.5,0.2,0.12,0.1,0.05,0.04,0.01));

 var
  i,j  :Integer;
  Feld :array[0..1] of T8Single = ((1,4,25,64,100,400,625,10000),
                                   (1,4,25,64,100,400,625,10000));

begin
  Result := True;
  FastRecSqrtYSingle(Feld);
  for i := 0 to 1 do
    for j := 0 to 7 do
      if SimpleRoundTo(Feld[i,j],-2) <> Soll[i,j] then
        Result := False;
end;

function TestFastRecSQRTYSingle1 :Boolean;
{reciprocal of the square root.}
 const
   Feld :array[0..1] of T8Single = ((1,4,25,64,100,400,625,10000),
                                    (1,4,25,64,100,400,625,10000));
   Soll :array[0..1] of T8Single = ((1,0.5,0.2,0.12,0.1,0.05,0.04,0.01),
                                    (1,0.5,0.2,0.12,0.1,0.05,0.04,0.01));

 var
  i,j  :Integer;
  Res :array[0..1] of T8Single;

begin
  Result := True;
  if FastRecSqrtYSingle(Feld,Res) then begin
    for i := 0 to 1 do
      for j := 0 to 7 do
        if SimpleRoundTo(Res[i,j],-2) <> Soll[i,j] then
          Result := False;
  end
  else Result := False;
end;

function TestSumRecSQRTYSingle :Boolean;
{Sum of reciprocal square root of the array.}
 const
   Feld :array[0..0] of T8Single = ((1,4,25,64,100,400,625,10000));
   Soll :Single = 2.025;

 var
  Res :Single;

begin
  Result := True;
  Res := SumRecSqrtYSingle(Feld);
  if Res <> Soll then
    Result := False;
end;

function TestSumRecSQRTVYSingle :Boolean;
{Sum of reciprocal square root of array cols}
 const
   Feld :array[0..1] of T8Single = ((1,4,25,64,100,400,625,10000),
                                    (2,3,4,5,6,7,8,9));
   Soll :T8Single = (1.707,1.077,0.700,0.572,0.508,0.428,0.394,0.343);

 var
  j :Integer;
  Res :T8Single;

begin
  Result := True;
  Res := SumRecSqrtVYSingle(Feld);
  RoundYSingle(Res,3);
  RoundYSingle(Soll,3);
  for j := 0 to 7 do
    if Res[j] <> Soll[j] then
      Result := False;
end;

function TestSumSRecSQRTVYSingle :Boolean;
{Sum of secure reciprocal square root of array cols. (zero = zero)}
 const
   Feld :array[0..1] of T8Single = ((0,4,25,64,100,400,625,10000),
                                    (2,3,4,5,6,7,8,9));
   Soll :T8Single = (0.707,1.077,0.700,0.572,0.508,0.428,0.394,0.343);

 var
  j :Integer;
  Res :T8Single;

begin
  Result := True;
  Res := SumSRecSqrtVYSingle(Feld);
  RoundYSingle(Res,3);
  RoundYSingle(Soll,3);
  for j := 0 to 7 do
    if Res[j] <> Soll[j] then
      Result := False;
end;

function TestSQRTYDouble :Boolean;
{square root of array fields}
 const
   Soll :array[0..1] of T4Double = ((1,2,5,7),(2.828,3.00,3.162,3.317));

 var
  i,j  :Integer;
  Feld :array[0..1] of T4Double = ((1,4,25,49),(8,9,10,11));

begin
  Result := True;
  SqrtYDouble(Feld);
  RoundYDouble(Feld,3);
  RoundYDouble(Soll,3);
  for i := 0 to 1 do
    for j := 0 to 3 do
      if Feld[i,j] <> Soll[i,j] then
         Result := False;
end;

function TestSQRTYDouble1 :Boolean;
{square root of array fields}
 const
   Feld :array[0..1] of T4Double = ((1,4,25,49),(8,9,10,11));
   Soll :array[0..1] of T4Double = ((1,2,5,7),(2.828,3,3.162,3.317));

 var
  i,j :Integer;
  Res :array[0..1] of T4Double;

begin
  Result := True;
  SqrtYDouble(Feld,Res);
  RoundYDouble(Res,3);
  RoundYDouble(Soll,3);
  for i := 0 to 1 do
    for j := 0 to 3 do
      if Res[i,j] <> Soll[i,j] then
         Result := False;
end;

function TestSumSQRTYDouble :Boolean;
{sum of square root of array fields}
 const
   Feld :array[0..0] of T4Double = ((1,4,25,49));
   Soll :Double = 15.0;

 var
  Res :Double;

begin
  Result := True;
  Res := SumSqrtYDouble(Feld);
  if Res <> Soll then
    Result := False;
end;

function TestSumSQRTVYDouble :Boolean;
{sum of square root of array cols}
 const
   Feld :array[0..1] of T4Double = ((1,4,25,49),
                                    (1,4,25,49));
   Soll :T4Double = (2,4,10,14);

 var
  i : Integer;
  Res :T4Double;

begin
  Result := True;
  Res := SumSqrtVYDouble(Feld);
  for i := 0 to 3 do
    if Res[i] <> Soll[i] then
      Result := False;
end;


function TestRecSQRTYDouble :Boolean;
{reciprocal square root of array fields}
 const
   Soll :array[0..1] of T4Double = ((1,0.5,0.2,0.125),(0.354,0.333,0.316,0.302));

 var
  i,j  :Integer;
  Feld :array[0..1] of T4Double = ((1,4,25,64),(8,9,10,11));

begin
  Result := True;
  RecSqrtYDouble(Feld);
  RoundYDouble(Feld,3);
  RoundYDouble(soll,3);
  for i := 0 to 1 do
    for j := 0 to 3 do
      if Feld[i,j] <> Soll[i,j] then
        Result := False;
end;

function TestRecSQRTYDouble1 :Boolean;
{reciprocal square root of array fields}
 const
   Feld :array[0..1] of T4Double = ((1,4,25,64),(8,9,10,11));
   Soll :array[0..1] of T4Double = ((1,0.5,0.2,0.125),(0.354,0.333,0.316,0.302));

 var
  i,j :Integer;
  Res :array[0..1] of T4Double;

begin
  Result := True;
  RecSqrtYDouble(Feld,Res);
  RoundYDouble(Res,3);
  RoundYDouble(Soll,3);
  for i := 0 to 1 do
    for j := 0 to 3 do
      if Res[i,j] <> Soll[i,j] then
        Result := False;
end;

function TestSRecSQRTYDouble :Boolean;
{secure reciprocal square root of array fields. (zero = zero)}
 const
   Soll :array[0..1] of T4Double = ((0,0.5,0.2,0.125),(0.354,0.333,0.316,0.302));

 var
  i,j  :Integer;
  Feld :array[0..1] of T4Double = ((0,4,25,64),(8,9,10,11));

begin
  Result := True;
  SRecSqrtYDouble(Feld);
  RoundYDouble(Feld,3);
  RoundYDouble(soll,3);
  for i := 0 to 1 do
    for j := 0 to 3 do
      if Feld[i,j] <> Soll[i,j] then
        Result := False;
end;

function TestSRecSQRTYDouble1 :Boolean;
{secure reciprocal square root of array fields. (zero = zero)}
 const
   Feld :array[0..1] of T4Double = ((0,4,25,64),(8,9,10,11));
   Soll :array[0..1] of T4Double = ((0,0.5,0.2,0.125),(0.354,0.333,0.316,0.302));

 var
  i,j :Integer;
  Res :array[0..1] of T4Double;

begin
  Result := True;
  SRecSqrtYDouble(Feld,Res);
  RoundYDouble(Res,3);
  RoundYDouble(Soll,3);
  for i := 0 to 1 do
    for j := 0 to 3 do
      if Res[i,j] <> Soll[i,j] then
        Result := False;
end;

function TestSumRecSQRTYDouble :Boolean;
{sum of reciprocal square root of array fields.}
 const
   Feld :array[0..0] of T4Double = ((1,4,25,64));
   Soll :Double = 1.825;

 var
  Res :Double;

begin
  Result := True;
  Res := SumRecSqrtYDouble(Feld);
   if Res <> Soll then
        Result := False;
end;

function TestSumSRecSQRTYDouble :Boolean;
{sum of secure reciprocal square root of array. zer0 = zero}
 const
   Feld :array[0..1] of T4Double = ((0,4,25,64),(8,9,10,11));
   Soll :Double = 2.130;

 var
  Res :Double;

begin
  Result := True;
  Res := SumSRecSqrtYDouble(Feld);
  Res := RoundYDouble(Res,3);
  Soll :=RoundYDouble(Soll,3);
  if Res <> Soll then
    Result := False;
end;

function TestSumRecSQRTVYDouble :Boolean;
{sum of reciprocal square root of array cols}
 const
   Feld :array[0..1] of T4Double = ((1,4,25,64),(8,9,10,11));
   Soll :T4Double = (1.354,0.833,0.516,0.427);

 var
  j :Integer;
  Res :T4Double;

begin
  Result := True;
  Res := SumRecSqrtVYDouble(Feld);
  RoundYDouble(Res,3);
  RoundYDouble(Soll,3);
  for j := 0 to 3 do
    if Res[j] <> Soll[j] then
      Result := False;
end;

function TestSumSRecSQRTVYDouble :Boolean;
{sum of secure reciprocal square root of array cols (zero = zero}
 const
   Feld :array[0..1] of T4Double = ((0,4,25,64),(8,9,10,11));
   Soll :T4Double = (0.354,0.833,0.516,0.427);

 var
  j :Integer;
  Res :T4Double;

begin
  Result := True;
  Res := SumSRecSqrtVYDouble(Feld);
  RoundYDouble(Res,3);
  RoundYDouble(Soll,3);
  for j := 0 to 3 do
    if Res[j] <> Soll[j] then
      Result := False;
end;

{-----------------------------change sign----------------------------------}


function TestSignFlipFlopYSingle :Boolean;
{change the sign of the values. From + to - and from - to + }
 const
   Soll :array[0..0] of T8Single= ((1,-4,25,-64,-100,400,-625,10000));

 var
  i,j  :Integer;
  Feld :array[0..0] of T8Single = ((-1,4,-25,64,100,-400,625,-10000));

begin
  Result := True;
  SignFlipFlopYSingle(Feld);
  for i := 0 to 0 do
    for j := 0 to 7 do
      if Feld[i,j] <> Soll[i,j] then
        Result := False;
end;

function TestSetSignYSingle :Boolean;
{set the sign of the values. From + to - }
 const
   Soll :array[0..0] of T8Single= ((-1,-4,-25,-64,-100,-400,-625,-10000));

 var
  i,j :Integer;
  Feld :array[0..0] of T8Single = ((-1,4,-25,64,100,-400,625,-10000));

begin
  Result := True;
  SetSignYSingle(Feld);
  for i := 0 to 0 do
    for j := 0 to 7 do
      if Feld[i,j] <> Soll[i,j] then
        Result := False;
end;

function TestAbsYSingle :Boolean;
{get the absolute values of all array fields}

 const
   Soll :array[0..0] of T8Single= ((1,4,25,64,100,400,625,10000));

 var
  i,j :Integer;
  Feld :array[0..0] of T8Single = ((-1,4,-25,64,100,-400,625,-10000));

begin
  Result := True;
  AbsYSingle(Feld);
  for i := 0 to 0 do
    for j := 0 to 7 do
      if Feld[i,j] <> Soll[i,j] then
        Result := False;
end;

function TestSignFlipFlopYDouble :Boolean;
{change the sign of the values. From + to - and from - to + }
 const
   Soll :array[0..0] of T4Double = ((1,-4,25,-64));

 var
  i,j :Integer;
  Feld :array[0..0] of T4Double = ((-1,4,-25,64));

begin
  Result := True;
  SignFlipFlopYDouble(Feld);
  for i := 0 to 0 do
    for j := 0 to 3 do
      if Feld[i,j] <> Soll[i,j] then
        Result := False;
end;

function TestSetSignYDouble :Boolean;
{change the sign of the values. From + to - }
 const
   Soll :array[0..0] of T4Double = ((-1,-4,-25,-64));

 var
  i,j :Integer;
  Feld :array[0..0] of T4Double = ((-1,4,-25,64));

begin
  Result := True;
  SetSignYDouble(Feld);
  for i := 0 to 0 do
    for j := 0 to 3 do
      if Feld[i,j] <> Soll[i,j] then
        Result := False;
end;

function TestAbsYDouble :Boolean;
{get the absolute value of all array fields }
 const
   Soll :array[0..0] of T4Double = ((1,4,25,64));

 var
  i,j :Integer;
  Feld :array[0..0] of T4Double = ((-1,4,-25,64));

begin
  Result := True;
  AbsYDouble(Feld);
  for i := 0 to 0 do
    for j := 0 to 3 do
      if Feld[i,j] <> Soll[i,j] then
        Result := False;
end;


{-------------------------Trigonometrie------------------------------------}

function TestDegInRadYSingle:Boolean;
 {Change degree in radian}
 const
  Res  :array[0..1] of T8Single = ((0,0.52,0.79,1.57,3.67,3.93,4.71,6.28),
                                   (0.26,0.61,0.96,1.66,3.49,3.67,5.24,5.59));

 var
  i,j  :Integer;
  Test :array[0..1] of T8Single = ((0,30,45,90,210,225,270,360),
                                   (15,35,55,95,200,210,300,320));

 begin
  Result := True;
  DegInRadYSingle(Test);
  RoundYSingle(Test,2);
  RoundYSingle(Res,2);
    for i := 0 to 1 do
      for j := 0 to 7 do
        if Test[i,j] <> Res[i,j] then
          Result := False;
end;

function TestDegInRadYDouble:Boolean;
{Change degree in radian}
 const
  Res :array[0..1] of T4Double = ((0,0.52,0.79,1.57),(3.67,3.93,4.71,6.28));

 var
  i,j  :Integer;
  Test :array[0..1] of T4Double = ((0,30,45,90),(210,225,270,360));

 begin
  Result := True;
  DegInRadYDouble(Test);
  RoundYDouble(Res,2);
  RoundYDouble(test,2);
    for i := 0 to 1 do
      for j := 0 to 3 do
        if Test[i,j] <> Res[i,j] then
          Result := False;
end;

function TestGonInRadYSingle:Boolean;
 {Change gon in radian}
 const
  Res  :array[0..0] of T8Single = ((0,0.47,0.71,1.57,3.30,3.53,4.24,6.28));

 var
  i,j  :Integer;
  Test :array[0..0] of T8Single = ((0,30,45,100,210,225,270,400));

 begin
  Result := True;
  GonInRadYSingle(Test);
  RoundYSingle(Test,2);
  RoundYSingle(Res,2);
    for i := 0 to 0 do
      for j := 0 to 7 do
        if Test[i,j] <> Res[i,j] then
          Result := False;
end;

function TestGonInRadYDouble:Boolean;
{Change gon in radian}
 const
  Res  :array[0..1] of T4Double = ((0,0.47,0.71,1.57),(3.30,3.53,4.24,6.28));

 var
  i,j  :Integer;
  Test :array[0..1] of T4Double = ((0,30,45,100),(210,225,270,400));

 begin
  Result := True;
  GonInRadYDouble(Test);
  RoundYDouble(Res,2);
  RoundYDouble(test,2);
    for i := 0 to 1 do
      for j := 0 to 3 do
        if Test[i,j] <> Res[i,j] then
          Result := False;
end;

function TestRadInDegYSingle:Boolean;
 {Change radian in degree.}
 const
  Res  :array[0..1] of T8Single =
                 ((0,57.30,114.59,171.89,229.18,286.48,343.77,401.07),
                  (458.37,515.66,572.96,630.25,687.55,744.85,802.14,859.44));

 var
  i,j  :Integer;
  Test :array[0..1] of T8Single = ((0,1,2,3,4,5,6,7),(8,9,10,11,12,13,14,15));

 begin
  Result := True;
  RadInDegySingle(Test);
    for i := 0 to 1 do
      for j := 0 to 7 do
        if SimpleRoundTo(Test[i,j],-2) <> Res[i,j] then begin
          Result := False;
          Break;
        end;
end;

function TestRadInDegYDouble:Boolean;
{Change radian in degree.}
 const
  Res :array[0..1] of T4Double = ((0,57.30,114.59,171.89),
                                  (229.18,286.48,343.77,401.07));

 var
  i,j  :Integer;
  Test :array[0..1] of T4Double = ((0,1.0,2.0,3.0),(4,5,6,7));

 begin
  Result := True;
  RadInDegYDouble(Test);
    for i := 0 to 1 do
      for j := 0 to 3 do
        if SimpleRoundTo(Test[i,j],-2) <> Res[i,j] then begin
          Result := False;
          Break;
        end;
end;

function TestRadInGonYSingle:Boolean;
 {Change radian in gon}
 const
  Res  :array[0..0] of T8Single =
                 ((0,63.66,127.32,190.99,254.65,318.31,381.97,445.63));

 var
  i,j  :Integer;
  Test :array[0..0] of T8Single = ((0,1,2,3,4,5,6,7));

 begin
  Result := True;
  RadInGonYSingle(Test);
  RoundYSingle(Test,2);
  RoundYSingle(Res,2);
  for i := 0 to 0 do
    for j := 0 to 7 do
      if Test[i,j] <> Res[i,j] then
        Result := False;
end;

function TestRadInGonYDouble:Boolean;
{Change radian in gon}
 const
  Res  :array[0..1] of T4Double =
                 ((0,63.66,127.32,190.99),(254.65,318.31,381.97,445.63));

 var
  i,j  :Integer;
  Test :array[0..1] of T4Double = ((0,1,2,3),(4,5,6,7));

 begin
  Result := True;
  RadInGonYDouble(Test);
  RoundYDouble(res,2);
  RoundYDouble(Test,2);
  for i := 0 to 1 do
    for j := 0 to 3 do
      if Test[i,j] <> Res[i,j] then
        Result := False;
end;


function TestSinYSingle:Boolean;
 {Calculation of the sinus (y = sin(x). The values are in radian.}
 const
  Res_e1  :array[0..1] of T8Single =
     ((0,0.84,0.91,0.14,-0.76,-0.96,-0.28,0.66),
      (0.99,0.41,-0.54,-1.00,-0.54,0.42,0.99,0.65));
  Test :array[0..1] of T8Single = ((0,1,2,3,4,5,6,7),(8,9,10,11,12,13,14,15));

 var
  i,j  :Integer;
  Res  :array[0..1] of T8Single;

 begin
  Result := True;
  if SinYSingle(Test,Res) then begin
    for i := 0 to 1 do
      for j := 0 to 7 do
        if SimpleRoundTo(Res[i,j],-2) <> Res_e1[i,j] then
          Result := False;
   end
  else  Result := False;
end;

function TestSinYDouble:Boolean;
{Calculation of the sinus (y = sin(x). The values are in radian.}
 const
  Res_e1  :array[0..1] of T4double = ((0,0.84,0.91,0.14),
                                      (-0.76,-0.96,-0.28,0.66));
  Test :array[0..1] of T4Double = ((0,1,2,3),(4,5,6,7));

 var
  i,j  :Integer;
  Res  :array[0..1] of T4Double;

 begin
  Result := True;
  if SinYDouble(Test,Res) then begin
    for i := 0 to 1 do
      for j := 0 to 3 do
        if SimpleRoundTo(Res[i,j],-2) <> Res_e1[i,j] then begin
          Result := False;
          Break;
        end;
   end
  else Result := False;
end;

function TestSinCosYSingle:Boolean;
 {Calculation of the sinus and cosinus. The values are in radian.}
 const
  Test  :array[0..1] of T8Single = ((0,1,2,3,4,5,6,7),(8,9,10,11,12,13,14,15));
  Sin_e :array[0..1] of T8Single =
     ((0,0.84,0.91,0.14,-0.76,-0.96,-0.28,0.66),
      (0.99,0.41,-0.54,-1.00,-0.54,0.42,0.99,0.65));

  Cos_e :array[0..1] of T8Single =
         ((1.0,0.54,-0.42,-0.99,-0.65,0.28,0.96,0.75),
          (-0.15,-0.91,-0.84,0.00,0.84,0.91,0.14,-0.76));

 var
  i,j  :Integer;
  Sin  :array[0..1] of T8Single;
  Cos  :array[0..1] of T8Single;

 begin
  Result := True;
  if SinCosYSingle(Test,Sin,Cos) then begin
    RoundYSingle(Sin,2);
    RoundYSingle(Sin_e,2);
    RoundYSingle(Cos,2);
    RoundYSingle(Cos_e,2);
    for i := 0 to 1 do
      for j := 0 to 7 do begin
        if Sin[i,j] <> Sin_e[i,j] then
          Result := False;
        if Cos[i,j] <> Cos_e[i,j] then
          Result := False;
      end;
   end
  else  Result := False;
end;

function TestSinCosYDouble:Boolean;
{Calculation of the sinus and cosinus. The values are in radian.}
 const
  Test  :array[0..1] of T4Double = ((0,1,2,3),(4,5,6,7));
  Sin_e :array[0..1] of T4double = ((0,0.84,0.91,0.14),
                                    (-0.76,-0.96,-0.28,0.66));
  Cos_e :array[0..1] of T4Double = ((1.0,0.54,-0.42,-0.99),
                                     (-0.65,0.28,0.96,0.75));

 var
  i,j :Integer;
  Sin :array[0..1] of T4Double;
  Cos :array[0..1] of T4Double;

 begin
  Result := True;
  if SinCosYDouble(Test,Sin,Cos) then begin
    RoundYDouble(Sin,2);
    RoundYDouble(Sin_e,2);
    RoundYDouble(Cos,2);
    RoundYDouble(Cos_e,2);
    for i := 0 to 1 do
      for j := 0 to 3 do begin
        if Sin[i,j] <> Sin_e[i,j] then
          Result := False;
        if Cos[i,j] <> Cos_e[i,j] then
          Result := False;
      end;
   end
  else Result := False;
end;


function TestCosYSingle:Boolean;
 {Calculation of the cosinus (y = cos(x). The values are in radian.}
 const
  Res_e1  :array[0..1] of T8Single =
         ((1.0,0.54,-0.42,-0.99,-0.65,0.28,0.96,0.75),
          (-0.15,-0.91,-0.84,0.00,0.84,0.91,0.14,-0.76));
  Test :array[0..1] of T8Single = ((0,1,2,3,4,5,6,7),(8,9,10,11,12,13,14,15));

 var
  i,j  :Integer;
  Res  :array[0..1] of T8Single;

 begin
  Result := True;
  if CosYSingle(Test,Res) then begin
    for i := 0 to 1 do
      for j := 0 to 7 do
        if SimpleRoundTo(Res[i,j],-2) <> Res_e1[i,j] then
          Result := False;
   end
  else Result := False;
end;

function TestCosYDouble:Boolean;
{Calculation of the cosinus (y = cos(x). The values are in radian.}
 const
  Res_e1 :array[0..1] of T4Double = ((1.0,0.54,-0.42,-0.99),
                                     (-0.65,0.28,0.96,0.75));
  Test :array[0..1] of T4Double = ((0,1,2,3),(4,5,6,7));

 var
  i,j  :Integer;
  Res  :array[0..1] of T4Double;

 begin
  Result := True;
  if CosYDouble(Test,Res) then begin
    for i := 0 to 1 do
      for j := 0 to 3 do
        if SimpleRoundTo(Res[i,j],-2) <> Res_e1[i,j] then begin
          Result := False;
          Break;
        end;
   end
  else Result := False;
end;


function TestTanYSingle:Boolean;
 {Calculation of the tangens (y = tan(x). The values are in radian.}
 const
  Res_e1  :array[0..1] of T8Single =
     ((0.0,1.56,-2.19,-0.14,1.16,-3.38,-0.29,0.87),
      (-6.80,-0.45,0.65,-225.95,-0.64,0.46,7.24,-0.86));
  Test :array[0..1] of T8Single = ((0,1,2,3,4,5,6,7),(8,9,10,11,12,13,14,15));

 var
  i,j  :Integer;
  Res  :array[0..1] of T8Single;

 begin
  Result := True;
  if TanYSingle(Test,Res) then begin
    for i := 0 to 1 do
      for j := 0 to 7 do
        if SimpleRoundTo(Res[i,j],-2) <> Res_e1[i,j] then begin
          Result := False;
          Break;
        end;
   end
  else Result := False;
end;

function TestTanYDouble:Boolean;
{Calculation of the tangens (y = tan(x). The values are in radian.}
 const
   Res_e1  :array[0..1] of T4Double = ((0.0,1.56,-2.19,-0.14),
                                       (1.16,-3.38,-0.29,0.87));
   Test :array[0..1] of T4Double = ((0,1,2,3),(4,5,6,7));

 var
  i,j  :Integer;
  Res  :array[0..1] of T4Double;

 begin
  Result := True;
  if TanYDouble(Test,Res) then begin
    for i := 0 to 1 do
      for j := 0 to 3 do
        if SimpleRoundTo(Res[i,j],-2) <> Res_e1[i,j] then begin
          Result := False;
          Break;
        end;
   end
  else Result := False;
end;

function TestCotanYSingle:Boolean;
 {Calculation of the cotangens (y = cot(x). The values are in radian.}
 const
  Res_e1  :array[0..1] of T8Single =
     ((9.97,0.64,-0.46,-7.02,0.86,-0.30,-3.44,1.15),
      (-0.15,-2.21,1.54,-0.00,-1.57,2.16,0.14,-1.17));
  Test :array[0..1] of T8Single = ((0.1,1,2,3,4,5,6,7),(8,9,10,11,12,13,14,15));

 var
  i,j  :Integer;
  Res  :array[0..1] of T8Single;

 begin
  Result := True;
  if CotanYSingle(Test,Res) then begin
    for i := 0 to 1 do
      for j := 0 to 7 do
        if SimpleRoundTo(Res[i,j],-2) <> Res_e1[i,j] then begin
          Result := False;
          Break;
        end;
   end
  else Result := False;
end;

function TestCotanYDouble:Boolean;
{Calculation of the cotangens (y = cot(x). The values are in radian.}
 const
  Res_e1  :array[0..1] of T4Double = ((9.97,0.64,-0.46,-7.02),
                                      (0.86,-0.30,-3.44,1.15));
  Test :array[0..1] of T4Double = ((0.1,1,2,3),(4,5,6,7));

 var
  i,j  :Integer;
  Res  :array[0..1] of T4Double;

 begin
  Result := True;
  if CotanYDouble(Test,Res) then begin
    for i := 0 to 1 do
      for j := 0 to 3 do
        if SimpleRoundTo(Res[i,j],-2) <> Res_e1[i,j] then begin
          Result := False;
          Break;
        end;
   end
  else Result := False;
end;

function TestArcSinYSingle:Boolean;
 {Calculation of the arcus sinus (y = arcsin(x). The values are in radian.}
 const
  Res_e1  :array[0..1] of T8Single = ((0,1.57,0.52,1.12,0.30,0.41,0.64,0.78),
                            (0.93,-1.57,-0.10,-0.2,-0.30,-0.41,-0.52,-0.93));
  Test :array[0..1] of T8Single = ((0,1,0.5,0.9,0.3,0.4,0.6,0.7),
                                   (0.8,-1.0,-0.1,-0.2,-0.3,-0.4,-0.5,-0.8));

 var
  i,j  :Integer;
  Res  :array[0..1] of T8Single;

 begin
  Result := True;
  if ArcSinYSingle(Test,Res) then begin
    for i := 0 to 1 do
      for j := 0 to 7 do
        if SimpleRoundTo(Res[i,j],-2) <> Res_e1[i,j] then begin
          Result := False;
          Break;
        end;
   end
  else Result := False;
end;

function TestArcSinYDouble:Boolean;
{Calculation of the arcus sinus (y = arcsin(x). The values are in radian.}
 const
  Res_e1  :array[0..1] of T4Double = ((0,1.57,0.52,1.12),
                                       (0.30,0.41,0.64,0.78));
  Test :array[0..1] of T4Double = ((0,1,0.5,0.9),(0.3,0.4,0.6,0.7));

 var
  i,j  :Integer;
  Res  :array[0..1] of T4Double;

 begin
  Result := True;
  if ArcSinYDouble(Test,Res) then begin
    for i := 0 to 1 do
      for j := 0 to 3 do
        if SimpleRoundTo(Res[i,j],-2) <> Res_e1[i,j] then begin
          Result := False;
          Break;
        end;
   end
  else Result := False;
end;


function TestArcCosYSingle:Boolean;
 {Calculation of the arcus cosinus (y = arccos(x). The values are in radian.}
 const
  Res_e1  :array[0..1] of T8Single =
      ((1.57,0.0,1.05,0.45,1.27,1.16,0.93,0.80),
      (1.67,2.09,2.69,1.88,1.98,2.21,2.35,2.50));
  Test :array[0..1] of T8Single = ((0,1,0.5,0.9,0.3,0.4,0.6,0.7),
                                   (-0.1,-0.5,-0.9,-0.3,-0.4,-0.6,-0.7,-0.8));

 var
  i,j  :Integer;
  Res  :array[0..1] of T8Single;

 begin
  Result := True;
  if ArcCosYSingle(Test,Res) then begin
    for i := 0 to 1 do
      for j := 0 to 7 do
        if SimpleRoundTo(Res[i,j],-2) <> Res_e1[i,j] then begin
          Result := False;
          Break;
        end;
   end
  else Result := False;
end;

function TestArcCosYDouble:Boolean;
{Calculation of the arcus cosinus (y = arccos(x). The values are in radian.}
 const
  Res_e1 :array[0..1] of T4Double = ((1.57,0.0,1.05,0.45),
                                     (1.27,1.16,0.93,0.80));
  Test :array[0..1] of T4Double = ((0,1,0.5,0.9),(0.3,0.4,0.6,0.7));

 var
  i,j  :Integer;
  Res  :array[0..1] of T4Double;

 begin
  Result := True;
  if ArcCosYDouble(Test,Res) then begin
    for i := 0 to 1 do
      for j := 0 to 3 do
        if SimpleRoundTo(Res[i,j],-2) <> Res_e1[i,j] then begin
          Result := False;
          Break;
        end;
   end
  else Result := False;
end;

function TestArctanYSingle:Boolean;
 {Calculation of the arcus tangens (y = arctan(x). The values are in radian.}
 const
  Res_e1  :array[0..1] of T8Single =
     ((0.0,0.79,0.46,0.73,0.29,0.38,0.54,0.61),
      (0.67,0.73,0.79,0.83,0.88,0.92,0.95,0.98));
  Feld :array[0..1] of T8Single = ((0.0,1.0,0.5,0.9,0.3,0.4,0.6,0.7),
                                   (0.8,0.9,1.0,1.1,1.2,1.3,1.4,1.5));

 var
  i,j  :Integer;
  Res  :array[0..1] of T8Single;

 begin
  Result := True;
  if ArctanYSingle(Feld,Res) then begin
    for i := 0 to 1 do
      for j := 0 to 7 do
        if SimpleRoundTo(Res[i,j],-2) <> Res_e1[i,j] then begin
          Result := False;
          Break;
        end;
   end
  else Result := False;
end;

function TestArcTanYDouble:Boolean;
{Calculation of the arcus tangens (y = arctan(x). The values are in radian.}
 const
   Res_e :array[0..1] of T4Double = ((0.0,0.79,0.46,0.73),
                                      (0.29,0.38,0.54,0.61));
   Feld :array[0..1] of T4Double = ((0,1,0.5,0.9),(0.3,0.4,0.6,0.7));

 var
  i,j   :Integer;
  Res   :array[0..1] of T4Double;

 begin
  Result := True;
  if ArcTanYDouble(Feld,Res) then begin
    for i := 0 to 1 do
      for j := 0 to 3 do
        if SimpleRoundTo(Res[i,j],-2) <> Res_e[i,j] then begin
          Result := False;
          Break;
        end;
   end
  else Result := False;
end;

function TestArcCotYSingle:Boolean;
 {Calculation of the arcus cotangens (y = arccot(x). The values are in radian.}
 const
  Res_e1  :array[0..1] of T8Single =
     ((1.57,1.47,1.37,1.28,1.19,1.11,1.03,0.96),
      (0.90,0.84,0.79,0.74,0.69,0.66,0.62,0.59));
  Feld :array[0..1] of T8Single = ((0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7),
                                   (0.8,0.9,1.0,1.1,1.2,1.3,1.4,1.5));

 var
  i,j  :Integer;
  Res  :array[0..1] of T8Single;

 begin
  Result := True;
  if ArcCotYSingle(Feld,Res) then begin
    for i := 0 to 1 do
      for j := 0 to 7 do
        if SimpleRoundTo(Res[i,j],-2) <> Res_e1[i,j] then
          Result := False;
   end
  else Result := False;
end;

function TestArcCotYDouble:Boolean;
{Calculation of the arcus cotangens (y = arccot(x). The values are in radian.}
 const
  Res_e :array[0..1] of T4Double =
        ((1.57,1.47,1.37,1.28),(1.19,1.11,1.03,0.96));
  Feld :array[0..1] of T4Double = ((0.0,0.1,0.2,0.3),(0.4,0.5,0.6,0.7));

 var
  i,j   :Integer;
  Res   :array[0..1] of T4Double;

 begin
  Result := True;
  if ArcCotYDouble(Feld,Res) then begin
    for i := 0 to 1 do
      for j := 0 to 3 do
        if SimpleRoundTo(Res[i,j],-2) <> Res_e[i,j] then begin
          Result := False;
          Break;
        end;
   end
  else Result := False;
end;

function TestSinhYSingle:Boolean;
 {Calculation of the sinus hyperbolicus (y = sinh(x). The values are in radian.}
 const
  Res_e1  :array[0..1] of T8Single =
     ((0.0,1.18,3.63,10.02,27.29,74.20,201.71,548.32),
      (1490.48,4051.54,11013.23,12171.51,13451.59,14866.31,16429.81,18157.75));
  Feld :array[0..1] of T8Single =
     ((0,1,2,3,4,5,6,7),(8,9,10,10.1,10.2,10.3,10.4,10.5));

 var
  i,j  :Integer;
  Res  :array[0..1] of T8Single;

 begin
  Result := True;
  if SinhYSingle(Feld,Res) then begin
    for i := 0 to 1 do
      for j := 0 to 7 do
        if SimpleRoundTo(Res[i,j],-2) <> Res_e1[i,j] then begin
          Result := False;
          Break;
        end;
   end
  else Result := False;
end;

function TestSinhYDouble:Boolean;
{Calculation of the sinus hyperbolicus (y = sinh(x). The values are in radian.}
 const
   Feld   :array[0..1] of T4Double = ((0,1,2,3),(4,5,6,7));
   Res_e1 :array[0..1] of T4Double = ((0.0,1.18,3.63,10.02),
                                      (27.29,74.20,201.71,548.32));

 var
  i,j  :Integer;
  Res  :array[0..1] of T4Double;

 begin
  Result := True;
  if SinhYDouble(Feld,Res) then begin
    RoundYDouble(Res,2);
    RoundYDouble(Res_e1,2);
    for i := 0 to 1 do
      for j := 0 to 3 do
        if Res[i,j] <> Res_e1[i,j] then begin
          Result := False;
          Break;
        end;
   end
  else Result := False;
end;

function TestSechYSingle:Boolean;
 {Calculation of the secans hyperbolicus (y = sech(x). The values are in radian.}
 const
  Feld  :array[0..0] of T8Single = ((0,1,2,3,4,5,-1,-2));
  Res_e :array[0..0] of T8Single = ((1,0.65,0.27,0.10,0.04,0.01,0.65,0.27));

 var
  i,j  :Integer;
  Res  :array[0..0] of T8Single;

 begin
  Result := True;
  if SechYSingle(Feld,Res) then begin
    RoundYSingle(Res,2);
    RoundYSingle(Res_e,2);
    for i := 0 to 0 do
      for j := 0 to 7 do
        if Res[i,j] <> Res_e[i,j] then
          Result := False;
   end
  else Result := False;
end;

function TestSechYDouble:Boolean;
{Calculation of the secans hyperbolicus (y = sech(x). The values are in radian.}
 const
   Feld  :array[0..1] of T4Double = ((0,1,2,3),(4,5,-1,-2));
   Res_e :array[0..1] of T4Double = ((1,0.65,0.27,0.10),(0.04,0.01,0.65,0.27));

 var
  i,j  :Integer;
  Res  :array[0..1] of T4Double;

 begin
  Result := True;
  if SechYDouble(Feld,Res) then begin
    RoundYDouble(Res,2);
    RoundYDouble(Res_e,2);
    for i := 0 to 1 do
      for j := 0 to 3 do
        if Res[i,j] <> Res_e[i,j] then
          Result := False;
   end
  else Result := False;
end;

function TestCschYSingle:Boolean;
 {Calculation of the cosecans hyperbolicus (y = cosech(x). The values are in radian.}
 const
  Feld :array[0..0] of T8Single = ((0.1,1,2,3,4,5,-1,-2));
  Res_e:array[0..0] of T8Single = ((9.98,0.85,0.28,0.10,0.04,0.01,-0.85,-0.28));

 var
  i,j  :Integer;
  Res  :array[0..0] of T8Single;

 begin
  Result := True;
  if CschYSingle(Feld,Res) then begin
    RoundYSingle(Res,2);
    RoundYSingle(Res_e,2);
    for i := 0 to 0 do
      for j := 0 to 7 do
        if Res[i,j] <> Res_e[i,j] then
          Result := False;
   end
  else Result := False;
end;

function TestCschYDouble:Boolean;
{Calculation of the cosecans hyperbolicus (y = cosech(x). The values are in radian.}
 const
   Feld :array[0..1] of T4Double = ((0.1,1,2,3),(4,5,-1,-2));
   Res_e:array[0..1] of T4Double = ((9.98,0.85,0.28,0.10),(0.04,0.01,-0.85,-0.28));

 var
  i,j  :Integer;
  Res  :array[0..1] of T4Double;

 begin
  Result := True;
  if CschYDouble(Feld,Res) then begin
    RoundYDouble(Res,2);
    RoundYDouble(Res_e,2);
    for i := 0 to 1 do
      for j := 0 to 3 do
        if Res[i,j] <> Res_e[i,j] then
          Result := False;
   end
  else Result := False;
end;


function TestCoshYSingle:Boolean;
{Calculation of the cosinus hyperbolicus (y = cosh(x). The values are in radian.}
 const
  Res_e1  :array[0..1] of T8Single =
     ((1.0,1.54,3.76,10.07,27.31,74.21,201.72,548.32),
      (605.98,669.72,740.15,817.99,904.02,999.10,1104.17,1220.30));
  feld :array[0..1] of T8Single = ((0,1,2,3,4,5,6,7),
                                   (7.1,7.2,7.3,7.4,7.5,7.6,7.7,7.8));

 var
  i,j  :Integer;
  Res  :array[0..1] of T8Single;

 begin
  Result := True;
  if CoshYSingle(Feld,Res) then begin
    for i := 0 to 1 do
      for j := 0 to 7 do
        if SimpleRoundTo(Res[i,j],-2) <> Res_e1[i,j] then begin
          Result := False;
          Break;
        end;
   end
  else Result := False;
end;

function TestCoshYDouble:Boolean;
{Calculation of the cosinus hyperbolicus (y = cosh(x). The values are in radian.}
 const
  Res_e1 :array[0..1] of T4Double = ((1.0,1.54,3.76,10.07),
                                     (27.31,74.21,201.72,548.32));
  Feld :array[0..1] of T4Double = ((0,1,2,3),(4,5,6,7));

 var
  i,j  :Integer;
  Res  :array[0..1] of T4Double;

 begin
  Result := True;
  if CoshYDouble(Feld,Res) then begin
    for i := 0 to 1 do
      for j := 0 to 3 do
        if SimpleRoundTo(Res[i,j],-2) <> Res_e1[i,j] then begin
          Result := False;
          Break;
        end;
   end
  else Result := False;
end;

function TestTanhYSingle:Boolean;
 {Calculation of the tangens hyperbolicus (y = tanh(x). The values are in radian.}
 const
  Res_e1  :array[0..1] of T8Single =
     ((0.0,0.76,0.96,1.00,1.00,1.00,1.00,1.00),
      (1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00));
  feld :array[0..1] of T8Single = ((0,1,2,3,4,5,6,7),(8,9,10,11,12,13,14,15));

 var
  i,j  :Integer;
  Res  :array[0..1] of T8Single;

 begin
  Result := True;
  if TanhYSingle(Feld,Res) then begin
    for i := 0 to 1 do
      for j := 0 to 7 do
        if SimpleRoundTo(Res[i,j],-2) <> Res_e1[i,j] then begin
          Result := False;
          Break;
        end;
   end
  else Result := False;
end;

function TestTanhYDouble:Boolean;
{Calculation of the tangens hyperbolicus (y = tanh(x). The values are in radian.}
 const
  Res_e1 :array[0..1] of T4Double = ((0.0,0.76,0.96,1.00),
                                     (1.00,1.00,1.00,1.00));
  Feld :array[0..1] of T4Double = ((0,1,2,3),(4,5,6,7));

 var
  i,j  :Integer;
  Res  :array[0..1] of T4Double;

 begin
  Result := True;
  if TanhYDouble(Feld,Res) then begin
    for i := 0 to 1 do
      for j := 0 to 3 do
        if SimpleRoundTo(Res[i,j],-2) <> Res_e1[i,j] then begin
          Result := False;
          Break;
        end;
   end
  else Result := False;
end;


function TestCothYSingle:Boolean;
{Calculation of the cotangens hyperbolicus (y = coth(x). The values are in radian.}
 const
  Res_e1  :array[0..1] of T8Single =
    ((10.03,1.31,1.04,1.00,1.03,1.02,1.02,1.02),
     (5.07,3.43,2.63,2.16,1.86,1.65,1.51,1.40));
  feld :array[0..1] of T8Single = ((0.1,1.0,2.0,3.0,2.1,2.2,2.3,2.4),
                                   (0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9));

 var
  i,j  :Integer;
  Res  :array[0..1] of T8Single;

 begin
  Result := True;
  if CothYSingle(Feld,Res) then begin
    for i := 0 to 1 do
      for j := 0 to 7 do
        if SimpleRoundTo(Res[i,j],-2) <> Res_e1[i,j] then begin
          Result := False;
          Break;
        end;
   end
  else Result := False;
end;

function TestCothYDouble:Boolean;
{Calculation of the cotangens hyperbolicus (y = coth(x). The values are in radian.}
 const
  Res_e1 :array[0..1] of T4Double = ((10.03,1.31,1.04,1.00),
                                     (1.00,1.00,1.00,1.00));
  Feld :array[0..1] of T4Double = ((0.1,1,2,3),(4,5,6,7));

 var
  i,j  :Integer;
  Res  :array[0..1] of T4Double;

 begin
  Result := True;
  if CothYDouble(Feld,Res) then begin
    for i := 0 to 1 do
      for j := 0 to 3 do
        if SimpleRoundTo(Res[i,j],-2) <> Res_e1[i,j] then begin
          Result := False;
          Break;
        end;
   end
  else Result := False;
end;


function TestArSinhYSingle:Boolean;
 {Calculation of the area sinus hyperbolicus (y = arsinh(x). The values are in radian.}
 const
  Feld :array[0..1] of T8Single = ((0,1,2,3,4,5,6,7),
                                   (8,9,10,11,12,13,14,15));
  Res_e1  :array[0..1] of T8Single = ((0,0.88,1.44,1.82,2.09,2.31,2.49,2.64),
                                      (2.78,2.89,3.00,3.09,3.18,3.26,3.33,3.40));

 var
  i,j  :Integer;
  Res  :array[0..1] of T8Single;

 begin
  Result := True;
  if ArSinhYSingle(Feld,Res) then begin
    RoundYSingle(Res,2);
    RoundYSingle(Res_e1,2);
    for i := 0 to 1 do
      for j := 0 to 7 do
        if Res[i,j] <> Res_e1[i,j] then
          Result := False;
   end
  else Result := False;
end;

function TestArSinhYDouble:Boolean;
{Calculation of the area sinus hyperbolicus (y = arsinh(x). The values are in radian.}
 const
  Feld   :array[0..1] of T4Double = ((0,1,2,3),(4,5,6,7));
  Res_e1 :array[0..1] of T4Double = ((0,0.88,1.44,1.82),(2.09,2.31,2.49,2.64));

 var
  i,j  :Integer;
  Res  :array[0..1] of T4Double;

 begin
  Result := True;
  if ArSinhYDouble(Feld,Res) then begin
    RoundYDouble(Res,2);
    RoundYDouble(Res_e1,2);
    for i := 0 to 1 do
      for j := 0 to 3 do
        if Res[i,j] <> Res_e1[i,j] then
          Result := False;
   end
  else Result := False;
end;

function TestArCoshYSingle:Boolean;
{Calculation of the area cosinus hyperbolicus (y = arcosh(x).
 The values are in radian.}
 const
  Feld :array[0..1] of T8Single = ((1,2,3,4,5,6,7,8),
                                   (9,10,11,12,13,14,15,16));
  Res_e1  :array[0..1] of T8Single = ((0,1.32,1.76,2.06,2.29,2.48,2.63,2.77),
                                      (2.89,2.99,3.09,3.18,3.26,3.33,3.40,3.46));

 var
  i,j  :Integer;
  Res  :array[0..1] of T8Single;

 begin
  Result := True;
  if ArCoshYSingle(Feld,Res) then begin
    RoundYSingle(Res,2);
    RoundYSingle(Res_e1,2);
    for i := 0 to 1 do
      for j := 0 to 7 do
        if Res[i,j] <> Res_e1[i,j] then
          Result := False;
   end
  else Result := False;
end;

function TestArCoshYDouble:Boolean;
{Calculation of the area cosinus hyperbolicus (y = arcosh(x).
 The values are in radian.}
 const
  Feld   :array[0..1] of T4Double = ((1,2,3,4),(5,6,7,8));
  Res_e1 :array[0..1] of T4Double = ((0,1.32,1.76,2.06),(2.29,2.48,2.63,2.77));

 var
  i,j  :Integer;
  Res  :array[0..1] of T4Double;

 begin
  Result := True;
  if ArCoshYDouble(Feld,Res) then begin
    RoundYDouble(Res,2);
    RoundYDouble(Res_e1,2);
    for i := 0 to 1 do
      for j := 0 to 3 do
        if Res[i,j] <> Res_e1[i,j] then
          Result := False;
   end
  else Result := False;
end;

function TestArTanhYSingle:Boolean;
 {Calculation of the area tangens hyperbolicus (y = artanh(x).
 The values are in radian.}
 const
  Feld :array[0..1] of T8Single = ((-0.9,-0.8,-0.7,-0.6,-0.5,-0.4,-0.3,-0.2),
                                   (-0.1,0,0.1,0.2,0.3,0.4,0.5,0.6));
  Res_e1  :array[0..1] of T8Single =
    ((-1.47,-1.10,-0.87,-0.69,-0.55,-0.42,-0.31,-0.20),
     (-0.10,0,0.10,0.20,0.31,0.42,0.55,0.69));

 var
  i,j  :Integer;
  Res  :array[0..1] of T8Single;

 begin
  Result := True;
  if ArTanhYSingle(Feld,Res) then begin
    RoundYSingle(Res,2);
    RoundYSingle(Res_e1,2);
    for i := 0 to 1 do
      for j := 0 to 7 do
        if Res[i,j] <> Res_e1[i,j] then
          Result := False;
   end
  else Result := False;
end;

function TestArTanhYDouble:Boolean;
{Calculation of the area tangens hyperbolicus (y = artanh(x).
The values are in radian.}
 const
  Feld :array[0..1] of T4Double = ((-0.9,-0.8,-0.7,-0.6),(-0.5,-0.4,-0.3,-0.2));
  Res_e1  :array[0..1] of T4Double =
    ((-1.47,-1.10,-0.87,-0.69),(-0.55,-0.42,-0.31,-0.20));

 var
  i,j  :Integer;
  Res  :array[0..1] of T4Double;

 begin
  Result := True;
  if ArTanhYDouble(Feld,Res) then begin
    RoundYDouble(Res,2);
    RoundYDouble(Res_e1,2);
    for i := 0 to 1 do
      for j := 0 to 3 do
        if Res[i,j] <> Res_e1[i,j] then
          Result := False;
   end
  else Result := False;
end;


{----------------------------rounding-------------------------------------}

function TestRoundYSingle :Boolean;
{round the array to integer,round nearest}
 const
   Soll :array[0..0] of T8Single = ((-1,3,4,-25,64,124,12,8));

 var
  i,j :Integer;
  Feld :array[0..0] of T8Single = ((-1.125,2.678,4.05,-25.04,
                                    64.007,123.67,11.77,7.567));

begin
  Result := True;
  RoundYSingle(Feld);
  for i := 0 to 0 do
    for j := 0 to 7 do
      if Feld[i,j] <> Soll[i,j] then
        Result := False;
end;

function TestTruncateYSingle :Boolean;
{round the array to integer,chop}
 const
   Soll :array[0..0] of T8Single = ((-1,2,4,-25,64,123,11,7));

 var
  i,j :Integer;
  Feld :array[0..0] of T8Single = ((-1.125,2.678,4.05,-25.04,
                                    64.007,123.67,11.77,7.567));

begin
  Result := True;
  TruncateYSingle(Feld);
  for i := 0 to 0 do
    for j := 0 to 7 do
      if Feld[i,j] <> Soll[i,j] then
        Result := False;
end;

function TestFloorYSingle :Boolean;
{round the array to integer,round in direction -oo}
 const
   Soll :array[0..0] of T8Single = ((-2,2,4,-26,64,123,11,7));

 var
  i,j :Integer;
  Feld :array[0..0] of T8Single = ((-1.125,2.678,4.05,-25.04,
                                    64.007,123.67,11.77,7.567));

begin
  Result := True;
  FloorYSingle(Feld);
  for i := 0 to 0 do
    for j := 0 to 7 do
      if Feld[i,j] <> Soll[i,j] then
        Result := False;
end;

function TestCeilYSingle :Boolean;
{round the array to integer,round in direction +oo}
 const
   Soll :array[0..0] of T8Single = ((-1,3,5,-25,65,124,12,8));

 var
  i,j :Integer;
  Feld :array[0..0] of T8Single = ((-1.125,2.678,4.05,-25.04,
                                    64.007,123.67,11.77,7.567));

begin
  Result := True;
  CeilYSingle(Feld);
  for i := 0 to 0 do
    for j := 0 to 7 do
      if Feld[i,j] <> Soll[i,j] then
        Result := False;
end;

function TestRoundYDouble :Boolean;
{round araay to integer, round nearest}
 const
   Soll :array[0..0] of T4Double = ((-1,3,4,-25));

 var
  i,j :Integer;
  Feld :array[0..0] of T4Double = ((-1.125,2.678,4.05,-25.04));

begin
  Result := True;
  RoundYDouble(Feld);
  for i := 0 to 0 do
    for j := 0 to 3 do
      if Feld[i,j] <> Soll[i,j] then
        Result := False;
end;

function TestTruncateYDouble :Boolean;
{round araay to integer, chop}
 const
   Soll :array[0..0] of T4Double = ((-1,2,4,-25));

 var
  i,j :Integer;
  Feld :array[0..0] of T4Double = ((-1.125,2.678,4.05,-25.04));

begin
  Result := True;
  TruncateYDouble(Feld);
  for i := 0 to 0 do
    for j := 0 to 3 do
      if Feld[i,j] <> Soll[i,j] then
        Result := False;
end;

function TestFloorYDouble :Boolean;
{round araay to integer, round to -oo}
 const
   Soll :array[0..0] of T4Double = ((-2,2,4,-26));

 var
  i,j :Integer;
  Feld :array[0..0] of T4Double = ((-1.125,2.678,4.05,-25.04));

begin
  Result := True;
  FloorYDouble(Feld);
  for i := 0 to 0 do
    for j := 0 to 3 do
      if Feld[i,j] <> Soll[i,j] then
        Result := False;
end;

function TestCeilYDouble :Boolean;
{round araay to integer, round to +oo}
 const
   Soll :array[0..0] of T4Double = ((-1,3,5,-25));

 var
  i,j :Integer;
  Feld :array[0..0] of T4Double = ((-1.125,2.678,4.05,-25.04));

begin
  Result := True;
  CeilYDouble(Feld);
  for i := 0 to 0 do
    for j := 0 to 3 do
      if Feld[i,j] <> Soll[i,j] then
        Result := False;
end;


function TestRoundYSingle1 :Boolean;
 {Round all the array fields to nearest and give a float result.
  min. digits = 1}
 const
  Res     :array[0..1] of T8Single = ((-1.62,2.51,3.98,4.13,
                                      102.45,789.79,2.2200,0.56),
                                      (-400.12,-600.12,700.12,
                                      800.12,900.12,1000.12,
                                      1100.12,1200.12));

 var
  i,j  :Integer;
  Test :array[0..1] of T8Single = ((-1.62456,2.5097,3.9784,4.1346,
                                   102.45,789.7890,2.2201,0.560),
                                   (-400.12345,-600.12345,700.12345,
                                   800.12345,900.12345,1000.12345,
                                   1100.12345,1200.12345));

begin
  Result := True;
  RoundYSingle(Test,2);
  RoundYSingle(Res,2);
  for i := 0 to 1 do
   for j := 0 to 7 do
     if Test[i,j] <> Res[i,j] then
       Result := False;
end;

function TestRoundYSingle2 :Boolean;
 {Round all the array fields to nearest and give a float result.
  min. digits = 1}
 const
   Value :Single = -1.62456;
   Soll  :Single = -1.62;

 var
  Res :Single;

begin
  Result := True;
  Res := RoundYSingle(Value,2);
  if Res <> Soll then
    Result := False;
end;

function TestRoundYDouble1 :Boolean;
 {Round all the array fields to nearest and give a double result.
  min. digits = 1}
 const
   Res  :array[0..1] of T4Double = ((-1.62,2.22,3.98,4.13),
                                    (102.45,789.79,2.22,0.56));

 var
  i,j  :Integer;
  Test :array[0..1] of T4Double = ((-1.62456,2.2201,3.9784,4.1346),
                                   (102.45,789.7890,2.2201,0.560));

begin
  Result := True;
  RoundYDouble(Test,2);
  RoundYDouble(Res,2);
  for i := 0 to 1 do
   for j := 0 to 3 do
     if Test[i,j] <> Res[i,j] then
       Result := False;
end;

function TestRoundYDouble2 :Boolean;
 {Round all the array fields to nearest and give a double result.
  min. digits = 1}
 const
   Test :Double = -1.62456;
   Soll :Double = -1.62;

 var
  Res :double;

begin
  Result := True;
  Res := RoundYDouble(Test,2);
  if Res <> Soll then
    Result := False;
end;


function TestRoundChopYSingle :Boolean;
 {Round all the array fields by chop the count digits > in parameter digits.}
 const
  Res     :array[0..1] of T8Single = ((-1.62,2.22,3.97,4.13,
                                      102.45,789.22,2.22,0.56),
                                      (-400.12,-600.12,700.12,
                                      800.12,900.12,1000.12,
                                      1100.12,1200.12));

 var
  i,j  :Integer;
  Test :array[0..1] of T8Single = ((-1.62456,2.2201,3.9784,4.1346,
                                   102.45,789.2201,2.2201,0.567),
                                   (-400.12345,-600.12345,700.12345,
                                   800.12345,900.12345,1000.12345,
                                   1100.12345,1200.12345));

begin
  Result := True;
  RoundChopYSingle(Test,2);
  RoundChopYSingle(Res,2);
  for i := 0 to 1 do
   for j := 0 to 7 do
     if Test[i,j] <> Res[i,j] then
       Result := False;
end;

function TestRoundChopYSingle1 :Boolean;
 {Round all the array fields by chop the count digits > in parameter digits.}
 const
   Value :Single = -1.456789;
   Soll  :Single = -1.45;

 var
  Res :Single;

begin
  Result := True;
  Res := RoundChopYSingle(Value,2);
 if Res <> Soll then
   Result := False;
end;

function TestRoundChopYDouble :Boolean;
 {Round all the array fields by chop the digits > in parameter digits.
  }
 const
   Res  :array[0..1] of T4Double = ((-1.62,2.52,3.97,4.13),
                                    (102.45,789.78,23456.88,0.56));

 var
  i,j  :Integer;
  Test :array[0..1] of T4Double = ((-1.62456,2.5297,3.9784,4.1346),
                                   (102.45,789.7890,23456.8867,0.567));

begin
  Result := True;
  RoundChopYDouble(Test,2);
  RoundChopYDouble(Res,2);
  for i := 0 to 1 do
   for j := 0 to 3 do begin
     if Test[i,j] <> Res[i,j] then
       Result := False;
   end;
end;

function TestRoundChopYDouble1 :Boolean;
 {Round all the array fields by chop the digits > in parameter digits.
  }
 const
   Value :Double = -1.634567;
   Soll  :Double = -1.63;

 var
  Res :Double;

begin
  Result := True;
  Res  := RoundChopYDouble(Value,2);
  Soll := RoundChopYDouble(Soll,2);
  if Res <> Soll then
    Result := False;
end;

{------------------------logical------------------------------------------}

function TestYSingle1 :Boolean;
{test for ALL are zeros or not}
 const
   Feld1 :T8Single = (-1,2,3,0,0,6,7,0);
   Soll1 :Boolean  = False;
   Feld2 :T8Single = (0,0,0,0,0,0,0,0);
   Soll2 :Boolean = True;

 var
  Res :Boolean;

 begin
   Result := True;
   Res := TestYSingle(Feld1);
   if Res <> Soll1 then
     Result := False;
   Res := TestYSingle(Feld2);
   if Res <> Soll2 then
     Result := False;
end;

function TestYDouble1 :Boolean;
 const
  Feld1 :T4Double = (-1,0,3,0);
  Soll1 :Boolean  = False;
  Feld2 :T4Double = (0,0,0,0);
  Soll2 :Boolean  = True;

 var
  Res :Boolean;

begin
  Result := True;
  Res := TestYDouble(Feld1);
  if Res <> Soll1 then
    Result := False;
  Res := TestYDouble(Feld2);
  if Res <> Soll2 then
    Result := False;
end;


{-------------------------other functions---------------------------------}


function TestIntPowYSingle :Boolean;
{calculate the y = x^exp for integer exponent}
 const
   Feld :array[0..1] of T8Single = ((-1,2,3,4,5,6,7,8),(9,10,1,1,1,1,1,1));
   Soll :array[0..1] of T8Single = ((1,4,9,16,25,36,49,64),(81,100,1,1,1,1,1,1));
   expo :Longint = 2;

 var
  i,j :Integer;
  Res :array[0..1] of T8Single;

begin
  Result := True;
  if IntPowYSingle(Feld,Res,expo) then begin
    RoundYSingle(Res);  // round to integer
    for i := 0 to 1 do
      for j := 0 to 7 do
        if Res[i,j] <> Soll[i,j] then
          Result := False;
   end
  else Result := False;
end;

function TestExpYSingle :Boolean;
{calculate y = exp(x)}
 const
   Feld :array[0..1] of T8Single = ((0,2,3,4,5,6,7,8),(9,10,11,12,13,14,15,16));
   Soll :array[0..1] of T8Single = ((1,7,20,55,148,403,1097,2981),
                     (8103,22026,59874,162755,442413,1202604,3269017,8886111));

 var
  i,j :Integer;
  Res :array[0..1] of T8Single;

begin
  Result := True;
  if ExpYSingle(Feld,Res) then begin
    RoundYSingle(Res);
    for i := 0 to 1 do
      for j := 0 to 7 do
      if Res[i,j] <> Soll[i,j] then
        Result := False;
   end
  else Result := False;
end;

function TestLnYSingle :Boolean;
{calculate y = Ln(x)}
 const
   Feld :array[0..1] of T8Single = ((1,2,3,4,5,6,7,8),(9,10,11,12,13,14,15,16));
   Soll :array[0..1] of T8Single = ((0,0.69,1.10,1.39,1.61,1.79,1.95,2.08),
                                    (2.20,2.30,2.40,2.48,2.56,2.64,2.71,2.77));

 var
  i,j :Integer;
  Res :array[0..1] of T8Single;

begin
  Result := True;
  if LnYSingle(Feld,Res) then begin
    for i := 0 to 1 do
      for j := 0 to 7 do
        if SimpleRoundTo(Res[i,j],-2) <> Soll[i,j] then
          Result := False;
   end
  else Result := False;
end;

function TestLdYSingle :Boolean;
{calculate logarithmus dualis  y = Ld(x)}
 const
   Feld :array[0..1] of T8Single = ((1,2,3,4,5,6,7,8),(9,10,11,12,13,14,15,16));
   Soll :array[0..1] of T8Single = ((0,1,1.58,2,2.32,2.58,2.81,3),
                                    (3.17,3.32,3.46,3.58,3.70,3.81,3.91,4));

 var
  i,j :Integer;
  Res :array[0..1] of T8Single;

begin
  Result := True;
  if LdYSingle(Feld,Res) then begin
    for i := 0 to 1 do
      for j := 0 to 7 do
        if SimpleRoundTo(Res[i,j],-2) <> Soll[i,j] then
          Result := False;
   end
  else Result := False;
end;


function TestLogYSingle :Boolean;
{calculate y = lg(x)}
 const
   Feld :array[0..1] of T8Single = ((1,2,3,4,5,6,7,8),(9,10,11,12,13,14,15,16));
   Soll :array[0..1] of T8Single = ((0,0.30,0.48,0.60,0.70,0.78,0.85,0.90),
                   (0.95,1.00,1.04,1.08,1.11,1.15,1.18,1.20));

 var
  i,j :Integer;
  Res :array[0..1] of T8Single;

begin
  Result := True;
  if LogYSingle(Feld,Res) then begin
    for i := 0 to 1 do
      for j := 0 to 7 do
        if SimpleRoundTo(Res[i,j],-2) <> Soll[i,j] then
          Result := False;
   end
  else Result := False;
end;

function TestPowYSingle :Boolean;
{calculate y = x^exp for float exponents}
 const
   Feld :array[0..1] of T8Single = ((1,2,3,4,5,6,7,8),(9,10,1,1,1,1,1,1));
   Soll :array[0..1] of T8Single = ((1,4,9,16,25,36,49,64),(81,100,1,1,1,1,1,1));
   expo :Single = 2.0;

 var
  i,j :Integer;
  Res :array[0..1] of T8Single;

begin
  Result := True;
  if PowYSingle(Feld,Res,expo) then begin
    RoundYSingle(Res);
    for i := 0 to 1 do
      for j := 0 to 7 do
        if Res[i,j] <> Soll[i,j] then
          Result := False;
   end
  else Result := False;
end;

function TestExp10YSingle :Boolean;
{calculate y = 10^x }
 const
   Feld :array[0..1] of T8Single = ((0,2,3,4,5,6,7,8),(9,10,11,12,13,14,15,16));
   Soll :array[0..1] of T8Single =
     ((1,100,1000,10000,100000,1000000,10000000,100000000),
     (1.0E+9,1.0E+10,1.0E+11,1.0E+12,1.0E+13,1.0E+14,1.0E+15,1.0E+16));

 var
  i,j :Integer;
  Res :array[0..1] of T8Single;

begin
  Result := True;
  if Exp10YSingle(Feld,Res) then begin
    RoundYSingle(Res);
    for i := 0 to 1 do
      for j := 0 to 7 do
        if Res[i,j] <> Soll[i,j] then
          Result := False;
    end
  else Result := False;
end;

function TestExp2YSingle :Boolean;
{calculate y = 10^x }
 const
   Feld :array[0..1] of T8Int32 = ((0,2,3,4,5,6,7,8),(9,10,-11,-12,-13,14,15,16));
   Soll :array[0..1] of T8Single =
     ((1,4,8,16,32,64,128,256),
     (512,1024,4.88E-4,2.44E-4,1.22E-4,16384,32768,65536));

 var
  i,j :Integer;
  Res :array[0..1] of T8Single;

begin
  Result := True;
  if Exp2YSingle(Feld,Res) then begin
    RoundYSingle(Res,6);
    RoundYSingle(Soll,6);
    for i := 0 to 1 do
      for j := 0 to 7 do
        if Res[i,j] <> Soll[i,j] then
          Result := False;
    end
  else Result := False;
end;

function TestIntPowYDouble :Boolean;
{calculate y = x^exp, exponent is integer}
 const
   Feld :array[0..1] of T4Double = ((-1,2,3,4),(5,6,7,8));
   Soll :array[0..1] of T4Double = ((1,4,9,16),(25,36,49,64));
   expo :Longint = 2;

 var
  i,j :Integer;
  Res :array[0..1] of T4Double;

begin
  Result := True;
  if IntPowYDouble(Feld,Res,expo) then begin
    RoundYDouble(Res);
    for i := 0 to 1 do
      for j := 0 to 3 do
        if Res[i,j] <> Soll[i,j] then
          Result := False;
   end
  else Result := False;
end;

function TestExpYDouble :Boolean;
{calculate y = e^x}
 const
   Feld :array[0..1] of T4Double = ((0,2,3,4),(5,6,7,8));
   Soll :array[0..1] of T4Double = ((1,7,20,55),(148,403,1097,2981));

 var
  i,j :Integer;
  Res :array[0..1] of T4Double;

begin
  Result := True;
  if ExpYDouble(Feld,Res) then begin
    RoundYDouble(Res);
    for i := 0 to 1 do
      for j := 0 to 3 do
        if Res[i,j] <> Soll[i,j] then
          Result := False;
   end
  else Result := False;
end;

function TestLnYDouble :Boolean;
{calculate y = Ln(x)}
 const
   Feld :array[0..1] of T4Double = ((1,2,3,4),(5,6,7,8));
   Soll :array[0..1] of T4Double = ((0,0.69,1.10,1.39),(1.61,1.79,1.95,2.08));

 var
  i,j :Integer;
  Res :array[0..1] of T4Double;

begin
  Result := True;
  if LnYDouble(Feld,Res) then begin
    for i := 0 to 1 do
      for j := 0 to 3 do
        if SimpleRoundTo(Res[i,j],-2) <> Soll[i,j] then
          Result := False;
   end
  else Result := False;
end;

function TestLdYDouble :Boolean;
{calculate logarithmus dualis y = Ld(x)}
 const
   Feld :array[0..3] of T4Double = ((1,2,3,4),(5,6,7,8),(9,10,11,12),(13,14,15,16));
   Soll :array[0..3] of T4Double = ((0,1,1.58,2),(2.32,2.58,2.81,3),
                                    (3.17,3.32,3.46,3.58),(3.70,3.81,3.91,4));

 var
  i,j :Integer;
  Res :array[0..3] of T4Double;

begin
  Result := True;
  if LdYDouble(Feld,Res) then begin
    for i := 0 to 3 do
      for j := 0 to 3 do
        if SimpleRoundTo(Res[i,j],-2) <> Soll[i,j] then
          Result := False;
   end
  else Result := False;
end;

function TestLogYDouble :Boolean;
{calculate y = lg(x)}
 const
   Feld :array[0..1] of T4Double = ((1,2,3,4),(5,6,7,8));
   Soll :array[0..1] of T4Double = ((0,0.30,0.48,0.60),
                                    (0.70,0.78,0.85,0.90));

 var
  i,j :Integer;
  Res :array[0..1] of T4Double;

begin
  Result := True;
  if LogYDouble(Feld,Res) then begin
    for i := 0 to 1 do
      for j := 0 to 3 do
        if SimpleRoundTo(Res[i,j],-2) <> Soll[i,j] then
          Result := False;
   end
  else Result := False;
end;

function TestPowYDouble :Boolean;
{calculate y = x^exp for exp floats}
 const
   Feld :array[0..1] of T4Double = ((1,2,3,4),(5,6,7,8));
   Soll :array[0..1] of T4Double = ((1,4,9,16),(25,36,49,64));
   expo :Single = 2.0;

 var
  i,j :Integer;
  Res :array[0..1] of T4Double;

begin
  Result := True;
  if PowYDouble(Feld,Res,expo) then begin
    RoundYDouble(Res);
    for i := 0 to 1 do
      for j := 0 to 3 do
        if Res[i,j] <> Soll[i,j] then
          Result := False;
   end
  else Result := False;
end;

function TestExp10YDouble :Boolean;
{calculate y = 10^x}
 const
   Feld :array[0..1] of T4Double = ((0,1,2,3),(4,5,6,7));
   Soll :array[0..1] of T4Double = ((1,10,100,1000),(10000,100000,1.0E+6,1.0E+7));

 var
  i,j :Integer;
  Res :array[0..1] of T4Double;

begin
  Result := True;
  if Exp10YDouble(Feld,Res) then begin
    for i := 0 to 1 do
      for j := 0 to 3 do
        if Res[i,j] <> Soll[i,j] then
          Result := False;
   end
  else Result := False;
end;

function TestExp2YDouble :Boolean;
{calculate y = 2^x}
 const
   Feld :array[0..1] of T4Int32 =  ((0,1,2,3),(4,5,6,7));
   Soll :array[0..1] of T4Double = ((1,2,4,8),(16,32,64,128));

 var
  i,j :Integer;
  Res :array[0..1] of T4Double;

begin
  Result := True;
  if Exp2YDouble(Feld,Res) then begin
    for i := 0 to 1 do
      for j := 0 to 3 do
        if Res[i,j] <> Soll[i,j] then
          Result := False;
   end
  else Result := False;
end;

function TestExponentYSingle :Boolean;
{extract exponent as integer}
 const
   Feld :T8Single = (-1,2,3,4,5,6,7,8);
   Soll :T8Single = (0,1,1,2,2,2,2,3);

 var
  j :Integer;
  Res :T8Int32;

begin
  Result := True;
  Res := ExponentYSingle(Feld);
  for j := 0 to 7 do
    if Res[j] <> Soll[j] then
      Result := False;
end;

function TestExponentYDouble :Boolean;
{exctract exponent as integer}
 const
   Feld :T4Double = (-1,2,3,4);
   Soll :T4Double = (0,1,1,2);

 var
  j :Integer;
  Res :T4Int32;

begin
  Result := True;
  Res := ExponentYDouble(Feld);
  for j := 0 to 3 do
    if Res[j] <> Soll[j] then
      Result := False;
end;


{------------------------------convert------------------------------------}

function TestConvertYSingleToInt32 :Boolean;
{convert a T8single to T8Int32}
 const
   Feld :T8Single = (-1,2,3,4,5,6,7,8);
   Soll :T8Int32 =  (-1,2,3,4,5,6,7,8);

 var
  j :Integer;
  Res :T8Int32;

begin
  Result := True;
  Res := ConvertYSingleToInt32(Feld);
  for j := 0 to 7 do
    if Res[j] <> Soll[j] then
      Result := False;
end;

function TestConvertYSingleToDouble :Boolean;
{convert T4Single in T4Double}
 const
   Feld :T4Single = (-1,2,3,4);
   Soll :T4Double =  (-1,2,3,4);

 var
  j :Integer;
  Res :T4Double;

begin
  Result := True;
  Res := ConvertYSingleToDouble(Feld);
  for j := 0 to 3 do
    if Res[j] <> Soll[j] then
      Result := False;
end;

function TestConvertYDoubleToInt32 :Boolean;
{convert T4Double to T4Int32}
 const
   Feld :T4Double = (-1,2,3,4);
   Soll :T4Int32 =  (-1,2,3,4);

 var
  j :Integer;
  Res :T4Int32;

begin
  Result := True;
  Res := ConvertYDoubleToInt32(Feld);
  for j := 0 to 3 do
    if Res[j] <> Soll[j] then
      Result := False;
end;

function TestConvertYDoubleToSingle :Boolean;
{convert T4Double to T4Single}
 const
   Feld :T4Double = (-1,2,3,4);
   Soll :T4Single = (-1,2,3,4);

 var
  j :Integer;
  Res :T4Single;

begin
  Result := True;
  Res := ConvertYDoubleToSingle(Feld);
  for j := 0 to 3 do
    if Res[j] <> Soll[j] then
      Result := False;
end;

function TestConvertYInt32ToSingle :Boolean;
{convert T8Int32 to T8Single}
 const
   Feld :T8Int32  = (-1,2,3,4,5,6,7,8);
   Soll :T8Single = (-1,2,3,4,5,6,7,8);

 var
  j :Integer;
  Res :T8Single;

begin
  Result := True;
  Res := ConvertYInt32ToSingle(Feld);
  for j := 0 to 7 do
    if Res[j] <> Soll[j] then
      Result := False;
end;

function TestConvertYInt32ToDouble :Boolean;
{convert T4Int32 to T4Double}
 const
   Feld :T4Int32  = (-1,2,3,4);
   Soll :T4Double = (-1,2,3,4);

 var
  j :Integer;
  Res :T4Double;

begin
  Result := True;
  Res := ConvertYInt32ToDouble(Feld);
  for j := 0 to 3 do
    if Res[j] <> Soll[j] then
      Result := False;
end;

function TestChopYSingleToInt32 :Boolean;
{chop T8Single to T8Int32}
 const
   Feld :T8Single  = (-1.0,2.7,3.6,4.9,5.1,6.2,7.2,8.7);
   Soll :T8Int32   = (-1,2,3,4,5,6,7,8);

 var
  j :Integer;
  Res :T8Int32;

begin
  Result := True;
  Res := ChopYSingleToInt32(Feld);
  for j := 0 to 7 do
    if Res[j] <> Soll[j] then
      Result := False;
end;

function TestChopYDoubleToInt32 :Boolean;
{chop T4Double to T4Int32}
 const
   Feld :T4Double  = (-1.0,2.7,3.6,4.9);
   Soll :T4Int32   = (-1,2,3,4);

 var
  j :Integer;
  Res :T4Int32;

begin
  Result := True;
  Res := ChopYDoubleToInt32(Feld);
  for j := 0 to 3 do
    if Res[j] <> Soll[j] then
      Result := False;
end;


{---------------------convert for arrays---------------------------------}

function TestConvYSingleToInt32 :Boolean;
{convert a T8Single array to T8Int32}
 const
   Feld :array[0..1] of T8Single = ((-1,2,3,4,5,6,7,8),
                                    (9,10,11,12,13,14,15,16));
   Soll :array[0..1] of T8Int32 =  ((-1,2,3,4,5,6,7,8),
                                    (9,10,11,12,13,14,15,16));

 var
  i,j :Integer;
  Res :array[0..1] of T8Int32;

begin
  Result := True;
  if ConvertYSingleToInt32(Feld,Res) then begin
  for i := 0 to 1 do
    for j := 0 to 7 do
      if Res[i,j] <> Soll[i,j] then
        Result := False;
   end
  else Result := False;
end;

function TestConvYSingleToDouble :Boolean;
{convert a T8Single array to T4Double}
 const
   Feld :array[0..1] of T8Single = ((-1,2,3,4,5,6,7,8),
                                    (9,10,11,12,13,14,15,16));
   Soll :array[0..3] of T4Double = ((-1,2,3,4),(5,6,7,8),
                                    (9,10,11,12),(13,14,15,16));

 var
  i,j :Integer;
  Res :array[0..3] of T4Double;

begin
  Result := True;
  if ConvertYSingleToDouble(Feld,Res) then begin
  for i := 0 to 3 do
    for j := 0 to 3 do
      if Res[i,j] <> Soll[i,j] then
        Result := False;
   end
  else Result := False;
end;

function TestConvYDoubleToInt32 :Boolean;
{convert a T4Double array to T4Int32}
 const
   Feld :array[0..1] of T4Double = ((-1,2,3,4),(5,6,7,8));
   Soll :array[0..1] of T4Int32  = ((-1,2,3,4),(5,6,7,8));

 var
  i,j :Integer;
  Res :array[0..1] of T4Int32;

begin
  Result := True;
  if ConvertYDoubleToInt32(Feld,Res) then begin
  for i := 0 to 1 do
    for j := 0 to 3 do
      if Res[i,j] <> Soll[i,j] then
        Result := False;
   end
  else Result := False;
end;

function TestConvYDoubleToSingle :Boolean;
{convert a T4Double array to T4Single}
 const
   Feld :array[0..1] of T4Double = ((-1,2,3,4),(5,6,7,8));
   Soll :array[0..1] of T4Single = ((-1,2,3,4),(5,6,7,8));

 var
  i,j :Integer;
  Res :array[0..1] of T4Single;

begin
  Result := True;
  if ConvertYDoubleToSingle(Feld,Res) then begin
  for i := 0 to 1 do
    for j := 0 to 3 do
      if Res[i,j] <> Soll[i,j] then
        Result := False;
   end
  else Result := False;
end;

function TestConvYInt32ToSingle :Boolean;
{convert a T8Int32 array to T8Single}
 const
   Feld :array[0..1] of T8Int32 = ((-1,2,3,4,5,6,7,8),
                                   (9,10,11,12,13,14,15,16));
   Soll :array[0..1] of T8Single = ((-1,2,3,4,5,6,7,8),
                                   (9,10,11,12,13,14,15,16));

 var
  i,j :Integer;
  Res :array[0..1] of T8Single;

begin
  Result := True;
  if ConvertYInt32ToSingle(Feld,Res) then begin
  for i := 0 to 1 do
    for j := 0 to 7 do
      if Res[i,j] <> Soll[i,j] then
        Result := False;
   end
  else Result := False;
end;

function TestConvYInt32ToDouble :Boolean;
{convert a T8Int32 array to T4Double}
 const
   Feld :array[0..1] of T8Int32 = ((-1,2,3,4,5,6,7,8),
                                   (9,10,11,12,13,14,15,16));
   Soll :array[0..3] of T4Double = ((-1,2,3,4),(5,6,7,8),
                                   (9,10,11,12),(13,14,15,16));

 var
  i,j :Integer;
  Res :array[0..3] of T4Double;

begin
  Result := True;
  if ConvertYInt32ToDouble(Feld,Res) then begin
  for i := 0 to 1 do
    for j := 0 to 3 do
      if Res[i,j] <> Soll[i,j] then
        Result := False;
   end
  else Result := False;
end;

function TestChopYSingleToInt32_1 :Boolean;
{convert a T8Single array to T8Int32}
 const
   Feld :array[0..1] of T8Single = ((-1,2,3,4,5,6,7,8),
                                   (9,10,11,12,13,14,15,16));
   Soll :array[0..1] of T8Int32 =  ((-1,2,3,4,5,6,7,8),
                                    (9,10,11,12,13,14,15,16));

 var
  i,j :Integer;
  Res :array[0..1] of T8Int32;

begin
  Result := True;
  if ChopYSingleToInt32(Feld,Res) then begin
  for i := 0 to 1 do
    for j := 0 to 7 do
      if Res[i,j] <> Soll[i,j] then
        Result := False;
   end
  else Result := False;
end;

function TestChopYDoubleToInt32_1 :Boolean;
{convert a T4Double array to T4Int32}
 const
   Feld :array[0..3] of T4Double = ((-1,2,3,4),(5,6,7,8),
                                   (9,10,11,12),(13,14,15,16));
   Soll :array[0..3] of T4Int32  = ((-1,2,3,4),(5,6,7,8),
                                    (9,10,11,12),(13,14,15,16));

 var
  i,j :Integer;
  Res :array[0..3] of T4Int32;

begin
  Result := True;
  if ChopYDoubleToInt32(Feld,Res) then begin
  for i := 0 to 3 do
    for j := 0 to 3 do
      if Res[i,j] <> Soll[i,j] then
        Result := False;
   end
  else Result := False;
end;


{----------------------------compare---------------------------------------}


function TestCmpYSingleEQ :Boolean;
 const
   a :T8Single  = (1,2,3,4,5,6,7,8);
   b :T8Single  = (1,2,5,6,7,8,9,10);
   Soll :T8YBool = (True,True,False,False,False,False,False,False);

 var
  j   :Integer;
  Res :T8YBool;

begin
  Result := True;
  Res := CmpYSingleEQ(a,b);
  for j := 0 to 7 do
    if Res[j] <> Soll[j] then
      Result := False;
end;

function TestCmpYSingleLT :Boolean;
 const
   a :T8Single = (1,2,3,4,5,6,7,8);
   b :T8Single = (1,2,5,6,7,8,9,10);
   Soll :T8YBool = (False,False,True,True,True,True,True,True);

 var
  j   :Integer;
  Res :T8YBool;

begin
  Result := True;
  Res := CmpYSingleLT(a,b);
  for j := 0 to 7 do
    if Res[j] <> Soll[j] then
      Result := False;
end;

function TestCmpYSingleGE :Boolean;
 const
   a :T8Single = (1,2,3,4,5,6,7,8);
   b :T8Single = (1,2,5,6,7,8,9,10);
   Soll :T8YBool = (True,True,False,False,False,False,False,False);

 var
  j   :Integer;
  Res :T8YBool;

begin
  Result := True;
  Res := CmpYSingleGE(a,b);
  for j := 0 to 7 do
    if Res[j] <> Soll[j] then
      Result := False;
end;

function TestCmpYSingleGT :Boolean;
 const
   a :T8Single = (1,2,3,4,5,6,7,8);
   b :T8Single = (1,2,5,6,7,8,9,10);
   Soll :T8YBool = (False,False,False,False,False,False,False,False);

 var
  j   :Integer;
  Res :T8YBool;

begin
  Result := True;
  Res := CmpYSingleGT(a,b);
  for j := 0 to 7 do
    if Res[j] <> Soll[j] then
      Result := False;
end;

function TestCmpYDoubleEQ :Boolean;
 const
   a :T4Double = (1,2,3,4);
   b :T4Double = (1,2,5,6);
   Soll :T4YBool = (True,True,False,False);

 var
  j   :Integer;
  Res :T4YBool;

begin
  Result := True;
  Res := CmpYDoubleEQ(a,b);
  for j := 0 to 3 do
    if Res[j] <> Soll[j] then
      Result := False;
end;

function TestCmpYDoubleLT :Boolean;
 const
   a :T4Double  = (1,2,3,4);
   b :T4Double  = (1,2,5,6);
   Soll :T4YBool = (False,False,True,True);

 var
  j   :Integer;
  Res :T4YBool;

begin
  Result := True;
  Res := CmpYDoubleLT(a,b);
  for j := 0 to 3 do
    if Res[j] <> Soll[j] then
      Result := False;
end;

function TestCmpYDoubleGE :Boolean;
 const
   a :T4Double = (1,2,3,4);
   b :T4Double = (1,2,5,6);
   Soll :T4YBool = (True,True,False,False);

 var
  j   :Integer;
  Res :T4YBool;

begin
  Result := True;
  Res := CmpYDoubleGE(a,b);
  for j := 0 to 3 do
    if Res[j] <> Soll[j] then
      Result := False;
end;

function TestCmpYDoubleGT :Boolean;
 const
   a :T4Double = (1,2,3,4);
   b :T4Double = (1,2,5,6);
   Soll :T4YBool = (False,False,False,False);

 var
  j   :Integer;
  Res :T4YBool;

begin
  Result := True;
  Res := CmpYDoubleGT(a,b);
  for j := 0 to 3 do
    if Res[j] <> Soll[j] then
      Result := False;
end;


{--------------------------diverses---------------------------------------}

function TestSignExtractYSingle :Boolean;
 const
   Feld :T8Single  = (-1,2,3,-4,5,6,-7,8);
   Soll :Longint = 73;

 var
  Res :Longint;  // give the sign of the values bit = 1 -> minus sign

begin
  Result := True;
  Res := SignExtractYSingle(Feld);
  if Res <> Soll then
    Result := False;
end;

function TestSignExtractYDouble :Boolean;
 const
   Feld :T4Double  = (-1,2,3,-4);
   Soll :Longint = 9;

 var
  Res :Longint;  // give the sign of the values bit = 1 -> -

begin
  Result := True;
  Res := SignExtractYDouble(Feld);
  if Res <> Soll then
    Result := False;
end;

function TestIsInfYSingle :Boolean;
{test for +/-oo in array }
const
  Feld :T32Byte = ($00,$00,$80,$7F,$00,$00,$80,$7F,
                   $00,$00,$80,$7F,$00,$00,$80,$7F,
                   $00,$00,$80,$7F,$00,$00,$80,$7F,
                   $00,$00,$80,$7F,$00,$00,$80,$7F); // +oo

var
 i :integer;
 Res :T8YBool;

begin
 Result := True;
 // test for +oo and -oo posibility  here only for +oo
 Res := Is_InfYSingle(T8Single(Feld));
 for i := 0 to 7 do
 if Res[i] = LongBool(0) then
   Result := False;
end;

function TestIsInfYDouble :Boolean;
{see upper}
const
  Feld :T32Byte =  ($00,$00,$00,$00,$00,$00,$F0,$7F,
                    $00,$00,$00,$00,$00,$00,$F0,$7F,
                    $00,$00,$00,$00,$00,$00,$F0,$7F,
                    $00,$00,$00,$00,$00,$00,$F0,$7F); // +oo
var
 i :integer;
 Res :T4YBool;

begin
 Result := True;
 Res := Is_InfYDouble(T4Double(Feld));
 for i := 0 to 3 do
 if Res[i] = LongBool(0) then
   Result := False;
end;

function TestIsNANYSingle :Boolean;
{test is in array a NAN}
const
  Feld :T32Byte = ($FF,$FF,$FF,$FF,$00,$00,$80,$7F,
                    // ^NAN
                   $00,$00,$80,$7F,$00,$00,$80,$7F,
                   $00,$00,$80,$7F,$00,$00,$80,$7F,
                   $00,$00,$80,$7F,$00,$00,$80,$7F); // +oo
Soll :T8YBool = (true,false,false,false,false,false,false,false);

var
 i :integer;
 Res :T8YBool;

begin
 Result := True;
 Res := Is_NANYSingle(T8Single(Feld));
 for i := 0 to 7 do
 if Res[i] <> Soll[i] then
   Result := False;
end;

function TestIsNANYDouble :Boolean;
{is in array a NAN}
const
  Feld :T32Byte = ($FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
                     // ^NAN
                   $00,$00,$00,$00,$00,$00,$F0,$7F,
                   $00,$00,$00,$00,$00,$00,$F0,$7F,
                   $00,$00,$00,$00,$00,$00,$F0,$7F); // +oo
  Soll :T4YBool = (true,false,false,false);

var
 i :integer;
 Res :T4YBool;

begin
 Result := True;
 Res := Is_NANYDouble(T4Double(Feld));
 for i := 0 to 3 do
 if Res[i] <> Soll[i] then
   Result := False;
end;

{-------------------------statistic functions-----------------------------}

function TestStatCalcYSingle :Boolean;
{calculate the arithmetical average,sdev,variance,skew
 and the excess of the array.}
 const
   Feld :array[0..1] of T8Single = ((41.1,43.3,39.2,42.3,42.8,44.8,41.5,36.6),
                                    (32.9,35.4,45.5,31.8,42.0,0,0,0));
   Sollaver :Single = 39.9;                                  //^ fill values
   SollsDev :Single = 4.4;
   Sollvari :Single = 19.6;
   Sollskew :Single = -0.6;
   SollExc  :Single = -0.9;

 var
  average,sDev,vari,skew,excess :Single;

begin
  Result := True;
  StatCalcYSingle(Feld,13,average,sDev,vari,skew,excess);
                    // ^count of values for calculation
  if SimpleRoundTo(average,-1) <> Sollaver then
     Result := False;
  if SimpleRoundTo(sDev,-1) <> SollsDev then
    Result := False;
  if SimpleRoundTo(vari,-1) <> Sollvari then
    Result := False;
  if SimpleRoundTo(skew,-1) <> Sollskew then
    Result := False;
  if SimpleRoundTo(excess,-1) <> SollExc then
    Result := False;
end;


function TestAverageYSingle :Boolean;
{calculate the arithmetic average of the array.}
 const
   Feld :array[0..1] of T8Single = ((41.1,43.3,39.2,42.3,42.8,44.8,41.5,36.6),
                                    (32.9,35.4,45.5,31.8,42.0,0,0,0));
   Soll :Single = 39.9;                                     // ^ fill values

 var
  Res :Single;

begin
  Result := True;
  Res := AverageYSingle(Feld,13);
                          // ^ count of values for calculation
  if SimpleRoundTo(Res,-1) <> Soll then
     Result := False;
end;

function TestGeoAverageYSingle :Boolean;
{calculate the geometric average of the array. Set unused beeded fields to 1.}
 const
   Feld :array[0..1] of T8Single = ((41.1,43.3,39.2,42.3,42.8,44.8,41.5,36.6),
                                    (32.9,35.4,45.5,31.8,42.0,1.0,1.0,1.0));
   SollRes :Single = 39.7;

 var
  Res :Single;

begin
  Result := True;
  Res := GeoAverageYSingle(Feld,13);
                              //^ count of values for calculation
  if SimpleRoundTo(Res,-1) <> SollRes then
     Result := False;
end;

function TestStatCalcYDouble :Boolean;
{see upper, set unused needed array fields to zero.}
 const
   Feld :array[0..3] of T4Double = ((41.1,43.3,39.2,42.3),
                                    (42.8,44.8,41.5,36.6),
                                    (32.9,35.4,45.5,31.8),
                                    (42.0,0,0,0));

   Sollaver :Double = 39.9;
   SollsDev :Double = 4.4;
   Sollvari :Double = 19.6;
   Sollskew :Double = -0.6;
   SollExc  :Double = -0.9;

 var
  average,sDev,vari,skew,excess :Double;

begin
  Result := True;
  StatCalcYDouble(Feld,13,average,sDev,vari,skew,excess);
                    // ^ count of values for calculation
   if SimpleRoundTo(average,-1) <> Sollaver then
     Result := False;
  if SimpleRoundTo(sDev,-1) <> SollsDev then
    Result := False;
  if SimpleRoundTo(vari,-1) <> Sollvari then
    Result := False;
  if SimpleRoundTo(skew,-1) <> Sollskew then
    Result := False;
  if SimpleRoundTo(excess,-1) <> SollExc then
    Result := False;
end;

function TestAverageYDouble :Boolean;
{Calculate the average of input fields. Set unused needed array fields to zero.}
 const
   Feld :array[0..3] of T4Double = ((41.1,43.3,39.2,42.3),
                                    (42.8,44.8,41.5,36.6),
                                    (32.9,35.4,45.5,31.8),
                                    (42.0,0,0,0));
   Soll :Double = 39.9;

 var
  Res :Double;

begin
  Result := True;
  Res := AverageYDouble(Feld,13);
                          // ^ count of array fields for calculation
  if SimpleRoundTo(Res,-1) <> Soll then
     Result := False;
end;

function TestGeoAverageYDouble :Boolean;
{Calculate the geometrical average of the array fields. No input value with
 zero is possibility! Set unused needed array fields to 1.}
 const
   Feld :array[0..3] of T4Double = ((41.1,43.3,39.2,42.3),
                                    (42.8,44.8,41.5,36.6),
                                    (32.9,35.4,45.5,31.8),
                                    (42.0,1.0,1.0,1.0));
   SollRes :Double = 39.7;

 var
  Res :Double;

begin
  Result := True;
  Res := GeoAverageYDouble(Feld,13);
                              // ^count of the array fields for calculation
  if SimpleRoundTo(Res,-1) <> SollRes then
     Result := False;
end;


function TestKorrAnalyseYSingle :Boolean;
{Calculate the correlation of x and y. For the calculation minimal 8 values
 are needed. Result -1 <= korr. coeffizient <= +1; on error Res = 2}
 const
   x :array[0..1] of T8Single = ((41.1,43.3,39.2,42.3,42.8,44.8,41.5,36.6),
                                 (32.9,35.4,45.5,31.8,42.0,0,0,0));

   y :array[0..1] of T8Single = ((0.04,0.03,0.04,0.05,0.04,0.04,0.03,0.03),
                                 (0.04,0.08,0.06,0.05,0.04,0,0,0));

   SollRes :Single = -0.20;    // d.h. no correlation

 var
  Res :Single;

begin
  Result := True;
  Res := KorrAnalyseYSingle(x,y,13);
                             // ^count of array fields for calculation
  if SimpleRoundTo(Res,-2) <> SollRes then
     Result := False;
end;

function TestLinRegYSingle :Boolean;
{Calculate the lin. regresion y = a + bx; min 2 value needed. Set unused
 needed array fields to zero.}
 const
   x :array[0..1] of T8Single = ((41.1,43.3,39.2,42.3,42.8,44.8,41.5,36.6),
                                 (32.9,35.4,45.5,31.8,42.0,0,0,0));

   y :array[0..1] of T8Single = ((0.04,0.03,0.04,0.05,0.04,0.04,0.03,0.03),
                                 (0.04,0.08,0.06,0.05,0.04,0,0,0));

   Solla :Single = 0.0682;    // d.h. no correlation
   Sollb :Single = -0.0006;

 var
  a,b :Single;

begin
  Result := True;
  if LinRegYSingle(x,y,13,a,b) then begin
                    // ^count of array fields for calculation
    if SimpleRoundTo(a,-4) <> Solla then
       Result := False;
    if SimpleRoundTo(b,-4) <> Sollb then
       Result := False;
   end
  else Result := False;
end;

function TestLogRegYSingle :Boolean;
{calculate the logarithm regresion y = a + bln(x); min 2 value needed. Set
 unused needeed array fields to 1 for x value and zero to y values.}
 const
   x :array[0..1] of T8Single = ((41.1,43.3,39.2,42.3,42.8,44.8,41.5,36.6),
                                 (32.9,35.4,45.5,31.8,42.0,1,1,1));

   y :array[0..1] of T8Single = ((0.04,0.03,0.04,0.05,0.04,0.04,0.03,0.03),
                                 (0.04,0.08,0.06,0.05,0.04,0,0,0));

   Solla :Single = 0.1338;
   Sollb :Single = -0.0244;

 var
  a,b :Single;

begin
  Result := True;
  if LogRegYSingle(x,y,13,a,b) then begin
                    // ^count of array fields for calculation
    if SimpleRoundTo(a,-4) <> Solla then
      Result := False;
    if SimpleRoundTo(b,-4) <> Sollb then
      Result := False;
   end
  else Result := False;
end;

function TestExpRegYSingle :Boolean;
{calculate the exponential regresion y = ae^(bx), min 2 value needed. Set
 unused needed array fields for x to zero and for y to 1.}
 const
   x :array[0..1] of T8Single = ((41.1,43.3,39.2,42.3,42.8,44.8,41.5,36.6),
                                 (32.9,35.4,45.5,31.8,42.0,0,0,0));

   y :array[0..1] of T8Single = ((0.04,0.03,0.04,0.05,0.04,0.04,0.03,0.03),
                                 (0.04,0.08,0.06,0.05,0.04,1,1,1));

   Solla :Single = 0.066;
   Sollb :Single = -0.011;

 var
  a,b :Single;

begin
  Result := True;
  if ExpRegYSingle(x,y,13,a,b) then begin
                    // ^count of the array fields for calculation
    if SimpleRoundTo(a,-3) <> Solla then
      Result := False;
    if SimpleRoundTo(b,-3) <> Sollb then
      Result := False;
   end
  else Result := False;
end;

function TestBPotenzRegYSingle :Boolean;
{calculate the regresion y = ax^b; min 2 value needed. Set unused needed
 array fields to 1.}
 const
   x :array[0..1] of T8Single = ((41.1,43.3,39.2,42.3,42.8,44.8,41.5,36.6),
                                 (32.9,35.4,45.5,31.8,42.0,1,1,1));

   y :array[0..1] of T8Single = ((0.04,0.03,0.04,0.05,0.04,0.04,0.03,0.03),
                                 (0.04,0.08,0.06,0.05,0.04,1,1,1));

   Solla :Single = 0.228;
   Sollb :Single = -0.458;

 var
  a,b :Single;

begin
  Result := True;
  if BPotenzRegYSingle(x,y,13,a,b) then begin
                        // ^count of the array fields for calculation
  if SimpleRoundTo(a,-3) <> Solla then
     Result := False;
  if SimpleRoundTo(b,-3) <> Sollb then
     Result := False;
  end
  else Result := False;
end;

function TestXPotenzRegYSingle :Boolean;
{calculate the regresion y = ab^x; min 2 value needed. Set unused needed array
 fields for x value to zero and for y value to 1.}
 const
   x :array[0..1] of T8Single = ((41.1,43.3,39.2,42.3,42.8,44.8,41.5,36.6),
                                 (32.9,35.4,45.5,31.8,42.0,0,0,0));

   y :array[0..1] of T8Single = ((0.04,0.03,0.04,0.05,0.04,0.04,0.03,0.03),
                                 (0.04,0.08,0.06,0.05,0.04,1,1,1));

   Solla :Single = 0.066;
   Sollb :Single = 0.989;

 var
  a,b :Single;

begin
  Result := True;
  if XPotenzRegYSingle(x,y,13,a,b) then begin
                         // ^count of the array fields for calculation
    if SimpleRoundTo(a,-3) <> Solla then
      Result := False;
    if SimpleRoundTo(b,-3) <> Sollb then
      Result := False;
   end
  else Result := False;
end;

function TestKorrAnalyseYDouble :Boolean;
{calculate the correlations of x and y; min 4 value needed.
 Result -1 <= Res <= +1; error Res = 2}
 const
   x :array[0..3] of T4Double = ((41.1,43.3,39.2,42.3),
                                 (42.8,44.8,41.5,36.6),
                                 (32.9,35.4,45.5,31.8),
                                 (42.0,0,0,0));

   y :array[0..3] of T4Double = ((0.04,0.03,0.04,0.05),
                                 (0.04,0.04,0.03,0.03),
                                 (0.04,0.08,0.06,0.05),
                                 (0.04,0,0,0));

   SollRes :Double = -0.20;

 var
  Res :Double;

begin
  Result := True;
  Res := KorrAnalyseYDouble(x,y,13);
                             // ^count of the array fields for calculation
  if SimpleRoundTo(Res,-2) <> SollRes then
     Result := False;
end;

function TestLinRegYDouble :Boolean;
{lineare regresion y = a + bx; min 2 value needed. Set unused needed array
 fields to zero.}
 const
   x :array[0..3] of T4Double = ((41.1,43.3,39.2,42.3),
                                 (42.8,44.8,41.5,36.6),
                                 (32.9,35.4,45.5,31.8),
                                 (42.0,0,0,0));

   y :array[0..3] of T4Double = ((0.04,0.03,0.04,0.05),
                                 (0.04,0.04,0.03,0.03),
                                 (0.04,0.08,0.06,0.05),
                                 (0.04,0,0,0));

   Solla :Double = 0.0682;
   Sollb :Double = -0.0006;

 var
  a,b :Double;

begin
  Result := True;
  if LinRegYDouble(x,y,13,a,b) then begin
                    // ^count of the array fields for calculation
    if SimpleRoundTo(a,-4) <> Solla then
      Result := False;
    if SimpleRoundTo(b,-4) <> Sollb then
      Result := False;
   end
  else Result := False;
end;

function TestLogRegYDouble :Boolean;
{Calculate the logaritm regresion y = a + bLn(x); min 2 value needed.
 Set unused needed array fields for x value to 1 and for y value to zero.}
 const
   x :array[0..3] of T4Double = ((41.1,43.3,39.2,42.3),
                                 (42.8,44.8,41.5,36.6),
                                 (32.9,35.4,45.5,31.8),
                                 (42.0,1,1,1));

   y :array[0..3] of T4Double = ((0.04,0.03,0.04,0.05),
                                 (0.04,0.04,0.03,0.03),
                                 (0.04,0.08,0.06,0.05),
                                 (0.04,0,0,0));

   Solla :Double = 0.1338;
   Sollb :Double = -0.0244;

 var
  a,b :Double;

begin
  Result := True;
  if LogRegYDouble(x,y,13,a,b) then begin
                     // ^count of the array fields for calculation
    if SimpleRoundTo(a,-4) <> Solla then
      Result := False;
    if SimpleRoundTo(b,-4) <> Sollb then
      Result := False;
   end
  else Result := False;
end;

function TestExpRegYDouble :Boolean;
{Calculation the regresion y = ae^(bx); min 2 value needed
 Set unused needed array fields for x value to zero and for y value to 1.}

 const
   x :array[0..3] of T4Double = ((41.1,43.3,39.2,42.3),
                                 (42.8,44.8,41.5,36.6),
                                 (32.9,35.4,45.5,31.8),
                                 (42.0,0,0,0));

   y :array[0..3] of T4Double = ((0.04,0.03,0.04,0.05),
                                 (0.04,0.04,0.03,0.03),
                                 (0.04,0.08,0.06,0.05),
                                 (0.04,1,1,1));

   Solla :Double = 0.066;
   Sollb :Double = -0.011;

 var
  a,b :Double;

begin
  Result := True;
  if ExpRegYDouble(x,y,13,a,b) then begin
                     // ^count of the array fields for calculation
  if SimpleRoundTo(a,-3) <> Solla then
     Result := False;
  if SimpleRoundTo(b,-3) <> Sollb then
     Result := False;
  end
  else Result := False;
end;

function TestBPotenzRegYDouble :Boolean;
{calculate regresion y = ax^b; min 2 value needed
 Set unused needed array fields for x and y value to 1.}

 const
   x :array[0..3] of T4Double = ((41.1,43.3,39.2,42.3),
                                 (42.8,44.8,41.5,36.6),
                                 (32.9,35.4,45.5,31.8),
                                 (42.0,1,1,1));

   y :array[0..3] of T4Double = ((0.04,0.03,0.04,0.05),
                                 (0.04,0.04,0.03,0.03),
                                 (0.04,0.08,0.06,0.05),
                                 (0.04,1,1,1));

   Solla :Double = 0.228;
   Sollb :Double = -0.458;

 var
  a,b :Double;

begin
  Result := True;
  if BPotenzRegYDouble(x,y,13,a,b) then begin
                        // ^count of the array fields for calculation
    if SimpleRoundTo(a,-3) <> Solla then
      Result := False;
    if SimpleRoundTo(b,-3) <> Sollb then
      Result := False;
   end
  else Result := False;
end;

function TestXPotenzRegYDouble :Boolean;
{calculate regresion y = ab^x; min 2 value needed.
 Set unused needed array fields for x value to 1 and for y value to zero.}

 const
   x :array[0..3] of T4Double = ((41.1,43.3,39.2,42.3),
                                 (42.8,44.8,41.5,36.6),
                                 (32.9,35.4,45.5,31.8),
                                 (42.0,0,0,0));

   y :array[0..3] of T4Double = ((0.04,0.03,0.04,0.05),
                                  (0.04,0.04,0.03,0.03),
                                  (0.04,0.08,0.06,0.05),
                                  (0.04,1,1,1));

   Solla :Double = 0.066;
   Sollb :Double = 0.989;

 var
  a,b :Double;

begin
  Result := True;
  if XPotenzRegYDouble(x,y,13,a,b) then begin
                        // ^count of the array fields for calculation
    if SimpleRoundTo(a,-3) <> Solla then
      Result := False;
    if SimpleRoundTo(b,-3) <> Sollb then
      Result := False;
   end
  else Result := False;
end;


{-------------------statistic functions for up to 4 or 8 arrays------------}

{The follow values for the calculations are hypotetical chem. pollute
 in cereales (in ppm).}


function TestStatCalcVYSingle :Boolean;
{calculate the statistical values for 5 and up to 8 arrays simultaneous.
When < 5 arrays use the xmm unit.}
 const
   {the count of array fields for calculation, set the count for unused arrays
    to 1}
   count :T8Int32 = (13,13,13,13,13,1,1,1);
   Zn :array[1..13] of Single = (41.1,43.3,39.2,42.3,42.8,44.8,41.5,36.6,
                                 32.9,35.4,45.5,31.8,42.0);
   Cd :array[1..13] of Single = (0.04,0.03,0.04,0.05,0.04,0.04,0.03,0.03,
                                 0.04,0.08,0.06,0.05,0.04);
   Pb :array[1..13] of Single = (0.18,0.17,0.16,0.20,0.14,0.24,0.19,0.14,
                                 0.12,0.22,0.17,0.17,0.12);
   Cu :array[1..13] of Single = (5.1,4.4,5.5,5.0,4.9,5.0,4.6,4.6,5.6,3.8,
                                  6.5,4.1,5.7);
   Fe :array[1..13] of Single = (1,6,8,5,3,10,3,7,8,2,9,2,7);

   Sollaver :T8Single = (39.94,0.04,0.17,4.98,5.46,0,0,0);
   SollsDev :T8Single = (4.43,0.01,0.04,0.72,2.99,0,0,0);
   Sollvari :T8Single = (19.644,0.000,0.001,0.525,8.936,0,0,0);
   Sollskew :T8Single = (-0.6,1.4,0.3,0.4,-0.1,0,0,0);
   SollExc  :T8Single = (-0.9,1.6,-0.6,-0.2,-1.4,-3,-3,-3);
                        // Zn Cd  Pb   Cu  Fe
 var
   i    :Integer;
   Flag :Boolean = False;  // set unused arrays to 0
   Res0 :array[0..12] of T8Single;
   average,sDev,vari,skew,excess :T8Single;

begin
  Result := True;
         // ^count of the T8Single array rows
  {Set the arrays in cols order with unused arrays to zero.}
  if Array5ToT8Single(Zn,Cd,Pb,Cu,Fe,Res0,Flag) then begin
    StatCalcVYSingle(Res0,count,average,sDev,vari,skew,excess);
    for i := 0 to 4 do begin  // only 5 arrays
    if SimpleRoundTo(average[i],-2) <> Sollaver[i] then
       Result := False;
    if SimpleRoundTo(sDev[i],-2) <> SollsDev[i] then
      Result := False;
    if SimpleRoundTo(vari[i],-3) <> Sollvari[i] then
      Result := False;
    if SimpleRoundTo(skew[i],-1) <> Sollskew[i] then
      Result := False;
    if SimpleRoundTo(excess[i],-1) <> SollExc[i] then
      Result := False;
    end;
  end;
end;

function TestStatCalcVYDouble :Boolean;
{calculate the statistical values for 3 or 4 arrays simultaneous. See upper
 when < 3 arrays use xmm unit}
 const
   count :T4Int32 = (13,13,13,13);
   Zn :array[1..13] of Double = (41.1,43.3,39.2,42.3,42.8,44.8,41.5,36.6,
                                 32.9,35.4,45.5,31.8,42.0);
   Cd :array[1..13] of Double = (0.04,0.03,0.04,0.05,0.04,0.04,0.03,0.03,
                                 0.04,0.08,0.06,0.05,0.04);
   Pb :array[1..13] of Double = (0.18,0.17,0.16,0.20,0.14,0.24,0.19,0.14,
                                 0.12,0.22,0.17,0.17,0.12);
   Cu :array[1..13] of Double = (5.1,4.4,5.5,5.0,4.9,5.0,4.6,4.6,5.6,3.8,
                                 6.5,4.1,5.7);
   Sollaver :T4Double = (39.94,0.04,0.17,4.98);
   SollsDev :T4Double = (4.43,0.01,0.04,0.72);
   Sollvari :T4Double = (19.644,0.000,0.001,0.525);
   Sollskew :T4Double = (-0.64,1.42,0.30,0.35);
   SollExc  :T4Double = (-0.86,1.62,-0.63,-0.22);
                       // Zn    Cd    Pb   Cu
 var
  Res0 :array[0..12] of T4Double;
  i :Integer;
  average,sDev,vari,skew,excess :T4Double;

begin
  Result := True;
  if Array4ToT4Double(Zn,Cd,Pb,Cu,Res0) then begin
    StatCalcVYDouble(Res0,count,average,sDev,vari,skew,excess);
    for i := 0 to 3 do begin
    if SimpleRoundTo(average[i],-2) <> Sollaver[i] then
       Result := False;
    if SimpleRoundTo(sDev[i],-2) <> SollsDev[i] then
      Result := False;
    if SimpleRoundTo(vari[i],-3) <> Sollvari[i] then
      Result := False;
    if SimpleRoundTo(skew[i],-2) <> Sollskew[i] then
      Result := False;
    if SimpleRoundTo(excess[i],-2) <> SollExc[i] then
      Result := False;
    end;
  end;
end;

function TestAverageVYSingle :Boolean;
{calculate the arithm. average for 5 or up to 8 arrays simultaneus. Set unused
 arrays to zero and the parameter count to 1 for unused arrays.
 The parameter count give the count of array fields.
 When < 5 arrays use the xmm unit.}

 const
   count :T8Int32 = (13,13,13,13,13,1,1,1);
   Zn :array[1..13] of Single = (41.1,43.3,39.2,42.3,42.8,44.8,41.5,36.6,
                                 32.9,35.4,45.5,31.8,42.0);
   Cd :array[1..13] of Single = (0.04,0.03,0.04,0.05,0.04,0.04,0.03,0.03,
                                 0.04,0.08,0.06,0.05,0.04);
   Pb :array[1..13] of Single = (0.18,0.17,0.16,0.20,0.14,0.24,0.19,0.14,
                                 0.12,0.22,0.17,0.17,0.12);
   Cu :array[1..13] of Single = (5.1,4.4,5.5,5.0,4.9,5.0,4.6,4.6,5.6,3.8,
                                  6.5,4.1,5.7);
   Fe :array[1..13] of Single = (1,6,8,5,3,10,3,7,8,2,9,2,7);
   Soll :T8Single = (39.94,0.04,0.17,4.98,5.46,0,0,0);
                   // Zn    Cd    Pb   Cu Fe
 var
   i    :Integer;
   Flag :Boolean = False;  // set unused arrays to 0
   Res0 :array[0..12] of T8Single;
   Res  :T8Single;

begin
  Result := True;
  {Set arrays in cols order.}
  if Array5ToT8Single(Zn,Cd,Pb,Cu,Fe,Res0,Flag) then begin
    Res := AverageVYSingle(Res0,count);
    for i := 0 to 4 do begin // only 5 arrays
    if SimpleRoundTo(Res[i],-2) <> Soll[i] then
       Result := False;
    end;
  end;
end;

function TestAverageVYDouble :Boolean;
{see upper For 3 or 4 arrays, when < 3 arrays use xmm unit.}
 const
   count :T4Int32 = (13,13,13,13);
   Zn :array[1..13] of Double = (41.1,43.3,39.2,42.3,42.8,44.8,41.5,36.6,
                                 32.9,35.4,45.5,31.8,42.0);
   Cd :array[1..13] of Double = (0.04,0.03,0.04,0.05,0.04,0.04,0.03,0.03,
                                 0.04,0.08,0.06,0.05,0.04);
   Pb :array[1..13] of Double = (0.18,0.17,0.16,0.20,0.14,0.24,0.19,0.14,
                                 0.12,0.22,0.17,0.17,0.12);
   Cu :array[1..13] of Double = (5.1,4.4,5.5,5.0,4.9,5.0,4.6,4.6,5.6,3.8,
                                 6.5,4.1,5.7);
   Soll :T4Double = (39.94,0.04,0.17,4.98);
                    // Zn   Cd   Pb   Cu
 var
  Res0 :array[0..12] of T4Double;
  Res :T4Double;
  i :Integer;

begin
  Result := True;
  if Array4ToT4Double(Zn,Cd,Pb,Cu,Res0) then begin
    Res := AverageVYDouble(Res0,count);
    for i := 0 to 3 do begin
    if SimpleRoundTo(Res[i],-2) <> Soll[i] then
       Result := False;
    end;
  end;
end;

function TestGeoAverageVYSingle :Boolean;
{Calculate the geometric average for 5 or up to 8 arrays simultaneous.
 Set unused arrays to 1. Set the parameter count to 1 for unused arrays.
 The parameter count is the count of the array fields in array.
 When < 5 arrays use the xmm unit.}
 const
   count :T8Int32 = (13,13,13,13,13,1,1,1);
   Zn :array[1..13] of Single = (41.1,43.3,39.2,42.3,42.8,44.8,41.5,36.6,
                                 32.9,35.4,45.5,31.8,42.0);
   Cd :array[1..13] of Single = (0.04,0.03,0.04,0.05,0.04,0.04,0.03,0.03,
                                 0.04,0.08,0.06,0.05,0.04);
   Pb :array[1..13] of Single = (0.18,0.17,0.16,0.20,0.14,0.24,0.19,0.14,
                                 0.12,0.22,0.17,0.17,0.12);
   Cu :array[1..13] of Single = (5.1,4.4,5.5,5.0,4.9,5.0,4.6,4.6,5.6,3.8,
                                  6.5,4.1,5.7);
   Fe :array[1..13] of Single = (1,6,8,5,3,10,3,7,8,2,9,2,7);
   Soll :T8Single = (39.70,0.04,0.17,4.94,4.49,1,1,1);
                    // Zn   Cd   Pb   Cu   Fe
 var
   i    :Integer;
   Flag :Boolean = True;  // set unused arrays to 1.0
   Res0 :array[0..12] of T8Single;
   Res  :T8Single;

begin
  Result := True;
  {Set arrays in cols order.}
  if Array5ToT8Single(Zn,Cd,Pb,Cu,Fe,Res0,Flag) then begin
    Res := GeoAverageVYSingle(Res0,count);
    for i := 0 to 7 do begin
    if SimpleRoundTo(Res[i],-2) <> Soll[i] then
       Result := False;
    end;
  end;
end;

function TestGeoAverageVYDouble :Boolean;
{Calculate the geometric average for 3 or 4 araays simultaneous. Set unused
 arrays to 1. Set parameter count for unused arras to 1.
 When < 3 arrays use the xmm unit.}
 const
   count :T4Int32 = (13,13,13,13);
   Zn :array[1..13] of Double = (41.1,43.3,39.2,42.3,42.8,44.8,41.5,36.6,
                                 32.9,35.4,45.5,31.8,42.0);
   Cd :array[1..13] of Double = (0.04,0.03,0.04,0.05,0.04,0.04,0.03,0.03,
                                 0.04,0.08,0.06,0.05,0.04);
   Pb :array[1..13] of Double = (0.18,0.17,0.16,0.20,0.14,0.24,0.19,0.14,
                                 0.12,0.22,0.17,0.17,0.12);
   Cu :array[1..13] of Double = (5.1,4.4,5.5,5.0,4.9,5.0,4.6,4.6,5.6,3.8,
                                 6.5,4.1,5.7);
   Soll :T4Double = (39.70,0.04,0.17,4.94);
                  //  Zn    Cd   Pb   Cu
 var
  Res0 :array[0..12] of T4Double;
  Res :T4Double;
  i :Integer;

begin
  Result := True;
  if Array4ToT4Double(Zn,Cd,Pb,Cu,Res0) then begin
    Res := GeoAverageVYDouble(Res0,count);
    for i := 0 to 3 do begin
    if SimpleRoundTo(Res[i],-2) <> Soll[i] then
       Result := False;
    end;
  end;
end;



{statistic functions for 2,3 or 4 array pairs}


function TestKorrAnalyse4VYSingle :Boolean;
{Calculate the correlation of 3 or 4 array pairs simultaneous.
 When < 3 array pairs use the xmm unit.
 The array pairs must have the equal count of fields.}
 const
   {set count for unused arrays to 1}
   count :T8Int32 = (13,13,13,13,13,13,1,1);

   Zn :array[1..13] of Single = (41.1,43.3,39.2,42.3,42.8,44.8,41.5,36.6,
                                 32.9,35.4,45.5,31.8,42.0);
   Cd :array[1..13] of Single = (0.04,0.03,0.04,0.05,0.04,0.04,0.03,0.03,
                                 0.04,0.08,0.06,0.05,0.04);
   Pb :array[1..13] of Single = (0.18,0.17,0.16,0.20,0.14,0.24,0.19,0.14,
                                 0.12,0.22,0.17,0.17,0.12);
   Cu :array[1..13] of Single = (5.1,4.4,5.5,5.0,4.9,5.0,4.6,4.6,5.6,3.8,
                                  6.5,4.1,5.7);
   Fe :array[1..13] of Single = (1,6,8,5,3,10,3,7,8,2,9,2,7);
   Mn :array[1..13] of Single = (2,7,9,10,12,13,14,2,10,7,3,2,4);

   Soll :T4Single = (-0.195,-0.388,0.141,0);

 var
   i    :Integer;
   Flag :Boolean = False;  // set unused arrays to 0
   Res0 :array[0..12] of T8Single;
   Res  :T4Single;

begin
  Result := True;
  {Set arrays in cols order. corr for Zb and Cd and Pb and Cu and Fe and Mn.}
  if Array6ToT8Single(Zn,Cd,Pb,Cu,Fe,Mn,Res0,Flag) then begin
    Res := KorrAnalyse4VYSingle(Res0,count);
    for i := 0 to 2 do begin  // only 3 values as result
      if SimpleRoundTo(Res[i],-3) <> Soll[i] then
       Result := False;
    end;
  end;
end;

function TestKorrAnalyse2VYDouble :Boolean;
{seee upper; corelation for 2 array pairs. when < 2 array pairs use the xmm unit.
 The array pairs must have the equal count of fields.}
 const
   count :T4Int32 = (13,13,13,13);

   Zn :array[1..13] of Double = (41.1,43.3,39.2,42.3,42.8,44.8,41.5,36.6,
                                 32.9,35.4,45.5,31.8,42.0);
   Cd :array[1..13] of Double = (0.04,0.03,0.04,0.05,0.04,0.04,0.03,0.03,
                                 0.04,0.08,0.06,0.05,0.04);
   Pb :array[1..13] of Double = (0.18,0.17,0.16,0.20,0.14,0.24,0.19,0.14,
                                 0.12,0.22,0.17,0.17,0.12);
   Cu :array[1..13] of Double = (5.1,4.4,5.5,5.0,4.9,5.0,4.6,4.6,5.6,3.8,
                                  6.5,4.1,5.7);

   Soll :T2Double = (-0.195,-0.388);

 var
  Res0 :array[0..12] of T4Double;
  Res  :T2Double;
  i    :Integer;

begin
  Result := True;
  if Array4ToT4Double(Zn,Cd,Pb,Cu,Res0) then begin
    Res := KorrAnalyse2VYDouble(Res0,count);
    for i := 0 to 1 do begin
      if SimpleRoundTo(Res[i],-3) <> Soll[i] then
       Result := False;
    end;
  end;
end;

function TestLinReg4VYSingle :Boolean;
{calculate the lin. regression (y = a + bx) for 3 or 4 array pairs simultaneous.
 When < 3 array pairs use the xmm unit.
 The count of the array fields on the pair must are equal. Set unused arrays
 to zero and count to 1.}
 const
   {set unused arrays to 1}
   count :T8Int32 = (13,13,13,13,13,13,1,1);

   Zn :array[1..13] of Single = (41.1,43.3,39.2,42.3,42.8,44.8,41.5,36.6,
                                 32.9,35.4,45.5,31.8,42.0);
   Cd :array[1..13] of Single = (0.04,0.03,0.04,0.05,0.04,0.04,0.03,0.03,
                                 0.04,0.08,0.06,0.05,0.04);
   Pb :array[1..13] of Single = (0.18,0.17,0.16,0.20,0.14,0.24,0.19,0.14,
                                 0.12,0.22,0.17,0.17,0.12);
   Cu :array[1..13] of Single = (5.1,4.4,5.5,5.0,4.9,5.0,4.6,4.6,5.6,3.8,
                                  6.5,4.1,5.7);
   Fe :array[1..13] of Single = (1,6,8,5,3,10,3,7,8,2,9,2,7);
   Mn :array[1..13] of Single = (2,7,9,10,12,13,14,2,10,7,3,2,4);

   Soll :T8Single = (0.0682,-0.0006,6.3106,-7.7646,6.1793,0.2066,0,0);
                   //  a1      b1     a2     b2      a3     b3
 var
  Res0 :array[0..12] of T8Single;
  Res  :T8Single;
  i    :Integer;

begin
  Result := True;
  {Set arays in cols order. lin regression for Zn,Cd and Pb,Cu and Fe, Mn.}
  if Array6ToT8Single(Zn,Cd,Pb,Cu,Fe,Mn,Res0,False) then begin
    Res := LinReg4VYSingle(Res0,count);//^ set unused arrays to 0
    for i := 0 to 5 do begin // only 3 pairs
      if SimpleRoundTo(Res[i],-4) <> Soll[i] then
       Result := False;
    end;
  end;
end;

function TestLinReg2VYDouble :Boolean;
{see upper; for 2 array pairs. The array pairs must have the equal
 count of fields.}
 const
   count :T4Int32 = (13,13,13,13);

   Zn :array[1..13] of Double = (41.1,43.3,39.2,42.3,42.8,44.8,41.5,36.6,
                                 32.9,35.4,45.5,31.8,42.0);
   Cd :array[1..13] of Double = (0.04,0.03,0.04,0.05,0.04,0.04,0.03,0.03,
                                 0.04,0.08,0.06,0.05,0.04);
   Pb :array[1..13] of Double = (0.18,0.17,0.16,0.20,0.14,0.24,0.19,0.14,
                                 0.12,0.22,0.17,0.17,0.12);
   Cu :array[1..13] of Double = (5.1,4.4,5.5,5.0,4.9,5.0,4.6,4.6,5.6,3.8,
                                  6.5,4.1,5.7);

   Soll :T4Double = (0.0682,-0.0006,6.3106,-7.7647);
                    // a1      b1     a2      b2
 var
  Res0 :array[0..12] of T4Double;
  Res  :T4Double;
  i    :Integer;

begin
  Result := True;
  {Set arrays in cols order. regression for Zn and Cd and Pb and Cu.}
  if Array4ToT4Double(Zn,Cd,Pb,Cu,Res0) then begin
    Res := LinReg2VYDouble(Res0,count);
    for i := 0 to 3 do begin
      if SimpleRoundTo(Res[i],-4) <> Soll[i] then
       Result := False;
    end;
  end;
end;

function TestLogReg4VYSingle :Boolean;
{logarithm regresion for 3 or 4 array pairs. y = a + b*Ln(x).
 When < 3 use the xmm unit.
 The count of the array fields on the pair must are equal.
 Set unused arrays and count to 1.}
 const
   {set unused array to 1}
   count :T8Int32 = (13,13,13,13,13,13,1,1);

   Zn :array[1..13] of Single = (41.1,43.3,39.2,42.3,42.8,44.8,41.5,36.6,
                                 32.9,35.4,45.5,31.8,42.0);
   Cd :array[1..13] of Single = (0.04,0.03,0.04,0.05,0.04,0.04,0.03,0.03,
                                 0.04,0.08,0.06,0.05,0.04);
   Pb :array[1..13] of Single = (0.18,0.17,0.16,0.20,0.14,0.24,0.19,0.14,
                                 0.12,0.22,0.17,0.17,0.12);
   Cu :array[1..13] of Single = (5.1,4.4,5.5,5.0,4.9,5.0,4.6,4.6,5.6,3.8,
                                  6.5,4.1,5.7);
   Fe :array[1..13] of Single = (1,6,8,  5, 3,10, 3,7, 8,2,9,2,7);
   Mn :array[1..13] of Single = (2,7,9, 10,12,13,14,2,10,7,3,2,4);

   Soll :T8Single = (0.1338,-0.0244,2.5679,-1.3514,5.2641,1.3599,0,0);
                       // a1    b1    a2      b2     c1     c2
 var
  Res0 :array[0..12] of T8Single;
  Res  :T8Single;
  i    :Integer;

begin
  Result := True;
  {Set arrays in cols order. Regression for Zn and Cd and Pb and Cu Fe and Mn.}
  if Array6ToT8Single(Zn,Cd,Pb,Cu,Fe,Mn,Res0,True) then begin
    Res := LogReg4VYSingle(Res0,count);//^ set unused arrays to 1.0
    for i := 0 to 5 do begin  // only 3 result pairs
      if SimpleRoundTo(Res[i],-4) <> Soll[i] then
       Result := False;
    end;
  end;
end;

function TestLogReg2VYDouble :Boolean;
{Log. regresion for 2 array pairs}
 const
   count :T4Int32 = (13,13,13,13);

   Zn :array[1..13] of Double = (41.1,43.3,39.2,42.3,42.8,44.8,41.5,36.6,
                                 32.9,35.4,45.5,31.8,42.0);
   Cd :array[1..13] of Double = (0.04,0.03,0.04,0.05,0.04,0.04,0.03,0.03,
                                 0.04,0.08,0.06,0.05,0.04);
   Pb :array[1..13] of Double = (0.18,0.17,0.16,0.20,0.14,0.24,0.19,0.14,
                                 0.12,0.22,0.17,0.17,0.12);
   Cu :array[1..13] of Double = (5.1,4.4,5.5,5.0,4.9,5.0,4.6,4.6,5.6,3.8,
                                  6.5,4.1,5.7);

   Soll :T4Double = (0.1338,-0.0244,2.5679,-1.3514);
                       //a1    b1     a2      b2
 var
  Res0 :array[0..12] of T4Double;
  Res :T4Double;
  i :Integer;

begin
  Result := True;
  if Array4ToT4Double(Zn,Cd,Pb,Cu,Res0) then begin
    Res := LogReg2VYDouble(Res0,count);
    for i := 0 to 3 do begin
      if SimpleRoundTo(Res[i],-4) <> Soll[i] then
       Result := False;
    end;
  end;
end;

function TestExpReg4VYSingle :Boolean;
{Calculation for y = ae^(bx) for 3 or 4 array pairs. The array pairs must
 have the equal count of array fields. Set unused arrays and count to 1.}
 const
   {set unused array to 1}
   count :T8Int32 = (13,13,13,13,13,13,1,1);

   Zn :array[1..13] of Single = (41.1,43.3,39.2,42.3,42.8,44.8,41.5,36.6,
                                 32.9,35.4,45.5,31.8,42.0);
   Cd :array[1..13] of Single = (0.04,0.03,0.04,0.05,0.04,0.04,0.03,0.03,
                                 0.04,0.08,0.06,0.05,0.04);
   Pb :array[1..13] of Single = (0.18,0.17,0.16,0.20,0.14,0.24,0.19,0.14,
                                 0.12,0.22,0.17,0.17,0.12);
   Cu :array[1..13] of Single = (5.1,4.4,5.5,5.0,4.9,5.0,4.6,4.6,5.6,3.8,
                                  6.5,4.1,5.7);
   Fe :array[1..13] of Single = (1,6,8,5,3,10,3,7,8,2,9,2,7);
   Mn :array[1..13] of Single = (2,7,9,10,12,13,14,2,10,7,3,2,4);

   Soll :T8Single = (0.066,-0.011,6.489,-1.601,4.462,0.049,0,0);
                    // a1     b1    a2     b2    a3    b3
 var
  Res0 :array[0..12] of T8Single;
  Res  :T8Single;
  i    :Integer;

begin
  Result := True;
  {Set arrays in cols order. Regression for Zn and Cd and Pb and Cu.}
  if Array6ToT8Single(Zn,Cd,Pb,Cu,Fe,Mn,Res0,True) then begin
    Res := ExpReg4VYSingle(Res0,count);// ^  set unused arrays to 1.0
    for i := 0 to 5 do begin // only 3 pairs
      if SimpleRoundTo(Res[i],-3) <> Soll[i] then
       Result := False;
    end;
  end;
end;

function TestExpReg2VYDouble :Boolean;
{see upper;s y = ae^(bx) for 2 array pairs.}
 const
   count :T4Int32 = (13,13,13,13);

   Zn :array[1..13] of Double = (41.1,43.3,39.2,42.3,42.8,44.8,41.5,36.6,
                                 32.9,35.4,45.5,31.8,42.0);
   Cd :array[1..13] of Double = (0.04,0.03,0.04,0.05,0.04,0.04,0.03,0.03,
                                 0.04,0.08,0.06,0.05,0.04);
   Pb :array[1..13] of Double = (0.18,0.17,0.16,0.20,0.14,0.24,0.19,0.14,
                                 0.12,0.22,0.17,0.17,0.12);
   Cu :array[1..13] of Double = (5.1,4.4,5.5,5.0,4.9,5.0,4.6,4.6,5.6,3.8,
                                  6.5,4.1,5.7);

   Soll :T4Double = (0.066,-0.011,6.489,-1.601);
                    // a1    b1     a2     b2
 var
  Res0 :array[0..12] of T4Double;
  Res :T4Double;
  i :Integer;

begin
  Result := True;
  {Set arrays in cols order. Regression for Zn and Cd and Pb and Cu.}
  if Array4ToT4Double(Zn,Cd,Pb,Cu,Res0) then begin
    Res := ExpReg2VYDouble(Res0,count);
    for i := 0 to 3 do begin
      if SimpleRoundTo(Res[i],-3) <> Soll[i] then
       Result := False;
    end;
  end;
end;

function TestBPotenzReg4VYSingle :Boolean;
{calculate the regresion y = ax^b for 3 or 4 array pairs.
 When < 3 use the xmm unit.
 Each array pair must have the equal count of array fields.
 Set unused arrays and the parameter count to 1.0}
 const
   {set unused array to 1}
   count :T8Int32 = (13,13,13,13,13,13,1,1);

   Zn :array[1..13] of Single = (41.1,43.3,39.2,42.3,42.8,44.8,41.5,36.6,
                                 32.9,35.4,45.5,31.8,42.0);
   Cd :array[1..13] of Single = (0.04,0.03,0.04,0.05,0.04,0.04,0.03,0.03,
                                 0.04,0.08,0.06,0.05,0.04);
   Pb :array[1..13] of Single = (0.18,0.17,0.16,0.20,0.14,0.24,0.19,0.14,
                                 0.12,0.22,0.17,0.17,0.12);
   Cu :array[1..13] of Single = (5.1,4.4,5.5,5.0,4.9,5.0,4.6,4.6,5.6,3.8,
                                  6.5,4.1,5.7);
   Fe :array[1..13] of Single = (1,6,8,5,3,10,3,7,8,2,9,2,7);
   Mn :array[1..13] of Single = (2,7,9,10,12,13,14,2,10,7,3,2,4);
   Soll :T8Single = (0.228,-0.458,2.996,-0.279,3.686,0.306,0,0);
                    // a1     b1    a2     b2
 var
  i    :Integer;
  Flag :Boolean = True;  // set unused arrays to 1.0
  Res0 :array[0..12] of T8Single;
  Res  :T8Single;

begin
  Result := True;
  {Set arrays in cols order. Regression for Zn,Cd and Pb,Cu and Fe,Mn.}
  if Array6ToT8Single(Zn,Cd,Pb,Cu,Fe,Mn,Res0,Flag) then begin
    Res := BPotenzReg4VYSingle(Res0,count);
    for i := 0 to 3 do begin
      if SimpleRoundTo(Res[i],-3) <> Soll[i] then
       Result := False;
    end;
  end;
end;

function TestBPotenzReg2VYDouble :Boolean;
{see upper; regresion for 2 array pairs (y = ax^(b))}
 const
   count :T4Int32 = (13,13,13,13);

   Zn :array[1..13] of Double = (41.1,43.3,39.2,42.3,42.8,44.8,41.5,36.6,
                                 32.9,35.4,45.5,31.8,42.0);
   Cd :array[1..13] of Double = (0.04,0.03,0.04,0.05,0.04,0.04,0.03,0.03,
                                 0.04,0.08,0.06,0.05,0.04);
   Pb :array[1..13] of Double = (0.18,0.17,0.16,0.20,0.14,0.24,0.19,0.14,
                                 0.12,0.22,0.17,0.17,0.12);
   Cu :array[1..13] of Double = (5.1,4.4,5.5,5.0,4.9,5.0,4.6,4.6,5.6,3.8,
                                  6.5,4.1,5.7);

   Soll :T4Double = (0.228,-0.458,2.996,-0.279);
                    // a1    b1    a2     b2
 var
  Res0 :array[0..12] of T4Double;
  Res :T4Double;
  i :Integer;

begin
  Result := True;
  {Set arrays in cols order. Regression for Zn, Cd and Pb,Cu.}
  if Array4ToT4Double(Zn,Cd,Pb,Cu,Res0) then begin
    Res := BPotenzReg2VYDouble(Res0,count);
    for i := 0 to 3 do begin
      if SimpleRoundTo(Res[i],-3) <> Soll[i] then
       Result := False;
    end;
  end;
end;

function TestXPotenzReg4VYSingle :Boolean;
{Regression for 3 or 4 array pairs. (y = ab^(x) The count of the array fields
 must are equal for each array pair. The parameter count has the count of
 the array fields. Set unused arrays and count to 1.0
 When < 3 pairs use xmm unit}
 const
   {set unused array to 1}
   count :T8Int32 = (13,13,13,13,13,13,1,1);

   Zn :array[1..13] of Single = (41.1,43.3,39.2,42.3,42.8,44.8,41.5,36.6,
                                 32.9,35.4,45.5,31.8,42.0);
   Cd :array[1..13] of Single = (0.04,0.03,0.04,0.05,0.04,0.04,0.03,0.03,
                                 0.04,0.08,0.06,0.05,0.04);
   Pb :array[1..13] of Single = (0.18,0.17,0.16,0.20,0.14,0.24,0.19,0.14,
                                 0.12,0.22,0.17,0.17,0.12);
   Cu :array[1..13] of Single = (5.1,4.4,5.5,5.0,4.9,5.0,4.6,4.6,5.6,3.8,
                                  6.5,4.1,5.7);
   Fe :array[1..13] of Single = (1,6,8,5,3,10,3,7,8,2,9,2,7);
   Mn :array[1..13] of Single = (2,7,9,10,12,13,14,2,10,7,3,2,4);
   Soll :T8Single = (0.066,0.989,6.489,0.202,4.462,1.051,0,0);
                    // a1    b1    a2    b2   a3    b3
 var
   i    :Integer;
   Flag :Boolean = True;  // set unused arrays to 1.0
   Res0 :array[0..12] of T8Single;
   Res  :T8Single;

begin
  Result := True;
  {Set arrays in cols order. Regression for Zn,Cd and Pb,Cu and Fe,Mn.}
  if Array6ToT8Single(Zn,Cd,Pb,Cu,Fe,Mn,Res0,Flag) then begin
    Res := XPotenzReg4VYSingle(Res0,count);
    for i := 0 to 5 do begin  // only 3 pairs
      if SimpleRoundTo(Res[i],-3) <> Soll[i] then
       Result := False;
    end;
  end;
end;

function TestXPotenzReg2VYDouble :Boolean;
{Regression for 2 array pairs. See upper}
 const
   count :T4Int32 = (13,13,13,13); // count of array fields

   Zn :array[1..13] of Double = (41.1,43.3,39.2,42.3,42.8,44.8,41.5,36.6,
                                 32.9,35.4,45.5,31.8,42.0);
   Cd :array[1..13] of Double = (0.04,0.03,0.04,0.05,0.04,0.04,0.03,0.03,
                                 0.04,0.08,0.06,0.05,0.04);
   Pb :array[1..13] of Double = (0.18,0.17,0.16,0.20,0.14,0.24,0.19,0.14,
                                 0.12,0.22,0.17,0.17,0.12);
   Cu :array[1..13] of Double = (5.1,4.4,5.5,5.0,4.9,5.0,4.6,4.6,5.6,3.8,
                                  6.5,4.1,5.7);

   Soll :T4Double = (0.066,0.989,6.489,0.202);
                    // a1    b1    a2    b2
 var
  Res0 :array[0..12] of T4Double;
  Res :T4Double;
  i :Integer;

begin
  Result := True;
  {Set arrays in cols order. Regression for Zn and Cd and Pb and Cu.}
  if Array4ToT4Double(Zn,Cd,Pb,Cu,Res0) then begin
    Res := XPotenzReg2VYDouble(Res0,count);
    for i := 0 to 3 do begin
      if SimpleRoundTo(Res[i],-3) <> Soll[i] then
       Result := False;
    end;
  end;
end;

{$ENDIF}


end.


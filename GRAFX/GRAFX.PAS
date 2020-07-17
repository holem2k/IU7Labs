program Grfx;
{$N+,E+}
uses Graph, Menus, Mouse, Crt, Strings, TInput, CalcBP;
const
     MarginTop: Integer = 30;
     MarginBot: Integer = 70;
     MarginLeft: Integer = 80;
     MarginRight: Integer = 20;

const
     Color: array [1..2] of Byte = (Red, Blue);

var
   Def1, Def2: Boolean;
   xb, xe: Real;
   SXb, SXe: string;
   MinF, MaxF: array [1..2] of Real;
   Gd, Gm, GErr : Integer;
   Nx, Ny: Word;
   dx, dy: Real;
   SNy: string;
   Sdx, Sdy: string;
   GrOO: Boolean;
   BegX, DistX: Integer;
   BegY, DistY, Y0: Integer;
   BothScale: Boolean;                { true - один масштаб }
   FuncStr, tFuncStr: array [1..2] of string;
   FindBent: Boolean;
   NDX, NDY: Word;
   UD: Word;
   LinesStyle: Word;

procedure Bent(Num: Integer); forward;

function Func(Num: Byte; x : Real): Real;
begin
  Func := FuncX(Num, X);
end;

procedure  FindMinMax(Num: Byte; var Min, Max: Real);
{ Определение наименьшего и наибольшего значений f(x) на сегменте }
var
   Step, X, Y: Real;
   i: Integer;
begin
  Min := 1e38; Max := -1e38;
  X := xb;
  for  i := MarginLeft to GeTMaxX - MarginRight do begin
     X := xb + (xe - xb)/(GetMaxX - MarginLeft - MarginRight + 1)*
          (i - MarginLeft);
     GE := False;
     Y := Func(Num, X);
     if not GE then begin
       if Y > Max then Max := Y;
       if Y < Min then Min := Y;
     end;
  end;
  if Max = Min then
    begin
      Max := Max + 5;
      Min := Min - 5;
    end;
end;

procedure FindBothMM;
{ Нахождение min и max обеих функций }
begin
  FindMinMax(1, MinF[1], MaxF[1]);
  FindMinMax(2, MinF[2], MaxF[2]);
end;

{***************************************************************************}

function KillSpaces(s: string): string;
begin
  While S[1] = ' ' do Delete(S, 1, 1);
  KillSpaces := S;
end;

{***************************************************************************}

function CountAPoint(S: string): Word;
{ подсчет числа цифр после запятой }
var
   i: Word;
begin
  i := System.Length(S);
  while (S[i] <> '.') and (i >= 1) do Dec(i);
  if i = 0 then CountAPoint := 0
     else CountAPoint := System.Length(S) - i;
end;

{***************************************************************************}

function KillZeros(s: string): string;
var
   i: Word;
begin
  i := System.Length(s);
  While (S[i] <> '.')  and  (i > 1) do Dec(I);
  s[0] := Chr(i + UD);
  KillZeros := s;
end;

{***************************************************************************}

function Covert(R: Real): string;
var
   s: string;
begin
    if Abs(R) < 1e-10 then  begin
                              Covert := '0.0';
                              Exit;
                            end
   else
    if (Abs(R)>100000) or (Abs(R)<1e-4) then
                         begin
                           Str(R:9, s);
                           Covert := KillSpaces(S);
                           Exit;
                         end
   else
    if Frac(R) = 0 then begin
                          Str(R:9:0, s);
                          Covert := KillSpaces(s);
                          Exit;
                        end

   else
    if (Abs(R)<1) then Str(R:9:6, s)
   else
     Str(R:9:2, s);
    Covert := KillZeros( KillSpaces(s));
end;

{****************************************************************************}
{              ГОРИЗОНТАЛЬНАЯ СЕТКА ПРИ ЗАДАННОМ ЧИСЛЕ ЛИНИЙ                 }
{****************************************************************************}

procedure Grid(Min, Max: Real; Check: Boolean);
{ Check - производится выравнивание сетки по нулевой линии }
var
   Dist, Offs: Integer;
   Beg, X0, Y0: Integer;
begin
  SetColor(Green);
  SetLineStyle(1, 0, NormWidth);
  Dist := Round((GetMaxY - MarginTop - MarginBot + 1)/(Ny + 1));
  Beg := MarginTop + Dist;
  {$B+}
  if Check and (Min < 0) and (Max > 0) then begin
     Y0 := GetMaxY - MarginBot - Round(-Min*(GetMaxY - MarginTop - MarginBot + 1)/(Max - Min));
     Grfx.Y0 := Y0;
     Offs := (Y0 - MarginTop) mod Dist;
     if Offs >= Dist div 2 then Offs := -(Dist - Offs);
     Beg := Beg + Offs;
     if Beg < MarginTop then Beg := Beg + Dist;
  end;
  BegY := Beg;
  DistY := Dist;
  while Beg <= GetMaxY - MarginBot do begin
    SetColor(Green);
    if Check and (Beg = Y0) then
         begin
           SetLineStyle(0, 0, NormWidth);
           SetColor(Magenta);
         end;
    Line(MarginLeft, Beg, GetMaxX - MarginRight, Beg);
    SetLineStyle(1, 0, NormWidth);
    Beg := Beg + Dist;
  end;
  SetLineStyle(0, 0, NormWidth);
end;

procedure MakeNumbers(Min, Max: Real; Check: Boolean);
var
   B, i, Xt: Integer;
   X, Y: Real;
   s1, s2: String;
begin
  UD := 2;
  for i := 1 to 2 do begin
   B := BegY;
   if not Check then begin
        Min := MinF[i];
        Max := MaxF[i];
        Y0 := 0;
   end;
   While (B<= GetMaxY - MarginBot) do begin
     Y := Max - (B - MarginTop)*(Max - Min)/
          (GetMaxY - MarginTop - MarginBot + 1);
     if B = Y0 then Y := 0;
     SetColor(Color[i]);
     SetTextStyle(2,0,5);
     if i = 1 then  Xt := MarginLeft - 5 - TextWidth(Covert(Y))
        else Xt := GetMaxX - MarginRight + 5;
     if XT<0 then X := 1;
     SetColor(Color[i]);
     OutTextXY(Xt, B - TextHeight('1') div 2 -2, Covert(Y));
     B := B + DistY;
   end;
   SetTextStyle(2, 0, 4);
   if i = 1 then
    begin
       s1 := '  max[f(x)] = ';
      s2 := Covert(MaxF[1]);
      s1 := s1 + s2 + ' min[f(x)] =  ';
      s2 := Covert(MinF[1]);
      s1 := s1 + s2;
      OutTextXY(MarginLeft, MarginTop - (4 + TextHeight('A'))*(3-i), ConCat('f(x) = ', FuncStr[i], s1))
    end
  else
    begin
     s1 := '  max[g(x)] = ';
     s2 := Covert(MaxF[2]);
     s1 := s1 + s2 + ' min[g(x)] =  ';
     s2 := Covert(MinF[2]);
     s1 := s1 + s2;
     OutTextXY(MarginLeft, MarginTop - (4 + TextHeight('A'))*(3-i), ConCat('g(x) = ', FuncStr[i], s1));
    end;
  end;
end;

{***************************************************************************}
{         УСТАНОВКА ОТСТУПОВ                                                }
{***************************************************************************}

procedure MarginOne;
begin
     MarginTop    := 30;
     MarginBot    := 70;
     MarginLeft   := 80;
     MarginRight  := 20;
end;

procedure MarginTwo;
begin
     MarginTop    := 30;
     MarginBot    := 70;
     MarginLeft   := 80;
     MarginRight  := 80;
end;


{***************************************************************************}
{                        ВЕРТИКАЛЬНАЯ   СЕТКА                               }
{***************************************************************************}

procedure GridDistX;
{ строит вертикальную сетку при заданном шаге dX }
{ исп Minf, MaxF}
var
   X: Real;
   Xr: Integer;
begin
  SetColor(Green);
  SetTextStyle(2, 0, 4);
  SetLineStyle(1, 0, NormWidth);
  X := dx*Trunc(XB/dX);
  if xb > 0 then X := X + dx;
  if (Round(dX*(GetMaxX - MarginLeft - MarginRight + 1)/(XE - XB)) >= TextWidth('000000000'))
      and (X < XE) then begin
      XR := MarginLeft + Round((X - XB)*
            (GetMaxX - MarginLeft - MarginRight + 1)/(xe - xb));
    while (xr>= MarginLeft) and (xr <= GetMaxX - MarginRight) do begin
      if Abs(X) < 1e-10 then
         begin
            SetColor(Magenta);
            SetLineStyle(0, 0, NormWidth);
         end
       else
         begin
           SetColor(Green);
           SetLineStyle(1, 0, NormWidth);
        end;

      Line(xr, MarginTop,  xr, GetMaxY - MarginBot);
      X := X + dX;
      XR := MarginLeft + Round((X - XB)*
      (GetMaxX - MarginLeft - MarginRight + 1)/(XE - XB));
    end;
  end;
  SetLineStyle(0, 0, NormWidth);
end;

procedure MakeNumDistX;
{ выводит числа на гор. сетку при заданном dX}
{ исп MinF, MaxF, dX}
var
   B: Integer;
   X, Y: Real;
begin
  UD := NDX;
  SetColor(Green);
  SetTextStyle(2, 0, 4);
  if  Round(dX*(GetMaxX - MarginLeft - MarginRight + 1)/(XE - XB))
         < TextWidth('000000000') then
        begin
          OutTextXY(GetMaxX div 2 - 50, GetMaxY - MarginBot + 2, 'Dense is too grid');
          Exit;
        end;

  X := dX*Trunc(XB/dX);
  if XB>0 then X := X + dX;
  while (X<=XE) do begin
    B :=  MarginLeft + Round((X - XB)*
        (GetMaxX - MarginLeft - MarginRight + 1)/(XE - XB));
    OutTextXY(B - TextWidth(Covert(X)) div 2,
              GetMaxY - MarginBot + 2, Covert(X));
    X := X + dX;
  end;
end;

{***************************************************************************}
{                        ГОРИЗОНТАЛЬНАЯ СЕТКА                               }
{***************************************************************************}

procedure GridDistY(Num: Byte);
{ строит горизонтальную сетку при заданном шаге dy }
{ исп Minf, MaxF}
var
   Y: Real;
   yr: Integer;
begin
  { горизонт. сетка}
  SetColor(Green);
  SetTextStyle(2,0,5);
  SetLineStyle(1, 0, NormWidth);
  Y := dy*Trunc(MinF[Num]/dy);
  if MinF[Num] > 0 then Y := Y + dy;
  if (Y < MaxF[Num]) and
     (Round(dY*(GetMaxY - MarginTop - MarginBot + 1)
           /(MaxF[Num] - MinF[Num])) >= TextHeight('0'))   then
       begin
         yr := GetMaxY - MarginBot - Round((Y - MinF[Num])*
               (GetMaxY - MarginTop - MarginBot + 1)/(MaxF[Num] - MinF[Num]));

        while (yr>= MarginTop) and (yr <= GetMaxY - MarginBot) do begin
              if Abs(Y) < 1e-10 then
                       begin
                         SetColor(Magenta);
                         SetLineStyle(0, 0, NormWidth);
                       end
                     else
                       begin
                         SetColor(Green);
                         SetLineStyle(1, 0, NormWidth);
                       end;

          Line(MarginLeft, yr, GetMaxX - MarginRight, Yr);
          Y := Y + dy;
          yr := GetMaxY - MarginBot - Round((Y - MinF[Num])*
               (GetMaxY - MarginTop - MarginBot + 1)/(MaxF[Num] - MinF[Num]));
       end;
      SetLineStyle(0, 0, NormWidth);
   end;
end;

procedure MakeNumDistY(Left: Byte);
{ выводит числа на гор. сетку при заданном dy}
{ исп MinF, MaxF, dy}
var
   B: Integer;
   X, Y: Real;
begin
  UD := NDY;
  SetTextStyle(2,0,5);
  Y := dy*Trunc(MinF[Left]/dy);
  if MinF[Left]>0 then Y := Y + dy;
  if  Round(dY*(GetMaxY - MarginTop - MarginBot + 1)/(MaxF[Left] - MinF[Left]))
       < TextHeight('0') then
       begin
          SetTextStyle(2,1,5);
          OutTextXY(MarginLeft - 20, GetMaxY div 2 - 50,'Dense is too grid');
          Exit;
       end;
  while (Y<=MaxF[Left]) do begin
    B := GetMaxY - MarginBot - Round((Y - MinF[Left])*
        (GetMaxY - MarginTop - MarginBot + 1)/(MaxF[Left] - MinF[Left]));
    SetColor(Color[Left]);
    OutTextXY(MarginLeft - 5 - TextWidth(Covert(Y)), B - TextHeight('1') div 2 -2, Covert(Y));
    Y := Y + dy;
  end;
end;

{***************************************************************************}
{                               ОСИ                                         }
{***************************************************************************}


procedure MakeAxes(Min, Max: Real);
var
   X0, Y0: Integer;
begin
  SetColor(Green);
  if (xb < 0) and (xe > 0)  then begin
    X0 := Round(MarginLeft - xb*(GetMaxX - MarginLeft - MarginRight + 1)/(xe -xb));
    Line(X0, MarginTop, X0, GetMaxY - MarginBot);
    Line(X0, MarginTop, X0 + 3, MarginTop + 3);
    Line(X0, MarginTop, X0  - 3, MarginTop + 3 );

   end;
  if (Min < 0) and (Max > 0) then begin
    Y0 := GetMaxY - MarginBot - Round(-Min*(GetMaxY - MarginTop - MarginBot + 1)/(Max - Min));
    Line(MarginLeft, Y0, GetMaxX - MarginRight, Y0);
    Line(GetMaxX - MarginRight, Y0, GetMaxX - MarginRight - 3 , Y0 + 3);
    Line(GetMaxX - MarginRight, Y0, GetMaxX - MarginRight - 3 , Y0 - 3);
   end;
end;


{***************************************************************************}
{                            ГРАФИКИ                                        }
{***************************************************************************}

procedure InitForeGround;
begin
  ClearViewPort;
  Input(0, 0, GetMaxX, GetMaxY);
{  SetFillStyle(1, White);
  Bar(0, 0, GetMaxX, GetMaxY);}
  SetColor(Blue);
  Rectangle(MarginLeft, MarginTop - 1, GetMaxX - MarginRight, GetMaxY - MarginBot);
end;

procedure DrawGraph(Num: Integer);
var
   i, yr: Integer;
   HasBegun: Boolean;
   X, F: Real;
   WideY, k: Real;
begin
  WideY := MaxF[Num] - MinF[Num];
  k := (GetMaxY - MarginTop - MarginBot + 1)/WideY;
  HasBegun := False;
  SetColor(Color[Num]);
  for  i := MarginLeft to GeTMaxX - MarginRight do begin
     X := xb + (xe - xb)/(GetMaxX - MarginLeft - MarginRight + 1)*
          (i - MarginLeft);
     GE := False;
     F := Func(Num, X);
     if not GE then begin
        yr := GetMaxY - MarginBot - Round((F - MinF[Num])*k);
        if not HasBegun then begin
                                Moveto(i, yr);
                                HasBegun := not HasBegun;
                             end
      else
        Lineto(i, yr);
      end { for }
    else
      HasBegun := False;
  end;

end;

procedure BuildOne(Num: Byte);
var
   WideY: Real; { размах функции }
   Step, X, Y: Real;
   i: Integer;
   k: Real;
   yr: Integer;
   F: Real;
   HasBegun: Boolean;
   s1, s2: String;
begin
  MarginOne;
  FindMinMax(Num, MinF[Num], MaxF[Num]);
  InitForeGround;
  WideY := MaxF[Num] - MinF[Num];
  k := (GetMaxY - MarginTop - MarginBot + 1)/WideY;
  SetColor(Color[Num]);
  SetLineStyle(0, 0, LinesStyle);
{  HasBegun := False;
  for  i := MarginLeft to GeTMaxX - MarginRight do begin
     X := xb + (xe - xb)/(GetMaxX - MarginLeft - MarginRight + 1)*
          (i - MarginLeft);
     GE := False;
     F := Func(Num, X);
     if not GE then begin
        yr := GetMaxY - MarginBot - Round((F - MinF[Num])*k);
        if not HasBegun then begin
                                Moveto(i, yr);
                                HasBegun := not HasBegun;
                             end
      else
        Lineto(i, yr);
      end
    else
      HasBegun := False;
  end;}
  DrawGraph(Num);
  SetLineStyle(0, 0, 1);
  if GrOO then begin
                GridDistY(Num);
                GridDistX;
                MakeNumDistY(Num);
                MakeNumDistX;
               end
             else
              MakeAxes(MinF[Num], MaxF[Num]);
  SetColor(Color[Num]);
  SetTextStyle(2, 0, 4);
  UD := 2;
  if Num = 1 then
     begin
     s1 := '  max[f(x)] = ';
     s2 := Covert(MaxF[1]);
     s1 := s1 + s2 + ' min[f(x)] =  ';
     s2 := Covert(MinF[1]);
     s1 := s1 + s2;
     OutTextXY(MarginLeft, MarginTop - 4 - TextHeight('A'), ConCat('f(x) = ', FuncStr[1], s1))
     end
   else
    begin
     s1 := '  max[g(x)] = ';
     s2 := Covert(MaxF[2]);
     s1 := s1 + s2 + ' min[g(x)] =  ';
     s2 := Covert(MinF[2]);
     s1 := s1 + s2;
     OutTextXY(MarginLeft, MarginTop - 4 - TextHeight('A'), ConCat('g(x) = ', FuncStr[2], s1));
    end;
  SetColor(Blue);
  Rectangle(MarginLeft, MarginTop - 1, GetMaxX - MarginRight, GetMaxY - MarginBot);
  if FindBent then Bent(Num);
end;

procedure BuildBoth(EqualSc: Boolean);
var
   TMinF, Wide, k: array[1..2] of Real;
   i, j: Integer;
   GlobMin, GlobMax, GlobWide, GlobK: Real;
   X: Real;
   yr: Integer;
   Hb: Boolean;
   F: Real;
begin
  MarginTwo;
  FindMinMax(1, MinF[1], MaxF[1]);
  FindMinMax(2, MinF[2], MaxF[2]);
  InitForeGround;
  if not EqualSc then
 { если в разных масштабах }
   for i := 1 to 2 do begin
     Wide[i] := MaxF[i] - MinF[i];
     k[i] := (GetMaxY - MarginTop - MarginBot + 1)/Wide[i];
     TMinF[i] := MinF[i];
   end
 else
   begin
   { если в одном масштабе }
    if MinF[1] < MinF[2] then GlobMin := MinF[1]
      else GlobMin := MinF[2];
    if MaxF[1] > MaxF[2] then GlobMax := MaxF[1]
      else GlobMax := MaxF[2];
    GlobWide := GlobMax - GlobMin;
    GlobK := (GetMaxY - MarginTop - MarginBot + 1)/GlobWide;
    K[1] := GlobK;
    K[2] := GlobK;
    TMinF[1] := GlobMin;
    TMinF[2] := GlobMin;
   end;

  for j := 1 to 2 do begin
  Hb := False;
  SetColor(Color[j]);
  for  i := MarginLeft to GeTMaxX - MarginRight do begin
           Ge := False;
           X := xb + (xe - xb)/(GetMaxX - MarginLeft - MarginRight + 1)*(i - MarginLeft);
           Func(j, X);
           if not Ge then begin
              yr := GetMaxY - MarginBot - Round((Func(j, X) - TMinF[j])*K[j]);
              if Hb then  Lineto(i, yr)
               else  begin
                        Moveto(i, yr);
                        Hb := True;
                     end;
           end { if }
         else
           Hb := False;
  end;
 end;
  SetColor(Blue);
  Rectangle(MarginLeft, MarginTop - 1, GetMaxX - MarginRight, GetMaxY - MarginBot);

  Grid(GlobMin, GlobMax, BothScale);
  MakeNumbers(GlobMin, GlobMax, BothScale);
  GridDistX;
  MakeNumDistX;
end;

{****************************************************************************}
procedure Wait;
var
   c: Char;
   Left, Right: Boolean;
   MouseX, MouseY: Integer;
   Clicked: Boolean;

begin
   Button(GetMaxX - MarginRight - Menus.Length, GetMaxY - 5 - Height, False, True, False,'Return to menu...');
   ShowMouse;
   Clicked := False;
   repeat
       Left := False;
       repeat
          GetMouse(MouseX, MouseY, Left, Right);
       until Left or Keypressed;

       if Left and (MouseX > GetMaxX - MarginRight - Menus.Length) and (MouseX < GetMaxX - 20) then
          if (GetMaxY - 5 > MouseY) and (GetMaxY - 5 - Height< MouseY) then
                     Clicked := True;
      if Keypressed then c := ReadKey;
      if (c = #13) or Clicked  then begin
                        HideMouse;
                        Button(GetMaxX - MarginRight - Menus.Length,
                               GetMaxY - 5 - Height, True,
                              True, False,'Return to menu...');
                        Delay(100);
                        Button(GetMaxX - MarginRight - Menus.Length,
                               GetMaxY - 5 - Height, True,
                              True, False,'Return to menu...');
                        ClearViewPort;
                        ShowMouse;
                        while Keypressed do c := ReadKey;
                        Exit;
                     end;
      c := ' ';
   until false;
end;

{****************************************************************************}
{                      НАХОЖДЕНИЕ ТОЧЕК ПЕРЕГИБА                             }
{****************************************************************************}

procedure Bent(Num: Integer);
const
     Share = 8;
     NN = 10;
var
   deX:   Extended;
   NdeX: Integer;
   X, teX:  Extended;
   LastK: Real;
   i: Integer;
   RTan, LTan:  Extended;
   Flag: Boolean;
   k: Real;
   yr, xr: Integer;
   WideY: Real;
   d2, h: Extended;
   fb: Boolean;
begin
   WideY := MaxF[Num] - MinF[Num];
   k := (GetMaxY - MarginTop - MarginBot + 1)/WideY;

  Fb := False;
  h := (Xb - XE)/1000;
  for  i := MarginLeft*NN to NN*(GeTMaxX - MarginRight) do begin
     X := xb + (xe - xb)/(GetMaxX - MarginLeft - MarginRight + 1)*
          (i/NN - MarginLeft);
     Ge := False;
     Func(Num, X);
     Func(Num, X + h);
     Func(Num, X - h);
     if Ge then begin
                  Fb := False;
                  Continue;
                end;
     if not Fb then
       begin
          d2 :=  (Func(Num, X + h) + Func(Num, X - h) - 2*Func(Num, X));
          if Abs(d2) < 1e-7 then d2 := 0;
          if d2 <= 0 then  Flag := True
            else Flag := False;
           fb := True;
       end
     else
       begin
          d2 :=  (Func(Num, X + h) + Func(Num, X - h) - 2*Func(Num, X));
          if Abs(d2) < 1e-7 then d2 := 0;
          if ((d2 > 0) and Flag) or ((d2 <= 0) and not Flag) then
             begin
                yr := GetMaxY - MarginBot - Round((Func(Num, X) - MinF[Num])*k);
                SetColor(Magenta);
                Circle(Round(i/NN), yr, 5);
             end;
          if d2 <= 0 then Flag := True
             else Flag := False;
       end;
  end;
end;

{****************************************************************************}


{****************************************************************************}
{                  ЗАДАНИЕ    ФУНКЦИЙ                                        }
{****************************************************************************}

procedure DefineFuncs;
var
   S: string;
   i: Integer;
begin
   tFuncStr[1] := FuncStr[1];
   tFuncStr[2] := FuncStr[2];
   repeat
     FunMenu(tFuncStr[1], tFuncStr[2]);
     case FRet of
       0: tFuncStr[1] :=
            GetString(GetMaxX div 2 - 200 + 3, 196, 45, tFuncStr[1], 0);
       1: tFuncStr[2] :=
            GetString(GetMaxX div 2 - 200 + 3, 236, 45, tFuncStr[2], 0);
     end;
   until FRet in [2,3];
   if FRet = 2 then
      begin
        for i := 1 to 2 do begin
          FuncStr[i] := tFuncStr[i];
          if FuncStr[i] <> '' then
              Load(FuncStr[i], i)
         else
          Loaded[i] := False;
        end;
      end;
   ShowMouse;
end;

{****************************************************************************}

procedure Options;
var
   _SXb, _SXe, _SdX, _SdY, _SnY: string;
   _Net, _Bs, _Mb: Boolean;
   tXB, tXE, tdX, tdY: Real;
   tnY: Integer;

    function GetWellString(x, y: Integer; var s: string): Real;
    var
      Code: Integer;
      rs: string;
      R: Real;
    begin
      Code := 0;
      repeat
        s := GetString(x, y, 20, s, 1);
        Val(s, R, Code);
      until Code = 0;
      GetWellString := R;
    end;

begin
  _SXb := SXB;
  _SXe := SXE;
  _SdX := SdX;
  _SdY := SdY;
  _SnY := SnY;
  _Net := Groo;
  _Bs := BothScale;
  _Mb := FindBent;
  tXB := XB;
  tXE := XE;
  tdX := dX;
  tdY := dY;
  tnY := nY;
  ORet := 8;
  repeat
    OptMenu(_SXb, _SXe, _SdX, _SdY, _SnY, _Net, _Bs, _Mb);
    case ORet of
      0:  tXB := GetWellString(GetMaxX div 2 - 230 + 3, 106, _SXB);
      1:  tXE := GetWellString(GetMaxX div 2 + 45 + 3, 106, _SXE);
      2: _Net := not _Net;
      3:  tdX := GetWellString(GetMaxX div 2 - 40 + 3, 166, _SdX);
      4:  tdY := GetWellString(GetMaxX div 2 - 40 + 3, 191, _SdY);
      5:  tnY := Round(GetWellString(GetMaxX div 2 - 40 + 3, 216, _SnY));
      6: _Bs := not _Bs;
      7: _MB := not _MB;
    end;
  until ORet in [8, 9];
  if ORet = 8 then begin
    SXB := _SXb;
    SXE := _SXe;
    SdX := _SdX;
    SdY := _SdY;
    SnY := _SnY;
    Groo := _Net;
    BothScale := _Bs;
    FindBent := _Mb;
    XB:= tXB;
    XE := tXE;
    dX := tdX;
    NDX := CountAPoint(SdX);
    dY := tdY;
    NDY := CountAPoint(SdY);
    nY := tnY;
  end;
  ShowMouse;
end;

{****************************************************************************}


begin
  Gd := Vga;
  Gm := VgaHI;
  InitGraph(Gd, Gm, 'c:\tp' );
  GErr := GraphResult;
  if Gerr <> 0 then begin
     Writeln(GraphErrorMsg(GErr));
     Halt(GErr);
    end;

  xb := -3;
  SXB := '-3';

  XE := 3;
  SXE := '3';

  Nx := 4; { сетка }
  Ny := 7;
  SNY := '7';

  dy := 0.1;
  SdY := '0.1';

  dX := 1;
  SdX := '1';

  Groo :=  True;
  BothScale := True;
  FindBent := False;
  FuncStr[1] := '';
  FuncStr[2] := '';

  NDX := 0;
  NDY := 1;

  LinesStyle := NormWidth;

  InitMouse;
  ShowMouse;
  repeat
    Menu;
    HideMouse;
    case Ret of
      mnDefFuncs: begin
                     DefineFuncs;
                  end;
      mnDraw1: begin
                 if not Loaded[1] then begin
                   ClearViewPort;
                   ErrorMessage('Function f(x) is not defined');
                 end
               else
                 begin
                   BuildOne(1);
                   Wait;
                 end;
               end;
      mnDraw2: begin
                 if not Loaded[2] then begin
                   ClearViewPort;
                   ErrorMessage('Function g(x) is not defined');
                 end
               else
                 begin
                   BuildOne(2);
                   Wait;
                 end;
               end;
      mnDrawB: begin
                 if not Loaded[1] or not Loaded[2] then begin
                   ClearViewPort;
                   ErrorMessage('Function g(x) or f(x) is not defined');
                 end
               else
                 begin
                   BuildBoth(BothScale);
                   Wait;
                 end;
               end;
      mnOptions: begin
                   Options;
                 end;
     end;
  until Ret = mnExit;
  CloseGraph;
  Writeln('@1999 Horror Software... LeTint19');
end.
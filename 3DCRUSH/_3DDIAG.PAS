unit _3DDiag;

interface
uses Graph;
{ Suturday 10 Apr. 1999. In Pascal We Trust }
{ We are waiting for bugs, bugs are not waiting for us }
{ Let p. it }
type
    TCake = record
      BAngle: Word;
      EAngle: Word;
      Color: Word;
      Out: Boolean;
      Proc: Real;
     end;

const
     ColorTable: array [1..14] of Byte =
     (Green,
      Cyan,
      Red,
      Magenta,
      Brown,
      DarkGray,
      LightBlue,
      LightGreen,
      LightCyan,
      LightRed,
      LightMagenta,
      Yellow,
      White,
      LightGray);
var
    Cake: array [1..20] of TCake;
    N: Word;

procedure CakeMenager;
procedure SetArcXY;
procedure VisualizeNumbers;

implementation
type
    TFace = record
      Angle: Word;
      Color: Byte;
      Out: Boolean;
      Fi: Integer;
     end;
type
    TBorder = record
      BAngle: Word;
      EAngle: Word;
      Color: Word;
      Out: Boolean;
      Drawn: Boolean;
      Left: Boolean;
      Right: Boolean;
      Fi: Integer;
     end;

const
     EllipseXR = 100;
     EllipseYR = 70;
     Height = 20;
     FaceEdgeColor = Yellow;
     OutDistance: Real = 0.3;
     OutNumDistance: Real = 1.5;

var
    Borders: array [1..20] of TBorder;
    NumFaces: Word;
    NumBorders: Word;
    ArcXY: array [0..360] of PointType;
    Xc, Yc: Integer;
    i: Integer;
    Faces: array [1..20] of TFace;

procedure SetCenter;
{ Установка центра }
begin
   Yc := GetMaxY div 2;
   Xc := GetMaxX div 2 + 100;
end;

procedure SetArcXY;
var
   ArcCoords: ArcCoordsType;
   i: Word;
begin
  SetColor(Black);
  for i := 0 to 360 do begin
    Ellipse(XC, YC, i, i + 1, EllipseXR, EllipseYR);
    GetArcCoords(ArcCoords);
    with ArcCoords do begin
      ArcXY[i].X := XStart - X;
      ArcXY[i].Y := YStart - Y;
    end;
  end;
end;

{****************************************************************************}
{****************************************************************************}

procedure DrawBorder(Item: TBorder);
var
   j:  Word;
{   _Fi: Integer;}
begin
  SetCenter;
  if Item.Out then  begin
      XC := XC + Round(OutDistance*EllipseXR*cos(Item.FI/180*PI));
      YC := YC - Round(OutDistance*EllipseYR*sin(Item.FI/180*PI));
    end;

  SetColor( Item.Color);
  for j := 0  to Height do
    Ellipse(XC, YC - j, Item.BAngle, Item.EAngle, EllipseXR, EllipseYR);
        SetColor(FaceEdgeColor);
        Ellipse(XC, YC,  Item.BAngle, Item.EAngle, EllipseXR, EllipseYR);
        Ellipse(XC, YC - Height,  Item.BAngle, Item.EAngle, EllipseXR, EllipseYR);

        if (Item.BAngle <> 180) and ( Item.BAngle <> 360) or Item.Left then
          Line(XC + ArcXY[Item.BAngle].X, YC + ArcXY[Item.BAngle].Y,
               XC + ArcXY[Item.BAngle].X, YC + ArcXY[Item.BAngle].Y - Height);

        if (Item.EAngle <> 180) and (Item.EAngle <> 360) or Item.Right  then
          Line(XC + ArcXY[Item.EAngle].X, YC + ArcXY[Item.EAngle].Y,
               XC + ArcXY[Item.EAngle].X, YC + ArcXY[Item.EAngle].Y - Height);
end;

{****************************************************************************}
{****************************************************************************}

procedure DrawFacesAndBorders;
var
   i, j: Word;
   Min, Max, Which: Integer;
   Predec: Integer;
   Order: array [1..20] of Word;
   Find: Boolean;
begin
  { ZZZZZ-Buffer }
  i := 0;
  Predec := 90;
  repeat
    Find := False;
    Min := 270;
    for j := 1 to NumFaces do begin
         if  (Faces[j].Angle < Min) and (Faces[j].Angle > Predec) then
         begin
            Find := True;
            Which := j;
            Min := Faces[j].Angle;
         end;
    end;
    if Find then begin
       Inc(i);
       Order[i] := Which;
       Predec := Faces[Which].Angle;
    end;
  until not Find;

  Predec := 181;
  repeat
    Find := False;
    Max := -1;
    for j := 1 to NumFaces do begin
         if  ((Faces[j].Angle  + 90) mod 360 > Max) and ((Faces[j].Angle  + 90) mod 360 < Predec) then
         begin
            Find := True;
            Which := j;
            Max := (Faces[j].Angle  + 90) mod 360;
         end;
    end;
    if Find then begin
       Inc(i);
       Order[i] := Which;
       Predec := (Faces[Which].Angle + 90) mod 360;
    end;

  until not Find;
  for i := 1 to NumFaces do begin
    { Надо бы нарисовать бордюры, которые будут закрыты...}
    { А не хочется . Ушел есть макароны }
    { Z - Buffer . Yee  Чаво ?     }
    if (Faces[Order[i]].Angle >= 180) and (Faces[Order[i]].Angle <= 270) then
    begin
      for j := 1 to NumBorders do
        if (Borders[j].EAngle <= Faces[Order[i]].Angle ) and (not Borders[j].Drawn) then
        begin
          DrawBorder(Borders[j]);
          Borders[j].Drawn := True;
          Break;
        end;
    end;

    if (Faces[Order[i]].Angle > 270) and (Faces[Order[i]].Angle < 360) then
    begin
      for j := 1 to NumBorders do
        if (Borders[j].BAngle >= Faces[Order[i]].Angle ) and (not Borders[j].Drawn) then
        begin
          DrawBorder(Borders[j]);
          Borders[j].Drawn := True;
          Break;
        end;
    end;

    { Рисуем фейсы }
    SetColor(Faces[Order[i]].Color);
    SetCenter;
    if Faces[Order[i]].Out then
    begin
      Yc := YC - Round(OutDistance*EllipseYR*sin(Faces[Order[i]].FI/180*PI));
      Xc := XC + Round(OutDistance*EllipseXR*cos(Faces[Order[i]].FI/180*PI));
    end;
    for j := 0 to Height do begin
      Moveto(XC, YC - j);
      LineRel(ArcXY[Faces[Order[i]].Angle].X, ArcXY[Faces[Order[i]].Angle].Y);
    end;
    SetColor(FaceEdgeColor);
    Moveto(XC, YC);
    LineRel(0, - Height);
    LineRel(ArcXY[Faces[Order[i]].Angle].X, ArcXY[Faces[Order[i]].Angle].Y);
    LineRel(0,  Height);
    LineRel( - ArcXY[Faces[Order[i]].Angle].X,
             - ArcXY[Faces[Order[i]].Angle].Y);
  end;

  { Никто не забыт, ни что не забито }
  for i := 1 to NumBorders do
    if not Borders[i].Drawn then DrawBorder(Borders[i]);
end;

{****************************************************************************}
{****************************************************************************}

procedure CakeMenager;
var
   i, j: Integer;
   FI: Real;
   B, E, _Fi: Word;
   D : Boolean;
begin
  { Рисуем бока кусочков }
  NumFaces := 0;
  SetCenter;
  for i := 1 to N do begin
    if ((Cake[i].BAngle > 270) and (Cake[i].BAngle <= 360)) or
       ((Cake[i].BAngle >= 0) and (Cake[i].BAngle < 90)) then
     begin
       Inc(NumFaces);
       Faces[NumFaces].Angle := Cake[i].BAngle;
       Faces[NumFaces].Color := Cake[i].Color;
       if Cake[i].Out then
       begin
         Faces[NumFaces].Out := True;
         if Cake[i].BAngle > Cake[i].EAngle then _Fi := 360
           else _Fi := 0;
         Faces[NumFaces].Fi := (_Fi + Cake[i].BAngle + Cake[i].EAngle) div 2;
       end
     else Faces[NumFaces].Out := False;
     end;

    if (Cake[i].EAngle > 90) and (Cake[i].EAngle < 270) then
     begin
       Inc(NumFaces);
       Faces[NumFaces].Angle := Cake[i].EAngle;
       Faces[NumFaces].Color := Cake[i].Color;
       if Cake[i].Out then
       begin
         Faces[NumFaces].Out := True;
         if Cake[i].BAngle > Cake[i].EAngle then _Fi := 360
           else _Fi := 0;
         Faces[NumFaces].Fi := (_Fi + Cake[i].BAngle + Cake[i].EAngle) div 2;
       end
     else Faces[NumFaces].Out := False;
   end;
  end; { for }

  { Находим бока кусков}
  NumBorders := 0;
  for  i := 1 to N do begin
    B :=  Cake[i].BAngle;
    E :=  Cake[i].EAngle;
    D := False;
    if (B <= 180) and (E >= 180) and (E < 360) then
    begin
      B := 180;
      D := True;
    end
  else
    if (B <= 180) and (E >= 0) and (E < B) then
    begin
      B := 180;
      E := 360;
      D := True;
    end
   else
    if (B > 180) and (E < 360) and (B < E) then
    begin
      D := True;
    end
   else
   if (B > 180) and (E < 180) and (B > E) then
    begin
      D := True;
      E := 360;
    end
   else
    if (B > 180) and (E >= 180) and (B > E) then
    begin
       Inc(NumBorders);
       with Borders[NumBorders] do begin
         BAngle := 180;
         EAngle := E;
         Color := Cake[i].Color;
         Out := Cake[i].Out;
         Drawn := False;
         if Cake[i].BAngle = 180 then Left := True
           else Left := not True;
         if Cake[i].EAngle = 360 then Right := True
           else Right := not True;
         if Cake[i].Out then
         begin
           if Cake[i].BAngle > Cake[i].EAngle then Fi := 360
             else Fi := 0;
           Fi := (Fi + Cake[i].BAngle + Cake[i].EAngle) div 2;

         end;
       end;

       Inc(NumBorders);
       with Borders[NumBorders] do begin
         BAngle := B;
         EAngle := 360;
         Color := Cake[i].Color;
         Out := Cake[i].Out;
         Drawn := False;
         if B = 180 then Left := True
           else Left := not True;
         if E = 360 then Right := True
           else Right := not True;
         if Cake[i].Out then
         begin
           if Cake[i].BAngle > Cake[i].EAngle then Fi := 360
             else Fi := 0;
           Fi := (Fi + Cake[i].BAngle + Cake[i].EAngle) div 2;
         end;
       end;
    end;

    if D then begin
       Inc(NumBorders);
       with Borders[NumBorders] do begin
         BAngle := B;
         EAngle := E;
         Color := Cake[i].Color;
         Out := Cake[i].Out;
         Drawn := False;
         if B = 180 then Left := True
           else Left := not True;
         if E = 360 then Right := True
           else Right := not True;
         if Cake[i].Out then
         begin
           if Cake[i].BAngle > Cake[i].EAngle then Fi := 360
             else Fi := 0;
           Fi := (Fi + Cake[i].BAngle + Cake[i].EAngle) div 2;
         end;
       end;
    end;
  end;
  { Нашли бока ...}

  { Try to нарисовать бока с краями ...};
  DrawFacesAndBorders;

  { Намалюем крышки }
  for  i := 1 to N do begin
    SetCenter;
    if Cake[i].Out then  begin
      if Cake[i].BAngle > Cake[i].EAngle then _Fi := 360
         else _Fi := 0;
      _Fi := (_Fi + Cake[i].BAngle + Cake[i].EAngle) div 2;
      XC := XC + Round(OutDistance*EllipseXR*cos(_FI/180*PI));
      YC := YC - Round(OutDistance*EllipseYR*sin(_FI/180*PI));
    end;

    SetColor(Blue);
    Moveto(XC, YC - Height);
    LineRel(ArcXY[Cake[i].BAngle].X, ArcXY[Cake[i].BAngle].Y);
    Moveto(XC, YC - Height);
    LineRel(ArcXY[Cake[i].EAngle].X, ArcXY[Cake[i].EAngle].Y);
    Ellipse(XC, YC - Height, Cake[i].BAngle, Cake[i].EAngle, EllipseXR, EllipseYR);
    SetFillStyle(1, Cake[i].Color);

    if Cake[i].BAngle > Cake[i].EAngle then Fi := 360
      else Fi := 0;
    Fi := (Fi + Cake[i].BAngle + Cake[i].EAngle) / 2;
    FloodFill(XC + Round(EllipseXR*cos(FI/180*PI)/2),
              YC - Round(EllipseYR*sin(FI/180*PI)/2) - Height, Blue);

    SetColor(FaceEdgeColor);
    Moveto(XC, YC - Height);
    LineRel(ArcXY[Cake[i].BAngle].X, ArcXY[Cake[i].BAngle].Y);
    Moveto(XC, YC - Height);
    LineRel(ArcXY[Cake[i].EAngle].X, ArcXY[Cake[i].EAngle].Y);
    Ellipse(XC, YC - Height, Cake[i].BAngle, Cake[i].EAngle, EllipseXR, EllipseYR);


    end;
end;

{****************************************************************************}
{****************************************************************************}

procedure VisualizeNumbers;
var
   i: Integer;
   FI: Integer;
   X, Y, DX, DY: Integer;
   S: string[7];
   AddX, AddY: Integer;
   k: Real;
begin
  SetCenter;
  for i := 1 to N do begin
    if Cake[i].BAngle > Cake[i].EAngle then Fi := 360
       else Fi := 0;
    Fi := (Fi + Cake[i].BAngle + Cake[i].EAngle) div 2;
    if Cake[i].Out then
    begin
       AddX := Round(EllipseXR*OUtDistance/1.4);
       AddY := Round(EllipseYR*OUtDistance/1.4);
    end
  else
    begin
       AddX := 0;
       AddY := 0;
    end;
    if (Fi > 180) and (Fi < 360) then
    begin
      k := 1-0.1*sin(FI/180*PI);
      X := XC + Round((EllipseXR*k + AddX)*OutNumDistance*cos(FI/180*PI));
      Y := YC - Round((EllipseYR*k + AddY)*OutNumDistance*sin(FI/180*PI)) - Height div 1;
      DY := Round((EllipseYR*k + AddY div 2)*OutNumDistance*sin(FI/180*PI)) div 2;
      DX := -Round((EllipseXR*k + AddX div 2)*OutNumDistance*cos(FI/180*PI)) div 2;
    end
   else
    begin
      X := XC + Round((EllipseXR + AddX)*OutNumDistance*cos(FI/180*PI));
      Y := YC - Round((EllipseYR + AddY)*OutNumDistance*sin(FI/180*PI)) - Height div 1;
      DY := Round((EllipseYR + AddY div 2)*OutNumDistance*sin(FI/180*PI)) div 2;
      DX := -Round((EllipseXR + AddX div 2)*OutNumDistance*cos(FI/180*PI)) div 2;
    end;
    SetColor(Yellow);
    Moveto(X + DX, Y + DY);
    LineRel(-Round(DX*0.65), -Round(DY*0.65));
    Circle(X + DX, Y + DY, 1);
    Str(Cake[i].Proc:4:2, S);
    S := S + '%';
    SetTextStyle(2, 0, 4);
    SetColor(Blue);
    SetfillStyle(1, Yellow);
    Bar(X - TextWidth(S) div 2 - 5, Y - 1 - TextHeight(S) div 2,
        X + TextWidth(S) div 2 + 3, Y + TextHeight(S) div 2 + 4);
    Rectangle(X - TextWidth(S) div 2 - 5, Y - 1 - TextHeight(S) div 2,
        X + TextWidth(S) div 2 + 3, Y + TextHeight(S) div 2 + 4);

    OutTextXY(X - TextWidth(S) div 2, Y - TextHeight(S) div 2, S);
  end;
end;
end.
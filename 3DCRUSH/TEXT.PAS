program ArbitraryTexture;
uses Graph;
const
     TLen = 30;
     TWid = 10;
type
    Quadrogon = array [1..4] of PointType;
    LineWay = record
      AB: PointType;
     end;
var
   Gd, Gm: Integer;
   Q: Quadrogon;
   V1: array [0..1000] of PointType;
   V2: array [0..1000] of PointType;
   Num1, Num2, ind, i, k: Word;
   l1, l2, Rind: Real;
   TextY, TextX: Integer;
   Len, CLen: Integer;

var
    deltax, deltay, numpixels,
    d, dinc1, dinc2,
    x, xinc1, xinc2,
    y, yinc1, yinc2 : integer;

const
    Texture: array[0..TWid,0..TLen] of Word =
    ((3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,3),
     (3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,3),
     (3,3,3,7,7,3,3,7,7,3,3,3,7,3,3,3,7,7,3,3,7,3,3,3,3,3,3,3,3,1,3),
     (3,3,3,7,7,3,3,7,7,3,3,7,3,7,7,3,3,7,7,7,7,3,3,3,3,3,3,3,3,1,3),
     (3,3,3,7,7,7,7,7,7,3,7,7,3,7,7,3,3,3,7,3,3,3,3,3,3,3,3,3,3,1,3),
     (3,3,3,7,7,7,3,7,7,3,7,7,7,7,7,3,3,7,7,7,7,3,3,3,3,3,3,3,3,1,3),
     (3,3,3,7,7,3,3,7,7,3,7,7,3,7,7,3,7,7,3,3,7,3,3,3,3,3,3,3,3,1,3),
     (3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,3),
     (3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,3),
     (3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3),
     (3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3));

procedure LinePut(x1, y1, x2, y2 : integer; var V: array of PointType; var Num: Word);
var
    i, deltax, deltay, numpixels,
    d, dinc1, dinc2,
    x, xinc1, xinc2,
    y, yinc1, yinc2 : integer;
begin
  Num := 0;
  deltax := abs(x2 - x1);
  deltay := abs(y2 - y1);
  if deltax >= deltay then
    begin
      numpixels := deltax + 1;
      d := (2 * deltay) - deltax;
      dinc1 := deltay Shl 1;
      dinc2 := (deltay - deltax) shl 1;
      xinc1 := 1;
      xinc2 := 1;
      yinc1 := 0;
      yinc2 := 1;
    end
  else
    begin
      numpixels := deltay + 1;
      d := (2 * deltax) - deltay;
      dinc1 := deltax Shl 1;
      dinc2 := (deltax - deltay) shl 1;
      xinc1 := 0;
      xinc2 := 1;
      yinc1 := 1;
      yinc2 := 1;
    end;
  if x1 > x2 then
    begin
      xinc1 := - xinc1;
      xinc2 := - xinc2;
    end;
  if y1 > y2 then
    begin
      yinc1 := - yinc1;
      yinc2 := - yinc2;
    end;
  x := x1;
  y := y1;
  for i := 0 to numpixels - 1 do
    begin
      V[i].X := X;
      V[i].Y := Y;
      INC(Num);
      if d < 0 then
        begin
          d := d + dinc1;
          x := x + xinc1;
          y := y + yinc1;
        end
      else
        begin
          d := d + dinc2;
          x := x + xinc2;
          y := y + yinc2;
        end;
    end;
end;


begin
    Gd := EGA;
    Gm := EGAlo;
    InitGraph(Gd, Gm, 'c:\tp');
    if GraphResult <> 0 then Halt(1);
    Q[1].X := 100;
    Q[1].Y := 100;

    Q[2].X := 100;
    Q[2].Y := 180;

    Q[3].X := 150;
    Q[3].Y := 160;

    Q[4].X := 160;
    Q[4].Y := 130;

    l1 := sqr(0.0 + Q[1].X - Q[2].X) +  sqr(0.0 + Q[1].Y - Q[2].Y);
    l2 := sqr(0.0 + Q[3].X - Q[4].X) +  sqr(0.0 + Q[3].Y - Q[4].Y);
    if l1 >= l2 then begin
      LinePut(Q[1].X, Q[1].Y, Q[2].X, Q[2].Y, V1, Num1);
      LinePut(Q[4].X, Q[4].Y, Q[3].X, Q[3].Y, V2, Num2);
     end
    else
      begin
       LinePut(Q[1].X, Q[1].Y, Q[2].X, Q[2].Y, V2, Num2);
       LinePut(Q[4].X, Q[4].Y, Q[3].X, Q[3].Y, V1, Num1);
      end;
    DEC(Num1);
    DEC(Num2);
    for  k := 0 to Num1  do begin
      ind := Round(Num2/Num1*k);
      BEGIN
      deltax := abs(V2[ind].X - V1[k].X);
      deltay := abs(V2[ind].Y - V1[k].Y);
      CLen := 0;
      if deltax >= deltay then
      begin
           numpixels := deltax + 1;
           d := (2 * deltay) - deltax;
           dinc1 := deltay Shl 1;
           dinc2 := (deltay - deltax) shl 1;
           xinc1 := 1;
           xinc2 := 1;
           yinc1 := 0;
           yinc2 := 1;
      end
   else
    begin
      numpixels := deltay + 1;
      d := (2 * deltax) - deltay;
      dinc1 := deltax Shl 1;
      dinc2 := (deltax - deltay) shl 1;
      xinc1 := 0;
      xinc2 := 1;
      yinc1 := 1;
      yinc2 := 1;
    end;
  if V1[k].X > V2[ind].X then
    begin
      xinc1 := - xinc1;
      xinc2 := - xinc2;
    end;
  if V1[k].Y > V2[ind].Y then
    begin
      yinc1 := - yinc1;
      yinc2 := - yinc2;
    end;
  x := V1[k].X;
  y := V1[k].Y;
  TextY := Round(TWid/Num1*k);
  for i := 0 to numpixels - 1 do
    begin
     PutPixel(X, Y, Texture[TextY, Trunc(TLen/(numpixels - 1)*i)]);
      if d < 0 then
        begin
          d := d + dinc1;
          x := x + xinc1;
          y := y + yinc1;
        end
      else
        begin
          d := d + dinc2;
          x := x + xinc2;
          y := y + yinc2;
        end;
    end;

      END;
    end;
    setColor(White);
    MOveto(Q[1].X, Q[1].Y);
    Lineto(Q[2].X, Q[2].Y);
    Lineto(Q[3].X, Q[3].Y);
    Lineto(Q[4].X, Q[4].Y);
    Lineto(Q[1].X, Q[1].Y);
    Readln;
    CloseGraph;
end.
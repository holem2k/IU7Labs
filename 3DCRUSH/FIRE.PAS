uses Graph;
const
     X = 20;
     Y = 20;
var
   A: Array[1..Y, 1..X] of Real;
   Gd, Gm: integer;
   i, j : Integer;

function Color(N: Byte): Byte;
begin
  case N of
   0..20  : Color := Red;
   80..160: Color := Yellow;
   80..255: Color := White;
  end;
end;







procedure ProduceFire;
begin
  for i :=  Y - 1 downto 2 do
    for j := 2 to X - 1 do
     A[i][j] := (A[i - 1][j - 1] + A[i - 1][j] + A[i - 1][j + 1] +
                 A[i][j - 1] +                   A[i][j + 1] +
                 A[i + 1][j + 1] + A[i + 1][j + 1] + A[i + 1][j + 1]) / 8;
end;






procedure Fire(XC, YC: Integer);
var
   i, j: integer;
begin
  for i := 1 to Y do
    for j := 1 to X do
      PutPixel(XC + j, YC + Y - i, Color(Round(A[i][j])));
end;

begin
   Gd := Vga;
   Gm := Vgalo;
   InitGraph(Gd, Gm, 'C:\tp');
   if Graphresult <> 0 then Halt(1);
   for Gd := 1 to X do
    A[1][Gd] := 255;

   for Gd := 1 to 16 do
     SetRGBPalette(Gd, 20 + Gd, 0, 0);
   repeat
     ProduceFire;
     Fire(GetMaxX div 2, GetMaxY div 2);
     for i := 1 to X do begin
      a[1][i] := 100 + Random(60);
      a[2][i] := 10 + Random(60);
    end;
   until False;
   CloseGraph;
end.
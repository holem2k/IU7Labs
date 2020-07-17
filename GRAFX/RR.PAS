uses Graph;
const
     MX = 8;
     MY: Integer = 13;
var
   Gd, Gm, i, j: Integer;
   _A, k,  t: Real;
   Next: Integer;
   Col: Integer;
begin
   Gd := Vga;
   Gm := Vgalo;
   InitGraph(Gd, Gm, 'c:\tp');
   if GraphResult <> 0 then Halt(1);
   Writeln(MaxColors);
   Readln;
{   for i := 1 to 15 do
     SetRGBPalette(i, 0, 0, 0);}
   t := 0;
   k := 3;
   Next := 2;
   repeat
   SetActivePage(Next);
   for i := 1 to MY + 5 do
    for j := -MX to MX do begin
      _A := j*j/k/k + i;
      Col := Round(_A*14/(MX*MX/K/K/MY + MY));
      if Col <= 14 then
                 begin
                   SetColor(16 + Col);
                   Line(j + GetMaxX div 2, -i + GetMaxY div 2,j + GetMaxX div 2, -i + GetMaxY div 2);
                 end;
{         PutPixel(j + GetMaxX div 2, -i + GetMaxY div 2, 1 + Col)}
    end;
    if Random(2) = 0 then begin if k = 2 then k := 3 else k := 2; end;
    if MY = 15 then MY := 10 else MY := 15;
    SetVisualPage(Next);
    Next := (Next + 1) mod 2;
   until False;
   Readln;
   CloseGraph;
end.
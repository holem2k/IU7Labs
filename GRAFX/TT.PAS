uses Graph;
const
     w: Real = 2*PI;
     v = 100;
     A = 7;
var
   Gd, Gm, i, j: Integer;
   _A, k, t: Real;
   Next: Integer;
begin
   Gd := Ega;
   Gm := Egalo;
   InitGraph(Gd, Gm, 'c:\tp');
   if GraphResult <> 0 then Halt(1);
   k := W/V;
   for i := 1 to 15 do
     SetRGBPalette(i, 10 + i*2, 0, 0);
   t := 0;
   Next := 1;
   repeat
   SetActivePage(Next);
   for i := 1 to 50 do
    for j := 1 to 50 do begin
      _A := A*cos(K*(j - i))*cos(w*t - K*(i + j)/2);
      if _A > 0 then
         PutPixel(i, j, 7 - Round(_A))
      else
         PutPixel(i, j, 7 + Round(_A));
    end;
    t := t + 0.1;
    SetVisualPage(Next);
    Next := (Next + 1) mod 2;
   until False;
   Readln;
   CloseGraph;

end.
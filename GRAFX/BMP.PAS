uses bitmap, graph;
var
   a: tbitmap;
   s: byte;
   d,g: integer;
begin
 g := ega;
 d:=     egalo;
  initgraph(g,d,'c:\tp');
  a.LoadfromFile('balls.bmp',s);

{  a.adjustpalette;}
  a.draw(100,100);
  readln;
  a.adjustpalette;
  readln;
end.
program g;
uses Crt, Graph;
var i,j,k,l,Gd, Gm: Integer;
x,y:real;
begin
 clrscr;
 Gd := Detect;
 InitGraph(Gd, Gm, 'c:\tp ');
 if GraphResult <> grOk then
 Halt(1);
 x:=0;
 begin
    repeat
    x:=x+0.05;
    y:=cos(x);
    putpixel(trunc(x)+1,trunc(y)+50,white);
    until x<=20;
end;
readln;
end.
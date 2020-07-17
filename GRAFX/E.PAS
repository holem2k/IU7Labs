uses Graph, Menus, Mouse, TInput;
var
   Gd, Gm: Integer;
   s: string;
begin
     Gd := Vga; Gm := VgaHi;
     InitGraph(Gd,Gm, 'c:\tp');
     SetBkColor(red);
     s := GetString(100,100,15,'Maxxxx',1);
     Readln;
     CloseGraph;
     Writeln(s);
end.
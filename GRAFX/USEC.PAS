uses CalcBp;
var
   i: integer;
begin
 Load('3/X*3*X+3', 1);
 Writeln('-----------------');
 for i := 1 to 10 do
  begin
    Writeln(FuncX(1, i):20:4);
    if errc<> 0 then Writeln(ErrMsg(Errc));
   end;
 Done;

end.
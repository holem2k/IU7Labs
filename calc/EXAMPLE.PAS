uses Calcbp;
begin
  Load('X+2',1);
  Load('X*X+2',2);
  Writeln(FuncX(1, 3.0):10:2);
  Writeln(FuncX(2, 3.0):10:2);
end.
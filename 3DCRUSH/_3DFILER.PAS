unit _3DFiler;
interface
type
    TData = record
      Name: String[20];
      Number: Longint;
      Proc: Real;
      VisualProc: Real;
      Color: Word;
      WasCalced: Boolean;
    end;

var
   Threshold: Real;
   VisualProcThreshold: Real;

procedure LoadFromFile(DataFile: string;
                       var Dest: array of TData;
                       var Num: Word);
procedure MakeCalc(var Dest: array of TData;
                   N: Word);

implementation
procedure LoadFromFile(DataFile: string;
                       var Dest: array of TData;
                       var Num: Word);
var
   F: Text;
   s: string;
   i: Integer;
begin
  {$I-}
  Assign(F, DataFile);
  Reset(F);
  {$I+}
  if IOResult <> 0 then begin
     Writeln('Ошибка чтения файла');
     Halt(1);
  end;
  Readln(F,   Threshold);
  Num := 0;
  While not SeekEof(F) do begin
    Read(F, s);
    i := Pos(' ', s);
    Dest[Num].Name := Copy(S, 1, i - 1);
    Delete(S, 1, i - 1);
    Val(s, Dest[Num].Number, i);
    INC(Num);
  end;
  Close(F);
end;

procedure MakeCalc(var Dest: array of TData;
                   N: Word);
var
   i: Integer;
   Sum: Longint;
   SumProc: Real;
begin
   Sum := 0;
   for  i := 0 to  N - 1 do
     Sum := Sum + Dest[i].Number;
   SumProc := 0;
   for i := 0 to N - 2 do begin
     Dest[i].Proc := Round(Dest[i].Number/Sum*10000)/10000;
     SumProc := SumProc + Dest[i].Proc;
   end;
   Dest[N - 1].Proc := 1 - SumProc;
end;
end.

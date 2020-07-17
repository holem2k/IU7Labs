unit CalcBP;

interface
function FuncX(Num: Byte; X: Real): Real;
procedure Load(S: string; Num: Byte);
function ErrMsg(errc: Byte): string;
procedure Done;

var
   errc: Byte;
   Loaded: array [1..2] of Boolean;
   GE: Boolean;

implementation
uses Strings;
type
    TFunc = record
       N: string[20];
       C: Char;
      end;
const
    NumOFFuncs = 11;
    OperTable: array [1..NumOFFuncs] of TFunc=
      ((N:'cos';     C:'a'),
       (N:'sin';     C:'b'),
       (N:'tg';      C:'c'),
       (N:'ctg';     C:'d'),
       (N:'arcsin';  C:'e'),
       (N:'arccos';  C:'f'),
       (N:'arctg';   C:'j'),
       (N:'ln';      C:'k'),
       (N:'log';     C:'l'),
       (N:'exp';     C:'m'),
       (N:'sqrt';    C:'n'));

const
     Max = 200;
var
    Nums: array[1..2, 0..23] of Real;
    ONums: array[0..50] of Real;
    GlobPol: array [1..2] of PChar;
    i: Integer;

procedure LoadNums(var S: string; Num: Integer);
var
   i: Integer;
   L: Boolean;
   NStr: String[100];
   N, Code: Integer;
   BegN: Integer;
begin
  L := False;
  NStr := '';
  N := -1;
  i := 1;
{  for  i := 1 to Length(S) do begin}
  repeat
    if not L and (S[i] in ['0'..'9','.']) then
       begin
         NStr := S[i];
         BegN := i;
         L := True;
       end
   else
    if L and (S[i] in ['0'..'9','.']) then  NStr := NStr + S[i]
   else
    if L and not (S[i] in ['0'..'9','.']) then
       begin
         INC(N);
         Val(Nstr, Nums[Num][N], Code);
         Delete(S, BegN + 1, I - BegN - 1);
         i := BegN;
         S[BegN] := Chr(65 + N);
         L := False;
       end;
    INC(I);
   until i > Length(S);
   if L then
      begin
         INC(N);
         Val(Nstr, Nums[Num][N], Code);
         Delete(S, BegN + 1, I - BegN - 1);
         i := BegN;
         S[BegN] := Chr(65 + N);
       end;
{  end;}
end;

procedure ReplaceFuncs(var S: string);
var
   i: Integer;
   p: Integer;
begin
  for i := 1 to NumOFFuncs do  begin
     p := Pos(OperTable[i].N, S);
     while p<>0 do begin
       Delete(S, p + 1, Length(OperTable[i].N) - 1);
       S[p] := OperTable[i].C;
       p := Pos(OperTable[i].N, S);
     end;
  end;
end;

function FuncX(Num: Byte; X: Real): Real;
var
   i: Integer;
   p: Integer;
begin
   errc := 0;
   p := -1;
   Nums[Num][Ord('X') - 65] := X;
   for i := 0 to StrLen(GlobPol[Num]) - 1 do begin
     if GlobPol[Num][i] in ['A'..'Z'] then
       begin
          INC(p);
          ONums[p] := Nums[Num][Ord(GlobPol[Num][i]) - 65]
       end
    else
      case GlobPol[Num][i] of
       '+',
       '-',
       '/',
       '*': begin
              case GlobPol[Num][i] of
               '+': ONums[p - 1] :=  ONums[p - 1] + ONums[p];
               '-': ONums[p - 1] :=  ONums[p - 1] - ONums[p];
               '*': ONums[p - 1] :=  ONums[p - 1] * ONums[p];
               '/': begin
                      if ONums[p] = 0.0 then
                          begin
                            errc := 1;
                            Ge := True;
                            Exit;
                          end;
                      ONums[p - 1] :=  ONums[p - 1] / ONums[p];
                    end;
              end;
              DEC(p);
            end;
       'a'..'z':
                  case GlobPol[Num][i] of
                   'a': ONums[p] := cos(ONums[p]);
                   'b': ONums[p] := sin(ONums[p]);
                   'c': begin
                          ONums[p] := sin(ONums[p])/cos(ONums[p]);
                        end;
                   'd': begin
                          ONums[p] := cos(ONums[p])/sin(ONums[p]);
                        end;
                   'e': begin
                          if Abs(X)>1 then
                            begin
                              errc := 4;
                              GE := True;
                              Exit;
                            end;
                          ONums[p] := ArcTan(ONums[p]/sqrt(1-sqr(ONums[p])))
                        end;
                   'f': begin
                          if Abs(X)>1 then
                            begin
                              errc := 4;
                              GE := True;
                              Exit;
                            end;
                          ONums[p] := ArcTan(sqrt(1-sqr(ONums[p]))/ONums[p]);
                        end;
                   'j': begin
                          ONums[p] := ArcTan(ONums[p]);
                        end;
                   'k': begin
                          if ONums[p] <= 0 then
                           begin
                             errc := 2;
                             GE := True;
                             Exit;
                           end;
                          ONums[p] := ln(ONums[p]);
                        end;
                   'l': begin
                          if ONums[p] <= 0 then
                           begin
                             errc := 2;
                             GE := True;
                             Exit;
                           end;
                          ONums[p] := ln(ONums[p])/ln(10.0);
                        end;
                   'm': begin
                          ONums[p] := exp(ONums[p]);
                        end;
                   'n': begin
                          if ONums[p] < 0 then
                           begin
                             errc := 3;
                             GE := True;
                             Exit;
                           end;
                          ONums[p] := sqrt(ONums[p]);
                        end;
                 end;
         end; { case }
   end; { for }
   FuncX := ONums[0];
end;

procedure Load(s: string; Num: Byte);
var
   i: Integer;
   C: Char;
   Stack, PolandS: PChar;
   Polp, StackP: Integer;
begin
  LoadNums(S, Num);
  ReplaceFuncs(S);
  GetMem(Stack, Max);
  GetMem(PolandS, Max);
  Polp := 0;
  Stackp := 0;
{  StrCopy(Stack,'±±±±±±±±±±±±±±±±±±±±');
  StrCopy(PolandS,'±±±±±±±±±±±±±±±±±±±±');}
  for i := 1 to Length(S)  do begin
    C := S[i];
    { ç¨á«® }
    if (c>='A') and (c<='Z') then
     begin
       PolandS[Polp] := C;
       Inc(Polp);
     end
   else
    { ®âªà.  áª®¡ª  }
    if c = '(' then
     begin
       Stack[StackP] := C;
       Inc(StackP);
     end
   else
   { § ªà.  áª®¡ª  }
    if c = ')' then
     begin
       repeat
        DEC(Stackp);
        if (Stack[StackP] <> '(') and (Stack[StackP] <> '[') then
          begin
            PolandS[Polp] := Stack[StackP];
            INC(Polp);
          end;
       until (Stack[StackP] = '(') or (Stack[StackP] = '[');
       {$B-}
       if (Stackp > 0) and (Stack[StackP-1] in ['a'..'z']) then
        begin
         DEC(StackP);
         PolandS[Polp] := Stack[StackP];
         INC(Polp);
        end;
     end
   else
     { äã­ªæ¨ï }
     if C in ['a'..'z'] then
      begin
       Stack[Stackp] := c;
       INC(Stackp);
       Stack[Stackp] := '[';
       INC(Stackp);
       INC(i) { EXTREMELY DANGEROUS !!!}
      end
   else
    begin
      if c in ['+', '-'] then
       begin
         if StackP = 0 then
           begin
             Stack[Stackp] := c;
             INC(Stackp);
           end
         else
              if Stack[Stackp - 1] in ['/', '*'] then
                begin
                  repeat
                     DEC(StackP);
                     if not (Stack[StackP] in ['[','(']) then
                       begin
                         PolandS[Polp] := Stack[StackP];
                         INC(Polp);
                       end;
                  until (StackP = 0) or (Stack[StackP] in ['[','(']);
                  if Stack[StackP] in ['[','('] then INC(StackP);
                  Stack[StackP] := C;
                  INC(Stackp);
                end
              else
               begin
                 Stack[StackP] := C;
                 INC(StackP);
               end
         end;  (* if *)
          if C in ['*','/'] then begin
                              if StackP = 0 then begin
                                   Stack[StackP] := C;
                                   INC(StackP);
                                  end
                                else
                                   begin
                                     if Stack[Stackp - 1] in ['*', '/'] then
                                        begin
                                           PolandS[Polp] := Stack[Stackp - 1];
                                           INC(Polp);
                                           Stack[Stackp - 1] := C;
                                        end
                                      else
                                        begin
                                          Stack[StackP] := C;
                                          INC(Stackp)
                                        end;
                                   end;
                                end;

    end; (* else *)
  end;

  while Stackp <> 0 do
   begin
     DEC(StackP);
     PolandS[Polp] := Stack[StackP];
     INC(Polp);
   end;

  PolandS[Polp] := #0;
  StrCopy(GlobPol[Num], PolandS);
  FreeMem(Stack, Max);
  FreeMem(PolandS, Max);
  Loaded[Num] := True;
end;

procedure Done;
begin
 FreeMem(GlobPol[1], Max);
 FreeMem(GlobPol[2], Max);
end;

function ErrMsg(errc: Byte): string;
begin
  ErrMsg := 'Unknown message';
  case errc of
    0: ErrMsg := 'OK';
    1: ErrMsg := 'Division by zero';
    2: ErrMsg := 'Ln/Log argument negative';
    3: ErrMsg := 'Root argument negative';
    4: ErrMsg := 'Arcsin/Arccos abs argument greater than 1';
  end;
end;

begin
  GetMem(GlobPol[1], Max);
  GetMem(GlobPol[2], Max);
  Ge := False;
  Loaded[1] := False;
  Loaded[2] := False;
end.

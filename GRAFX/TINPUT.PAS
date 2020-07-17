unit TInput;
interface
function GetString(x, y: Integer; Max: Byte; Is: string; Mode: Byte): string;

implementation
uses Graph, Crt, Mouse;
function GetString(x, y: Integer; Max: Byte; Is: string; Mode: Byte): string;
const
   Validator: array [0..1] of Set of Char
                                  = (['a'..'z',
                                      'A'..'Z',
                                      '0'..'9',
                                      '.', '(',
                                       ')', '+',
                                       '-', '*',
                                       '/'],

                                       ['0'..'9', '.', '+', '-']);
var
   c: Char;
   l: Byte Absolute Is;

   procedure Show;
   begin
     Bar(x, y, x + TextWidth(Is + '_') + 10, y + TextHeight(Is + '_') + 4);
     OutTextXY(x + 2, Y, Is + '_');
   end;

begin
  SetFillStyle(1, White);
  SetColor(Blue);
{  SetTextStyle(2, 0, 5);}
  SetTextStyle(0, 0, 1);
  Show;
  Show;
  ShowMouse;
  repeat
     c := ReadKey;
     if (c = #8) and (l > 0) then begin
        Dec(l);
        HideMouse;
        Show;
        ShowMouse;
       end
    else
     if (c in Validator[Mode]) and (l < Max) then
      begin
         Inc(l);
         Is[l] := c;
         HideMouse;
         Show;
         ShowMouse;
      end
    else if c = #0 then c := ReadKey;
  until c = #13;
  GetString := Is;
  HideMouse;
end;
end.
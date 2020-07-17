unit _3DMenu;
interface
uses _3DFiler, Graph;
var
   MA: Array [1..4,1..2] of PointType;
   L, B: Integer;
   T: Real;

procedure Dialog(x, y, Length, Height : Integer);
procedure Button(x, y: Word; Pressed, Selected, Banned: Boolean; Textt: string);
procedure Face(First: Boolean; var Data: array of TData; N: Word;
               What: Word; State: Boolean);
procedure _Input(x, y: Word; dx, dy: Word);

implementation
const
     Height: Integer = 30;
     Length: Integer = 160;

procedure Dialog(x, y, Length, Height : Integer);
begin
     SetFillStyle(1, LightGray);
     Bar(x, y, x + Length, y + Height);
     SetColor(White);
     Line(x, y, x + Length - 1, y);
     Line(x, y, x, y + Height - 2);
     SetColor(Blue);
     Line(x + Length, y - 1, x + Length, y + Height);
     Line(x - 1, y + Height, x+Length, y + Height);
     SetColor(DarkGray);
     Line(x , y + Height - 1, x + Length - 1,y + Height -1);
     Line(X + Length - 1, y + 1,X + Length - 1,y - 1 + Height );
     SetColor(LightGray);
     Line(x - 1, y - 1, x + Length - 1, y - 1);
     Line(x - 1, y + Height - 1, x - 1, y - 1);
end;

procedure Button(x, y: Word; Pressed, Selected, Banned: Boolean; Textt: string);
var
   xc, yc: Integer;
begin
  if not Pressed and not Selected then begin
     SetFillStyle(1, LightGray);
     Bar(x, y, x + Length, y + Height);
     SetColor(White);
     Line(x, y, x + Length - 1, y);
     Line(x, y, x, y + Height-1);
     SetColor(Blue);
     Line(x + Length, y, x + Length, y + Height);
     Line(x, y + Height, x+Length, y + Height);
     SetColor(DarkGray);
     Line(x + 1, y + Height - 1, x + Length - 1,y + Height -1);
     Line(X + Length - 1, y + 1,X + Length - 1,y - 1 + Height );
  end
 else
  if Selected then begin
     SetFillStyle(1, LightGray);
     Bar(x, y, x + Length, y + Height);
     SetColor(Blue);
     Rectangle(x, y, x + Length, y + Height);
     Line(x + 1, y + Height - 1, x + Length - 1, y + Height - 1);
     Line(x + Length - 1, y + Height - 1,x + Length - 1, y + 1);
     SetColor(DarkGray);
     Line(x + 2, y + Height - 2,x + Length - 2, y + Height - 2);
     Line(x + Length - 2, y + Height - 2,x + Length - 2, y + 2);
     SetColor(White);
     Line(x + 1, y + Height - 2, x + 1, y + 1);
     Line(x + 1, y + 1, x + Length - 2, y + 1);
    end
   else
    begin
     SetFillStyle(1, LightGray);
     Bar(x, y, x + Length, y + Height);
     SetColor(Blue);
     Rectangle(x, y, x + Length, y + Height);
     SetColor(DarkGray);
     Rectangle(x + 1, y + 1, x + Length - 1, y + Height - 1);
    end;
   SetColor(Blue);
   SetTextStyle(0,0,1);
   xc :=TextWidth(Textt);
   xc := (Length - TextWidth(Textt)) div 2;
   yc := (Height - TextHeight(Textt)) div 2;
    if Pressed then OutTextXY(x + xc + 1, y + yc + 1, Textt)
     else OutTextXY(x + xc, y + yc, Textt)
end;

procedure Input(x, y: Word; dx, dy: Word);
begin
  SetFillStyle(1, White);
  Bar(x, y, x + dx, y + dy);
  SetColor(White);
  MoveTo(x+dx,y);
  Lineto(x + dx,y + dy);
  Lineto(x, y + dy);
  SetColor(DarkGray);
  Moveto(x, y + dy - 1);
  Lineto(x, y);
  Lineto(x + dx - 1, y);
  SetColor(Blue);
  Moveto(x + 1, y + dy - 2);
  Lineto(x + 1, y + 1);
  Lineto(x + dx - 2, y + 1);
  SetColor(LightGray);
  Moveto(x + 1, y + dy - 1);
  Lineto(x + dx - 1, y + dy - 1);
  Lineto(x + dx - 1, y + 1);
end;

procedure ColorButton(X, Y, Color: Word; State: Boolean);
begin
  Length := 30;
  Height := 12;
  Button(X, Y, State, False, False, '');
  SetFillStyle(1, Color);
  if State then
     Bar(X + 4, Y + 4, X + 27, Y + 9)
   else
     Bar(X + 3, Y + 3, X + 26, Y + 8);
end;

procedure LeftArrow(X, Y: Word; State: Boolean);
begin
  Length := 60;
  Height := 20;
  Button(X, Y, State, False, False, '');
  SetColor(Blue);
  if State then Moveto(X + 13, Y + 12)
   else  Moveto(X + 13, Y + 10);
  LineRel(6, 6);
  LineRel(0,-3);
  LineRel(30,0);
  LineRel(0,-6);
  LineRel(-30,0);
  LineRel(0,-3);
  LineRel(-6,6);
  SetFillStyle(1, Blue);
  FloodFill(X + 20, Y + 10, Blue);
end;

procedure RightArrow(X, Y: Word; State: Boolean);
begin
  Length := 60;
  Height := 20;
  Button(X, Y, State, False, False, '');
  if State then Moveto(X + 47, Y + 12)
   else  Moveto(X + 47, Y + 10);
  LineRel(-6, 6);
  LineRel(0,-3);
  LineRel(-30,0);
  LineRel(-0,-6);
  LineRel(30,0);
  LineRel(-0,-3);
  LineRel(6,6);
  SetFillStyle(1, Blue);
  FloodFill(X + 20, Y + 10, Blue);
end;

procedure Face(First: Boolean; var Data: array of TData; N: Word; What: Word; State: Boolean);
const
     nn = 20;
var
    i, Code: Word;
   S: string;

begin
   L := 100 + nn*N;
   B := (GetMaxY - L) div 2 + 10;
     if First then begin
     Dialog(10, (GetMaxY - L) div 2, 200, L);
     SetTextStyle(2, 0, 4);
     SetColor(Blue);
     OutTextXY(105 - TextWidth('SECTORS') div 2, (GetMaxY - L) div 2 + 5, 'SECTORS');
     for i := 1 to N do
       ColorButton(20, (GetMaxY - L) div 2 + 10 + nn*i, Data[i - 1].Color, False);
     LeftArrow(40, GetMaxY - (GetMaxY - L) div 2 - 55, False);
     RightArrow(120, GetMaxY - (GetMaxY - L) div 2 - 55, False);
     Length := 60;
     Button(120, GetMaxY - (GetMaxY - L) div 2 - 30, False, False, False, 'Exit');
     Input(55, (GetMaxY - L) div 2 + 8 + nn, 145, nn*N);
     Input(40, GetMaxY - (GetMaxY - L) div 2 - 30, 60,  20);
       SetTextStyle(0,0,1);
        Str(T:5:2, S);
          SetColor(Blue);
            OutTextXY(45, 6  +GetMaxY - (GetMaxY - L) div 2 - 30,S);
     SetTextStyle(2, 0, 4);
     SetColor(Blue);
     Ma[1][1].X := 40;
     Ma[1][1].Y := GetMaxY - (GetMaxY - L) div 2 - 55;
     Ma[1][2].X := Ma[1][1].X + 60;
     Ma[1][2].Y := Ma[1][1].Y + 20;

     Ma[2][1].X := 120;
     Ma[2][1].Y := GetMaxY - (GetMaxY - L) div 2 - 55;
     Ma[2][2].X := Ma[2][1].X + 60;
     Ma[2][2].Y := Ma[2][1].Y + 20;

     Ma[3][1].X := 40;
     Ma[3][1].Y := GetMaxY - (GetMaxY - L) div 2 - 30;
     Ma[3][2].X := 100;
     Ma[3][2].Y := Ma[3][1].Y + 20;

     Ma[4][1].X := 120;
     Ma[4][1].Y := GetMaxY - (GetMaxY - L) div 2 - 30;
     Ma[4][2].X := 180;
     Ma[4][2].Y := Ma[4][1].Y + 20;

     for i := 1 to N do begin
       OutTextXY(59, (GetMaxY - L) div 2 + 10 + nn*i, Data[i-1].Name);
       Str( Data[i-1].Number, S);
       OutTextXY(195 - TextWidth(S) , (GetMaxY - L) div 2 + 10 + nn*i, S);
     end;
   end
 else
   begin
     case What of
       1:  LeftArrow(40, GetMaxY - (GetMaxY - L) div 2 - 55, State);
       2:  RightArrow(120, GetMaxY - (GetMaxY - L) div 2 - 55, State);
       3:  begin
              Input(40, GetMaxY - (GetMaxY - L) div 2 - 30, 60,  20);
              SetTextStyle(0,0,1);
              Str(T:5:2, S);
              SetColor(Blue);
              OutTextXY(45, GetMaxY - (GetMaxY - L) div 2 - 30 + 6, S);
           end;

       4:  begin
              Length := 60;
              Height := 20;
              Button(120, GetMaxY - (GetMaxY - L) div 2 - 30, State, False, False, 'Exit');
           end;
      else
        ColorButton(20, (GetMaxY - L) div 2 + 10 + nn*(What - 4),
                    Data[What - 1 - 4].Color, State);
     end;
   end;
end;

procedure _Input(x, y: Word; dx, dy: Word);
begin
  SetFillStyle(1, White);
  Bar(x, y, x + dx, y + dy);
  SetColor(White);
  MoveTo(x+dx,y);
  Lineto(x + dx,y + dy);
  Lineto(x, y + dy);
  SetColor(DarkGray);
  Moveto(x, y + dy - 1);
  Lineto(x, y);
  Lineto(x + dx - 1, y);
  SetColor(Blue);
  Moveto(x + 1, y + dy - 2);
  Lineto(x + 1, y + 1);
  Lineto(x + dx - 2, y + 1);
  SetColor(LightGray);
  Moveto(x + 1, y + dy - 1);
  Lineto(x + dx - 1, y + dy - 1);
  Lineto(x + dx - 1, y + 1);
end;

end.
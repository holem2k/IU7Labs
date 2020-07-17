unit Menus;

interface
const
  mnDefFuncs       =  0;
  mnDraw1          =  1;
  mnDraw2          =  2;
  mnDrawB          =  3;
  mnOptions        =  4;
  mnExit           =  5;

{type
    TOptions = record
       _XB: Real;
       _XE: Real;
       _dX: Real;
       _dY: Real;
       _NY: Real;
       _BS: Boolean;
       _MB: Boolean;
       _Net: Boolean;
     end;}
const
     Height = 30;
     Length = 160;

var
   Ret: Integer;
   FRet: Integer;
   ORet: Integer;

procedure Menu;
procedure FadeIn;
procedure FadeOut;
procedure Button(x, y: Word; Pressed, Selected, Banned: Boolean; Textt: string);
procedure Input(x, y: Word; dx, dy: Word);
procedure Dialog(x, y, Length, Height : Integer);
procedure FunMenu(s1, s2: string);
procedure OptMenu(var SXb, SXe, SdX, SdY, SnY: string; Net, Bs, Mb: Boolean);
procedure ErrorMessage(s: string);

implementation
uses Graph, Crt, Mouse, TInput;

const
  N = 6;
  MaxLen = 25;

const
  Mstr: array [0..N - 1] of string[MaxLen] =
     ('Define functions', 'Draw 1st function',
     'Draw 2nd function ', 'Draw both functions','Options', ' Exit' );


procedure  FadeIn;
var
   i: Byte;
begin
   for i := $2A downto 20 do
    SetRGBPalette(7, i,i,i);
end;

procedure FadeOut;
var
   i: Byte;
begin
   for i := 20 to $2A do
    SetRGBPalette(7, i, i, i);
end;

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

procedure Menu;
var
   H, i, OldI: Integer;
   SWidth, Ih: Word;
   c : Char;
   Left, Right: Boolean;
   MouseX, MouseY: Integer;
   Clicked, Redraw: Boolean;
begin
   HideMouse;
   ClearViewPort;
   Clicked := False;
   c := ' ';
   SetFillStyle(1, LightGray);
   Dialog(GetMaxX div 2 - 130,80, 260, 270);
   ShowMouse;
   repeat
     HideMouse;
     SWidth := 10;
     for i := 0 to N - 1 do
        Button(GetMaxX div 2 - 80, 100 + 40*i, False, i = Ret , False, MStr[i]);
     ShowMouse;
     Left := False;
     Redraw := False;
     OldI := 0;
     repeat
       repeat
         GetMouse(MouseX, MouseY, Left, Right);
       until Left or Keypressed;
       if Left and (MouseX > GetMaxX div 2 - 80) and (MouseX < GetMaxX div 2 + 80) then
         for i := 0 to N - 1 do
          if (100 + 40*i + 30 > MouseY) and (100 + 40*i < MouseY) then
           begin
             Clicked := True;
             OldI := Ret;
             Ret := i;
             Break;
           end;

       if Keypressed then c := ReadKey;
       if c = #0 then begin
          c := ReadKey;
          if c = #80 then begin
                            Ret := (Ret + 1) mod N;
                            Redraw := True;
                          end;
          if c = #72 then begin
                           if Ret = 0 then Ret := N - 1
                          else Ret := Ret - 1;
                           Redraw := True;
                          end;

        end;

     if (c = #13) or Clicked  then begin
                        HideMouse;
                        Button(GetMaxX div 2 - 80, 100 + 40*OldI, False, False , False, MStr[OldI]);
                        Button(GetMaxX div 2 - 80, 100 + 40*Ret, True, True , False, MStr[Ret]);
                        Delay(100);
                        Button(GetMaxX div 2 - 80, 100 + 40*Ret, False, True , False, MStr[Ret]);
                        ShowMouse;
                        Exit;
                     end;
      c := ' ';
      until Redraw;
   until false;
end;

procedure FunMenu(s1, s2: string);
const
     MRect: array[0..3,1..4] of Integer =
     ((639 div 2 - 200, 190, 639 div 2 + 200, 210),
      (639 div 2 - 200, 230, 639 div 2 + 200, 250),
      (638 div 2 - 170, 300, 639 div 2 - 10, 330),
      (638 div 2 + 10, 300, 639 div 2 + 170, 330));

var
   H, i, OldI: Integer;
   SWidth, Ih: Word;
   c : Char;
   Left, Right: Boolean;
   MouseX, MouseY: Integer;
   Clicked, Redraw: Boolean;
   s: String;

  function WhereClicked(x, y: Integer): Byte;
  var
     i: Integer;
  begin
    for i := 0 to 3 do
     if (X>MRect[i][1]) and (X<MRect[i][3]) and
        (Y>MRect[i][2]) and (Y<MRect[i][4]) then begin
                                                    WhereClicked := i;
                                                    Exit;
                                                  end;
    WhereClicked := 255;
  end;

  procedure RedrawAll;
  begin
       if (FRet = 0) then
       begin
         SetTextStyle(0, 0, 1);
         SetColor(Red);
         OutTextXY(GetMaxX div 2 - 200 + 3, 196, s1);
         SetColor(Blue);
         OutTextXY(GetMaxX div 2 - 200 + 3, 236, s2);
         Button(GetMaxX div 2-170, 300, False,  False, False, 'OK');
         Button(GetMaxX div 2 + 10, 300, False, False, False, 'Cancel');
       end
     else
       if (FRet = 1) then
       begin
{         SetTextStyle(2, 0, 5);}
         SetTextStyle(0, 0, 1);
         SetColor(Blue);
         OutTextXY(GetMaxX div 2 - 200 + 3, 196, s1);
         SetColor(Red);
         OutTextXY(GetMaxX div 2 - 200 + 3, 236, s2);
         Button(GetMaxX div 2-170, 300, False,  False, False, 'OK');
         Button(GetMaxX div 2 + 10, 300, False, False, False, 'Cancel');
       end
     else
      if FRet = 2 then
       begin
         Button(GetMaxX div 2-170, 300, False, not False, False, 'OK');
         Button(GetMaxX div 2 + 10, 300, False, False, False, 'Cancel');
{         SetTextStyle(2, 0, 5);}
         SetTextStyle(0, 0, 1);
         SetColor(Blue);
         OutTextXY(GetMaxX div 2 - 200 + 3, 196, s1);
         OutTextXY(GetMaxX div 2 - 200 + 3, 236, s2);
       end
     else
      if FRet = 3 then
       begin
         Button(GetMaxX div 2-170, 300, False, False, False, 'OK');
         Button(GetMaxX div 2 + 10, 300, False, not False, False, 'Cancel');
{         SetTextStyle(2, 0, 5);}
         SetTextStyle(0, 0, 1);
         SetColor(Blue);
         OutTextXY(GetMaxX div 2 - 200 + 3, 196, s1);
         OutTextXY(GetMaxX div 2 - 200 + 3, 236, s2);
       end;
  end;


begin
{   FRet := 0;}
   Clicked := False;
   c := ' ';
   ClearViewPort;
   Dialog(GetMaxX div 2 - 250, GetMaxY div 2 - 100, 500, 200);
   SetTextStyle(0, 0, 1);
   SetColor(Blue);
   OutTextXY(GetMaxX div 2-80, 150,'Define functions');
   OutTextXY(GetMaxX div 2-200, 180,'Function f(x)');
   Input(GetMaxX div 2-200, 190, 400, 20);
   SetTextStyle(0, 0, 1);
   SetColor(Blue);
   OutTextXY(GetMaxX div 2-200, 220,'Function g(x)');
   Input(GetMaxX div 2-200, 230, 400, 20);
{   GetString(GetMaxX div 2 - 200 + 3, 192, 45, s, 0);}
   Button(GetMaxX div 2 - 170, 300, False, False, False, 'OK');
   Button(GetMaxX div 2 + 10, 300, False, False, False, 'Cancel');
   ShowMouse;
   repeat
     HideMouse;
     RedrawAll;
     ShowMouse;
     Left := False;
     Redraw := False;
     OldI := 0;
     repeat
       repeat
         GetMouse(MouseX, MouseY, Left, Right);
       until Left or Keypressed;

       if Left and (WhereClicked(MouseX, MouseY) <> 255) then
           begin
             Clicked := True;
             OldI := FRet;
             FRet := WhereClicked(MouseX, MouseY);
           end;

       if Keypressed then c := ReadKey;
       if c = #0 then begin
          c := ReadKey;
          if c = #80 then begin
                            FRet := (FRet + 1) mod 4;
                            Redraw := True;
                          end;
          if c = #72 then begin
                           if FRet = 0 then FRet := 4 - 1
                          else FRet := FRet - 1;
                           Redraw := True;
                          end;

        end;

     if (c = #13) or Clicked  then begin
                        HideMouse;
                        RedrawAll;
{                        ShowMouse;}
                        while KeyPressed do C := ReadKey;
                        Exit;
                     end;
      c := ' ';
      until Redraw;
   until false;
end;

procedure Onfer(x, y: Integer; Switch, On: Boolean);
begin
  Input(x, y, 15, 15);
  if On then begin
     SetFillStyle(1, Red);
     Bar(x + 2, y + 2, x + 13, y + 13);
    end;
  if Switch then begin
    SetColor(Blue);
    SetLineStyle(0, 0, 3);
    Line(x + 3, y + 3, x + 12, y + 12);
    Line(x + 12, y + 3, x + 3, y + 12);
    SetLineStyle(0, 0, 1);
  end;
end;

procedure OptMenu(var SXb, SXe, SdX, SdY, SnY: string; Net, Bs, Mb: Boolean);
const
     MRect: array[0..9,1..4] of Integer =
     ((639 div 2 - 230, 100, 639 div 2 - 30,  120),
      (639 div 2 + 45,  100, 639 div 2 + 245, 120),
      (639 div 2 - 270, 135, 639 div 2 - 255, 150),
      (639 div 2 - 40,  160, 639 div 2 + 160, 180),
      (639 div 2 - 40,  185, 639 div 2 + 160, 205),
      (639 div 2 - 40,  210, 639 div 2 + 160, 235),
      (639 div 2 - 270, 245, 639 div 2 - 255, 260),
      (639 div 2 - 270, 270, 639 div 2 - 255, 285),
      (639 div 2 - 180, 330, 639 div 2 - 20,  360),
      (639 div 2 + 20,  330, 639 div 2 + 180, 360));

var
   H, i, OldI: Integer;
   SWidth, Ih: Word;
   c : Char;
   Left, Right: Boolean;
   MouseX, MouseY: Integer;
   Clicked, Redraw: Boolean;
   s: String;

   function WhereClicked(x, y: Integer): Byte;
   var
      i: Integer;
   begin
     for i := 0 to 9 do
      if (X>MRect[i][1]) and (X<MRect[i][3]) and
         (Y>MRect[i][2]) and (Y<MRect[i][4]) then begin
                                                     WhereClicked := i;
                                                     Exit;
                                                   end;
     WhereClicked := 255;
   end;

   procedure RedrawAll;
   begin
     if ORet = 0 then  SetColor(Red)
      else SetColor(Blue);
     OutTextXY(GetMaxX div 2 - 230 + 3, 106, SXB);

     if ORet = 1 then  SetColor(Red)
      else SetColor(Blue);
     OutTextXY(GetMaxX div 2 + 45 + 3, 106, SXE);

     if ORet = 3 then  SetColor(Red)
      else SetColor(Blue);
     OutTextXY(GetMaxX div 2 - 40 + 3, 166, SdX);

     if ORet = 4 then  SetColor(Red)
      else SetColor(Blue);
     OutTextXY(GetMaxX div 2 - 40 + 3, 191, SdY);

     if ORet = 5 then  SetColor(Red)
      else SetColor(Blue);
     OutTextXY(GetMaxX div 2 - 40 + 3, 216, SnY);

     Onfer(GetMaxX div 2 - 270, 135, Net, ORet = 2);

     Onfer(GetMaxX div 2 - 270, 245, Bs, ORet = 6);

     Onfer(GetMaxX div 2 - 270, 270, Mb, ORet = 7);

     if ORet = 8 then Button(GetMaxX div 2 - 180, 330, False, True, False, 'OK')
      else Button(GetMaxX div 2 - 180, 330, False, False, False, 'OK');

     if ORet = 9 then Button(GetMaxX div 2 + 20, 330, False, True, False, 'Cancel')
      else Button(GetMaxX div 2 + 20, 330, False, False, False, 'Cancel');
   end;

begin
   ClearViewPort;
   Dialog(GetMaxX div 2 - 300, GetMaxY div 2 - 180, 600, 340);
   SetTextStyle(0, 0, 1);
   SetColor(Blue);
   OutTextXY(GetMaxX div 2 - 40, 70, 'Options');
   OutTextXY(GetMaxX div 2 - 270, 85,'Functions definition limits');
   OutTextXY(GetMaxX div 2 - 270, 105, 'From');
   OutTextXY(GetMaxX div 2 , 105, 'Up to');
   OutTextXY(GetMaxX div 2 - 240, 140 , 'Show net');
   OutTextXY(GetMaxX div 2 - 240, 165 , 'Horizontal net step    ');
   OutTextXY(GetMaxX div 2 - 240, 190 , 'Vertical net step       ');
   OutTextXY(GetMaxX div 2 - 240, 215 , 'Number of vertical lines');
   OutTextXY(GetMaxX div 2 - 240, 250, 'Show f(x) and g(x) in equal scale');
   OutTextXY(GetMaxX div 2 - 240, 275, 'Search for point of bent');
   Input(GetMaxX div 2 - 230, 100, 200, 20);
   Input(GetMaxX div 2 + 45, 100, 200, 20);
   Input(GetMaxX div 2 - 40, 160, 200, 20);
   Input(GetMaxX div 2 - 40, 185, 200, 20);
   Input(GetMaxX div 2 - 40, 210, 200, 20);
   ShowMouse;
   Clicked := False;
   c := ' ';
   repeat
     HideMouse;
     RedrawAll;
     ShowMouse;
     Left := False;
     Redraw := False;
     OldI := 0;
     repeat
       repeat
         GetMouse(MouseX, MouseY, Left, Right);
       until Left or Keypressed;

       if Left and (WhereClicked(MouseX, MouseY) <> 255) then
           begin
             Clicked := True;
             OldI := ORet;
             ORet := WhereClicked(MouseX, MouseY);
           end;

       if Keypressed then c := ReadKey;
       if c = #0 then begin
          c := ReadKey;
          if c in [#80, #77] then begin
                            ORet := (ORet + 1) mod 10;
                            Redraw := True;
                          end;
          if c in [#72, #75] then begin
                           if ORet = 0 then ORet := 10 - 1
                             else ORet := ORet - 1;
                           Redraw := True;
                         end;
        end;

     if (c = #13) or Clicked  then begin
                        HideMouse;
                        RedrawAll;
                        while KeyPressed do C := ReadKey;
                        Exit;
                     end;
      c := ' ';
      until Redraw;
   until false;
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

procedure ErrorMessage(s: string);
var
   c: Char;
   MouseX, MouseY: Integer;
   Left, Right: Boolean;
begin
  Dialog(GetMaxX div 2 - 200, GetMaxY div 2 - 50, 400, 100);
  SetTextStyle(0, 0, 1);
  SetColor(Blue);
  OutTextXY(GetMaxX div 2 - 50, GetMaxY div 2 - 30, 'Error message !');
  OutTextXY(GetMaxX div 2 - TextWidth(s) div 2, GetMaxY div 2 - 20, S);
  Button(GetMaxX div 2 - 80, GetMaxY div 2, False, False, False,'OK');
  ShowMouse;
  repeat
    repeat
       GetMouse(MouseX, MouseY, Left, Right);
    until Keypressed or Left;
    if Keypressed then c := Readkey;
    if (c = #13) or ((MouseX > GetMaxX div 2 - 80) and (MouseX<GetMaxX div 2 + 80)
                and (MouseY>GetMaxY div 2) and (MouseY<GetMaxY div 2 + 30)) then
         begin
           HideMouse;
           Button(GetMaxX div 2 - 80, GetMaxY div 2,
                                    not False, False, False,'OK');
           ShowMouse;
           Delay(30);

           Exit;
         end;
   until False
end;

begin
  Ret := 3;
  FRet := 3;
  ORet := 8;
end.

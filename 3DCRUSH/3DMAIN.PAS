uses Graph, _3DFiler, _3DDiag, _3DMenu, Mouse, Crt, Tinput;

var
   Data: array [1..15] of TData;
   NumData, i, j: Word;
   UsedColors: Word;
   LastAngle, Code: Word;
   Find: Boolean;
   Gd, Gm: Integer;
   Add: Integer;
   TT: Real;
   S: String;

procedure Init; forward;

function NormAngle(Fi: Integer): Integer;
begin
  NormAngle := Fi;
  if Fi >= 360 then  NormAngle :=  Fi  mod 360
   else
     if Fi < 0 then  NormAngle := 360 + Fi;
end;


procedure Work;
var
   Left, Right: Boolean;
   MouseX, MouseY: Integer;
   WClicked: Byte;
   Dfi: Integer;
   Num, NCake: Integer;
   NewState : Boolean;

   function DefineWhere(MouseX, MouseY: Integer): Byte;
   var
      i: Byte;
   begin
     DefineWhere := 255;
     for i := 1 to 4 do
      if (MouseX > MA[i][1].X) and (MouseX < MA[i][2].X)
         and (MouseY > MA[i][1].Y) and (MouseY < MA[i][2].Y)
         then
           begin
             DefineWhere := i;
             Exit;
           end;

     for i := 1 to NumData do
      if (MouseX > 20) and (MouseX < 50)
         and (MouseY > B + 20*i) and (MouseY < B + 20*(i + 1))
          then
           begin
             DefineWhere := i + 4;
             Exit;
           end;
   end;

begin
 repeat
   Left := False;
   repeat
     GetMouse(MouseX, MouseY, Left, Right);
   until Left;
   WClicked := DefineWhere(MouseX, MouseY);

   if (WClicked >= 5) and (WClicked <= 4 + NumData) then
   begin
     Num := WClicked - 4;
     for i := 1 to UsedColors do
       if Cake[i].Color = Data[Num].Color then begin
          NCake := i;
          Break;
        end;
     NewState := not Cake[NCake].Out;
     Cake[NCake].Out := NewState;
     for i := 1 to NumData do
       if Data[i].Color = Data[Num].Color then begin
         HideMouse;
         Face(False, Data, NumData, i + 4, NewState);
         Delay(200);
         ShowMouse;
       end;
       HideMouse;
       SetFillStyle(1, LightBlue);
       Bar(210, 80, GetMaxX, GetMaxy);
       CakeMenager;
       VisualizeNumbers;
       ShowMouse;
   end;

   if  WClicked  = 3 then begin
      Str(T:5:2, S);
      HideMouse;
      S := GetString(42, GetMaxY - (GetMaxY - L) div 2 - 30 + 6, 5, s, 1);
      ShowMouse;
      HideMouse;
      Val(S, T, Code);
      Threshold := T;
      Init;
      SetFillStyle(1, LightBlue);
      Bar(210, 80, GetMaxX, GetMaxy);
      CakeMenager;
      VisualizeNumbers;
      Face(True, Data, NumData, 1, True);
      ShowMouse;
      Face(False, Data, NumData, 3, not True);
   end;

   if  WClicked in [1, 2] then begin
     if WClicked = 1 then begin
      DFi := -10;
      HideMouse;
      Face(False, Data, NumData, 1, True);
      ShowMouse;
      Delay(100);
      HideMouse;
      Face(False, Data, NumData, 1, not True);
      ShowMouse;
     end
   else
    begin
      DFi := 10;
      HideMouse;
      Face(False, Data, NumData, 2, True);
      ShowMouse;
      Delay(100);
      HideMouse;
      Face(False, Data, NumData, 2, not True);
      ShowMouse;
    end;
     for i := 1 to UsedColors do begin
       Cake[i].BAngle := NormAngle(Cake[i].BAngle + DFI);
       Cake[i].EAngle := NormAngle(Cake[i].EAngle + DFI);
     end;
    HideMouse;
    SetFillStyle(1, LightBlue);
    Bar(210, 80, GetMaxX, GetMaxy);
    CakeMenager;
    VisualizeNumbers;
    ShowMouse;
   end;

 until WClicked = 4;
 HideMouse;
 Face(False, Data, NumData, 4, True);
 ShowMouse;
 Delay(100);
 HideMouse;
 Face(False, Data, NumData, 4, not True);
end;

procedure Init;
begin
   UsedColors := 0;
   LastAngle := 0;
   for i := 1 to NumData do
        Data[i].WasCalced := not True;
   for i :=  1 to NumData do begin
     if Data[i].Proc < Threshold/100 then Data[i].WasCalced := False
    else
     begin
       Data[i].WasCalced := True;
       INC(UsedColors);
       Data[i].Color := ColorTable[UsedColors];
       with Cake[UsedColors] do begin
           Proc := Data[i].Proc*100;
           BAngle := LastAngle;
           LastAngle := LastAngle + Round(3.60*Proc);
           EAngle := LastAngle;
           if EAngle - BAngle < 8 then
             begin
                EAngle := BAngle + 8;
                LastAngle := EAngle;
             end;
           Color := ColorTable[UsedColors];
           Out := False;
       end;
     end;  { if }
   end;  { for }

   Find := False;
   for i := 1 to NumData do begin
    if not Data[i].WasCalced then begin
    if not Find then begin
       Inc(UsedColors);
       with Cake[UsedColors] do begin
       Proc := 0;
       Out := False;
       BAngle := LastAngle;
       EAngle := 360;
       Color := ColorTable[UsedColors];
       if EAngle - BAngle < 8 then
             begin
                EAngle := BAngle + 8;
                LastAngle := EAngle;
             end;
       end;
     end;
     Find := True;
     Cake[UsedColors].Proc := Cake[UsedColors].Proc + Data[i].Proc*100;
     Data[i].Color := ColorTable[UsedColors];
    end;
   end;

   if LastAngle <= 360 then Cake[UsedColors].EAngle := 0
  else if LastAngle > 360 then
   begin
     Add := LastAngle - 360;
     for i := 1 to UsedColors do begin
       if Cake[i].EAngle - Cake[i].BAngle > 8 + Add then
       begin
          Cake[i].EAngle :=  Cake[i].EAngle - Add;
          for j := i + 1 to UsedColors do begin
            Cake[j].EAngle := (Cake[j].EAngle - Add) mod 360;
            Cake[j].BAngle := Cake[j].BAngle - Add;
          end;
          Break;
       end;
     end;
   end;
   N := UsedColors;

end;

procedure Candle;
const
     MX = 5;
     MY: Integer = 5;

var
   Gd, Gm, i, j: Integer;
   _A, k,  t: Real;
   Next: Integer;
   f, Col, S: Integer;
   Left, Right: Boolean;
   MouseX, MouseY: Integer;
begin
   k := 3;
   S := -1;
   Next := 2;
   SetFillStyle(1, Yellow);
   FillEllipse(GetMaxX div 2 + 100, GetMaxY div 2 - 20 , 5, 3);
   Bar(GetMaxX div 2 + 100 - 6, GetMaxY div 2 - 130,GetMaxX div 2 + 100 + 6, GetMaxY div 2 - 20);
   FillEllipse(GetMaxX div 2 + 100, GetMaxY div 2 - 130, 6, 2);
   repeat
   f := Random(3);
   for i := 1 to MY + 5  do
    for j := -MX to MX do begin
      _A := j*j/k/k*5 + i;
      Col := Round(_A*14/(MX*MX/K/K/(MY+10) + MY));
      if Col <= 15 then
                 begin
                   case Col of
                     0..5: SetColor(LightRed);
                     6..9: SetColor(White);
                     9..15: SetColor(Yellow);
                   end;
                   Line(j + GetMaxX div 2 + 100, -i + GetMaxY div 2 - 130,j + GetMaxX div 2+100, -i + GetMaxY div 2- 130);
                 end
               else
                begin
                 SetColor(LightBlue);
                 Line(j + GetMaxX div 2 + 100, -i + GetMaxY div 2 - 130,j + GetMaxX div 2 + 100, -i + GetMaxY div 2 - 130);
                end;
    end;
    if Random(2) = 0 then begin if k = 2 then k := 3 else k := 2; end;
    MY := MY + S;
    Delay(100);
    if MY >= 15 then s := -2;
    if MY <= 12 then s := 2;
    Next := (Next + 1) mod 2;
    until  GetMouse(MouseX, MouseY, Left, Right);
    HideMouse;
    SetBkColor(LightBlue);
    ClearViewPort;
    CakeMenager;
    VisualizeNumbers;
    Face(True, Data, NumData, 1, True);
    SetTextStyle(8,0,1);
    SetColor(LightGreen);
    OutTextXY(270,35,' Quantity of licensed programs');
    OutTextXY(330,55,'  used in Russia');
    ShowMouse
end;

begin
   LoadFromFile('data.3dd', Data, NumData);
   MakeCalc(Data, NumData);
   Init;
   Gd := Vga;
   Gm := VgaHI;
   InitGraph(Gd, Gm, 'C:\tp');
   if Graphresult <> 0 then Halt(1);
   SetArcXY;
   SetBkColor(LightBlue);
   T := Threshold;
   SetTextStyle(8,0,1);
   SetColor(LightGreen);
   OutTextXY(270,35,' Quantity of licensed programs');
   OutTextXY(330,55,'  used in Russia');
   CakeMenager;
   VisualizeNumbers;
   Face(True, Data, NumData, 1, True);
   InitMouse;
   ShowMouse;
   Candle;
   Work;
   CloseGraph;
end.
Program Graphik;
uss Graph,Crt;
type
 Funct=function( x:real):real;
{$F+}
Function Func1( x:real):real;
begin
  Func1:={Exp(x)*sin(X*X)}2-x/2+sqrt(sqr(x)/4+2);
end;
Function Func2( x:real):real;
begin
  Func2:={sin(X*X*X)*cos(X);{sin(x)+Sin(x)*Cos(X);cos(exp(-2*x*x))}X*X;
end;
{$F-}
const
Knop:array[1..5] of PointType=((X:50;Y:310),(X:164;Y:310),(X:278;Y:310)
    ,(X:392;Y:310),(X:506;Y:310));
  KnopWords:array[1..5]of String=('Писовать','Мастаб','MoveПопой','Сетка',
         'Выход');
  GridSize=5;
  x=10;
  y=300;
  GrX=50;
  GrY1=20;
  GrY2=70;
var 
  Driver,Mode,sx,sy:Integer;
  m:Byte;
  B,T1,T2:Boolean;
  Ra,Stx,Sty,MinX,MaxX,MinY,MaxY,mn,mx:real;
  xa,ya:word;
  ch,c:char;
procedure EnterGrid(var sx,sy:Integer;var B:boolean);
begin
 { SetFillStyle(1,7);
  Bar(342,100,498,300);
  SetFillStyle(2,1);
  Bar(377,105,489,125);
  SetColor(15+128);
  OutTextXY(388,111,'Сетка');
  RamkaOut(372,100,494,300,0,0);
  RamkaOut(377,105,489,125,15,0);
  SetColor(0);    
  OutTextXY(380,150,'Шаг по Х..');
  OutTextXY(380,175,'Шаг по Y..');
  SetFillStyle(1,15);
  Bar(450,145,489,160);
  Bar(450,170,489,185);
  RamkaIn(450,145,489,160,0,15);
  RamkaIn(450,170,489,185,0,15);}
  RestoreCrtMode;
  WriteLn('Шаг по X..');
  ReadLn(Sx);
{  Sx:=Round((GetMaxX+1)/Sx);}
  WriteLn('Шаг по Y');
  ReadLn(Sy);
{    Sy:=Round((GetMaxY+1)/Sy);}
    if (Sx=0) and (Sy=0) then
     B:=false  else
     B:=true;
  SetGraphMode(Mode); 
end;
{----------------------------------------------------}
procedure drawgrid(sx,sy:integer;T1,T2:Boolean);
var I,k:integer;
begin
  if (sx>=GridSize) and (sy>=GridSize)then
  begin
  SetColor(7);
    if MinX<>MaxX then
    k:=Round((-MinX)/(MaxX-MinX)*(GetMaxX-2*GrX+1))+GrX
    else
    k:=GrX;
    repeat
      Line(k,GrY1,k,GetMaxY-GrY2);
      k:=k+Sx;
    until k>=GetMaxX-GrX;
     if MinX<>MaxX then
    k:=Round((-MinX)/(MaxX-MinX)*(GetMaxX-2*GrX+1))+GrX
    else
     K:=GrX;
    if k<>GrX then
    repeat
      Line(k,GrY1,k,GetMaxY-GrY2);
      k:=k-Sx;
    until k<=GrX;
    if MaxY<>MInY then
    k:=GetMaxY-GrY2-Round((-MinY)/(MaxY-MinY)*(GetMaxY-GrY1-GrY2))
    else
    k:=GetMaxY-GrY2;
    repeat
      Line(GrX,k,GetMaxX-GrX,k);
      k:=k+Sy; 
    until k>=GetMaxY-GrY2;
    if MaxY<>MInY then
    k:=GetMaxY-GrY2-Round((-MinY)/(MaxY-MinY)*(GetMaxY-GrY1-GrY2))
    else begin
    k:=GetMaxY-GrY2;
    if k<>GrY1 then
     repeat
      Line(GrX,k,GetMaxX-GrX,k);
      k:=k-Sy;
    until k<=GrY1;
end;
end;
{---------------------------------------}
procedure RomkaOut(XUp,YUp,XDown,YDown:integer ; ColorUp,ColorDown:word);
begin
SetColor(ColorUp);
Line(XUp-1,YDown,XUp-1,YUp-1);
Line(XUp-1,YUp-1,XDown,YUp-1);
SetColor(ColorDown);
Line(XUp-1,YDown+1,XDown+1,YDown+1);
Line(XDown+1,YDown+1,XDown+1,YUp-1);
end;
procedure RamkaIn(XUp,YUp,XDown,YDown:integer ; ColorUp,ColorDown:word);
begin
SetColor(ColorUp);
Line(XUp,YDown-1,XUp,YUp);
Line(XUp,YUp,XDown-1,YUp);
SetColor(ColorDown);
Line(XUp,YDown,XDown,YDown);
Line(XDown,YDown,XDown,YUp);
end;              end;
procedure menu( var m:Byte);
var
  i  :integer;
  n:byte;
  ch :char;
begin
  m:=1000;
  n:=1000;
  {  Выводим меню и перемещаем выделение до нажатия клавиши Enter  }
  repeat
 {  SetActivePage(n);
    cleardevice;
      SetFillStyle(1,7);
      Bar(0,0,GetMaxX,GetMaxY);
  SetFillStyle(1,white);
  Bar(10,10,GetMaxX-10,GetMaxY-50);}
    SetFillStyle(1,15);
     SetColor(0);
    for i:=1 to 5 do
      begin
        Bar(Knop[i].x,Knop[m].y,Knop[i].x+84,Knop[i].y+30);
        SetColor(blue);
        OutTextXY(Knop[i].x+12,Knop[i].y+10,KnopWords[i]);
        RamkaOut(Knop[i].x-1,Knop[i].y-1,Knop[i].x+85,Knop[i].y+31,15,0);
      end;
       SetLineStyle(dashedln,0,NormWidth);
       RamkaOut(Knop[m].x+5,Knop[m].y+5,Knop[m].x+79,Knop[m].y+25,0,0);
        SetLineStyle(Solidln,0,NormWidth);
{        SetVisualPage(n);           }

    ch:=readkey;
    if ch=#0 then
      ch:=readkey;
    case ch of
  #75:
      if m=1 then m:=5         { Перемещаемся влево }
      else
        m:=m mod 6 -1;
  #77:
      m:=m mod 5 +1;            { Перемещаемся вправо }
    end;
    n:=(n+1) mod 2;
  until ch=#33;
  RamkaOut(Knop[m].x-1,Knop[m].y-1,Knop[m].x+85,Knop[m].y+31,0,15);
   Delay(300);
end;


procedure MinMax( MinX,MaxX:real;var MinY,MaxY:real;Y:Funct;var T1,T2:Boolean);
var k,Stx:real;
begin
  MinY:=Y(MinX);
  MaxY:=Y(MaxX);
  Stx:=(MaxX-MinX)/(GetMaxX+1-2*GrX);     {Шаг по Х при построении }
  K:=MinX;
  repeat
    k:=k+Stx;
    if Y(k)>MaxY then
      MaxY:=Y(k);
    if Y(k)<MinY then
      MinY:=Y(k);
  until K>=MaxX;
  if @Y = @Func1 then
    T1 := True
   else
   T2:=True;
end;
procedure EnterInterval(var MinX,MaxX:real);

begin
    RestorecrtMode;
  clrscr;
  WriteLn('MinX=');
  ReadLn(MinX);                   { m:=round((Z1-MINZ1)*71/(MAXZ1-MINZ1));}
    WriteLn('MaxX=');
    ReadLn(MaxX);
    SetGraphMode(Mode);
end;

procedure DrawGraph(Y:Funct; Color:word; MinX,MaxX, MinY,MaxY:real);
const
  n=10;
  MaxConst=1e+4;
var
  k,F,Stx:real;
  Xc,Yc:Integer;
begin
  SetLineStyle(0,0,1);
  SetColor(Color);
  K:=MinX;
  if MinY=MaxY then
  begin
    MinY:=MinY-N;
    MaxY:=MaxY+N;
  end;
{  if MinY<-MaxConst then
    MinY:=-MaxConst/N;
  if MaxY>MaxConst then
    MaxY:=MaxConst/N;}
  Stx:=(MaxX-MinX)/(GetMaxX-2*GrX+1);
  repeat
     Line(Round((K-MinX)/(MaxX-MinX)*(GetMaxX-2*GrX))+GrX,
       GetMaxY-GrY2-Round((Y(K)-MinY)/(MaxY-MinY)*(GetMaxY-GrY1-GrY2)),
       Round((K+Stx-MinX)/(MaxX-MinX)*(GetMaxX-2*GrX))+GrX,
       GetMaxY-GrY2-Round((Y(K+Stx)-MinY)/(MaxY-MinY)*(GetMaxY-GrY1-GrY2)));
  k:=k+Stx;
  until k>=MaxX;
  SetLineStyle(0,0,0);
  SetColor(0);
end;

procedure DrawAxis(MinX,MaxX,MinY,MaxY:real);
const
  N=10;
begin
  SetLIneStyle(0,0,0);
  SetColor(0);
    if MinY=MaxY then
  begin
    MinY:=MinY-N;
    MaxY:=MaxY+N;
  end;
  if (MinX<0)and(MaxX>0) then
  begin
  Line (Round((-MinX)/(MaxX-MinX)*(GetMaxX-2*GrX))+GrX,
  GrY1,Round((-MinX)/(MaxX-MinX)*(GetMaxX-2*GrX))+GrX,
    GetMaxY-GrY2);
  if Round((-MinX)/(MaxX-MinX)*(GetMaxX-2*GrX))+GrX+5<=GetMaxX-GrX then
    LIne(Round((-MinX)/(MaxX-MinX)*(GetMaxX-2*GrX))+GrX,GrY1,
  Round((-MinX)/(MaxX-MinX)*(GetMaxX-2*GrX))+GrX+5,GrY1 +10 );
  if Round((-MinX)/(MaxX-MinX)*(GetMaxX-2*GrX))+GrX-5 >=GrX then
    LIne(Round((-MinX)/(MaxX-MinX)*(GetMaxX-2*GrX))+GrX,GrY1,
  Round((-MinX)/(MaxX-MinX)*(GetMaxX-2*GrX))+GrX-5,GrY1 +10 );
  end;
  if (MinY<0)and(MaxY>0) then
  begin
  Line(GrX,GetMaxY-GrY2-Round((-MinY)/(MaxY-MinY)*(GetMaxY-GrY1-GrY2)),
  GetMaxX-GrX,GetMaxY-GrY2-Round((-MinY)/(MaxY-MinY)*(GetMaxY-GrY1-GrY2)));
  Line(GetMaxX-GrX,GetMaxY-GrY2-Round((-MinY)/(MaxY-MinY)*(GetMaxY-GrY1-GrY2)),
    GetMaxX-GrX-10,GetMaxY-GrY2-Round((-MinY)/(MaxY-MinY)*(GetMaxY-GrY1-GrY2))-5);
    Line(GetMaxX-GrX,GetMaxY-GrY2-Round((-MinY)/(MaxY-MinY)*(GetMaxY-GrY1-GrY2)),
    GetMaxX-GrX-10,GetMaxY-GrY2-Round((-MinY)/(MaxY-MinY)*(GetMaxY-GrY1-GrY2))+5);
   end;

  end;
{-----------------------------------------------------------}

procedure FindPeregib( MinX,MaxX:real; Y:Funct );
const
  Eps=1e-4;
  h=1e-2;
  Rad=4;
  Ksi=1e-2;
  Psi=10;
var
  Stx,a,b,r,c{,SPr1,SPr2},p,m,n:real;
  Bool:Boolean;
begin
  SetColor(2);
  a:=MinX;
  Stx:=(MaxX-MinX)/(GetMaxX-2*GrX+1);
  repeat
    Bool:=False;                         { Выражение второй производной }
    b:=a+Stx;                            { через функцию }
   r:=(Y(a+h)+Y(a-h)-2*Y(a))/Sqr(h);     {  см. ниже }
   c:=(Y(b+h)+Y(b-h)-2*Y(b))/Sqr(h);
    if (Y(a+h)+Y(a-h)-2*Y(a))/Sqr(h)*(Y(b+h)+Y(b-h)-2*Y(b))/Sqr(h) <= 0 then
    begin
    m:=a;
    n:=b;
    repeat
    p:=(m+n)/2;
    if (Y(p+h)+Y(p-h)-2*Y(p))/Sqr(h)*(Y(m+h)+Y(m-h)-2*Y(m))/Sqr(h)<=0 then
      n:=p
    else
        m:=p;
  until Abs(m-n) < Eps;
  Bool:=True;
   end;
   if Bool then
  Circle(Round((n-MinX)/(MaxX-MinX)*(GetMaxX-2*GrX))+GrX,
  GetMaxY-GrY2-Round((Y(n)-MinY)/(MaxY-MinY)*(GetMaxY-GrY1-GrY2)),Rad);
    a:=a+Stx;
  until a>=MaxX;
  SetColor(0);
end;
{-----------------------------------------------------------}
procedure MoveGraph(MinX,MaxX,MinY,MaxY:real;t1,t2,b:Boolean);
const
  f=100;
var

  n:byte;
  Step:real;
begin
  Step:=f*(MaxX-MinX)/(GetMaxX-2*GrX+1);
  n:=1;
    repeat

     if Keypressed then
       begin
     SetActivePage(n);
    ClearDevice;
         SetFillStyle(1,7);
      Bar(0,0,GetMaxX,GetMaxY);
  SetFillStyle(1,white);
  Bar(GrX,GrY1,GetMaxX-GrX,GetMaxY-GrY2);
  RamkaIn(GrX,GrY1,GetMaxX-GrX,GetMaxY-GrY2,0,15);
  SetFillStyle(1,7);
    if b then drawgrid(sx,sy,t1,t2);
      c:=readkey;
      if c=#0 then
        c:=readkey;
      case c of
      #75:
        begin
          MinX:=MinX-Step;
          MaxX:=MaxX-Step;
          if t1 then
          DrawGraph(func1,1,MinX,MaxX,MinY,MaxY)
          else
          DrawGraph(func2,4,MinX,MaxX,MinY,MaxY);
          DrawAxis(MinX,MaxX,MInY,MaxY);
        end;
      #77:
        begin
          MinX:=MinX+Step;
          MaxX:=MaxX+Step;
          if t1 then
          DrawGraph(func1,1,MinX,MaxX,MinY,MaxY)
          else
          DrawGraph(func2,4,MinX,MaxX,MinY,MaxY);
          DrawAxis(MinX,MaxX,MInY,MaxY);
        end;
      end;
      SetVisualPage(n);
         n:=(n+1) mod 2;
      end;
    until c=#27;
end;
{-----------------------------------------------------------}
begin
  Driver:=VGA;
  Mode:=VGAMED;
  InitGraph(Driver,Mode,'c:\tp');
  GetAspectRatio(xa,ya);
  ra:=xa/ya;
   T1:=false;
    T2:=false;
               RestoreCrtMode;
          Write('Искать перегибы ?  y/n');
          ReadLn(ch);
          SetGraphMode(Mode);
 repeat

     SetFillStyle(1,7);
      Bar(0,0,GetMaxX,GetMaxY);
  SetFillStyle(1,white);
  Bar(GrX,GrY1,GetMaxX-GrX,GetMaxY-GrY2);
  SetLineStyle(0,0,1);
  RamkaIn(GrX,GrY1,GetMaxX-GrX,GetMaxY-GrY2,0,15);
  SetLineStyle(0,0,0);
  SetFillStyle(1,7);
    if b then drawgrid(sx,sy,t1,t2);
    if t1  then
         begin
         DrawGraph(func1,1,MinX,MaxX,MinY,MaxY);
         DrawAxis(MinX,MaxX,MInY,MaxY);
           if (ch='y')and(MinY<>MaxY) then
             FindPeregib(MinX,MaxX,Func1);
         end;
         if t2 then
         begin
          DrawGraph(func2,4,MinX,MaxX,MinY,MaxY);
            DrawAxis(MinX,MaxX,MInY,MaxY);
              if (ch='y')and(MinY<>MaxY) then
             FindPeregib(MinX,MaxX,Func2);
          end;
       Menu(m);
      case m of
       1:
       begin
         EnterInterval(MinX,MaxX);
         MinMax(MinX,MaxX,MinY,MaxY,Func1,T1,T2);
         T2:=False;
       end;
       2:
      { begin
            EnterInterval(MinX,MaxX);
         MInMax(MinX,MaxX,MinY,MaxY,Func1,T1,T2);
         mn:=MinY;
         Mx:=MaxY;
              MInMax(MinX,MaxX,MinY,MaxY,Func2,T1,T2);
          if mn<MInY then
            MinY:=mn;
          if Mx>MaxY then
           MaxY:=Mx;
       end; }

       MoveGraph(MinX,MaxX,MinY,MaxY,t1,t2,b);

       3:
       begin
        EnterInterval(MinX,MaxX);
       MInMax(MinX,MaxX,MinY,MaxY,Func2,T1,T2);
       T1:=False;

       end;
       4:
       begin
       EnterGrid(sx,sy,b);
       end;
     end;
  until m=5;
end.
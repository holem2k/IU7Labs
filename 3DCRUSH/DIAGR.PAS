Program Diagramma;
uses Graph,Crt;
const
  Xc=320;
  Yc=200;
  Xra=100;
  Yra=50;
  NN=20;
  Thick=30;
  FirstAngle=90;
var
  Driver,Mode,n,k:Integer;
  F:Text;
  Sum,All:real;
  A:array [0..NN] of Real;

{--------------------------------------------------------}

procedure Cake(B:array of Real;Sum:Real;var k:Integer;StartAngle:Word);
var
  i,j:Byte;
  Angle,LastAngle:Word;
  Ar:ArcCoordsType;
begin
  for j:=Thick downto 0 do
    begin
      Angle:=StartAngle;
      for i:=0 to K do
        begin
          SetFillStyle(1,i+1);
          SetColor(i+1);
          LastAngle:=Angle;
          Angle := Angle+Round(B[i]/Sum*360);
          if Angle > 360  then
            begin
              Angle:=Angle-360;
              Sector(Xc,Yc+j,LastAngle, 360  ,Xra,Yra);
              Sector(Xc,Yc+j,0, Angle ,Xra,Yra);
            end
          else
            begin
              if (Angle > StartAngle) and (i=k) then Angle:=StartAngle;
              Sector(Xc,Yc+j,LastAngle, Angle  ,Xra,Yra);
            end;
        end;
    end;
  Angle:=StartAngle;
  for i:=0 to K do
    begin
      LastAngle:=Angle;
      Angle := Angle+Round(B[i]/Sum*360);
      if (Angle > StartAngle) and (i=k) then Angle := StartAngle;
      Ellipse(Xc,Yc,LastAngle,Angle,Xra,Yra);
      GetArcCoords(Ar);
      Line(Xc,Yc,Ar.xstart,Ar.ystart);
      Line(Xc,Yc,Ar.xend,Ar.yend);
      if Ar.Ystart>=Yc then
        Line(Ar.XStart,Ar.Ystart,Ar.XStart,Ar.Ystart+Thick);
      if Ar.Yend>=Yc then
        Line(Ar.Xend,Ar.Yend,Ar.Xend,Ar.Yend+Thick);
    end;
  Ellipse(Xc,Yc+Thick,180,360,Xra,Yra);
end;

{--------------------------------------------------------}
procedure CakeRound;
const
  Delta=20;
var
  Angle:Word;
begin
  Angle:=FirstAngle;
  repeat
    Angle:=(Angle+Delta) mod 360;
    Cake(A,Sum,k,Angle);
  until KeyPressed;;
end;
{--------------------------------------------------------}
begin
  Assign(F,'c:\Cake.txt');
  Driver:=Detect;
  InitGraph(Driver,Mode,'c:\tp');
  k:=-1;
  Sum:=0;
  Reset(F);
  While not Eof(F) do
    begin
      ReadLn(F,n);
      Sum:=Sum+n;
      inc(k);
      A[k]:=n;
    end;
  Close(F);
  Cake(A,Sum,k,FirstAngle);
  ReadLn;
  CakeRound;
end.
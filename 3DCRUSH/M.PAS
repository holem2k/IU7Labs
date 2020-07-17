program Mandel;
uses CRT, Graph;

const
     maxcol = 640;
     maxrow = 200;
     max_colors = 16;
     max_iterations = 24;
     max_size = 4;

var
   Q    :   array[0..349] of real;
   XMax,YMax,XMin,YMin : real;
   P,deltaP,deltaQ,X,Y,Xsquare,Ysquare : real;
   i,color,row,col,GraphDriver,GraphMode : integer;
   ch : char;

begin
     XMax := 1.2;
     XMin := -2.0;
     YMax := 1.2;
     YMin :=-1.2;
     GraphDriver := EGA;
     GraphMode := EGALo;
     InitGraph(GraphDriver,GraphMode,'c:\tp');
     deltaP := (XMax - XMin)/(maxcol);
     deltaQ := (YMax - Ymin)/(maxrow);
     Q[0] := YMax;
     for row := 1 to maxrow do
         Q[row] := Q[row-1] - deltaQ;
     P := XMin;
     for col := 0 to maxcol do
     begin
          if Keypressed then
             exit;
          for row := 0 to maxrow do
          begin
               X := 0.0;
               Y := 0.0;
               Xsquare := 0.0;
               Ysquare := 0.0;
               color := 1;
               repeat
                     Xsquare := X*X;
                     Ysquare := Y*Y;
                     Y := 2*X*Y + Q[row];
                     X := Xsquare - Ysquare + P;
                     inc(color);
               until (color>=max_iterations) OR (Xsquare + Ysquare >= max_size);
               PutPixel(col,row,(color MOD max_colors));
          end;
          P := P + deltaP;
     end;
     ch := ReadKey;
end.

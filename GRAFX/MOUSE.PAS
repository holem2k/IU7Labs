unit Mouse;
interface
function InitMouse: Boolean;
procedure ShowMouse;
procedure HideMouse;
function GetMouse(var x, y: Integer; var Left, Right: Boolean): Boolean;
implementation
uses Dos;
var
   R: Registers;

function InitMouse: Boolean;
begin
  R.AX := $0;
  Intr( $33, R );
  if R.AX = $FFFF then InitMouse:= True
 else InitMouse := False;
end;

procedure ShowMouse;
begin
  R.AX := $01;
  Intr( $33, R );
end;

procedure HideMouse;
begin
  R.AX := $02;
  Intr( $33, R );
end;

function GetMouse(var x, y: Integer; var Left, Right: Boolean): Boolean;
begin
  R.AX := 3;
  Intr($33, R);
  x := R.CX;
  y := R.DX;
  Left := (R.BX and $01) <> 0;
  Right := (R.BX and $02) <> 0;
  GetMouse := Left or Right;
{  Left := false;
  Right := false;
  GetMouse :=  false;}
end;

end.
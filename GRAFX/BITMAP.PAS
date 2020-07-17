unit BitMap;
interface
type
   tFileHeader = record
    Bm: word;
    FileSize: longint;
    Reserved1: word;
    Reserved2: word;
    ImageOfs: longint;

    HeaderSize: longint;
    Width: longint;
    Height: longint;
    Planes: word;
    BitPix: word;
    ComressType: longint;
    ComressedSize: longint;
    HorResolution: longint;
    VerResolution: longint;
    UsedColors: longint;
    ImpColors: longint;
   end;

   tPaletElem = record
    Blue: byte;
    Green: byte;
    Red: byte;
   end;

  tBitMap = object
   pBM: pointer;
   pPal: pointer;
   sPath: string;
   Info: tFileHeader;
   Loaded: boolean;
   procedure LoadFromFile(path: string;var code: byte);
   procedure Draw(x,y: word);
   procedure AdjustPalette;
   procedure Free;
   function  HandleError(NumError: byte): string;

   public
   RealColors: byte;
   MemForBM: longint;
   MemForPal: longint;
   procedure TestBitMap(var code:byte);
  end;

implementation
uses crt,graph;
type
  tpBM = array [1..65519] of byte;
  tpPal = array [1..256] of tPaletElem;

procedure tBitMap.TestBitMap;
var
  FileHead: file of tFileHeader;
begin
{$I-}
 code:=0;
 Assign(FileHead,sPath);
 Reset(FileHead);
 if FileSize(FileHead)<1 then code:=200;        { Размеp Файла слишком мал }
 Read(FileHead,Info);
 if IoResult<>0 then begin
                      code:=IoResult;
                      Exit;
                     end;
 Close(FileHead);
{$I+,B-}
with Info do begin
if (Bm<>19778) or
   (HeaderSize<>40) or
   (Planes<>1) or
   (BitPix<>4) or
   (ComressType<>0) then code:=201                    {  Файл-не pисунок BMP }
 end;
end;

procedure tBitMap.LoadFromFile;
var
  BmFile: file of byte;
  a,b,res,RealCol: byte;
  i,j,poss: word;
  PalElem: tPaletElem;
begin
 sPath:=path;
 TestBitMap(code);
 if code<>0 then Exit;
{$I-}
 Assign(BmFile,path);
 Reset(BmFile);
 with Info do begin
  Seek(BmFile,ImageOfs);
  MemForBM:=Width*Height;
  if odd(Width) then MemForBM:=MemForBM+Height;
  if MaxAvail>=MemForBM then GetMem(pBM,MemForBM)
                           else
                             begin
                              code:=202;              { Hедостаточно памяти }
                              Exit;
                             end;
  poss:=1;
  for i:=1 to  Height do
   begin
    for j:=1 to Round(Width/2)  do
     begin
      Read(BmFile,a);
      b:=a;
      a:=a shr 4;
      b:=b and $f;
      tpBM(pBM^)[poss]:=a;
      inc(poss);
      tpBM(pBM^)[poss]:=b;
      inc(poss);
     end;
    while ((FilePos(BmFile)-ImageOfs) mod 4)<> 0 do Read(BmFile,a);
   end;
 if UsedColors=0 then RealColors:=16 else RealColors:=UsedColors;
 MemForPal:=RealColors*3;
 if MaxAvail>=MemForPal then GetMem(pPal,MemForPal)
                           else
                             begin
                              code:=202;              { Hедостаточно памяти }
                              Exit;
                             end;
  Seek(Bmfile,54);
  for i:=1 to RealColors do
    begin
     Read(Bmfile,PalElem.Blue,PalElem.Green,PalElem.Red,res);
     PalElem.Blue:=PalElem.Blue shr 2;
     PalElem.Green:=PalElem.Green shr 2;
     PalElem.Red:=PalElem.Red shr 2;
     tpPal(pPal^)[i]:=PalElem;
    end;
 end;
 close(Bmfile);
{$I+}
 code:=IoResult;
 Loaded:=TRUE;
end;

procedure tBitMap.Draw;
{$R-,S-}
var
 i,j,poss: word;
begin
with Info do begin
 poss:=1;
 for i:=Height downto 1 do
  begin
   for j:=1 to Width  do
    begin
     PutPixel(x+j-1,y+i-1,tpBM(pBM^)[poss]);
     inc(poss);
    end;
   if odd(Width) then inc(poss);
  end;
end;
end;

procedure tBitMap.AdjustPalette;
var
  pal: tPaletElem;
  i: byte;
begin
for i:=1 to RealColors do
  begin
   Pal:=tpPal(pPal^)[i];
   SetRGBPalette(i-1,Pal.Red,Pal.Green,Pal.Blue);
  end;
end;

procedure tBitMap.Free;
begin
 with Info do begin
  FreeMem(pBM,MemForBM);
  FreeMem(pPal,MemForPal);
 end;
 Loaded:=FALSE;
end;

function  tBitMap.HandleError(NumError: byte): string;
begin
 case NumError of
  200: HandleError:='Размеp файла слишком мал';
  201: HandleError:='Файл - не pисунок BMP';
  202: HandleError:='Hедостаточно памяти';
 end;
end;

end.
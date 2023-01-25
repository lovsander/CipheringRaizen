unit Unit1;

{$mode objfpc}{$H+}
{$ASMMODE INTEL}
interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Spin;

type
  tdatablock = array [0..1] of longword;
type
  pdatablock = ^Tdatablock;
type
  t2datablock = array [0..1] of tdatablock;
type
  p2datablock = ^T2datablock;
type
  tkeyblock = array [0..3] of longword;
type
  pkeyblock = ^Tkeyblock;


type

  { TForm1 }

  TForm1 = class(TForm)
    RaidenKeysToRSA: TButton;
    findE: TButton;
    Panel3: TPanel;
    rsa_d: TFloatSpinEdit;
    powersDe: TButton;
    powers: TButton;
    RSA_test: TButton;
    GroupBox1: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    newmasterkey: TButton;
    printmasterkey: TButton;
    clear: TButton;
    masterkey: TEdit;
    fromArr: TButton;
    Label1: TLabel;
    Labellen: TLabel;
    Panel1: TPanel;
    hexview: TRadioButton;
    decview: TRadioButton;
    Panel2: TPanel;
    rsa_f: TSpinEdit;
    rsa_n: TSpinEdit;
    rsa_p: TSpinEdit;
    rsa_e: TSpinEdit;
    rsa_k: TSpinEdit;
    rsa_s: TSpinEdit;
    rsa_m: TSpinEdit;
    rsa_crypt: TSpinEdit;
    rsa_decrypt: TSpinEdit;
    taillbl: TLabel;
    trystr: TButton;
    ButtonCode: TButton;
    ButtonDecode: TButton;
    coded1: TEdit;
    inpStr: TEdit;
    inp: TEdit;
    coded: TEdit;
    inp1: TEdit;
    decstr: TEdit;
    Memo1: TMemo;
    out: TEdit;
    k1: TEdit;
    k2: TEdit;
    k3: TEdit;
    k4: TEdit;
    out1: TEdit;
    procedure ButtonCodeClick(Sender: TObject);
    procedure ButtonDecodeClick(Sender: TObject);
    procedure clearClick(Sender: TObject);
    procedure findEClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure fromArrClick(Sender: TObject);
    procedure powersClick(Sender: TObject);
    procedure powersDeClick(Sender: TObject);
    procedure printmasterkeyClick(Sender: TObject);
    procedure k1Change(Sender: TObject);
    procedure crypt (Data: tdatablock; var Result: tdatablock; key: pkeyblock);
    procedure decrypt (Data: tdatablock; var Result: tdatablock; key: pkeyblock);
    procedure Memo1Change(Sender: TObject);
    procedure newmasterkeyClick(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure RaidenKeysToRSAClick(Sender: TObject);
    procedure rsa_eChange(Sender: TObject);
    procedure RSA_testClick(Sender: TObject);
    procedure trystrClick(Sender: TObject);
    procedure Piece8bitToDataBlock(s:string; var Result: tdatablock);
    function keygen: DWord;
    function PowerModul(Base, Power, Modul: Integer): Integer;
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}
// for noise gen  sam707
type
  TRndRec = record
    state, Inc: QWord;
  end;

var
   arrResult: array of tdatablock;     // for Raiden cipher
   RndRec: TRndRec;  // for noise gen

(*************************************************************************
Raiden cipher pascal port
32 rounds edition
(c) 2009 Alexander Myasnikow
Web: www.darksoftware.narod.ru
**************************************************************************)



  procedure TForm1.crypt (Data: tdatablock; var Result: tdatablock; key: pkeyblock);
  var
    b0: longword;
    b1: longword;
    i:  longword;
    sk: array [0..31] of longword;
    k:  tkeyblock;
  begin

    b0 := Data[0];
    b1 := Data[1];

    move(key^, k[0], 16);


    for I := 0 to 31 do
      begin
      k[i mod 4] := ((k[0] + k[1]) + ((k[2] + k[3]) xor (k[0] shl k[2])));
      sk[i] := k[i mod 4];
      end;

    for i := 0 to 31 do
      begin
      b0 := b0 + (((sk[i] + b1) shl 9) xor ((sk[i] - b1) xor ((sk[i] + b1) shr 14)));
      b1 := b1 + (((sk[i] + b0) shl 9) xor ((sk[i] - b0) xor ((sk[i] + b0) shr 14)));
      end;

    Result[0] := b0;
    Result[1] := b1;

  end;


  procedure TForm1.decrypt (Data: tdatablock; var Result: tdatablock; key: pkeyblock);
  var
    b0: longword;
    b1: longword;
    i:  longword;
    sk: array [0..31] of longword;
    k:  tkeyblock;
  begin

    b0 := Data[0];
    b1 := Data[1];

    move(key^, k[0], 16);


    for I := 0 to 31 do
      begin
      k[i mod 4] := ((k[0] + k[1]) + ((k[2] + k[3]) xor (k[0] shl k[2])));
      sk[i] := k[i mod 4];
      end;

    for i := 31 downto 0 do
      begin
      b1 := b1 - (((sk[i] + b0) shl 9) xor ((sk[i] - b0) xor ((sk[i] + b0) shr 14)));
      b0 := b0 - (((sk[i] + b1) shl 9) xor ((sk[i] - b1) xor ((sk[i] + b1) shr 14)));
      end;
    Result[0] := b0;
    Result[1] := b1;

  end;

procedure TForm1.Memo1Change(Sender: TObject);
begin

end;



procedure TForm1.Panel1Click(Sender: TObject);
begin

end;



procedure TForm1.rsa_eChange(Sender: TObject);
begin

end;



  { TForm1 }

  procedure TForm1.k1Change(Sender: TObject);
  begin
  end;

procedure TForm1.ButtonCodeClick(Sender: TObject);
  var
    Data: tdatablock;
    Result: tdatablock;
    key: tkeyblock ;
    k:pkeyblock;
    doo :Longint;
    posle:Longint;
  begin
        Data[0]:= StrToInt64(inp.Text);
        Data[1]:= StrToInt64(inp1.Text);

        key[0] := StrToInt64(k1.Text);
        key[1] := StrToInt64(k2.Text);
        key[2] := StrToInt64(k3.Text);
        key[3] := StrToInt64(k4.Text);

        k:=@key;

        //doo:=GetTickCount;
       crypt(Data,Result,k);
       //posle:=GetTickCount-doo;

       //memo1.lines.add(inttostr(posle));
       coded.Text:= IntToStr(Result[0]);
       coded1.Text:=IntToStr(Result[1]);
end;

procedure TForm1.ButtonDecodeClick(Sender: TObject);
    var
      Data: tdatablock;
      var Result: tdatablock;
      key: tkeyblock ;
      k:pkeyblock;
    begin
          Data[0]:= StrToInt64(coded.Text);
          Data[1]:= StrToInt64(coded1.Text);

          key[0] := StrToInt64(k1.Text);
          key[1] := StrToInt64(k2.Text);
          key[2] := StrToInt64(k3.Text);
          key[3] := StrToInt64(k4.Text);

          k:=@key;
         decrypt(Data,Result,k);

         out.Text:= IntToStr(Result[0]);
         out1.Text:=IntToStr(Result[1]);
end;

procedure TForm1.clearClick(Sender: TObject);
begin
  memo1.lines.Clear;
end;



procedure TForm1.FormCreate(Sender: TObject);
begin

end;

 procedure TForm1.trystrClick(Sender: TObject);
 var
 str,s:string;
 i,len,ri,rlen,adds,tail:integer;
 Result: tdatablock;

 begin
 Panel1.Color:=clGray;
       str:= inpStr.Text;
       Labellen.caption:=inttostr(length(str));
       tail:= length(str)  mod 8;
       taillbl.caption:=inttostr(tail);
         if tail <> 0 then
            begin
            for i := tail to 8-1 do str := str +' ';
            end;

         //inpStr.Text:= str;
         len:=length(str);

       ri:=0;
       for i := 1 to len do
       begin
         s := s + str[i];
         //memo1.lines.add(s);
         if (i mod 8=0) then begin
         // memo1.lines.add( IntToStr(i) + ' symbols');
         Piece8bitToDataBlock(s,Result);
         inc(ri);
         setLength(arrResult, ri);
         arrResult[ri-1]:= Result;
         if hexview.Checked then
         memo1.lines.add( IntToHex(Result[0],8) + ' ' + IntToHex(Result[1],8) )
         else
         memo1.lines.add( IntTostr(Result[0]) + ' ' + IntTostr(Result[1]) ) ;
         s:='';
         end;
       end;


end;

procedure TForm1.Piece8bitToDataBlock(s:string; var Result: tdatablock);
var
Data: tdatablock;
key: tkeyblock ;
k:pkeyblock;
b: array [0..8] of byte;
i: integer;
lw1,lw2: longword;

begin

      for i := 0 to 8-1 do
      begin
           b[i]:= ord(s[i+1]);
           //memo1.lines.add(inttostr(b[i]));
      end;

      lw1:=0;
      lw1:=lw1 + b[0] shl (3*8);
      lw1:=lw1 + b[1] shl (2*8);
      lw1:=lw1 + b[2] shl 8;
      lw1:=lw1 + b[3] ;

      lw2:=0;
      lw2:=lw2 + b[4] shl (3*8);
      lw2:=lw2 + b[5] shl (2*8);
      lw2:=lw2 + b[6] shl 8;
      lw2:=lw2 + b[7] ;

      Data[0]:= lw1;
      Data[1]:= lw2;

      key[0] := StrToInt64(k1.Text);
      key[1] := StrToInt64(k2.Text);
      key[2] := StrToInt64(k3.Text);
      key[3] := StrToInt64(k4.Text);

      k:=@key;
      crypt(Data,Result,k);
      //memo1.lines.add( IntToStr(Data[0]) + ' -> ' +IntToStr(Result[0]) + ' | '+ IntToStr(Data[1]) + ' -> ' +IntToStr(Result[1]));

end;

procedure TForm1.fromArrClick(Sender: TObject);
var
Data,Result: tdatablock;
key: tkeyblock ;
k:pkeyblock;
cb: array [0..8] of byte;
ri,i,rlen,lenBeforeAdd: integer;
lw1,lw2: longword;
 cs:string;
 charArr: array of char;
begin
    decstr.caption :='';
      //memo1.lines.add('');
      key[0] := StrToInt64(k1.Text);
      key[1] := StrToInt64(k2.Text);
      key[2] := StrToInt64(k3.Text);
      key[3] := StrToInt64(k4.Text);
      k:=@key;

       rlen:=length(arrResult);
    for ri := 0 to rlen-1 do
     begin
       Result := arrResult[ri];
       decrypt(Result,Data,k);
       //memo1.lines.add( IntToStr(Data[0]) + ' <- ' +IntToStr(Result[0]) + ' | '+ IntToStr(Data[1]) + ' <- ' +IntToStr(Result[1]));

              //make decoded as string[8]
       cb[0]:= ($FF000000 and Data[0]) shr (3*8);
       cb[1]:= ($00FF0000 and Data[0]) shr (2*8);
       cb[2]:= ($0000FF00 and Data[0]) shr 8;
       cb[3]:= ($000000FF and Data[0]);

       cb[4]:= ($FF000000 and Data[1]) shr (3*8);
       cb[5]:= ($00FF0000 and Data[1]) shr (2*8);
       cb[6]:= ($0000FF00 and Data[1]) shr 8;
       cb[7]:= ($000000FF and Data[1]);

       cs:='';
       lenBeforeAdd:= length(charArr);
       setLength(charArr,lenBeforeAdd + 8);
       for i := 0 to 8-1 do
       begin
         charArr[lenBeforeAdd +i] := chr(cb[i]);
            //cs:=cs+chr(cb[i]);
            //memo1.lines.add(inttostr(cb[i]));
       end;
        //memo1.lines.add(cs);
        //decstr.caption :=  decstr.caption + cs;
     end;

     for i := 0 to length(charArr)-1 do
       begin
        cs:=cs+charArr[i];
       end;
     decstr.caption :=  cs;
     decstr.caption :=  trim(decstr.caption);
     if  decstr.caption = inpStr.Caption then  Panel1.Color:=clLime else  Panel1.Color:=clred;

end;



procedure TForm1.printmasterkeyClick(Sender: TObject);
var
b,cb: array [0..15] of byte;
i: integer;
lw1,lw2,lw3,lw4: longword;
cs:string;
charArr: array [0..15] of char;
begin
     if length( masterkey.Text) <> 16 then exit;

      for i := 0 to 16-1 do
      begin
           b[i]:= ord(masterkey.Text[i+1]);
      end;

      lw1:=0;
      lw1:=lw1 + b[0] shl (3*8);
      lw1:=lw1 + b[1] shl (2*8);
      lw1:=lw1 + b[2] shl 8;
      lw1:=lw1 + b[3] ;

      lw2:=0;
      lw2:=lw2 + b[4] shl (3*8);
      lw2:=lw2 + b[5] shl (2*8);
      lw2:=lw2 + b[6] shl 8;
      lw2:=lw2 + b[7] ;

      lw3:=0;
      lw3:=lw3 + b[8] shl (3*8);
      lw3:=lw3 + b[9] shl (2*8);
      lw3:=lw3 + b[10] shl 8;
      lw3:=lw3 + b[11] ;

      lw4:=0;
      lw4:=lw4 + b[12] shl (3*8);
      lw4:=lw4 + b[13] shl (2*8);
      lw4:=lw4 + b[14] shl 8;
      lw4:=lw4 + b[15] ;

      memo1.lines.add(masterkey.Text+' '+ IntTostr(lw1) + ' ' + IntTostr(lw2) +' '+  IntTostr(lw3) + ' ' + IntTostr(lw4)) ;

       cb[0]:= ($FF000000 and lw1) shr (3*8);
       cb[1]:= ($00FF0000 and lw1) shr (2*8);
       cb[2]:= ($0000FF00 and lw1) shr 8;
       cb[3]:= ($000000FF and lw1);

       cb[4]:= ($FF000000 and lw2) shr (3*8);
       cb[5]:= ($00FF0000 and lw2) shr (2*8);
       cb[6]:= ($0000FF00 and lw2) shr 8;
       cb[7]:= ($000000FF and lw2);

       cb[8]:= ($FF000000 and lw3) shr (3*8);
       cb[9]:= ($00FF0000 and lw3) shr (2*8);
       cb[10]:= ($0000FF00 and lw3) shr 8;
       cb[11]:= ($000000FF and lw3);

       cb[12]:= ($FF000000 and lw4) shr (3*8);
       cb[13]:= ($00FF0000 and lw4) shr (2*8);
       cb[14]:= ($0000FF00 and lw4) shr 8;
       cb[15]:= ($000000FF and lw4);

       for i := 0 to 16-1 do
       begin
         charArr[i] := chr(cb[i]);
       end;
       cs:='';
       for i := 0 to length(charArr)-1 do
       begin
        cs:=cs+charArr[i];
       end;
       if cs=masterkey.Text  then  Panel2.Color:=clLime else  Panel2.Color:=clred;
end;




function TForm1.keygen: DWord; (* pseudoNoisy sausage follows *)

function QuickRand(IncSeed: QWord = 1): DWord;
var
  oldstate: QWord;
  tmp0, tmp1: DWord;
begin
  oldstate := RndRec.state;
  RndRec.Inc := IncSeed;
  RndRec.state := oldstate * 6364136223846793005 + (RndRec.Inc or 1);
  tmp0 := ((oldstate shr 18) xor oldstate) shr 27;
  tmp1 := oldstate shr 59;
  Result := (tmp0 shr tmp1) or (tmp0 shl ((-tmp1) and 31));
end;

var
  r: DWord;
  s: cardinal;
  i: integer;
begin
{ following if..then breaks the 'period' by random jumps ahead }
  if random(1023)< 321 then { adjustable }
    s := 1
  else
    s := succ(random(14));
  if random(255) > (15+random(17)) then { adjustable }
    r := QuickRand
  else
    r := QuickRand(s);
  //Edit1.Text := Format('%U', [r]);
  result:=r;
end;


procedure TForm1.newmasterkeyClick(Sender: TObject);

function dwordtoascii(var dw: DWord) : string;
function rangeChar(c:byte):byte;
begin
       if (c >=159) then c:=c-126;
       if (c >126) and (c <159) then c:=c-126+33;
       if (c <33) then c:=c+33;

       result:=c;
end;

var
  cb: array [0..15] of byte;
  i: integer;
  cs:string;
  c:byte;
  begin
       cb[0]:= ($FF000000 and dw) shr (3*8);
       cb[1]:= ($00FF0000 and dw) shr (2*8);
       cb[2]:= ($0000FF00 and dw) shr 8;
       cb[3]:= ($000000FF and dw);
       cs:='';
       for i := 0 to 3 do begin
       c:=cb[i];
       c:=rangeChar(c);
       cs:=cs+chr(c);

       //memo1.lines.add(inttostr(cb[i])+ ' ' + inttostr(c));
       end;
       //memo1.lines.add('');
       result:=cs;
end;

var
  r: array [0..3] of DWord;
  i: integer;
begin
  Panel2.Color:=clGray;

r[0] := keygen;

r[1] := keygen;

r[2] := keygen;

r[3] := keygen;


masterkey.text:='';
for i := 0 to 3 do masterkey.text := masterkey.text+dwordtoascii(r[i]);
k1.Text := Format('%U', [r[0]]);
k2.Text := Format('%U', [r[1]]);
k3.Text := Format('%U', [r[2]]);
k4.Text := Format('%U', [r[3]]);

end;


  procedure TForm1.RSA_testClick(Sender: TObject);



  var
  p,s,n,f,e,k,d,m:integer;
  powercrypt,powerdecrypt:int64;
begin
     Panel3.Color:=clgray;
     rsa_n.value:=rsa_p.value*rsa_s.value;
     rsa_f.value:=(rsa_p.value-1)*(rsa_s.value-1);
     rsa_d.value:=(rsa_k.value*rsa_f.value+1)/rsa_e.value;

end;

procedure TForm1.powersClick(Sender: TObject);
begin
     rsa_crypt.value:=PowerModul(rsa_m.value, rsa_e.value, rsa_n.value);
end;

procedure TForm1.powersDeClick(Sender: TObject);
begin
     rsa_decrypt.value:=PowerModul(rsa_crypt.value, round(rsa_d.value), rsa_n.value);
end;

function TForm1.PowerModul(Base, Power, Modul: Integer): Integer;
var i,c:integer;
begin
c:=1;
for i:=1 to Power do begin
    c:=(c*Base) mod Modul;
   // memo1.lines.add(IntTostr(c));
end;
result:=c;
//(f(29,1547,143))//=61
end;

procedure TForm1.findEClick(Sender: TObject);
var
ok:boolean;
begtime:int64;
begin
ok:=false;
  begtime:=gettickcount;
   rsa_e.value:=2;
    while ok<>true do begin
    rsa_e.value:=rsa_e.value+1;
    RSA_test.Click;
    ok := (rsa_d.value - round(rsa_d.value) = 0 );
    if gettickcount-begtime>10*1000 then begin
     Panel3.Color:=clRed ;
     Exit;
    end;
   end;
  Panel3.Color:=clLime ;
end;

procedure TForm1.RaidenKeysToRSAClick(Sender: TObject);
var
key:array [0..3] of longword;
rawb:array [0..15] of byte;
keyCoded: array[0..31] of byte;
pos,i:byte;
buf:integer;
begin
          key[0] := StrToInt64(k1.Text);
          key[1] := StrToInt64(k2.Text);
          key[2] := StrToInt64(k3.Text);
          key[3] := StrToInt64(k4.Text);
          pos:=0;
          for i := 0 to 3 do begin
              rawb[pos]:= ($FF000000 and key[i]) shr (3*8); inc(pos);
              rawb[pos]:= ($00FF0000 and key[i]) shr (2*8); inc(pos);
              rawb[pos]:= ($0000FF00 and key[i]) shr 8;     inc(pos);
              rawb[pos]:= ($000000FF and key[i]);           inc(pos);
          end;

          for i := 0 to 15 do begin
          buf:= PowerModul(rawb[i], rsa_e.value, rsa_n.value);
          keyCoded[i*2]:= ($FF00 and buf) shr 8;
          keyCoded[i*2+1]:= ($00FF and buf);

          memo1.lines.add(IntTostr(rawb[i])+' '+IntTostr(buf)+' '+IntTostr(keyCoded[i*2])+' '+IntTostr(keyCoded[i*2+1]));
          end;
end;

  initialization
  Randomize;
  RndRec.state := RandSeed + 6364136223846793005;
{ RandSeed is the value to pass to client for that
  last to retrieve same panquakes twoaster random values }


end.


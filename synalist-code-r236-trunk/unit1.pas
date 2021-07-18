unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,Synaser;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    ProgressBar1: TProgressBar;
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  ser: TBlockSerial;
begin
  ser := TBlockSerial.Create;
  try
    ser.Connect('COM1'); // write here Arduino COM port number (on linux it's something like '/dev/ttyUSB0')
    Sleep(250);
    ser.config(9600, 8, 'N', SB1, False, False);
    ser.SendString('on'); // button 2 should have 'off' here
  finally
    ser.free;
  end;
end;

end.


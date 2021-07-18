unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls, ExtCtrls, Menus, Synaser, Crt, ClipBrd;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    ListBox1: TListBox;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    PopupMenu1: TPopupMenu;
    ProgressBar1: TProgressBar;
    StaticText1: TStaticText;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public
    myDate: TDateTime;
    myHour, myMin, mySec, myMilli: word;
    myHourStr, myMinStr: string;
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
  ProgressBar1.Color := clBlue;
  ListBox1.Color := clDefault;
  ProgressBar1.position := ProgressBar1.Min + ProgressBar1.Step;
  ListBox1.Items.Add('[' + TimeToStr(Time) + ']' + '  ' + 'Starting synchronization!');
  ser := TBlockSerial.Create;
  try
    try
      ser.Connect(Form1.Edit1.Text);
      ProgressBar1.Position := ProgressBar1.Position + ProgressBar1.Step;
      Delay(1000);
      ser.config(9600, 8, 'N', SB1, False, False);
      ProgressBar1.Position := ProgressBar1.Position + ProgressBar1.Step;
      ListBox1.Items.Add('[' + TimeToStr(Time) + ']' + '  ' +
        'Порт: ' + ser.Device + '   Статус: ' + ser.LastErrorDesc +
        ' ' + IntToStr(ser.LastError));
      if (ser.LastError = 0) then
      begin
        Sleep(1500);
        ser.SendString(Trunc((Now - EncodeDate(1970, 1, 1)) * 24 * 60 * 60).toString);
        ProgressBar1.Position := ProgressBar1.Position + ProgressBar1.Step;
        ListBox1.Items.Add('[' + TimeToStr(Time) + ']' + 'Time sended:' +
          Trunc((Now - EncodeDate(1970, 1, 1)) * 24 * 60 * 60).toString);
        ProgressBar1.Position := ProgressBar1.Position + ProgressBar1.Step;
        ProgressBar1.Position := ProgressBar1.Max;
      end
      else
      begin
        ProgressBar1.Position := ProgressBar1.Max;
        ProgressBar1.Color := clRed;
        ListBox1.Items.Add('[' + TimeToStr(Time) + ']' +
          ' ERROR! Check device and port');
      end;
    except
      on E: Exception do
      begin
        ProgressBar1.Color := clRed;
        ListBox1.Items.Add('[' + TimeToStr(Time) + ']' + '  ' +
          E.ClassName + ' поднята ошибка, с сообщением : ' + E.Message);
      end;
    end;
  finally
    ser.Free;
  end;
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  Application.ProcessMessages; //добавьте эту строку
  edit1.Text := Clipboard.AsText;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  myDate := StrToDateTime(TimeToStr(Time));
  DecodeTime(myDate, myHour, myMin, mySec, myMilli);
  myHourStr := myHour.ToString;
  myMinStr := myMin.ToString;
  if myHour < 10 then
  begin
    myHourStr := '0' + myHour.ToString;
  end;
  if myMin < 10 then
  begin
    myMinStr := '0' + myMin.ToString;
  end;
  label1.Caption := myHourStr + ':' + myMinStr;
end;


end.

unit Unit3; // sport unit

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Unit1;

type

  { TForm3 }

  TForm3 = class(TForm)
    Button1: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit5: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1EditingDone(Sender: TObject);
    procedure ComboBox2EditingDone(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.lfm}

{ TForm3 }

procedure TForm3.Button1Click(Sender: TObject);
var
  s, fmt3, fmt4: String;
begin
  s:= Form1.LeftPart;
  fmt3:= '%5s';
  fmt4:= '%5s';
  s:= s + ' ' + Form1.myformat(trim(ComboBox1.Text), 'l', ' ', 11) + ' ';
  s:= s + Form1.myformat(trim(ComboBox2.Text), 'l', ' ', 8) + ' ';

  if trim(Edit1.Text) = '' then s:= s + format(fmt3, ['/']) + ' '
                           else s:= s + Form1.myformat(trim(Edit1.Text), 'r', ' ', 5) + ' ';
  if trim(Edit2.Text) = '' then s:= s + format(fmt4, ['/'])
                           else s:= s + Form1.myformat(trim(Edit2.Text), 'r', ' ', 5);
  if trim(Edit5.Text) <> '' then s:= s + ' ' + trim(Edit5.Text);

  s:= trim(s);
  Form1.SynEdit11.Append(s);
  Form1.Edit1.Text:='';
  Form1.Edit3.Text:='';
  Form1.ComboBox3.ItemIndex:= 0;

  s:= '';
  Edit1.Text:='';
  Edit2.Text:='';
  Edit5.Text:='';
  Form3.Hide;
  Form1.Button2.Font.Color:= clRed;
end;

procedure TForm3.ComboBox1EditingDone(Sender: TObject);
begin
  Form1.CheckNewComboItem(Form3.ComboBox1, Form3.ComboBox1.Text, 'sport_reff.txt', Form3);
end;

procedure TForm3.ComboBox2EditingDone(Sender: TObject);
begin
  Form1.CheckNewComboItem(Form3.ComboBox2, Form3.ComboBox2.Text, 'sportwhere_reff.txt', Form3);
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  // read sport_reff.txt file
  AssignFile(fspr, dir_in + 'sport_reff.txt');
  reset(fspr);
  while not(eof(fspr)) do begin
    readln(fspr, line);
    if trim(line) <> '' then ComboBox1.Items.AddText(line);
  end;
  CloseFile(fspr);
  ComboBox1.ItemIndex:= 0;

  // read sport_where.txt file
  AssignFile(fspw, dir_in + 'sportwhere_reff.txt');
  reset(fspw);
  while not(eof(fspw)) do begin
    readln(fspw, line);
    if trim(line) <> '' then Form3.ComboBox2.Items.AddText(line);
  end;
  CloseFile(fspw);
  ComboBox2.ItemIndex:= 0;

end;

end.


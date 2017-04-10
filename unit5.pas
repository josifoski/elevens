unit Unit5;    // money_out unit

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynEdit, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Unit1;

type

  { TForm5 }

  TForm5 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    SynEdit1: TSynEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox1EditingDone(Sender: TObject);
    procedure ComboBox2EditingDone(Sender: TObject);
    procedure ComboBox3EditingDone(Sender: TObject);
    procedure ComboBox4EditingDone(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form5: TForm5;
  fmoto, fmoq, fmop, fmocat : Text;

implementation

{$R *.lfm}

{ TForm5 }

procedure TForm5.FormCreate(Sender: TObject);
begin
  // read money_outtovia_reff.txt file
  AssignFile(fmoto, dir_in + 'money_outtovia_reff.txt');
  reset(fmoto);
  while not(eof(fmoto)) do begin
    readln(fmoto, line);
    if trim(line) <> '' then ComboBox1.Items.AddText(line);
  end;
  CloseFile(fmoto);
  ComboBox1.ItemIndex:= 0;

  // read money_outqt_reff.txt file
  AssignFile(fmoq, dir_in + 'money_outqt_reff.txt');
  reset(fmoq);
  while not(eof(fmoq)) do begin
    readln(fmoq, line);
    if trim(line) <> '' then ComboBox2.Items.AddText(line);
  end;
  CloseFile(fmoq);
  ComboBox2.ItemIndex:= 0;

  // read money_outproducts_reff.txt file
  AssignFile(fmop, dir_in + 'money_outproducts_reff.txt');
  reset(fmop);
  while not(eof(fmop)) do begin
    readln(fmop, line);
    if trim(line) <> '' then ComboBox3.Items.AddText(line);
  end;
  CloseFile(fmop);
  ComboBox3.ItemIndex:= 0;

  // read money_outcategories_reff.txt file
  AssignFile(fmocat, dir_in + 'money_outcategories_reff.txt');
  reset(fmocat);
  while not(eof(fmocat)) do begin
    readln(fmocat, line);
    if trim(line) <> '' then ComboBox4.Items.AddText(line);
  end;
  CloseFile(fmocat);
  ComboBox4.ItemIndex:= 0;

end;

procedure TForm5.Button1Click(Sender: TObject);
var
  s: String;
  i: Integer;
begin
  for i:= 0 to SynEdit1.Lines.Count - 1 do
    Form1.SynEdit11.Append(SynEdit1.Lines[i]);
  SynEdit1.Clear;
  motempsum:= 0;
  Form1.Button2Click(Button2);
end;

procedure TForm5.Button2Click(Sender: TObject);
var
  s: String;
  List: TStrings;
  myreal: Real;
begin
  If trim(Edit1.Text) = '' then Edit1.Text:= '0';
  If trim(Edit2.Text) = '' then Edit2.Text:= '0';
  s:= trim(Form1.Edit2.Text) + ' '  +
    Form1.myformat(trim(Form1.ComboBox7.Text), 'l', ' ', 3) + ' ' +
    Form1.myformat(trim(ComboBox1.Text), 'l', ' ', 15) + ' ' +
    Form1.myformat(trim(ComboBox2.Text), 'l', ' ', 3) + ' ' +
    Form1.myformat(trim(Edit1.Text), 'r', ' ', 5) + ' ' +
    Form1.myformat(trim(ComboBox3.Text), 'l', ' ', 20) + ' ' +
    Form1.myformat(trim(Edit2.Text), 'r', ' ', 5) + ' ' +
    trim(ComboBox4.Text);
  s:= trim(s);

  SynEdit1.Append(s);
  Edit1.Text:='';
  Edit2.Text:='';
  List:= TStringList.Create;
  try
    ExtractStrings([' '], [], PChar(s), List);
    TryStrToFloat(List[6], myreal);
    motempsum:= motempsum + myreal;
    Label4.Caption:= 'Sum = ' + FloatToStr(motempsum);
  finally
      List.Free;
      s:= '';
  end;
  Edit1.SetFocus;
end;

procedure TForm5.ComboBox1EditingDone(Sender: TObject);
begin
  Form1.CheckNewComboItem(Form5.ComboBox1, Form5.ComboBox1.Text, 'money_outtovia_reff.txt', Form5);
end;

procedure TForm5.ComboBox2EditingDone(Sender: TObject);
begin
  Form1.CheckNewComboItem(Form5.ComboBox2, Form5.ComboBox2.Text, 'money_outqt_reff.txt', Form5);
end;

procedure TForm5.ComboBox3EditingDone(Sender: TObject);
begin
  Form1.CheckNewComboItem(Form5.ComboBox3, Form5.ComboBox3.Text, 'money_outproducts_reff.txt', Form5);
end;

procedure TForm5.ComboBox4EditingDone(Sender: TObject);
begin
  Form1.CheckNewComboItem(Form5.ComboBox4, Form5.ComboBox4.Text, 'money_outcategories_reff.txt', Form5);
end;

procedure TForm5.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  SynEdit1.Clear;
end;

end.


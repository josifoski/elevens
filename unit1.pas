unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynEdit, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, Menus, Dos, Unix, lazUTF8, LCLType;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    CheckBox3: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox3: TComboBox;
    ComboBox5: TComboBox;
    ComboBox7: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label9: TLabel;
    MenuItem1: TMenuItem;
    PopupMenu1: TPopupMenu;
    SynEdit11: TSynEdit;
    MyTrayIcon: TTrayIcon;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox1EditingDone(Sender: TObject);
    procedure ComboBox3EditingDone(Sender: TObject);
    procedure Edit7KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit8KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit9KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    function Convert2minutes(s: String; i: Integer; li: String; Sender: TObject): Integer;
    function LeftPart(): String;
    procedure FormResize(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MyTrayIconClick(Sender: TObject);
    procedure SynEdit11Change(Sender: TObject);
    procedure SynEdit11ChangeUpdating(ASender: TObject; AnUpdating: Boolean);
    procedure SynEdit11KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CheckNewComboItem(Combo: TComboBox;  s1, s2 : String; Sender: TObject);
    function myformat(s, lr, mychar: String; leng: Integer): String;
    procedure gettoday();
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  line, se11, sinv, dir_in : String;
  ffiles, ftopics, fdb, foodreff, flast, fpy, fspr, fspw, ffromto: Text;
  fdirpath, facc, fcombo: Text;
  minutes, keyByZeroColumn: Integer;
  total, motempsum: Real;
  sensitivity, memprevcombo1, memprevcombo3, juststarted, blinenums: Boolean;
  Year,Month,Day,WDay : word;
  syear, smonth, sday, todaydate: String;

implementation
uses Unit2, Unit3, Unit4, Unit5;
{$R *.lfm}

{ TForm1 }

function TForm1.myformat(s, lr, mychar: String; leng: Integer): String;
var
  i: Integer;
begin
  myformat:= s;
  if lr = 'l' then
    if UTF8length(s) < leng then
       for i:= 1 to leng - UTF8length(s) do
           myformat:= myformat + mychar;
  if lr = 'r' then
    if UTF8length(s) < leng then
       for i:= 1 to leng - UTF8length(s) do
           myformat:=  mychar + myformat;
end;

procedure TForm1.CheckNewComboItem(Combo: TComboBox;  s1, s2 : String; Sender: TObject);
var
  i: Integer;
  bima: Boolean;
begin
  bima:= False;
  for i:= 0 to Combo.Items.Count - 1 do
    if s1 = Combo.Items.ValueFromIndex[i] then bima:= True;
  if not(bima) then begin
    // ask for writing in file
    if MessageDlg('Question', 'Do you want to save ' + s1 + '?', mtConfirmation,
     [mbYes, mbNo, mbIgnore],0) = mrYes
    then
    begin
      AssignFile(fcombo, dir_in + s2);
      append(fcombo);
      writeln(fcombo, s1);
      CloseFile(fcombo);
      Combo.Items.Append(s1);
    end;
  end;
end;

procedure TForm1.gettoday();
begin
  // get today's date
  GetDate(Year,Month,Day,WDay);
  syear:= IntToStr(Year);
  smonth:= IntToStr(Month);
  if length(smonth) = 1 then smonth:= '0' + smonth;
  sday:= IntToStr(Day);
  if length(sday) = 1 then sday:= '0' + sday;
  todaydate:= syear + smonth + sday;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  s: String;
  i: Integer;

begin
  blinenums:= False;
  keyByZeroColumn:= 2;
  memprevcombo1:= True;
  memprevcombo3:= True;
  juststarted:= True;
  sinv:= '';
  gettoday();
  Edit2.Text:=todaydate;
  ComboBox5.ItemIndex:= 0;
  Label12.Caption:= '';
  sensitivity:= False;
  SynEdit11.LineHighlightColor.Background:=clHighLight;

  // read dirpathlocation.txt
  AssignFile(fdirpath, 'dirpathlocation.txt');
  reset(fdirpath);
  for i:= 1 to 5 do readln(fdirpath, line);
  dir_in:= trim(line);
  CloseFile(fdirpath);

  // read 0fileslist_reff.txt file
  AssignFile(ffiles, dir_in + '0fileslist_reff.txt');
  reset(ffiles);
  while not(eof(ffiles)) do begin
    readln(ffiles, line);
    if trim(line) <> '' then ComboBox1.Items.AddText(line);
  end;
  CloseFile(ffiles);
  ComboBox1.ItemIndex:= 0;

  // read topics_reff.txt file
  AssignFile(ftopics, dir_in + 'topics_reff.txt');
  reset(ftopics);
  while not(eof(ftopics)) do begin
    readln(ftopics, line);
    if trim(line) <> '' then ComboBox3.Items.AddText(line);
  end;
  CloseFile(ftopics);
  ComboBox3.ItemIndex:= 0;

  i:= 0;
  AssignFile(fdb, dir_in + ComboBox1.Text);
  s:= '';
  reset(fdb);
  while not(eof(fdb)) do begin
    readln(fdb, line);
    i:= i + 1;
    line:= trim(line);
    s:= s + line + #13;
  end;
  CloseFile(fdb);
  SynEdit11.Text:= s;
  SynEdit11.CaretY:= i;
  se11:= s;

  // read accounts_reff.txt file
  AssignFile(facc, dir_in + 'accounts_reff.txt');
  reset(facc);
  while not(eof(facc)) do begin
    readln(facc, line);
    if trim(line) <> '' then begin
      ComboBox7.Items.AddText(line);
    end;
  end;
  CloseFile(facc);
  ComboBox7.ItemIndex:= 0;

  // Tray icon
  MyTrayIcon.Icon.LoadFromFile('elevens.ico');
  MyTrayIcon.Show;

  Form1.WindowState := wsNormal;
  Form1.Hide;
  Form1.ShowInTaskBar := stNever;
end;

function TForm1.LeftPart(): String;
var
  s: String;
begin
  if trim(Edit1.Text) = '' then Edit1.Text:= '/';
  s:= trim(Edit2.Text) + ' '  +
    trim(ComboBox7.Text) + ' ' +
    myformat(trim(Edit1.Text), 'l', ' ', 5) + ' ' +
    myformat(trim(ComboBox3.Text), 'l', ' ', 11);
  if Edit3.Text <> '' then
    s:= s + ' ' + trim(Edit3.Text);
  LeftPart:= s;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  SynEdit11.Append(LeftPart);
  Edit1.Text:='';
  Edit3.Text:='';
  ComboBox3.ItemIndex:= 0;
  Form1.Button2.Font.Color:= clRed;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  rewrite(fdb);
  writeln(fdb, trim(SynEdit11.Text));
  Edit1.Text:='';
  Edit3.Text:='';
  CloseFile(fdb);
  Button2.Font.Color:= clDefault;
end;

function TForm1.Convert2minutes(s: String; i: Integer; li: String; Sender: TObject): Integer;
var
  Listf: TStrings;
  hours, rminutes: Integer;
  msg: String;
begin
    Listf := TStringList.Create;
    hours:= 0;
    rminutes:= 0;
    try
      ExtractStrings([':'], [], PChar(s), Listf);
      if Listf.Count = 2 then begin
        TryStrToInt(Listf[0], hours);
        TryStrToInt(Listf[1], rminutes);
      end
      else begin
        // Form4.Show;
        // Form4.SynEdit1.Append('Correct time on line position ' + IntToStr(i));
      end;
    finally
      Listf.Free;
    end;
    Convert2minutes:= hours * 60 + rminutes;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  SynEdit11.Width:= Form1.Width - 15;
end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
   Halt;
end;

procedure TForm1.MyTrayIconClick(Sender: TObject);
begin
  if not(Form1.Showing) then
      Form1.Show
     else begin
      Form1.WindowState := wsNormal;
      Form1.Hide;
      Form1.ShowInTaskBar := stNever;
   end;
end;

procedure TForm1.SynEdit11Change(Sender: TObject);
begin
  Form1.Button2.Font.Color:= clRed;

end;

procedure TForm1.SynEdit11ChangeUpdating(ASender: TObject; AnUpdating: Boolean);
begin

end;

procedure TForm1.SynEdit11KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  linenum: Integer;
  column: Integer;
  line: String;
  List: TStrings;
begin
     if Shift=[ssCtrl] then
         // S = 83 for save
         if Key = 83 then
           if Button2.Enabled = True then
             Button2Click(Button2);
         // L = 76 toogle line numbers
         if Key = 76 then begin
          blinenums:= not(blinenums);
          if blinenums then SynEdit11.Gutter.Visible:= True
                       else SynEdit11.Gutter.Visible:=False;
         end;
         // G go to line number
         if Key = 71 then
            if SynEdit11.ReadOnly = True then
               if SynEdit11.Focused = True then begin
                linenum:= 1;
                column:= SynEdit11.CaretX - 5;
                // 106 20170116 сшо bA     8:19  8:36  0:17  sport       jumprope    home      1000   100
                line:= SynEdit11.Lines.ValueFromIndex[SynEdit11.CaretY - 1];
                List := TStringList.Create;
                try
                  ExtractStrings([' '], [], PChar(line), List);
                  linenum:= StrToInt(List[0]);
                finally
                  List.Free;
                end;
                CheckBox1.Checked:= False;
                // SynEdit11.Lines.LoadFromFile(dir_in + trim(ComboBox1.Text));
                Label12.Caption:='';
                SynEdit11.CaretY:= linenum;
                SynEdit11.CaretX:= column;
                Button1.Enabled:=True;
                Button2.Enabled:=True;
                SynEdit11.ReadOnly:= False;
               end;

end;

function ConvertReadable(n: Integer): String;
var
  hours, rminutes: Integer;
  sminutes: String;
begin
  hours:= trunc(n / 60);
  rminutes:= n - hours * 60;
  if rminutes < 10 then sminutes:= '0' + IntToStr(rminutes)
                   else sminutes:= IntToStr(rminutes);
  ConvertReadable:= IntToStr(hours) + 'h ' + sminutes + 'm';
end;

procedure TForm1.CheckBox1Change(Sender: TObject);
var
  s, line, keywords, keyw, date1, date2, dateline, sf, sstat, testsensline: String;
  List, List2, Listin, Listex: TStrings;
  bok, bpass: Boolean;
  i, j, k, linesf, itry, statcol: Integer;
  taminutes: Integer;
  ftry: Real;
  myfmt, linenumber: String;
begin
  if trim(Edit9.Text) <> '' then begin
    if ComboBox5.ItemIndex = 0 then sf:='s';
    if ComboBox5.ItemIndex = 1 then sf:='a';
    if ComboBox5.ItemIndex = 2 then sf:='ta';
    if ComboBox5.ItemIndex = 3 then sf:='tt';
    statcol:= StrToInt(trim(Edit9.Text));
    bpass:= True;
  end
  else bpass:= False;
  reset(fdb);
  s:= '';
  minutes:= 0;
  taminutes:= 0;
  total:= 0;
  linesf:= 0;
  j:= 0;
  date1:= copy(trim(Edit7.Text), 1, 8);
  if trim(date1) = '' then date1:= copy(se11, 1 , 8);
  date2:= copy(trim(Edit2.Text), 1, 8);

  if CheckBox1.Checked then begin
  SynEdit11.ReadOnly:=True;
  Button1.Enabled:= False;
  Button2.Enabled:= False;
  keywords:= trim(Edit8.Text);
  if not(sensitivity) then keywords:= UTF8UpperCase(keywords);

  List := TStringList.Create;
  Listin := TStringList.Create;
  Listex:= TStringList.Create;
  try
    ExtractStrings([' '], [], PChar(keywords), List);
    for k:= 0 to List.Count - 1 do
      if copy(List[k], 1, 1) = '-' then
        Listex.Append(copy(List[k], 2, length(List[k]) - 1 ))
      else
        Listin.Append(List[k]);

    while not(eof(fdb)) do begin
      readln(fdb, line);
      if not(sensitivity) then testsensline:= UTF8UpperCase(line)
                          else testsensline:= line;
      j:= j + 1;
      bok:= True;
      dateline:= copy(line, 1, 8);
      if (dateline >= date1) and (dateline <= date2) then begin
        for i:= 0 to Listin.Count - 1 do begin
          if Pos(Listin[i], testsensline) = 0 then begin
                                                    bok:= False;
                                                 end;
        end;
        for k:= 0 to Listex.Count - 1 do begin
          if Pos(Listex[k], testsensline) > 0 then begin
                                                    bok:= False;
                                                   end;
        end;
        end
        else bok:= False;
      if bok then begin
        myfmt:= '%4s';
        linenumber:= format(myfmt,[IntToStr(j)]);
        s:= s + linenumber + ' ' + trim(line) + #13;
        // s:= s + trim(line) + #13;
        linesf:= linesf + 1;

        List2:= TStringList.Create;
        ExtractStrings([' '], [], PChar(line), List2);
        if List2.Count > keyByZeroColumn then
          if (List2[keyByZeroColumn] <> '/') then begin
            minutes:= minutes + Convert2minutes(List2[keyByZeroColumn], j, line, Form1 );
          end;

        if bpass then
          if List2.Count >= statcol then begin
            if (sf = 's') or (sf = 'a') then
                TryStrToFloat(List2[statcol - 1], ftry);
                total:= total + ftry;
            if (sf = 'ta') or (sf = 'tt') then
              if List2[statcol - 1] <> '/' then
                taminutes:= taminutes + Convert2minutes(List2[statcol - 1], j, line, Form1);
          end;
        List2.Free;
      end;
    end;
    SynEdit11.Text:= s;
    sstat:= 'Statistics: ' + ConvertReadable(minutes);
    if bpass then begin
      if sf = 's' then sstat:= sstat + '  |  ' + FloatToStr(total);
      if sf = 'a' then sstat:= sstat + '  |  ' + FloatToStr(total / linesf);
      if sf = 'ta' then sstat:= sstat + '  |  ' + ConvertReadable(taminutes div linesf);
      if sf = 'tt' then sstat:= sstat + '  |  ' + ConvertReadable(taminutes);
    end;
    Label12.Caption:= sstat;
  finally
    List.Free;
    Listin.Free;
    Listex.Free;
  end;
  end
  else begin
    i:= 0;
    while not(eof(fdb)) do begin
      readln(fdb, line);
      i:= i + 1;
      s:= s + trim(line) + #13;
    end;
    Label12.Caption:='';
    SynEdit11.Text:= s;
    SynEdit11.CaretY:= i;
    Button1.Enabled:=True;
    Button2.Enabled:=True;
    SynEdit11.ReadOnly:= False;
  end;
  CloseFile(fdb);
end;

procedure TForm1.CheckBox3Change(Sender: TObject);
begin
  if CheckBox3.Checked then sensitivity:= True
                       else sensitivity:= False;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin

end;

procedure TForm1.ComboBox1EditingDone(Sender: TObject);
var
  i: Integer;
  s: String;
begin
  CheckBox1.Checked:= False;
  i:= 0;
  AssignFile(fdb, dir_in + ComboBox1.Text);
  s:= '';
  reset(fdb);
  while not(eof(fdb)) do begin
    readln(fdb, line);
    i:= i + 1;
    line:= trim(line);
    s:= s + line + #13;
  end;
  CloseFile(fdb);
  SynEdit11.Text:= s;
  SynEdit11.CaretY:= i;
  se11:= s;
  if trim(ComboBox1.Text) = '0money_outdb.txt' then begin
    if memprevcombo1 then begin
      ComboBox3.Visible:= False;
      Label3.Visible:= False;
      motempsum:= 0;
      memprevcombo1:= False;
      Form5.Show;
      Form5.SynEdit1.Clear;
  end
  else begin
         memprevcombo1:= True;
  end;
  end
  else begin
        ComboBox3.Visible:= True;
        Label3.Visible:= True;
       end;
end;


procedure TForm1.ComboBox3EditingDone(Sender: TObject);
begin
  Edit3.Text:= '';
  if trim(ComboBox3.Text) = 'sport' then
   if memprevcombo3 then begin
    memprevcombo3:= False;
    Form3.Show;
  end
  else memprevcombo3:= True;

  Form1.CheckNewComboItem(Form1.ComboBox3, Form1.ComboBox3.Text, 'topics_reff.txt', Form1);

end;

procedure TForm1.Edit7KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
if Shift=[ssCtrl] then begin
  // T = 84
  if Key = 84 then begin
      gettoday();
      Edit7.Text:= todaydate;
  end;
  // Y = 89
  if Key = 89 then begin
     gettoday();
     Edit7.Text:= copy(todaydate, 1, 4) + '0101';
  end;
  // M = 77
  if Key = 77 then begin
     gettoday();
     Edit7.Text:= copy(todaydate, 1, 6) + '01';
  end;
end;
if Key = 13 then
  if CheckBox1.Checked = False then
    CheckBox1.Checked:= True
  else begin
    CheckBox1.Checked:= False;
    CheckBox1.Checked:= True;
  end;
end;

procedure TForm1.Edit8KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  if Key = 13 then
    if CheckBox1.Checked = False then
      CheckBox1.Checked:= True
    else begin
      CheckBox1.Checked:= False;
      CheckBox1.Checked:= True;
    end;
end;

procedure TForm1.Edit9KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  if Key = 13 then
    if CheckBox1.Checked = False then
      CheckBox1.Checked:= True
    else begin
      CheckBox1.Checked:= False;
      CheckBox1.Checked:= True;
    end;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var donotexit : TCloseAction;
begin
  donotexit:=caNone;
  CloseAction:=donotexit;
  Form1.WindowState := wsNormal;
  Form1.Hide;
  Form1.ShowInTaskBar := stNever;
end;

end.


unit Unit4;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynEdit, Forms, Controls, Graphics, Dialogs;

type

  { TForm4 }

  TForm4 = class(TForm)
    SynEdit1: TSynEdit;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.lfm}

{ TForm4 }

procedure TForm4.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  SynEdit1.Clear;
end;

end.


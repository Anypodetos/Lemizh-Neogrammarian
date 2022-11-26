unit Cases;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, Math;

type
  TCasesForm = class(TForm)
    SecCaseBox: TListBox;
    CaseBox: TListBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure CaseBoxDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
  public
  end;

var
  CasesForm: TCasesForm;

implementation

{$R *.DFM}

procedure TCasesForm.FormShow(Sender: TObject);
begin
  Left:=Min(Mouse.CursorPos.X, Screen.Width-Width);
  Top:=Min(Mouse.CursorPos.Y, Screen.Height-Height-20);
  SecCaseBox.ItemIndex:=0;
  CaseBox.ItemIndex:=0;
end; {FormShow}

procedure TCasesForm.CaseBoxDblClick(Sender: TObject);
begin
  ModalResult:=mrOK;
end; {CaseBoxDblClick}

end.

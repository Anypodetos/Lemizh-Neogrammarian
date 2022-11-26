unit Cognates;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, MyUtils;

type
  TCognatesForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LangEdit: TEdit;
    AbbrEdit: TEdit;
    CodeEdit: TEdit;
    NonLatinCheckBox: TCheckBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DeleteBtn: TBitBtn;
  private
  public
    function ShowModalEx(ALang, AAbbr, ACode: string; ANonLatin, ShowDelete: Boolean): Integer;
    function MenuHint: string;
  end;

var
  CognatesForm: TCognatesForm;

implementation

{$R *.DFM}

function TCognatesForm.ShowModalEx(ALang, AAbbr, ACode: string; ANonLatin, ShowDelete: Boolean): Integer;
begin
  LangEdit.Text:=ALang;
  AbbrEdit.Text:=AAbbr;
  CodeEdit.Text:=ACode;
  NonLatinCheckBox.Checked:=ANonLatin;
  DeleteBtn.Visible:=ShowDelete;
  ActiveControl:=LangEdit;
  Result:=ShowModal;
end; {ShowModalEx}

function TCognatesForm.MenuHint: string;
begin
  Result:=IfThen(NonLatinCheckBox.Checked, '+', '-')+Trim(AbbrEdit.Text)+','+Trim(CodeEdit.Text);
end; {MenuHint}

end.

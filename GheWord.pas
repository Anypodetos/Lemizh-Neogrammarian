unit GheWord;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

type
  TGheWordForm = class(TForm)
    Label1: TLabel;
    GlossEdit: TEdit;
    Label2: TLabel;
    SpeechPartGroup: TRadioGroup;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
  public
  end;

var
  GheWordForm: TGheWordForm;

implementation

{$R *.DFM}

end.

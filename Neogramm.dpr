program Neogramm;

uses
  Forms,
  MainForm in 'MainForm.pas' {Neogrammarian},
  Data in 'Data.pas',
  Dict in 'Dict.pas' {DictForm},
  GheWord in 'GheWord.pas' {GheWordForm},
  Cases in 'Cases.pas' {CasesForm},
  Cognates in 'Cognates.pas' {CognatesForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Neogrammarian';
  Application.CreateForm(TNeogrammarian, Neogrammarian);
  Application.CreateForm(TDictForm, DictForm);
  Application.CreateForm(TGheWordForm, GheWordForm);
  Application.CreateForm(TCasesForm, CasesForm);
  Application.CreateForm(TCognatesForm, CognatesForm);
  Application.Run;
end.

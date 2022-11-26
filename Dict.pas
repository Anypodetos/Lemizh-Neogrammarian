unit Dict;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Clipbrd,
  ComCtrls, StdCtrls, ExtCtrls, Registry, Math, Data, ImgList, Buttons, MyUtils,
  CheckLst, Menus;

type
  PLemma = ^TLemma;
  PDictEntry = ^TDictEntry;
  TLemma = record
    Lang: Byte;
    Entry: PDictEntry;
  end;
  TConnotStatus = (csUnused, csUsed, csIncluded, csWarning, csFixedWarning);
  TConnot = record
    Status: TConnotStatus;
    Kind: string;
  end;
  TConnotArray = array of TConnot;
  TDictEntry = record
    Word, StressDia: ByteArray;
    Ending, MorphBound: Word;
    Gloss: string;
    Confirmed: Boolean;
    Connots: TConnotArray;
    OldConnots: Word;
    Ancestor: TLemma; {or 1st compound part, or stem of affixed word}
    Ancestor2: PDictEntry;
    VarCode: Byte;
    Irregular: string;
    Descendants: array of TLemma;
    Mark: Byte;
  end;
  TDictForm = class(TForm)
    ColourList: TImageList;                 PageControl: TPageControl;              DictSheet: TTabSheet;                   OptionsSheet: TTabSheet;
    UploadCheckBox: TCheckBox;              Label32: TLabel;                        HostEdit: TEdit;                        Label33: TLabel;
    UserEdit: TEdit;                        Label34: TLabel;                        PasswordEdit: TEdit;                    Label35: TLabel;
    UploadPathEdit: TEdit;                  BackPanel: TPanel;                      Bevel3: TBevel;                         Label10: TLabel;
    Label11: TLabel;                        CopyBtn: TSpeedButton;                  AncestorLabel: TLabel;                  CopyEtyBtn: TSpeedButton;
    Label13: TLabel;                        Label14: TLabel;                        Label16: TLabel;                        Bevel4: TBevel;
    ToMainBtn: TSpeedButton;                DelBtn: TSpeedButton;                   WordPanel: TPanel;                      WordImage: TPaintBox;
    GlossEdit: TEdit;                       ConfirmedBox: TCheckBox;                AncestorPanel: TPanel;                  AncestorImage: TPaintBox;
    DescendantsListBox: TListBox;           SaveBtn: TBitBtn;                       ConnotListBox: TCheckListBox;           Label7: TLabel;
    IrregularCombo: TComboBox;              IrregularLabel: TLabel;                 WordPopup: TPopupMenu;                  Deleteword1: TMenuItem;
    Copywordtomainwindow1: TMenuItem;       DescendantsPopup: TPopupMenu;           Gotodescendant1: TMenuItem;             ImageList: TImageList;
    AncestorPopup: TPopupMenu;              Gotoancestor1: TMenuItem;               EditBtn: TSpeedButton;                  Editwordinmainwindow1: TMenuItem;
    N1: TMenuItem;                          Panel1: TPanel;                         Label1: TLabel;                         LangTree: TTreeView;
    WordListBox: TListBox;                  FindPanel: TPanel;                      Label5: TLabel;                         FindUp: TSpeedButton;
    FindDown: TSpeedButton;                 FindClear: TSpeedButton;                FindEdit: TEdit;                        WordListLabel: TLabel;
    LangLabel: TStaticText;                 Splitter: TSplitter;                    Bevel1: TBevel;                         Label6: TLabel;
    PathLabel: TLabel;                      Bevel2: TBevel;                         ConnotDelBtn: TSpeedButton;             FilePanel: TPanel;
    FileCombo: TComboBox;                   Label3: TLabel;                         ExpandDescBox: TCheckBox;               Bevel6: TBevel;
    VariantPaintBox: TPaintBox;             Label8: TLabel;                         Copyword1: TMenuItem;                   CompoundBtn: TSpeedButton;
    AffixBtn: TSpeedButton;                 Compoundword1: TMenuItem;               Affixword1: TMenuItem;                  N2: TMenuItem;
    AffixPopup: TPopupMenu;                 DictVerLabel: TLabel;                   Switchancestor1: TMenuItem;             Noapplicableaffixes1: TMenuItem;
    ContaminationBtn: TSpeedButton;         Contaminateword1: TMenuItem;            N3: TMenuItem;                          InternalSort: TMenuItem;
    DuplicateBtn: TSpeedButton;             Duplicateword1: TMenuItem;              Image2: TImage;                         Bevel5: TBevel;
    Image4: TImage;                         Noapplicableaffixes2: TMenuItem;        Bevel7: TBevel;                         CheckDescBtn: TBitBtn;
    CheckListBox: TListBox;                 Label9: TLabel;                         GlossSort: TMenuItem;                   FindOpts: TSpeedButton;
    FindPopup: TPopupMenu;                  FindType1: TMenuItem;                   FindType2: TMenuItem;                   FindType3: TMenuItem;
    FindType8: TMenuItem;                   FindType0: TMenuItem;                   N4: TMenuItem;                          FindNoDescs: TMenuItem;                 
    FindType4: TMenuItem;                   UploadLabel: TStaticText;               CopyEtyOutlineBtn: TSpeedButton;        StatusShape: TShape;
    Label2: TLabel;                         Image3: TImage;                         CheckConnotsBtn: TBitBtn;               FindType5: TMenuItem;
    Aux: TLabel;                            FindType7: TMenuItem;                   Gotoultimateancestor1: TMenuItem;       N5: TMenuItem;
    CompoundPopup: TPopupMenu;              Compound1: TMenuItem;                   Tatpurusha1: TMenuItem;                 Bahuvrihi1: TMenuItem;
    Appositional1: TMenuItem;               Clarifying1: TMenuItem;                 N6: TMenuItem;                          N7: TMenuItem;
    Caland1: TMenuItem;                     FindShape: TShape;                      CopyEngBtn: TSpeedButton;               CognatesBtn: TSpeedButton;
    CognatesPopup: TPopupMenu;              AddCognate1: TMenuItem;                 N8: TMenuItem;                          EditCognate1: TMenuItem;
    ConnotLabel: TLabel;                    ToMainBtn2: TSpeedButton;               EditBtn2: TSpeedButton;                 Copywordtomainwindow2: TMenuItem;
    Editwordinmainwindow2: TMenuItem;       N9: TMenuItem;                          ShowConsoleBox: TCheckBox;              ConnotPopup: TPopupMenu;
    Copyconnotations1: TMenuItem;           Gotoorigin1: TMenuItem;                 N10: TMenuItem;                         Bookmark1: TMenuItem;
    N11: TMenuItem;                         Bookmarks: TMenuItem;                   Bookmark2: TMenuItem;                   Bookmark3: TMenuItem;
    Bookmark4: TMenuItem;                   Bookmark5: TMenuItem;                   Bookmark6: TMenuItem;                   CopyConnotBtn: TSpeedButton;
    TreeSheet: TTabSheet;                   SemTreePanel: TPanel;                   Label4: TLabel;                         SemanticTree: TTreeView;
    TreeSplitter: TSplitter;                Panel3: TPanel;                         SemDelBtn: TSpeedButton;                SemTreeBtn: TSpeedButton;
    Bevel8: TBevel;                         SemAddEmptyBtn: TSpeedButton;           Addtotree1: TMenuItem;                  N12: TMenuItem;
    SemChangeBtn: TSpeedButton;             Bevel9: TBevel;                         SemDownBtn: TSpeedButton;               SemUpBtn: TSpeedButton;
    SemMoveBtn: TSpeedButton;               Label12: TLabel;                        SemTopmostEdit: TEdit;                  SemAddMemo: TMemo;
    Label15: TLabel;                        SemTreeLabel: TLabel;                   SemanticPopup: TPopupMenu;              Addchildnodewithoutaword1: TMenuItem;
    Deletenode1: TMenuItem;                 Changenode1: TMenuItem;                 N13: TMenuItem;                         Movedown1: TMenuItem;
    Moveup1: TMenuItem;                     Movetodifferentparentnode1: TMenuItem;  SemSortBtn: TSpeedButton;               Sortchildrenalphabetically1: TMenuItem;
    FindType6: TMenuItem;
    procedure LangTreeChanging(Sender: TObject; Node: TTreeNode; var AllowChange: Boolean);
    procedure LangTreeChange(Sender: TObject; Node: TTreeNode);
    procedure AncestorImageDblClick(Sender: TObject);
    procedure DescendantsListBoxDblClick(Sender: TObject);
    procedure WordListBoxClick(Sender: TObject);
    procedure ListBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure ImagePaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DelBtnClick(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    procedure CopyEtyBtnClick(Sender: TObject);
    procedure GlossEditChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ConfirmedBoxClick(Sender: TObject);
    procedure ToMainBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FindClearClick(Sender: TObject);
    procedure FindEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FindEditChange(Sender: TObject);
    procedure ConnotListBoxClickCheck(Sender: TObject);
    procedure IrregularComboChange(Sender: TObject);
    procedure PopupPopup(Sender: TObject);
    procedure SplitterMoved(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure ConnotDelBtnClick(Sender: TObject);
    procedure ConnotListBoxClick(Sender: TObject);
    procedure FileComboDropDown(Sender: TObject);
    procedure FileComboExit(Sender: TObject);
    procedure FileComboKeyPress(Sender: TObject; var Key: Char);
    procedure ExpandDescBoxClick(Sender: TObject);
    procedure VariantPaintBoxPaint(Sender: TObject);
    procedure AffixBtnClick(Sender: TObject);
    procedure CompoundBtnClick(Sender: TObject);
    procedure AffixPopupPopup(Sender: TObject);
    procedure AncestorImageClick(Sender: TObject);
    procedure ContaminationBtnClick(Sender: TObject);
    procedure SortClick(Sender: TObject);
    procedure DuplicateBtnClick(Sender: TObject);
    procedure CheckBtnClick(Sender: TObject);
    procedure CheckListBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure CheckListBoxDblClick(Sender: TObject);
    procedure FindOptsClick(Sender: TObject);
    procedure FindTypeClick(Sender: TObject);
    procedure FindNoDescsClick(Sender: TObject);
    procedure UploadLabelClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure ConnotListBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure Gotoultimateancestor1Click(Sender: TObject);
    procedure CompoundClick(Sender: TObject);
    procedure CompoundPopupPopup(Sender: TObject);
    procedure CopyEngBtnClick(Sender: TObject);
    procedure CognatesBtnClick(Sender: TObject);
    procedure ConnotListBoxDblClick(Sender: TObject);
    procedure FindShapeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure AddCognate1Click(Sender: TObject);
    procedure WordListBoxMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure EditCognate1Click(Sender: TObject);
    procedure Copyconnotations1Click(Sender: TObject);
    procedure ConnotPopupPopup(Sender: TObject);
    procedure BookmarkClick(Sender: TObject);
    procedure CopyConnotBtnClick(Sender: TObject);
    procedure SemTreeBtnClick(Sender: TObject);
    procedure SemDelBtnClick(Sender: TObject);
    procedure SemanticTreeChange(Sender: TObject; Node: TTreeNode);
    procedure SemAddEmptyBtnClick(Sender: TObject);
    procedure SemChangeBtnClick(Sender: TObject);
    procedure SemMoveBtnClick(Sender: TObject);
    procedure SemDownBtnClick(Sender: TObject);
    procedure SemanticTreeCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure SemTreePanelResize(Sender: TObject);
    procedure SemanticPopupPopup(Sender: TObject);
    procedure SemUpBtnClick(Sender: TObject);
    procedure SemSortBtnClick(Sender: TObject);
  private
    HDict: THandle; {File handle}
    Dicts: array[0..High(LangNs)] of TList;
    BackupStr, DictFile: string;
    SortInternal: Boolean;
    SortLang: Integer;
    SortCharsRev: array[0..High(LangNs), 0..43] of Byte;
    EditBtnNotes: array[False..True] of Byte;
    procedure LoadDict;
    procedure CloseDict;
    function MakePHP: string;
    procedure AffixClick(Sender: TObject);
    procedure AffixDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
    procedure CognatesClick(Sender: TObject);
    function PartOfSpeech: string;
    procedure GotoEntry(Lang: Integer; Entry: PDictEntry);
    function PThisEntry: PDictEntry;
    function ThisLang: Integer;
    function PrepareWord(Control: TControl; Index: Integer; Right: Boolean; var Lemma: TLemma): Boolean;
    procedure SetEditBtn(Btn: TSpeedButton; Entry: PDictEntry; Lang: Byte);
    procedure FillMainWord(i, Lang: Integer; Entry: PDictEntry);
    procedure UpdateConnot(Index: Integer);
    procedure UpdateWordListLabel;
    procedure AddWord(AWord, AStressDia: ByteArray; AEnding, AMorphBound: Integer; AGloss: string; AConnots: TConnotArray; AVarCode: Byte; AAnc1, AAnc2: PDictEntry);
    procedure AddDescendant(ELang, DLang: Integer; AEntry, ADescendant: PDictEntry; FirstDesc: Boolean);
    procedure PropagateConnots(Entry1, Entry2: PDictEntry; AConnots: TStrings);
    function WideWordListBox: Boolean;
    procedure DictSort(Lang: Integer);
    procedure CheckListBoxClear;
    function ConnotIsFrom(Index: Integer): TLemma;
    procedure PlaceCognatesMenuItem(Index: Integer);
    function WordInTree(E: PDictEntry): Integer;
    procedure UpdateSemTreeBtn;
    procedure DisconnectSemNode(Node: TTreeNode);
  public
    procedure AppHint(var HintStr: string; var HintInfo: THintInfo);
    function SaveDict(WantClose: Boolean): Boolean;
    procedure AddWords(Lang1, Lang2: Integer; Word1, Word2, StressDia1, StressDia2: ByteArray; Ending1, Ending2, MorphBound1, MorphBound2: Word;
      Gloss: string; Connots: TStrings; VarCode: Byte; var Entry1, Entry2: PDictEntry; const AnotherDesc: Boolean);
    function ChangeWords(Entry1, Entry2: PDictEntry; Word1, Word2, StressDia1, StressDia2: ByteArray; Ending1, Ending2, MorphBound1: Word;
      Connots: TStrings; VarCode2: Byte): Boolean;
    function AskDictSave: Integer;
    function ValidFileHandle: Boolean;
    function Changed: Boolean;
  end;

var
  DictForm: TDictForm;

implementation

uses MainForm, Cases, Cognates;

{$R *.DFM}

const
  UndefIrreg = 'yes';
  csString: array[Low(TConnotStatus)..High(TConnotStatus)] of string = ('unused', 'used', 'included in lemma', 'open warning', 'fixed warning');
  EditBtnNoteStrings: array[1..3] of string = ('Word has more than one descendant.', 'Descendant has descendants of its own.', 'Descendant is a derivation in the same language.');

function DictGlossCompare(Item1, Item2: Pointer): Integer;
begin
   Result:=AnsiCompareStr(GlossBrackets(PDictEntry(Item1).Gloss, False), GlossBrackets(PDictEntry(Item2).Gloss, False));
end; {DictGlossCompare}

function DictEntryCompare(Item1, Item2: Pointer): Integer;
var i, w1, w2: Integer;
begin
  i:=0;
  while (PDictEntry(Item1).Word[i]=PDictEntry(Item2).Word[i]) and (i<Length(PDictEntry(Item1).Word)-1) and (i<Length(PDictEntry(Item2).Word)-1) do Inc(i);
  with DictForm do if SortInternal then begin
    w1:=PDictEntry(Item1).Word[i];
    w2:=PDictEntry(Item2).Word[i];
  end else begin
    w1:=SortCharsRev[SortLang, PDictEntry(Item1).Word[i]];
    w2:=SortCharsRev[SortLang, PDictEntry(Item2).Word[i]];
  end;
  if w1<w2 then Result:=-1 else
    if w1>w2 then Result:=1 else
      if Length(PDictEntry(Item1).Word)<Length(PDictEntry(Item2).Word) then Result:=-1 else
        if Length(PDictEntry(Item1).Word)>Length(PDictEntry(Item2).Word) then Result:=1 else Result:=0;
  if Result=0 then begin
    i:=0;
    while (PDictEntry(Item1).StressDia[i]=PDictEntry(Item2).StressDia[i]) and (i<Length(PDictEntry(Item1).StressDia)-1) and (i<Length(PDictEntry(Item2).StressDia)-1) do Inc(i);
    if PDictEntry(Item1).StressDia[i]<PDictEntry(Item2).StressDia[i] then Result:=-1 else
      if PDictEntry(Item1).StressDia[i]>PDictEntry(Item2).StressDia[i] then Result:=1 else Result:=0;
  end;                                                 
  if Result=0 then Result:=PDictEntry(Item1).Ending-PDictEntry(Item2).Ending;
  if Result=0 then Result:=PDictEntry(Item1).MorphBound-PDictEntry(Item2).MorphBound;
end; {DictEntryCompare}

function LemmaCompare(Item1, Item2: TLemma): Integer;
begin
  Result:=Item1.Lang-Item2.Lang;
  if Result=0 then begin
    DictForm.SortInternal:=False;
    DictForm.SortLang:=Item1.Lang;
    Result:=DictEntryCompare(Item1.Entry, Item2.Entry);
  end;
end; {LemmaCompare}

function Variant(AncLang, Lang: Integer; Entry: PDictEntry; ForCopy: Boolean): string;
var id: Integer;
begin
  Result:='';                                                               
  with Entry^ do if VarCode<$F0 then begin
    if AncLang=Lang then begin
      if Ancestor2<>nil then id:=4900 else if VarCode<$80 then id:=5000+100*Lang else id:=30-$80-$40*Ord(VarCode>=$C0); {PIE participle}
    end else if (AncLang=lOLem) and (Lang in [lVolg, lEHell, lPrWald]) then id:=70 else if AncLang=lPIE then id:=30 else if (AncLang=lOLem) and (Lang=lMLem) then id:=20 else if Lang=lModLem then id:=10 else id:=0;
    if id<>0 then Result:=Copy(LoadStr(id+VarCode), 3, MaxInt);
    if (id+VarCode=41) and (Lang=lPrLem) then Result:=Copy(Result, 1, 6)+Copy(Result, 8, MaxInt); {sk(é)-present}
  end else if VarCode=$F1 then begin
    if AncLang=lPIE then id:=IfThen((Lang=lPrLem) and (Entry.Ancestor.Entry.Ending=System.Word(-1)), 6, 1) else if (AncLang=lPrLem) and (Lang=lOLem) then id:=2
      else if (AncLang=lOLem) and (Lang=lMLem) then id:=9 else if (AncLang=lBesk) and (Lang=lNLem) then id:=5 else if (AncLang=lPrWald) and (Lang=lEth) then id:=11 else if AncLang=lEHell then id:=3 else
        if (AncLang=lKoi) and (Lang in [lLMLem, lNLem, lModLem]) then id:=0 else // see Greek.pas > KoineToLem; too much trouble to implement here
          if Lang=lBesk then id:=4 else id:=0;
    if id>0 then Result:=CheckBoxCaptions[id];
  end;
  if (Result='') and (AncLang<$FF) and (Lang in LLoans[AncLang]) then Result:='academic loan';
  Result:=Trim(RemoveFrom(IfThen(ForCopy, '[')+'{', Result));
  with Entry^ do if Result<>'' then Result:=Result+IfThen(VarCode in [$80..$EF], IfThen(VarCode<>$80+24, ' '+IfThen(VarCode<$C0, 'active', 'mediopassive'))+' participle');
  if ForCopy then Result:=StringReplace(StringReplace(Result, '¶', '<span class="etyco">', []), '¶', '</span>', [])
    else Result:=StringReplace(Result, '¶', '', [rfReplaceAll]);
end; {Variant}

{----------------------------------------------------------Dictionary---------------------------------------------------------------------}

procedure TDictForm.FormCreate(Sender: TObject);
begin
  HDict:=Invalid_Handle_Value;
  PageControl.ActivePage:=DictSheet;
  with ContaminationBtn do Hint:=Hint+#13#10'often in compact series or for antonyms';
end; {FormCreate}

const MaxFindType = 8;
procedure TDictForm.FormShow(Sender: TObject);
var i, j: Integer;
    sl: TStringList;
begin
  if ColourList.Count=0 then with TRegIniFile.Create(Reg+'\Dict') do begin
    for i:=0 to High(LangNs) do for j:=0 to High(SortChars[0]) do if SortChars[i,j]<255 then SortCharsRev[i,SortChars[i,j]]:=j;
    Gotodescendant1.Caption:=Gotodescendant1.Caption+#9#9'Double click';
    Gotoancestor1.Caption:=Gotoancestor1.Caption+#9#9'Double click';
    Switchancestor1.Caption:=Switchancestor1.Caption+#9#9#9'Click';
    Gotoorigin1.Caption:=Gotoorigin1.Caption+#9'Double click';
    GlossEdit.Hint:='( ) = quoted remark'#13#10'[ ] = unquoted'#13#10'{ } = hidden'#13#10', = additional (informal) glosses'#13#10'lit., [tr.], [intr.]';
    for i:=0 to CompoundPopup.Items.Count-1 do with CompoundPopup.Items[i] do AddMenuItem(self, Caption, Tag, OnClick, Compoundword1);
    LangTree.Items.Assign(Neogrammarian.SourceTree.Items);
    LangTree.FullExpand;
    ColourList.Assign(Neogrammarian.ColourList);
    for i:=0 to High(LangNs) do Dicts[i]:=TList.Create;
    LangTree.Selected:=LangTree.Items[1];
    PathLabel.Caption:=ExtractFilePath(Application.ExeName);
    DictFile:=ReadString('', '', 'Dict');
    FileCombo.Text:=DictFile;
    WindowState:=TWindowState(ReadInteger('', 'WinState', Ord(wsNormal)));
    Left:=ReadInteger('', 'WinLeft', 100);
    Top:=ReadInteger('', 'WinTop', 100);
    Width:=ReadInteger('', 'WinWidth', Width);
    Height:=ReadInteger('', 'WinHeight', Height);
    Panel1.Width:=ReadInteger('', 'WinSplit', Panel1.Width);
    FindEdit.Text:=ReadString('', 'FindString', '');
    TMenuItem(FindComponent('FindType'+IntToStr(Min(Max(ReadInteger('', 'FindType', 0), 0), MaxFindType)))).Checked:=True;
    FindNoDescs.Checked:=ReadBool('', 'FindNoDescs', False);
    FindEditChange(FindEdit);
    SemTreePanel.Width:=ReadInteger('', 'WinTreeSplit', SemTreePanel.Width);
    UploadCheckBox.Checked:=ReadBool('', 'Upload', False);
    HostEdit.Text:=ReadString('', 'UploadHost', '');
    UserEdit.Text:=ReadString('', 'UploadUser', '');
    PasswordEdit.Text:=DecryptPwd(ReadString('', 'UploadPwd', ''), 34960119);
    UploadPathEdit.Text:=ReadString('', 'UploadPath', '');
    ShowConsoleBox.Checked:=ReadBool('', 'UploadShow', False);
    sl:=TStringList.Create;
    ReadSection('Cognates', sl);
    sl.Sort;
    for i:=0 to sl.Count-1 do AddMenuItem(self, sl[i], 0, CognatesClick, CognatesPopup.Items).Hint:=ReadString('Cognates', sl[i], '');
    sl.Free;
    LoadDict;
    Free;
  end;
  if PageControl.ActivePage=DictSheet then FocusControl(WordListBox);
  WordListBoxClick(nil);
end; {FormShow}

procedure TDictForm.FormHide(Sender: TObject);
begin
  if ActiveControl=FileCombo then FileComboExit(Sender);
end; {FormHide}

procedure TDictForm.FormDestroy(Sender: TObject);
var i: Integer;
begin
  if ColourList.Count>0 then begin
    with TRegIniFile.Create(Reg+'\Dict') do begin
      WriteString('', '', DictFile);
      WriteInteger('', 'WinState', Ord(WindowState));
      WriteInteger('', 'WinLeft', Left);
      WriteInteger('', 'WinTop', Top);
      WriteInteger('', 'WinWidth', Width);
      WriteInteger('', 'WinHeight', Height);
      WriteInteger('', 'WinSplit', Panel1.Width);
      WriteString('', 'FindString', FindEdit.Text);
      for i:=0 to MaxFindType do if TMenuItem(FindComponent('FindType'+IntToStr(i))).Checked then WriteInteger('', 'FindType', i);
      WriteBool('', 'FindNoDescs', FindNoDescs.Checked);
      WriteInteger('', 'WinTreeSplit', SemTreePanel.Width);
      WriteBool('', 'Upload', UploadCheckBox.Checked);
      WriteString('', 'UploadHost', HostEdit.Text);
      WriteString('', 'UploadUser', UserEdit.Text);
      WriteString('', 'UploadPwd', EncryptPwd(PasswordEdit.Text, 34960119));
      WriteString('', 'UploadPath', UploadPathEdit.Text);
      WriteBool('', 'UploadShow', ShowConsoleBox.Checked);
      EraseSection('Cognates');
      with CognatesPopup do for i:=3 to Items.Count-1 do WriteString('Cognates', Items[i].Caption, Items[i].Hint);
      Free;
    end;
    CloseDict;
    for i:=0 to High(Dicts) do Dicts[i].Free;
  end;
end; {FormDestroy}

procedure TDictForm.FormResize(Sender: TObject);
begin
  DescendantsListBox.Repaint;
  FilePanel.Left:=Min(PathLabel.Left+PathLabel.Width+2, PageControl.Width-FilePanel.Width);
end; {FormResize}

procedure TDictForm.AppHint(var HintStr: string; var HintInfo: THintInfo);
var i, j, m, w: Integer;
    c: TConnotStatus;
    cs: array[Low(TConnotStatus)..High(TConnotStatus)] of Integer;
    lem: TLemma;
    n: TTreeNode;
begin
  with HintInfo do if HintControl=SaveBtn then begin
    if Changed then HintStr:='Save dictionary (Ctrl+S)' else HintStr:='Nothing needs to be saved.';
  end else if HintControl=ConnotLabel then begin
    for c:=Low(cs) to High(cs) do cs[c]:=0;
    m:=0;  w:=0;
    for i:=0 to Dicts[ThisLang].Count-1 do for j:=0 to Length(PDictEntry(Dicts[ThisLang][i])^.Connots)-1 do begin
      c:=PDictEntry(Dicts[ThisLang][i])^.Connots[j].Status;
      Inc(cs[c]);
      if c in [csUnused, csUsed, csIncluded] then Inc(m) else Inc(w);
    end;
    HintStr:=IntToStr(m)+' connotation'+IfThen(m<>1, 's')+' in '+LongLangNs[ThisLang]+IfThen(m>0, ':');
    if m>0 then for c:=csUnused to csIncluded do HintStr:=HintStr+#13#10+IntToStr(cs[c])+' ('+IntToStr(Round(cs[c]/m*100))+'%) '+csString[c];
    HintStr:=HintStr+#13#10#13#10+IntToStr(w)+' warning'+IfThen(w<>1, 's')+IfThen(w>0, ':');
    if w>0 then for c:=csWarning to csFixedWarning do HintStr:=HintStr+#13#10+IntToStr(cs[c])+' ('+IntToStr(Round(cs[c]/w*100))+'%) '+csString[c]+IfThen(cs[c]<>1, 's');
  end else if (HintControl=ConnotListBox) or (HintControl=WordListBox) or (HintControl=DescendantsListBox) or (HintControl=CheckListBox) then with TListBox(HintControl) do begin
    m:=ItemAtPos(CursorPos, True);
    CursorRect:=ItemRect(m);
    if ((HintControl=WordListBox) and WideWordListBox) or (HintControl=CheckListBox) then
      if CursorPos.X<Width div 2 then CursorRect.Right:=Width div 2 else CursorRect.Left:=Width div 2 +1;
    if m>-1 then
      if HintControl=ConnotListBox then begin
        with PThisEntry.Connots[m] do HintStr:=Kind+#13#10'• '+IfThen(m>=PThisEntry.OldConnots, 'new in ', 'since ')+LongLangNs[ConnotIsFrom(m).Lang]+#13#10'• '+csString[Status];
      end else
        if PrepareWord(HintControl, m, CursorPos.X>=Width div 2, lem) and ((HintControl<>WordListBox) or not WideWordListBox or (CursorPos.X<Width div 2)) then
          HintStr:=Neogrammarian.DrawWord(3, Aux.Canvas, Rect(0, 0, 0, 0), False, False, 0)
            else if HintControl=WordListBox then HintStr:=lem.Entry.Gloss;
  end else if HintControl=SemanticTree then begin
    n:=SemanticTree.GetNodeAt(CursorPos.X, CursorPos.Y);
    if n<>nil then begin
      CursorRect:=n.DisplayRect(False);
      if n.Data<>nil then begin
        FillMainWord(3, lModLem, PDictEntry(n.Data));
        HintStr:=Neogrammarian.DrawWord(3, Aux.Canvas, Rect(0, 0, 0, 0), False, False, 0)+' ‘'+PDictEntry(n.Data)^.Gloss+'’';
      end else HintStr:=n.Text;
    end;
  end;
end; {AppHint}

procedure TDictForm.LoadDict;
var i, j, k, l, n, wi: Integer;
    e: PDictEntry;
    r: DWord;
    b: Byte;
    st, ver: string;
    lach: array[0..255] of Integer;
      function ReadString: string;
      var k: Integer;
          ach: array[0..255] of Byte;
      begin
        ReadFile(HDict, k,                 4, r, nil);
        ReadFile(HDict, ach,               k, r, nil);
        ach[r]:=0;
        Result:=PChar(@ach);
      end;
      procedure FillConnots(e: PDictEntry);
      var k, l: Integer;
      begin
        for k:=0 to Length(e.Descendants)-1 do with e.Descendants[k] do if (Entry.Ancestor.Entry=e) then begin
          for l:=0 to Entry.OldConnots-1 do if Entry.Connots[l].Kind='' then Entry.Connots[l].Kind:=e.Connots[l].Kind;
          FillConnots(Entry);
        end;
      end;
begin
  CopyFile(PChar(PathLabel.Caption+DictFile+'.ngr'), PChar(PathLabel.Caption+DictFile+'.bak'), False);
  HDict:=CreateFile(PChar(PathLabel.Caption+DictFile+'.ngr'), Generic_Read or Generic_Write, File_Share_Read, nil, Open_Always, File_Attribute_Normal, 0);
  if HDict<>Invalid_Handle_Value then begin
    st:=ReadString;
    ver:=Copy(st, 4, 1);
    st:=Copy(st, 5, MaxInt);
    for i:=0 to LangTree.Items.Count-1 do if (LangTree.Items[i].Level=1) and (LangNs[Integer(LangTree.Items[i].Data)]=st) then
      LangTree.Selected:=LangTree.Items[i];
    ReadFile(HDict, wi, 4, r, nil);
    ReadFile(HDict, n, 4, r, nil);
    if r=0 then n:=0;
    ReadFile(HDict, lach, 4*n, r, nil);
    for i:=0 to Min(n-1, High(Dicts)) do Dicts[i].Capacity:=lach[i];
    for i:=0 to Min(n-1, High(Dicts)) do for j:=0 to lach[i]-1 do begin
        New(e);
        ReadFile(HDict, l,                 4, r, nil);
        SetLength(e.Word, l);
        SetLength(e.StressDia, l);
      for k:=0 to l-1 do
        ReadFile(HDict, e.Word[k],         1, r, nil);
      for k:=0 to l-1 do
        ReadFile(HDict, e.StressDia[k],    1, r, nil);
        ReadFile(HDict, e.Ending,          2, r, nil);
      if ver>='#' then
        ReadFile(HDict, e.MorphBound,      2, r, nil) else e.MorphBound:=Word(-1);
        e.Gloss:=ReadString;
        ReadFile(HDict, e.Confirmed,       1, r, nil);
        ReadFile(HDict, k,                 4, r, nil);
        SetLength(e.Connots, k);
      for k:=0 to Length(e.Connots)-1 do with e.Connots[k] do begin
        ReadFile(HDict, Status,            1, r, nil);
        if ver='$' then begin
          ReadFile(HDict, b,               1, r, nil);
          if b=3 then Status:=csIncluded;
        end;
        Kind:=ReadString;
      end;
        ReadFile(HDict, e.Ancestor.Lang,   1, r, nil);
      if (ver<='"') or (e.Ancestor.Lang<255) then
        ReadFile(HDict, e.Ancestor.Entry,  4, r, nil);
      if (ver='"') or (ver>='#') and (e.Ancestor.Lang=i) then
        ReadFile(HDict, e.Ancestor2,       4, r, nil);
      if ver>='!' then
        ReadFile(HDict, e.VarCode,         1, r, nil) else e.VarCode:=$FF;
        e.Irregular:=ReadString;
        ReadFile(HDict, k,                 4, r, nil);
        SetLength(e.Descendants, k);
      for k:=0 to Length(e.Descendants)-1 do with e.Descendants[k] do begin
        ReadFile(HDict, Lang,              1, r, nil);
        ReadFile(HDict, Entry,             4, r, nil);
      end;
      if ver>='&' then
        ReadFile(HDict, e.Mark,            1, r, nil);       
      Dicts[i].Add(e)
    end;
    if ver>='#' then begin
      ReadFile(HDict, b, 1, r, nil);
      InternalSort.Checked:=Odd(b);
      GlossSort.Checked:=b>=2;
      ReadFile(HDict, b, 1, r, nil);
      ExpandDescBox.Checked:=Odd(b);
    end;
    if ver>='''' then begin
      ReadFile(HDict, l, 4, r, nil);
      with SemanticTree do for i:=0 to l-1 do begin
        ReadFile(HDict, k, 4, r, nil);
        ReadFile(HDict, b, 1, r, nil);
        if b=0 then begin
          e:=nil;
          st:=ReadString;
        end else begin
          ReadFile(HDict, l, 4, r, nil);
          e:=Dicts[lModLem][l];
          st:='';
        end;
        if k=-1 then with Items[0] do begin
          Text:=st;  Data:=e;
        end else Items.AddChildObject(Items[k], st, e);
      end;
      SemanticTree.Items[0].Expand(False);
    end;
    if (r<1) and (ver<>'') then TangoMessageBox('Dictionary wasn’t loaded completely.', mtWarning, [mbOK], '');
    for i:=0 to Min(n-1, High(Dicts)) do for j:=0 to Dicts[i].Count-1 do with PDictEntry(Dicts[i][j])^ do begin
      if (Ancestor.Lang<255) and (Integer(Ancestor.Entry)>-1) and (Dicts[Ancestor.Lang].Count>Integer(Ancestor.Entry)) then begin
        Ancestor.Entry:=Dicts[Ancestor.Lang][Integer(Ancestor.Entry)];
        OldConnots:=Min(Length(Ancestor.Entry.Connots), Length(Connots));
      end;
      if Ancestor.Lang=i then
        if Integer(Ancestor2)=-1 then Ancestor2:=nil else Ancestor2:=Dicts[i][Integer(Ancestor2)];
      for k:=0 to Length(Descendants)-1 do if (Descendants[k].Lang<255) then
        if (Integer(Descendants[k].Entry)>-1) and (Dicts[Descendants[k].Lang].Count>Integer(Descendants[k].Entry)) then
            Descendants[k].Entry:=Dicts[Descendants[k].Lang][Integer(Descendants[k].Entry)] else begin
          for l:=k+1 to Length(Descendants)-1 do Descendants[l-1]:=Descendants[l];
          SetLength(Descendants, Length(Descendants)-1);
        end;                          
    end;
    for i:=0 to Min(n-1, High(Dicts)) do for j:=0 to Dicts[i].Count-1 do FillConnots(PDictEntry(Dicts[i][j]));
    if ver='' then i:=-1 else i:=Ord(ver[1])-32;
    DictVerLabel.Caption:='(a version '+IntToStr(i)+' file)';
    Caption:=DictFile+'.ngr - Dictionary';
    UploadLabel.Caption:=LowerCase(DictFile)+'.ngr and '+LowerCase(DictFile)+'.php';
    BackupStr:=MakePHP;
    LangTreeChange(nil, nil);
    WordListBox.ItemIndex:=wi;
    WordListBoxClick(nil);
  end else begin
    TangoMessageBox('Error opening dictionary.', mtError, [mbOK], '');
    BackupStr:=MakePHP;
    PageControl.ActivePage:=OptionsSheet;
    PageControlChange(nil);
    FileCombo.SetFocus;
  end;
end; {LoadDict}

function TDictForm.SaveDict(WantClose: Boolean): Boolean;
var i, j, k, l, p: Integer;
    w: DWord;
    b: Byte;
    lach: array[0..255] of Integer;
    fname: string;
    t: TDateTime;
    sl: TStringList;
  procedure WriteString(S: string);
  var l: Integer;
      ach: array[0..255] of Byte;
  begin
        l:=Length(S);
        WriteFile(HDict, l,                   4,         w, nil);
        StrPCopy(PChar(@ach), S);
        WriteFile(HDict, ach,                 Length(S), w, nil);
  end;
begin
  Result:=HDict<>Invalid_Handle_Value;
  if Result and (not WantClose or Changed) then begin
    SetFilePointer(HDict, 0, nil, File_Begin);
    SetEndOfFile(HDict);
    WriteString('NGR'''+LangNs[ThisLang]);
    i:=WordListBox.ItemIndex;
    WriteFile(HDict,     i,                   4,         w, nil);
    lach[0]:=Length(Dicts);
    for i:=0 to lach[0]-1 do lach[i+1]:=Dicts[i].Count;
    WriteFile(HDict,     lach,            4*(lach[0]+1), w, nil);
    for i:=0 to Length(Dicts)-1 do for j:=0 to Dicts[i].Count-1 do with PDictEntry(Dicts[i][j])^ do begin
        l:=Length(Word);
        WriteFile(HDict, l,                   4,         w, nil);
      for k:=0 to l-1 do
        WriteFile(HDict, Word[k],             1,         w, nil);
      for k:=0 to l-1 do
        WriteFile(HDict, StressDia[k],        1,         w, nil);
        WriteFile(HDict, Ending,              2,         w, nil);
        WriteFile(HDict, MorphBound,          2,         w, nil);
        WriteString(Gloss);
        WriteFile(HDict, Confirmed,           1,         w, nil);
        k:=Length(Connots);
        WriteFile(HDict, k,                   4,         w, nil);
      for k:=0 to Length(Connots)-1 do with Connots[k] do begin
        WriteFile(HDict, Status,              1,         w, nil);
        WriteString(IfThen(k>=OldConnots, Kind));
      end;
        WriteFile(HDict, Ancestor.Lang,       1,         w, nil);
        if Ancestor.Lang<255 then begin
          p:=Dicts[Ancestor.Lang].IndexOf(Ancestor.Entry);
          WriteFile(HDict, p,                 4,         w, nil);
        end;
        if Ancestor.Lang=i then begin
          p:=Dicts[i].IndexOf(Ancestor2);
          WriteFile(HDict, p,                 4,         w, nil);
        end;
        WriteFile(HDict, VarCode,             1,         w, nil);
        WriteString(Irregular);
        k:=Length(Descendants);
        WriteFile(HDict, k,                   4,         w, nil);
      for k:=0 to Length(Descendants)-1 do begin
        WriteFile(HDict, Descendants[k].Lang, 1,         w, nil);
        if Descendants[k].Lang<255 then p:=Dicts[Descendants[k].Lang].IndexOf(Descendants[k].Entry) else p:=-1;
        WriteFile(HDict, p,                   4,         w, nil);
      end;
        WriteFile(HDict, Mark,                1,         w, nil);
    end;
    b:=Ord(InternalSort.Checked)+2*Ord(GlossSort.Checked);
    WriteFile(HDict, b, 1, w, nil);
    b:=Ord(ExpandDescBox.Checked);
    WriteFile(HDict, b, 1, w, nil);
    l:=SemanticTree.Items.Count;     {Semantic tree}
    WriteFile(HDict, l, 4, w, nil);
    for i:=0 to SemanticTree.Items.Count-1 do with SemanticTree.Items[i] do begin
      if Parent<>nil then l:=Parent.AbsoluteIndex else l:=-1;
      WriteFile(HDict, l, 4, w, nil);
      b:=Ord(Data<>nil);
      WriteFile(HDict, b, 1, w, nil);
      if Data<>nil then begin
        l:=Dicts[lModLem].IndexOf(Data);
        WriteFile(HDict, l, 4, w, nil);
      end else WriteString(Text);
    end;
    Result:=w>=1;
    BackupStr:=MakePHP;
    if UploadCheckBox.Checked then begin
      sl:=TStringList.Create;
      SetCurrentDir(PathLabel.Caption);
      sl.Add('ftp -s:upload.bat');
      sl.Add('goto done');
      sl.Add('open "'+HostEdit.Text+'"');
      sl.Add(UserEdit.Text);
      sl.Add(PasswordEdit.Text);
      fname:=StringReplace(UploadPathEdit.Text, '/', '\', [rfReplaceAll]);
      fname:=fname+IfThen(Copy(fname, Length(fname), 1)<>'\', '\')+DictFile+'.';
      repeat
        j:=Pos('\', fname);
        if j>0 then begin
          sl.Add('cd "'+Copy(fname, 1, j-1)+'"');
          fname:=Copy(fname, j+1, 20000);
        end;
      until j=0;
      sl.Add('ascii');
      sl.Add('put "'+PathLabel.Caption+fname+'php" "'+LowerCase(fname)+'php"');
      sl.Add('bin');
      sl.Add('put "'+PathLabel.Caption+fname+'ngr" "'+LowerCase(fname)+'ngr"');
      sl.Add('bye');
      sl.Add(':done');
      sl.Add('del upload.bat');
      t:=Now;
      repeat i:=FileCreate('upload.bat') until (i>-1) or (Now>t+0.001);
      FileClose(i);
      try sl.SaveToFile('upload.bat') except end;
      sl.Text:=BackupStr;
      try sl.SaveToFile(PathLabel.Caption+ExtractFileName(fname)+'php') except end;
      sl.Free;
      WinExec('upload.bat', Ord(ShowConsoleBox.Checked));
    end;
  end;
  if not Result then
    if WantClose then Result:=TangoMessageBox('Error saving dictionary. Close anyway?', mtError, [mbYes, mbNo], '')=idYes
      else TangoMessageBox('Error saving dictionary.', mtError, [mbOK], '');
end; {SaveDict}

function TDictForm.MakePHP: string;
const identifiers: array[0..12] of string = ('word', 'gloss', 'confirmed', 'variant', 'ancLang', 'ancNo', 'anc2No', 'descLang', 'descNo', 'connot', 'connStatus', 'irregular', 'mark');
      BoolStr: array[False..True] of string = ('False', 'True');
      StatusStr: array[csUnused..csFixedWarning] of string = ('Unused', 'Used', 'Included', 'Warning', 'FixedWarning');
var i, j, k, l: Integer;
    st: string;
    sl: TStringList;
begin
  if LangTree.Items.Count>0 then begin
    sl:=TStringList.Create;
    sl.Add('<?php');
    for k:=0 to High(identifiers) do begin
      sl.Add('$'+identifiers[k]+' = [');
      for i:=0 to Length(Dicts)-1 do begin
        sl.Add('[');
        for j:=0 to Dicts[i].Count-1 do begin
          with PDictEntry(Dicts[i][j])^ do case k of
            0: begin
              FillMainWord(3, i, PDictEntry(Dicts[i][j]));
              st:=QuoteRTFtoUTF8(Neogrammarian.MakeWordHTML(3, -1, -1, 'h2', False), False);
            end;
            1: st:=QuoteRTFtoUTF8(Gloss, True);
            2: st:=BoolStr[Confirmed];
            3: st:=QuoteRTFtoUTF8(PercentToRTF(Variant(Ancestor.Lang, i, PDictEntry(Dicts[i][j]), False)), True);
            4: if Ancestor.Lang<255 then st:=IntToStr(Ancestor.Lang) else st:='-1';
            5: if Ancestor.Lang<255 then st:=IntToStr(Dicts[Ancestor.Lang].IndexOf(Ancestor.Entry)) else st:='-1';
            6: if Ancestor.Lang=i then st:=IntToStr(Dicts[i].IndexOf(Ancestor2)) else st:='-1';
            7: begin
              st:='[';
              for l:=0 to Length(Descendants)-1 do st:=st+IntToStr(Descendants[l].Lang)+IfThen(l<Length(Descendants)-1, ',');
              st:=st+']';
            end;
            8: begin
              st:='[';
              for l:=0 to Length(Descendants)-1 do st:=st+IntToStr(Dicts[Descendants[l].Lang].IndexOf(Descendants[l].Entry))+IfThen(l<Length(Descendants)-1, ',');
              st:=st+']';
            end;
            9: begin
              st:='[';
              for l:=0 to Length(Connots)-1 do st:=st+QuoteRTFtoUTF8(PercentToRTF(Connots[l].Kind), True)+IfThen(l<Length(Connots)-1, ',');
              st:=st+']';
            end;
           10: begin
              st:='[';
              for l:=0 to Length(Connots)-1 do st:=st+''''+StatusStr[Connots[l].Status]+''''+IfThen(l<Length(Connots)-1, ',');
              st:=st+']';
            end;
           11: st:=QuoteRTFtoUTF8(Irregular, True);
           12: st:=IntToStr(Mark);
          end;
          sl.Add(st+IfThen(j<Dicts[i].Count-1, ','));
        end;
        sl.Add(']'+IfThen(i<Length(Dicts)-1, ','));
      end;
      sl.Add('];');
    end;
    sl.Add('$tree = [');
    for i:=0 to SemanticTree.Items.Count-1 do with SemanticTree.Items[i] do begin
      if Data<>nil then st:=IntToStr(Dicts[lModLem].IndexOf(Data)) else st:=QuoteRTFtoUTF8(Text, True);
      sl.Add('['+IntToStr(Level)+','+BoolStr[Data<>nil]+','+st+']'+IfThen(i<SemanticTree.Items.Count-1, ','));
    end;
    sl.Add(']; ?>');
    Result:=sl.Text;
    sl.Free;
  end else Result:='';
end; {MakePHP}

procedure TDictForm.CloseDict;
var i, j: Integer;
begin
  if HDict<>Invalid_Handle_Value then CloseHandle(HDict);
  for i:=0 to High(Dicts) do with Dicts[i] do begin
    for j:=0 to Count-1 do Dispose(PDictEntry(Items[j]));
    Count:=0;
  end;
  with Neogrammarian do if Addallwords.Checked then AddallwordsClick(nil) else begin
    DictLinkS:=nil;
    DictLinkT:=nil;
  end;
  LangTreeChange(nil, nil);
end; {CloseDict}                                        

{procedure TDictForm.PropagateConnots(Entry1, Entry2: PDictEntry; AConnots: TStrings);    /// propagate to all descendants (see OLem fler-/flor- "blue")
  procedure Propagate(E1, E2: PDictEntry);                                                 // compounds have no connots
  var i, l: Integer;                                                                       // contaminations inherit only those of 1st part
      st: string;                                                                          // affixed words and duplicates inherit connots
  begin
    l:=Length(E1.Connots);
    SetLength(E2.Connots, l);
    E2.OldConnots:=l;
    for i:=0 to l-1 do E2.Connots[i]:=E1.Connots[i];


  end;
var i: Integer;
begin


  for i:=0 to AConnots.Count-1 do if (AConnots.Objects[i]=Pointer(clWindowText)) or (AConnots.Objects[i]=Pointer(clRed)) then begin
    st:=Copy(AConnots[i], Pos('|', AConnots[i])+1, MaxInt);
    if (Length(st)>0) and (st[1]<>'(') then begin
      Inc(l);
      SetLength(Entry2.Connots, l);
      with Entry2.Connots[l-1] do begin
        if AConnots.Objects[i]=Pointer(clWindowText) then Status:=csUnused else Status:=csError;
        Kind:=st;
      end;
    end;
  end;
end; {PropagateConnots}

procedure TDictForm.PropagateConnots(Entry1, Entry2: PDictEntry; AConnots: TStrings);    /// propagate to all descendants (see OLem fler-/flor- "blue")
var i, l: Integer;
    st: string;
begin
  l:=Length(Entry1.Connots);
  SetLength(Entry2.Connots, l);
  Entry2.OldConnots:=l;
  for i:=0 to l-1 do Entry2.Connots[i]:=Entry1.Connots[i];
  for i:=0 to AConnots.Count-1 do if (AConnots.Objects[i]=Pointer(clWindowText)) or (AConnots.Objects[i]=Pointer(clRed)) then begin
    st:=Copy(AConnots[i], Pos('|', AConnots[i])+1, MaxInt);
    if (Length(st)>0) and (st[1]<>'(') then begin
      Inc(l);
      SetLength(Entry2.Connots, l);
      with Entry2.Connots[l-1] do begin
        if AConnots.Objects[i]=Pointer(clWindowText) then Status:=csUnused else Status:=csWarning;
        Kind:=st;
      end;
    end;
  end;
end; {PropagateConnots}

procedure TDictForm.AddWords(Lang1, Lang2: Integer; Word1, Word2, StressDia1, StressDia2: ByteArray; Ending1, Ending2, MorphBound1, MorphBound2: Word;
    Gloss: string; Connots: TStrings; VarCode: Byte; var Entry1, Entry2: PDictEntry; const AnotherDesc: Boolean);
  procedure Add(ALang: Integer; AWord, AStressDia: ByteArray; AEnding, AMorphBound: Word; Kind: string; var Added: Boolean; var Entry: PDictEntry);
  var i, j: Integer;
      e: PDictEntry;
  begin
    if Dicts[ALang].IndexOf(Entry)=-1 then begin
      New(e);
      SetLength(e.Word, Length(AWord));         // merge with ChangeWords.Change, AddWord?
      for i:=0 to Length(AWord)-1 do e.Word[i]:=AWord[i];
      SetLength(e.StressDia, Length(AStressDia));
      for i:=0 to Length(AStressDia)-1 do e.StressDia[i]:=AStressDia[i];
      e.Ending:=AEnding;
      e.MorphBound:=AMorphBound;
      e.Gloss:=Gloss;
      e.Confirmed:=False;
      e.Ancestor.Lang:=255;
      e.Ancestor2:=nil;
      e.VarCode:=$FF;
      e.Mark:=0;
      j:=-1;
      SortLang:=ALang;
      for i:=0 to Dicts[ALang].Count-1 do if DictEntryCompare(e, Dicts[ALang][i])=0 then j:=i;
      if (j=-1) or Added and (PDictEntry(Dicts[ALang][j]).Ancestor.Lang<255) or
          (TangoMessageBoxT(Kind+' word already exists. Add as a homonym?', mtConfirmation, [mbYes, mbNo], ['&Yes, homonym', '&No, same word'], '')=idYes) then begin
        Dicts[ALang].Add(e);
        DictSort(ALang);
        Entry:=e;
        Added:=True;
      end else begin
        Dispose(e);
        Entry:=Dicts[ALang][j];
      end;
    end;
  end; {Add}
var i, j: Integer;
    a: Boolean;
begin
  a:=False;
  Add(Lang1, Word1, StressDia1, Ending1, MorphBound1, 'Source', a, Entry1);
  Add(Lang2, Word2, StressDia2, Ending2, MorphBound2, 'Target', a, Entry2);
  if Connots<>nil then PropagateConnots(Entry1, Entry2, Connots);
  Entry2.VarCode:=VarCode;
  AddDescendant(Lang1, Lang2, Entry1, Entry2, True);
  GotoEntry(Lang1, Entry1);
  GlossEditChange(nil);
  j:=-1;
  for i:=0 to Length(Entry1.Descendants)-1 do if Entry1.Descendants[i].Lang=Lang2 then Inc(j);
  if AnotherDesc and (j>0) then TangoMessageBox('Note: Source word has '+IfThen(j=1, 'another descendant', IntToStr(j)+' other descendants')+' in '+LongLangNs[Lang2]+'.',
    mtInformation, [mbOK], '');
end; {AddWords}

function TDictForm.ChangeWords(Entry1, Entry2: PDictEntry; Word1, Word2, StressDia1, StressDia2: ByteArray; Ending1, Ending2, MorphBound1: Word; Connots: TStrings; VarCode2: Byte): Boolean;
  procedure Change(Entry: PDictEntry; AWord, AStressDia: ByteArray; AEnding, AMorphBound: Word; AVarCode: Byte; TargetWord: Boolean);
  var i: Integer;
      same: Boolean;
  begin
    with Entry^ do begin
      same:=(Length(Word)=Length(AWord)) and (Ending=AEnding) and (MorphBound=AMorphBound);
      if same then for i:=0 to Length(Word)-1 do same:=same and (Word[i]=AWord[i]) and (StressDia[i]=AStressDia[i]);
      if not same then begin
        SetLength(Word, Length(AWord));                // merge with AddWords.Add, AddWord?
        for i:=0 to Length(Word)-1 do Word[i]:=AWord[i];
        SetLength(StressDia, Length(AStressDia));
        for i:=0 to Length(StressDia)-1 do StressDia[i]:=AStressDia[i];
        Ending:=AEnding;
        MorphBound:=AMorphBound;
        Confirmed:=False;
        if TargetWord then VarCode:=AVarCode else if (Ancestor.Lang<255) and (Irregular='') then Irregular:=UndefIrreg;
        Result:=True;
      end;
    end;
  end; {Change}
begin
  Result:=False;
  if (Entry1<>nil) and (Length(Word1)>0) then begin
    Change(Entry1, Word1, StressDia1, Ending1, MorphBound1, 0, False);
    DictSort(Neogrammarian.Langs[0,0]);
    if ThisLang=Neogrammarian.Langs[0,0] then WordListBox.ItemIndex:=Dicts[Neogrammarian.Langs[0,0]].IndexOf(Entry1);
  end;
  if (Entry2<>nil) and (Length(Word2)>0) then begin
    Change(Entry2, Word2, StressDia2, Ending2, Word(-1), VarCode2, True);
    if Entry2<>nil then PropagateConnots(Entry1, Entry2, Connots);
    DictSort(Neogrammarian.Langs[2,0]);
    if ThisLang=Neogrammarian.Langs[2,0] then WordListBox.ItemIndex:=Dicts[Neogrammarian.Langs[2,0]].IndexOf(Entry2);
  end;
  // sort Entry1.Descendants: see AddDescendant (only if both words exist!)
  WordListBox.Invalidate;
  WordListBoxClick(nil);
end; {ChangeWords}

{----------------------------------------------------------Controls--------------------------------------------------------------}

procedure TDictForm.PageControlChange(Sender: TObject);
begin
  LangLabel.Visible:=PageControl.ActivePage=DictSheet;
  UpdateSemTreeBtn;
end; {PageControlChange}

procedure TDictForm.SplitterMoved(Sender: TObject);
begin
  WordListBox.Invalidate;
  DescendantsListBox.Invalidate;
end; {SplitterMoved}

procedure TDictForm.SaveBtnClick(Sender: TObject);
begin
  SaveDict(False);
end; {SaveBtnClick}

procedure TDictForm.UpdateWordListLabel;
var i, u: Integer;
begin
  u:=0;
  with Dicts[ThisLang] do begin
    for i:=0 to Count-1 do if not PDictEntry(Items[i]).Confirmed then Inc(u);
    WordListLabel.Caption:=IntToStr(Count)+' le&mma'+Copy('ta', 1, 2*Ord(Count<>1))+' ('+IntToStr(u)+' unconfirmed)';
  end;
end; {UpdateWordListLabel}

procedure TDictForm.LangTreeChanging(Sender: TObject; Node: TTreeNode; var AllowChange: Boolean);
begin
  with LangTree do AllowChange:=Node.Level>0;
end; {LangTreeChanging}

procedure TDictForm.LangTreeChange(Sender: TObject; Node: TTreeNode);
var i: Integer;
begin
  UpdateWordListLabel;
  LangLabel.Caption:=LongLangNs[ThisLang];
  WordListBox.Items.BeginUpdate;
  WordListBox.Items.Clear;
  with Dicts[ThisLang] do for i:=0 to Count-1 do WordListBox.Items.Add('');
  WordListBox.Items.EndUpdate;
  BackPanel.Visible:=Dicts[ThisLang].Count>0;
  if BackPanel.Visible then WordListBox.ItemIndex:=0;
  CompoundBtn.Down:=False;
  ContaminationBtn.Down:=False;
  WordListBoxClick(nil);
end; {LangTreeChange}

procedure TDictForm.SetEditBtn(Btn: TSpeedButton; Entry: PDictEntry; Lang: Byte);
begin
  Btn.Enabled:=Lang<255;
  Btn.Hint:='Edit word in main window ('+IfThen(Btn=EditBtn2, 'Shift+')+'Ctrl+E)';
  EditBtnNotes[Btn=EditBtn2]:=0;
  with Btn, Entry^ do if Enabled and (Length(Descendants)>0) then if Length(Descendants)>1 then EditBtnNotes[Btn=EditBtn2]:=1
    else if Length(Descendants[0].Entry.Descendants)>0 then EditBtnNotes[Btn=EditBtn2]:=2
      else if Descendants[0].Lang=Lang then EditBtnNotes[Btn=EditBtn2]:=3;
  if EditBtnNotes[Btn=EditBtn2]>0 then Btn.Hint:=Btn.Hint+#13#10'Note: '+EditBtnNoteStrings[EditBtnNotes[Btn=EditBtn2]];
end; {SetEditBtn}

procedure TDictForm.WordListBoxClick(Sender: TObject);
  procedure Compound;
  var e1, e2: PDictEntry;
      wrd, strs: ByteArray;
      i, mb: Integer;
  begin
    e1:=PDictEntry(CompoundBtn.Tag);
    e2:=PThisEntry;
    if e1<>e2 then with Neogrammarian do begin
      FillMainWord(1, ThisLang, e1);
      WordLen[1]:=Min(WordLen[1], Ending[1]);
      if ThisLang=lPIE then case CompoundPopup.Tag of
        2{bahuvrihi}:    Grade(gFull, True);
        3{appositional}: ;                       // grade, accent?
        9{Caland}:       begin Grade(gZeroPlusV, False); Add(1, 7); end;
      end else if (ThisLang=lElb) and (CompoundPopup.Tag=2) then ; //
      with CasesForm do if (ThisLang=lModLem) and (ShowModal=mrOK) then for i:=WordLen[1]-1 downto 0 do if Words[1,i]=0 then begin
        Words[1,i]:=CaseBox.ItemIndex mod 8;
        if SecCaseBox.ItemIndex>0 then Insert(1, i+1, SecCaseBox.ItemIndex+23);
        if CaseBox.ItemIndex>=8 then Insert(1, i+1, 29-(CaseBox.ItemIndex div 8));
        Break;
      end;
      mb:=WordLen[1];
      WordLen[1]:=mb+Length(e2.Word);
        for i:=0 to Length(e2.Word)-1 do WordsStressDia[1,i+mb,0]:=e2.Word[i];
      if (ThisLang<>lPIE) or (CompoundPopup.Tag<>2) then
        for i:=0 to Length(e2.Word)-1 do SetStress(1, i+mb, TStress(e2.StressDia[i] and 15), False);
        for i:=0 to Length(e2.Word)-1 do if e2.StressDia[i]>15 then SetDia(1, i+mb, False);
      if ThisLang=lPIE then case CompoundPopup.Tag of
        2{bahuvrihi}:    Grade(gO, False);
        3{appositional}: ;                // grade, accent?
      end else if (ThisLang=lElb) and (CompoundPopup.Tag=2) then ; //
      SetLength(wrd, WordLen[1]);
      for i:=0 to WordLen[1]-1 do wrd[i]:=Words[1,i];
      SetLength(strs, WordLen[1]);
      for i:=0 to WordLen[1]-1 do strs[i]:=GetStressDia(1, i);
      AddWord(wrd, strs, Min(mb+e2.Ending, Word(-1)), mb, IfThen(CompoundPopup.Tag=2, 'with a ')+e1.Gloss+' '+e2.Gloss, nil, CompoundPopup.Tag, e1, e2);
    end else MessageBeep(MB_IconAsterisk);
  end; {Compound}
  procedure Contamination;
  var e2: PDictEntry;
  begin                                                                               
    e2:=PThisEntry;     
    if PDictEntry(ContaminationBtn.Tag)<>e2 then
      with PDictEntry(ContaminationBtn.Tag)^ do AddWord(Word, StressDia, Ending, System.Word(-1), Gloss+' ('+e2.Gloss+')', Connots, $10, PDictEntry(ContaminationBtn.Tag), e2)
         else MessageBeep(MB_IconAsterisk);
  end; {Contamination}

begin
  if WordListBox.ItemIndex>-1 then with PThisEntry^ do begin
    SetEditBtn(EditBtn, PThisEntry, ThisLang);
    Editwordinmainwindow1.Enabled:=EditBtn.Enabled;
    GlossEdit.Tag:=1;
    GlossEdit.Text:=Gloss;
    GlossEdit.Tag:=0;
    UpdateConnot(0);
    ConfirmedBox.Checked:=Confirmed;
    AncestorImage.Tag:=0;
    AncestorImage.Invalidate;
    AncestorLabel.Caption:=IfThen(Ancestor.Lang=ThisLang, IfThen(Ancestor2=nil, IfThen(VarCode=$FF, 'Ancestor', 'Stem'), 'Word 1'), 'Ancestor');
    ToMainBtn2.Enabled:=Ancestor.Lang<255;
    Copywordtomainwindow2.Enabled:=ToMainBtn2.Enabled;
    SetEditBtn(EditBtn2, Ancestor.Entry, Ancestor.Lang);
    Editwordinmainwindow2.Enabled:=EditBtn2.Enabled;
    Gotoancestor1.Enabled:=Ancestor.Lang<255;
    Gotoultimateancestor1.Enabled:=Gotoancestor1.Enabled;
    Switchancestor1.Enabled:=Ancestor.Lang=ThisLang;
    VariantPaintBox.Hint:='Code '+IntToStr(VarCode)+' (0x'+IntToHex(VarCode, 2)+')';
    VariantPaintBox.Invalidate;
    IrregularCombo.Text:=Irregular;
    IrregularComboChange(nil);
    ExpandDescBoxClick(nil);
    if CompoundBtn.Down then Compound else if ContaminationBtn.Down then Contamination;
    UpdateSemTreeBtn;
  end else WordListBox.ItemIndex:=0;
  SemTreeBtn.Down:=False;
  SemanticTree.Cursor:=crDefault;
  WordImage.Invalidate;
  FindShape.Hide;
end; {WordListBoxClick}

procedure TDictForm.BookmarkClick(Sender: TObject);
begin
  with PThisEntry^ do if Sender=WordListBox then Mark:=Ord(Mark=0) else Mark:=TMenuItem(Sender).Tag*Ord(Mark<>TMenuItem(Sender).Tag);
  WordListBox.Invalidate;
end; {BookmarkClick}

procedure TDictForm.WordListBoxMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if not (CompoundBtn.Down or ContaminationBtn.Down) then WordListBox.Cursor:=crDefault else WordListBox.Cursor:=crHandPoint;
end; {WordListBoxMouseMove}

function TDictForm.PrepareWord(Control: TControl; Index: Integer; Right: Boolean; var Lemma: TLemma): Boolean;
begin
  if Control=WordListBox then begin
    Lemma.Lang:=ThisLang;
    Lemma.Entry:=PDictEntry(Dicts[Lemma.Lang][Index]);
  end else if Control=DescendantsListBox then Lemma:=PLemma(Pointer(DescendantsListBox.Items.Objects[Index]))^ else if CheckListBox.Items.Objects[Index]<>nil then begin
    Lemma.Lang:=HexToInt(Copy(CheckListBox.Items[Index], 1+2*Ord(Right), 2));
    if Right then Lemma.Entry:=PDictEntry(HexToInt(Copy(CheckListBox.Items[Index], 5, 8))) else Lemma.Entry:=PDictEntry(CheckListBox.Items.Objects[Index]);
  end;
  Result:=Lemma.Entry<>nil;
  if Result then FillMainWord(3, Lemma.Lang, Lemma.Entry);
end; {PrepareWord}

procedure TDictForm.ListBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var indent: Integer;
    lem: TLemma;
begin
  if Control=DescendantsListBox then indent:=StrToInt(DescendantsListBox.Items[Index]) else indent:=0;
  if PrepareWord(Control, Index, False, lem) then with TListBox(Control) do begin
    with TListBox(Control) do Neogrammarian.DrawWord(3, Canvas, Rect, odSelected in State, Control=DescendantsListBox, indent);
    Canvas.Font.Color:=clBlack;
    if (Control=WordListBox) and WideWordListBox then Canvas.TextOut(Rect.Left+Width div 2, Rect.Top+2, lem.Entry.Gloss);
    if not lem.Entry.Confirmed then with Canvas do begin
      Font.Color:=clRed;
      Font.Style:=[];
      TextOut(Rect.Right-TextWidth('?')-1, Rect.Top+2, '?');
    end;
    if lem.Entry.Mark>0 then with Canvas do ImageList.Draw(TListBox(Control).Canvas, Rect.Right-24, (Rect.Top+Rect.Bottom) div 2 -8, Min(lem.Entry.Mark+12, 17));
    Canvas.Brush.Style:=bsClear;
    Canvas.Pen.Color:=clGrayText;
    if odSelected in State then with Rect do Canvas.Rectangle(Left, Top, Right, Bottom);
  end;
end; {ListBoxDrawItem}

procedure TDictForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if PageControl.ActivePage=DictSheet then case Key of
    VK_F3: if Shift=[] then FindEditChange(FindDown);
    VK_Add: if Shift=[ssCtrl] then SemTreeBtnClick(nil);
    67{C}: if Shift=[ssCtrl] then CopyBtnClick(CopyBtn)       else if Shift=[ssShift, ssCtrl] then CopyEngBtnClick(CopyEngBtn);
    68{D}: if Shift=[ssCtrl] then DuplicateBtnClick(nil);
    69{E}: if Shift=[ssCtrl] then ToMainBtnClick(EditBtn)     else if Shift=[ssShift, ssCtrl] then ToMainBtnClick(EditBtn2);
    70{F}: if Shift=[ssCtrl] then AffixBtnClick(AffixBtn);
    77{M}: if Shift=[ssCtrl] then ToMainBtnClick(ToMainBtn)   else if Shift=[ssShift, ssCtrl] then ToMainBtnClick(ToMainBtn2);
    79{O}: if Shift=[ssCtrl] then ContaminationBtnClick(nil);
    80{P}: if Shift=[ssCtrl] then CompoundBtnClick(nil);
    89{Y}: if Shift=[ssCtrl] then CopyEtyBtnClick(CopyEtyBtn) else if Shift=[ssShift, ssCtrl] then CopyEtyBtnClick(CopyEtyOutlineBtn);
  end else if PageControl.ActivePage=TreeSheet then case Key of
    VK_Add:    if Shift=[ssCtrl] then SemAddEmptyBtnClick(nil);
    VK_Delete: if Shift=[]       then SemDelBtnClick(nil);
    VK_Up:     if Shift=[ssCtrl] then SemUpBtnClick(nil);
    VK_Down:   if Shift=[ssCtrl] then SemDownBtnClick(nil);
    65{A}:     if Shift=[ssCtrl] then SemSortBtnClick(nil);
    67{C}:     if Shift=[ssCtrl] then SemChangeBtnClick(nil);
    77{M}:     if Shift=[ssCtrl] then SemMoveBtnClick(nil);
  end;
  if (Key=VK_Escape) and (Shift=[]) then begin
    if CompoundBtn.Down then CompoundBtn.Down:=False else if ContaminationBtn.Down then ContaminationBtn.Down:=False else
      if ActiveControl=FindEdit then FindClearClick(nil);
    if SemTreeBtn.Down or SemMoveBtn.Down then begin
      SemTreeBtn.Down:=False;
      SemMoveBtn.Down:=False;
      SemanticTree.Cursor:=crDefault;
    end;
  end;
  if (Key=83{S}) and (Shift=[ssCtrl]) then SaveDict(False);
end; {FormKeyDown}

procedure TDictForm.PopupPopup(Sender: TObject);
var p: TPoint;
    i: Integer;
begin
  CompoundBtn.Down:=False;
  ContaminationBtn.Down:=False;
  InternalSort.Visible:=TPopupMenu(Sender).PopupComponent=WordListBox;
  GlossSort.Visible:=InternalSort.Visible;
  N3.Visible:=InternalSort.Visible;
  with TWinControl(TPopupMenu(Sender).PopupComponent) do if TPopupMenu(Sender).PopupComponent is TListBox then begin
    for i:=0 to TPopupMenu(Sender).Items.Count-1 do TPopupMenu(Sender).Items[i].Enabled:=TListBox(TPopupMenu(Sender).PopupComponent).Items.Count>0;
    p:=ScreenToClient(Mouse.CursorPos);
    SendMessage(Handle, WM_LButtonDown, 0, MakeLong(p.X, p.Y));
    if TPopupMenu(Sender).PopupComponent=WordListBox then WordListBoxClick(nil);
  end;
  if Bookmarks.Enabled then begin
    Bookmarks.ImageIndex:=PThisEntry^.Mark+12;
    for i:=1 to 6 do with TMenuItem(FindComponent('Bookmark'+IntToStr(i))) do Checked:=PThisEntry^.Mark=i;
  end;
end; {PopupPopup}

{----------------------------------------------------------Word--------------------------------------------------------------}

procedure TDictForm.ToMainBtnClick(Sender: TObject);
var b: Boolean;
    e: PDictEntry;
    l: Byte;
begin
  if Sender is TSpeedButton then b:=TSpeedButton(Sender).Enabled else b:=TMenuItem(Sender).Enabled;
  if b then with Neogrammarian do begin
    DictLinkS:=nil;
    DictLinkT:=nil;
    HistPopupClick(nil);
    if TComponent(Sender).Tag<=1 then begin
      e:=PThisEntry;
      l:=ThisLang;
    end else with PThisEntry^ do begin
      if (Ancestor.Lang<>ThisLang) or (Ancestor2=nil) or (Tag=0) then e:=Ancestor.Entry else e:=Ancestor2;
      l:=Ancestor.Lang;
    end;
    FillMainWord(0, l, e);
    if Odd(TComponent(Sender).Tag) then with e^ do begin
      DictLinkS:=PDictEntry(Dicts[Langs[0,0]][WordListBox.ItemIndex]);
      if Length(Descendants)>0 then begin
        if EditBtnNotes[TComponent(Sender).Tag=3]=0 then begin
          Langs[2,0]:=Descendants[0].Lang;
          with Descendants[0].Entry^ do if VarCode<$F0 then ComboBox.ItemIndex:=VarCode else if VarCode<$FF then CheckBox.Checked:=Odd(VarCode);
          DictLinkT:=Descendants[0].Entry;
        end else TangoMessageBox('Won’t edit target word:'#13#10+EditBtnNoteStrings[EditBtnNotes[TComponent(Sender).Tag=3]], mtWarning, [mbOK], '');
      end;
    end;
    SetCaret(MaxInt, MaxInt);
    UpdateWord(True, e.Gloss);
    SetFocus;
  end;
end; {ToMainBtnClick}

procedure TDictForm.CompoundBtnClick(Sender: TObject);
var p: TPoint;
begin
  if Sender<>CompoundBtn then CompoundBtn.Down:=not CompoundBtn.Down;
  if CompoundBtn.Down then begin
    CompoundBtn.Down:=False;
    p:=BackPanel.ClientToScreen(Point(CompoundBtn.Left, CompoundBtn.Top+CompoundBtn.Height));
    CompoundPopup.Popup(p.X, p.Y);
  end;
end; {CompoundBtnClick}

procedure TDictForm.CompoundPopupPopup(Sender: TObject);
var top: TMenuItem;
    i: Integer;
begin
  if Sender=CompoundPopup then top:=CompoundPopup.Items else top:=Compoundword1;
  for i:=1 to 6 do top.Items[i].Visible:=not (ThisLang in [lPrLem, lMLem..lModLem, lVolg, lEHell, lKoi, lBrug, lPrWald, lPrCelt, lGhe]) and not (i=4{appositional//});
  if not ((ThisLang=lPIE) and (Pos('V', PartOfSpeech)>0)) then top.Items[5{Caland}].Visible:=False;
end; {CompoundPopupPopup}

procedure TDictForm.CompoundClick(Sender: TObject);
begin
  ContaminationBtn.Down:=False;
  CompoundBtn.Down:=True;
  CompoundBtn.Tag:=Integer(PThisEntry);
  CompoundPopup.Tag:=TMenuItem(Sender).Tag;
end; {CompoundClick}

procedure TDictForm.AffixBtnClick(Sender: TObject);
var p: TPoint;
begin
  p:=BackPanel.ClientToScreen(Point(AffixBtn.Left, AffixBtn.Top+AffixBtn.Height));
  AffixPopup.Popup(p.X, p.Y);
end; {AffixBtnClick}

procedure TDictForm.AffixPopupPopup(Sender: TObject);
var i: Integer;
    top: TMenuItem;
    st, st1, st2: string;
begin
  if Sender=AffixPopup then top:=AffixPopup.Items else top:=Affixword1;
  with top do for i:=Count-1 downto 1 do Delete(i);
  for i:=0 to 99 do begin
    st:=LoadStr(5000+100*ThisLang+i);
    st1:=Copy(st, 1, 1);  st2:=Copy(st, 3, MaxInt);
    if (Pos(st1, PartOfSpeech)>0) or (st1=' ') or (st1='-') then with AddMenuItem(self, st2, IfThen(st2<>'-', i, 0), AffixClick, top) do if st2<>'-' then OnDrawItem:=AffixDrawItem;
  end;
  top[0].Visible:=top.Count=1;
end; {AffixPopupPopup}

procedure TDictForm.AffixClick(Sender: TObject);
  function Ed(S, Ending: string): string;
  begin
    Result:=S+IfThen(Copy(S, Length(S), 1)<>'e', 'e')+Ending;
  end; {Ed}
var i, mb, opt: Integer;
    wrd, strs: ByteArray;
    gl: string;
    s: Byte;
begin
  with PThisEntry^, Neogrammarian do begin
    FillMainWord(1, ThisLang, PThisEntry);
    mb:=Min(Ending[1], WordLen[1]);
    opt:=-1;
    gl:=Gloss;
    case ThisLang of  // -> Etymologie.odt
      lPIE: case TMenuItem(Sender).Tag of
       {deverbal}
        0: {-tó-verbal adj} begin Grade(gZeroPlusC, False); Add(1, 31); Add(1, 4); Add(1, 18); mb:=Ending[1]; Ending[1]:=WordLen[1]-2; Grade(gO, True); gl:=Ed(gl, 'd'); end;
        1: {-nó-verbal adj} begin Grade(gZeroPlusC, False); Add(1, 12); Add(1, 4); Add(1, 18); mb:=Ending[1]; Ending[1]:=WordLen[1]-2; Grade(gO, True); gl:=Ed(gl, 'd'); end;
        2: {neuter abstract noun} begin Grade(gFull, True); Add(1, 10); Add(1, 13); Ending[1]:=System.Word(-1); opt:=-2; gl:='thing '+Ed(gl, 'd'); end;
        3: {object noun} begin Grade(gFull, True); Add(1, 8); Add(1, 15); Ending[1]:=System.Word(-1); opt:=-2; gl:=Ed(gl, 'd thing') end;
        4: {event agent} begin Grade(gFull, True); Add(1, 31); Add(1, 4); Add(1, 14); Add(1, 18); Ending[1]:=WordLen[1]-1; gl:=Ed(gl, 'r'); end;
        5: {non-event agent} begin Grade(gZeroPlusC, False); Add(1, 31); Add(1, 0); Add(1, 14); Add(1, 18); Grade(gFull, True); mb:=Ending[1]; Ending[1]:=WordLen[1]-1; gl:=Ed(gl, 'r'); end;
        6: {r-stem noun} begin Grade(gFull, True); Add(1, 4); Add(1, 14); Add(1, 18); Ending[1]:=WordLen[1]-1; gl:=Ed(gl, 'r'); end;
       15: {zero-affix noun} begin Grade(gFull, True); Add(1, 4); Add(1, 18); mb:=System.Word(-1); gl:=gl+'…' end;
       17: {minus s-mobile} begin Delete(1, 0); mb:=-1; end;
       {de-adjectival}
       20: ;
       21: ;  
       22: {stative verb} begin Grade(gZeroPlusV, False); WordLen[1]:=Ending[1]; mb:=Ending[1]; Add(1, 0); Add(1, 22); Ending[1]:=WordLen[1]; opt:=13; gl:='be '+gl; end;
       23: {factitive verb} begin WordLen[1]:=Ending[1]; Add(1, 0); Add(1, 24); Ending[1]:=WordLen[1]; opt:=12; gl:='make '+gl; end;
   //  30: {-teh2t-feminine abstract noun} begin WordLen[1]:=mb; Add(1, 31); Add(1, 0); Add(1, 24); Add(1, 31); Add(1, 18); Ending[1]:=WordLen[1]-1; gl:=gl+'ness'; end;  // stress? \ has another element
   //  31: {-tuh2t-feminine abstract noun} begin WordLen[1]:=mb; Add(1, 31); Add(1, 9); Add(1, 24); Add(1, 31); Add(1, 18); Ending[1]:=WordLen[1]-1; gl:=gl+'ness'; end;  // stress? / as in sen-ek-tas, ne(u)-ó-te:s
       {denominal}
   //  40: {denominal verb} begin WordLen[1]:=mb; Add(1, 6); Ending[1]:=WordLen[1]; gl:=; end;    // remove stress;  how create full grade?
       41: {feminine} begin s:=GetStressDia(1, mb); WordLen[1]:=mb; mb:=PThisEntry.MorphBound; Add(1, 0); Add(1, 24); SetStress(1, mb, TStress(s), False); Ending[1]:=WordLen[1]-2; gl:='she-'+gl; end;
       42: {diminutive} begin WordLen[1]:=mb; Add(1, 16); Add(1, 4); Add(1, 18); Ending[1]:=WordLen[1]-2; gl:=gl+'let'; end;
       43: {Hoffmann} begin WordLen[1]:=mb; Grade(gZeroPlusC, False); mb:=Ending[1]; Add(1, 22); Add(1, 4); Add(1, 12); Add(1, 18); SetStress(1, WordLen[1]-1, stIs1, False); Ending[1]:=WordLen[1]-1; gl:='having (a) '+gl; end;
       // IELC pp 110ff, 116ff
   //  50: {vrddhi} begin gl:='belonging to '+gl; end; // IELC p116f
      end;
      lPrLem: case TMenuItem(Sender).Tag of
        30: {feminine} begin Add(1, 23); Add(1, 4); Add(1, 12); Ending[1]:=WordLen[1]; end;
      end;
      lMLem: case TMenuItem(Sender).Tag of
        0: {diminutive}   begin Insert(1, Ending[1], 1); Insert(1, Ending[1]+1, 28); Ending[1]:=Ending[1]+2; gl:='small '+gl; end;
        1: {augmentative} begin Insert(1, Ending[1], 4); Insert(1, Ending[1]+1, 27); Ending[1]:=Ending[1]+2; gl:='big '+gl; end;
        8: {collective/abstract} begin Insert(1, Ending[1], 2); Ending[1]:=Ending[1]+1; gl:='collective '+gl; end;
      end;
    end;          
    SetLength(wrd, WordLen[1]);
    for i:=0 to WordLen[1]-1 do wrd[i]:=Words[1,i];
    SetLength(strs, WordLen[1]);
    for i:=0 to WordLen[1]-1 do strs[i]:=GetStressDia(1, i);
    AddWord(wrd, strs, Ending[1], mb, gl, Connots, TMenuItem(Sender).Tag, PThisEntry, nil);
    if opt>-1 then begin
      ComboBox.ItemIndex:=opt;
      OptBoxesClick(nil);
    end else if opt=-2 then CheckBox.Checked:=True;
  end;
end; {AffixClick}

function TDictForm.PartOfSpeech: string;
begin
  Result:='?';
  with PThisEntry^ do case ThisLang of
    lPIE: if Ending=Length(Word) then Result:='V'{+Adj}+IfThen((Word[0]=18) and (Word[1] in [8, 10, 12, 14, 16, 28, 31, 34, 37, 40]), 'S') else Result:='N';
    lPrLem, lOLem: if Ending=Length(Word) then Result:='X' else Result:='P';
    lMLem, lLMLem, lNLem: if SmallInt(Ending)<>-1 then Result:='X' else Result:='P';
    lVolg: ; //
    lGhe: ;  //
    lEHell: ; //
    lKoi: ;    //
    lOTroy: ;  //
    lNTroy: ;  //
    lPrWald: ; //
    lEth: ;   //
    lElb: ;    //
    lPrCelt: ; //
    lBesk: ;   //
    lBrug: ;  //
  end;
end; {PartOfSpeech}

procedure TDictForm.AffixDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
begin
  ACanvas.Font.Assign(Font);
  Neogrammarian.DrawUnicode(ACanvas, ARect, Font.Color, IfThen(Selected, clHighlight, Color), False, True, TMenuItem(Sender).Caption);
end; {AffixDrawItem}

procedure TDictForm.ContaminationBtnClick(Sender: TObject);
begin
  CompoundBtn.Down:=False;
  if Sender<>ContaminationBtn then ContaminationBtn.Down:=not ContaminationBtn.Down;
  ContaminationBtn.Tag:=Integer(PThisEntry);
end; {ContaminationBtnClick}

procedure TDictForm.DuplicateBtnClick(Sender: TObject);
begin
  with PThisEntry^ do AddWord(Word, StressDia, Ending, System.Word(-1), Gloss+'…', Connots, $FF, PThisEntry, nil);
end; {DuplicateBtnClick}

procedure TDictForm.CopyBtnClick(Sender: TObject);
begin
  if Sender=Copyword1 then Sender:=CopyBtn;
  FillMainWord(3, ThisLang, PThisEntry);
  Neogrammarian.CopyBtnClick(Sender);
end; {CopyBtnClick}

procedure TDictForm.DelBtnClick(Sender: TObject);
  procedure RemoveFromAnc(This, Anc: PDictEntry);
  var i, j: Integer;
  begin
    with Anc^ do for i:=0 to Length(Descendants)-1 do if Descendants[i].Entry=This then begin
      for j:=i to Length(Descendants)-2 do Descendants[j]:=Descendants[j+1];
      SetLength(Descendants, Length(Descendants)-1);
    end;
  end;
  procedure DelEntry(ALang: Integer; E: PDictEntry; OnlyThis: Boolean);
  var i: Integer;
  begin
    with E^ do begin
      if Ancestor.Lang<255 then RemoveFromAnc(E, Ancestor.Entry);
      if (Ancestor.Lang=ALang) and (Ancestor2<>nil) then RemoveFromAnc(E, Ancestor2);
      if OnlyThis then for i:=0 to Length(Descendants)-1 do with Descendants[i] do begin
        if (Lang=Entry.Ancestor.Lang) and (Entry.Ancestor2<>nil) then
          if Entry.Ancestor2=E then RemoveFromAnc(Entry, Entry.Ancestor.Entry) else RemoveFromAnc(Entry, Entry.Ancestor2);
        Entry.Ancestor.Lang:=255;
        Entry.VarCode:=$FF;
      end else for i:=Length(Descendants)-1 downto 0 do with Descendants[i] do DelEntry(Lang, Entry, False);
      with CheckListBox.Items do for i:=Count-1 downto 0 do if (E=Pointer(Objects[i])) or (E=Pointer(HexToInt(Copy(Strings[i], 5, 8)))) then Delete(i);
      if CheckListBox.Items.Count=0 then CheckListBoxClear;
      if (E=Neogrammarian.DictLinkS) or (E=Neogrammarian.DictLinkT) then begin
        Neogrammarian.DictLinkS:=nil;
        Neogrammarian.DictLinkT:=nil;
      end;
      with Dicts[ALang] do Remove(E);
      i:=WordInTree(E);
      if i>-1 then DisconnectSemNode(SemanticTree.Items[i]);
      Dispose(E);
    end;
  end;
const mbs: array[False..True] of TMsgDlgButtons = ([mbYes, mbNo], [mbYes, mbNo, mbYesToAll]);
var a, i: Integer;
begin
  with PThisEntry^ do a:=TangoMessageBox('Delete selected word?'+Copy(#13#10'(Delete all of its descendants as well? Otherwise they will be left without an ancestor.)',
    1, 1000*(Ord(Length(Descendants)>0))), mtConfirmation, mbs[Length(Descendants)>0], '');
  if a<>idNo then begin
    i:=WordListBox.ItemIndex;
    DelEntry(ThisLang, PThisEntry, a=idYes);
    LangTreeChange(nil, nil);
    WordListBox.ItemIndex:=Min(i, WordListBox.Items.Count-1);
    WordListBoxClick(nil);
  end;
end; {DelBtnClick}
              
procedure TDictForm.SortClick(Sender: TObject);
var i: Integer;
begin
  with TMenuItem(Sender) do Checked:=not Checked;
  if Sender=GlossSort then InternalSort.Checked:=False else GlossSort.Checked:=False;
  for i:=0 to High(LangNs) do DictSort(i);
  LangTreeChange(nil, nil);
end; {SortClick}

procedure TDictForm.ConfirmedBoxClick(Sender: TObject);
  procedure UncheckDescendants(E: PDictEntry; var Answer: Integer);
  var i: Integer;
  begin
    for i:=0 to Length(E.Descendants)-1 do with E.Descendants[i].Entry^ do if Confirmed then begin
      if Answer=0 then Answer:=TangoMessagebox('Un-confirm descendants as well?', mtConfirmation, [mbYes, mbNo], '');
      if Answer=idYes then Confirmed:=False;
      UncheckDescendants(E.Descendants[i].Entry, Answer);
    end;
  end; {UncheckDescendants}
var e: PDictEntry;
    manual: Boolean;
    answer: Integer;
begin
  e:=PThisEntry;
  manual:=e.Confirmed<>ConfirmedBox.Checked;
  e.Confirmed:=ConfirmedBox.Checked;
  answer:=0;
  if manual then
    if e.Confirmed then while e.Ancestor.Lang<255 do begin
      e:=e.Ancestor.Entry;
      if not e.Confirmed then begin
        if answer=0 then answer:=TangoMessagebox('Confirm ancestors as well?', mtConfirmation, [mbYes, mbNo], '');
        if answer=idYes then e.Confirmed:=True;
      end;
    end else UncheckDescendants(e, answer);
  UpdateWordListLabel;
  WordListBox.Invalidate;
  WordImage.Invalidate;
  AncestorImage.Invalidate;
  DescendantsListBox.Invalidate;
end; {ConfirmedBoxClick}

procedure TDictForm.ImagePaint(Sender: TObject);
var l: Integer;
    e: PDictEntry;
begin
  e:=nil;
  if (LangTree.Selected<>nil) and (WordListBox.ItemIndex>-1) then begin
    l:=ThisLang;
    if Sender<>AncestorImage then e:=PDictEntry(Dicts[l][WordListBox.ItemIndex]) else with PThisEntry^ do begin
      if AncestorImage.Tag=0 then e:=Ancestor.Entry else e:=Ancestor2;
      l:=Ancestor.Lang;
    end;
  end else l:=255;
  with TPaintBox(Sender) do if l<255 then begin
    FillMainWord(3, l, e);
    Hint:=Neogrammarian.DrawWord(3, Canvas, Rect(0, 0, Width, Height), True, Sender=AncestorImage, 0);
    if not e.Confirmed then with Canvas do begin
      Font.Color:=clRed;
      Font.Style:=[];
      TextOut(Width-TextWidth('?')-1, 2, '?');
    end;
  end else begin
    Canvas.FillRect(Rect(0, 0, Width, Height));
    Hint:='';
  end;
end; {ImagePaint}

{----------------------------------------------------------Semantics--------------------------------------------------------------}

procedure TDictForm.GlossEditChange(Sender: TObject);
var st: string;
  procedure Glosses(E: PDictEntry);
  var i: Integer;
  begin
    E.Gloss:=GlossEdit.Text;
    for i:=0 to Length(E.Descendants)-1 do if (E.Descendants[i].Entry.Gloss='') or (E.Descendants[i].Entry.Gloss=st) then Glosses(E.Descendants[i].Entry);
  end;
var e: PDictEntry;
begin
  if GlossEdit.Tag=0 then begin
    e:=PThisEntry;
    st:=e.Gloss;
    Glosses(e);
    if GlossSort.Checked then begin
      Dicts[ThisLang].Sort(DictGlossCompare);
      WordListBox.ItemIndex:=Dicts[ThisLang].IndexOf(e); {use e because PDictEntry has changed meanwhile}
    end;
    if WideWordListBox then WordListBox.Invalidate;
  end;
end; {GlossEditChange}

procedure TDictForm.ConnotListBoxClick(Sender: TObject);
begin
  UpdateConnot(-1);
end; {ConnotListBoxClick}

procedure TDictForm.ConnotListBoxDblClick(Sender: TObject);
begin
  with ConnotIsFrom(ConnotListBox.ItemIndex) do if Entry<>PThisEntry then GotoEntry(Lang, Entry);
end; {ConnotListBoxDblClick}

procedure TDictForm.ConnotListBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  with ConnotListBox.Canvas do if Length(PThisEntry.Connots)>Index then begin
    if odSelected in State then Brush.Color:=clBtnFace;
    with PThisEntry.Connots[Index] do case Status of
      csIncluded: Font.Color:=clGrayText;
      csWarning: Font.Color:=clRed;
      csFixedWarning: Font.Color:=$7070B0;
      else if Index<PThisEntry.OldConnots then Font.Color:=clWindowText else Font.Color:=clBlue;
    end;
    if PThisEntry.Connots[Index].Status in [csIncluded, csFixedWarning] then Font.Style:=[fsStrikeOut];
    Neogrammarian.DrawUnicode(ConnotListBox.Canvas, Rect, Font.Color, Brush.Color, False, False, PThisEntry.Connots[Index].Kind);
  end;
end; {ConnotListBoxDrawItem}

procedure TDictForm.UpdateConnot(Index: Integer);
var i: Integer;
begin
  with ConnotListBox, PThisEntry^ do begin      
    if Index>-1 then begin
      Clear;
      for i:=0 to Length(Connots)-1 do with Connots[i] do begin
        Items.Add('');
        ConnotListBox.Checked[i]:=Status in [csUsed, csIncluded, csFixedWarning];
      end;
      ItemIndex:=Index;
    end;
    ConnotDelBtn.Enabled:=Length(Connots)>0;  // delete error message: cave OldConnots (i.e. number of inherited Connots) 
    ConnotDelBtn.Down:=(Length(Connots)>0) and (Connots[ItemIndex].Status in [csIncluded, csFixedWarning]);
    if Length(Connots)>0 then ConnotDelBtn.Hint:=IfThen(Connots[ItemIndex].Status<=csIncluded,
      IfThen(ConnotDelBtn.Down, 'Ex', 'In')+'clude connotation '+IfThen(ConnotDelBtn.Down, 'from', 'in')+' lemma',
      'Mark warning as '+ IfThen(ConnotDelBtn.Down, 'open', 'fixed')) else ConnotDelBtn.Hint:='';
  end;
end; {UpdateConnot}

procedure TDictForm.ConnotListBoxClickCheck(Sender: TObject);
  procedure CheckDescendants(E: PDictEntry; Index: Integer; var Answer: Integer);
  var i: Integer;
  begin
    for i:=0 to Length(E.Descendants)-1 do with E.Descendants[i].Entry^ do if (Length(Connots)>Index) and (Connots[Index].Status=csUnused) then begin
      if Answer=0 then Answer:=TangoMessagebox('Check descendant connotations too?', mtConfirmation, [mbYes, mbNo], '');
      if Answer=idYes then Connots[Index].Status:=csUsed;
      CheckDescendants(E.Descendants[i].Entry, Index, Answer);
    end;
  end; {CheckDescendants}
var e: PDictEntry;
    answer: Integer;
begin
  e:=PThisEntry;
  with ConnotListBox do case e.Connots[ItemIndex].Status of
    csIncluded: ConnotListBox.Checked[ItemIndex]:=True;
    csWarning, csFixedWarning: ConnotDelBtnClick(Sender);
    else begin
      e.Connots[ItemIndex].Status:=TConnotStatus(ConnotListBox.Checked[ItemIndex]);
      answer:=0;
      if e.Connots[ItemIndex].Status=csUnused then while e.Ancestor.Lang<255 do begin
        e:=e.Ancestor.Entry;
        if Length(e.Connots)>ItemIndex then
          if e.Connots[ItemIndex].Status=csUsed then begin
            if answer=0 then answer:=TangoMessagebox('Uncheck ancestor connotations too?', mtConfirmation, [mbYes, mbNo], '');
            if answer=idYes then e.Connots[ItemIndex].Status:=csUnused;
          end else if e.Connots[ItemIndex].Status=csIncluded then Break;
      end else CheckDescendants(e, ItemIndex, answer);
    end;
  end;
end; {ConnotListBoxClickCheck}

procedure TDictForm.CopyConnotBtnClick(Sender: TObject);
begin
  Clipboard.AsText:='<h3>Usage notes</h3>'#13#10'<p>…</p>'#13#10;
end; {CopyConnotBtnClick}

procedure TDictForm.ConnotDelBtnClick(Sender: TObject);                           // merge with ConnotListBoxClickCheck?
  procedure DelDescendants(E: PDictEntry; Index: Integer; var Answer: Integer);     // merge with CheckDescendants, UncheckDescendants?
  var i: Integer;
  begin
    for i:=0 to Length(E.Descendants)-1 do with E.Descendants[i].Entry^ do if (Length(Connots)>Index) and (Connots[Index].Status in [csUnused, csUsed, csWarning]) then with Connots[Index] do begin
      if Answer=0 then Answer:=TangoMessagebox(IfThen(Status<>csWarning, 'Include descendant connotations', 'Mark descendant warnings as fixed')+' too?', mtConfirmation, [mbYes, mbNo], '');
      if Answer=idYes then
        if Status<>csWarning then Status:=csIncluded else Status:=csFixedWarning;
      DelDescendants(E.Descendants[i].Entry, Index, Answer);
    end;
  end; {DelDescendants}
var e: PDictEntry;
    answer: Integer;
begin
  if ConnotDelBtn.Enabled then begin
    e:=PThisEntry;
    with ConnotListBox do begin
      with e.Connots[ItemIndex] do case Status of
        csUnused, csUsed: Status:=csIncluded;
        csIncluded:       Status:=csUsed;
        csWarning:        Status:=csFixedWarning;
        csFixedWarning:   Status:=csWarning;
      end;
      answer:=0;
      if e.Connots[ItemIndex].Status in [csUnused, csUsed, csWarning] then while e.Ancestor.Lang<255 do begin
        e:=e.Ancestor.Entry;
        if Length(e.Connots)>ItemIndex then with e.Connots[ItemIndex] do
          if Status in [csIncluded, csFixedWarning] then begin
            if answer=0 then answer:=TangoMessagebox(IfThen(Status=csIncluded, 'Exclude ancestor connotations', 'Mark ancestor warnings as open')+' too?', mtConfirmation, [mbYes, mbNo], '');
            if answer=idYes then
              if Status=csIncluded then Status:=csUsed else Status:=csWarning;
          end;
      end else DelDescendants(e, ItemIndex, answer);
    end;
    UpdateConnot(ConnotListBox.ItemIndex);
  end;
end; {ConnotDelBtnClick}

procedure TDictForm.ConnotPopupPopup(Sender: TObject);
var i: Integer;
begin
  i:=ConnotListBox.ItemAtPos(ConnotListBox.ScreenToClient(Mouse.CursorPos), True);
  Gotoorigin1.Enabled:=(i>-1) and (ConnotIsFrom(i).Entry<>PThisEntry);
  if i>-1 then ConnotListBox.ItemIndex:=i;
  Copyconnotations1.Enabled:=ConnotListBox.Items.Count>0;
end; {ConnotPopupPopup}

procedure TDictForm.Copyconnotations1Click(Sender: TObject);
var i: Integer;
    st: string;
begin
  st:='';
  with PThisEntry^ do for i:=0 to Length(Connots)-1 do with Connots[i] do st:=st+Kind+' ['+csString[Status]+', from '+LongLangNs[ConnotIsFrom(i).Lang]+']'#13#10;
  CopyRTFasUnicode(PercentToRTF(st));
end; {Copyconnotations1Click}

{----------------------------------------------------------Etymology--------------------------------------------------------------}

procedure TDictForm.AncestorImageDblClick(Sender: TObject);
begin
  with PThisEntry.Ancestor do if Lang<255 then
    if (Lang<>ThisLang) or (PThisEntry.Ancestor2=nil) or ((AncestorImage.Tag=0) xor (Sender<>Gotoancestor1))
      then GotoEntry(Lang, Entry) else GotoEntry(ThisLang, PThisEntry.Ancestor2);
end; {AncestorImageDblClick}

procedure TDictForm.Gotoultimateancestor1Click(Sender: TObject);
begin
  while PThisEntry.Ancestor.Lang<255 do AncestorImageDblClick(Gotoancestor1);
end; {Gotoultimateancestor1Click}

procedure TDictForm.AncestorImageClick(Sender: TObject);
var e: PDictEntry;
begin
  with PThisEntry^ do if (Ancestor.Lang=ThisLang) and (Ancestor2<>nil) then begin
    AncestorImage.Tag:=1-AncestorImage.Tag;
    AncestorLabel.Caption:='Word '+IntToStr(AncestorImage.Tag+1);
    AncestorImage.Invalidate;
    with PThisEntry^ do if AncestorImage.Tag=0 then e:=Ancestor.Entry else e:=Ancestor2;
    SetEditBtn(EditBtn2, e, Ancestor.Lang);
  end;
end; {AncestorImageClick}

procedure TDictForm.VariantPaintBoxPaint(Sender: TObject);
var st: string;
begin
  st:=Variant(PThisEntry.Ancestor.Lang, ThisLang, PThisEntry, False);
  with VariantPaintBox do Neogrammarian.DrawUnicode(Canvas, Rect(0, 0, Width, Height), IfThen(st='', clGrayText, Font.Color), Color, False, False, IfThen(st='', '[ none ]', st));
end; {VariantPaintBoxPaint}

procedure TDictForm.IrregularComboChange(Sender: TObject);
const clIrreg: array[False..True] of TColor = (clWindowText, clRed);
begin
  PThisEntry.Irregular:=IrregularCombo.Text;
  IrregularCombo.Font.Color:=clIrreg[IrregularCombo.Text=UndefIrreg];
end; {IrregularComboChange}

procedure TDictForm.DescendantsListBoxDblClick(Sender: TObject);
begin
  with PLemma(DescendantsListBox.Items.Objects[DescendantsListBox.ItemIndex])^ do GotoEntry(Lang, Entry);
end; {DescendantsListBoxDblClick}

procedure TDictForm.ExpandDescBoxClick(Sender: TObject);
  procedure AddDescendants(Entry: PDictEntry; Level: Integer);
  var i: Integer;
  begin
    with Entry^ do for i:=0 to Length(Descendants)-1 do begin
      DescendantsListBox.Items.AddObject(IntToStr(Level), @Descendants[i]);
      if ExpandDescBox.Checked then AddDescendants(Descendants[i].Entry, Level+1);
    end;
  end;
begin
  DescendantsListBox.Clear;
  if WordListBox.ItemIndex>-1 then AddDescendants(PThisEntry, 0);
end; {ExpandDescBoxClick}

procedure TDictForm.CopyEtyBtnClick(Sender: TObject);
var l: TLemma;
    i, oldlen, wordlen, oldlang: Integer;
    loop0, lem, oldlem, conn, glosspending: Boolean;
    st, st2, wrd, oldwrd, oldgloss, rem: string;
    anc2: array of TLemma;
    anc2code: ByteArray;
begin
  l.Lang:=ThisLang;  l.Entry:=PThisEntry;
  loop0:=True;  oldlem:=False;  conn:=False;
  for i:=0 to Length(l.Entry.Connots)-1 do if l.Entry.Connots[i].Status<csIncluded then conn:=True;
  st:='';  oldwrd:='';  oldgloss:='';
  oldlen:=0;  wordlen:=0;
  oldlang:=255;
  glosspending:=False;
  repeat                                
    FillMainWord(3, l.Lang, l.Entry);
    st:=st+IfThen(not loop0, '&'+IfThen(l.Lang<>oldlang, 'lt', 'ensp')+';&nbsp;<abbr title="'+LongLangNs[l.Lang]+'">'+LangNs[l.Lang]+'</abbr> ');
    st2:=Neogrammarian.MakeWordHTML(3, -1, -1, IfThen(loop0, 'h2', 'span'), loop0, wrd, lem);
    if (wrd=oldwrd) and (lem=oldlem) and (GlossBrackets(l.Entry.Gloss, False)=oldgloss) and (rem='') then st:=Copy(st, 1, oldlen-1)+', '+Copy(st, oldlen+wordlen+17-2*Ord(l.Lang=oldlang), MaxInt)
      else glosspending:=False;
    oldwrd:=wrd;
    oldlem:=lem;
    oldlen:=Length(st);
    if loop0 and (Sender=CopyEtyOutlineBtn) then st2:=st2+#13#10'<p><span class="dictadd">to</span>';
    if (GlossBrackets(l.Entry.Gloss, False)<>oldgloss) or glosspending then begin
      st2:=st2+StringReplace(' '+GlossBrackets(l.Entry.Gloss, not loop0), ' ‘’', '', []);
      glosspending:=True;
    end;
    wordlen:=Length(st2);
    st:=st+st2;
    oldgloss:=GlossBrackets(l.Entry.Gloss, False);
    if loop0 then begin
      st:=st+'</p>'#13#10#13#10;
      if Sender=CopyEtyBtn then st:='' else if conn then st:=st+'<h3>Usage notes</h3>'#13#10'<p>…</p>'#13#10#13#10;
      st:=st+'<h3>Etymology</h3>'#13#10'<p>';
    end;
    rem:=ConcatCommas([Trim(RemoveFrom('[{', l.Entry.Irregular)), Variant(l.Entry.Ancestor.Lang, l.Lang, l.Entry, True)]);
    if (rem='') and (l.Entry.Ancestor.Lang=255) and not (l.Lang in [lPIE, lGhe]) then rem:='of unknown origin';
    st:=st+IfThen(rem<>'', IfThen(loop0, #13#10, ', ')+rem+IfThen(l.Entry.Ancestor.Lang<255, ' of'))+IfThen((l.Entry.Ancestor.Lang<255) and (not loop0 or (rem<>'')) or (Length(anc2)>0), '<br>')+#13#10;
    oldlang:=l.Lang;
    if (l.Entry.Ancestor.Lang=l.Lang) and (l.Entry.Ancestor2<>nil) then begin
      SetLength(anc2, Length(anc2)+1);
      anc2[Length(anc2)-1].Entry:=l.Entry.Ancestor2;
      anc2[Length(anc2)-1].Lang:=l.Lang;
      SetLength(anc2code, Length(anc2));
      anc2code[Length(anc2)-1]:=l.Entry.VarCode;
      if (l.Entry.VarCode=16{contamination}) and (l.Entry.Ancestor.Lang<255) then l:=l.Entry.Ancestor;
    end;
    l:=l.Entry.Ancestor;
    if (l.Lang=255) and (Length(anc2)>0) then begin
      l:=anc2[Length(anc2)-1];
      oldlang:=l.Lang;                
      st:=st+'<span class="etysep">&emsp;—'+IfThen(anc2code[Length(anc2)-1]=16{contamination}, 'with', 'and')+'—</span><br>'#13#10;
      if (anc2code[Length(anc2)-1]=16{contamination}) and (l.Entry.Ancestor.Lang<255) then l:=l.Entry.Ancestor;
      SetLength(anc2, Length(anc2)-1);
    end;
    loop0:=False;
  until l.Lang=255;
  if Copy(st, Length(st)-4, 5)='<p>'#13#10 then st:=st+'of unknown origin'#13#10;
  CopyRTFasUnicode(PercentToRTF(st+'</p>'#13#10+IfThen((Sender=CopyEtyOutlineBtn) and (oldlang=lPIE), #13#10'<h4>Cognates</h4>'#13#10'<p>…, …</p>'#13#10)));
end; {CopyEtyBtnClick}

procedure TDictForm.CopyEngBtnClick(Sender: TObject);
var gloss, st, wrd: string;
    lem: Boolean;
begin
  FillMainWord(3, ThisLang, PThisEntry);
  gloss:=GlossBrackets(GlossEdit.Text, False);
  st:='<h2 id="x'+LowerCase(RemoveDiacritics(RemoveFrom(', ', gloss)))+'">'+gloss+'</h2>'#13#10'<p><span class="dictcat">…:</span> '+
    Neogrammarian.MakeWordHTML(3, -1, -1, IfThen(ThisLang=lModLem, 'a ¥', 'span'), False, wrd, lem)+'</p>'#13#10;
  CopyRTFasUnicode(StringReplace(st, '¥', 'href="../le.php?'+MakeLemId(wrd)+'"', []));
end; {CopyEngBtnClick}

procedure TDictForm.CognatesBtnClick(Sender: TObject);
var p: TPoint;
begin
  p:=BackPanel.ClientToScreen(Point(CognatesBtn.Left, CognatesBtn.Top+CognatesBtn.Height));
  CognatesPopup.Popup(p.X, p.Y);
end; {AffixBtnClick}

procedure TDictForm.PlaceCognatesMenuItem(Index: Integer);
var c, i: Integer;
begin
  c:=CognatesPopup.Items.Count-1;
  CognatesPopup.Items[Index].MenuIndex:=c;
  i:=3;
  while LowerCase(CognatesPopup.Items[i].Caption)<LowerCase(CognatesPopup.Items[c].Caption) do Inc(i);
  CognatesPopup.Items[c].MenuIndex:=i;
end; {PlaceCognatesMenuItem}

procedure TDictForm.CognatesClick(Sender: TObject);
var p, i: Integer;
    l, a, c: string;
    nl: Boolean;
begin
  with TMenuItem(Sender) do begin
    l:=Caption;
    p:=Pos(',', Hint);
    a:=Copy(Hint, 2, p-2);
    c:=Copy(Hint, p+1, MaxInt);
    nl:=(Hint+' ')[1]='+';
    if EditCognate1.Checked then case CognatesForm.ShowModalEx(l, a, c, nl, True) of
      mrOK: begin
        Caption:=Trim(CognatesForm.LangEdit.Text);
        Hint:=CognatesForm.MenuHint;
        PlaceCognatesMenuItem(MenuIndex);
      end;
      mrNo: CognatesPopup.Items.Delete(MenuIndex);
    end else begin
      for i:=Length(l) downto 2 do if (l[i] in ['A'..'Z']) and (l[i-1] in ['A'..'Z']) then l[i]:=Char(Ord(l[i])+32);
      Clipboard.AsText:='<abbr title="'+l+'">'+a+'</abbr> <span lang="'+c+'"'+IfThen(nl, ' title="…"')+'>…</span>'+IfThen((c<>'en') and (Copy(c, 1, 3)<>'en-'), ' ‘…’');
    end;
  end;
  EditCognate1.Checked:=False;
end; {CognatesClick}

procedure TDictForm.AddCognate1Click(Sender: TObject);
begin
  with CognatesForm do if ShowModalEx('', '', '', False, False)=mrOK then with AddMenuItem(self, Trim(LangEdit.Text), 0, CognatesClick, CognatesPopup.Items) do begin
    Hint:=MenuHint;
    PlaceCognatesMenuItem(MenuIndex);
  end;
  EditCognate1.Checked:=False;
end; {AddCognate1Click}

procedure TDictForm.EditCognate1Click(Sender: TObject);
begin
  EditCognate1.Checked:=not EditCognate1.Checked;
end; {EditCognate1Click}

{----------------------------------------------------------Find--------------------------------------------------------------}

procedure TDictForm.FindClearClick(Sender: TObject);
begin
  FindEdit.Text:='';
  FindEdit.Color:=clWindow;
  FindType0.Checked:=True;
  FindNoDescs.Checked:=False;
  FindEditChange(FindEdit);
end; {FindClearClick}

procedure TDictForm.FindEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Shift=[] then case Key of
   VK_Return: FindEditChange(FindDown);
   VK_Escape: FindClearClick(nil);
  end;
  if (Shift=[ssShift]) and (Key=VK_F3) then FindEditChange(FindUp);
end; {FindEditKeyDown}

procedure TDictForm.FindOptsClick(Sender: TObject);
var p: TPoint;
begin
  p:=FindPanel.ClientToScreen(Point(FindOpts.Left, FindOpts.Top+FindOpts.Height));
  FindPopup.Popup(p.X, p.Y);
end; {FindOptsClick}

procedure TDictForm.FindTypeClick(Sender: TObject);
begin
  TMenuItem(Sender).Checked:=True;
  FindEditChange(FindEdit);
end; {FindTypeClick}

procedure TDictForm.FindNoDescsClick(Sender: TObject);
begin
  FindNoDescs.Checked:=not FindNoDescs.Checked;
  FindEditChange(FindEdit);
end; {FindNoDescsClick}

procedure TDictForm.FindEditChange(Sender: TObject);
var l, w: Integer;
  procedure Hop;
  begin
    Inc(w, TComponent(Sender).Tag);
    if (w<0) or (w>Dicts[l].Count-1) then begin
      repeat l:=(l+TComponent(Sender).Tag+Length(LangNs)) mod Length(LangNs) until (Dicts[l].Count>0) or (l=ThisLang);
      if Sender=FindUp then w:=Dicts[l].Count-1 else w:=0;
    end;
  end;
  procedure SetFindShape(Control: TControl);
  begin
    FindShape.Left:=Control.Left-FindShape.Width;
    FindShape.Top:=Control.Top+Control.Height div 2 - FindShape.Height div 2;
    FindShape.Show;
  end;
var i, f, t, p: Integer;
    v, fe0: string;
begin
  t:=0;
  for i:=0 to MaxFindType do if TMenuItem(FindComponent('FindType'+IntToStr(i))).Checked then t:=i;
  FindOpts.Down:=not FindType0.Checked or FindNoDescs.Checked;
  FindOpts.Hint:='Find —'#13#10'• '+Trim(TMenuItem(FindComponent('FindType'+IntToStr(t))).Caption)+IfThen(FindNoDescs.Checked, #13#10'• '+FindNoDescs.Caption);
  FindShape.Hide;
  if DictForm.Visible then FocusControl(FindEdit);
  FindClear.Enabled:=(FindEdit.Text<>'') or not FindType0.Checked or FindNoDescs.Checked;
  FindDown.Enabled:=FindClear.Enabled;
  FindUp.Enabled:=FindClear.Enabled;
  l:=ThisLang;
  w:=WordListBox.ItemIndex;
  fe0:=UpperCase(FindEdit.Text);
  while ((fe0+' ')[1]='0') and ((fe0+'  ')[2] in ['0'..'9', 'A'..'F']) do Delete(fe0, 1, 1);
  if Sender<>FindEdit then Hop;
  if (w>-1) and FindClear.Enabled then repeat with PDictEntry(Dicts[l][w])^ do begin
    f:=-10;
    if not FindNoDescs.Checked or (Length(Descendants)=0) then begin
      if (t in [0, 1]) and (Pos(LowerCase(FindEdit.Text), LowerCase(Gloss))>0) or (t=1) and (FindEdit.Text='') and (Gloss<>'') then f:=-1 else begin
        if t in [0, 2..4] then for i:=0 to Length(Connots)-1 do if (Connots[i].Status<=csIncluded)
          and ((Pos(LowerCase(FindEdit.Text), LowerCase(Connots[i].Kind))>0) or (t>0) and (FindEdit.Text=''))
          and ((t<>3) or (Connots[i].Status=csUnused)) and ((t<>4) or (Connots[i].Status<csIncluded)) then begin f:=i; Break; end;
        if (f=-10) and (t in [0, 5, 6]) then for i:=0 to Length(Connots)-1 do if (Connots[i].Status>=csWarning)
          and ((Pos(LowerCase(FindEdit.Text), LowerCase(Connots[i].Kind))>0) or (t>0) and (FindEdit.Text=''))
          and ((t<>6) or (Connots[i].Status=csWarning)) then begin f:=i; Break; end;
      end;
      v:=Variant(Ancestor.Lang, l, PDictEntry(Dicts[l][w]), False);
      repeat
        p:=Pos('%', v);
        if p>0 then Delete(v, p, 5);
      until p=0;
      if (f=-10) and (t in [0, 7]) and ((Pos(LowerCase(FindEdit.Text), LowerCase(v        ))>0) or (fe0=IntToStr(VarCode)) or (fe0=IntToHex(VarCode, 1)+'X'))
                                                                                                or (t=7) and (FindEdit.Text='') and (v        <>'') then f:=-4;
      if (f=-10) and (t in [0, 8]) and  (Pos(LowerCase(FindEdit.Text), LowerCase(Irregular))>0) or (t=8) and (FindEdit.Text='') and (Irregular<>'') then f:=-2;
      if (f=-10) and (FindEdit.Text='') and FindNoDescs.Checked then f:=-3;
    end;
    if f>-10 then begin
      GotoEntry(l, PDictEntry(Dicts[l][w]));
      if f>-1 then begin
        ConnotListBox.ItemIndex:=f;
        UpdateConnot(-1);
      end;
      if f=-1 then SetFindShape(GlossEdit) else if f=-2 then SetFindShape(IrregularCombo) else if f=-3 then SetFindShape(DescendantsListBox) else if f=-4 then SetFindShape(VariantPaintBox) else
        if f>-1 then SetFindShape(ConnotListBox);
    end else Hop;
  end until (f>-10) or (l=ThisLang) and (w=WordListBox.ItemIndex)
    else f:=-9;
  FindEdit.Color:=IfThen(f>-10, clWindow, $c0c0ff);
end; {FindEditChange}

procedure TDictForm.FindShapeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FindShape.Hide;
end; {FindShapeMouseUp}

{----------------------------------------------------------Semantic tree--------------------------------------------------------}

function TDictForm.WordInTree(E: PDictEntry): Integer;
var i: Integer;
begin
  Result:=-1;
  with SemanticTree do for i:=0 to Items.Count-1 do if Items[i].Data=E then Result:=i;
end; {WordInTree}

procedure TDictForm.UpdateSemTreeBtn;
begin
  Addtotree1.Enabled:=(ThisLang=lModLem) and (WordListBox.ItemIndex>-1) and (PThisEntry^.MorphBound=65535);
  Addtotree1.Caption:=IfThen(Addtotree1.Enabled, IfThen(WordInTree(PThisEntry)>-1, 'Find word in', 'Add word to'), 'Can’t add word to')+' semantic tree';
  SemTreeBtn.Enabled:=Addtotree1.Enabled;
  SemTreeLabel.Visible:=(WordInTree(PThisEntry)=-1) and SemTreeBtn.Enabled;
  SemTreeBtn.Hint:=Addtotree1.Caption+IfThen(SemTreeBtn.Enabled, ' (Ctrl++)');
end; {UpdateSemTreeBtn}

procedure TDictForm.DisconnectSemNode(Node: TTreeNode);
begin
  Node.Text:=PDictEntry(Node.Data)^.Gloss;
  Node.Data:=nil;
  SemChangeBtn.Hint:='Change title of node (Ctrl+C)';
end; {DisconnectSemNode}

// keyboard shortcuts: something is strange with the shortcuts for sheet 1
// Buttons: Sort alphabetically, TTreeNode.Collapse(Recurse: True) / Expand 
// verbs of movement, force and damage, colours, elements

procedure TDictForm.SemanticPopupPopup(Sender: TObject);
var p: TPoint;
begin
  p:=SemanticTree.ScreenToClient(Mouse.CursorPos);
  SemanticTree.Selected:=SemanticTree.GetNodeAt(p.X, p.Y);
  Addchildnodewithoutaword1.Enabled:=SemAddEmptyBtn.Enabled;
  Deletenode1.Enabled:=SemDelBtn.Enabled;
  Changenode1.Enabled:=SemChangeBtn.Enabled;
  Changenode1.Caption:=SemChangeBtn.Hint;
  Moveup1.Enabled:=SemUpBtn.Enabled;
  Movedown1.Enabled:=SemDownBtn.Enabled;
  Movetodifferentparentnode1.Enabled:=SemMoveBtn.Enabled;
  Sortchildrenalphabetically1.Enabled:=SemSortBtn.Enabled;
end; {SemanticPopupPopup}

procedure TDictForm.SemTreePanelResize(Sender: TObject);
begin
  SemanticTree.Invalidate;
end; {SemTreePanelResize}

procedure TDictForm.SemanticTreeCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
var r: TRect;
begin
  with SemanticTree.Canvas do begin
    DefaultDraw:=False;
    r:=Node.DisplayRect(True);
    if cdsSelected in State then Brush.Color:=RGBsB[lModLem];
    FillRect(Node.DisplayRect(False));
    Font.Color:=clBlack;
    Brush.Color:=clBlack;
    TextOut(r.Left-10, r.Top, IfThen(Node.HasChildren, IfThen(Node.Expanded, '–', '+'), '·'));
    if Node.Data<>nil then begin
      FillMainWord(3, lModLem, PDictEntry(Node.Data));
      Neogrammarian.DrawWord(3, SemanticTree.Canvas, r, cdsSelected in State, False, 0);
      TextOut(SemanticTree.Width div 4 +r.Left, r.Top+1, PDictEntry(Node.Data).Gloss);
    end else TextOut(r.Left, r.Top+1, Node.Text);
  end;
end; {SemanticTreeCustomDrawItem}

procedure TDictForm.SemanticTreeChange(Sender: TObject; Node: TTreeNode);
begin
  with SemanticTree do if SemTreeBtn.Down and (Cursor=crHandPoint) then begin
    SemTreeBtn.Down:=False;
    Cursor:=crDefault;
    if Node.Data<>nil then Selected:=Items.AddChildObject(Node, '', PThisEntry) else
      case TangoMessageBoxT('Connect word to this node or add it as child node?', mtConfirmation, [mbYes, mbNo, mbCancel], ['&This', '&Child'], '') of
        idYes: begin
          Node.Text:='';
          Node.Data:=PThisEntry;
        end;
        idNo: Selected:=Items.AddChildObject(Node, '', PThisEntry);
    end;
  end else if SemMoveBtn.Down then begin
   SemMoveBtn.Down:=False;
   Cursor:=crDefault;
   TTreeNode(SemMoveBtn.Tag).MoveTo(Selected, naAddChild);
  end;
  SemAddEmptyBtn.Enabled:=SemanticTree.Selected<>nil;
  SemDelBtn.Enabled:=(SemanticTree.Selected<>nil) and (SemanticTree.Selected.AbsoluteIndex>0);
  SemChangeBtn.Enabled:=SemanticTree.Selected<>nil;
  with SemChangeBtn do if Enabled then Hint:=IfThen(SemanticTree.Selected.Data<>nil, 'Disconnect node from its word', 'Change title of node')+' (Ctrl+C)' else Hint:='No node to change selected';
  SemUpBtn.Enabled:=SemDelBtn.Enabled and (SemanticTree.Selected.GetPrevSibling<>nil);                                {see also DisconnectSemNode}
  SemDownBtn.Enabled:=SemDelBtn.Enabled and (SemanticTree.Selected.GetNextSibling<>nil);
  SemMoveBtn.Enabled:=SemDelBtn.Enabled;
  SemSortBtn.Enabled:=(SemanticTree.Selected<>nil) and false; //SemanticTree.Selected.HasChildren;
end; {SemanticTreeChange}

procedure TDictForm.SemTreeBtnClick(Sender: TObject);
var w: Integer;
begin
  w:=WordInTree(PThisEntry);
  if w>-1 then begin
    SemTreeBtn.Down:=False;
    PageControl.ActivePage:=TreeSheet;
    SemanticTree.Items[w].Selected:=True;
  end else begin
    if Sender<>SemTreeBtn then SemTreeBtn.Down:=not SemTreeBtn.Down;
    if SemTreeBtn.Down then begin
      SemMoveBtn.Down:=False;
      PageControl.ActivePage:=TreeSheet;
      LangLabel.Hide;
      SemanticTree.Selected:=nil;
      SemanticTree.Cursor:=crHandPoint;
    end else SemanticTree.Cursor:=crDefault;
  end;
end; {SemTreeBtnClick}

procedure TDictForm.SemAddEmptyBtnClick(Sender: TObject);
var st: string;
begin
  with SemanticTree do if (Selected<>nil) and TangoInputQuery('Add child node without a word', 'Title:', st) then Items.AddChildObject(Selected, st, nil);
end; {SemAddEmptyBtnClick}

procedure TDictForm.SemDelBtnClick(Sender: TObject);
begin
  with SemanticTree do if (Selected<>nil) and (TangoMessageBox('Delete selected node'+IfThen(Selected.Count>0, ' and all of its child nodes')+'?', mtConfirmation, [mbYes, mbNo], '')=idYes)
    then Items.Delete(Selected);
end; {SemDelBtnClick}

procedure TDictForm.SemChangeBtnClick(Sender: TObject);
var st: string;
begin
  with SemanticTree do if Selected<>nil then begin
    if Selected.Data<>nil then begin
      if TangoMessageBox('Disconnect node ‘'+PDictEntry(Selected.Data).Gloss+'’ from its word?', mtConfirmation, [mbYes, mbNo], '')=idYes then DisconnectSemNode(Selected);
    end else begin
      st:=Selected.Text;
      if TangoInputQuery('Change title of node ‘'+st+'’', 'Title:', st) then Selected.Text:=st;
    end;
  end;
end; {SemChangeBtnClick}

procedure TDictForm.SemUpBtnClick(Sender: TObject);
begin
  with SemanticTree do if (Selected<>nil) and (Selected.GetPrevSibling<>nil) then begin
    Selected.MoveTo(Selected.GetPrevSibling, naInsert);
    SemUpBtn.Enabled:=Selected.GetPrevSibling<>nil;
    SemDownBtn.Enabled:=Selected.GetNextSibling<>nil;
  end;
end; {SemUpBtnClick}

procedure TDictForm.SemDownBtnClick(Sender: TObject);
begin
  with SemanticTree do if (Selected<>nil) and (Selected.GetNextSibling<>nil) then begin
    with Selected do if GetNextSibling.GetNextSibling<>nil then MoveTo(GetNextSibling.GetNextSibling, naInsert) else MoveTo(GetNextSibling, naAdd);
    SemUpBtn.Enabled:=Selected.GetPrevSibling<>nil;
    SemDownBtn.Enabled:=Selected.GetNextSibling<>nil;
  end;
end; {SemUpDownBtnClick}

procedure TDictForm.SemMoveBtnClick(Sender: TObject);
begin
  with SemanticTree do if Selected<>nil then begin
    if Sender<>SemMoveBtn then SemMoveBtn.Down:=not SemMoveBtn.Down;
    if SemMoveBtn.Down then begin
      SemTreeBtn.Down:=False;
      SemanticTree.Cursor:=crHandPoint;
      SemMoveBtn.Tag:=Integer(Selected);
    end else SemanticTree.Cursor:=crDefault;
  end;
end; {SemMoveBtnClick}

function NodeSort(Node1, Node2: TTreeNode; Data: Longint): Integer;
begin
  if (Node1.Data<>nil) and (Node2.Data<>nil) then Result:=DictEntryCompare(Node1.Data, Node2.Data)
    else if (Node1.Data=nil) and (Node2.Data=nil) then Result:=CompareStr(Node1.Text, Node2.Text)
      else Result:=2*Ord(Node2.Data=nil)-1;
end; {NodeSort}

procedure TDictForm.SemSortBtnClick(Sender: TObject);
begin
  with SemanticTree do if Selected<>nil then Selected.CustomSort(@NodeSort, 0);
end; {SemSortBtnClick}

{----------------------------------------------------------Options--------------------------------------------------------------}

procedure TDictForm.FileComboExit(Sender: TObject);
var id: Integer;
begin
  if FileCombo.Text<>DictFile then begin
    if Changed then id:=AskDictSave else id:=idYes;
    if (id=idCancel) or ((id=idYes) and not SaveDict(True)) then FileCombo.Text:=DictFile else begin
      CloseDict;
      DictFile:=FileCombo.Text;
      LoadDict;
      CheckListBoxClear;
    end;
  end;
end; {FileComboExit}

procedure TDictForm.FileComboKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then FileComboExit(Sender);
end; {FileComboKeyPress}

procedure TDictForm.FileComboDropDown(Sender: TObject);
var sr: TSearchRec;
begin
   FileCombo.Items.Clear;
   if FindFirst(PathLabel.Caption+'*.ngr', faAnyFile, sr)=0 then FileCombo.Items.Add(Copy(sr.Name, 1, Length(sr.Name)-4));
   while FindNext(sr)=0 do FileCombo.Items.Add(Copy(sr.Name, 1, Length(sr.Name)-4));
end; {FileComboDropDown}

procedure TDictForm.UploadLabelClick(Sender: TObject);
begin
  FocusControl(UploadCheckBox);
  UploadCheckBox.Checked:=not UploadCheckBox.Checked;
end; {UploadLabelClick}

procedure TDictForm.CheckBtnClick(Sender: TObject);
var i, j, k, l, n: Integer;
    equal, hist: Boolean;
    st: string;
    sl1, sl2: TStringList;
begin
  hist:=Neogrammarian.WordLen[0]>0;
  if hist then Neogrammarian.HistPopupClick(nil);
  CheckListBox.Tag:=1;
  CheckListBox.Items.BeginUpdate;
  CheckListBoxClear;
  TBitBtn(Sender).Font.Color:=clHighlight;
  sl1:=TStringList.Create;
  sl2:=TStringList.Create;
  for i:=0 to High(LangNs) do for j:=0 to Dicts[i].Count-1 do with PDictEntry(Dicts[i][j])^ do for k:=0 to Length(Descendants)-1 do if Descendants[k].Lang<>i then begin
    FillMainWord(0, i, PDictEntry(Dicts[i][j]));
    Neogrammarian.Langs[2,0]:=Descendants[k].Lang;
    with Descendants[k].Entry^, Neogrammarian do if VarCode<$F0 then ComboBox.ItemIndex:=VarCode else if VarCode<$FF then CheckBox.Checked:=VarCode=$F1;
    Neogrammarian.UpdateWord(False, '');
    if Sender=CheckDescBtn then begin
      if (Descendants[k].Entry.Irregular='') or (Descendants[k].Entry.Irregular=UndefIrreg) then begin
        equal:=(Length(Descendants[k].Entry.Word)=Neogrammarian.WordLen[2]) and (Descendants[k].Entry.Ending=Neogrammarian.Ending[2]);
        for n:=0 to Length(Descendants[k].Entry.Word)-1 do if (Descendants[k].Entry.Word[n]<>Neogrammarian.Words[2,n])
          or (Descendants[k].Entry.StressDia[n]<>Neogrammarian.GetStressDia(2, n)) then equal:=False;
      end else equal:=True;
    end else begin
      with Neogrammarian.RemarksBox.Items do for l:=Count-1 downto 0 do if (Objects[l]=Pointer(clWindowText)) or (Objects[l]=Pointer(clRed)) then begin
        st:=Copy(Strings[l], Pos('|', Strings[l])+1, MaxInt);
        if (Length(st)>0) and (st[1]<>'(') then sl1.Add(st);
      end;                                                                                  
      with Descendants[k].Entry^ do for l:=Length(Connots)-1 downto OldConnots do sl2.Add(Connots[l].Kind);
      equal:=sl1.Equals(sl2);
      sl1.Clear;
      sl2.Clear;                                                                           
    end;
    if not equal then CheckListBox.Items.AddObject(IntToHex(i, 2)+IntToHex(Descendants[k].Lang, 2)+IntToHex(Integer(Descendants[k].Entry), 8), Dicts[i][j]);
  end;
  sl1.Free;
  sl2.Free;
  with CheckListBox.Items do if Count=0 then AddObject('[ none ]', nil);
  CheckListBox.Items.EndUpdate;
  CheckListBox.Tag:=0;
  with Neogrammarian.HistPopup do if hist and (Items.Count>0) then Items[0].Click;
end; {CheckBtnClick}

procedure TDictForm.CheckListBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var e: PDictEntry;
begin
  e:=PDictEntry(CheckListBox.Items.Objects[Index]);
  with CheckListBox.Canvas do if e<>nil then begin
    FillMainWord(3, HexToInt(Copy(CheckListBox.Items[Index], 1, 2)), e);
    Neogrammarian.DrawWord(3, CheckListBox.Canvas, Rect, odSelected in State, True, 0);
    TextOut(Rect.Left+CheckListBox.Width div 2-TextWidth('> '), Rect.Top, '>');
    FillMainWord(3, HexToInt(Copy(CheckListBox.Items[Index], 3, 2)), PDictEntry(HexToInt(Copy(CheckListBox.Items[Index], 5, 8))));
    Neogrammarian.DrawWord(3, CheckListBox.Canvas, Classes.Rect(Rect.Left+CheckListBox.Width div 2, Rect.Top, Rect.Right, Rect.Bottom), odSelected in State, True, 0);
  end else begin
    Brush.Color:=clWindow;
    Font.Color:=clGrayText;
    TextOut(Rect.Left+2, Rect.Top+1, CheckListBox.Items[Index]);
  end;
  if odSelected in State then with Rect, CheckListBox.Canvas do begin
    Brush.Style:=bsClear;
    Pen.Color:=clGrayText;
    CheckListBox.Canvas.Rectangle(Left, Top, Right, Bottom);
  end;
end; {CheckListBoxDrawItem}

procedure TDictForm.CheckListBoxDblClick(Sender: TObject);
var e: PDictEntry;
    i: Integer;
begin
  e:=PDictEntry(CheckListBox.Items.Objects[CheckListBox.ItemIndex]);
  if e<>nil then begin
    GotoEntry(HexToInt(Copy(CheckListBox.Items[CheckListBox.ItemIndex], 1, 2)), e);
    PageControl.ActivePage:=DictSheet;
    PageControlChange(nil);
    FocusControl(DescendantsListBox);
    with DescendantsListBox do for i:=0 to Items.Count-1 do
      if Pointer(HexToInt(Copy(CheckListBox.Items[CheckListBox.ItemIndex], 5, 8)))=PLemma(Pointer(Items.Objects[i])).Entry then ItemIndex:=i;
  end;
end; {CheckListBoxDblClick}

procedure TDictForm.CheckListBoxClear;
begin          
  CheckListBox.Items.Clear;
  CheckDescBtn.ParentFont:=True;
  CheckConnotsBtn.ParentFont:=True;
end; {CheckListBoxClear}

{----------------------------------------------------------Utilities--------------------------------------------------------------}

procedure TDictForm.GotoEntry(Lang: Integer; Entry: PDictEntry);
var i: Integer;
begin
  WordListBox.Items.BeginUpdate;
  for i:=0 to LangTree.Items.Count-1 do if (LangTree.Items[i].Level=1) and (Integer(LangTree.Items[i].Data)=Lang)
    then LangTree.Selected:=LangTree.Items[i];
  LangTreeChange(nil, nil);
  WordListBox.ItemIndex:=Dicts[Lang].IndexOf(Entry);
  WordListBoxClick(nil);
  WordListBox.Items.EndUpdate;
end; {GotoEntry}

procedure TDictForm.AddWord(AWord, AStressDia: ByteArray; AEnding, AMorphBound: Integer; AGloss: string; AConnots: TConnotArray; AVarCode: Byte; AAnc1, AAnc2: PDictEntry);
var i, l: Integer;
    e: PDictEntry;
begin
  l:=ThisLang;
  New(e);
  SetLength(e.Word, Length(AWord));           // merge with AddWords.Add, ChangeWord.Change?
  for i:=0 to Length(AWord)-1 do e.Word[i]:=AWord[i];
  SetLength(e.StressDia, Length(AStressDia));
  for i:=0 to Length(AStressDia)-1 do e.StressDia[i]:=AStressDia[i];
  e.Ending:=AEnding;
  e.MorphBound:=AMorphBound;
  e.Gloss:=AGloss;
  e.Confirmed:=False;
  SetLength(e.Connots, Length(AConnots));
  for i:=0 to Length(AConnots)-1 do e.Connots[i]:=AConnots[i];
  e.OldConnots:=Length(AConnots);
  e.VarCode:=AVarCode;
  e.Mark:=0;
  Dicts[l].Add(e);
  DictSort(l);
  AddDescendant(l, l, AAnc1, e, True);
  e.Ancestor2:=AAnc2;
  GotoEntry(l, e); {position of this line is important - otherwise access vio depending on order of compound parts}
  if AAnc2<>nil then AddDescendant(l, l, AAnc2, e, False);
  ToMainBtnClick(EditBtn);
end; {AddWord}

procedure TDictForm.AddDescendant(ELang, DLang: Integer; AEntry, ADescendant: PDictEntry; FirstDesc: Boolean);
var i, p: Integer;
    b: Boolean;
    le: TLemma;
begin
  b:=True;
  for i:=0 to Length(AEntry.Descendants)-1 do if AEntry.Descendants[i].Entry=ADescendant then b:=False;
  if b then begin
    le.Lang:=DLang;
    le.Entry:=ADescendant;
    p:=0;
    while (p<Length(AEntry.Descendants)) and (LemmaCompare(AEntry.Descendants[p], le)<0) do Inc(p);
    SetLength(AEntry.Descendants, Length(AEntry.Descendants)+1);
    for i:=Length(AEntry.Descendants)-1 downto p+1 do AEntry.Descendants[i]:=AEntry.Descendants[i-1];
    AEntry.Descendants[p]:=le;
    if FirstDesc then with ADescendant.Ancestor do begin
      Lang:=ELang;
      Entry:=AEntry;
    end else ADescendant.Ancestor2:=AEntry;
  end;
end; {AddDescendant}

function TDictForm.ConnotIsFrom(Index: Integer): TLemma;
begin
  Result.Lang:=ThisLang;  Result.Entry:=PThisEntry;
  with Result do while (Index<Entry.OldConnots) and (Entry.Ancestor.Lang<255) do begin
    Lang:=Entry.Ancestor.Lang;  Entry:=Entry.Ancestor.Entry;
  end;
end; {ConnotIsFrom}

function TDictForm.PThisEntry: PDictEntry;
begin
  if WordListBox.ItemIndex>-1 then Result:=PDictEntry(Dicts[ThisLang][WordListBox.ItemIndex]) else Result:=nil;
end; {PThisEntry}

function TDictForm.ThisLang: Integer;
begin
  Result:=Integer(LangTree.Selected.Data);
end; {ThisLang}

procedure TDictForm.DictSort(Lang: Integer);
begin
  if GlossSort.Checked then Dicts[Lang].Sort(DictGlossCompare) else begin
    SortInternal:=InternalSort.Checked;
    SortLang:=Lang;
    Dicts[Lang].Sort(DictEntryCompare);
  end;
end; {DictSort}

procedure TDictForm.FillMainWord(i, Lang: Integer; Entry: PDictEntry);
var j: Integer;
begin
  Neogrammarian.Langs[i,0]:=Lang;
  Neogrammarian.WordLen[i]:=Length(Entry.Word);
  for j:=0 to Length(Entry.Word)-1 do Neogrammarian.WordsStressDia[i, j, Entry.StressDia[j]]:=Entry.Word[j];
  Neogrammarian.Ending[i]:=Entry.Ending;
  Neogrammarian.MorphBound[i]:=Entry.MorphBound;
end; {FillMainWord}

function TDictForm.WideWordListBox: Boolean;
begin
 Result:=WordListBox.Width>1.5*LangTree.Width;
end; {WideWordListBox}

function TDictForm.AskDictSave: Integer;
begin
  Result:=TangoMessageBox('Save changes to dictionary ‘'+DictFile+'.ngr’?', mtConfirmation, [mbYes, mbNo, mbCancel], '');
end; {AskDictSave}

function TDictForm.ValidFileHandle: Boolean;
begin
  Result:=HDict<>Invalid_Handle_Value;
end; {ValidFileHandle}

function TDictForm.Changed: Boolean;
begin
  Result:=BackupStr<>MakePHP;
end; {Changed}

end.


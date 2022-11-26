unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ImgList, StdCtrls, ExtCtrls, Buttons, Math,
  ComCtrls, Registry, CommCtrl, Menus, Clipbrd, MyUtils, Data, Dict;

type
  TNeogrammarian = class(TForm)
    ColourList: TImageList;                 HidePanel1: TPanel;                     Label2: TLabel;                         SourceTree: TTreeView;
    SourceBackPanel: TPanel;                SourceLabel: TLabel;                    DownBtn: TSpeedButton;                  CharsBox: TListBox;
    SourcePanel: TPanel;                    SourceImage: TPaintBox;                 TargetBackPanel: TPanel;                TargetPanel: TPanel;
    TargetImage: TPaintBox;                 UpBtn: TSpeedButton;                    Label4: TLabel;                         CheckBox: TCheckBox;
    ComboBox: TComboBox;                    RemarksBox: TListBox;                   TargetBtn: TSpeedButton;                TargetLangPopup: TPopupMenu;
    TargetLabel: TLabel;                    SourceLangPopup: TPopupMenu;            SourceBtn: TSpeedButton;                GheWordBtn: TSpeedButton;
    HidePanel2: TPanel;                     Label1: TLabel;                         TargetBox: TListBox;                    CopyrightLabel: TLabel;
    Image1: TImage;                         LemizhImage: TImage;                    CopySourceBtn: TSpeedButton;            CopyTargetBtn: TSpeedButton;
    VerLabel: TLabel;                       SmallBtn: TSpeedButton;                 SourcePopup: TPopupMenu;                InsertLetter: TMenuItem;
    ToggleAccent1: TMenuItem;               HistPopup: TPopupMenu;                  HistBtn: TBitBtn;                       N1: TMenuItem;
    EscapeWord: TMenuItem;                  AddToHistory: TMenuItem;                PopupImgs: TImageList;                  CharList: TImageList;
    SemBtn: TSpeedButton;                   ToggleAccent2: TMenuItem;               Undo: TMenuItem;                        AccentWarn: TImage;
    LicenseImage: TImage;                   PopupBtn: TSpeedButton;                 BtnPopup: TPopupMenu;                   Copyletterlist: TMenuItem;
    Copylettertable: TMenuItem;             CopyGreekvoweltable: TMenuItem;         DictBtn: TSpeedButton;                  DictPopup: TPopupMenu;
    Showdictionary: TMenuItem;              Addcurrwords: TMenuItem;                Addallwords: TMenuItem;                 ToggleHyphen: TMenuItem;
    ToggleDiaeresis: TMenuItem;             N3: TMenuItem;                          RemarksPopup: TPopupMenu;               CopyRemarks: TMenuItem;
    SemMenuitem: TMenuItem;                 SourceAddImage: TImage;                 TargetAddImage: TImage;                 Recalculate1: TMenuItem;
    N4: TMenuItem;                          N5: TMenuItem;                          InternalSort: TMenuItem;                AddPIEparticiple1: TMenuItem;
    AddPIEparticiple2: TMenuItem;           N6: TMenuItem;                          ToggleMorphbound: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure CharsBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure CharsBoxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImagePaint(Sender: TObject);
    procedure UpBtnClick(Sender: TObject);
    procedure TargetBoxClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure RemarksBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure OptBoxesClick(Sender: TObject);
    procedure AppActivate(Sender: TObject);
    procedure AppDeactivate(Sender: TObject);
    procedure SourceTreeChange(Sender: TObject; Node: TTreeNode);
    procedure SourceTreeChanging(Sender: TObject; Node: TTreeNode; var AllowChange: Boolean);
    procedure SourceTreeClick(Sender: TObject);
    procedure TargetBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure DownBtnClick(Sender: TObject);
    procedure SmallBtnClick(Sender: TObject);
    procedure TargetBtnClick(Sender: TObject);
    procedure SourceBtnClick(Sender: TObject);
    procedure GheWordBtnClick(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    procedure SourcePopupClick(Sender: TObject);
    procedure SourcePopupPopup(Sender: TObject);
    procedure HistBtnClick(Sender: TObject);
    procedure SemBtnClick(Sender: TObject);
    procedure SourceImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SourceImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure LicenseImageClick(Sender: TObject);
    procedure PopupBtnClick(Sender: TObject);
    procedure CopyletterlistClick(Sender: TObject);
    procedure CopylettertableClick(Sender: TObject);
    procedure CopyGreekvoweltableClick(Sender: TObject);
    procedure AddallwordsClick(Sender: TObject);
    procedure ShowdictionaryClick(Sender: TObject);
    procedure AddcurrwordsClick(Sender: TObject);
    procedure DictPopupPopup(Sender: TObject);
    procedure DictBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CopyRemarksClick(Sender: TObject);
    procedure ComboBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure InternalSortClick(Sender: TObject);
    procedure AddPIEparticipleClick(Sender: TObject);
  private
    FWords, FStressDia: array[-MaxHist-1..3] of ByteArray;  {0: source, 1: aux, 2: target, 3: dict}
    FEnding, FMorphBound: array[-MaxHist-1..3] of Word;
    GheGloss: array[-MaxHist-1..0] of string;
    FHistLangs: array[0..1, 1..MaxHist+1] of Integer;
    HistOpts, HistSourceLetter: array[0..MaxHist+1] of Byte;
    Caret: array[0..MaxHist+1, 0..1] of Integer;
    CopyBtns: array[0..1] of TSpeedButton;
    ComboBoxIndices: array[1..7] of Integer;
    Descendants, Loans, LargeWidth, LargeHeight, LargeTargetPanelTop, LargeTargetPanelHeight, DictLang: Integer;
    InputNum: Char;
    CF_RTF: DWord;
    FDictLinkS, FDictLinkT: PDictEntry;
    procedure AppShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
    procedure SourceLangPopupClick(Sender: TObject);
    procedure TargetLangPopupClick(Sender: TObject);
    procedure PopupMeasureItem(Sender: TObject; ACanvas: TCanvas; var Width, Height: Integer);
    procedure LangPopupDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
    procedure HistPopupDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
    function ShowComboBox(Show: Boolean; Id: Integer): Integer;
    function OTroyVFromLast(i, Nr: Integer): Integer;
    function OTroyDiph(i: Integer; Ins: Boolean): Integer;
    procedure PIEStem(Lang: Byte; assimSPH: Boolean = True);
    function GetWords(i, j: Integer): Byte;
    procedure SetWords(i, j: Integer; c: Byte);
    function GetDrawWords(i, j: Integer): SmallInt;
    procedure SetWordsStressDia(i, j: Integer; sd, c: Byte);
    function GetWordsB(i, j: Integer): Byte;
    procedure SetWordsB(i, j: Integer; c: Byte);
    property WordsB[i, j: Integer]: Byte read GetWordsB write SetWordsB;
    function GetWordLen(i: Integer): Integer;
    procedure SetWordLen(i, v: Integer);
    function GetEnding(i: Integer): Word;
    procedure SetEnding(i: Integer; v: Word);
    function GetMorphBound(i: Integer): Word;
    procedure SetMorphBound(i: Integer; v: Word);
    procedure WordCut(i, v: Integer);
    procedure InsAtCaret(c: Byte);
    function GetLangs(i, j: Integer): Integer;
    procedure SetLangs(i, j, l: Integer);
    function GetStress(i, j: Integer; Sort: TStress): TStress;
    function GetDia(i, j: Integer): TDia;
    function SortChar(Lang, i: Integer): Byte;
    procedure SetDictLinkS(p: PDictEntry);
    procedure SetDictLinkT(p: PDictEntry);
    function VarCode: Byte;
  public
    procedure HistPopupClick(Sender: TObject);
    procedure Reduplicate(r: Integer; accent: Boolean);
    procedure Grade(g: Integer; accent: Boolean);
    procedure Add(i: Integer; c: Byte);  overload;
    procedure Add(i: Integer; c, sd: Byte);  overload;
    procedure Delete(i, p: Integer);
    procedure Insert(i, p, c: Integer);
    function GetStressDia(i, j: Integer): Byte;
    procedure SetStress(i, j: Integer; Sort: TStress; Toggle: Boolean);
    procedure SetDia(i, j: Integer; Toggle: Boolean);
    procedure SetCaret(p0, p1: Integer);
    property Langs[i, j: Integer]: Integer read GetLangs write SetLangs; {[0..3, 0]: source/target/dict lang; [0..2, 1..MaxHist]: hist langs}
    property Words[i, j: Integer]: Byte read GetWords write SetWords;
    property WordsStressDia[i, j: Integer; sd: Byte]: Byte write SetWordsStressDia;
    property WordLen[i: Integer]: Integer read GetWordLen write SetWordLen;
    property Ending[i: Integer]: Word read GetEnding write SetEnding;
    property MorphBound[i: Integer]: Word read GetMorphBound write SetMorphBound;
    property DrawWords[i, j: Integer]: SmallInt read GetDrawWords;
    property DictLinkS: PDictEntry read FDictLinkS write SetDictLinkS;
    property DictLinkT: PDictEntry read FDictLinkT write SetDictLinkT;
    procedure UpdateWord(UpDict: Boolean; Gloss: string);
    function DrawWord(i: Integer; ACanvas: TCanvas; ARect: TRect; ASelected, DrawLang: Boolean; Indent: Integer): string;
    procedure DrawUnicode(ACanvas: TCanvas; Rect: TRect; FrontColor, BackColor: TColor; Invert, ConvBrackets: Boolean; S: string);
    function MakeWordHTML(i, Start, Stop: Integer; HTMLTag: string; Id: Boolean): string; overload;
    function MakeWordHTML(i, Start, Stop: Integer; HTMLTag: string; Id: Boolean; out S: string; out Lem: Boolean): string; overload;
  end;

var
  Neogrammarian: TNeogrammarian;

implementation

uses GheWord;

{$R *.DFM} {$R Strings.res}

procedure TNeogrammarian.FormShow(Sender: TObject);
const SourceTarg: array[0..1] of string = ('Source', 'Target');
var i, j: Integer;
    Node: TTreeNode;
    m: TMenuItem;
    dt: TDateTime;
    buf: array[0..4095] of Byte;
    ver: array[0..2] of Byte;
    ct: array[0..1] of string;
    w: DWord;
    P: Pointer;
    h: HWnd;
begin    
  h:=FindWindowEx(0, Handle, 'TNeogrammarian', nil);
  if (h<>Handle) and (GetWindowTextLength(h)>0) then begin
    SetWindowPos(h, HWnd_Top, Left, Top, 0, 0, SWP_NoSize);
    SetForegroundWindow(h);
    Close;
  end else begin
    LargeWidth:=Width;
    LargeHeight:=Height;
    LargeTargetPanelTop:=TargetBackPanel.Top;
    LargeTargetPanelHeight:=TargetBackPanel.Height;
    for i:=0 to 1 do CopyBtns[i]:=TSpeedButton(FindComponent('Copy'+SourceTarg[i]+'Btn'));
    for i:=0 to Length(LangNs)-1 do begin
      Node:=nil;
      for j:=0 to SourceTree.Items.Count-1 do if (SourceTree.Items[j].Level=0) and (Integer(SourceTree.Items[j].Data)=Dates[i]) then Node:=SourceTree.Items[j];
      if Node=nil then Node:=SourceTree.Items.AddObject(nil, IntToYear(Dates[i]), Pointer(Dates[i]));
      SourceTree.Items.AddChildObject(Node, LangNs[i], Pointer(i)).ImageIndex:=i+1;
    end;
    for i:=0 to SourceTree.Items.Count-1 do begin
      m:=TMenuItem.Create(self);
      if SourceTree.Items[i].Level=1 then m.Caption:=LongLangNs[Integer(SourceTree.Items[i].Data)] else m.Caption:='-';
      m.Tag:=Integer(SourceTree.Items[i].Data);
      m.RadioItem:=True;
      m.OnClick:=SourceLangPopupClick;
      m.OnMeasureItem:=PopupMeasureItem;
      m.OnDrawItem:=LangPopupDrawItem;
      SourceLangPopup.Items.Add(m);
    end;
    with SourceTree do for i:=0 to Items.Count-1 do Items[i].SelectedIndex:=Items[i].ImageIndex;
    SourceTree.FullExpand;
    ToggleAccent1.Caption:=ToggleAccent1.Caption+#9#9',';
    ToggleAccent2.Caption:=ToggleAccent2.Caption+#9#9'.';
    ToggleDiaeresis.Caption:=ToggleDiaeresis.Caption+#9#9#9':';
    ToggleHyphen.Caption:=ToggleHyphen.Caption+#9#9#9'-';
    ToggleMorphbound.Caption:=ToggleMorphbound.Caption+#9'/';
    with TRegIniFile.Create(Reg) do begin
      InternalSort.Checked:=ReadBool('', 'InternalSort', False);
      SourceTree.Selected:=SourceTree.Items[1]; {must be after InternalSort.Checked}
      for i:=Max(Min(ReadInteger('History', '', 0), MaxHist), 0) downto 0 do begin
        if i>0 then OpenKey('\'+Reg+'\History\'+FormatFloat('00', i), False) else OpenKey('\'+Reg, False);
        for j:=0 to Length(LangNs)-1 do if LangNs[j]=ReadString('', 'SourceLang', '') then Langs[0,0]:=j;
        for j:=0 to Length(LangNs)-1 do if LangNs[j]=ReadString('', 'TargetLang', '') then Langs[2,0]:=j;
        for j:=0 to ReadBinaryData('SourceWord', buf, 4096)-1 do if buf[j]<=NrChars[True, Langs[0,0]] then Add(0, buf[j]);
        for j:=0 to Min(ReadBinaryData('SourceStress', buf, 4096), WordLen[0])-1 do if buf[j]>=1 then SetStress(0, j, TStress(buf[j]), False);
        Ending[0]:=Word(ReadInteger('', 'SourceEnding', -1));
        MorphBound[0]:=Word(ReadInteger('', 'SourceMorphBd', -1));
        GheGloss[0]:=ReadString('', 'SourceGloss', '');
        CharsBox.ItemIndex:=Max(Min(ReadInteger('', 'SourceLetter', 0), CharsBox.Items.Count-1), 0);
        Caret[0,0]:=Max(Min(ReadInteger('', 'CaretPos', 0), WordLen[0]), 0);
        Caret[0,1]:=Max(Min(ReadInteger('', 'CaretEnd', 0), WordLen[0]), 0);
        if i>0 then begin
          HistOpts[0]:=ReadInteger('', 'ZOptions', 255);
          HistPopupClick(Neogrammarian);
          WordLen[0]:=0;
        end;
      end;
      CheckBox.Checked:=ReadBool('', 'CheckBox', False);
      for i:=1 to High(ComboBoxIndices) do ComboBoxIndices[i]:=Max(Min(ReadInteger('', 'ComboBox'+IntToStr(i), ComboBoxDef[i]), ComboBoxNrs[i]-1), 0);
      SemBtn.Down:=ReadBool('', 'Sememes', False);
      SemBtnClick(SemBtn);
      SmallBtn.Down:=ReadBool('', 'WinSmall', False);
      SmallBtnClick(SmallBtn);
      Left:=ReadInteger('', 'WinLeft', 100);
      Top:=ReadInteger('', 'WinTop', 100);
      if GetFileVersionInfo(PChar(Application.ExeName), 0, GetFileVersionInfoSize(PChar(Application.ExeName), w), @buf) then begin
        VerQueryValue(@buf, '\', P, w);
        ver[0]:=VS_FixedFileInfo(P^).dwFileVersionMS shr 16;
        ver[1]:=VS_FixedFileInfo(P^).dwFileVersionMS and $FF;
        ver[2]:=VS_FixedFileInfo(P^).dwFileVersionLS shr 16;
      end else for i:=0 to 2 do ver[i]:=0;
      VerLabel.Caption:='Version '+IntToStr(ver[0])+'.'+IntToStr(ver[1])+'.'+IntToStr(ver[2]);
      dt:=CompileTime(Application.ExeName);
      for i:=2*Ord(ver[2]<>0)+Ord((ver[1]<>0) and (ver[2]=0)) to 2 do WriteDate('CompileTime'+IntToStr(i), dt);
      for i:=0 to 1 do try ct[i]:=DateToStr(ReadDate('CompileTime'+IntToStr(i))) except ct[i]:='??.??.????' end;
      VerLabel.Hint:='Compiled'#13#10'V '+IntToStr(ver[0])+'.'+IntToStr(ver[1])+'.'+IntToStr(ver[2])+':  '+DateTimeToStr(dt)
        +Copy(#13#10'V '+IntToStr(ver[0])+'.'+IntToStr(ver[1])+'.0:  '+ct[1], 1, 1000*Ord((ver[1]<>0) and (ver[2]<>0)))
        +Copy(#13#10'V '+IntToStr(ver[0])+'.0.0:  '+ct[0], 1, 1000*Ord((ver[1]<>0) or (ver[2]<>0)))
      //+#13#10'V 6.0.0:  23.03.2020'
        +#13#10'V 5.0.0:  21.11.2011'
        +#13#10'V 4.0.0:  October 2007'
        +#13#10'V 1.0.0:  2006';
      CopyrightLabel.Caption:='2006-'+FormatDateTime('yy', dt)+' by';
      if ReadBool('Dict', 'WinShow', False) then DictForm.Show;
      Free;
    end;
    CF_RTF:=RegisterClipboardFormat('Rich Text Format');
    Application.OnShowHint:=AppShowHint;
    Application.HintHidePause:=-1;
    Application.OnActivate:=AppActivate;
    Application.OnDeactivate:=AppDeactivate;
    UpdateWord(False, '');
  end;
end; {FormShow}

procedure TNeogrammarian.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if DictForm.Changed then case DictForm.AskDictSave of
    idYes: if not DictForm.SaveDict(True) then Action:=caNone;
    idCancel: Action:=caNone;
  end else if DictForm.ValidFileHandle then if not DictForm.SaveDict(True) then Action:=caNone;
  Showdictionary.Tag:=Ord(DictForm.Visible);
end; {FormClose}

procedure TNeogrammarian.FormDestroy(Sender: TObject);
var i, j: Integer;
    w: array[0..4095] of Byte;
begin
  if SourceTree.Items.Count>0 then with TRegIniFile.Create(Reg) do begin
    WriteBool('', 'InternalSort', InternalSort.Checked);
    WriteBool('', 'CheckBox', CheckBox.Checked);
    for i:=1 to High(ComboBoxIndices) do WriteInteger('', 'ComboBox'+IntToStr(i), ComboBoxIndices[i]);
    WriteInteger('', 'ComboBox', ComboBox.ItemIndex);
    WriteInteger('', 'WinLeft', Left);
    WriteInteger('', 'WinTop', Top);
    WriteBool('', 'WinSmall', not HidePanel1.Visible);
    WriteBool('', 'Sememes', SemBtn.Down);
    WriteInteger('Dict', 'WinShow', Showdictionary.Tag);
    EraseSection('History');
    WriteInteger('History', '', HistPopup.Items.Count);
    for i:=0 to HistPopup.Items.Count do begin
      WriteString('', 'SourceLang', LangNs[Langs[0,i]]);
      WriteString('', 'TargetLang', LangNs[Langs[2,i]]);
      for j:=0 to WordLen[-i]-1 do w[j]:=Words[-i,j];
      WriteBinaryData('SourceWord', w, WordLen[-i]);
      for j:=0 to WordLen[-i]-1 do w[j]:=Ord(GetStressDia(-i, j));
      WriteBinaryData('SourceStress', w, WordLen[-i]);
      WriteInteger('', 'SourceEnding', SmallInt(Ending[-i]));
      WriteInteger('', 'SourceMorphBd', SmallInt(MorphBound[-i]));
      if GheGloss[-i]<>'' then WriteString('', 'SourceGloss', GheGloss[-i]) else DeleteKey('', 'SourceGloss');
      if (i>0) and (HistOpts[i]<255) then WriteInteger('', 'ZOptions', HistOpts[i]);
      if i=0 then WriteInteger('', 'SourceLetter', CharsBox.ItemIndex) else WriteInteger('', 'SourceLetter', HistSourceLetter[i]);
      WriteInteger('', 'CaretPos', Caret[i,0]);
      WriteInteger('', 'CaretEnd', Caret[i,1]);
      if i<HistPopup.Items.Count then OpenKey('\'+Reg+'\History\'+FormatFloat('00', i+1), True);
    end;
    Free;
  end;
  DestroyCaret;   
end; {FormDestroy}

procedure TNeogrammarian.AppShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
var n, m: Integer;
    c: Char;
begin
  with HintInfo do if HintControl.Owner=DictForm then DictForm.AppHint(HintStr, HintInfo) else if HintControl=CharsBox then begin
    m:=CharsBox.ItemAtPos(CursorPos, True);
    CursorRect:=CharsBox.ItemRect(m);
    n:=SortChar(Langs[0,0], m);
    if n<255 then begin
      HintStr:='[no shortcut]';
      for c:='Z' downto 'A' do if Map2[Langs[0,0], c]=n then HintStr:='Shift+'+c;
      for c:='z' downto 'a' do if Map1[Langs[0,0], c]=n then HintStr:=UpperCase(c);
      HintStr:=HintStr+'   '+IfThen(n>=10, '#')+IntToStr(n);
    end else HintStr:='Navigate with Ctrl + cursor keys';
  end;
end; {AppShowHint}

procedure TNeogrammarian.AppActivate(Sender: TObject);
begin
  if Active then begin
    ActiveControl:=CharsBox;
    CreateCaret(SourcePanel.Handle, 0, 2, 16);
    SourceImage.Invalidate;
    ShowCaret(SourcePanel.Handle);
  end;
end; {AppActivate}

procedure TNeogrammarian.AppDeactivate(Sender: TObject);
begin
  DestroyCaret;
end; {AppDeactivate}

procedure TNeogrammarian.PopupMeasureItem(Sender: TObject; ACanvas: TCanvas; var Width, Height: Integer);
begin
  Height:=Canvas.TextHeight('A')+3;
  Width:=(SourcePanel.Width-20) div (1+Ord(TMenuItem(Sender).Parent=SourceLangPopup.Items));
end; {PopupMeasureItem}

{----------------------------------------------------------Source language--------------------------------------------------------------}

procedure TNeogrammarian.SourceTreeChanging(Sender: TObject; Node: TTreeNode; var AllowChange: Boolean);
begin
  with SourceTree do AllowChange:=Node.Level>0;
  if AllowChange and (DictForm.CheckListBox.Tag=0) then HistPopupClick(nil);
end; {SourceTreeChanging}

procedure TNeogrammarian.SourceTreeChange(Sender: TObject; Node: TTreeNode);
var i: Integer;
    m: TMenuItem;
begin
  CharsBox.Items.Clear;
  for i:=0 to NrChars[InternalSort.Checked, Langs[0,0]]-1 do CharsBox.Items.Add('');
  if CharsBox.Items.Count>0 then CharsBox.ItemIndex:=0;
  DictLinkS:=nil;
  DictLinkT:=nil;
  WordLen[0]:=0;
  Ending[0]:=Word(-1);
  MorphBound[0]:=Word(-1);
  GheGloss[0]:='';
  TargetBox.Items.Clear;
  for i:=0 to Length(LangNs)-1 do if i in Desc[Langs[0,0]] then TargetBox.Items.AddObject(LongLangNs[i]+' (descendant, '+IntToYear(Dates[i])+')', Pointer(i));
  Descendants:=TargetBox.Items.Count;
  for i:=0 to Length(LangNs)-1 do if (Dates[i]=Dates[Langs[0,0]]) and (i<>Langs[0,0]) then
    TargetBox.Items.AddObject(LongLangNs[i]+' (loans, '+IntToYear(Dates[i])+')', Pointer(i));
  Loans:=TargetBox.Items.Count;
  for i:=0 to Length(LangNs)-1 do if i in LLoans[Langs[0,0]] then TargetBox.Items.AddObject(LongLangNs[i]+' (academic loans, '+IntToYear(Dates[i])+')', Pointer(i));
  for i:=0 to TargetLangPopup.Items.Count-1 do TargetLangPopup.Items.Delete(0);
  for i:=0 to TargetBox.Items.Count-1 do begin
    m:=TMenuItem.Create(self);
    m.Caption:=TargetBox.Items[i];
    m.RadioItem:=True;
    m.Tag:=Integer(TargetBox.Items.Objects[i]);
    m.OnClick:=TargetLangPopupClick;
    m.OnMeasureItem:=PopupMeasureItem;
    m.OnDrawItem:=LangPopupDrawItem;
    TargetLangPopup.Items.Add(m);
  end;
  SourceLabel.Caption:='Source word ('+LongLangNs[Langs[0,0]]+')';
  TargetBox.ItemIndex:=0;
  if TargetBox.Visible then TargetBoxClick(nil);
  for i:=0 to 1 do Caret[0,i]:=0;
  DownBtn.Enabled:=not (Langs[0,0] in [lPIE, lGhe]);
  DownBtn.Visible:=not (Langs[0,0]=lGhe);
  DownBtn.Hint:='Make '+LongLangNs[Langs[0,0]]+' the target language (Cursor down)';
  UpBtn.Enabled:=not ((Langs[0,0]=lNLem) and (Langs[2,0]=lModLem));
  GheWordBtn.Visible:=Langs[0,0]=lGhe;
  for i:=0 to SourceLangPopup.Items.Count-1 do if SourceLangPopup.Items[i].Tag=Integer(SourceTree.Selected.Data) then SourceLangPopup.Items[i].Checked:=True;
end; {SourceTreeChange}

procedure TNeogrammarian.SourceTreeClick(Sender: TObject);
begin
  ActiveControl:=CharsBox;
  SourceImage.Invalidate;
end; {SourceTreeClick}

procedure TNeogrammarian.SourceBtnClick(Sender: TObject);
var p: TPoint;
begin
  p:=SourceBackPanel.ClientToScreen(Point(SourceBtn.Left, SourceBtn.Top+SourceBtn.Height));
  SourceLangPopup.Popup(p.X, p.Y);
end; {SourceBtnClick}

procedure TNeogrammarian.SourceLangPopupClick(Sender: TObject);
var i: Integer;
begin
  with SourceTree do for i:=0 to Items.Count-1 do if Integer(Items[i].Data)=TMenuItem(Sender).Tag then Selected:=Items[i];
end; {SourceLangPopupClick}

procedure TNeogrammarian.LangPopupDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
var p: Integer;
begin
  with ACanvas, TMenuItem(Sender) do begin
    Font.Assign(Neogrammarian.Font);
    if Selected then begin
      Font.Color:=clHighlightText;
      Brush.Color:=RGBs[Tag];
    end else begin
      if Caption='-' then Font.Color:=clGray else Font.Color:=RGBs[Tag];
      Brush.Color:=clMenu;
      Pen.Color:=clGray;                                                         
    end;
    FillRect(Rect(ARect.Left+16, ARect.Top, ARect.Right, ARect.Bottom));
    MoveTo(0, ARect.Bottom-1);
    if (Parent=TargetLangPopup.Items) and (MenuIndex+1 in [Descendants, Loans]) and (MenuIndex+1<TargetLangPopup.Items.Count) then LineTo(ARect.Right, ARect.Bottom-1);
    if Checked then ColourList.Draw(ACanvas, ARect.Left+2, ARect.Top+2, Tag+1);
    if Caption='-' then begin
      TextOut(ARect.Left+2, ARect.Top+1, SourceTree.Items[MenuIndex].Text+':');
      MoveTo(ARect.Left, ARect.Top);
      if MenuIndex>0 then LineTo(ARect.Right, ARect.Top);
    end else begin
      p:=Pos('(', Caption);
      if p=0 then p:=1000;
      if (p<1000) and (Caption[p+1]<>'d') then Font.Style:=[fsItalic];
      TextOut(ARect.Left+18, ARect.Top+1, Copy(Caption, 1, p-1));
      TextOut(ARect.Right div 2, ARect.Top+1, Copy(Caption, p, 1000));
    end;
  end;
end; {LangPopupDrawItem}

{----------------------------------------------------------Target language--------------------------------------------------------------}

procedure TNeogrammarian.TargetBoxClick(Sender: TObject);
var entry: PDictEntry;
begin
  entry:=DictLinkS;
  TargetLabel.Caption:='Target word ('+LongLangNs[Langs[2,0]]+')';
  CheckBox.Visible:=False;
  CheckBox.Checked:=False;
  ComboBox.Visible:=False;
  Caption:=LangNs[Langs[0,0]]+'>'+LangNs[Langs[2,0]]+' - Neogrammarian';
  TargetLangPopup.Items[TargetBox.ItemIndex].Checked:=True;
  AccentWarn.Visible:=(Langs[0,0]=lPIE)    and (Langs[2,0] in [lEHell, lPrWald, lPrCelt])
                   or (Langs[0,0]=lEHell)  and (Langs[2,0]=lKoi)
                   or (Langs[0,0]=lKoi)    and (Langs[2,0]=lLMLem)
                   or (Langs[0,0]=lPrWald) and (Langs[2,0]=lElb)
                   or (Langs[0,0]=lLMLem)  and (Langs[2,0]=lNLem);
  DictLinkS:=entry;
  DictLinkT:=nil;
  UpdateWord(False, '¤');
  if Addallwords.Checked then AddcurrwordsClick(nil);
end; {TargetBoxClick}

procedure TNeogrammarian.TargetBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var p: Integer;
begin
  with TargetBox do begin
    p:=Pos('(', Items[Index]);
    if odSelected in State then Canvas.Brush.Color:=RGBs[Integer(Items.Objects[Index])];
    Canvas.FillRect(Rect);
    if Items[Index][p+1]='d' then Canvas.Font.Style:=[] else Canvas.Font.Style:=[fsItalic];
    Canvas.TextOut(Rect.Left+18, Rect.Top, Copy(Items[Index], 1, p-1));
    Canvas.TextOut(Rect.Left+Width div 2, Rect.Top, Copy(Items[Index], p, 1000));
    Canvas.Brush.Color:=clWindow;
    Canvas.FillRect(Classes.Rect(Rect.Left, Rect.Top, Rect.Left+16, Rect.Bottom));
    ColourList.Draw(Canvas, Rect.Left+2, Rect.Top+2, Integer(Items.Objects[Index])+1);
  end;
end; {TargetBoxDrawItem}

procedure TNeogrammarian.TargetBtnClick(Sender: TObject);
var p: TPoint;
begin
  p:=TargetBackPanel.ClientToScreen(Point(TargetBtn.Left, TargetBtn.Top+TargetBtn.Height));
  TargetLangPopup.Popup(p.X, p.Y);
end; {TargetBtnClick}

procedure TNeogrammarian.TargetLangPopupClick(Sender: TObject);
begin
  TargetBox.ItemIndex:=TMenuItem(Sender).MenuIndex;
  TargetBoxClick(nil);
end; {TargetLangPopupClick}

{----------------------------------------------------------Source word--------------------------------------------------------------}

procedure TNeogrammarian.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var i: Integer;
    c: Char;
begin
  if (ActiveControl=CharsBox) and ((Shift=[]) or (Shift=[ssShift]) or (Shift=[ssShift, ssCtrl])) then begin
    c:=#8;
    case Key of
      VK_Left:   if ssCtrl in Shift then Caret[0,0]:=0          else Caret[0,0]:=Max(Caret[0,0]-1, 0);
      VK_Right:  if ssCtrl in Shift then Caret[0,0]:=WordLen[0] else Caret[0,0]:=Min(Caret[0,0]+1, WordLen[0]);
      VK_Home:   Caret[0,0]:=0;
      VK_End:    Caret[0,0]:=WordLen[0];
      VK_Up:     if (Shift=[]) and UpBtn.Enabled then UpBtnClick(nil);
      VK_Down:   if (Shift=[]) and DownBtn.Enabled then DownBtnClick(nil);
      VK_Delete: if Shift=[] then if Caret[0,0]<>Caret[0,1] then FormKeyPress(Sender, c) else if Caret[0,0]<WordLen[0] then begin
        Delete(0, Caret[0,0]);
        UpdateWord(True, '');
      end;
    end;
    if Key in [VK_Left, VK_Right, VK_Home, VK_End, VK_Up, VK_Down] then begin
      if Shift=[] then Caret[0,1]:=Caret[0,0];
      SourceImage.Invalidate;
      Key:=0;
    end;
  end;
  if ComboBox.Visible and (Shift=[ssAlt]) then with ComboBox do for i:=ItemIndex+1 to 2*Items.Count-2 do if (Items[i mod Items.Count]<>'')
      and (Ord(Items[i mod Items.Count][1])=Key) then begin
    ComboBox.ItemIndex:=i mod Items.Count;
    UpdateWord(False, '¤');
    Break;
  end;
  case Key of
    VK_F2: if Shift=[] then SmallBtnClick(nil);
    VK_F3: if Shift=[] then GheWordBtnClick(GheWordBtn);
    VK_F4: if Shift=[] then SemBtnClick(nil);
    VK_F7: if Shift-[ssShift]=[] then if CheckBox.Visible then CheckBox.Checked:=not CheckBox.Checked else if ComboBox.Visible then begin
      if Shift=[] then ComboBox.ItemIndex:=(ComboBox.ItemIndex+1) mod ComboBox.Items.Count
        else ComboBox.ItemIndex:=(ComboBox.ItemIndex+ComboBox.Items.Count-1) mod ComboBox.Items.Count;
      UpdateWord(True, '¤');
    end;
    65{A}: if Shift=[ssCtrl] then begin
      Caret[0,0]:=WordLen[0];  Caret[0,1]:=0;
      SourceImage.Invalidate;
    end;
    67{C}: if ssCtrl in Shift then CopyBtnClick(CopyBtns[Ord(ssShift in Shift)]);
    68{D}: if Shift=[ssCtrl] then AddallwordsClick(nil) else if Shift=[ssShift, ssCtrl] then ShowdictionaryClick(nil);
  //  73{I}: if ssCtrl in Shift then ChangesBtnClick(ChangesBtn);
  end;
end; {FormKeyDown}

procedure TNeogrammarian.FormKeyPress(Sender: TObject; var Key: Char);
var i: Integer;
begin
  if ActiveControl=CharsBox then begin
    case Key of
      'a'..'z': InsAtCaret(Map1[Langs[0,0], Key]);
      'A'..'Z': InsAtCaret(Map2[Langs[0,0], Key]);
      '0'..'9': if InputNum=#0 then InsAtCaret(StrToInt(Key)) else if InputNum=#1 then InputNum:=Key else InsAtCaret(Max(Min(StrToInt(InputNum+Key), NrChars[True, Langs[0,0]]-1), 0));
      '#': if InputNum=#1 then InputNum:=#0 else InputNum:=#1;
      ',', '.': SetStress(0, Caret[0,0]-1, TStress(Ord(Key='.')+2), True);
      ':': SetDia(0, Caret[0,0]-1, True);
      '-': if Langs[0,0] in HyphenAllowed then if Langs[0,0] in HyphenEndOnly then begin
        if Ending[0]=WordLen[0] then Ending[0]:=Word(-1) else Ending[0]:=WordLen[0];
      end else begin
        if Ending[0]=Caret[0,0] then Ending[0]:=Word(-1) else Ending[0]:=Caret[0,0];
      end;
      '/': if (FDictLinkS<>nil) then if MorphBound[0]=Caret[0,0] then MorphBound[0]:=Word(-1) else MorphBound[0]:=Caret[0,0];
      '+': AddcurrwordsClick(nil);
      ' ': InsAtCaret(SortChar(Langs[0,0], CharsBox.ItemIndex));
      #8: if Caret[0,0]<>Caret[0,1] then begin
        HistPopupClick(nil);
        for i:=Max(Caret[0,0], Caret[0,1])-1 downto Min(Caret[0,0], Caret[0,1]) do Delete(0, i);
        Caret[0,0]:=Min(Caret[0,0], Caret[0,1]);
        Caret[0,1]:=Caret[0,0];
      end else if Caret[0,0]=Ending[0] then Ending[0]:=Word(-1) else if Caret[0,0]>0 then begin
        for i:=0 to 1 do Dec(Caret[0,i]);
        Delete(0, Caret[0,0]);
      end;
      #13: HistPopupClick(nil);
      #26{Ctrl+Z}: if HistPopup.Items.Count>0 then HistPopup.Items[0].Click;
      #27: if (DictLinkS<>nil) then begin
         DictLinkS:=nil;
         DictLinkT:=nil;
         if Addallwords.Checked then AddallwordsClick(nil);
      end else if (WordLen[0]=0) and (Ending[0]=Word(-1)) and (MorphBound[0]=Word(-1)) then begin
        if (Langs[0,0]=lPIE) and (Langs[2,0]=lPrLem) then begin
          Langs[0,0]:=lGhe;  Langs[2,0]:=lMLem;
        end else begin
          Langs[0,0]:=lPIE;  Langs[2,0]:=lPrLem;
        end;
      end else if Caret[0,0]<>Caret[0,1] then Caret[0,1]:=Caret[0,0] else begin
        HistPopupClick(nil);
        WordLen[0]:=0;
        Ending[0]:=Word(-1);
        MorphBound[0]:=Word(-1);
        CheckBox.Checked:=False;
      end;
    end;
    if not (Key in ['0'..'9', '#']) then InputNum:=#0;
    if Key in ['a'..'z', 'A'..'Z', '0'..'9', ',', '.', ':', '-', '/', ' ', #8, #10{Ctrl+Enter}, #27] then UpdateWord(not (Key in [#10, #27]), '');
  end;
end; {FormKeyPress}

procedure TNeogrammarian.SourceImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i, j, w, cp: Integer;
begin
  ActiveControl:=CharsBox;
  cp:=1; w:=0;
  for i:=-1 to WordLen[0] do begin
    w:=CharWidth(DrawWords[0,i], i+1=Ending[0], i+1=MorphBound[0]);
    if SourcePanel.ScreenToClient(Mouse.CursorPos).X<cp+w div 2 then Break else Inc(cp, w);
  end;
  if i=-1 then Inc(cp, w);
  for j:=0 to 1 do Caret[0,j]:=Min(Max(i, 0), WordLen[0]);
  SetCaretPos(cp, 1);
  SourceImage.Invalidate;
end; {SourceImageMouseDown}

procedure TNeogrammarian.SourceImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var i, w, cp: Integer;
begin
  if Shift=[ssLeft] then begin
    cp:=1;
    for i:=-1 to WordLen[0] do begin
      w:=CharWidth(DrawWords[0,i], i+1=Ending[0], i+1=MorphBound[0]);
      if SourcePanel.ScreenToClient(Mouse.CursorPos).X<cp+w div 2 then Break else Inc(cp, w);    
    end;
    Caret[0,0]:=Min(Max(i, 0), WordLen[0]);
    SourceImage.Invalidate;
  end;
end; {SourceImageMouseMove}

function TNeogrammarian.DrawWord(i: Integer; ACanvas: TCanvas; ARect: TRect; ASelected, DrawLang: Boolean; Indent: Integer): string;
const lem: array[115..151] of string = ('a', 'à', 'e', 'è', 'y', 'y`', 'i', 'ì', 'o', 'ò', 'ö', 'ö`', 'u', 'ù', 'ü', 'ü`',
        'gh', 'zh', 'z', 'dh', 'w', 'x', 'sh', 's', 'th', 'f', 'g', 'd', 'b', 'k', 't', 'p', 'ng', 'm', 'r', 'rh', 'l');
      grc: array[61..112] of string = ('a', 'á', 'a:', 'â', 'ã', 'b', 'g', 'd', 'e', 'é', 'e:', 'ê', 'e~', 'w', 'z', 'th', 'i', 'í', 'i:', 'î', 'i~', 'k',
        'l', 'l°', 'm', 'n', 'x', 'o', 'ó', 'o:', 'ô', 'õ', 'p', 'q', 'r', 'r°', 'rh', 's', 't', 'u', 'ú', 'u:', 'û', 'u~', 'ph', 'kh', 'ps', 'hw', 's', 'h', '', 'h');
var k, w, dw: Integer;
    bmp: TBitmap;                                             
begin
  Result:='';
  bmp:=TBitmap.Create;
  with ACanvas.Brush do if ASelected then Color:=RGBsB[Langs[i,0]] else if i=3 then Color:=clWindow else Color:=cl3DLight;
  ACanvas.FillRect(ARect);
  ACanvas.CopyMode:=cmMergeCopy;
  with ACanvas do w:=ARect.Left+2+TextWidth('m')*Indent;
  if DrawLang then with ACanvas do begin
    Font.Color:=RGBs[Langs[i,0]];
    Font.Style:=[fsItalic];
    TextOut(w, ARect.Top+2, LangNs[Langs[i,0]]);
    Inc(w, TextWidth('ModLem '));
  end;
  with ACanvas do for k:=-1 to WordLen[i] do begin
    dw:=DrawWords[i,k];
    if dw>-1 then begin
      CharList.GetBitmap(dw, bmp);
      if (i=0) and ((k<Caret[0,0]) xor (k<Caret[0,1])) then CopyMode:=cmNotSrcCopy else CopyMode:=cmMergeCopy;
      Draw(w, ARect.Top+1, bmp);
      if GetDia(i, k)=diaYes then begin
        CharList.GetBitmap(chDiaeresis, bmp);
        CopyMode:=cmSrcAnd;
        Draw(w+(CharWidth(dw)-CharWidth(chDiaeresis)) div 2, ARect.Top+1, bmp);
      end;
    end else FillRect(Rect(w, ARect.Top, w+16, ARect.Bottom));
    Inc(w, CharWidth(dw, k+1=Ending[i], k+1=MorphBound[i]));
    if k+1=MorphBound[i] then begin
      CharList.GetBitmap(chMorphBound, bmp);
      Draw(w-CharWidth(chMorphBound)-Ord(k+1=Ending[i])*CharWidth(chEnding), ARect.Top+1, bmp);
    end;
    if k+1=Ending[i] then begin
      CharList.GetBitmap(chEnding, bmp);
      Draw(w-CharWidth(chEnding), ARect.Top+1, bmp);
    end;
    if (i=0) and (k=Caret[0,0]-1) then SetCaretPos(w-1, 1);
    if Langs[i,0] in [lMLem..lModLem, lKoi, lOTroy, lNTroy] then Result:=Result+IfThen(k=Ending[i], '-')+IfThen(k=MorphBound[i], '/');
    if Langs[i,0] in [lMLem..lModLem] then begin
      if dw in [Low(lem)..High(lem)] then Result:=Result+lem[dw] else if dw=chFullstop then Result:=Result+'.';
    end else if Langs[i,0] in [lKoi, lOTroy, lNTroy] then begin
      if (dw=67{gamma}) and (DrawWords[i,k+1] in [67, 82, 87, 106]) then dw:=86{ny};
      if dw in [Low(grc)..High(grc)] then Result:=Result+IfThen((GetDia(i, k)=diaYes) and (Ending[i]<>k), '·')+grc[dw];     
      if (dw=109{sh}) and (Langs[i,0]=lNTroy) then Result:=Result+'h';
    end;
  end;
  bmp.Free;
end; {DrawWord}

procedure TNeogrammarian.ImagePaint(Sender: TObject);
begin
  with TPaintBox(Sender) do Hint:=DrawWord(Tag, Canvas, Rect(0, 0, Width, Height), True, False, 0);
end; {ImagePaint}

procedure TNeogrammarian.SourcePopupPopup(Sender: TObject);
const Imgs: array[0..High(LangNs)] of SmallInt = (0, 0, 0, 0, 3, 0, 3, 0, 0, 0, 2, 0, 2, 0, 1, 0, 0, 0, 0);
var i, j: Integer;
begin
  ActiveControl:=CharsBox;
  if SourcePopup.PopupComponent<>SourceImage then
    if SourcePopup.PopupComponent=CharsBox then CharsBox.ItemIndex:=CharsBox.ItemAtPos(CharsBox.ScreenToClient(Mouse.CursorPos), False);
  InsertLetter.Bitmap:=nil;
  CharList.GetBitmap(CharIds[Langs[0,0], SortChar(Langs[0,0], CharsBox.ItemIndex)], InsertLetter.Bitmap);
  for i:=0 to 1 do with TMenuItem(FindComponent('ToggleAccent'+IntToStr(i+1))) do begin
    Enabled:=False;
    for j:=0 to WordLen[0]-1 do if GetStress(0, j, TStress(i+2))>stCant then Enabled:=True;
    if Enabled then ImageIndex:=2*Imgs[Langs[0,0]]+i else ImageIndex:=-1;
  end;
  ToggleDiaeresis.Enabled:=False;
  for j:=0 to WordLen[0]-1 do if GetDia(0, j)>diaCant then ToggleDiaeresis.Enabled:=True;
  if ToggleDiaeresis.Enabled then ToggleDiaeresis.ImageIndex:=12+Ord(Langs[0,0] in [lKoi..lNTroy]) else ToggleDiaeresis.ImageIndex:=-1;
  ToggleHyphen.Enabled:=Langs[0,0] in HyphenAllowed;
  ToggleHyphen.ImageIndex:=12*Ord(ToggleHyphen.Enabled)-1;
  ToggleMorphbound.Visible:=FDictLinkS<>nil;
  if DictLinkS<>nil then EscapeWord.Caption:='Stop editing dictionary word' else if WordLen[0]>0 then EscapeWord.Caption:='Clear source word'
    else if (Langs[0,0]=lPIE) and (Langs[2,0]=lPrLem) then EscapeWord.Caption:='Ghe > MLem' else EscapeWord.Caption:='PIE > PrLem';
  EscapeWord.ImageIndex:=7+3*Ord(WordLen[0]=0);
  AddToHistory.Enabled:=WordLen[0]>0;
  Undo.Enabled:=HistPopup.Items.Count>0;
  InternalSort.Visible:=SourcePopup.PopupComponent=CharsBox;
  N5.Visible:=InternalSort.Visible;
  SourcePopup.PopupComponent:=nil;
end; {SourcePopupPopup}

procedure TNeogrammarian.SourcePopupClick(Sender: TObject);
var ch: Char;
begin
  ch:=Char(TMenuItem(Sender).Tag);
  FormKeyPress(nil, ch);
end; {SourcePopupClick}

procedure TNeogrammarian.InternalSortClick(Sender: TObject);
var i: Integer;
begin
  InternalSort.Checked:=not InternalSort.Checked;
  CharsBox.Items.Clear;
  for i:=0 to NrChars[InternalSort.Checked, Langs[0,0]]-1 do CharsBox.Items.Add('');
  if CharsBox.Items.Count>0 then CharsBox.ItemIndex:=0;
end; {InternalSortClick}

procedure TNeogrammarian.HistBtnClick(Sender: TObject);
var p: TPoint;
begin
  p:=SourcePanel.ClientToScreen(Point(0, HistBtn.Height));
  HistPopup.Popup(p.X, p.Y);
  ActiveControl:=CharsBox;
end; {HistBtnClick}

procedure TNeogrammarian.HistPopupClick(Sender: TObject);
procedure DelHistItem(Nr: Integer);
  var i, j: Integer;
  begin
    for i:=Nr+1 to HistPopup.Items.Count do begin
      for j:=0 to 1 do Langs[2*j,i-1]:=Langs[2*j,i];
      WordLen[-i+1]:=WordLen[-i];
      for j:=0 to WordLen[-i]-1 do WordsStressDia[-i+1, j, GetStressDia(-i, j)]:=Words[-i,j];
      Ending[-i+1]:=Ending[-i];
      MorphBound[-i+1]:=MorphBound[-i];
      GheGloss[-i+1]:=GheGloss[-i];
      HistOpts[i-1]:=HistOpts[i];
      HistSourceLetter[i-1]:=HistSourceLetter[i];
      for j:=0 to 1 do Caret[i-1,j]:=Caret[i,j];
    end;
    HistPopup.Items.Delete(Nr-1);
    HistBtn.Enabled:=HistPopup.Items.Count>0;
  end; {DelHistItem}
var i, j, d, n: Integer;
    m: TMenuItem;
begin
  m:=nil;
  if WordLen[0]>0 then begin
    HistBtn.Enabled:=True;
    for i:=MaxHist downto 0 do begin
      for j:=0 to 1 do Langs[2*j,i+1]:=Langs[2*j,i];
      WordLen[-i-1]:=WordLen[-i];
      for j:=0 to WordLen[-i]-1 do WordsStressDia[-i-1, j, GetStressDia(-i, j)]:=Words[-i,j];
      Ending[-i-1]:=Ending[-i];
      MorphBound[-i-1]:=MorphBound[-i];
      GheGloss[-i-1]:=GheGloss[-i];
      if (i>0) or (Sender=Neogrammarian) then HistOpts[i+1]:=HistOpts[i] else if CheckBox.Visible then HistOpts[i+1]:=Ord(CheckBox.Checked) else
        if ComboBox.Visible then HistOpts[i+1]:=ComboBox.ItemIndex else HistOpts[i+1]:=255;
      if i>0 then HistSourceLetter[i+1]:=HistSourceLetter[i] else HistSourceLetter[i+1]:=CharsBox.ItemIndex;
      for j:=0 to 1 do Caret[i+1,j]:=Caret[i,j];
    end;
    m:=TMenuItem.Create(self);
    m.OnClick:=HistPopupClick;
    m.OnMeasureItem:=PopupMeasureItem;
    m.OnDrawItem:=HistPopupDrawItem;
    HistPopup.Items.Insert(0, m);
  end;
  if (Sender<>nil) and (Sender<>Neogrammarian) then begin
    n:=TMenuItem(Sender).MenuIndex+1;
    WordLen[0]:=0;
    for i:=0 to 1 do Langs[2*i,0]:=Langs[2*i,n];
    WordLen[0]:=WordLen[-n];
    for i:=0 to WordLen[0]-1 do WordsStressDia[0, i, GetStressDia(-n, i)]:=Words[-n, i];
    Ending[0]:=Ending[-n];
    MorphBound[0]:=MorphBound[-n];
    GheGloss[0]:=GheGloss[-n];
    CharsBox.ItemIndex:=HistSourceLetter[n];
    for j:=0 to 1 do Caret[0,j]:=Caret[n,j];
    if CheckBox.Visible then CheckBox.Checked:=HistOpts[n]=1 else if ComboBox.Visible then ComboBox.ItemIndex:=HistOpts[n];
    UpdateWord(False, '¤');
    DelHistItem(n);
  end;
  d:=0;
  for i:=2 to HistPopup.Items.Count do begin
    if (Langs[0,i]=Langs[0,1]) and (Langs[2,i]=Langs[2,1]) and (WordLen[-i]=WordLen[-1]) and (Ending[-i]=Ending[-1]) and (MorphBound[-i]=MorphBound[-1]) then d:=i;
    if d>0 then for j:=0 to WordLen[-i]-1 do if (Words[-i,j]<>Words[-1,j]) or (GetStressDia(-i, j)<>GetStressDia(-1, j)) then d:=0;  
    if d>0 then Break;
  end;
  if d>0 then DelHistItem(d);
  if (HistPopup.Items.Count>MaxHist) and (m<>nil) then HistPopup.Items.Delete(MaxHist);
end; {HistPopupClick}

procedure TNeogrammarian.HistPopupDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
begin
  ACanvas.Font.Assign(Font);
  DrawWord(-1-TMenuItem(Sender).MenuIndex, ACanvas, ARect, Selected, True, 0);
  ACanvas.FillRect(Rect(ARect.Right-ACanvas.TextWidth('> ModLem'), ARect.Top, ARect.Right, ARect.Bottom));
  ACanvas.Font.Color:=RGBs[Langs[2, TMenuItem(Sender).MenuIndex+1]];
  ACanvas.TextOut(ARect.Right-ACanvas.TextWidth('> ModLem'), ARect.Top+2, '> '+LangNs[Langs[2, TMenuItem(Sender).MenuIndex+1]]);
  ACanvas.Font.Color:=clBlack;
  ACanvas.Font.Style:=[];
  if GheGloss[-1-TMenuItem(Sender).MenuIndex]<>'' then ACanvas.TextOut(ARect.Right div 2, ARect.Top+2, '‘'+GheGloss[-1-TMenuItem(Sender).MenuIndex]+'’');
  ACanvas.Brush.Style:=bsClear;
  ACanvas.Pen.Color:=clGrayText;
  if Selected then with ARect do ACanvas.Rectangle(Left, Top, Right, Bottom);
end; {HistPopupDrawItem}

procedure TNeogrammarian.CharsBoxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var p: Integer;
begin
  p:=CharsBox.ItemAtPos(CharsBox.ScreenToClient(Mouse.CursorPos), True);
  if (Button=mbLeft) and (p>-1) then begin
    InsAtCaret(SortChar(Langs[0,0], CharsBox.ItemIndex));
    UpdateWord(True, '');
  end;
end; {CharsBoxMouseDown}

procedure TNeogrammarian.CharsBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  CharsBox.Canvas.Brush.Color:=clWindow;
  CharsBox.Canvas.FillRect(Rect);
  CharList.Draw(CharsBox.Canvas, Rect.Left+12, Rect.Top, CharIds[Langs[0,0], SortChar(Langs[0,0], Index)]);
end; {CharsBoxDrawItem}

{----------------------------------------------------------Buttons & remarks--------------------------------------------------------------}

procedure TNeogrammarian.DownBtnClick(Sender: TObject);
var l, i: Integer;
begin
  l:=Langs[0,0];
  for i:=0 to Length(LangNs)-1 do if Langs[0,0] in Desc[i] then Langs[0,0]:=i;
  Langs[2,0]:=l;
end; {DownBtnClick}

procedure TNeogrammarian.UpBtnClick(Sender: TObject);
var i, e: Integer;
    w, sd: ByteArray;
    entry: PDictEntry;
begin
  entry:=DictLinkT;
  SetLength(w,  WordLen[2]);
  SetLength(sd, WordLen[2]);
  for i:=0 to WordLen[2]-1 do w [i]:=Words[2,i];
  for i:=0 to WordLen[2]-1 do sd[i]:=GetStressDia(2, i);
  e:=Ending[2];
  Langs[0,0]:=Langs[2,0];
  WordLen[0]:=Length(w);
  for i:=0 to WordLen[0]-1 do WordsStressDia[0, i, sd[i]]:=w[i];
  Ending[0]:=e;
  MorphBound[0]:=Word(-1);
  for i:=0 to 1 do Caret[0,i]:=WordLen[0];
  DictLinkS:=entry;
  DictLinkT:=nil;
  UpdateWord(False, '');
  if Addallwords.Checked then AddcurrwordsClick(nil);
end; {UpBtnClick}

procedure TNeogrammarian.GheWordBtnClick(Sender: TObject);
function GheChar(t: Byte; P: array of Real; zero: Real): Byte;
  var i: Integer;
      r, m: Real;
  begin
    r:=Min(Random/zero, 1);
    Result:=255;
    m:=0;
    for i:=0 to Length(P)-1 do begin
      m:=m+P[i];
      if r<m then begin
        Result:=t+i;
        Break;
      end;
    end;
  end;
const tVowel=0; tCons=12; tModif=20;
      glosses: array[0..30] of string =
       ('zero', 'opposite', 'one', 'ten', 'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'several', 'each',
        'yes', 'no', 'and', 'or', 'xor',
        'do', 'make', 'go', 'eat', 'mow',
        'cat', 'dog', 'chicken', 'ship', 'meadow', 'identity',
        'male', 'female', 'woman', 'green');
      translations: array[0..30, 0..3] of Byte =
       ((0, 15, 24, 99), (18, 99, 99, 99), (16, 21, 99, 99), (1, 15, 22, 99), (1, 2, 13, 24), (13, 21, 99, 99), (2, 17, 15, 99), (1, 12, 22, 99),  (18, 23, 99, 99), (16, 23, 99, 99), (19, 22, 99, 99),
        (0, 99, 99, 99), (3, 99, 99, 99), (2, 99, 99, 99), (1, 99, 99, 99), (4, 99, 99, 99),
        (16, 23, 99, 99), (14, 99, 99, 99), (15, 20, 99, 99), (5, 15, 18, 99), (2, 17, 17, 20),
        (0, 19, 24, 99), (1, 19, 13, 22), (1, 14, 18, 99), (0, 18, 19, 99), (3, 13, 13, 22), (2, 14, 22, 99),
        (12, 25, 99, 99), (12, 22, 99, 99), (12, 22, 99, 99), (16, 15, 23, 99));
var i, j, l, s: Integer;
    b: Boolean;
    st: string;
begin
  DestroyCaret;
  GheWordForm.GlossEdit.Text:='';
  GheWordForm.ActiveControl:=GheWordForm.GlossEdit;
  if (Langs[0,0]=lGhe) and (GheWordForm.ShowModal=idOK) then begin
    DictLinkS:=nil;  
    DictLinkT:=nil;
    st:=LowerCase(GheWordForm.GlossEdit.Text);
    l:=0;
    b:=True;
    for i:=1 to Length(st) do if not (st[i] in ['a'..'z']) then b:=False else if (st[i] in ['a', 'e', 'i', 'o', 'u', 'y']) and
      ((i=0) or not (st[i-1] in ['a', 'e', 'i', 'o', 'u', 'y'])) and not ((i=Length(st)) and (st[i]='e')) then Inc(l, 2) else Inc(l);
    if b then begin
      HistPopupClick(nil);
      WordLen[0]:=0;
      for i:=0 to High(glosses) do if st=glosses[i] then for j:=High(translations[0]) downto 0 do if translations[i,j]<99 then Insert(0, 0, translations[i,j]);
      if WordLen[0]=0 then while Length(st)>0 do begin
        s:=0;                                                             
        for i:=1 to Min(7, Length(st)) do s:=27*s+(Ord(st[i])-96);
        RandSeed:=s;
        Insert(0, 0, GheChar(tModif, [0.1, 0.1, 0.1, 0.1, 0.1, 0.1], 1));
        for i:=1 to 3 do Insert(0, 0, GheChar(tCons, [0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1], l/(5+WordLen[0])));
        if (Words[0,0] in [tModif..25]) or ((Words[0,0]<255) and (Words[0,0]=Words[0,1]) and (Words[0,1]=Words[0,2])) then Delete(0, 0);
        Insert(0, 0, GheChar(tVowel, [0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05], l/3));
        if Random<0.2 then if Words[0,0] in [0..2] then Insert(0, 1, 2) else if Words[0,0] in [3..5] then Insert(0, 1, 5);
        st:=Copy(st, Random(WordLen[0])+4, 1000);
        l:=Max(l-WordLen[0], 1);
      end;
      Ending[0]:=WordLen[0];
      MorphBound[0]:=Word(-1);
      case GheWordForm.SpeechPartGroup.ItemIndex of
        0: Add(0, 0);
        1: Add(0, 6);
        2: Add(0, 8);
        3: Add(0, 11);
        4: Ending[0]:=Word(-1);
      end;
      for i:=0 to 1 do Caret[0,i]:=WordLen[0];
      UpdateWord(False, '');
      GheGloss[0]:=GheWordForm.GlossEdit.Text;
      if Addallwords.Checked then AddcurrwordsClick(nil);
    end else TangoMessageBox('Invalid character(s)! Only the letters ‘a’ to ‘z’ are allowed.', mtError, [mbOK], '');
  end;
  AppActivate(nil);
end; {GheWordBtnClick}

procedure TNeogrammarian.CopyBtnClick(Sender: TObject);
var a, b, a1, b1, l: Integer;
    H: THandle;
    RTF, st: string;
    lem: Boolean;
    P: PChar;
begin
  with TSpeedButton(Sender) do if Enabled then with Clipboard do begin
    if (Tag=0) and (Caret[0,0]<>Caret[0,1]) then begin
      a1:=Caret[0,0];
      b1:=Caret[0,1];
      a:=Min(a1, b1);
      b:=Max(a1, b1)-1;
    end else begin
      a:=-1;  b:=WordLen[Tag];
    end;
    Open;
    Clear;
    l:=Langs[Tag, 0];
    CopyRTFasUnicode('<abbr title="'+LongLangNs[l]+'">'+LangNs[l]+'</abbr> '+MakeWordHTML(Tag, a, b, 'span', False, st, lem));
    RTF:='{\rtf1\ansi{\fonttbl{\f0\fnil\fcharset0 Gentium plus;}{\f2\fnil\fcharset0 Lemizh;}}\pard\fs24\f'+IntToStr(2*Ord(lem))+st+'}';
    H:=GlobalAlloc(gmem_Moveable, Length(RTF)+1);
    P:=GlobalLock(H);
    StrPCopy(P, RTF);
    GlobalUnlock(H);
    SetAsHandle(CF_RTF, H);
    Close;
  end;
end; {CopyBtnClick}

procedure TNeogrammarian.DictBtnClick(Sender: TObject);
var p: TPoint;
begin
  p:=SourceBackPanel.ClientToScreen(Point(DictBtn.Left, DictBtn.Top+DictBtn.Height));
  DictPopup.Popup(p.X, p.Y);
end; {DictBtnClick}

procedure TNeogrammarian.DictPopupPopup(Sender: TObject);
begin
  Addcurrwords.Enabled:=(WordLen[0]>0) and (WordLen[2]>0);
  AddPIEparticiple1.Visible:=(Langs[0,0]=lPIE) and ComboBox.Visible and (ComboBox.ItemIndex in [0..17, 20..24]);
  AddPIEparticiple2.Visible:=AddPIEparticiple1.Visible and not (ComboBox.ItemIndex=24);
end; {DictPopupPopup}

procedure TNeogrammarian.AddallwordsClick(Sender: TObject);
begin
  Addallwords.Checked:=not Addallwords.Checked;
  DictBtn.GroupIndex:=Ord(Addallwords.Checked);
  DictBtn.AllowAllUp:=not Addallwords.Checked;
  DictBtn.Down:=Addallwords.Checked;
  with DictForm do if Addallwords.Checked then begin
    ShowdictionaryClick(nil);
    AddcurrwordsClick(nil);
    StatusShape.Hint:='dictionary active';
    StatusShape.Brush.Color:=$00C000;
  end else begin
    DictLinkS:=nil;
    DictLinkT:=nil;
    StatusShape.Hint:='dictionary inactive';
    StatusShape.Brush.Color:=$8080FF;
  end;
end; {AddallwordsClick}

procedure TNeogrammarian.ShowdictionaryClick(Sender: TObject);
begin
  DictForm.Show;
  if DictForm.WindowState=wsMinimized then DictForm.WindowState:=wsNormal;
end; {ShowdictionaryClick}

procedure TNeogrammarian.AddcurrwordsClick(Sender: TObject);
begin
  with DictForm do if (WordLen[0]>0) and (WordLen[2]>0) then begin
    Show;
    AddWords(Langs[0,0], Langs[2,0], FWords[0], FWords[2], FStressDia[0], FStressDia[2], FEnding[0], FEnding[2], FMorphBound[0], Word(-1),
      GheGloss[0], RemarksBox.Items, VarCode, FDictLinkS, FDictLinkT, True);
    DictLinkS:=FDictLinkS;
    DictLinkT:=FDictLinkT;
    Neogrammarian.SetFocus;
  end;
end; {AddcurrwordsClick}

procedure TNeogrammarian.AddPIEparticipleClick(Sender: TObject);
var athem: Boolean;
begin
  PIEStem(Langs[0,0], False);
  WordLen[1]:=Ending[1];
  athem:=ComboBox.ItemIndex in [0..4, 6..8, 11, 20, 22, 23];
  if athem then Grade(gZeroPlusC, False);
  FMorphBound[1]:=Ending[1];
  if ComboBox.ItemIndex=24 then begin            {perfect:      -wós-s (> -wó:s)}
    Add(1, 8); Add(1, 4); Add(1, 18); Ending[1]:=WordLen[1];
  end else if TMenuItem(Sender).Tag=0 then begin {active:       -ónt-s}
    Add(1, 4); Add(1, 12); Add(1, 31); Ending[1]:=WordLen[1];
  end else begin                                 {mediopassive: -(o-)mh1n-ós}  
    if not athem then Add(1, 4);
    Add(1, 10); Add(1, 22+Ord(athem)); Add(1, 12); Ending[1]:=WordLen[1]; Add(1, 4);
  end;
  Grade(gO, athem);
  Add(1, 18);
  with DictForm do begin
    Show;
    AddWords(Langs[0,0], Langs[0,0], FWords[0], FWords[1], FStressDia[0], FStressDia[1], FEnding[0], FEnding[1], FMorphBound[0], FMorphBound[1],
      '', nil, VarCode+$80+$40*TMenuItem(Sender).Tag, FDictLinkS, FDictLinkT, False);
    DictLinkS:=nil;
    DictLinkT:=nil;            
  end;                         
end; {AddPIEparticipleClick}

procedure TNeogrammarian.OptBoxesClick(Sender: TObject);
begin
  UpdateWord(True, '¤');
end; {OptBoxesClick}

function TNeogrammarian.ShowComboBox(Show: Boolean; Id: Integer): Integer;
var i: Integer;
begin
  Result:=Max(ComboBoxIndices[Id], 0);
  ComboBox.Items.Clear;
  ComboBox.Tag:=Id;
  if Show then begin
    for i:=0 to ComboBoxNrs[Id]-1 do ComboBox.Items.Add(LoadStr(10*Id+i));
    ComboBox.ItemIndex:=Result;
  end else Result:=ComboBoxDef[Id];
  ComboBox.Visible:=Show;
end; {ShowComboBox}

procedure TNeogrammarian.DrawUnicode(ACanvas: TCanvas; Rect: TRect; FrontColor, BackColor: TColor; Invert, ConvBrackets: Boolean; S: string);
var p, q, x, l, c: Integer;
    st: string;
    bmp: TBitmap;
begin
  bmp:=TBitmap.Create;
  bmp.Width:=16; bmp.Height:=16;
  q:=1;
  x:=Rect.Left+2;
  with ACanvas do if Invert then begin
    Brush.Color:=FrontColor;
    Font.Color:=BackColor;
    CopyMode:=cmMergePaint;
  end else begin
    Brush.Color:=BackColor;
    Font.Color:=FrontColor;
    CopyMode:=cmSrcPaint;
  end;
  ACanvas.FillRect(Rect);
  if ConvBrackets then S:=StringReplace(StringReplace(S, '{', '[', [rfReplaceAll]), '}', ']', [rfReplaceAll]);
  with ACanvas do repeat
    p:=Pos('%', Copy(S, q, 255));
    if p=0 then p:=MaxInt;
    st:=Copy(S, q, p-1);
    TextOut(x, Rect.Top, st);
    Inc(x, TextWidth(st));
    if p<MaxInt then begin
      l:=StrToInt(Copy(S, p+q, 2));
      c:=StrToInt(Copy(S, p+q+2, 2));
      CharList.GetBitmap(CharIds[l,c], bmp);
      if not Invert then Brush.Color:=FrontColor;
      FillRect(Bounds(x, Rect.Top, 16, 16));
      Draw(x, Rect.Top, bmp);
      if not Invert then begin
        Brush.Color:=BackColor;
        CopyMode:=$A000C9;
      end;
      Draw(x, Rect.Top, bmp);
      if not Invert then CopyMode:=cmSrcPaint;
      Inc(x, CharWidth(CharIds[l,c]));
    end;
    Inc(q, p+4);
  until p=MaxInt;
  bmp.Free;
end; {DrawUnicode}

procedure TNeogrammarian.ComboBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  with ComboBox do DrawUnicode(Canvas, Rect, Font.Color, Color, odSelected in State, True, Copy(Items[Index], 3, MaxInt));
  if Index in [18, 20, 24, 25, 27, 29, 31..34, 37] then with ComboBox.Canvas do begin
    Pen.Color:=MixColors(Font.Color, clBlack, 0.25);
    MoveTo(Rect.Left, Rect.Top);
    LineTo(Rect.Right, Rect.Top);
  end;
end; {ComboBoxDrawItem}

procedure TNeogrammarian.RemarksBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var st: string;
begin
  with RemarksBox do begin
    if Pos('|', Items[Index])=0 then st:=Items[Index] else
      if SemBtn.Down then st:=Copy(Items[Index], Pos('|', Items[Index])+1, 10000) else st:=Copy(Items[Index], 1, Pos('|', Items[Index])-1);
    DrawUnicode(Canvas, Rect, IfThen(SemBtn.Down and (Length(st)>0) and (st[1]='('), clGrayText, TColor(Items.Objects[Index])), Color, False, False, st);
  end;
end; {RemarksBoxDrawItem}

procedure TNeogrammarian.LicenseImageClick(Sender: TObject);
begin
  if Sender=LemizhImage then OpenHTTP('https://lemizh.conlang.org/') else OpenHTTP('https://www.gnu.org/licenses/gpl-3.0.html');     
end; {LicenseImageClick}

procedure TNeogrammarian.SmallBtnClick(Sender: TObject);
begin
  if Sender=nil then SmallBtn.Down:=not SmallBtn.Down;
  HidePanel1.Visible:=not SmallBtn.Down;
  HidePanel2.Visible:=HidePanel1.Visible;
  TargetBackPanel.Top:=LargeTargetPanelTop-HidePanel2.Height*Ord(not HidePanel1.Visible);
  TargetBackPanel.Height:=LargeTargetPanelHeight-4*RemarksBox.ItemHeight*Ord(not HidePanel1.Visible);
  Width:= LargeWidth -HidePanel1.Width*Ord(not HidePanel1.Visible);
  if HidePanel1.Visible then Height:=LargeHeight else ClientHeight:=TargetBackPanel.Top+TargetBackPanel.Height+3*SmallBtn.Height div 2;
  Left:=Max(Min(Left, Screen.Width-Width-5), 5);
  Top:=Max(Min(Top, Screen.Height-Height-30), 5);
  if HidePanel1.Visible then SmallBtn.Hint:='Reduce window (F2)' else SmallBtn.Hint:='Enlarge window (F2)';
end; {SmallBtnClick}

procedure TNeogrammarian.SemBtnClick(Sender: TObject);
begin
  if Sender<>SemBtn then SemBtn.Down:=not SemBtn.Down;
  SemMenuitem.Checked:=SemBtn.Down;
  if SemBtn.Down then SemBtn.Hint:='Show sound shift rules (F4)' else SemBtn.Hint:='Show semantic shift rules (F4)';
  if SemBtn.Down then RemarksBox.Color:=$FFCCCC else RemarksBox.Color:=clWindow;
  RemarksBox.Invalidate;
end; {SemBtnClick}

procedure TNeogrammarian.CopyRemarksClick(Sender: TObject);
var i: Integer;
    st: string;
begin
  st:='';
  with RemarksBox do for i:=0 to Items.Count-1 do if Pos('|', Items[i])=0 then st:=st+Items[i]+#13#10 else
    if SemBtn.Down then st:=st+Copy(Items[i], Pos('|', Items[i])+1, 10000)+#13#10 else st:=st+Copy(Items[i], 1, Pos('|', Items[i])-1)+#13#10;
  CopyRTFasUnicode(PercentToRTF(st));
end; {CopyRemarksClick}

procedure TNeogrammarian.PopupBtnClick(Sender: TObject);
var p: TPoint;
begin
  p:=ClientToScreen(Point(PopupBtn.Left, PopupBtn.Top+PopupBtn.Height));
  BtnPopup.Popup(p.X, p.Y);
end; {PopupBtnClick}

const HTMLhead = '<!DOCTYPE HTML>'#13#10+
                 '<html>'#13#10'<head>'#13#10'<title>Letter table</title>'#13#10+
                 '<meta http-equiv="content-type" content="text/html; charset=utf-8">'#13#10+
                 '<style>table, td, th {border: 1px solid silver}</style>'#13#10+
                 '</head>'#13#10'<body>'#13#10'<table>'#13#10;
     HTMLbottom = '</table>'#13#10'</body>'#13#10'</html>'#13#10;

procedure TNeogrammarian.CopyletterlistClick(Sender: TObject);
var st: string;
    i, j: Integer;
begin
  st:=HTMLhead+'<tr>';
  for i:=0 to 7 do st:=st+'<th style="width: 4em">n</th><th style="width: 4em">Symbol</th>';
  for i:=0 to 31 do begin
    st:=st+'</tr><tr>';
    for j:=0 to 7 do st:=st+'<td>'+IntToStr(i+32*j)+'</td><td'+Copy(' style="font-family: Lemizh"', 1, 100*Ord((i+32*j) in [115..151]))+'>'+LoadStr(i+32*j+100)+'</td>'#13#10;
  end;
  CopyRTFasUnicode(st+'</tr>'+HTMLbottom);
end; {CopyletterlistClick}

procedure TNeogrammarian.CopylettertableClick(Sender: TObject);
var st: string;
    i, j: Integer;
begin
  st:=HTMLhead;
  for i:=0 to High(LangNs) do begin
    st:=st+'<tr><th colspan="'+IntToStr(High(CharIds[0])+1)+'">'+LongLangNs[i]+'</th></tr>'#13#10'<tr>';
    for j:=0 to High(CharIds[0]) do st:=st+'<td>'+IntToStr(j)+'</td>';
    st:=st+'</tr>'#13#10'<tr>';
    for j:=0 to High(CharIds[0]) do st:=st+'<td'+Copy(' style="font-family: Lemizh"', 1, 100*Ord(i in [lMLem..lModLem]))+'>'+LoadStr(CharIds[i,j]+100)+'</td>';
    st:=st+'</tr>'#13#10'<tr>';
    for j:=0 to High(CharIds[0]) do st:=st+'<td>'+IntToStr(CharIds[i,j])+'</td>';
    st:=st+'</tr>'#13#10;
  end;
  CopyRTFasUnicode(st+HTMLbottom);
end; {CopyletterlistClick}

procedure TNeogrammarian.CopyGreekvoweltableClick(Sender: TObject);
var st: string;
    i: Integer;
begin
  st:=HTMLhead+'<tr><th>n</th><th>Basic</th><th>Psili (+300)</th><th>Dasia (+400)</th></tr>'#13#10;
  for i:=61 to 104 do if LoadStr(i+400)<>'' then
    st:=st+'<tr><td>'+IntToStr(i)+'</td><td>'+LoadStr(i+100)+'</td><td>'+LoadStr(i+400)+'</td><td>'+LoadStr(i+500)+'</td></tr>'#13#10;
  CopyRTFasUnicode(st+HTMLbottom);
end; {CopyGreekvoweltableClick}

{----------------------------------------------------------UpdateWord--------------------------------------------------------------}

procedure TNeogrammarian.Reduplicate(r: Integer; accent: Boolean);
var p, i: Integer;
begin
  p:=-1;
  repeat Inc(p) until Words[1,p] in [0..5, 255];
  if Words[1,p]<255 then begin
    WordLen[1]:=WordLen[1]+p+1;
    for i:=WordLen[1]-1 downto p+1 do Words[1,i]:=Words[1,i-p-1];
    Words[1,p]:=r;
    if accent then SetStress(1, p, stIs1, False);
  end;
end; {Reduplicate}

procedure TNeogrammarian.Grade(g: Integer; accent: Boolean);
const syll = [0..5, 7, 9, 11, 13, 15, 17, 23, 25, 27, 43];
var i, p: Integer;
begin
  p:=WordLen[1];
  repeat Dec(p) until Words[1,p] in [0..5, 255];
  if Words[1,p]<255 then begin
    case g of                                                    
      gZeroPlusC, gZeroPlusV: if Words[1,p] in [0, 2, 4] then begin
        Delete(1, p);
        for i:=p downto p-1 do
          if ((Words[1,i] in [6, 8, 10, 12, 14, 16]) or (Words[1,i] in [22, 24, 26]) {and not (Words[1,i+1] in [18, 20])})   /// because h1 in h1s-mi should be syllabic
            and not (Words[1,i-1] in syll) and not ((Words[1,i+1] in syll) or ((Words[1,i+1]=255) and (g=gZeroPlusV)))
              then Words[1,i]:=Words[1,i]+1;
      end else Words[1,p]:=Words[1,p]-1;
      gFull: ;
      gLength:  if Words[1,p] in [0, 2, 4] then Words[1,p]:=Words[1,p]+1;
      gO:       if Words[1,p] in [0, 2, 4] then Words[1,p]:=4 else Words[1,p]:=5;
      gOLength: Words[1,p]:=5;
    end;
    if accent then SetStress(1, p, stIs1, False);
  end;
end; {Grade}

procedure TNeogrammarian.PIEStem(Lang: Byte; assimSPH: Boolean = True);
var i, p: Integer;
begin
  WordLen[1]:=WordLen[0];
  for i:=0 to WordLen[0]-1 do WordsStressDia[1, i, GetStressDia(0, i)]:=Words[0,i];
  Ending[1]:=Ending[0];
  if assimSPH and (Words[1,0]=18) and (Words[1,1] in [29, 30, 32, 33, 35, 36, 38, 39, 41, 42]) then begin
    RemarksBox.Items.AddObject('Progressive assimilation of '+MCh(lPIE, Words[1,0])+MCh(lPIE, Words[1,1])+' (in PIE)|(Internal PIE shift)', Pointer(clWindowText));
    if Words[1,1] in [29, 32, 35, 38, 41] then Words[1,1]:=Words[1,1]-1 else Words[1,1]:=Words[1,1]+16;
  end;
  case ShowComboBox(Ending[0]=WordLen[0], 3) of
     0  {root present, non-verbs}, 18 {full-grade root stative}, 20 {root aorist}: if Ending[0]=WordLen[0] then Grade(gFull, True);
     1: {Narten present} Grade(gLength, True);
     2: {u-present} begin Grade(gFull, True); Add(1, 9); end;
     3: {e-reduplicated athematic present} begin Reduplicate(0, True); Grade(gO, False); end;
     4: {i-reduplicated athematic present} begin Reduplicate(7, False); Grade(gFull, True); end;
     5: {i-reduplicated thematic present} begin Reduplicate(7, False); Grade(gZeroPlusV, False); Add(1, 4); Grade(gFull, True); end;
     6: {nasal present} begin Grade(gZeroPlusC, False); i:=WordsB[1,1]; WordsB[1,1]:=12; Add(1, 0); Add(1, i); Grade(gFull, True); end;
     7: {néw-present} begin Grade(gZeroPlusC, False); Add(1, 12); Add(1, 0); Add(1, 8); Grade(gFull, True); end;  
     8: {néH-present} begin Grade(gZeroPlusC, False); Add(1, 12); Add(1, 0); Add(1, 22); Grade(gFull, True); end;
     9  {full-grade thematic present}, 21 {thematised root aorist}: begin Grade(gFull, True); Add(1, 4); end;
    10: {zero-grade thematic present} begin Grade(gZeroPlusV, False); Add(1, 4); Grade(gFull, True); end;
    11: {sk(é)-present} begin Grade(gZeroPlusC, False); Add(1, 18); Add(1, 34);
      if Lang>lPrLem then begin
        Add(1, 4); Grade(gFull, True);
      end; end;
    12: {full-grade ye-present} begin Grade(gFull, True); Add(1, 6); Add(1, 4); end;
    13: {zero-grade yé-present} begin Grade(gZeroPlusC, False); Add(1, 6); Add(1, 4); Grade(gFull, True); end;
    14: {éye-present} begin Grade(gZeroPlusV, False); Add(1, 0); Grade(gFull, True); Add(1, 6); Add(1, 4); end;
    15: {de-present} begin Grade(gFull, True); Add(1, 32); Add(1, 4); end;
    16: {dhe-present} begin Grade(gFull, True); Add(1, 33); Add(1, 4); end;
    17: {te-present} begin Grade(gFull, True); Add(1, 31); Add(1, 4); end;
    19: {zero-grade root stative} begin Grade(gZeroPlusC, False); end;
    22: {s-aorist} begin Grade(gLength, True); Add(1, 18); end;
    23: {reduplicated aorist} begin Reduplicate(0, True); Grade(gZeroPlusV, False); Add(1, 0); end;
    24: {perfect} begin Reduplicate(0, False); Grade(gO, True); end;
    25  {ye-causative}, 27 {ye-iterative}: begin Grade(gOLength, True); Add(1, 6); Add(1, 4); end;
    26  {éye-causative}, 28 {éye-iterative}: begin Grade(gO, False); Add(1, 0); Grade(gFull, True); Add(1, 6); Add(1, 4); end;
    29: {s-desiderative} begin Grade(gFull, True); Add(1, 18); end;
    30: {reduplicated desiderative} begin Reduplicate(7, False); Grade(gZeroPlusC, False); Add(1, 18); Add(1, 4); Grade(gFull, True); end;
    31: {intensive} begin
      p:=-1;
      repeat Inc(p) until Words[1,p]>5;
      if Words[1,p]<255 then Insert(1, 0, Words[1,p]);
      Insert(1, 1, 0);
      SetStress(1, 1, stIs1, False);
      Inc(p, 1+Ord(Words[1,p]<255));
      repeat Inc(p) until Words[1,p]>5;
      if Words[1,p]<255 then Insert(1, 2, Words[1,p]);
      Grade(gO, False);
    end;
    32: {fientive} begin Grade(gZeroPlusV, False); Add(1, 0); Grade(gFull, True); Add(1, 22); end;
    33: {essive} begin Grade(gZeroPlusC, False); Add(1, 22); Add(1, 6); Add(1, 4); Grade(gFull, True); end;
    34: {r-stem adjective} begin Grade(gZeroPlusC, False); Add(1, 14); end;
    35: {u-stem adjective} begin Grade(gZeroPlusV, False); Add(1, 9); SetStress(1, WordLen[1], stIs1, False); end;
    36: {o-stem adjective} ;
    //37: {nt-stem adjective} begin Grade(gZeroPlusV, False); Add(1, 12); Add(1, 31); end;   // is zero grade correct? -onts vs -ntos? stress? s. http://users.ox.ac.uk/~shug1472/Caland_handout.pdf
    37: {prefix} ;
  end;
  if Ending[0]=WordLen[0] then begin
    Ending[1]:=WordLen[1];
    if Lang>lPrLem then case ComboBox.ItemIndex of
      0..4, 6..8, 18, 29, 31, 32: {athem. primary} begin Add(1, 10); Add(1, 7); end;
      19: {athem. primary, stress on ending} begin Add(1, 10); Add(1, 7); SetStress(1, WordLen[1]-1, stIs1, False); end;
      5, 9..17, 25..28, 30, 33: {them. primary} Add(1, 24);
      20..23: {secondary} begin
        if Lang in [lEHell, lBrug] then Insert(1, 0, 0); {augment}
        Add(1, 10+Ord(WordsB[1,1] in [18, 20, 28..42]));
      end;
      24: {perfect} begin Add(1, 24); Add(1, 0); end;
      35: {athem. adjective} begin Add(1, 18); end;
      36: {them. adjective} begin Grade(gFull, True); Add(1, 4); Add(1, 18); end;
      34: {them. adjective, stress on ending} begin Add(1, 4); Add(1, 18); Grade(gO, True); end;
    end else Grade(gZeroPlusV, False);
  end;
end; {PIEStem}

const OTroyVowels = [0, 1, 5, 8, 10, 11, 14, 18, 22, 25, 26, 30];
function TNeogrammarian.OTroyVFromLast(i, Nr: Integer): Integer;
var j: Integer;
begin
  Result:=-1;
  for j:=WordLen[i]-1 downto 0 do if (Words[i,j] in OTroyVowels) and not ((Words[i,j-1] in [0, 5, 18]) and (Words[i,j] in [10, 25])) then begin
    Dec(Nr);
    if Nr=0 then begin Result:=j; Break; end;
  end;
end; {OTroyVFromLast}

function TNeogrammarian.OTroyDiph(i: Integer; Ins: Boolean): Integer;
const Cd1: array[0..5] of Byte = ( 0, 5,  5, 18, 0,  5);
      Cd2: array[0..5] of Byte = (25, 0, 10, 25, 0, 25);
var j: Integer;
begin
  if Ins then begin
    for j:=0 to WordLen[i]-1 do Add(1, Words[i,j]);
    Ending[1]:=Ending[i];
  end;
  Result:=OTroyVFromLast(i, 1);
  if ((Words[i, Result-2] in [0, 5, 18]) or ((Words[i, Result-2] in [10, 25]) and not (Words[i, Result-3] in [0, 5, 18]))) and not (Words[i, Result-1] in [7, 17, 29]+OTroyVowels) then begin
    Dec(Result, 2);
    if Ins then begin
      Words[1, Result]:=Cd1[Words[0, Result] div 5];
      Insert(1, Result+1, Cd2[Words[0, Result] div 5]);
      RemarksBox.Items.AddObject('Old Troyan penultimate is a diphthong ('+MCh(lOTroy, Words[1, Result])+MCh(lOTroy, Words[1, Result+1])+')|(Old Troyan diphthong)', Pointer(clWindowText));
    end;
  end else Result:=-1;
end; {OTroyDiph}

procedure TNeogrammarian.UpdateWord(UpDict: Boolean; Gloss: string);
const ceNo = -1;  ceRoot = 0;  ce1s = 1; ceInf = 2;

  procedure CheckEnding(Chars: array of LongWord; VerbForm: Integer);
  const VF: array[-1..2] of string = ('', 'root', '1st sg', 'infinitive');
  var c: LongWord;
      i: Integer;
      b: Boolean;
  begin                    
    c:=0;
    for i:=Ending[0] to WordLen[0] do Inc(c, (1 shl (8*(i-Ending[0])))*Words[0,i]);
    b:=c=0;
    for i:=0 to Length(Chars)-1 do if Chars[i]=c then b:=True;
    if not b then RemarksBox.Items.AddObject(IfThen(Ending[0]=WordLen[0], 'Missing', 'Unsupported')+' ending! '+IfThen(VerbForm>-1, 'Use '+VF[VerbForm]+' for verbs.'), Pointer(clRed));
  end; {CheckEnding}

{$I Lemizh.pas}
{$I Ghean.pas}
{$I Greek.pas}
{$I Waldaiic.pas}
{$I Celtic.pas}

var st: string;
    i: Integer;
begin
  SourceImage.Invalidate;
  RemarksBox.Items.Clear;
  for i:=1 to 2 do begin
    WordLen[i]:=0;
    Ending[i]:=Word(-1);
  end;
  if Gloss<>'¤' then GheGloss[0]:=Gloss;
  if Dates[Langs[0,0]]=Dates[Langs[2,0]] then begin
    st:=LoadStr(2000+100*Langs[0,0]+Langs[2,0]);
    if st='' then st:='unknown';
    RemarksBox.Items.AddObject('Topic'+Copy('s', 1, Ord(Pos(',', st)>0))+': '+st, Pointer(clBlue));
  end;
  case Langs[0,0] of
    lPIE:          CheckEnding([$FF, $FF12{s}, $FF1204{os}, $FF0A04{on}, $FF1200{es}, $FF1800{eh2}, $FF2004{od}], ceRoot);
    lMLem, lLMLem: CheckEnding([$FF00{a}, $FF1A00{ar}, $FF1A02{yr}, $FF1A01{er}, $FF1A03{ir}, $FF1A05{ör}, $FF1A07{ür}, $FF1C02{yl}], ceNo);
    lNLem:         CheckEnding([$FF00{a}], ceNo);
    lGhe:          CheckEnding([$FF00{a}, $FF06{a:}, $FF08{shwa:}, $FF09{e:}, $FF0B{i:}], ceNo);
    lEHell:        CheckEnding([$FF13{o:}, $FF080E{mi}, $FF08000E{mai}, $FF1B{s}, $FF1B12{os}, $FF1012{on}{,//$FF00{a}, $FF01{a:}], ce1s);
    lKoi:          CheckEnding([$FF1A{o:}, $FF090D{mi}, $FF09000D{mai}, $FF13{s}, $FF1310{os}, $FF0E10{on} ,$FF00{a}, $FF01{a:}, $FF07{e:}], ce1s);
    lOTroy:        CheckEnding([$FF0A00{ai}, $FF17{s}, $FF1712{os}, $FF1012{on}, $FF00{a}], ceInf);              
    lPrWald:       CheckEnding([$FF13{o}, $FF0B11{mi}, $FF1800{as}, $FF1813{os}, $FF18{s}, $FF19{š}, $FF00{a}], ce1s);
    lElb:          ;  //
    lPrCelt:       CheckEnding([$FF15{u:}, $FF090E{mi}, $FF01{a:}, $FF0A{i:}, $FF1210{os}, $FF0E10{om}, $FF12{s}], ce1s);
    lBesk:         CheckEnding([$FF14{m}], ce1s)
  end;
  if ComboBox.Visible then ComboBoxIndices[ComboBox.Tag]:=ComboBox.ItemIndex;
  case 100*Langs[0,0]+Langs[2,0] of
    100*lPIE   +lPrLem:  PIEtoPrLem;
    100*lPIE   +lEHell:  PIEtoEHell;     /// NOT FINISHED
    100*lPIE   +lPrWald: PIEtoPrWald;
    100*lPIE   +lPrCelt: PIEtoPrCelt;    // not finished
    100*lPIE   +lBrug:   PIEtoBrug;      // not implemented
    100*lPrLem +lOLem:   PrToOLem;
    100*lOLem  +lMLem:   OToMLem;
    100*lOLem  +lVolg:   OLemToVolg;     // not implemented
    100*lOLem  +lEHell:  OLemToEHell;
    100*lOLem  +lPrWald: OLemToPrWald; 
    100*lOLem  +lNLem:   OToNLem;
    100*lEHell +lKoi:    EHellToKoine;   /// NOT FINISHED
    100*lEHell +lOLem:   EHellToOLem;
    100*lEHell +lOTroy:  EHellToOTroy;
    100*lEHell +lPrWald: EHellToPrWald;  // not implemented
    100*lPrWald+lEth:    PrWaldToEth;    // not finished
    100*lPrWald+lElb:    PrWaldToElb;    // not finished
    100*lPrWald+lOLem:   PrWaldToOLem;
    100*lPrWald+lEHell:  PrWaldToEHell;  // ending not implemented 
    100*lMLem  +lLMLem:  MToLMLem;
    //100*lMLem  +lGhe:    MLemToGhe;    // not implemented
    //100*lMLem  +lOTroy:  MLemToOTroy;  // not implemented
    //100*lMLem  +lPrCelt: MLemToPrCelt; // not implemented
    100*lGhe   +lMLem:   GheToMLem;      
    //100*lGhe   +lOTroy:  GheToOTroy;   // not implemented
    //100*lGhe   +lPrCelt: GheToPrCelt;  // not implemented
    100*lOTroy +lNTroy:  OToNTroy;       
    100*lOTroy +lMLem:   OTroyToMLem;
    //100*lOTroy +lGhe:    OTroyToGhe;   // not implemented
    //100*lOTroy +lPrCelt: OTroyToPrCelt;// not implemented
    100*lPrCelt+lBesk:   PrCeltToBesk;
    100*lPrCelt+lMLem:   PrCeltToMLem;
    //100*lPrCelt+lGhe:    PrCeltToGhe;  // not implemented
    //100*lPrCelt+lOTroy:  PrCeltToOTroy;// not implemented
    100*lLMLem +lNLem:   LMToNLem;
    //100*lLMLem +lKoi:    LMLemToKoi;   // not implemented
    //100*lLMLem +lElb:    LMLemToElb;   // not implemented
    100*lKoi   +lLMLem:  KoineToLMLem;
    100*lKoi   +lNLem:   KoineToNLem;
    100*lKoi   +lModLem: KoineToModLem;  
    100*lKoi   +lElb:    KoiToElb;       // not implemented
    100*lElb   +lLMLem:  ElbToLMLem;     // not finished
    //100*lElb   +lKoi:    ElbToKoi;     // not implemented
    100*lNLem  +lModLem: NToModLem;     
    //100*lNLem  +lVolg:   NLemToVolg;   // not implemented
    //100*lNLem  +lBesk:   NLemToBesk;   // not implemented
    100*lVolg  +lNLem:   VolgToNLem;     // not implemented
    //100*lVolg  +lBesk:   VolgToBesk;   // not implemented
    100*lBesk  +lNLem:   BeskToNLem;
    //100*lBesk  +lVolg:   BeskToVolg;   // not implemented
    100*lModLem+lNTroy:  ModLemToNTroy;  // not implemented
    //100*lModLem+lEth:    ModLemToEth;  // not implemented
    //100*lModLem+lBrug:   ModLemToBrug; // not implemented
    100*lNTroy +lModLem: NTroyToModLem;
    100*lNTroy +lEth:    NTroyToEth;     // not implemented
    //100*lNTroy +lBrug:   NTroyToBrug;  // not implemented
    100*lEth   +lModLem: EthToModLem;   
    //100*lEth   +lNTroy:  EthToNTroy;   // not implemented
    //100*lEth   +lBrug:   EthToBrug;    // not implemented
    100*lBrug  +lModLem: BrugToModLem;   // not implemented
    //100*lBrug  +lNTroy:  BrugToNTroy;  // not implemented
    //100*lBrug  +lEth:    BrugToEth;    // not implemented
    else RemarksBox.Items.AddObject(LongLangNs[Langs[0,0]]+' > '+LongLangNs[Langs[2,0]]+' not implemented yet!', Pointer(clRed));
  end;
  if RemarksBox.Items.Count=0 then RemarksBox.Items.AddObject('[ none ]', Pointer(clGrayText));
  TargetImage.Invalidate;
  ActiveControl:=CharsBox;
  for i:=0 to 1 do with CopyBtns[i] do Enabled:=WordLen[2*i]>0;
  if UpDict and ((DictLinkS<>nil) or (DictLinkT<>nil)) and (WordLen[0]>0) and
    not DictForm.ChangeWords(DictLinkS, DictLinkT, FWords[0], FWords[2], FStressDia[0], FStressDia[2], FEnding[0], FEnding[2], FMorphBound[0], RemarksBox.Items, VarCode)
      and DictBtn.Down then AddcurrwordsClick(nil);
end; {UpdateWord}

{----------------------------------------------------------Utilities--------------------------------------------------------------}

function TNeogrammarian.GetWords(i, j: Integer): Byte;
begin
  if (j>=0) and (j<WordLen[i]) then Result:=FWords[i,j] else Result:=255;
end; {GetWords}

function TNeogrammarian.GetDrawWords(i, j: Integer): SmallInt;
var ch: Byte;
    s: TStress;
begin
  if j=-1 then begin
    if Langs[i,0] in Reconstructed then Result:=chAsterisk else Result:=-1;
  end else if (j=WordLen[i]) and (Langs[i,0]=lModLem) then Result:=chFullstop else begin
    ch:=GetWords(i, j);
    case Langs[i,0] of
      lKoi: if (ch=18) and (j=0) then ch:=29 else if (ch=19) and (j=WordLen[i]-1) then ch:=28;
      lOTroy: if (ch=23) and (j=WordLen[i]-1) then ch:=33;
      lEth: if (ch=20) and (GetWords(i, j-1) in [9, 17]) then ch:=39;
    end;
    if ch<255 then begin
      Result:=CharIds[Langs[i,0], ch];
      s:=GetStress(i, j, stAny);
      if s>=stIs1 then case Langs[i,0] of
        lEHell: if (ch in [8, 30]) and (s=stIs2) then Inc(Result, 4) else Inc(Result, Ord(s)-1);
        lKoi:   if (ch in [9, 21]) and (s=stIs2) then Inc(Result, 4) else Inc(Result, Ord(s)-1);
        lEth:   if ch in [0, 9, 17, 28, 35] then Inc(Result, Ord(s)-1) else if ch in [2, 11, 19, 30, 38] then Inc(Result, 1);
        else if s=stIs1 then Inc(Result, 1);
      end;
    end else Result:=-1;
  end;
end; {GetDrawWords}

procedure TNeogrammarian.SetWords(i, j: Integer; c: Byte);
begin
  FWords[i,j]:=c;
end; {SetWords}

procedure TNeogrammarian.SetWordsStressDia(i, j: Integer; sd, c: Byte);
begin
  FWords[i,j]:=c;
  FStressDia[i,j]:=sd;
end; {SetWordsStressDia}

function TNeogrammarian.GetWordsB(i, j: Integer): Byte;
begin
  if (j>=1) and (j<=WordLen[i]) then Result:=FWords[i, WordLen[i]-j] else Result:=255;
end; {GetWordsB}

procedure TNeogrammarian.SetWordsB(i, j: Integer; c: Byte);
begin
  if (j>=1) and (j<=WordLen[i]) then FWords[i,WordLen[i]-j]:=c;
end; {SetWordsB}

function TNeogrammarian.GetWordLen(i: Integer): Integer;
begin
  Result:=Length(FWords[i]);
end; {GetWordLen}

procedure TNeogrammarian.SetWordLen(i, v: Integer);
var j: Integer;
begin
  SetLength(FWords[i], Max(v, 0));
  SetLength(FStressDia[i], Max(v, 0));
  if i=0 then for j:=0 to 1 do Caret[0,j]:=Min(Caret[0,j], v);
  if Ending[i]>v then Ending[i]:=Word(-1);
  if MorphBound[i]>v then MorphBound[i]:=Word(-1);
end; {SetWordLen}

function TNeogrammarian.GetEnding(i: Integer): Word;
begin
  Result:=FEnding[i];
end; {GetEnding}

procedure TNeogrammarian.SetEnding(i: Integer; v: Word);
begin
  FEnding[i]:=Word(Max(Min(SmallInt(v), WordLen[i]), -1));
end; {SetEnding}

function TNeogrammarian.GetMorphBound(i: Integer): Word;
begin
  if (i<=0) or (i=3) then Result:=FMorphBound[i] else Result:=Word(-1);
end; {GetMorphBound}

procedure TNeogrammarian.SetMorphBound(i: Integer; v: Word);
begin
  if (i<=0) or (i=3) then FMorphBound[i]:=Word(Max(Min(SmallInt(v), WordLen[i]), -1));
end; {SetMorphBound}

procedure TNeogrammarian.WordCut(i, v: Integer);
begin                                                                         
  WordLen[i]:=WordLen[i]-v;
end; {WordCut}

procedure TNeogrammarian.Add(i: Integer; c: Byte);
begin
  Add(i, c, 0);
end; {Add}

procedure TNeogrammarian.Add(i: Integer; c, sd: Byte);
begin
  if c<255 then begin
    WordLen[i]:=WordLen[i]+1;
    WordsStressDia[i, WordLen[i]-1, sd]:=c;
  end;
end; {Add}

procedure TNeogrammarian.Delete(i, p: Integer);
var j: Integer;
begin
  for j:=p to WordLen[i]-2 do WordsStressDia[i, j, GetStressDia(i, j+1)]:=Words[i,j+1];
  if SmallInt(Ending[i])>p then Ending[i]:=Word(Ending[i]-1);
  if SmallInt(MorphBound[i])>p then MorphBound[i]:=Word(MorphBound[i]-1);
  WordCut(i, 1);
end; {Delete}

procedure TNeogrammarian.Insert(i, p, c: Integer);
var j: Integer;
begin
  if c<255 then begin
    WordLen[i]:=WordLen[i]+1;
    for j:=WordLen[i]-2 downto p do WordsStressDia[i, j+1, GetStressDia(i, j)]:=Words[i,j];
    WordsStressDia[i, p, 0]:=c;
    if SmallInt(Ending[i])>IfThen(Langs[i,0] in HyphenEndOnly, -1, p) then Ending[i]:=Ending[i]+1;
    if SmallInt(MorphBound[i])>p then MorphBound[i]:=MorphBound[i]+1;
  end;
end; {Insert}

procedure TNeogrammarian.InsAtCaret(c: Byte);
const iu:  array[lEHell..lKoi] of set of Byte= ([8, 30], [9, 21]);
      aeo: array[lEHell..lKoi] of set of Byte= ([0, 1, 4, 5, 18, 19], [0, 1, 5, 7, 16, 26]);
var   i: Integer;
      cb: Char;
begin
  cb:=#8;
  if Caret[0,0]<>Caret[0,1] then FormKeyPress(nil, cb);
  Insert(0, Caret[0,0], c);
  if (Langs[0,0] in [lEHell, lKoi]) and (c in iu[Langs[0,0]]) and (Words[0, Caret[0,0]-1] in aeo[Langs[0,0]]) and (GetStress(0, Caret[0,0]-1, stAny)>=stIs1)
    then SetStress(0, Caret[0,0], stIs2, True);
  if c<255 then for i:=0 to 1 do Inc(Caret[0,i]);
  for i:=0 to CharsBox.Items.Count-1 do if c=SortChar(Langs[0,0], i) then CharsBox.ItemIndex:=i;
end; {InsAtCaret}

function TNeogrammarian.GetLangs(i, j: Integer): Integer;
begin
  if i<0 then begin j:=Abs(i); i:=0; end;
  if j>0 then Result:=FHistLangs[i div 2, Min(j, MaxHist)] else if i in [0, 1] then Result:=Integer(SourceTree.Selected.Data)
    else if i=3 then Result:=DictLang else Result:=Integer(TargetBox.Items.Objects[TargetBox.ItemIndex]);
end; {GetLangs}

procedure TNeogrammarian.SetLangs(i, j, l: Integer);
var k: Integer;
begin
  if i<0 then begin j:=Abs(i); i:=0; end;
  if j>0 then FHistLangs[i div 2, Min(j, MaxHist)]:=l else if i in [0, 1] then begin
    for k:=0 to SourceTree.Items.Count-1 do if (SourceTree.Items[k].Level=1) and (Integer(SourceTree.Items[k].Data)=l)
      then SourceTree.Selected:=SourceTree.Items[k];
    DictLinkS:=nil;
  end else if i=3 then DictLang:=l else begin
    for k:=0 to TargetBox.Items.Count-1 do if Integer(TargetBox.Items.Objects[k])=l then TargetBox.ItemIndex:=k;
    DictLinkT:=nil;
    TargetBoxClick(nil);
  end;
end; {SetLangs}

function TNeogrammarian.GetStress(i, j: Integer; Sort: TStress): TStress;
function Can(i, j: Integer; Sort: TStress): Boolean;
  var k: Integer;
  begin
    Result:=False;
    if (Langs[i,0] in [lEHell, lKoi, lEth]) or (Sort=stIs1) then case Langs[i,0] of
      lPIE: Result:=Words[i,j] in [0..5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27];
      lLMLem: Result:=Words[i,j] in [0..7];
      lModLem: begin
        Result:=Words[i,j]=0;
        for k:=j+1 to WordLen[i]-1 do if Words[i,k] in [0..7] then Result:=False;
      end;
      lVolg: ; //?
      lEHell: Result:=((Words[i,j] in [9, 31]) or ((Words[i,j] in [1, 5, 19]) and not ((Words[i,j+1] in [8, 30]) and (FStressDia[i,j+1]<16)))
        or ((Words[i,j] in [8, 30]) and (FStressDia[i,j]<16) and (Words[i,j-1] in [0, 1, 4, 5, 18, 19])))
        or ((Sort=stIs1) and (((Words[i,j] in [0, 4, 8, 18, 30]) and not ((Words[i,j+1] in [8, 30]) and (FStressDia[i,j+1]<16))) or (Words[i,j] in [13, 15, 17, 26])));
      lKoi: Result:=((Words[i,j] in [10, 22]) or ((Words[i,j] in [1, 7, 26]) and not ((Words[i,j+1] in [9, 21]) and (FStressDia[i,j+1]<16)))
        or ((Words[i,j] in [9, 21]) and (FStressDia[i,j]<16) and (Words[i,j-1] in [0, 1, 5, 7, 16, 26])))
        or ((Sort=stIs1) and (Words[i,j] in [0, 5, 9, 16, 21]) and not ((Words[i,j+1] in [9, 21]) and (FStressDia[i,j+1]<16)));
      lNTroy: begin
        for k:=0 to j-1 do if Words[i,k] in [0, 4, 6, 8, 14, 19, 23] then Result:=True;
        Result:=Result and (Words[i,j] in [0, 4, 8, 14, 19, 23]) and not ((j=WordLen[i]-1) and (Words[i,j] in [8, 14]) and (Words[i,j-1] in [0, 4, 8, 14, 19, 23]))
          and not ((j=WordLen[i]-2) and (Words[i,j+1] in [8, 14]));
        for k:=j+1 to WordLen[i]-1 do if Words[i,k] in [0, 4, 6, 8, 14, 19, 23] then Result:=False;
      end;
      lPrWald: Result:=(Words[i,j] in [0, 1, 6, 7, 11, 12, 19, 20, 21, 27, 28]) and not ((Words[i,j-1] in [0, 6]) and (Words[i,j]=27-8*Words[i,j-1] div 3));
      lEth: begin
        Result:=(Words[i,j] in [0, 9, 17, 28, 35]) or ((Sort=stIs2) and (Words[i,j] in [2, 11, 19, 30, 37]));
        for k:=0 to WordLen[i]-1 do if (k<>j) and (Words[i,k] in [1, 2, 10, 11, 18, 19, 29, 30, 36, 37]) then Result:=False;
      end;
      lElb: ; // s.a. TDictForm.WordListBoxClick (accents on various compound types)
      lPrCelt: Result:=(Words[i,j] in [0, 1, 4, 5, 9, 10, 16, 20, 21]) and not ((Words[i,j-1] in [0, 16]) and (Words[i,j] in [9, 20]));
      lBrug: ; //?
    end;
  end; {Can}
begin
  if (j>=0) and (j<WordLen[i]) then begin
    if Sort=stAny then Result:=TStress(FStressDia[i,j] and 15) else begin
      Result:=TStress(Can(i, j, Sort));
      if (j>=0) and (TStress(FStressDia[i,j] and 15)=Sort) then
        if Result=stCant then FStressDia[i,j]:=FStressDia[i,j] and 16 + Byte(stCant) else Result:=Sort;
    end;
  end else Result:=stCant;
end; {GetStress}

procedure TNeogrammarian.SetStress(i, j: Integer; Sort: TStress; Toggle: Boolean);
var k: Integer;
begin
  j:=Min(Max(j, 0), WordLen[i]-1);
  while (j>=0) and (GetStress(i, j, Sort)=stCant) do Dec(j);
  if j=-1 then repeat Inc(j) until (j>=WordLen[i]) or not (GetStress(i, j, Sort)=stCant);
  if (j<WordLen[i]) and not (Sort=stCant) then begin
    if Toggle and (TStress(FStressDia[i,j] and 15)=Sort) then FStressDia[i,j]:=FStressDia[i,j] and 16 + Byte(stCant)
      else FStressDia[i,j]:=FStressDia[i,j] and 16 + Byte(Sort);
    if not (Langs[i,0]=lLMLem) and (TStress(FStressDia[i,j] and 15)>stCant) then for k:=0 to WordLen[i]-1 do if j<>k
      then FStressDia[i,k]:=FStressDia[i,k] and 16 + Byte(stCant);
  end;
end; {SetStress}

function TNeogrammarian.GetDia(i, j: Integer): TDia;
begin
  Result:=diaCant;
  if (j>-1) and (j<WordLen[i]) then
    if FStressDia[i,j]>15 then Result:=diaYes else case Langs[i,0] of
      lEHell: if (Words[i,j] in [8, 30]) and (Words[i,j-1] in [0, 1, 4, 5, 18, 19]) then Result:=diaCan;
      lKoi:   if (Words[i,j] in [9, 21]) and (Words[i,j-1] in [0, 1, 5, 7, 16, 26]) then Result:=diaCan;
    end;
end; {GetDia}

procedure TNeogrammarian.SetDia(i, j: Integer; Toggle: Boolean);   
begin
  j:=Min(Max(j, 0), WordLen[i]-1);
  while (j>=0) and (GetDia(i, j)=diaCant) do Dec(j);
  if j=-1 then repeat Inc(j) until (j>=WordLen[i]) or not (GetDia(i, j)=diaCant);
  if j<WordLen[i] then
    if Toggle then FStressDia[i,j]:=FStressDia[i,j] xor 16 else FStressDia[i,j]:=FStressDia[i,j] or 16;
end; {SetDia}

function TNeogrammarian.GetStressDia(i, j: Integer): Byte;
begin
  Result:=FStressDia[i,j];
end; {GetStressDia}

procedure TNeogrammarian.SetCaret(p0, p1: Integer);
begin
  Caret[0,0]:=Max(Min(p0, WordLen[0]), 0);
  Caret[0,1]:=Max(Min(p1, WordLen[0]), 0);
end;

function TNeogrammarian.MakeWordHTML(i, Start, Stop: Integer; HTMLTag: string; Id: Boolean): string;
var st: string;
    lem: Boolean;
begin
  Result:=MakeWordHTML(i, Start, Stop, HTMLTag, Id, st, lem);
end; {MakeWordHTML}

function TNeogrammarian.MakeWordHTML(i, Start, Stop: Integer; HTMLTag: string; Id: Boolean; out S: string; out Lem: Boolean): string;
var l, dasia, diph: Integer;
    inivowel: Boolean;
function Offset(j: Integer): Integer;
  begin
    Result:=100;
    if (l=lKoi) and (j<>Ending[i]) then begin
      if dasia=-1 then begin
        dasia:=Ord(Words[i,0]=27);
        diph:=Ord((Words[i,dasia] in [0, 1, 5, 7, 16, 26]) and (Words[i, dasia+1] in [9, 21]));
        inivowel:= Words[i,0] in [0, 1, 5, 7, 9, 10, 16, 21, 22, 26, 27];
      end;
      if inivowel then
        if j=dasia+diph then Result:=400+100*dasia else if (dasia=1) and (j=0) then Result:=-110;
    end;
    if GetDia(i, j)=diaYes then Result:=600;
  end; {Offset}
const grc: array[False..True, 61..112] of string = (('a', '\u225?', '\u257?', '\u226?', '\u227?', 'b', 'g', 'd', 'e', '\u233?', '\u275?', '\u234?', '\u7869?', 'w', 'z', 'th',
  'i', '\u237?', '\u299?', '\u238?', '\u297?', 'k', 'l', 'l\u805?', 'm', 'n', 'x', 'o', '\u243?', '\u333?', '\u244?', '\u245?', 'p', 'q', 'r', 'r\u805?', 'rh',
  's', 't', 'u', '\u250?', '\u363?', '\u251?', '\u361?', 'ph', 'kh', 'ps', 'hw', 's', 'h', '', 'h'),
  ('', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '\u239?', '\u7727?', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '',
  '', '', '\u252?', '\u472?', '', '', '', '', '', '', '', '', '', '', ''));
      otropron: array[False..True, 0..32] of string = (('a', 'a\u720?', '\u651?', '\u624?', 'ð\u798?', 'e', 'v', 'dz', 'e\u720?', '\u952?', 'i', 'i\u720?', '\u609?', 'l', 'l\u809?', 'm', 'n', '\u609?z',
  'o', 'b', 'k', 'r', 'r\u809?', 's', 'd', 'u', 'u\u720?', 'f', 'x', 'bz', 'o\u720?', 'h', 'h\u695?'),
  ('a\u860?u', '', '', '\u331?', '', 'e\u860?a', 'f', '', '', '', 'e\u860?i', '', 'k', '', '', '', '', '', 'o\u860?u', 'p', '', '', '', '', 't', 'e\u860?u', '', '', '', '', '', '', ''));
      ntropron: array[False..True, 0..25] of string = (('a', '\u651?', '\u624?', 'ð\u798?', 'e', 't', '', '\u952?', 'i', '\u609?', 'l', 'm', 'n', 'k', 'u', 'b', 'r', 's', 'd', 'y', 'f', 'x', 'p', 'o', 'h', '\u643?'),
  ('a\u860?i', '', '\u331?', '', 'i\u860?u', 'dz', '', '', 'e\u860?i', '', '', '', '', '\u609?z', 'o\u860?u', '', '', '', '', 'e\u860?u', '', '', 'bz', 'o\u720?', '', ''));
var j, dw, mo, re, di, str: Integer;
    st, pron: string;
begin
  if Stop=-1 then Stop:=WordLen[i];
  l:=Langs[i,0];
  dasia:=-1;
  S:='';  st:='';
  Lem:=l in [lMLem..lModLem];
  Result:='<'+HTMLTag+IfThen(Id, ' ¤')+' lang="'+LangTags[l]+'"';
  for j:=Start to Stop do begin
    S:=S+IfThen((j=Ending[i]) or (j=MorphBound[i]), '\u8209?')+LoadStr(DrawWords[i,j]+Offset(j));
    if l in [lKoi, lOTroy, lNTroy] then begin
      dw:=DrawWords[i,j];
      st:=st+IfThen((j=Ending[i]) or (j=MorphBound[i]), '\u8209?');
      if dw=67{gamma} then
        if (l in [lKoi, lOTroy]) and (DrawWords[i,j+1] in [67, 82, 87, 106]) or (l=lNTroy) and (DrawWords[i,j+1]=67) then dw:=86{ny} else
          if (l=lNTroy) and ((DrawWords[i,j+1] in [87, 98, 109]) or (j=1) and (DrawWords[i,0]=71{eta})) then st:=st+'n';
      if dw in [Low(grc[False])..High(grc[False])] then st:=st+grc[GetDia(i, j)=diaYes, dw];
      if (l=lNTroy) and (dw=109{sh}) then st:=st+'h';
    end;
  end;
  if Lem then Result:=Result+LemTranscript(S) else if st<>'' then Result:=Result+' title="'+st+'"';
  Result:=StringReplace(Result, '¤', 'id="'+MakeLemId(S)+'"', []);
  j:=Pos(' ', HTMLTag);
  if j=0 then j:=MaxInt;
  Result:=Result+'>'+S+'</'+Copy(HTMLTag, 1, j-1)+'>';
  pron:='';
  if (Start<1) and (Stop=WordLen[i]) then case l of
    lGhe: begin
      mo:=0;  re:=0;
      for j:=WordLen[i]-1 downto 0 do case Words[i,j] of
        0..11: if Words[i,j-1]=Words[i,j] then pron:='\u720?'+pron else begin
          pron:=IfThen(Words[i,j-1] in [0..11], '\u860?')+LoadStr(7000+Words[i,j])+pron;
          mo:=0;  re:=0;
        end;
        12..19: begin
          st:=LoadStr(7008+10*mo+Words[i,j]);
          pron:=Copy(st, 1, Length(st)-Ord((mo=1) and (Words[i,j] in [12, 14, 16, 18]) or (mo=4) and (Words[i,j] in [14]))*re)+pron;
          if mo=1 then re:=7 else if mo=4 then re:=6;
        end;
        20..25: mo:=Words[i,j]-19;
      end;
    end;
    lOTroy: begin
      di:=OTroyDiph(i, False);
      str:=OTroyVFromLast(i, 2);
      if str<=0 then Inc(str) else if OTroyVFromLast(i, 3)=-1 then str:=1 else if Words[i,str-1]=Words[i,str-2] then Dec(str);
      for j:=0 to WordLen[i]-1 do begin
        if str-1=j then pron:=pron+'\u712?';
        case Words[i,j] of
           0, 5, 10, 18, 25:
               pron:=pron+otropron[di=j, Words[i,j]];
           3:  pron:=pron+otropron[Words[i,j+1] in [3, 12, 17, 20, 28, 32], 3];
           6:  pron:=pron+otropron[(Words[i,j-1]=6) or (Words[i,j+1]=6), Words[i,j]];
          12, 19, 24: if Words[i,j]<>Words[i,j+1] then
               pron:=pron+otropron[Words[i,j-1] in [3, 15, 16, Words[i,j]], Words[i,j]];
          31:  pron:=pron+otropron[not (Words[i,j-1] in [0, 1, 5, 8, 10, 11, 14, 18, 22, 25, 26, 30, 255]), Words[i,j]];
          else pron:=pron+otropron[False, Words[i,j]];
        end;
      end;
    end;
    lNTroy: begin
      for j:=0 to WordLen[i]-1 do case Words[i,j] of
        0, 4, 8, 14, 19, 23:
          pron:=pron+ntropron[False, Words[i,j]];  /// DIPHS, STRESS (ultimate after syncopation; else penultimate; '\u712?')
        2: if not (Words[i,j-1]=2) then begin
          pron:=pron+ntropron[(Words[i,j+1] in [2, 13, 17, 25]) or (j=1) and (Words[i,0]=6), Words[i,j]];
          if (j=1) and (Words[i,0]=6) then pron:=pron+'\u781?';
        end;
        5, 13, 22:
          pron:=pron+ntropron[(Words[i,j-1] in [0, 4, 8, 14, 19, 23, 255]) and (Words[i,j+1] in [0, 4, 8, 14, 19, 23, 255]), Words[i,j]];
        else begin
          pron:=pron+ntropron[False, Words[i,j]];
          if (j=1) and (Words[i,0]=6) and (Words[i,1] in [10, 11, 12, 16]) then pron:=pron+'\u809?';
        end;
      end;                
      pron:=pron+' DIPHS+STRESS? ';
    end;
    lVolg: ; // ?
    lBesk: if Words[i, 0] in [0..5, 8, 9, 15, 16, 23, 24, 30, 31] then pron:='h\u8209?';
    lBrug: ; // ?
  end;
  if pron<>'' then Result:=Result+'&nbsp;/'+pron+'/';  
end; {MakeWordHTML}

function TNeogrammarian.SortChar(Lang, i: Integer): Byte;
begin
  if InternalSort.Checked then Result:=i else Result:=SortChars[Lang, i];
end; {SortChar}

procedure TNeogrammarian.SetDictLinkS(p: PDictEntry);
begin
  FDictLinkS:=p;
  SourceAddImage.Visible:=p<>nil;
end; {SetDictLinkS}

procedure TNeogrammarian.SetDictLinkT(p: PDictEntry);
begin
  FDictLinkT:=p;
  TargetAddImage.Visible:=p<>nil;                  
end; {SetDictLinkT}

function TNeogrammarian.VarCode: Byte;
begin
  if CheckBox.Visible then begin
    if CheckBox.Checked or not ComboBox.Visible then Result:=$F0+Ord(CheckBox.Checked) else Result:=ComboBox.ItemIndex; 
  end else
    if ComboBox.Visible then Result:=ComboBox.ItemIndex else Result:=$FF;
end; {VarCode}

{
* Etymologies that could/shoud be covered: telmà. fragmà. natlà. oàs. melàs. selà. disfàk.
  + lemàzh. flàzh.(contamination) klàgh.
* Dictionary folder!

V 6.x:
* Hellenic (UpdateWord, Greek.pas incl. connotations)
* Bugs

V 7.x?:
* Phonologie.odt! Etymologie.odt!
* Loan translations
* Taboo: Semantic shift of word B because word A was tabooed
* Vrddhi (affixes popup)
* MakeWordHTML: Troyan pronunciation, incl. stress
* EHell (+Koi): deponent verbs (-mai)
* Appositional compounds

* CharIds, ShortCuts, GetStress/Diæresis
  - Volg
  # Elb
  + Brug

* Sound shifts: Phonotaktik, Syllabification, AccentWarn!
    DOPPELBÖDIGE SHIFTS (vgl. Troy)
    Soundshifts, die häufigen Semshifts entsprechen:
      whole for part selten im Lexikon, häufig in Diktion
      container for contained vice versa ebenso
      effect for cause, result for purpose > v.v.
      material for object >> v.v.
      concrete for abstract > v.v. (p 113)
      objective for subjective ~ v.v. (e.g. pitiful)
  - OLem   > Volg
  # PrWald > Eth
  # PrWald > Elb
  o PIE    > PrCelt
  o PrCelt > Besk
  + PIE    > Brug

* Loanwords: Phonotaktik, Syllabification, AccentWarn, cave morphology!
  + Brug   > ModLem
  # Eth    > ModLem
  # Elb    > LMLem (Stress!)
  o PrCelt > MLem
  o Besk   > NLem
  - Volg   > NLem

V 8.x:
* Loanwords mit non-lemurischen Zielen (23):
  - Cave morphology!
  - Phonotaktik, Syllabification, AccentWarn!
  - Stress/Diæresis: OLem,PrWald > EHell; LMLem,Elb > Koi; Eth > NTroy; OLem,EHell > PrWald; ETC!
}

end.


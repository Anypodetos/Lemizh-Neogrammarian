procedure PIEtoEHell;
const A: array[0..45] of Byte = (4, 5, 0, 1, 18, 19, 33, 8, 32, 30, 14, 15, 16, 17, 25, 26, 12, 13, 27, 27, 34, 34, 5, 4, 1, 0, 19, 18, 20, 2, 21,
  28, 3, 29, 10, 6, 11, 10, 6, 11, 22, 23, 24, 4, 9, 31);
var i, s: Integer;                                              
    grass: array of Integer;
begin                                             
  PIEStem(lEHell);
  PIEChanges(lEHell);                              /// accent? (-mi mostly unaccented)
  s:=100000;                                       
  Ending[2]:=Word(-1);
  for i:=0 to WordLen[1]-1 do begin                /// h2r°tk-os > arktos oder r°ktos?
    case Words[1,i] of
      6: if Words[1,i-1]>5 then Add(2, 33) else Add(2, 8);
      7: begin
        Add(2, 8);
        if Words[1,i-1]<=5 then SetDia(2, WordLen[2]-1, False);
      end;
      8: if Words[1,i-1] in [34, 37] then Add(2, 22) else if Words[1,i-1]>5 then Add(2, 32) else Add(2, 30);
      9: begin
        Add(2, 30);
        if Words[1,i-1]<=5 then SetDia(2, WordLen[2]-1, False);
      end;
      18: if (i=WordLen[1]-1) or (Words[1,i-1] in [6, 8, 10, 12, 14, 16, 18, 20, 28..42]) or (Words[1,i+1] in [6, 8, 10, 12, 14, 16, 18, 20, 28..42, 46..58]) then begin
       { if (Words[1,i-1] in [6, 8, 10, 12, 14, 16]) then Insert(2, WordLen[2]-1, 27) else} Add(2, 27);
      end else Add(2, 7);                                               /// huh?
      22, 24, 26: if (i=0) and (Words[1,1] in [6, 8, 10, 12, 14, 16, 18, 20, 28..42]) then Add(2, A[Words[1,i]]-1) else if WordsB[2,1] in [13, 15, 17, 26] then begin
        WordsB[2,1]:=WordsB[2,1]-1;
        Add(2, A[Words[1,i]]);
      end else RemarksBox.Items.AddObject(MCh(lPIE, Words[1,i])+'-loss|(Internal late PIE shift)', Pointer(clWindowText));
      30, 33, 36, 39, 42: Add(2, A[Words[1,i]-2*Ord(Words[1,i+1] in [18..21])]);
      34, 37: if Words[1,i+1]=8 then Add(2, 22) else Add(2, A[Words[1,i]]);
      46, 49, 52, 55, 58: Add(2, A[Words[1,i]-16-2*Ord(Words[1,i+1] in [18..21])]);
      else Add(2, A[Words[1,i]]);
    end;
    if GetStress(1, i, stIs1)=stIs1 then s:=WordLen[2]-1;
    if Ending[1]=i then Ending[2]:=WordLen[2]-1;
    if Words[1,i] in [19, 21] then RemarksBox.Items.AddObject(MCh(lPIE, Words[1,i])+': forbidden letter!',  Pointer(clRed));
  end;
  if s<100000 then
    if GetStress(2, s, stIs1)>stCant then begin
      SetStress(2, s, stIs1, False);
      RemarksBox.Items.AddObject('Or 1st mora stressed?', Pointer(clRed));      /// Betonung auf 1./2. Mora?   stIs1 = 2nd mora!
    end else SetStress(2, s, stIs2, False);
  if Words[2,0]=33 then Insert(2, 0, 3);
  Anticipatory(lEHell, 2, [2, 3, 6, 23, 34], [20, 28, 10, 22, 27, 11, 21, 24, 29], [caseB, caseB, caseB, caseB, caseW, caseB, caseB, caseB, caseB]);
  if Ending[0]<>WordLen[0] then
    if WordsB[2,1] in [14, 15] then WordsB[2,1]:=WordsB[2,1]+2 else if WordsB[2,1] in [2, 3, 6, 10, 11, 20..24, 28, 29] then begin
      RemarksBox.Items.AddObject('Loss of final plosive '+MCh(lEHell, WordsB[2,1])+'|'+Existence(False, caseB+Ord(WordsB[2,1] in [10, 11, 20..22, 24, 28, 29])), Pointer(clWindowText));
      Delete(2, WordLen[2]-1);
    end;
  for i:=0 to WordLen[2]-1 do if Words[2,i] in [7, 11, 21, 24, 29] then begin
    SetLength(grass, Length(grass)+1);
    grass[Length(grass)-1]:=i;
  end;
  for i:=Length(grass)-1 downto 1 do begin
    RemarksBox.Items.AddObject('Grassmann’s law: '+MCh(lEHell, Words[2, grass[i-1]])+'...'+MCh(lEHell, Words[2, grass[i]])+' dissimilates|'+AspirationChange(False, caseP), Pointer(clWindowText));
    if Words[2, grass[i]]=7 then Delete(2, grass[i]) else if Words[2, grass[i-1]]=7 then Delete(2, grass[i-1])
      else Words[2, grass[i-1]]:=Words[2, grass[i-1]]-1-Ord(Words[2, grass[i-1]]=24);
  end;
  RemarksBox.Items.AddObject('Proto-Indo-European > South Hellenic not finished yet!', Pointer(clRed));
end; {PIEtoEHell}

procedure EHellChanges;
const Vowels: set of Byte = [0, 1, 4, 5, 8, 9, 18, 19, 30, 31, 32, 33, 13, 15, 17, 26];
var i: Integer;
begin
  for i:=0 to WordLen[0]-1 do begin
    case Words[0,i] of
      8, 33, 30, 32: if not (Words[0,i-1] in Vowels+[255]) and (Words[0,i+1] in Vowels+[255]) then Add(1, Words[0,i]) else    
        Add(1, Words[0,i]+(2+23*Ord(Words[0,i] in [8, 33]))*(Ord(Words[0,i] in [8, 30])+                                 /// sniqhos > snjqhos > mphos ??
        Ord((Words[0,i+1] in Vowels{+[27] sonst ausa, amusa falsch!///}) or (Words[0,i-1] in [14, 16, 18, 26]))-1));
      34: Add(1, 27);
      else Add(1, Words[0,i]);
    end;
    SetStress(1, WordLen[1]-1, GetStress(0, i, stAny), False);
    if GetDia(0, i)=diaYes then SetDia(1, WordLen[1]-1, False);
    if Ending[0]=i then Ending[1]:=WordLen[1]-1;
  end;
  if Ending[0]=WordLen[0] then Ending[1]:=WordLen[1];
  if WordsB[1,1] in [14, 15] then WordsB[1,1]:=WordsB[1,1]+2;
  CheckBox.Caption:=CheckBoxCaptions[3];
  CheckBox.Hint:=CheckBoxHints[3];
  CheckBox.Visible:=((Words[1,0]=32) and (Words[1,1] in Vowels)) or ((Words[1,0]=3) and (Words[1,1]=33) and (Words[1,2] in Vowels));
end; {EHellChanges}

procedure EHellToOLem;
const A: array[0..33] of Byte = (0, 0, 20, 21, 4, 31, 22, 29, 5, 32, 25, 25, 30, 30, 26, 0, 27, 0, 2, 2, 23, 23, 25, 22, 25, 28, 28, 16, 24, 24, 3, 3, 8, 12);
var i: Integer;
begin
  EHellChanges;
  for i:=0 to Min(WordLen[1], Ending[1])-1 do begin
    if (Words[1,i] in [0, 1, 4, 5]) and (Words[1,i+1] in [8, 30]) then begin
      if Words[1,i+1]=8 then Add(2, 4) else if Words[1,i] in [0, 1] then Add(2, 2) else Add(2, 6);
    end else begin
      Add(2, A[Words[1,i]]);
      case Words[1,i] of
        3: if CheckBox.Visible and CheckBox.Checked and (i=0) and (Words[1,1]=33) then Words[2,0]:=29;
        22..24: if not (Words[1,i+1] in [2, 3, 6, 7, 10, 11, 20..24, 28, 29]) then Add(2, 8);
        13, 26: Insert(2, WordLen[2]-1, 0);
        15, 17: if Words[1,i+1] in [0, 1, 4, 5, 8, 9, 18, 19, 30, 31] then Add(2, A[Words[1,i]-1]);
        8: if Words[1,i-1] in [18, 19] then WordsB[2,1]:=3;
        30: if Words[1,i-1] in [4, 5]  then WordsB[2,1]:=7;
        27: if Words[1,i+1] in [2, 3, 6, 23] then WordsB[2,1]:=10 else
          if (Words[1,i-1] in [12, 14, 16, 25, 32, 33]) or (Words[1,i+1] in [12, 14, 16, 25, 32, 33]) then Delete(2, WordLen[2]-1);
        32: if (Words[1,i-1]=27) or (Words[1,i+1]=27) then WordsB[2,1]:=14;
        33: if CheckBox.Visible and CheckBox.Checked and (i=1) and (Words[1,0]=3) then Delete(2, 1) else if (Words[1,i-1]=27) or (Words[1,i+1]=27) then
          WordsB[2,1]:=18;
      end;
    end;
  end;
  if Ending[1]<Word(-1) then Ending[2]:=WordLen[2];
  Anticipatory(lOLem, 2, [22, 8], [25], [caseB, caseW]);
end; {EHellToOLem}

procedure EHellToKoine;
procedure Lengthen(p: Integer; ElChr: Byte; AddStr: string);
  const EHellType: array[0..34] of TCase = (caseA, caseA, caseB, caseB, caseE, caseE, caseB, caseF, caseI, caseI, caseP, caseP, caseL, caseL, caseN, caseN, caseN, caseN,
    caseO, caseO, caseP, caseP, caseP, caseB, caseP, caseL, caseL, caseF, caseP, caseP, caseU, caseU, caseW, caseW, caseW);
        KoiType: array[0..27] of TCase = (caseA, caseA, caseB, caseB, caseB, caseE, 255{zeta}, caseE, caseF, caseI, caseI, caseP, caseL, caseN, caseN, 255{xi}, caseO, caseP,
          caseL, caseF, caseP, caseUE, caseUE, caseF, caseF, 255{psi}, caseO, caseF);
  var comp: Boolean;
      conn: string;
  begin
    comp:=(WordsB[2,p] in [0, 5, 9, 16, 21]) and not (WordsB[2,p+1] in [0, 5, 9, 16, 21]);
    if comp then conn:=TypeChange(True, EHellType[ElChr], KoiType[WordsB[2,p]]) else conn:=Existence(False, EHellType[ElChr]);
    RemarksBox.Items.AddObject('Elimination of '+MCh(lEHell, ElChr)+AddStr+Copy(' with comp. lengthening of '+MCh(lKoi, WordsB[2,p]), 1, 100*Ord(comp))+'|'+conn, Pointer(clWindowText));
    if comp then if WordsB[2,p] in [0, 9, 21] then WordsB[2,p]:=WordsB[2,p]+1 else Insert(2, WordLen[2]-p+1, WordsB[2,p]+4+Ord(WordsB[2,p]=16));       /// EHell háls > he:s ??
  end;                                                                                                                                                 /// leu-on sollte > leo:n sein (warum "contraction of e+i??)
const A: array[0..33] of Byte = (0, 1, 2, 4, 5, 7, 3, 0{h}, 0, 10, 11, 24, 12, 0{silb.l}, 13, 0, 14, 0, 16, 26, 17, 23, 102, 101, 103, 18,
       0{silb.r}, 19{s}, 20, 8, 21, 22, 0, 0);
      Stops: array[1..3, 1..3] of Byte = ((2, 4, 0), (17, 20, 0), (23, 8, 101));
      Vowels: set of Byte = [0, 1, 4, 5, 8, 9, 13, 15, 17, 18, 19, 26, 30, 31];
var i, j: Integer;
    s: TStress;
begin
  EHellChanges;                                                                           /// nouns -> -(o)s, -on, -e:/a:, -a, consonantal: strak[p,t]-s muss Hyphen eliminieren!
  for i:=0 to WordLen[1]-1 do begin
    if (Words[1,i]=27) and not ((i=WordLen[1]-1) or (Words[1,i-1] in [2, 3, 6, 10, 11, 20..24, 28, 29]) or (Words[1,i+1] in [2, 3, 6, 10, 11, 20..24, 28, 29]))
      then Words[1,i]:=7;
    case Words[1,i] of
      3: if Words[1,i+1]=29 then Add(2, 19) else if Words[1,i-1]=27 then WordsB[2,1]:=6 else Add(2, 4);
      22..24: begin
        if (Words[1,i+1] in [4, 5]) or ((Words[1,i]=22) and (Words[1,i+1] in [8, 9])) then j:=2 else if (Words[1,i]=24) and (Words[1,i+1] in [14, 16])
          then j:=3 else j:=1;
        Add(2, Stops[A[Words[1,i]]-100, j]);
      end;
      7, 32: if i>0 then begin                  /// nú > n ??
        if Words[1,i-1] in [12..17, 25, 26, 32] then Lengthen(2, Words[0,i], '')                    {Konsonantengruppen zwischen Vokalen; h=s/h:}
          else if Words[1,i+1] in [13..18, 25, 26, 32] then Lengthen(1, Words[0,i], '')             {mit komp.length: hw  R+h/w  h+R}
          else if (Words[1,i]=32) and (Words[1,i-1]=28) then Add(2, 20)
          else if (Words[1,i]=32) and (Words[1,i-1] in [0, 4, 18]) then Add(2, 100)
          else RemarksBox.Items.AddObject('Elimination of '+MCh(lEHell, Words[0,i])+'|'+Existence(False, caseW+Ord(Words[0,i]=7)), Pointer(clWindowText)); {eliminieren: h  wj>i  **jw>i}
      end else if ((Words[1,0]=7) or (CheckBox.Checked and CheckBox.Visible)) and (Words[1,1] in Vowels+[32]) then
        Add(2, 27) else RemarksBox.Items.AddObject('Elimination of initial '+MCh(lEHell, Words[0,0])+'|'+Existence(False, caseF-Ord(Words[0,0]=32)), Pointer(clWindowText));
      8: if not (Words[1,i-1] in [1, 5, 19]) or (i=WordLen[1]-1) then Add(2, 9);
      27: if (i=WordLen[1]-1) and (Words[1,i-1] in [12, 14, 16, 25]) then begin
        WordsB[2,1]:=19;
        Lengthen(2, Words[0,i-1], ' before final '+MCh(lEHell, 27));
      end else if Words[1,i+1]<>29 then Add(2, A[Words[1,i]]);
      33: if Words[1,i+1] in Vowels then begin
        if i>0 then case Words[1,i-1] of                          
          0, 1, 4, 5, 8, 9, 18, 19, 30, 31: Add(2, 100);
          2, 20, 21: begin WordsB[2,1]:=17; Add(2, 20); end;
          3, 6, 23: WordsB[2,1]:=6+21*Ord(CheckBox.Checked and CheckBox.Visible and (Words[1,i-1]=3));
          10, 11: begin WordsB[2,1]:=20; if i>1 then Add(2, 20); end;
          12, 13: begin
            Add(2, 12);
            RemarksBox.Items.AddObject(MCh(lEHell, 33)+' doubles '+MCh(lEHell, 12)+'|'+TypeChange(True, caseW, caseL), Pointer(clWindowText));
          end;
          14..17, 25, 26: begin
            Insert(2, WordLen[2]-1, 9);
            if Words[1,i-1] in [14, 15] then RemarksBox.Items.AddObject(MCh(lEHell, Words[0,i-1])+MCh(lEHell, 33)+': outcome unknown!', Pointer(clRed))   ///  mya > ?
              else RemarksBox.Items.AddObject(MCh(lEHell, Words[0,i-1])+MCh(lEHell, 33)+' metathesises|'+Metathesis(IfThen(Words[0,i-1]<=17, caseN, caseL), caseW), Pointer(clWindowText));
          end;
          22, 24, 28, 29: begin WordsB[2,1]:=19;
            RemarksBox.Items.AddObject('Other possibility: '+MCh(lEHell, Words[0,i-1])+MCh(lEHell, Words[0,i])+' > '+MCh(lKoi, 20)+MCh(lKoi, 20), Pointer(clRed));
          end;
          32: Add(2, 9);
        end;
      end else if Words[1,i+1]=32 then Add(2, 9);
      else Add(2, A[Words[1,i]]);
    end;
    SetStress(2, WordLen[2]-1, GetStress(1, i, stAny), False);
    if (Words[1,i] in [13, 26]) or ((Words[1,i] in [15, 17]) and (Words[1,i+1] in Vowels+[33])) then begin
      Add(2, A[Words[1,i]-1]);
      RemarksBox.Items.AddObject('Other possibility: '+MCh(lEHell, Words[1,i])+' > '+MCh(lKoi, A[Words[1,i]-1])+MCh(lKoi, 0), Pointer(clRed));
    end;
    SetStress(2, WordLen[2]-1, GetStress(1, i, stAny), False);
    if GetDia(1, i)=diaYes then SetDia(2, WordLen[2]-1, False);
    if Ending[1]=i then Ending[2]:=WordLen[2]-1;
  end;
  if Ending[1]=WordLen[1] then Ending[2]:=WordLen[2];
  Anticipatory(lKoi, 2, [2, 4, 3, 2, 4, 3], [17, 20, 11, 23, 8, 24], [caseB, caseB, caseB, caseB, caseB, caseB]); {vor ng>gg!}
  for i:=WordLen[2]-1 downto 0 do case Words[2,i] of
    0, 5, 16: if (Words[2,i+1] in [0, 5, 7, 16, 26]) or ((Words[2,i]=5) and (Words[2,i+1]=9)) then begin
      RemarksBox.Items.AddObject('Contraction of '+MCh(lKoi, Words[2,i])+'+'+MCh(lKoi, Words[2,i+1])
        +Copy(MCh(lKoi, Words[2,i+2]), 1, 10*Ord(Words[2,i+2] in [9, 21]))+'|'+Existence(False, caseA), Pointer(clWindowText)); /// Existence/TYPE CHANGE: which vowel?
      s:=GetStress(2, i+1, stAny);
      if ((Words[2,i] in [5, 16]) and (Words[2,i+1]=16)) or ((Words[2,i]=16) and (Words[2,i+1]=5)) then begin
        Words[2,i]:=16;
        if Words[2,i+2] in [9, 21] then Delete(2, i+1) else Words[2,i+1]:=21;
      end else begin
        if (Words[2,i]=16) or (Words[2,i+1] in [16, 26]) then Words[2,i]:=26 else Words[2,i]:=1+6*Ord(Words[2,i]=5);
        if Words[2,i+2] in [9, 21] then Delete(2, i+2);
        Delete(2, i+1);
      end;
      SetStress(2, i, s, False);
    end else if Words[2,i+1]=100 then Delete(2, i+1);
    1, 7: if (Words[2,i]=7) or not (Words[2,i-1] in [5, 9, 10, 18, 100]) then begin
      if Words[2,i+1] in [0, 16, 26, 7] then begin
        if Words[2,i+1]=7 then Delete(2, i) else Words[2,i]:=5;
        if Words[2,i+1] in [0, 16] then Words[2,i+1]:=Words[2,i+1]+1+9*Ord(Words[2,i+1]=16);
      end else Words[2,i]:=7;
    end;
    4, 8: if Words[2,i+1] in [{4,///} 20] then Words[2,i]:=19 else if (Words[2,i]=8) and (Words[2, i-1] in [17, 11]) then Words[2,i-1]:=25-Words[2,i-1] div 6;
    13, 14: if Words[2,i+1]=18 then Insert(2, i+1, 2*Words[2,i]-24) else
      if Words[2,i-1] in [2, 17, 23] then Words[2,i-1]:=13 else if Words[2,i-1] in [11, 24] then Words[2,i-1]:=3 else if Words[2,i]=14 then
        if Words[2,i+1] in [2, 17, 23] then Words[2,i]:=13 else if Words[2,i+1] in [3, 11, 24] then Words[2,i]:=3;
    19: if Words[2,i-1] in [2, 3, 4, 8, 11, 17, 19, 20, 23, 24] then begin
      if Words[2,i-1] in [2, 17, 23] then Words[2,i]:=25 else if Words[2, i-1] in [3, 11, 24] then Words[2,i]:=15;
      Delete(2, i-1);
    end;
    101: Words[2,i]:=23;
  end;
  j:=-1;
  for i:=0 to WordLen[2]-1 do begin
    s:=GetStress(2, i, stIs1);
    if GetStress(2, i, stIs2)=stIs2 then j:=-2 else if (s=stCan) and (j=-1) then j:=i else if s in [stCan, stIs1] then j:=-2;
  end;
  if j>-1 then begin
    SetStress(2, j, stIs1, False);
    if GetStress(2, j, stIs2)=stCan then RemarksBox.Items.AddObject('Or 1st mora stressed?', Pointer(clRed));     /// Betonung auf 1./2. Mora?
  end;
  RemarksBox.Items.AddObject('South Hellenic > Koine not finished yet!', Pointer(clRed));
end; {EHellToKoine}

procedure KoineToLem(lang: Byte);
const AKL: array[0..27] of Byte = (0, 0, 20, 18, 19, 1, 19, 1, 16, 3, 3, 21, 28, 25, 24, 21, 4, 23, 26, 15, 22, 7, 7, 17, 13, 23, 4, 13);
var i, s, c: Integer;
    b: Boolean;
begin
  s:=100000;
  for i:=0 to Min(WordLen[0], Ending[0])-1 do begin
    if not ((Words[0,i] in [9, 21]) and (Words[0,i-1] in [0, 1, 5, 7, 16, 21, 26])) and not ((Words[0,i]=27) and not (Words[0,i+1] in [0, 1, 5, 7, 9, 10, 16, 21, 22, 26, 255]))
      or (GetDia(0, i)=diaYes) then Add(2, AKL[Words[0,i]]);
    case Words[0,i] of
      3: if Words[0,i+1] in [3, 11, 15, 24] then WordsB[2,1]:=24;
      6: Add(2, 10);
      15, 25: Add(2, 15);
      19: if Words[0,i+1] in [2..4] then WordsB[2,1]:=10;
      21: if Words[0, i-1]=16 then WordsB[2,1]:=6;
    end;
    if GetStress(0, i, stAny)>=stIs1 then s:=WordLen[2]-1;
  end;
  If (Ending[0]<Word(-1)) or CheckBox.Visible and CheckBox.Checked then begin
    if lang<lModLem then Ending[2]:=WordLen[2];
    if (lang>lLMLem) or (((Ending[0]=WordLen[0]-1) and (WordsB[0,1]=26)) or ((Ending[0]=WordLen[0]-2) and (WordsB[0,2]=13) and (WordsB[0,1]=9))) then begin
      if WordsB[0,1] in [15, 25] then Delete(2, WordLen[2]-1);
      Add(2, 0);             {verb, NLem, ModLem}
    end else if (Ending[0]<WordLen[0]) or CheckBox.Visible and CheckBox.Checked then begin
      if WordsB[0,1] in [15, 25] then Delete(2, WordLen[2]-1);
      Add(2, 2); Add(2, 26); {MLem noun}
    end;
  end;
  case lang of
    lLMLem: begin
      b:=False;
      for i:=s+1 to WordLen[2]-1 do if GetStress(2, i, stIs1)>stCant then b:=True;
      if b then SetStress(2, s, stIs1, False);
    end;
    lModLem: begin
      i:=WordLen[2];
      while (i>-1) and (Words[2,i]>7) do Dec(i);
      if i>-1 then Words[2,i]:=0 else Add(2, 0);
      if (CheckBox.Visible and CheckBox.Checked and (Ending[0]<Word(-1))) or ((Ending[0]=WordLen[0]-2) and (WordsB[0,2]=16) and (WordsB[0,1]=19)) then Add(2, 15);
      ModLemPhonotactics;
      SetStress(2, 0, stIs1, False);
    end;
  end;
  if (lang=lModLem) and (Ending[0]=WordLen[0]-1) and (WordsB[0,1]=19) then c:=7 else if Ending[0]=Word(-1) then c:=6+2*Ord(WordsB[0,1] in [15, 25]) else c:=0;
  CheckBox.Visible:=c>0;
  if c>0 then begin
    CheckBox.Caption:=CheckBoxCaptions[c];
    CheckBox.Hint:=CheckBoxHints[c];
  end;
end; {KoineToLem}

procedure KoineToLMLem;
begin
  KoineToLem(lLMLem);
end; {KoineToLMLem}

procedure KoineToNLem;
begin
  KoineToLem(lNLem);
end; {KoineToNLem}

procedure KoineToModLem;
begin
  KoineToLem(lModLem);
end; {KoineToModLem}

const OTrVCase: array[0..32] of TCase = (caseA, caseA, 0, 0, 0, caseE, 0, 0, caseE, 0, caseI, caseI, 0, 0, 0, 0, 0, 0, caseO, 0, 0, 0, 0, 0, 0, caseU, caseU, 0, 0, 0, caseO, 0, 0);

procedure EHellToOTroy;
const A: array[0..33] of Byte = (0, 1, 2, 4, 5, 8, 3, 31, 10, 11, 12, 28, 13, 14, 15, 5, 16, 5, 18, 30, 19, 27, 20, 6, 32, 21, 22, 23, 24, 9, 25, 26, 6, 0);
      HardP: array[2..6] of Byte = (19, 24, 0, 0, 12);
      SoftP: array[10..28] of Byte = (3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 4);
      Vowels = [0, 1, 5, 8, 10, 11, 14, 18, 22, 25, 26, 30];
var i, u: Integer;
begin
  EHellChanges;
  if     (Ending[1]=WordLen[1]-1) and (WordsB[1,1]=19)
      or (Ending[1]=WordLen[1]-2) and (WordsB[1,2]=14) and (WordsB[1,1]=8)
      or (Ending[1]=WordLen[1]-3) and (WordsB[1,3]=14) and (WordsB[1,2]=0) and (WordsB[1,1]=8) then begin
    WordLen[1]:=Ending[1];
    Add(1, 0);
    Add(1, 8);
  end;
  for i:=0 to WordLen[1]-1 do begin
    case Words[1,i] of
      1, 5, 9, 19, 31: Add(2, A[Words[1,i]-Ord(i=WordLen[1]-1)]);
      2, 3, 6: if Words[1,i+1] in [21, 29, 11, 24, 23, 7, 27, 2, 3, 6, 10, 20, 22, 28] then begin
        RemarksBox.Items.AddObject(MCh(lOTroy, A[Words[1,i]])+' loses aspiration before '+IfThen(Words[1,i+1] in [23, 2, 3, 6, 10, 20, 22, 28], 'plosive', 'fricative')
          +' '+MCh(lOTroy, A[Words[1,i+1]])+'|'+AspirationChange(True, caseB), Pointer(clWindowText));
        Add(2, HardP[Words[1,i]]);
      end else Add(2, A[Words[1,i]]);
      10, 20, 28: if Words[1,i-1] in [2, 3, 6] then begin
        RemarksBox.Items.AddObject(MCh(lOTroy, A[Words[1,i]])+' receives aspiration from preceding '+MCh(lOTroy, A[Words[1,i-1]])+'|'+AspirationChange(True, caseB), Pointer(clWindowText));  
        Add(2, SoftP[Words[1,i]]);
      end else Add(2, A[Words[1,i]]);
      23: if Words[1,i-1] in [0, 1, 4, 5, 18, 19] then begin
        RemarksBox.Items.AddObject(MCh(lEHell, Words[1,i-1])+MCh(lEHell, Words[1,i])+' forms a diphthong|'+TypeChange(True, caseB, caseU), Pointer(clWindowText));  
        Add(2, 25);
      end else Add(2, 6);
      32: if (i=0) and CheckBox.Visible then Add(2, 6+25*Ord(CheckBox.Checked and CheckBox.Visible)) else Add(2, 6);
      27: if (Words[1,i-1] in [12, 14, 16, 25]) or (Words[1,i+1] in [12, 14, 16, 25, 32]) then begin
        RemarksBox.Items.AddObject('Elimination of '+MCh(lEHell, 27)+IfThen(i>0, ', leaving silent '+MCh(lOTroy, 31))+'|'+Existence(False, caseF), Pointer(clWindowText));   
        if i>0 then Add(2, 31);
      end else Add(2, 23);
      33: if i>0 then case Words[1,i-1] of
        3: if (i=1) and CheckBox.Visible then WordsB[2,1]:=10+21*Ord(CheckBox.Checked and CheckBox.Visible);
        7: WordsB[2,1]:=28;
        10: WordsB[2,1]:=17;
        11, 21, 29: Insert(2, i-1, A[Words[1,i-1]-1]);
        12, 14, 16, 25: if Words[1,i-2] in [0, 4, 8, 18, 30] then WordsB[2,2]:=A[Words[1,i-2]+1];
        15, 17: WordsB[2,2]:=8;
        20, 22, 28: Add(2, A[Words[1,i-1]]);
        24: begin WordsB[2,1]:=20; Add(2, 20); end;
        27: Delete(2, WordLen[2]-1);
      end;
      else Add(2, A[Words[1,i]]);
    end;
    if (Words[1,i] in [15, 17]) and (Words[1,i+1] in [0, 1, 4, 5, 8, 9, 18, 19, 30, 31, 13, 15, 17, 26, 33]) then Add(2, A[Words[1,i]-1]);
    if Ending[1]=i then Ending[2]:=WordLen[2]-1;
  end;
  if Ending[1]=WordLen[1] then Ending[2]:=WordLen[2];
  if (Words[2,0]=10) and CheckBox.Visible then begin
    RemarksBox.Items.AddObject(MCh(lEHell, 33)+MCh(lOTroy, Words[2,1])+' metathesises to '+MCh(lOTroy, Words[2,1])+MCh(lOTroy, 10)+'|'+Metathesis(caseW, OTrVCase[Words[2,1]]),
      Pointer(clWindowText));
    Delete(2, 0);
    if not (Words[2,0] in [6, 25]) then Insert(2, 1, 10);
  end;
  for i:=WordLen[2]-1 downto 0 do case Words[2,i] of
    0, 5, 18: if Words[2,i+1] in [0, 1, 5, 8, 11, 18, 26, 30] then begin
      RemarksBox.Items.AddObject('Contraction of '+MCh(lOTroy, Words[2,i])+'+'+MCh(lOTroy, Words[2,i+1])+Copy(MCh(lOTroy, Words[2,i+2]), 1, 10*Ord(Words[2,i+2] in [10, 25]))
        , Pointer(clWindowText));  /// connot: contraction of a e o + vowel except short i u:   o > ui > e <> a  (?)
      if Words[2,i]=18 then Words[2,i+1]:=18 else if (Words[2,i]=0) and not (Words[2,i+1] in [18, 30]) then Words[2,i]:=0;
      if not (Words[2,i+2] in [10, 25]) then case Words[2,i+1] of
        0: Words[2,i+1]:=1;
        5: Words[2,i+1]:=8;
        18: Words[2,i+1]:=30;
      end;
      Delete(2, i);
    end;
    3, 12: if Words[2,i+1] in [10, 11] then Words[2,i]:=Words[2,i] div 3 *5 +4;
    20: if Words[2,i+1] in [10, 11] then begin
      Words[2,i]:=24;
      if Words[2,i-1]<>13 then Insert(2, i, 24);
    end;
    28, 31: if Words[2,i+1] in [25, 26] then begin
      Words[2,i]:=32;
      Words[2,i+1]:=Words[2,i+1]-15;
      Insert(2, i+1, 31);
    end else if (Words[2,i-1] in Vowels-[14, 22]) and (Words[2,i]=31) and (Words[2,i+1] in [10, 11]) then Words[2,i]:=28;
    6: if not (Words[2,i+1] in [6, 31]) then begin
      if Words[2,i-1] in [3, 12, 28, 31] then Words[2,i]:=31;
      case Words[2,i-1] of
        0, 1, 5, 8, 18, 30: begin Words[2,i]:=25; Insert(2, i+1, 31); end;
        2, 3, 19, 27: Words[2,i-1]:=6;
        4: Words[2,i-1]:=24;
        6, 20, 25, 26, 32: Delete(2, i);
        9: begin Words[2,i-1]:=23; Words[2,i]:=23; end;
        12: Words[2,i-1]:=20;
        28, 31: Words[2,i-1]:=32;
      end;
    end;
    10, 25: if Words[2,i-1] in [1, 8, 30] then Words[2,i-1]:=5*Ord(Words[2,i-1]=8)+18*Ord(Words[2,i-1]=30);
    14, 22: if (Words[2,i-1] in Vowels) or (Words[2,i+1] in Vowels) then Words[2,i]:=Words[2,i]-1;
    16: if Words[2,i+1] in [2, 6, 19, 27, 29] then Words[2,i]:=15 else if Words[2,i+1] in [3, 12, 17, 20, 28, 32] then Words[2,i]:=3;
    23: if (Words[2,i-1] in [12, 19, 24]) then begin
      Words[2,i-1]:=7+10*Ord(Words[2,i-1]=12)+22*Ord(Words[2,i-1]=19);
      Delete(2, i);
    end else if Words[2,i+1]=4 then begin
      Words[2,i+1]:=7;
      Delete(2, i);
    end;
  end;
  u:=OTroyVFromLast(2, 1);
  if (Words[2,u-2] in [14, 22]) and not (Words[2,u-1] in [7, 17, 29]+Vowels) then begin
    RemarksBox.Items.AddObject('Syllabic liquid '+MCh(lOTroy, Words[2,u-2])+' “diphthongises” in penultimate|'+Existence(True, caseA), Pointer(clWindowText));
    Words[2,u-2]:=Words[2,u-2]-1;
    Insert(2, u-2, 0);
    Inc(u);
  end;
  for i:=WordLen[2]-1 downto 0 do if (Words[2,i]=31) and ((u<>i+1) or (Words[2,i-1] in [7, 17, 29]) or not (Words[2,i-2] in Vowels-[14, 22])) then  /// check
    if not (Words[2,i-1] in Vowels+[255]) then Delete(2, i);/// else if not (Words[2,i+1] in Vowels) then Words[2,i]:=28;
  if Ending[2]>=WordLen[2] then Ending[2]:=Word(-1);
end; {EHellToOTroy}

procedure OTroyToMLem;
const A: array[0..32] of Byte = (0, 0, 12, 8, 11, 1, 12, 19, 1, 16, 3, 3, 18, 28, 28, 25, 24, 18, 4, 20, 21, 26, 26, 15, 19, 6, 6, 17, 13, 20, 4, 13, 13);
var i: Integer;
begin
  OTroyDiph(0, True);
  for i:=0 to Min(WordLen[1], Ending[1])-1 do begin
    Add(2, A[Words[1,i]]);
    case Words[1,i] of
       1, 8, 11, 30: Add(2, A[Words[1,i]]);          
       3: if Words[1,i+1] in [3, 12, 17, 20, 28, 32] then WordsB[2,1]:=24;
       6: if (Words[1,i-1]=6) or (Words[1,i+1]=6) then WordsB[2,1]:=17;
       7, 17, 29: Add(2, 10);
       12, 19, 24: if Words[1,i-1] in [3, 15, 16, Words[1,i]] then WordsB[2,1]:=WordsB[2,1]+3 else if Words[1,i]=Words[1,i+1] then WordCut(2, 1);
       14, 22: Insert(2, i, 2);
       23: if (Words[1,i+1] in [2..4, 7, 17, 29]) or ((Words[1,i+1] in [12, 19, 24]) and not (Words[1,i+1]=Words[1,i+2])) then WordsB[2,1]:=10;
       31: if not (Words[1,i-1] in [0, 1, 5, 8, 10, 11, 14, 18, 22, 25, 26, 30]) then WordCut(2, 1);
       32: if Words[1,i+1]<>32 then Add(2, 12);
    end;
  end;
  Ending[2]:=WordLen[2];
  for i:=0 to WordLen[2]-2 do case Words[2,i] of
    0: if Words[2,i+1]=3 then Words[2,i+1]:=2 else if Words[2,i+1]=6 then Words[2,i]:=4;
    1: if Words[2,i+1]=0 then Words[2,i+1]:=3 else if Words[2,i+1]=6 then begin
      Words[2,i]:=5;
      Words[2,i+1]:=7;
    end;
    4: if Words[2,i+1]=3 then Words[2,i+1]:=6;
  end;
  if (Ending[0]=WordLen[0]-2) and (WordsB[0,2]=0) and (WordsB[0,1]=10) then Add(2, 0) else begin
    Add(2, 2);
    Add(2, 26);
  end;
end; {OTroyToMLem}

procedure OToNTroy;
const A: array[0..32] of Byte = (0, 0, 1, 2, 3, 4, 1, 5, 4, 7, 8, 8, 9, 10, 10, 11, 12, 13, 14, 15, 13, 16, 16, 17, 18, 19, 19, 20, 21, 22, 23, 24, 24);
      OVowels = [0, 1, 5, 8, 10, 11, 18, 25, 26, 30];
      O: array[0..3, 0..55] of ShortInt = ((0, 1, 1, 1, 0, 0, 0,-1, 0, 0, 1, 0, 0, 0, 0, 0,-1,-1, 0, 0,-1,-1, 0, 0, 1, 0,   0,  -1,-1,-1, 1, 1, 1,  -1, 1,   1, 1, 1,-1,-1,-1,  -1,-1,-1, 1, 1, 1,   0, 0, 0, 0, 0, 0, 0, 0, 0),
                                           (0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 1, 0, 0, 0,-1, 0,-1, 0, 0, 0,   1,   1, 0, 0,-1, 0, 0,  -1,-1,  -1, 1, 1,-1, 1, 1,   1,-1,-1, 1,-1,-1,   0, 0, 0,-1,-1, 1, 1,-1,-1),
                                           (0, 0, 0, 1, 0,-1, 0,-1, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0,   1,   0, 1, 0, 0,-1, 0,  -1,-1,   1,-1, 1, 1,-1, 1,  -1, 1,-1,-1, 1,-1,   1,-1,-1, 0, 0, 0,-1,-1, 1),
                                           (0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1,-1, 0, 0, 1, 0, 0, 0, 0,-1, 0, 0, 0, 0,   0,   0, 0, 1, 0, 0,-1,  -1,-1,   1, 1,-1, 1, 1,-1,  -1,-1, 1,-1,-1, 1,  -1,-1, 1, 1,-1,-1, 0, 0, 0));
      NVowels = [0, 4, 6, 8, 14, 19, 23];
      C1: array[27..55] of Byte = (22, 5, 13, 22,  5, 13,   10, 16,   10, 10, 10, 16, 16, 16,    10, 10, 10, 16, 16, 16,    11, 11, 11, 12, 12, 12, 26, 26, 26);
      C2: array[27..55] of Byte = (22, 5, 13, 25, 25, 25,   17, 17,   22,  5, 13, 22,  5, 13,    22,  5, 13, 22,  5, 13,    22, 17, 25,  5, 17, 25, 13, 17, 25);
      CSa: array[0..55] of TCase = (0, caseB, caseB, caseB, 0, caseBW, 0, caseF, 0, caseP, caseL, caseN, caseN, caseBW, 0, caseP, caseL, caseF, caseP, 0, caseF, caseF, caseBW, 0, caseF, caseF, caseN,
                                      caseP, caseP, caseP, caseP, caseP, caseP,   caseL, caseL,   caseL, caseL, caseL, caseL, caseL, caseL,   caseL, caseL, caseL, caseL, caseL, caseL,   caseN, caseN, caseN, caseN, caseN, caseN, caseN, caseN, caseN);
      CSb: array [27..55] of TCase = (caseP, caseP, caseP, caseF, caseF, caseF,   caseF, caseF,   caseP, caseP, caseP, caseP, caseP, caseP,   caseP, caseP, caseP, caseP, caseP, caseP,   caseP, caseF, caseF, caseP, caseF, caseF, caseP, caseF, caseF);
  function MakeQ(val: Integer): string;
  const C: array[1..4] of string = ('', '%1227', '', '½');
        E: array[0..3] of Char = '1ijk';
  var i: Integer;
  begin
    Result:=C[Abs(O[0,val])+Abs(O[1,val])+Abs(O[2,val])+Abs(O[3,val])]+'(';
    for i:=0 to 3 do if O[i,val]<>0 then Result:=Result+Copy(Chr(44-Sign(O[i,val])), 1, Ord((O[i,val]=-1) or (Result[Length(Result)]<>'(')))+E[i];
    Result:=Result+')';
  end; {MakeQ}
 function MChs(val: Integer): string;
  begin
    if val<Low(C1) then Result:=MCh(lNTroy, val) else Result:=MCh(lNTroy, C1[val])+MCh(lNTroy, C2[val]);
    if val in [41..46] then Result:=Result+MCh(lNTroy, 17);
  end; {MChs}
var NoC, b, afterstress: Boolean;
    i, j, sk1, sk3, stressed, stressnew, l, inci, f: Integer;
    st1, st2: string;
    acase: array of TCase;
    case2a, case2b, case2c: TCase;
    q, qa: array[0..3] of Real;
begin
  sk1:=OTroyVFromLast(0, 1);
  stressed:=-1; sk3:=-1;
  for i:=sk1-1 downto 0 do if (Words[0,i] in OVowels+[14, 22]) and not ((Words[0,i-1] in [0, 5, 18]) and (Words[0,i] in [10, 25])) then
    if stressed=-1 then stressed:=i else begin
      sk3:=i;
      Break;
    end;
  NoC:=(Words[0,stressed] in [0, 5, 18]) and (Words[0,stressed+1] in [10, 25]);
  j:=Ord((Words[0,sk1-1]=3) and (Words[0,sk1-2]=3))+1;
  if (not (Words[0,sk1-j] in OVowels) and not (Words[0,sk1-j-1] in OVowels)) or (Words[0,sk1-j] in [7, 17, 29]) or (Words[0,sk1] in [1, 8, 11, 26, 30]) then sk1:=-1;
  if Words[0,sk3] in [1, 8, 11, 26, 30] then sk3:=-1;
  stressnew:=-1;
  for i:=0 to WordLen[0]-1 do begin
    if (Words[0,i] in [14, 22]) and not ((i=sk1) or (i=sk3)) then Add(1, 6+17*Ord((Words[0,i]=22) or (Words[0,i-1] in [4, 7, 9, 17, 23, 27..29]))); {syll.r/l}
    if not ((Words[0,i-1] in [0, 5, 18]) and (Words[0,i] in [10, 25])) and (not ((i=sk1) or (i=sk3)) or (Words[0,i] in [14, 22])) then begin
      Add(1, A[Words[0,i]]);
      if (Words[0,i] in [12, 19, 24]) and ((Words[0,i-1]=Words[0,i]) or (Words[0,i+1]=Words[0,i])) then
        WordsB[1,1]:=22*Ord(Words[0,i]=19)+5*Ord(Words[0,i]=24)+13*Ord(Words[0,i]=12);
      if Words[0,i]=3 then if Words[0,i+1] in [3, 12, 17, 20, 28, 32] then WordsB[1,1]:=26 else if Words[0,i-1]=3 then Delete(1, WordLen[1]-1);
      if (Words[0,i]=6) and ((Words[0,i-1]=6) or (Words[0,i+1]=6)) then WordsB[1,1]:=20;
      if i=stressed then stressnew:=WordLen[1]-1;
      if (Words[0,i]=5) and (Words[0,i+1] in [10, 25]) then WordsB[1,1]:=A[Words[0,i+1]];
      if WordsB[1,1]=19 then begin {upsilon>omega}
        b:=False;
        for j:=i+1 to WordLen[0]-1 do if Words[0,j] in OVowels+[14, 22] then begin
          if Words[0,j] in [5, 8, 10, 11] then begin
            WordsB[1,1]:=23;
            RemarksBox.Items.AddObject(MCh(lNTroy, 19)+' > '+MCh(lNTroy, 23)+' in syllable before '+MCh(lOTroy, Words[0,j])+'|'+PosChange(True, caseU, caseO), Pointer(clWindowText));
          end;
          b:=True; Break;
        end;
        if not b then begin
          WordsB[1,1]:=23;
          RemarksBox.Items.AddObject(MCh(lNTroy, 19)+' > '+MCh(lNTroy, 23)+' in final syllable|'+PosChange(True, caseU, caseO), Pointer(clWindowText));
        end;
      end;
      if (Words[0,i]=20) and (Words[0,i-1] in OVowels+[14, 22, 255]) and (Words[0,i+1] in OVowels+[14, 22, 255]) then Add(1, A[Words[0,i]]);
    end else if (i=sk1) or (i=sk3) then RemarksBox.Items.AddObject(IfThen(i=sk1, 'U', 'Antepenu')+'ltimate '+IfThen(not (Words[0,i+1] in OVowels), 'vowel', 'diphthong loses')
      +' '+MCh(lOTroy, Words[0,i])+' '+IfThen(not (Words[0,i+1] in OVowels), 'syncopates')+'|'+Existence(False, OTrVCase[Words[0,i]]), Pointer(clWindowText));
    if (i=sk3) and (Words[0,i+1] in [10, 25]) then Add(1, 8+6*Ord(Words[0,i+1]=25)); {Diph-Synkope3}
    if (i=stressed) and (Words[0,i] in [1, 8, 11, 26, 30]) and not (Words[0,i+1] in OVowels) then begin {Langvokal-c}
      Add(1, 24);
      RemarksBox.Items.AddObject('Long vowel '+MCh(lOTroy, Words[0,i])+' stays a monophthong|(Non-shift)', Pointer(clWindowText));
    end;
    if Ending[0]=i then Ending[1]:=WordLen[1]-1;
  end;
  if sk1>-1 then if Words[0,sk1+1] in [10, 25] then Add(1, 8+6*Ord(Words[0,sk1+1]=25)) {Diph-Synkope1} else Add(1, 6); {stummes eta von Synkope1}
{ ^ MTroy }
  if Ending[1]<WordLen[1] then case Words[1,Ending[1]] of {genitive noun forms}
     0: if (WordLen[1]=Ending[1]+1) and not ((WordsB[0,2]=0) and (WordsB[0,1]=10)) then Add(1, 17);
    14: if (WordLen[1]=Ending[1]+2) and (WordsB[1,1] in [12, 17]) then begin
      WordsB[1,2]:=23;
      WordCut(1, 1);
    end;               /// other genitive-derived nominals in NTroy?
  end;                 /// aun-os > ans? hiq-os[sic] > hixsh? ("ultimate vowel o syncopates")
  for i:=0 to 3 do q[i]:=O[i,24];
  i:=0; st1:=''; st2:=''; l:=0; afterstress:=False;
  while i<=WordLen[1]-1 do if (Words[1,i] in NVowels) or ((Words[1,i-1]=6) and (Words[1,i]=10)) then begin
    Add(2, Words[1,i]);
    Inc(i);
  end else begin
    if l=0 then afterstress:=(stressnew>-1) and (stressnew=i-1);
    f:=Words[1,i];
    for j:=High(C1) downto Low(C1) do if ((Words[1,i]=C1[j]) and (Words[1,i+1]=C2[j]))
      and not ((Words[1,i+1] in [5, 13, 22]) and ((Words[1,i+1]=Words[1,i+2]) or (Words[1,i] in [10..12, 16, 26]))) then f:=j;
    if (f in [35..40]) and (Words[1,i+2]=17) then Inc(f, 6);
    qa[0]:=q[0]*O[0,f] -q[1]*O[1,f] -q[2]*O[2,f] -q[3]*O[3,f];
    qa[1]:=q[0]*O[1,f] +q[1]*O[0,f] +q[2]*O[3,f] -q[3]*O[2,f];
    qa[2]:=q[0]*O[2,f] +q[2]*O[0,f] +q[3]*O[1,f] -q[1]*O[3,f];
    qa[3]:=q[0]*O[3,f] +q[3]*O[0,f] +q[1]*O[2,f] -q[2]*O[1,f];
    for j:=0 to 3 do q[j]:=Sign(qa[j]);
    if Words[1,i]<>24{c} then begin
      st1:=st1+'°'+MChs(f);
      st2:=st2+' × '+MakeQ(f);
      SetLength(acase, Length(acase)+1);
      acase[Length(acase)-1]:=CSa[f];
    end;
    inci:=1+Ord(f>=Low(C1))+Ord(f in [41..46]);
    Inc(l, inci);
    if Words[1,i+inci] in NVowels+[255] then begin
      case2a:=0;  case2b:=0;  case2c:=0;
      for j:=1 to High(O[0]) do if (q[0]=O[0,j]) and (q[1]=O[1,j]) and (q[2]=O[2,j]) and (q[3]=O[3,j]) then begin
        if j<Low(C1) then Add(2, j) else begin
          Add(2, C1[j]);   Add(2, C2[j]);
          if j in [41..46] then Add(2, 17);
        end;
        if (l>1) and (j<Low(C1)) and not (j in [5, 13, 22]) and afterstress and not NoC then Add(2, 24);
        st1:=st1+' = '+MChs(j);
        st2:=st2+' = '+MakeQ(j);
        case2a:=CSa[j];
        if j>=Low(C1) then case2b:=CSb[j];
        if j in [41..46] then case2c:=caseF;
      end;
      if Pos('°', Copy(st1, 2, 1000))>0 then RemarksBox.Items.AddObject(Copy(st1, 2, 1000)+';  '+Copy(st2, 3, 1000)+'|'+n2O(acase, case2a, case2b, case2c), Pointer(clWindowText));
      for j:=0 to 3 do q[j]:=O[j,24];
      st1:=''; st2:=''; l:=0;
      SetLength(acase, 0);
    end;
    Inc(i, inci);
  end;
  if ((Words[2,0] in [10..12, 16, 26]) and not (Words[2,1] in NVowels)) then Insert(2, 0, 6); {sec. syllabic}
  if (WordsB[2,1]=6) and ((not (WordsB[2,2] in NVowels+[255]) and not (WordsB[2,3] in NVowels+[255])) or (WordsB[2,2] in NVowels)) then begin
    Delete(2, WordLen[2]-1);
    if WordsB[2,1]=24 then Delete(2, WordLen[2]-1);
    SetStress(2, 0, stIs1, False);
  end;
  for i:=WordLen[2]-1 downto 0 do if Words[2,i]=26 then begin
    Words[2,i]:=2;
    if not (Words[2,i+1] in [13, 17, 25]) then Insert(2, i, 2);
  end;
end; {OToNTroy}

procedure NTroyPronounce;
const Vowels = [0, 4, 8, 14, 19, 23];
      Cd1: array[0..5] of Byte = (0, 8,  4, 23,  4, 14);
      Cd2: array[0..5] of Byte = (8, 14, 8, 14, 14, 14);
      SemStr = '|(New Troyan pronunciation)';
var i, p: Integer;
    pen: string;
begin
  for i:=0 to WordLen[0]-1 do begin
    if Words[0,i]<>2 then Add(1, Words[0,i]) else if Words[0,i+1] in [2, 13, 17, 25] then Add(1, 26) else if Words[0,i-1]<>2 then Add(1, 2);
    if (Words[0,i] in [5, 13, 22]) and (Words[0,i-1] in Vowels+[255]) and (Words[0,i+1] in Vowels+[6, 255]) then begin
      WordsB[1,1]:=18*Ord(Words[0,i]=5)+9*Ord(Words[0,i]=13)+15*Ord(Words[0,i]=22);
      Add(1, 17);
    end;
    if GetStress(0, i, stIs1)=stIs1 then SetStress(1, WordLen[1]-1, stIs1, False);
  end;
  p:=-1;
  for i:=0 to WordLen[1]-1 do if ((i=WordLen[1]-1) and (Words[1,i-1] in Vowels) and (Words[1,i] in [8, 14])) or
    ((i=WordLen[1]-2) and (Words[1,i+1] in [8, 14])) or (GetStress(1, i, stIs1)=stIs1) then p:=-1 else if Words[1,i] in Vowels+[6] then p:=i;
  if Words[1, p-2] in Vowels then begin
    if Words[1,p]=6 then pen:='' else pen:='pen';
    Insert(1, p-1, Cd2[Words[1, p-2] div 4]);
    Words[1, p-2]:=Cd1[Words[1, p-2] div 4];
    if Words[1, p-2]=14 then RemarksBox.Items.AddObject('New Troyan '+pen+'ultimate is a long '+MCh(lNTroy, Words[1, p-2])+SemStr, Pointer(clWindowText))
      else RemarksBox.Items.AddObject('New Troyan '+pen+'ultimate is a diphthong ('+MCh(lNTroy, Words[1, p-2])+MCh(lNTroy, Words[1, p-1])+')'+SemStr, Pointer(clWindowText));
  end else if (Words[1,p-1]=24) and not (Words[1,p-2] in Vowels+[255]) then Delete(1, p-1);
  if WordsB[1,1]=6 then Delete(1, WordLen[1]-1);
end; {NTroyPronounce}

procedure NTroyToModLem;
const A: array[0..26] of Byte = (0, 12, 8, 11, 1, 22, 2, 16, 3, 18, 28, 25, 24, 21, 6, 20, 26, 15, 19, 7, 17, 13, 23, 4, 13, 14, 24);
var i: Integer;
begin
  NTroyPronounce;
  for i:=0 to WordLen[1]-1 do begin
    Add(2, A[Words[1,i]]);
    if (Words[1,i]=17) and (Words[1,i-1] in [9, 15, 18]) then WordsB[2,1]:=10;
  end;
  ModLemPhonotactics;
  Poststem;
end; {NTroyToModLem}

procedure PIEtoBrug;
var i: Integer;
begin
  PIEStem(lBrug);
  PIEChanges(lBrug); // which semantic shift in thorn cluster?
  // PIE 44=i:, 45=u:  46,49,52,55,58=ph etc.
  for i:=0 to WordLen[0]-1 do begin
    case Words[0,i] of
       0: ;
    end;
  end;
//  RemarksBox.Items.AddObject('Cave morphology!', Pointer(clRed));
  RemarksBox.Items.AddObject('Proto-Indo-European > Brugian not implemented yet!', Pointer(clRed));
end; {BrugToModLem}

procedure BrugToModLem;
var i: Integer;
begin
  for i:=0 to WordLen[0]-1 do begin
    case Words[0,i] of
       0: ;
    end;
  end;
  ModLemPhonotactics;
  Poststem;
//  RemarksBox.Items.AddObject('Cave morphology!', Pointer(clRed));
  RemarksBox.Items.AddObject('Brugian > Modern Lemizh not implemented yet!', Pointer(clRed));
end; {BrugToModLem}

{--------------------------------------------------Loans with non-Lemizh targets---------------------------------------------}

procedure EHellToPrWald;
const A: array[0..34] of Byte = (0, 1, 2, 4, 6, 7, 8, 10, 11, 12, 15, 15, 16, 16, 17, 17, 18, 18, 19, 20, 22, 22, 15, 8, 15, 23, 23, 24, 26, 26, 27, 28, 29, 11, 30);
var i: Integer;
begin
  EHellChanges;
  for i:=0 to WordLen[1]-1 do begin
    if Words[1,i] in [13, 15, 17, 26] then Add(2, 11);
    Add(2, A[Words[1,i]]);
    if Words[1,i] in [22, 23, 24] then Add(2, 29);
    if GetStress(1, i, stAny) in [stIs1, stIs2] then SetStress(2, WordLen[2]-1, stIs1, False);
    if Ending[1]=i+1 then Ending[2]:=WordLen[2];
  end;
  if Ending[1]<>Word(-1) then begin
    case Words[1,Ending[1]] of
      1: Words[2,Ending[2]]:=0;
      14: if WordsB[1,2]=0 then Delete(2, WordLen[2]-2);
      18: begin
        Words[2,Ending[2]]:=0;
        if WordsB[1,1]=16 then Delete(2, WordLen[2]-1);
      end;
      19: Words[2,Ending[2]]:=19;
    end;
  end;
end; {EHellToPrWald}

procedure KoiToElb;
begin

    // CheckBoxCaptions: endingless noun, noun in -s (see KoineToLem)
  RemarksBox.Items.AddObject('Koine Greek > Old Elbic not implemented yet!', Pointer(clRed));
end; {KoiToElb}

procedure NTroyToEth;
var i: Integer;
begin
  NTroyPronounce;
  for i:=0 to WordLen[1]-1 do begin
    case Words[1,i] of
      0:;
      else //Add(2, A[Words[1,i]]);
    end;
  end;
//  RemarksBox.Items.AddObject('Cave morphology!', Pointer(clRed));
  RemarksBox.Items.AddObject('New Troyan > Ethiynic not implemented yet!', Pointer(clRed));
end; {NTroyToEth}

procedure ModLemToNTroy;
begin

  RemarksBox.Items.AddObject('Modern Lemizh > New Troyan not implemented yet!', Pointer(clRed));
end; {ModLemToNTroy}


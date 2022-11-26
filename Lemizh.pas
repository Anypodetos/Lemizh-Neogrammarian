const intPIE = '|(Internal PIE shift)';

procedure Anticipatory(Lang: Byte; Stage: Integer; Voiced, Unvoiced, ACase: array of Byte);
var i, j, k, c: Integer;
begin
  for i:=WordLen[Stage]-2 downto 0 do for j:=0 to Min(Length(Voiced), Length(Unvoiced))-1 do begin
    c:=-1;
    if Words[Stage,i]=  Voiced[j] then for k:=0 to Length(Unvoiced)-1 do if Words[Stage,i+1]=Unvoiced[k] then c:=Unvoiced[j];
    if Words[Stage,i]=Unvoiced[j] then for k:=0 to Length(  Voiced)-1 do if Words[Stage,i+1]=  Voiced[k] then c:=  Voiced[j];
    if c>-1 then begin
      RemarksBox.Items.AddObject('Anticipatory assimilation of '+MCh(Lang, Words[Stage,i])+MCh(Lang, Words[Stage,i+1])+' (in '+LangNs[Lang]+')'
        +IfThen(Lang=lPIE, intPIE, '|'+VoiceChange(True, ACase[j]+Ord(c=Voiced[j]))), Pointer(clWindowText));
      Words[Stage,i]:=c;
    end;
  end;
end; {Anticipatory}

procedure MustHaveStress;
var b: Boolean;
    i: Integer;
begin
  if WordLen[0]>0 then begin
    b:=True;
    for i:=0 to WordLen[0]-1 do if GetStress(0, i, stIs1)=stIs1 then b:=False;
    if b then RemarksBox.Items.AddObject('Missing stress!', Pointer(clRed));
  end;
end; {MustHaveStress}

procedure PIEChanges(Lang: Byte);
var i, j: Integer;
    pinault, sscomp: Boolean;
    complen: string;
begin
  for i:=0 to IfThen(Lang=lPrLem, Min(WordLen[1], Ending[1]), WordLen[1])-1 do begin
    Add(2, Words[1,i], GetStressDia(1, i));
    if (Words[1,i]=0) and (Words[1,i-1] in [24, 26]) then begin
      WordsB[2,1]:=Words[1,i-1]-22;
      RemarksBox.Items.AddObject(MCh(lPIE, Words[1,i-1])+'-colouring'+intPIE, Pointer(clWindowText));
    end;
    if (Words[1,i]=0) and (Words[1,i+1] in [24, 26]) then begin
      WordsB[2,1]:=Words[1,i+1]-22;
      RemarksBox.Items.AddObject(MCh(lPIE, Words[1,i+1])+'-colouring'+intPIE, Pointer(clWindowText));
    end;
    if (Words[1,i] in [28, 31, 34, 37, 40]) and (Words[1,i+1] in [26, 27]) then WordsB[2,1]:=Words[1,i]+1;
    pinault:=True;
    if (Words[1,i-1] in [0..5, 7, 9]) and (Words[1,i] in [22, 24, 26]) and
        (Words[1,i+1] in [6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28..42, 255]) then begin
      RemarksBox.Items.AddObject(MCh(lPIE, Words[1,i])+'-loss with comp. lengthening'+intPIE, Pointer(clWindowText));
      WordCut(2, 1);
      if WordsB[2,1]<=5 then WordsB[2,1]:=WordsB[2,1] div 2 *2+1 else WordsB[2,1]:=WordsB[2,1] div 2 +41;
      pinault:=False;
    end;
    if pinault and (Words[1,i] in [22..27]) and (Words[1,i+1]=6) then begin
      RemarksBox.Items.AddObject('Pinault’s law: '+MCh(lPIE, Words[1,i])+' disappears before '+MCh(lPIE, 6)+intPIE, Pointer(clWindowText));
      WordCut(2, 1);
    end;
    if (Words[1,i] in [28..42]) and (Words[1,i+1] in [28..42]) and (Words[1,i+2] in [6, 8, 10, 12, 14, 16, 18, 20]) then begin
      Add(2, 43);
      RemarksBox.Items.AddObject('Schwa secundum between '+MCh(lPIE, Words[1,i])+' and '+MCh(lPIE, Words[1,i+1])+intPIE, Pointer(clWindowText));
    end;
    if (Words[1,i] in [31, 32]) and (Words[1,i+1] in [31, 32]) then begin
      Add(2, 18);
      RemarksBox.Items.AddObject('Dental cluster '+MCh(lPIE, Words[1,i])+MCh(lPIE, Words[1,i+1])+' inserts '+MCh(lPIE, 18)+intPIE, Pointer(clWindowText));
    end;
    if (Words[1,i]=18) and (Words[1,i-1]=18) then begin
      sscomp:=(WordsB[2,3] in [0, 2, 4, 7, 9]) and (i=WordLen[1]-1);
      RemarksBox.Items.AddObject('Double '+MCh(lPIE, 18)+' simplifies'+IfThen(sscomp, ' with comp. lengthening')+intPIE, Pointer(clWindowText));
      if sscomp then
        if WordsB[2,3]<=5 then WordsB[2,3]:=WordsB[2,3] div 2 *2+1 else WordsB[2,3]:=WordsB[2,3] div 2 +41;
      WordCut(2, 1);
    end;
    if (Words[1,i] in [40..42]) and ((Words[1,i-1] in [8, 9]) or (Words[1,i+1] in [8, 9])) then begin
      WordsB[2,1]:=Words[1,i]-3;
      RemarksBox.Items.AddObject('boukólos rule: '+MCh(lPIE, Words[1,i])+' > '+MCh(lPIE, WordsB[2,1])+' next to '+MCh(lPIE, 8)+' or '+MCh(lPIE, 9)+intPIE, Pointer(clWindowText));
    end;
    if (Lang>lPrLem) and (Words[1,i] in [34..42]) and (Words[1,i-1] in [31..33]) then begin
      WordCut(2, 2);
      if Lang=lEHell then begin
        Add(2, Words[0,i]);
        Add(2, Words[0,i-1]);
      end else Add(2, 46+Ord(Words[1,i-1]>31));
      RemarksBox.Items.AddObject('Thorn cluster '+MCh(lPIE, Words[1,i-1])+MCh(lPIE, Words[1,i])+' '
        +IfThen(Lang=lEHell, 'metathesises|'+Metathesis(caseB+Ord(Words[1,i-1]=31), caseB+Ord(Words[1,i] in [34, 37, 40])), 'simplifies|'
        +Existence(False, caseB+Ord(Words[1,i-1]=31))+IfThen(Lang=lPrWald, ' / '+TypeChange(Words[1,i-1]<>31, caseB+Ord(Words[1,i-1]=31), caseW+Ord(Words[1,i-1]=31)))),  // Brugian?
        Pointer(clWindowText));   
    end;
    if Ending[1]=i then Ending[2]:=WordLen[2]-1;
  end;
  if (WordsB[2,1]=12) and (WordsB[2,2]=5) then begin
    WordCut(2, 1);
    RemarksBox.Items.AddObject('Word-final '+MCh(lPIE, 12)+' disappears after '+MCh(lPIE, 5)+intPIE, Pointer(clWindowText));
  end;
  WordLen[1]:=WordLen[2];
  for i:=0 to WordLen[2]-1 do WordsStressDia[1, i, GetStressDia(2, i)]:=Words[2,i];
  Ending[1]:=Ending[2];
  WordLen[2]:=0;
  if Lang=lPrLem then Anticipatory(lPIE, 1, [20, 29, 32, 35, 38, 41, 30, 33, 36, 39, 42], [18, 28, 31, 34, 37, 40],
      [caseW, caseB, caseB, caseB, caseB, caseB, caseB, caseB, caseB, caseB, caseB])
    else Anticipatory(lPIE, 1, [20, 29, 32, 35, 38, 41, 30, 33, 36, 39, 42, 26, 27], [18, 28, 31, 34, 37, 40],
      [caseW, caseB, caseB, caseB, caseB, caseB, caseB, caseB, caseB, caseB, caseB, caseW, caseW]);
  if (WordsB[1,3] in [0..5, 7, 9, 44{i:}, 45{u:}]) then begin
    complen:=IfThen(not (WordsB[1,3] in [1, 3, 5]), ' with comp. lengthening')+intPIE;
    if (WordsB[1,1] in [18, 22, 24, 26]) and (WordsB[1,2] in [6, 8, 10, 12, 14, 16]) then begin  {*VRs, *VRH > *V:R; R = jwmnrl}
      RemarksBox.Items.AddObject('Szemerényi: '+MCh(lPIE, WordsB[1,3])+MCh(lPIE, WordsB[1,2])+MCh(lPIE, 18)+' elmininates '+MCh(lPIE, 18)+complen, Pointer(clWindowText));
      if WordsB[1,3]<=5 then WordsB[1,3]:=WordsB[1,3] div 2 *2+1 else if WordsB[1,3]<=9 then WordsB[1,3]:=WordsB[1,3] div 2 +41;
      WordCut(1, 1);
    end else if (WordsB[1,1]=10) and (WordsB[1,2] in [8, 10]) then begin  {*V[wm]m > *V:m}
      RemarksBox.Items.AddObject('Stang: '+MCh(lPIE, WordsB[1,3])+MCh(lPIE, WordsB[1,2])+MCh(lPIE, 10)+' elmininates '+MCh(lPIE, WordsB[1,2])+complen, Pointer(clWindowText));
      if WordsB[1,3]<=5 then WordsB[1,3]:=WordsB[1,3] div 2 *2+1 else if WordsB[1,3]<=9 then WordsB[1,3]:=WordsB[1,3] div 2 +41;
      Delete(1, WordLen[1]-2);
    end else if (WordsB[1,1]=7) and (WordsB[1,2]=6) then begin  {*Vyi > *V:y}
      RemarksBox.Items.AddObject('Stang: '+MCh(lPIE, WordsB[1,3])+MCh(lPIE, 6)+MCh(lPIE, 7)+' elmininates '+MCh(lPIE, 7)+complen, Pointer(clWindowText));
      if WordsB[1,3]<=5 then WordsB[1,3]:=WordsB[1,3] div 2 *2+1 else if WordsB[1,3]<=9 then WordsB[1,3]:=WordsB[1,3] div 2 +41;
      WordCut(1, 1);
    end;
  end;
  if ComboBox.Visible then CheckBox.Visible:=False else
    if (Lang=lPrLem) and (Ending[0]=Word(-1)) and (WordLen[0]>0) then begin
      CheckBox.Caption:=CheckBoxCaptions[6];
      CheckBox.Hint:=CheckBoxHints[6];
      CheckBox.Visible:=True;
    end else begin
      CheckBox.Caption:=CheckBoxCaptions[1]+' ['+IfThen(Words[1,1] in [6, 8], 'di', 'mono')+'syllabic] {*}';
      CheckBox.Hint:=CheckBoxHints[1];
      j:=0;
      for i:=0 to WordLen[1]-1 do if Words[1,i] in [0..5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27] then Inc(j);
      CheckBox.Visible:=(Words[0,0] in [6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28..42])
        and (((Words[0,1] in [6, 8]) and (j<=1)) or ((Words[0,2] in [6, 8]) and (Words[0,1]=Words[0,2]+1) and (j<=2)));
      if CheckBox.Checked and CheckBox.Visible then if Words[1,1] in [6, 8] then Insert(1, 1, Words[1,1]+1) else Delete(1, 1);
    end;
  if (Ending[0]<WordLen[0]) or CheckBox.Visible and (CheckBox.Caption=CheckBoxCaptions[6]) and CheckBox.Checked then MustHaveStress;
end; {PIEChanges}

procedure PIEtoPrLem;
function AfterCons: Boolean;
  begin
    Result:=WordsB[2,1] in [10..33, 255];
    if (WordsB[2,1]=14) and (WordsB[2,2] in [0..9]) then Result:=False;
  end;
const
  caseV: array[0..4] of Byte = (caseE, caseA, caseO, caseI, caseU);
  hReflex: array[11..13] of Byte = (27, 26, 21);
  PFPsem: array[1..3] of Byte = (caseN, caseW, caseF);
var
  i, j: Integer;
  b: Boolean;
  st: string;
begin
  PIEStem(lPrLem);
  PIEChanges(lPrLem);
  if ComboBox.Visible then
    if ComboBox.ItemIndex in [5, 9, 10, 12..17, 21, 23, 25..28, 30, 33] then RemarksBox.Items.AddObject('No thematic verbs in Proto-Lemizh!', Pointer(clRed)) else
      if ComboBox.ItemIndex=22 then RemarksBox.Items.AddObject('No s-aorist in Proto-Lemizh!', Pointer(clRed));
  for i:=0 to WordLen[1]-1 do begin
    case Words[1,i] of
      0..5: Add(2, Words[1,i]);
      7, 9: Add(2, Words[1,i]-1);
      6: Add(2, 18);
      8: Add(2, 14);
      10, 12, 14, 16: Add(2, Words[1,i] div 2 +5);
      11, 13, 15, 17: begin Add(2, 2); Add(2, Words[1,i] div 2 +5); end;
      18, 20: Add(2, 86-7*Words[1,i] div 2);
      19, 21: begin Add(2, 2); Add(2, 86-7*(Words[1,i] div 2)); end;
      22, 24, 26: if not (WordsB[2,1] in [1, 3, 5]) then Add(2, hReflex[Words[1,i] div 2]) else
        RemarksBox.Items.AddObject('Elimination of '+MCh(lPIE, Words[1,i])+' after long vowel '+MCh(lPrLem, WordsB[2,1])+'|(Pseudo-internal PIE shift)', Pointer(clWindowText));
      23, 25, 27: Add(2, Words[1,i]-23);
      28: if AfterCons then Add(2, 31) else if WordsB[2,1] in [0, 1, 6, 7] then Add(2, 21) else Add(2, 21);
      29: if AfterCons then Add(2, 28) else if WordsB[2,1] in [0, 1, 6, 7] then Add(2, 14) else Add(2, 14);
      30: if AfterCons then begin Add(2, 28); Add(2, 14); end else begin Add(2, 10); Add(2, 28); end;
      31: if AfterCons then Add(2, 32) else if WordsB[2,1] in [0, 1, 6, 7] then Add(2, 22) else Add(2, 23);
      32: if AfterCons then Add(2, 29) else if WordsB[2,1] in [0, 1, 6, 7] then Add(2, 15) else Add(2, 16);
      33: if AfterCons then begin Add(2, 29); Add(2, 16); end else begin Add(2, 11); Add(2, 29); end;
      34: if AfterCons then Add(2, 33) else if WordsB[2,1] in [0, 1, 6, 7] then Add(2, 24) else Add(2, 25);
      35: if AfterCons then Add(2, 30) else if WordsB[2,1] in [0, 1, 6, 7] then Add(2, 17) else Add(2, 18);
      36: if AfterCons then begin Add(2, 30); Add(2, 18); end else begin Add(2, 11); Add(2, 30); end;
      37, 40: if AfterCons then Add(2, 33) else if WordsB[2,1] in [0, 1, 6, 7] then Add(2, 26) else Add(2, 27);
      38, 41: if AfterCons then Add(2, 30) else if WordsB[2,1] in [0, 1, 6, 7] then Add(2, 19) else Add(2, 20);
      39, 42: if AfterCons then begin Add(2, 30); Add(2, 19); end else begin Add(2, 11); Add(2, 30); end;
      43: Add(2, 2);
      44, 45: Add(2, 2*Words[1,i]-81);
      46: begin Add(2, 31); Add(2, 21); end;
      49: begin Add(2, 32); Add(2, 23); end;
      52: begin Add(2, 33); Add(2, 25); end;
      55: begin Add(2, 33); Add(2, 26); end;
      58: begin Add(2, 33); Add(2, 21); end;
    end;
    if Words[1,i] in [40..42] then Add(2, 14);
    j:=WordsB[2,2];
    if (WordsB[2,1]=18) and (j<10) then begin
      RemarksBox.Items.AddObject('Elimination of '+MCh(lPrLem, 18)+' after vowel with comp. lengthening|'+TypeChange(True, caseW, caseV[j div 2]), Pointer(clWindowText));
      WordCut(2, 2-Ord(Odd(j)));
      if not Odd(j) then Add(2, j+1);
    end;
    j:=WordsB[2,1];
    if (WordsB[2,3] in [19, 20, 26, 27]) and (WordsB[2,2]=14) and (j in [10..33]) then begin
      RemarksBox.Items.AddObject('Limsa rule: '+MCh(lPrLem, WordsB[2,3])+MCh(lPrLem, 14)+' > '+MCh(lPrLem, 10)+'|'+TypeChange(False, caseW, caseN), Pointer(clWindowText));
      Delete(2, WordLen[2]-2);
      WordsB[2,2]:=10;
    end;
    if (WordsB[2,3] in [28..33]) and (WordsB[2,2] in [14..20]) and (WordsB[2,1] in [12, 13]) then begin
      RemarksBox.Items.AddObject('Affricate '+MCh(lPrLem, WordsB[2,3])+MCh(lPrLem, WordsB[2,2])+' gets devoiced before '+MCh(lPrLem, WordsB[2,1])+
        '|'+VoiceChange(False, caseBW), Pointer(clWindowText));
      WordsB[2,2]:=WordsB[2,2]+7;
      if WordsB[2,3]<=30 then WordsB[2,3]:=WordsB[2,3]+3;
    end;
  end;
  repeat
    b:=False;
    for i:=0 to WordLen[2]-3 do if (Words[2,i] in [14..33]) and (Words[2,i+1] in [10, 11, 14..27]) and (Words[2,i+2] in [14..33]) then begin
      RemarksBox.Items.AddObject('PFP rule: '+MCh(lPrLem, Words[2,i])+MCh(lPrLem, Words[2,i+1])+MCh(lPrLem, Words[2,i+2])+' eliminates middle consonant|'
        +Existence(False, PFPsem[Words[2,i+1] div 7]), Pointer(clWindowText));
      for j:=i+1 to WordLen[2]-2 do Words[2,j]:=Words[2,j+1];
      WordCut(2, 1);
      b:=True;
    end;
  until not b;
  for i:=0 to WordLen[2]-3 do if (Words[2,i] in [28..33]) and (Words[2,i+1] in [28..33]) and (Words[2,i+2] in [10..33]) then begin
    RemarksBox.Items.AddObject('PPC rule: '+MCh(lPrLem, Words[2,i])+MCh(lPrLem, Words[2,i+1])+MCh(lPrLem, Words[2,i+2])+' eliminates middle consonant|'
      +Existence(False, caseB+Ord(Words[2,i+1]>=31)), Pointer(clWindowText));
    for j:=i+1 to WordLen[2]-2 do Words[2,j]:=Words[2,j+1];
    WordCut(2, 1);
  end;
  if (SmallInt(Ending[0])>-1) and (WordsB[2,1] in [6, 8]) then for i:=0 to WordLen[2]-2 do if Words[2,i] in [0..9] then begin
    RemarksBox.Items.AddObject('Final '+MCh(lPrLem, WordsB[2,1])+' becomes '+MCh(lPrLem, 30-2*WordsB[2,1])+' in polysyllabic stems|'
      +TypeChange(False, caseV[WordsB[2,1] div 2], caseW), Pointer(clWindowText));
    WordsB[2,1]:=30-2*WordsB[2,1];
    Break;
  end;
  Anticipatory(lPrLem, 2, [28, 29, 30], [31, 32, 33, 21, 22, 23, 24, 25, 26, 27], [caseB, caseB, caseB, caseW, caseW, caseW, caseW, caseW, caseW, caseW]);
  Anticipatory(lPrLem, 2, [28, 29, 30, 14, 15, 16, 17, 18, 19, 20], [31, 32, 33], [caseB, caseB, caseB, caseW, caseW, caseW, caseW, caseW, caseW, caseW]);
  for i:=WordLen[2]-1 downto 1 do if (Words[2,i-1]=Words[2,i]) or ((Words[2,i]<10) and (Words[2,i] div 2=Words[2,i-1] div 2)) then begin
    case Words[2,i] of
      0..9: st:=Existence(False, caseV[Words[2,i] div 2]);
      10..11: st:=Existence(False, caseN);
      12..13: st:=Existence(False, caseL);
      14..27: st:=Existence(False, caseW+Ord(Words[2,i]>=21));
      28..33: st:=Existence(False, caseB+Ord(Words[2,i]>=31));
    end;
    RemarksBox.Items.AddObject('Double '+MCh(lPrLem, Words[2,i-1])+' simplifies|'+st, Pointer(clWindowText));
    Delete(2, i);
    if Words[2,i-1] in [0, 2, 4, 6, 8] then Words[2,i-1]:=Words[2,i-1]+1;
  end else if (Words[2,i]=27) and (Words[2,i-1] in [16, 23, 28..33]) then begin
    RemarksBox.Items.AddObject(MCh(lPrLem, 27)+' after '+MCh(lPrLem, Words[2,i-1])+' eliminated|'+Existence(False, caseF), Pointer(clWindowText));
    Delete(2, i);
  end;
  if (SmallInt(Ending[0])>-1) or CheckBox.Checked then Ending[2]:=WordLen[2];
end; {PIEtoPrLem}

procedure PrToOLem;
const
  Plosive: array[14..19] of Byte = (23, 24, 24, 24, 25, 25);
  caseV: array[0..7] of Byte= (caseA, caseY, caseO, caseU, caseE, caseI, caseOE, caseUE);
var
  i, bw, SylNr, sshift, shiftedS: Integer;
  b, aff: Boolean;
  Syls: array of (syN, syS, syD);
  VowelPos: array of Integer;
begin
  bw:=100*Words[0,0]+Words[0,1];
  aff:=False;
  sshift:=-1;
  for i:=0 to WordLen[0]-1 do if (Words[0,i] in [29, 16, 30, 32, 23]) and (Words[0,i+1]=27) then case Words[0,i] of
    16: Add(1, 17);    23: Add(1, 24);    29: Add(1, 15);    30: Add(1, 19);    32: Add(1, 22);
  end else if (Words[0,i]<>27) or not (Words[0,i-1] in [29, 16, 30, 32, 23]) then Add(1, Words[0,i]);
  for i:=0 to WordLen[1]-1 do begin
    case Words[1,i] of
      0: if Words[1,i+1]<>14 then Add(2, 4)  else Add(2, 31);
      1: if Words[1,i+1]<>14 then Add(2, 31) else begin Add(2, 4); Add(2, 5); end;
      2: if Words[1,i+1]<>14 then Add(2, 0)  else begin Add(2, 0); Add(2, 1); end;
      3: if Words[1,i+1]<>14 then Add(2, 31) else begin Add(2, 4); Add(2, 5); end;
      4: if Words[1,i+1]<>14 then Add(2, 2)  else begin Add(2, 2); Add(2, 3); end;
      5: if Words[1,i+1]<>14 then Add(2, 6)  else begin Add(2, 6); Add(2, 7); end;
      6: if Words[1,i+1]<>14 then Add(2, 5)  else Add(2, 32);
      7: if Words[1,i+1]<>14 then Add(2, 32) else Add(2, 32);
      8: if Words[1,i+1]<>14 then Add(2, 3)  else Add(2, 7);
      9: if Words[1,i+1]<>14 then Add(2, 7)  else Add(2, 7);
      10..12: Add(2, Words[1,i]+16);
      13: Add(2, 30);
      14..19, 21..26: begin
        Add(2, Words[1,i]-6-Ord(Words[1,i]>=21));
        if (WordLen[2]=1) and (Words[1,i] in [16, 23]) and (Words[1,i+1] in [0..9]) then sshift:=Words[1,i+1] else
          if (Words[1,i]=14) and (Words[1,i-1] in [0..9]) then WordCut(2, 1);
      end;
      20: if (WordsB[2,1] in [0..7, 31, 32, 255]) and (Words[1,i+1] in [0..9, 255]) then Add(2, 13) else if WordsB[2,1] in [0, 2..5] then begin
        RemarksBox.Items.AddObject('Elimination of '+MCh(lPrLem, 20)+' with comp. lengthening|'+TypeChange(True, caseW, caseV[WordsB[2,1]]), Pointer(clWindowText));
        if WordsB[2,1]=0 then WordsB[2,1]:=31 else if WordsB[2,1] in [2, 3] then WordsB[2,1]:=WordsB[2,1]+4 else WordsB[2,1]:=WordsB[2,1]+27;
      end else RemarksBox.Items.AddObject('Elimination of '+MCh(lPrLem, 20)+'|'+Existence(False, caseW), Pointer(clWindowText));
      27: Add(2, 29);
      28..33: if (i>0) or not ((bw=2814) or (bw=2916) or (bw=3018) or (bw=3019) or (bw=3121) or (bw=3223) or (bw=3325) or (bw=3326)) then Add(2, Words[1,i]-8)
        else aff:=True;
    end;
  end;
  SetLength(Syls, WordLen[0]+1);
  SetLength(VowelPos, WordLen[0]+1);
  SylNr:=-Ord(SmallInt(Ending[0])=-1);
  for i:=WordLen[2]-1 downto 0 do if Words[2,i] in [0..7, 31, 32] then begin
    if Words[2,i] in [31, 32] then Syls[SylNr]:=syS else if Words[2,i]=Words[2,i+1]-1 then begin
      Dec(SylNr);
      Syls[SylNr]:=syD;
    end else if Words[2,i] in [6, 7] then Syls[SylNr]:=syS else Syls[SylNr]:=syN;
    VowelPos[SylNr]:=i;
    Inc(SylNr);
  end;
  Syls[SylNr]:=syN;
  b:=False;
  for i:=0 to SylNr-1 do if Syls[i]<>syN then b:=True;
  if (SylNr>0) and not b then Syls[0]:=syS;
  for i:=0 to SylNr-1 do if (Syls[i]=syN) and (Words[2,VowelPos[i]] in [0, 2, 4]) then
    if (VowelPos[i]=0) or ((Syls[i+1]>syN) and (VowelPos[i]=VowelPos[i+1]+Ord(Syls[i+1]))) then begin
      RemarksBox.Items.AddObject('Unstressed vowel '+MCh(lOLem, Words[2,VowelPos[i]])+' eliminated|'+Existence(False, caseV[Words[2,VowelPos[i]]]), Pointer(clWindowText));
      Delete(2, VowelPos[i]);
    end else begin
      RemarksBox.Items.AddObject('Unstressed vowel '+MCh(lOLem, Words[2,VowelPos[i]])+' weakened to '+MCh(lOLem, Words[2,VowelPos[i]]+1)+'|'
        +PosChange(True, caseV[Words[2,VowelPos[i]]], caseV[Words[2,VowelPos[i]]+1]), Pointer(clWindowText));
      Words[2,VowelPos[i]]:=Words[2,VowelPos[i]]+1;
    end;
  if aff then if (SylNr>0) and (Syls[SylNr-1]=syN) then begin
    Insert(2, 0, Words[1,0]-8);
    sshift:=-1;
  end else RemarksBox.Items.InsertObject(0, 'Initial affricate '+MCh(lPrLem, Words[1,0])+MCh(lPrLem, Words[1,1])+' simplifies in stressed syllable|'
    +Existence(False, caseB+Ord(Words[1,0]>=31)), Pointer(clWindowText));
  if sshift>-1 then begin
    if sshift in [0, 1, 6, 7] then shiftedS:=Words[2,0]-1 else shiftedS:=Words[2,0]+1;
    RemarksBox.Items.AddObject('Initial '+MCh(lOLem, Words[2,0])+' shifts to '+MCh(lOLem, shiftedS)+' before vowel '+MCh(lPrLem, sshift)+'|'
      +PosChange(True, caseW+Ord(Words[2,0]=16), caseW+Ord(Words[2,0]=16)), Pointer(clWindowText));
    Words[2,0]:=shiftedS;
  end;
  CheckBox.Caption:=CheckBoxCaptions[2];
  CheckBox.Hint:=CheckBoxHints[2];
  CheckBox.Visible:=(Ending[0]=WordLen[0]) and (WordsB[2,1] in [14..19]);
  if CheckBox.Visible and CheckBox.Checked then begin
    RemarksBox.Items.AddObject('Stem-final '+MCh(lOLem, WordsB[2,1])+' hardens|'+TypeChange(False, caseF, caseP), Pointer(clWindowText));
    WordsB[2,1]:=Plosive[WordsB[2,1]];
  end;
  if SmallInt(Ending[0])>-1 then Ending[2]:=WordLen[2];
end; {PrToOLem}

procedure OLemXh;
var i: Integer;
begin
  for i:=0 to WordLen[0]-1 do if (Words[0,i] in [21, 10, 22, 24, 16]) and (Words[0,i+1]=29) then case Words[0,i] of
    21: Add(1, 9);    10: Add(1, 21);    22: Add(1, 13);    24: Add(1, 15);    16: Add(1, 17);
  end else if (Words[0,i]<>29) or not (Words[0,i-1] in [21, 10, 22, 24, 16]) then Add(1, Words[0,i]);
end; {OLemXh}

procedure OToMLem;
const ce: array[1..8] of Byte = (0, 2, 1, 3, 5, 7, 2, 2);
var i, n, p: Integer;
begin
  OLemXh;
  if (Words[1,0] in [16..19, 25]) and (Words[1,1] in [0..7]) and (Words[1,2] in [26, 27]) then begin
    RemarksBox.Items.AddObject('Initial '+MCh(lOLem, Words[1,0])+' voiced before vowel plus nasal ('+MCh(lOLem, Words[1,1])+MCh(lOLem, Words[1,2])+')|'
      +VoiceChange(True, 9+2*Ord(Words[2,0]<=19)), Pointer(clWindowText));
    Words[1,0]:=Words[1,0]-3-3*Ord(Words[1,0]<=19);
  end;
  n:=0;
  for i:=0 to WordLen[1]-1 do begin
    case Words[1,i] of
      0..3: Add(2, 2*Words[1,i]);
      4..7: if (Words[1,i]=5) and (Words[1,i-1] in [11, 13, 17, 19, 22, 25, 27]) then begin
        RemarksBox.Items.AddObject(MCh(lOLem, 5)+' lowered to '+MCh(lMLem, 1)+' after '+IfThen(Words[1,i-1] in [11, 17], 'postalveolar', 'velar')+'|'
          +TypeChange(True, caseI, caseE), Pointer(clWindowText));
        Add(2, 1);
      end else Add(2, 2*Words[1,i]-7);
      8..12: Add(2, 20-Words[1,i]);
      13: if (Words[1,i-1] in [22, 25, 27]) or (Words[1,i+1] in [22, 25, 27]) then Add(2, 8) else Add(2, 27);
      14..18: Add(2, 31-Words[1,i]);
      19: Add(2, 13);
      20..22: Add(2, 40-Words[1,i]);
      23..25: Add(2, 46-Words[1,i]);
      26, 27: Add(2, 51-Words[1,i]);
      28: Add(2, 26);
      29: if Words[1,i-1] in [0..7, 31, 32] then Add(2, 13) else RemarksBox.Items.AddObject('Elimination of '+MCh(lOLem, 29)+'|'+Existence(False, caseF), Pointer(clWindowText));
      30: Add(2, 28);
      31: begin Add(2, 1); Add(2, 1); end;
      32: begin Add(2, 3); Add(2, 3); end;
    end;
    if Words[1,i] in [0..5, 7] then Inc(n) else if Words[1,i] in [6, 31, 32] then Inc(n, 2);
    if (Words[1,i]=6) and (Words[1,i+1]<>7) then Add(2, 5);
  end;
  p:=ShowComboBox(SmallInt(Ending[0])>-1, 2);
  if ComboBox.Visible then begin
    if (p=2) and (WordsB[1,2] in [0..7, 31, 32]) and (WordsB[1,1]=28) and ((n>3) or (n>2) and (WordsB[1,2] in [1, 5])) then begin
      CheckBox.Caption:=CheckBoxCaptions[9];
      CheckBox.Hint:=CheckBoxHints[9];
      CheckBox.Visible:=True;
    end else CheckBox.Visible:=False;
    if CheckBox.Visible and CheckBox.Checked then WordCut(2, 2);
    if (p in [7, 8]) and (WordsB[2,1] in [18..23]) then begin
      RemarksBox.Items.AddObject('Elimination of stem-final '+MCh(lMLem, WordsB[2,1])+'|'+Existence(False, caseB+Ord(WordsB[2,1]>=21)), Pointer(clWindowText));
      Delete(2, WordLen[2]-1);
    end;
    if p<9 then Ending[2]:=WordLen[2];
    case p of
      0: Add(2, 0);
      1..8: begin
        Add(2, ce[p]);
        Add(2, 26+2*Ord(p=8));
      end;
    end;
  end;
end; {OToMLem}

procedure OToNLem;
const A: array[0..32] of Byte = (0, 2, 4, 6, 1, 3, 5, 7, 12, 11, 10, 9, 8, 8, 17, 16, 15, 14, 13, 13, 20, 19, 18, 23, 22, 21, 25, 24, 26, 0, 28, 1, 3);
var i: Integer;
begin
  for i:=0 to WordLen[0]-1 do if Words[0,i]<>29 then Add(2, A[Words[0,i]]);
  if Ending[0]=WordLen[0] then begin
    Ending[2]:=WordLen[2];
    Add(2, 0);
  end;
end; {OToNLem}

procedure MToLMLem;
var i, v1, v2: Integer;
    b: Boolean;
    Vowel: array of (vNo, vOrd, v1st, v2nd);
begin
  SetLength(Vowel, WordLen[0]);
  for i:=0 to Min(WordLen[0], Ending[0])-1 do if Words[0,i]>7 then Vowel[i]:=vNo else if (i=0) or (Vowel[i-1]<>vOrd) then Vowel[i]:=vOrd else begin
    Vowel[i]:=v2nd;
    Vowel[i-1]:=v1st;
  end;
  if (Ending[0] in [1..WordLen[0]]) and (Vowel[Ending[0]-1]=vOrd) then Vowel[Ending[0]-1]:=v2nd;
  for i:=0 to Min(WordLen[0], Ending[0])-1 do if Vowel[i]<>v2nd then Add(2, Words[0,i]) else begin
    b:=Vowel[i-1]<>v1st;
    v1:=Words[0,i-1+Ord(b)];
    if not b or (Ending[0]<WordLen[0]) then v2:=Words[0,i+Ord(b)] else v2:=0;
    RemarksBox.Items.AddObject(IfThen(v1=v2, 'Monophthongisation', 'Shortening')+' of '+MCh(lMLem, v1)+MCh(lMLem, v2)+IfThen(b, ' (extending into ending)')
      +'|'+Existence(False, Words[0,i]), Pointer(clWindowText));
  end;
  for i:=0 to Min(WordLen[0], Ending[0])-1 do if Vowel[i]=v1st then SetStress(2, i, stIs1, False);
  if SmallInt(Ending[0])>-1 then Ending[2]:=WordLen[2];
  for i:=Min(WordLen[0], Ending[0]) to WordLen[0]-1 do Add(2, Words[0,i]);
end; {MToLMLem}

function CaseOf(c: Integer): TCase;
begin
  if c<8 then Result:=c else Result:=8+2*Ord(c in [8..17])+Ord(c in [13..17, 21..23])+4*Ord(c in [24, 25])+6*Ord(c in [26..28]);
end; {CaseOf}

procedure LMToNLem;
const
  addJ: array[caseB..caseF] of Integer = (3, -3, 5, -5);
  PtoF: array[18..23] of Integer = (8, 10, 12, 13, 15, 17);
  afterWhat: array[False..True] of string = ('after consonant', 'word-initially');
  quasiMeta: array[8..17] of Byte = (12, 12, 0, 8, 8, 17, 0, 0, 0, 13);
  affStr: array[0..1] of string = (' reverse', 'n');
  VposStr: array[False..True] of string = ('rounded after obstruent + liquid', 'raised after obstruent + nasal');
var
  i, j, rm, lv, c, f, cl: Integer;
  b: Boolean;
  st: string;
begin
  b:=True;
  for i:=0 to Min(WordLen[0], Ending[0])-1 do if GetStress(0, i, stAny)=stIs1 then b:=False;
  lv:=-1;
  if b then for i:=0 to Min(WordLen[0], Ending[0])-1 do if Words[0,i]<=7 then lv:=i;
  for i:=0 to Min(WordLen[0], Ending[0])-1 do if (Words[0,i]>7) or (GetStress(0, i, stAny)=stIs1) or (i=lv) then Add(2, Words[0,i]) else begin
    RemarksBox.Items.AddObject(MCh(lLMLem, Words[0,i])+' syncopates|'+Existence(False, Words[0,i]), Pointer(clWindowText));
    j:=WordLen[2]-1;
    while Words[2,j] in [8..29] do Dec(j);
    if Words[2,j+1] in [13..17, 21..23] then begin
      RemarksBox.Items.AddObject(MCh(lNLem, Words[2,j+1])+' gets voiced before syncope|'+VoiceChange(True, CaseOf(Words[2,j+1])), Pointer(clWindowText));
      Words[2,j+1]:=Words[2,j+1]-3-2*Ord(Words[2,j+1] in [13..17]);
    end;
  end;
  repeat
    rm:=RemarksBox.Items.Count;
    for i:=WordLen[2]-2 downto 0 do if Words[2,i-1]>7 then                    {LC, NF}
      if ((Words[2,i] in [26..28]) and (Words[2,i+1] in [8, 11..18, 20, 21, 23])) or ((Words[2,i] in [24, 25]) and (Words[2,i+1] in [8..17])) then begin
        if ((Words[2,i]=24) and (Words[2,i+1] in [11, 12, 17])) or ((Words[2,i]=25) and (Words[2,i+1] in [8, 9, 13])) then begin
          RemarksBox.Items.AddObject(MCh(lNLem, Words[2,i])+MCh(lNLem, Words[2,i+1])+' quasi-metathesises '+afterWhat[Words[2,i-1]=255]
            +'|'+Metathesis(CaseOf(Words[2,i]), CaseOf(Words[2,i+1])), Pointer(clWindowText));
          Words[2,i]:=quasiMeta[Words[2,i+1]];
          Words[2,i+1]:=24+Ord(Words[2,i+1] in [11, 12, 17]);
        end else begin
          RemarksBox.Items.AddObject(MCh(lNLem, Words[2,i])+MCh(lNLem, Words[2,i+1])+' metathesises '+afterWhat[Words[2,i-1]=255]
            +'|'+Metathesis(CaseOf(Words[2,i]), CaseOf(Words[2,i+1])), Pointer(clWindowText));
          c:=Words[2,i];  Words[2,i]:=Words[2,i+1];  Words[2,i+1]:=c;
        end;
      end else if (Words[2,i] in [26..28]) and (Words[2,i+1] in [9, 10, 19, 22]) then begin {LD, Lz(h)}
        RemarksBox.Items.AddObject(MCh(lNLem, Words[2,i])+' assimilates '+MCh(lNLem, Words[2,i+1])+' '+afterWhat[Words[2,i-1]=255]+'|'
          +Existence(False, CaseOf(Words[2,i+1])), Pointer(clWindowText));
        if Words[2,i+1]=9 then Words[2,i]:=26 else if Words[2,i+1]=10 then Words[2,i]:=27;
        Delete(2, i+1);
      end;
    for i:=WordLen[2]-2 downto 0 do if (Words[2,i] in [24, 25]) and (Words[2,i+1] in [18..23]) and (Words[2,i-1]>7{incl. 255}) then begin {NP}
      if Words[2,i+1] in [18, 21] then c:=24 else if Words[2,i+1] in [20, 23] then c:=25 else c:=Words[2,i];
      RemarksBox.Items.AddObject(MCh(lNLem, Words[2,i])+MCh(lNLem, Words[2,i+1])+' contracts to '+MCh(lNLem, c)+'|'
        +Existence(False, CaseOf(Words[2,i+1])), Pointer(clWindowText));
      Words[2,i]:=c;
      Delete(2, i+1);
    end;
    for i:=WordLen[2]-2 downto 0 do if (Words[2,i] in [18..23]) and (Words[2,i+1] in [18..23]) and not (Words[2,i]=Words[2,i+1]) {PP}
        and (Words[2,i-1] in [0..7, 24..28, 255]) and (Words[2,i+2] in [0..7, 24..28, 255]) then begin
      if (Words[2,i-1] in [24..28]) and not (Words[2,i+2] in [24..28]) then j:=1 else j:=0;
      RemarksBox.Items.AddObject('Two consecutive plosives ('+MCh(lNLem, Words[2,i])+MCh(lNLem, Words[2,i+1])+') get a'+affStr[j]+' afficate|'
        +TypeChange(False, CaseOf(Words[2,i+j]), CaseOf(Words[2,i+j])+2), Pointer(clWindowText));
      Words[2,i+j]:=PtoF[Words[2,i+j]];
    end;
    for i:=WordLen[2]-2 downto 0 do if ((Words[2,i] in [18..23]) and (Words[2,i+1] in [18..23])) or  {CC}
        ((Words[2,i] in [24, 25]) and (Words[2,i+1] in [24, 25])) or ((Words[2,i]=Words[2,i+1]) and (Words[2,i]>7)) then begin
      RemarksBox.Items.AddObject(MCh(lNLem, Words[2,i])+MCh(lNLem, Words[2,i+1])+Copy(' assimilates and', 1, 16*Ord(Words[2,i]<>Words[2,i+1]))
        +' simplifies to '+MCh(lNLem, Words[2,i])+'|'+Existence(False, CaseOf(Words[2,i+1])), Pointer(clWindowText));
      Delete(2, i+1);
    end;
  until rm=RemarksBox.Items.Count;
  for i:=WordLen[2]-2 downto 0 do if (Words[2,i] in [8..17]) and (Words[2,i+1] in [8..17]) then begin
    f:=0;
    for j:=i-2 to i+3 do if Words[2,j] in [8..17] then Inc(f, 2) else if Words[2,j] in [18..28] then Inc(f) else if j=i-1 then f:=0 else if j=i+2 then Break;
    if f>=6 then begin
      if (Words[2,i] in [8..12]) xor (Words[2,i+1] in [8..12]) then c:=10*Ord(Words[2,i+1] in [8..12])-5 else c:=0;
      c:=Words[2,i]+Words[2,i+1]+c;
      c:=(c+Ord(c mod 4 = 1+2*Ord(c>24))) div 2;
      RemarksBox.Items.AddObject(MCh(lNLem, Words[2,i])+MCh(lNLem, Words[2,i+1])+' contracts to '+MCh(lNLem, c)+'|'
        +Existence(False, caseW+Ord(Words[2,i]>12)+Ord(Words[2,i+1]>12)-Ord(c>12)), Pointer(clWindowText));
      Words[2,i]:=c;
      Delete(2, i+1);
    end;
  end;
  for i:=0 to WordLen[2]-2 do if (Words[2,i] in [26, 27, 28]) and (Words[2,i+1] in [24, 25]) and ((i=0) or (Words[2,i-1] in [8..23])) then begin {[*O]LN}
    if i=0 then st:='word boundary' else st:='obstruent '+MCh(lNLem, Words[2,i-1]);
    RemarksBox.Items.AddObject('Liquid '+MCh(lNLem, Words[2,i])+' between '+st+' and nasal '+MCh(lNLem, Words[2,i+1])
      +' eliminated'+'|'+Existence(False, caseL), Pointer(clWindowText));
    Delete(2, i);
  end;
  for i:=WordLen[2]-3 downto 0 do begin {epenthetic vowel}
    cl:=0;
    while Words[2,i+cl] in [8..28] do Inc(cl);
    if (cl>=4) or ((Words[2,i] in [18..23]) and (Words[2,i+1] in [8..17]) and (Words[2,i+2] in [18..23])) then begin
      if Words[2,i+2] in [18..23] then f:=2 else f:=1;
      c:=0;
      for j:=WordLen[2]-1 downto i+cl do if Words[2,j] in [0..7] then c:=Words[2,j];
      st:='';
      for j:=0 to cl-1 do st:=st+MCh(lNLem, Words[2,i+j]);
      RemarksBox.Items.AddObject('Epenthetic '+MCh(lNLem, c)+' breaks up cluster '+st+'|'+Existence(True, c), Pointer(clWindowText));
      Insert(2, i+f, c);
    end;
  end;
  for i:=WordLen[2]-2 downto 0 do begin {anticipatory}
    if (Words[2,i] in [8..12]) and (Words[2,i+1] in [21..23]) then j:=caseW else if (Words[2,i] in [13..17]) and (Words[2,i+1] in [18..20]) then j:=caseF else
      if (Words[2,i] in [18..20]) and (Words[2,i+1] in [13..17]) then j:=caseB else if (Words[2,i] in [21..23]) and (Words[2,i+1] in [8..12]) then j:=caseP
      else j:=0;
    if j<>0 then begin
      RemarksBox.Items.AddObject('Anticipatory assimilation of '+MCh(lNLem, Words[2,i])+MCh(lNLem, Words[2,i+1])+'|'
        +VoiceChange(True, j), Pointer(clWindowText));
      Words[2,i]:=Words[2,i]+addJ[j];
    end;
  end;
  for i:=0 to WordLen[2]-3 do if (Words[2,i] in [8..23]) and {vowel rounding/raising}
      (((Words[2,i+1] in [24, 25]) and (Words[2,i+2] in [0, 1, 4, 5])) or ((Words[2,i+1] in [26..28]) and (Words[2,i+2] in [0..3]))) then begin
    RemarksBox.Items.AddObject('Vowel '+MCh(lNLem, Words[2,i+2])+' '+VposStr[Words[2,i+1] in [24, 25]]+' ('+MCh(lNLem, Words[2,i])+MCh(lNLem, Words[2,i+1])+')|'
      +PosChange(True, Words[2,i+2], Words[2,i+2]+2+2*Ord(Words[2,i+1] in [26..28])), Pointer(clWindowText));
    Words[2,i+2]:=Words[2,i+2]+2+2*Ord(Words[2,i+1] in [26..28]);
  end;
  for i:=WordLen[2]-2 downto 0 do if (Words[2,i] in [8..17]) and (Words[2,i+1] in [8..17]) and (Abs(Words[2,i]-Words[2,i+1])=5) then begin
    RemarksBox.Items.AddObject(MCh(lNLem, Words[2,i])+MCh(lNLem, Words[2,i+1])+' simplifies|'+Existence(False, caseW+Ord(Words[2,i] in [13..17])), Pointer(clWindowText));
    Delete(2, i);
  end;
  if SmallInt(Ending[0])>-1 then begin
    Ending[2]:=WordLen[2];
    Add(2, 0);
  end;
end; {LMToNLem}

procedure ModLemPhonotactics;
const
  MatchP: array[8..17] of Byte = (18, 19, 19, 19, 20, 21, 22, 22, 22, 23);
  ToF:    array[8..17] of Byte = ( 9,  8,  8,  8, 11, 14, 13, 13, 13, 16);
var
  i, d: Integer;
  st: string;
begin
  for i:=0 to WordLen[2]-1 do begin
    st:='Dissimilation of '+MCh(lNLem, Words[2,i-1])+MCh(lNLem, Words[2,i])+'|';
    case Words[2,i] of
      8..17: if Words[2,i-1]=MatchP[Words[2,i]] then begin
        RemarksBox.Items.AddObject(st+PosChange(False, caseW+Ord(Words[2,i]>=13), caseW+Ord(Words[2,i]>=13)), Pointer(clWindowText));
        Words[2,i]:=ToF[Words[2,i]];
      end;
      24, 25: if Words[2,i-1] in [2*Words[2,i]-30, 2*Words[2,i]-27] then begin
        RemarksBox.Items.AddObject(st+PosChange(False, caseB+Ord(Words[2,i-1]>=21), caseB+Ord(Words[2,i-1]>=21)), Pointer(clWindowText));
        Words[2,i-1]:=Words[2,i-1] div 3 *3 +1;
      end;
      27: if Words[2,i-1]=22 then begin
        RemarksBox.Items.AddObject(st+PosChange(False, caseP, caseP), Pointer(clWindowText));
        Words[2,i-1]:=21;
      end;
      28: if Words[2,i-1] in [19, 22] then begin
        RemarksBox.Items.AddObject(st+PosChange(False, caseB+Ord(Words[2,i-1]=22), caseB+Ord(Words[2,i-1]=22)), Pointer(clWindowText));
        Words[2,i-1]:=Words[2,i-1]-1;
      end;
    end;
  end;
  i:=0; d:=0;
  while i+d<WordLen[2] do begin
    if d>0 then WordsStressDia[2, i, GetStressDia(2, i+d)]:=Words[2,i+d];
    if (Words[2,i]>=8) and (Words[2,i]=Words[2,i+1+d]) then Inc(d) else Inc(i);
  end;
  WordCut(2, d);
end; {ModLemPhonotactics}

procedure Poststem;
const fric: array[8..28] of Byte = (13, 14, 15, 16, 17, 8, 9, 10, 11, 12, 21, 22, 23, 18, 19, 20, 8, 12, 9, 10, 8);
      gramm: array[3..5] of Byte = (9, 8, 15);
var
  i, j, p, pr, r, r2, rn: Integer;
  remst: string;
  b: Boolean;
begin
  rn:=RemarksBox.Items.Count;
  p:=100000;                                                  {0: No PR; 1: Regular PR; 2: Masc/Fem; 3: Sg; 4: Pl; 5: Resultative}
  for i:=0 to WordLen[2]-1 do if Words[2,i]<=7 then p:=i;
  pr:=ShowComboBox(WordLen[2]>0, 1); 
  if (pr in [0, 3, 4, 5]) or (p=100000) then begin
    Add(2, 0);
    if pr>=3 then Add(2, gramm[pr]);
    RemarksBox.Items.AddObject(IfThen(pr>=3, 'Grammatigenic', 'No')+' poststem|(Poststem)', Pointer(clWindowText));
    if pr>=3 then RemarksBox.Items.AddObject(UpperCaseFirst(Copy(ComboBox.Items[pr], 17, MaxInt))+' meaning', Pointer(clWindowText));
  end else begin
    Words[2,p]:=0;
    r:=-1;   r2:=-1;
    for i:=p+1 to WordLen[2]-1 do if Words[2,i] in [24..28] then if r=-1 then r:=i else if r2=-1 then r2:=i;
    if r>p+1 then begin
      remst:='apocope of '+MCh(lNLem, Words[2,r]);
      WordLen[2]:=r;
    end else if r>-1 then begin
      i:=p-1;   j:=0;
      while Words[2,i] in [8..23] do begin
        if (Words[2,i] in [8..12]) or ((j=0) and (Words[2,i] in [13..17])) then Inc(j);
        Dec(i);
      end;
      if ((Words[2,i] in [24..28]) and (Words[2,r] in [24, 25])) or (Words[2,i] in [26..28]) or (r2>-1) or ((j>=2) and (Words[2,p+1] in [24..28])) then begin
        if r2>-1 then begin
          remst:='apocope of '+MCh(lNLem, Words[2,r2])+', ';
          WordLen[2]:=r2;
        end else remst:='';
        if (WordLen[2]<=r+2) then begin
          Words[2,r]:=fric[Words[2,r]];
          remst:=remst+'fortition';
          if Words[2,r+1] in [21..23] then begin
            RemarksBox.Items.AddObject('Anticipatory assimilation of '+MCh(lNLem, Words[2,r])+MCh(lNLem, Words[2,r+1])+'|'+VoiceChange(True, caseW), Pointer(clWindowText));
            Words[2,r]:=Words[2,r]+5;
          end;
        end else begin
          b:=(Words[2,r]=24) and (Words[2,r+1]=18) or (Words[2,r]=25) and (Words[2,r+1]=20);
          remst:='elision of '+MCh(lNLem, Words[2,r])+IfThen(b, MCh(lNLem, Words[2,r+1]));
          Delete(2, r);
          if b then Delete(2, r);
        end;
      end else begin
        Words[2,p]:=Words[2,r];
        Words[2,r]:=0;
        remst:='metathesis';
      end;
    end else remst:='typical form';
    p:=WordLen[2]-1;
    while (Words[2,p]>0) and (p>-1) do Dec(p);
    if WordLen[2]>p+3 then begin
      WordLen[2]:=p+3;
      remst:=remst+', apocope of obstruent';
    end;
    RemarksBox.Items.InsertObject(rn, 'Lexicogenic '+Copy('pseudo-', 1, 7*Ord(WordsB[2,1]=0))+'poststem with '+remst+'|(Poststem)', Pointer(clWindowText));
  end;
  p:=WordLen[2]-1;
  while (Words[2,p]>0) and (p>-1) do Dec(p);
  SetStress(2, p, stIs1, False);
  if pr=2 then if p<WordLen[2]-1 then begin
    if p>0 then begin
      RemarksBox.Items.AddObject('Feminisation', Pointer(clWindowText));
      WordLen[2]:=p+1;
    end else RemarksBox.Items.AddObject('Feminisation impossible!', Pointer(clRed));
  end else begin
    r:=-1;  b:=False;
    for i:=p-1 downto 0 do if Words[2,i]>7 then r:=i else b:=True;
    if r>-1 then begin
      if (Words[2,r] in [24..28]) or not b then Add(2, fric[Words[2,r]]) else Add(2, Words[2,r]);
      RemarksBox.Items.AddObject('Masculinisation (or clarification)|Masculinisation', Pointer(clWindowText));
    end else RemarksBox.Items.AddObject('Masculinisation impossible!', Pointer(clRed));
  end;
  i:=0;
  while (Words[2,i]>7) and (i<=WordLen[2]) do Inc(i);
  if i>3 then RemarksBox.Items.AddObject('Initial cluster of '+IntToStr(i)+': try avoiding poststem!', Pointer(clRed));
end; {Poststem}

procedure NToModLem;
var i: Integer;
begin
  for i:=0 to Min(WordLen[0], Ending[0])-1 do Add(2, Words[0,i]);
  Poststem;
  ModLemPhonotactics;
end; {NToModLem}

procedure OLemToVolg;
var i, p: Integer;             // Sememshifts umgekehrt?
begin
  OLemXh;
  for i:=0 to WordLen[1]-1 do begin
    case Words[1,i] of
      0:;
      else //Add(2, A[Words[1,i]]);
    end;
  end;
  p:=ShowComboBox(Ending[0]=WordLen[0], 7);
  if ComboBox.Visible then begin
    Ending[2]:=WordLen[2];
    case p of
      0: ; // verb
      1: ; // masc. nominal
      2: ; // fem. nominal         (are they distinguished in Volg??)
      3: ; // neut. nominal
    end;
  end;
//  RemarksBox.Items.AddObject('Cave morphology!', Pointer(clRed));
  RemarksBox.Items.AddObject('Old Lemizh > Volgian not implemented yet!', Pointer(clRed));
end; {OLemToVolg}

procedure VolgToNLem;
var i: Integer;
begin
  for i:=0 to WordLen[0]-1 do begin
    case Words[0,i] of
      0: ;
      else //Add(2, A[Words[0,i]]);
    end;
  end;
  RemarksBox.Items.AddObject('Volgian > Early New Lemizh not implemented yet!', Pointer(clRed));
end; {VolgToNLem}

{--------------------------------------------------Loans with non-Lemizh targets---------------------------------------------}

procedure OLemToEHell;
const A: array[0..32] of Byte = (0, 8, 18, 30, 4, 8, 19, 31, 32, 34, 34, 34, 8, 7, 21, 27, 27, 27, 11, 11, 2, 3, 6, 20, 28, 10, 14, 16, 25, 7, 12, 5, 9);
var i, j, p: Integer;
begin
  OLemXh;
  j:=-1;
  for i:=0 to WordLen[1]-1 do if Words[1,i] in [0..7, 31, 32] then
    if (j=-1) or (Words[1,j]<=5) or (Words[1,i] in [6, 7, 31, 32]) then j:=i;
  for i:=0 to WordLen[1]-1 do begin                                   
    case Words[1,i] of
      12: if ((Words[1,i-1]<>5) and (Words[1,i+1]<>5)) then Add(2, A[Words[1,i]]);
      13, 18, 19, 29: if (i=0) and (Words[1,1] in [0..7, 12, 31, 32]) then Add(2, 7) else if Words[1,i] in [18, 19] then Add(2, A[Words[1,i]]);
      26, 27, 28, 30: Add(2, A[Words[1,i]]+Ord((Words[1,i-1] in [9..11, 14..17, 20..30]) and (Words[1,i+1] in [9..11, 14..28, 30])));
      else Add(2, A[Words[1,i]]);
    end;
    if i=j then SetStress(2, i, stIs1, False);
  end;
  j:=0;
  for i:=WordLen[2]-1 downto 0 do if Words[2,i] in [0, 1, 4, 5, 8, 9, 13, 15, 17, 18, 19, 26, 30, 31] then j:=0 else begin
    Inc(j);
    if (j>2) and not ((Words[2,i]=16) and (Words[2,i+1]=6)) then Delete(2, i+1);
  end;
  p:=ShowComboBox(Ending[0]=WordLen[0], 7);
  if ComboBox.Visible then begin
    Ending[2]:=WordLen[2];
    case p of
      0: Add(2, 19);
      1: begin Add(2, 18); Add(2, 27); end;
      2: Add(2, 1);
      3: begin Add(2, 18); Add(2, 16); end;
    end;
  end;
end; {OLemToEHell}

procedure OLemToPrWald;
const A: array[0..32] of Byte = (0, 11, 19, 27, 6, 11, 21, 27, 29, 31, 24, 30, 11, 0, 32, 24, 24, 25, 10, 10, 2, 4, 8, 22, 26, 15, 17, 18, 23, 10, 16, 7, 12);
var i, p: Integer;
    stress, l, long: Boolean;
begin
  OLemXh;
  stress:=False;
  long:=False;
  for i:=0 to WordLen[1]-1 do begin
    case Words[1,i] of
      10: if Words[1,i+1] in [14..19, 23..25, 29] then Add(2, 24) else Add(2, 30);
      12: if Words[1,i+1] in [0, 2, 3, 6, 7, 255] then Add(2, 11);
      13: ; {gh}
      18, 19, 29: if not (WordsB[2,1] in [3, 5, 9, 10, 15, 22, 26]) then Add(2, 10);
      else Add(2, A[Words[1,i]]);
    end;
    l:=(Words[1,i] in [6, 7, 31, 32]) or ((Words[1,i] in [0..7, 31, 32]) and (Words[1,i+1] in [0..7, 31, 32]));
    if (((Words[1,i] in [0..5]) and not long) or l) and not (Words[1,i-1] in [0..7, 31, 32]) then begin
      SetStress(2, WordLen[2]-1, stIs1, False);
      stress:=True;
    end;
    if l then long:=True;
  end;
  p:=ShowComboBox(Ending[0]=WordLen[0], 7);
  if ComboBox.Visible then begin
    Ending[2]:=WordLen[2];
    case p of
      0: Add(2, 19);
      1: begin Add(2, 0); Add(2, 24); end;
      2, 3: Add(2, 0);
    end;
    if not stress then SetStress(2, WordLen[2]-1, stIs1, False);
  end;
end; {OLemToPrWald}


procedure PIEtoPrCelt;
const A: array[0..47] of Byte = (4, 10, 0, 1, 16, 1, 24, 9, 22, 20, 14, 14, 15, 15, 17, 117, 13, 113, 18, 18, 18, 18, 0, 0, 0, 0, 0, 0, 6, 2, 2,
  19, 3, 3, 11, 7, 7, 11, 7, 7, 12, 2, 8, 0, 10, 21, 19, 3);
var                                 
  i, j: Integer;
  b: Boolean;
begin
  PIEStem(lPrCelt);
  PIEChanges(lPrCelt);
  if Words[1,1] in [46, 49, 52, 55 ,58] then Words[1,1]:=Words[1,1]-18;
  for i:=0 to WordLen[1]-1 do begin
    if not (Words[1,i] in [22, 24, 26]) then Add(2, A[Words[1,i]]) else RemarksBox.Items.AddObject(MCh(lPIE, Words[1,i])+'-loss|(Internal late PIE shift)', Pointer(clWindowText));
    case Words[1,i] of
      1, 3, 5: if Words[1,i+1] in [6, 8] then WordsB[2,1]:=A[Words[1,i]-1] else if Words[1,i]=5 then begin
        b:=True;
        for j:=i+2 to WordLen[1]-1 do if Words[1,j] in [0..5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 43..45] then b:=False;
        if b then WordsB[2,1]:=21;
        RemarksBox.Items.AddObject(MCh(lPIE, 5)+' becomes '+MCh(lPrCelt, WordsB[2,1])+' in '+Copy('non-', 1, 4*Ord(not b))+'final syllable|'+PosChange(True, caseO, IfThen(b, caseU, caseA)), Pointer(clWindowText));
      end;
      6, 8: if (Words[1,i-1] in [0, 1]) and (Words[1,i]=6) then begin
        Delete(2, WordLen[2]-1);
        WordsB[2,1]:=5;
      end else if Words[1,i-1] in [0..5] then begin
        WordsB[2,1]:=9+11*Ord(Words[1,i]=8);
        if Words[1,i-1] in [0, 1] then WordsB[2,2]:=16;
      end;
      11, 13, 15, 17, 19, 21: if Words[1,i+1] in [22, 24, 26] then begin
        WordsB[2,1]:=WordsB[2,1] mod 100;
        Add(2, Ord(Words[1,i+2] in [6, 8, 10, 12, 14, 16, 255]));
      end else if not (Words[1,i] in [15, 17]) then Insert(2, WordLen[2]-1, 0);
      28: begin
        b:=False;
        for j:=i+1 to WordLen[1]-1 do if Words[1,j]=40 then b:=True;
        if b then begin
          RemarksBox.Items.AddObject(MCh(lPIE, 28)+'...'+MCh(lPIE, 40)+' assimilates to '+MCh(lPrCelt, 12)+'...'+MCh(lPrCelt, 12)+'|'+PosChange(True, caseP, caseP), Pointer(clWindowText));  
          WordsB[2,1]:=12;
        end;
      end;
    end;
    if Ending[1]=i then Ending[2]:=WordLen[2]-1;
    if GetStress(1, i, stIs1)=stIs1 then SetStress(2, WordLen[2]-1, stIs1, False); 
  end;
  for i:=WordLen[2]-1 downto 0 do case Words[2,i] of
    6, 11: if Words[2,i+1] in [18, 19] then Words[2,i]:=23;
    20: if (Words[2,i+1]=22) and (Words[2,i+2]=0) then begin
      RemarksBox.Items.AddObject(MCh(lPrCelt, 20)+' becomes '+MCh(lPrCelt, 16)+' before '+MCh(lPrCelt, 22)+MCh(lPrCelt, 0)+'|'+PosChange(False, caseU, caseO), Pointer(clWindowText));  
      Words[2,i]:=16;
    end;
    113, 117: begin
      Words[2,i]:=Words[2,i]-100;
      if Words[2,i+1] in [2, 3, 7, 8, 11, 12, 19] then Insert(2, i+1, 9) else Insert(2, i, 0);
    end;
  end;
  
  // see https://en.wikipedia.org/wiki/Proto-Celtic_language !
  // -DSD- > -ss-
  // to be confirmed: rs>rr, ls>ll, VslV>ll, VsnV>nn, ln>ll, VsmV>mm, wn>bn; weitere?

  if Ending[1]=WordLen[1] then Ending[2]:=WordLen[2];
  RemarksBox.Items.AddObject('Proto-Indo-European > Proto-Celtic not finished yet!', Pointer(clRed));
end; {PIEtoPrCelt}

procedure PrCeltX;
var i: Integer;
begin
  for i:=0 to WordLen[0]-1 do if (Words[0,i]=23) and not (Words[0,i+1] in [18, 19]) and (RemarksBox.Items.Count<=1) then
    RemarksBox.Items.AddObject('Proto-Celtic '+MCh(lPrCelt, 23)+' only occurs before '+MCh(lPrCelt, 18)+' and '+MCh(lPrCelt, 19), Pointer(clRed));
end; {PrCeltX}

procedure PrCeltToMLem;
const A: array[0..24] of Byte = (0, 0, 20, 19, 1, 1, 17{phi}, 18, 18, 3, 3, 21, 18, 28, 25, 24, 4, 26, 15, 22, 6, 6, 12, 13, 8);
var i: Integer;
begin
  PrCeltX;
  for i:=0 to Min(WordLen[0], Ending[0])-1 do begin
    Add(2, A[Words[0,i]]);
    case Words[0,i] of
      1, 5, 10: Add(2, A[Words[0,i]]);
      8, 12: Add(2, 12);
    end;
  end;
  If Ending[0]<Word(-1) then begin
    Ending[2]:=WordLen[2];
    if not ((Ending[0]=WordLen[0]-1) and (WordsB[0,1] in [1, 18]) or (Ending[0]=WordLen[0]-2) and (WordsB[0,2]=16) and (WordsB[0,1]=18))
        then Add(2, 0) else if Ending[0]<WordLen[0] then begin
      Add(2, 2);
      Add(2, 26);
    end;
  end;
end; {PrCeltToMLem}

procedure PreHarmonyBeskTest(n: Integer);
begin
  if (Words[2,n] in [2..5, 24]) then RemarksBox.Items.AddObject('No '+MCh(lBesk, Words[2,n])+' allowed in pre–vowel harmony Beskidic! (likely a bug)', Pointer(clRed));
end; {PreHarmonyBeskTest}

procedure PrCeltToBesk;
const A: array[False..True] of array[0..24] of Byte = ((0, 1, 25, 29, 8, 9, 0, 17, 11, 15, 16, 17, 25, 18, 20, 21, 23, 26, 28, 29, 30, 31, 10, 32, 33),
                                                       (0, 1,  6,  7, 8, 9, 0, 11, 12, 15, 16, 32, 10, 19, 22, 21, 23, 27, 32, 28, 30, 31,  0, 32,  0));
  celtVowels = [0, 1, 4, 5, 9, 10, 16, 20, 21];
  beskVowels = [0..5, 8, 9, 15, 16, 23, 24, 30, 31];
  beskVowelValues: array[0..31] of Integer = (caseA, caseA, caseE, caseE, caseO, caseO, 0, 0, caseE, caseE, 0, 0, 0, 0, 0, caseI, caseI, 0, 0, 0, 0, 0, 0, caseO, caseO, 0, 0, 0, 0, 0, caseU, caseU);
  beskVowelPrimes: array[0..31] of Integer = (5, 25, 0, 0, 0, 0, 0, 0, 7, 49, 0, 0, 0, 0, 0, 11, 121, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 2, 4);
  beskHarmonies: array[0..11] of Integer = (0, 1500, 4, 3004, 15, 8, 1508, 23, 1523, 2, 3002, 30);
  beskIntervals: array[0..11] of string  = ('unison', 'minor second', 'major second', 'minor third', 'major third', 'perfect fourth', 'tritone', 'perfect fifth',
    'minor sixth', 'major sixth', 'minor seventh', 'major seventh');
var
  h, i, j: Integer;
  len: Boolean;
  st1, st2: string;
begin
  PrCeltX;
  if Words[0,0] in celtVowels then Insert(2, 0, 14);
  for i:=0 to WordLen[0]-1 do Add(1, Words[0,i]);
  if CheckBox.Checked and CheckBox.Visible then begin
    WordCut(1, 1);
    WordsB[1,1]:=1;
  end;
  for i:=0 to WordLen[1]-1 do begin
    len:=not (Words[1,i] in celtVowels) and (Words[1,i-1] in celtVowels);
    if (Words[1,i] in [12, 22]) and ((Words[1,i-1] in [1, 5, 10, 16, 21]) or ((i=0) and (Words[1,1] in [1, 5, 10, 16, 21]))) then Add(2, IfThen(Words[1,i]=12, 32, 13))
      else if Words[1,i]<>6 then Add(2, A[len, Words[1,i]]);
    case Words[1,i] of
      11, 12, 19: if not len then begin
        if (Words[1,i]=12) and (WordsB[2,1]=34) then WordsB[2,1]:=19;
        Add(2, A[True, Words[1,i]]);
      end;
      22, 24: if len then begin
        Delete(2, WordLen[2]-1);
        if Words[1,i]=24 then if WordLen[2]=0 then Add(2, 34) else WordsB[2,1]:=WordsB[2,1]+1;
      end;
    end;
    if (Words[1,i]=Words[1,i+1]) and not (Words[1,i] in celtVowels) then begin
      Add(2, 90);
      RemarksBox.Items.AddObject('Insertion of epenthetic '+MCh(lBesk, 2)+'|'+Existence(True, caseE), Pointer(clWindowText));
    end;
  end;
  i:=WordLen[2];
  repeat Dec(i) until (i<0) or (Words[2,i] in beskVowels);
  if i>1 then begin
    j:=i;
    repeat Dec(j) until (j<0) or (Words[2,j] in beskVowels);
    PreHarmonyBeskTest(j);
    PreHarmonyBeskTest(i);
    h:=0;
    if j>0 then begin
      st1:=MCh(lBesk, Words[2,j])+'+'+MCh(lBesk, Words[2,i]);
      h:=beskVowelPrimes[Words[2,j]]*beskVowelPrimes[Words[2,i]];
      st2:=IntToStr(beskVowelPrimes[Words[2,j]])+' × '+IntToStr(beskVowelPrimes[Words[2,i]])+' = '+IntToStr(h);
      if h>0 then h:=Round(12*Log2(h)) mod 12;
      st2:=st2+' -> '+beskIntervals[h];
      h:=beskHarmonies[h];
      Words[2,j]:=h mod 100;
      if h>99 then Insert(2, j+1, h div 100);
      RemarksBox.Items.AddObject('Vowel harmony: '+st1+' -> '+MCh(lBesk, Words[2,j])+IfThen(h>99, MCh(lBesk, Words[2,j+1]))+'|Interval: '+st2, Pointer(clWindowText));
    end;
    WordLen[2]:=i+Ord(h>99);
    if Words[2,j-1] in beskVowels then begin
      RemarksBox.Items.AddObject('Elimination of first diphthong vowel '+MCh(lBesk, Words[2,j-1])+' in harmony|'+Existence(False, beskVowelValues[Words[2,j-1]]), Pointer(clWindowText));
      Delete(2, j-1);
    end;
  end;
  for i:=1 to WordLen[2]-1 do if Words[2,i]=90 then Words[2,i]:=2;
  if (WordsB[1,2]=14) and (WordsB[1,1]=9) and (Ending[0]=WordLen[1]-2) then Ending[2]:=WordLen[2]-1;
  if Words[2,0]=13 then Delete(2, 0);
  CheckBox.Caption:=CheckBoxCaptions[4];
  CheckBox.Hint:=CheckBoxHints[4];
  CheckBox.Visible:=(Ending[0]=WordLen[0]-2) and (WordsB[0,2]=16) and (WordsB[0,1]=18);
end; {PrCeltToBesk}

procedure BeskToNLem;
const A: array[0..34] of Byte = (0, 0, 1, 1, 4, 4, 20, 19, 1, 1, 17, 18, 8, 13, 0, 3, 3, 21, 28, 28, 25, 24, 24, 4, 4, 23, 26, 27, 15, 22,
  6, 6, 13, 8, 0);
var i: Integer;
begin
  for i:=0 to Min(WordLen[0], Ending[0])-1 do case Words[0,i] of
    14, 34: ;
    8, 15: if Words[0,i+1] in [19, 27] then Add(2, IfThen(Words[0,i]=8, 0, 2)) else Add(2, A[Words[0,i]]);
    else Add(2, A[Words[0,i]]);
  end;
  CheckBox.Visible:=Ending[0]>WordLen[0];
  if CheckBox.Visible then begin
    CheckBox.Caption:=CheckBoxCaptions[5];
    CheckBox.Hint:=CheckBoxHints[5];
  end;
  if (CheckBox.Visible and CheckBox.Checked) or (Ending[0]<=WordLen[0]) then begin
    if WordsB[2,1] in [0..7] then WordLen[2]:=WordLen[2]-1;
    Ending[2]:=WordLen[2];
    Add(2, 0);
  end;
end; {BeskToNLem}

{--------------------------------------------------Loans with non-Lemizh targets---------------------------------------------}



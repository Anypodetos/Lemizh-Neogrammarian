procedure PIEtoPrWald;
const A: array[0..47] of Byte = (6, 7, 0, 1, 19, 19, 26, 11, 29, 27, 17, 17, 18, 18, 23, 23, 16, 16, 24, 25, 23, 30, 0, 0, 0, 0, 0, 0, 22, 2, 3,
  26, 4, 5, 25, 13, 14, 15, 8, 9, 15, 8, 9, 0, 12, 28, 25, 30);
var i: Integer;
begin
  PIEStem(lPrWald);
  PIEChanges(lPrWald);
  if Words[1,1] in [46, 49, 52, 55 ,58] then Words[1,1]:=Words[1,1]-18;
  for i:=0 to WordLen[1]-1 do begin
    if Words[1,i] in [11, 13, 15, 17, 19, 21] then
      if (Words[1,i] in [11, 13, 19, 21]) or (Words[1,i-1] in [18, 19, 22..27, 31, 30, 33, 36, 39]) then Add(2, 11)
        else Add(2, 19*Ord(Words[1,i-1] in [8, 40, 41, 42]));
    case Words[1,i] of
      0, 2, 3, 4: if (Words[1,i-1] in [8, 40, 41, 42]) and not ((i=WordLen[1]-2) and (Words[1,i+1]=18)) then begin
        Add(2, 19+2*Ord(Words[1,i]=0));
        RemarksBox.Items.AddObject(MCh(lPIE, Words[1,i])+' rounded after '+MCh(lPIE, Words[1,i-1])+'|'+LabialChange(True, IfThen(Words[1,i]=0, caseE, caseA)), Pointer(clWindowText));
      end else Add(2, 6*Ord(Words[1,i]=0));
      6: if not (Words[1,i-1] in [0..5]) or (Words[1,i+1] in [0..5, 7, 9, 11, 13, 15, 17]) then begin
        if i=0 then Add(2, 26) else Add(2, 10);
      end else if Words[1,i-1]=0 then WordsB[2,1]:=6 else if Words[1,i-1] in [2..5] then WordsB[2,1]:=19*Ord(Words[1,i-2] in [8, 40, 41, 42])+1;
      8: if not (Words[1,i-1] in [0..5]) or (Words[1,i+1] in [0..5, 7, 9, 11, 13, 15, 17]) then begin
        if i=0 then Add(2, 8);
        Add(2, 29);
      end else if Words[1,i-1] in [0, 1] then WordsB[2,1]:=21 else if Words[1,i-1] in [2..5] then WordsB[2,1]:=20;
      18, 20: if Words[1,i-1] in [6..9, 14, 15, 34, 37] then begin
        RemarksBox.Items.AddObject('ruki rule: '+MCh(lPIE, Words[1,i])+' shifts to '+MCh(lPrWald, 25+5*Ord(Words[1,i]=20))+'|'
          +PosChange(True, caseW+Ord(Words[1,i]=18), caseW+Ord(Words[1,i]=18)), Pointer(clWindowText));
        Add(2, 25+5*Ord(Words[1,i]=20));
      end else Add(2, 24-Ord(Words[1,i]=20));
      31..33: if (Words[1,i+1] in [12, 14, 18, 20]) and not (Words[1,i+2] in [0..5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 255]) then
        RemarksBox.Items.AddObject('Dental plosive '+MCh(lPrWald, A[Words[1,i]])+' eliminated before '+MCh(lPrWald, A[Words[1,i+1]])+'-cluster|'
          +Existence(False, caseB+Ord(Words[1,i]=31)), Pointer(clWindowText))
        else if (Words[1,i]=33) and (Words[1,i-1] in [10..13]) then begin
          RemarksBox.Items.AddObject(MCh(lPIE, 33)+' loses aspiration after nasal '+MCh(lPIE, Words[1,i-1])+'|'+AspirationChange(True, caseB), Pointer(clWindowText));
          Add(2, 4);
        end else Add(2, A[Words[1,i]]);
      30, 36, 39: if Words[1,i-1] in [10..13] then begin
        RemarksBox.Items.AddObject(MCh(lPIE, Words[1,i])+' loses aspiration after nasal '+MCh(lPIE, Words[1,i-1])+'|'+AspirationChange(True, caseB), Pointer(clWindowText));
        Add(2, A[Words[1,i]-1])
      end else Add(2, A[Words[1,i]]);
      22..27, 43: RemarksBox.Items.AddObject(MCh(lPIE, Words[1,i])+'-loss|(Internal late PIE shift)', Pointer(clWindowText));
      else Add(2, A[Words[1,i]]);
    end;
    if GetStress(1, i, stIs1)=stIs1 then SetStress(2, WordLen[2]-1, stIs1, False);
    case WordsB[2,1] of
      2, 3, 22: if WordsB[2,2] in [0, 1] then begin
        RemarksBox.Items.AddObject(MCh(lPrWald, WordsB[2,2])+MCh(lPrWald, WordsB[2,1])+' diphthongises|'+TypeChange(True, caseB+Ord(WordsB[2,1]=22), caseU), Pointer(clWindowText));
        WordsB[2,2]:=0;
        if WordsB[2,1]<>2 then Add(2, 10);
        WordsB[2, Ord(WordsB[2,1]<>2)+1]:=27;
      end;
      16: if WordsB[2,2] in [3, 5, 9, 15, 22, 26, 255] then begin
        WordsB[2,1]:=23;
        if WordsB[2,2]=255 then RemarksBox.Items.AddObject('Initial '+MCh(lPrWald, 16)+' shifts to '+MCh(lPrWald, 23)+'|'+TypeChange(False, caseL, caseL), Pointer(clWindowText))
          else RemarksBox.Items.AddObject(MCh(lPrWald, 16)+' shifts to '+MCh(lPrWald, 23)+' after aspirate '+MCh(lPrWald, WordsB[2,2])+'|'+TypeChange(False, caseL, caseL), Pointer(clWindowText));
      end;
      8, 9, 15: if WordsB[2,2] in [6, 7] then begin
        RemarksBox.Items.AddObject(MCh(lPrWald, WordsB[2,2])+MCh(lPrWald, WordsB[2,1])+' diphthongises|'+TypeChange(True, caseB+Ord(WordsB[2,1]=15), caseI), Pointer(clWindowText));  
        WordsB[2,2]:=6;
        if WordsB[2,1]<>8 then Add(2, 10);
        WordsB[2, Ord(WordsB[2,1]<>8)+1]:=11;
      end;
      10: if WordsB[2,2] in [2..5, 8, 9] then begin
        if WordsB[2,2] in [2, 4, 8] then WordsB[2,2]:=WordsB[2,2]+1;
        Delete(2, WordLen[2]-1);
      end;
    end;
    if Ending[1]=i then Ending[2]:=WordLen[2]-1;
  end;
  if (WordsB[2,1] in [16, 17, 18, 23]) then begin
    RemarksBox.Items.AddObject('Loss of final continuant '+MCh(lPrWald, WordsB[2,1])+'|'+Existence(False, IfThen(WordsB[2,1] in [16, 23], caseL, caseN)), Pointer(clWindowText));
    if Ending[2]=WordLen[2]-1 then Ending[2]:=Word(-1);
    WordCut(2, 1);
  end;       
  Anticipatory(lPrWald, 2, [30, 2, 3, 4, 5, 8, 9, 13, 14, 29], [25], [caseW, caseB, caseB, caseB, caseB, caseB, caseB, caseBW, caseBW, caseW]);
end; {PIEtoPrWald}

procedure PrWaldToOLem;
const A: array[0..32] of Byte = (0, 0, 20, 20, 21, 21, 4, 31, 22, 22, 29, 5, 32, 10, 11, 25, 30, 26, 27, 2, 2, 6, 23, 28, 16, 17, 24, 3, 3, 8, 11, 9, 14);
var i: Integer;
begin
  MustHaveStress;
  for i:=0 to Min(WordLen[0], Ending[0])-1 do begin
    if Words[0,i] in [13, 14] then Add(2, 21);
    Add(2, A[Words[0,i]]);
  end;
  if Ending[0]<>Word(-1) then Ending[2]:=WordLen[2];
end; {PrWaldToOLem}

procedure PrWaldToElb;
const A: array[0..32] of Byte = (0, 0, 1, 23, 0, 5, 6, 0, 0, 9, 10, 11, 11, 12, 3, 0, 14, 15, 0, 17, 17, 17, 7, 18, 19, 20, 21, 22, 22, 23, 20, 5, 7);
      vowels = [0, 1, 6, 7, 11, 12, 19, 20, 21, 27, 28];
var i, c: Integer;
    v: array of Byte;
begin
  MustHaveStress;
  SetLength(v, WordLen[0]+1);  {0: consonant, 1: unstressed, 2: long, 3: stressed, 4: 1st vowel of diphthong}
  for i:=0 to WordLen[0]-1 do if not (Words[0,i] in vowels) then v[i]:=0 else if Words[0,i] in [1, 7, 12, 20, 21, 28] then v[1]:=2 else
    if GetStress(0, i, stIs1)=stIs1 then v[i]:=3 else if Words[0,i+1] in vowels then v[i]:=4 else v[i]:=1;
  c:=0;
  for i:=0 to WordLen[0]-1 do begin
    if v[i]<>1 then begin
       if v[i]=4 then Add(1, Words[0,i]) {//shift diph} else Add(1, Words[0,i]);
       if v[i]>0 then c:=0;
    end else begin
      Inc(c);                                                                                 // CAVE KHINÉRA > XINARA !!!
      if c>1 then begin
        Add(1, Words[0,i]); // shift vowel  a>  e>  i>  o>  u>
        c:=0;
      end;
    end;
    if Ending[0]=i then Ending[1]:=WordLen[1]-1;
  end;
  for i:=0 to WordLen[1]-1 do begin
    case Words[1,i] of
      4: if Words[1,i+1] in [19..21, 27, 28] then Add(2, 21) else Add(2, 4);
      6: if (Words[1,i+1] in [16, 17, 18, 29]) or (i=WordLen[1]-1) then Add(2, 0) else Add(2, 6);
      8: case Words[1,i+1] of
        19..21, 27, 28: Add(2, 13);
        29: Add(2, 4);
        else Add(2, 8);
      end;
      15: if i=0 then Add(2, 24) else Add(2, 10);
      18: if Words[1,i+1]=26 then Add(2, 21) else Add(2, 16);
      else Add(2, A[Words[1,i]]);
    end;
    if Ending[1]=i then Ending[2]:=WordLen[2]-1;
  end;
  if Ending[0]=WordLen[0] then Ending[2]:=WordLen[2];
  if Words[2,0]=23 then Insert(2, 0, 4);
  // ths, ... > c; thsh > ch
  // glides (i, u)
  RemarksBox.Items.AddObject('Proto-Waldaiic > Old Elbic not finished yet!', Pointer(clRed));
end; {PrWaldToElb}

procedure ElbToLMLem;
const A: array[0..24] of Byte = (0, 20, 22, 22, 19, 11, 1, 17, 18, 8, 255, 3, 19, 21, 28, 25, 24, 4, 26, 15, 14, 22, 6, 12, 13);
var i: Integer;
begin
  for i:=0 to WordLen[0]-1 do begin
    if Words[0,i]<>10 then Add(2, A[Words[0,i]]);
    case Words[0,i] of
       2: Add(2, 15);
       3: Add(2, 14);
       12: Add(2, 10);
    end;
  end;                                                    
  // diphs; vowel clusters created by h > Ø
//  RemarksBox.Items.AddObject('Lemizh mobile accent not implemented yet!', Pointer(clRed));
  RemarksBox.Items.AddObject('Old Elbic > Late Middle Lemizh not finished yet!', Pointer(clRed));
end; {ElbToLMLem}

procedure PrWaldToEth;
const A: array[0..32] of Byte = (0, 1, 3, 4, 7, 8, 9, 10, 13, 14, 38, 17, 18, 20, 21, 22, 23, 24, 25, 28, 29, 11, 12, 31, 34, 32, 33, 35, 36, 12, 32, 34, 12);
      PrWVowels: set of Byte = [0, 1, 6, 7, 11, 12, 19, 20, 21, 27, 28];
      EthVowels: set of Byte = [0..2, 9..11, 17..19, 28..30, 35..37];
var s: TStress;
    i: Integer;
    st: string;
    b: Boolean;
begin
  MustHaveStress;
  if CheckBox.Checked and CheckBox.Visible then s:=stIs2 else s:=stIs1;
  for i:=0 to WordLen[0]-1 do begin
    case Words[0,i] of
       4: if (Words[0,i-1] in PrWVowels) and (Words[0,i+1] in PrWVowels+[23]) then Add(2, 31) else Add(2, A[Words[0,i]]);
       8, 9: Add(2, A[Words[0,i]+5*Ord(Words[0,i+1] in [6, 7, 11, 12])]);
      11: if Words[0,i-1]=6 then WordsB[2,1]:=11 else Add(2, A[Words[0,i]]);
      27: if Words[0,i-1]=0 then WordsB[2,1]:=2 else Add(2, A[Words[0,i]]);
      {Boil’s Dozen #1, #11}
      24: if Words[0,i+1]=22 then begin
        Add(2, 12);
        RemarksBox.Items.AddObject('Boil’s #1: *sph > f|Nabokov: Spring in Fialta', Pointer(clWindowText));
      end else if Words[0,i+1]=16 then begin
        if (i>0) then Add(2, 24);
        RemarksBox.Items.AddObject('Boil’s #11: *sl > m(m)|Nabokov: Scenes from the Life of a Double Monster', Pointer(clWindowText));
      end else Add(2, A[Words[0,i]]);
      22: if Words[0,i-1]<>24 then Add(2, A[Words[0,i]]);
      {BD #2, #3}
      32: if (i=0) or (Words[0,i+1] in [10, 15, 22, 24, 25, 26, 32]) then begin
        Add(2, 3);
        RemarksBox.Items.AddObject('Boil’s #2: *f > p (written b) word-initially and before unvoiced consonants|Nabokov: A Forgotten Poet', Pointer(clWindowText));
      end else begin
        Add(2, 23);
        RemarksBox.Items.AddObject('Boil’s #3: *f > l word-internally before voiced sounds|Nabokov: First Love', Pointer(clWindowText));
      end;
      {BD #4}
      12: if Words[0,i-1]=24 then begin
        Add(2, 35);
        RemarksBox.Items.AddObject('Boil’s #4: *si: > su > þu|Nabokov: Signs and Symbols', Pointer(clWindowText));
      end else Add(2, A[Words[0,i]]);
      {BD #5, #6, #9}
      31: if not (Words[0,i+1] in [0, 6]) then Add(2, A[Words[0,i]]) else if Words[0,i+1]=0 then RemarksBox.Items.AddObject('Boil’s #9: *ða > a|Nabokov: That in Aleppo Once …', Pointer(clWindowText));
      6: if Words[0,i-1]=31 then begin
           if Words[0,i+1] in [22, 23] then begin
             Add(2, 0);
             RemarksBox.Items.AddObject('Boil’s #5: *ðe > a before ph and r|Nabokov: The Assistant Producer', Pointer(clWindowText));
           end else begin
             Add(2, 2);
             RemarksBox.Items.AddObject('Boil’s #6: *ðe > aw|Nabokov: The Aurelian', Pointer(clWindowText));
           end;
         end else Add(2, A[Words[0,i]]);
      {BD #7, #8}
      15: if i=0 then begin
        Add(2, 3);
        RemarksBox.Items.AddObject('Boil’s #8: *kh > p (written b) word-initially|Nabokov: Conversation Piece, 1945', Pointer(clWindowText));
      end else if Words[0,i-1] in PrWVowels then begin
        if Words[0,i+1]<>16 then Add(2, 23);
        RemarksBox.Items.AddObject('Boil’s #7: *khl, *kh > l|Nabokov: Cloud, Castle, Lake', Pointer(clWindowText));
      end else Add(2, A[Words[0,i]]);
      {BD #10}
      26: if i>0 then begin
        Add(2, 3);
        RemarksBox.Items.AddObject('Boil’s #10: *th > b word-internally and word-finally|Nabokov: Time and Ebb', Pointer(clWindowText));
      end else Add(2, A[Words[0,i]]);
      {BD #11, #13, other things with l & r}
      16, 23: if (Words[0,i-1]=24) and (Words[0,i]=16) then Add(2, 24) else
        if (i=0) and (Words[0,1] in [1, 7, 12, 20, 28]) then Add(2, 15+Ord(Words[0,i]=23)) else
          if (i=1) and (Words[0,0] in [9, 10, 15]) then Words[2,0]:=15+Ord(Words[0,i]=23) else
            if (Words[0,i]=16) and (Words[0,i+1]=0) then RemarksBox.Items.AddObject('Boil’s #13: *l > Ø|Nabokov: Lance', Pointer(clWindowText)) else Add(2, A[Words[0,i]]);
      {BD #12}
      17: if Words[0,i+1]=0 then begin
        Add(2, 29);
        RemarksBox.Items.AddObject('Boil’s #12: *ma > õ|Nabokov: Mademoiselle O', Pointer(clWindowText));
      end else Add(2, A[Words[0,i]]);
      0:  if Words[0,i-1]<>17 then Add(2, A[Words[0,i]]);
      else Add(2, A[Words[0,i]]);
    end;
    if GetStress(0, i, stIs1)=stIs1 then SetStress(2, WordLen[2]-1, s, False);
  end;
  for i:=0 to WordLen[2]-3 do if not (Words[2,i+2] in EthVowels) then
      if(((Words[2,i] in [0, 28, 35]) and (Words[2,i+1]=31)) or ((Words[2,i] in [9, 17]) and (Words[2,i+1]=23))) then begin
    RemarksBox.Items.AddObject('Liquid diphthongisation: '+MCh(lEth, Words[2,i])+MCh(lEth, Words[2,i+1])+' > '+MCh(lEth, Words[2,i]+2)+'|'
      +TypeChange(True, caseL, IfThen(Words[2,i+1]=31, caseU, caseI)), Pointer(clWindowText));
    Words[2,i]:=Words[2,i]+2;
    Delete(2,i+1);
    if Words[2,i+1]=22 then begin
      RemarksBox.Items.AddObject(MCh(lEth, 22)+' is voiced to '+MCh(lEth, 14)+' after liquid diphthongisation|'+VoiceChange(True, caseP), Pointer(clWindowText));
      Words[2,i+1]:=14;
    end;
  end else if (Words[2,i] in [0, 9, 17, 28, 35]) and (Words[2,i+1] in [24..27]) then begin
    RemarksBox.Items.AddObject('Nasalisation: '+MCh(lEth, Words[2,i])+MCh(lEth, Words[2,i+1])+' > '+MCh(lEth, Words[2,i]+1)+'|'
      +Existence(False, caseB{i.e., the stop quality is eliminated; the nasal quality remains in the vowel}), Pointer(clWindowText));
    Words[2,i]:=Words[2,i]+1;
    Delete(2,i+1);
  end;
  if Words[2,0]=8 then begin
    st:='';
    case Words[2,1] of
      24, 25: begin st:=' with place assimilation of '+MCh(lEth, Words[2,1]); Words[2,1]:=26; end;
      23:     begin st:=' with aspiration of '+MCh(lEth, 23);                 Words[2,1]:=15; end;
      31:     begin st:=' with aspiration of '+MCh(lEth, 31);                 Words[2,1]:=16; end;
    end;
    if not (Words[2,1] in EthVowels) then begin
      RemarksBox.Items.AddObject('Elimination of initial '+MCh(lEth, 8)+st+'|'+Existence(False, caseB), Pointer(clWindowText));
      Delete(2,0);
    end;
  end;
  if (Ending[0]=WordLen[0]-1) and (WordsB[0,1]=19) then WordsB[2,1]:=9
    else if (Ending[0]=WordLen[0]-2) and (WordsB[0,2]=17) and (WordsB[0,1]=11) then begin
      WordCut(2, 1);
      WordsB[2,1]:=9;
    end;
  if WordsB[2,1]=34 then WordCut(2, 1);
  b:=False;
  for i:=WordLen[2]-1 downto 0 do if Words[2,i] in EthVowels-[0, 9, 17, 28, 35] then b:=True;
  CheckBox.Visible:=not b;
  if b then for i:=WordLen[2]-1 downto 0 do begin
    if (s=stIs2) and (Words[2,i] in [2, 11, 19, 30, 37]) then FStressDia[2,i]:=3 else FStressDia[2,i]:=0;
    if Words[2,i] in [2, 11, 19, 30, 37] then CheckBox.Visible:=True;
  end;
  CheckBox.Caption:=CheckBoxCaptions[11];
  CheckBox.Hint:=CheckBoxHints[11];
end; {PrWaldToEth}

procedure EthToModLem;
const A: array[0..38] of Byte = (0, 0, 0, 20, 20, 15, 13, 19, 19, 1, 1, 1, 17, 18, 18, 28, 26, 3, 3, 3, 10, 8, 21, 28, 25, 24, 24, 24, 4, 4, 4, 26, 14, 22, 16, 6, 6, 6, 13);
var i: Integer;
begin
  for i:=0 to WordLen[0]-1 do begin
    if Words[0,i] in [5, 6, 20, 21] then Add(2, 22-3*Ord(Words[0,i]>6));
    if Words[0,i] in [3, 7, 13] then Add(2, A[Words[0,i]]+3*Ord((i=0) or (Words[0,i+1] in [5, 6, 12, 15, 16, 22, 32, 33, 34, 38])))
      else Add(2, A[Words[0,i]]);
  end;
  ModLemPhonotactics;
  Poststem;
end; {EthToModLem}

{--------------------------------------------------Loans with non-Lemizh targets---------------------------------------------}

procedure PrWaldToEHell;
const A: array[0..32] of Byte = (0, 1, 2, 2, 3, 3, 4, 5, 6, 6, 7, 8, 9, 34, 34, 11, 12, 14, 16, 18, 19, 18, 21, 25, 27, 27, 29, 30, 31, 32, 34, 3, 27);
      Voiceless: set of Byte = [10, 15, 22, 23, 26];
      AVoiceless: array[3..9] of Byte = (21, 0, 29, 0, 0, 0, 11);
var i: Integer;
begin
  MustHaveStress;
  for i:=0 to WordLen[0]-1 do begin
    if Ending[0]=i then Ending[2]:=WordLen[2];
     case Words[0,i] of
      3, 5, 9: if (Words[0,i-1] in Voiceless) or (i=0) or (Words[0,i+1] in Voiceless) or (i=WordLen[0]-1) then Add(2, AVoiceless[Words[0,i]]) else Add(2, A[Words[0,i]]);
      30: if (Words[0,i-1] in Voiceless) or (i=0) then Add(2, 27) else Add(2, A[Words[0,i]]);
      else Add(2, A[Words[0,i]]);
    end;
    if GetStress(0, i, stIs1)=stIs1 then SetStress(2, WordLen[2]-1, stIs1, False);
  end;
  if (Ending[2]=WordLen[2]-1) and (WordsB[2,1]=0) then WordsB[2,1]:=1 else RemarksBox.Items.AddObject('Ending not implemented yet!', Pointer(clRed));
end; {PrWaldToEHell}

procedure GheToMLem;
const
  vowl: array[0..5] of Byte = (0, 4, 2, 1, 5, 3);
  rvar: array[6..9] of Byte = (12, 26, 26,  8);
  lvar: array[6..9] of Byte = (12, 28, 28,  8);
  fric: array[6..9] of Byte = (12,  0,  9, 27);
  charsort: array[False..True] of string = ('consonant', 'modifier');
var
  a, i, j, m, mo: Integer;
  noPin, noPafter: Boolean;
begin
  for i:=0 to Min(WordLen[0], Ending[0])-1 do begin
    a:=i;
    repeat Dec(a) until Words[0,a] in [0..11, 255];
    m:=i;
    repeat Inc(m) until Words[0,m] in [0..11, 20..25, 255];
    if Words[0,m] in [20..25] then mo:=Words[0,m] else mo:=0;
    noPin:=True;
    for j:=a+1 to m-1 do if Words[0,j] in [12, 14, 16, 18] then noPin:=False;
    noPafter:=True;
    for j:=i+1 to m-1 do if Words[0,j] in [12, 14, 16, 18] then noPafter:=False;
    case Words[0,i] of
      0, 1, 3, 4: Add(2, vowl[Words[0,i]]);
      2: if Words[0,i-1]=1 then Add(2, 6) else Add(2, 2);
      5: if Words[0,i-1]=4 then Add(2, 7) else Add(2, 3);
      6..11: begin
        Add(2, vowl[Words[0,i]-6]);
        Add(2, vowl[Words[0,i]-6]);
      end;
      12, 14, 16, 18: case mo of
        0, 20, 25: begin
          if (Words[0,i]<>16) or (WordLen[2]>0) then Add(2, 29- Words[0,i] div 2 +Ord(Words[0,i]>=16));
          if (mo=20) and (i=m-1)  then Add(2, 25-Ord(Words[0,i]=18));
          if (mo=25) and noPafter then Add(2, 29- Words[0,i] +2*Ord(Words[0,i]>=16));
        end;
        21: if Words[0,i-1] in [12, 14, 16, 18] then Add(2, rvar[Words[0,i] div 2]) else Add(2, 26);
        22..24: begin
          if (Words[0,i]<>16) or (WordLen[2]>0) then Add(2, 26-Words[0,i] div 2 +Ord(Words[0,i]>=16));
          if (mo=23) and ((i=m-1) or (Words[0,i]<>14)) then Add(2, lvar[Words[0,i] div 2]);
        end;
      end;
      13, 17, 19: case mo of
        0, 20, 21: begin
          Add(2, 22- Words[0,i] div 2 + Ord(Words[0,i]=13));
          if (mo=21) and noPin then Add(2, 26);
        end;
        22, 23: Add(2, fric[Words[0,i] div 2]);
        24: Add(2, 24+Ord(Words[0,i]=13));
      end;
      15: case mo of
        0, 20, 21: begin
          Add(2, 15+Ord((WordLen[2]=0) and (mo<>21)));
          if (mo=21) and noPin then Add(2, 26);
        end;
        22, 23: Add(2, 10+Ord(WordLen[2]=0));
        24: Add(2, 24+Ord(Words[0,i-1] in [3..5, 9..15, 255]));
      end;
      20..25: if Words[0,i+1] in [12..25] then RemarksBox.Items.AddObject('A modifier plus a '+charsort[Words[0,i+1]>19]+' ( '
          +MCh(lGhe, Words[0,i])+MCh(lGhe, Words[0,i+1])+') is not allowed!', Pointer(clRed));
    end;
  end;
  for i:=0 to WordLen[2]-1 do if (Words[2,i+1] in [8..23]) and (Words[2,i-1] in [8..23, 255]) then case Words[2,i] of
    24, 25: Insert(2, i, 2);
    26, 27: if i=0 then Insert(2, 0, 2) else Delete(2, i);
  end;
  if SmallInt(Ending[0])>-1 then begin
    Ending[2]:=WordLen[2];
    if Ending[0]=WordLen[0]-1 then case WordsB[0,1] of
      0: Add(2, 0);
      6,  9: begin Add(2, 0); Add(2, 26+2*Ord(WordsB[0,1]= 9)); end;
      8, 11: begin Add(2, 2); Add(2, 26+2*Ord(WordsB[0,1]=11)); end;
    end;
  end;
end; {GheToMLem}

{--------------------------------------------------Loans with non-Lemizh targets---------------------------------------------}



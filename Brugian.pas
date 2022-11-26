procedure PIEtoBrug;
var i: Integer;
begin
  PIEChanges(lBrug);
  PIEChanges2(lBrug); // which semantic shift in thorn cluster?
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

unit Data;

interface

type TCase = Byte;
     ByteArray = array of Byte;

function Existence(Insertion: Boolean; ACase: TCase): string;
function TypeChange(Assim: Boolean; ACase1, ACase2: TCase): string;
function VoiceChange(Assim: Boolean; ACase1: TCase): string;
function PosChange(Assim: Boolean; ACase1, ACase2: TCase): string;
function LabialChange(Assim: Boolean; ACase: TCase): string;
function Metathesis(ACase1, ACase2: TCase): string;
function AspirationChange(Assim: Boolean; ACase: TCase): string;
function n2O(ACases: array of TCase; ACase2a, ACase2b, ACase2c: TCase): string;

function CharWidth(i: Integer; Ending, MorphBound: Boolean): Integer; overload;
function CharWidth(i: Integer): Integer; overload;
function MCh(Lang, c: Byte): string;
function IntToYear(i: Integer): string;
function PercentToRTF(S: string): string;
function GlossBrackets(S: string; Quotes: Boolean): string;

type TStress = (stCant, stCan, stIs1, stIs2, stAny);
     TDia = (diaCant, diaCan, diaYes);
                   
const
  Reg='Software\TESSoft Inc.\Neogrammarian';
  MaxHist=12;
  lPIE=0; lPrLem=1; lOLem=2; lMLem=3; lLMLem=4; lNLem=5; lModLem=6; lVolg=7; lGhe=8; lEHell=9; lKoi=10; lOTroy=11; lNTroy=12; lPrWald=13; lEth=14; lElb=15;
  lPrCelt=16; lBesk=17; lBrug=18;
  LangNs: array[0..18] of string =  ('PIE', 'PLem', 'OLem', 'MLem', 'LMLem', 'NLem', 'ModLem', 'Volg', 'Ghe', 'SHell', 'Koi', 'OTroy', 'NTroy',
    'PWald', 'Eth', 'OElb', 'PCelt', 'Besk', 'Brug');
  LangTags: array[0..High(LangNs)] of string = ('x-ine', 'x-lmp', 'x-lmo', 'x-lmm', 'x-lml', 'x-lmn', 'x-lm', 'x-ka', 'x-gh', 'grc-x-sou', 'grc-x-koi', 'x-tro', 'x-tr',
    'x-wld', 'x-et', 'x-plo', 'x-cel', 'x-sk', 'x-bg');
  LongLangNs: array[0..High(LangNs)] of string = ('Proto-Indo-European', 'Proto-Lemizh', 'Old Lemizh', 'Middle Lemizh',
    'Late Middle Lemizh', 'Early New Lemizh', 'Modern Lemizh', 'Volgan', 'Ghean', 'South Hellenic', 'Koine Greek', 'Old Troyan', 'New Troyan',
    'Proto-Waldaiic', 'Ethiynic', 'Old Elbic', 'Proto-Celtic', 'Beskidic', 'Brugian');
  Dates: array[0..High(LangNs)] of Integer = (-3500, -2700, -2100, -1000, -200, 1350, 1750, 1350, -1000, -2100, -200, -1000, 1750, -2100, 1750, -200, -1000, 1350, 1750);
  Desc:  array[0..High(LangNs)] of set of Byte = ([lPrLem, lEHell, lPrWald, lPrCelt, lBrug], [lOLem], [lMLem, lVolg], [lLMLem], [lNLem], [lModLem], [],
    [], [], [lKoi, lOTroy], [], [lNTroy], [], [lEth, lElb], [], [], [lBesk], [], []);
  LLoans: array[0..High(LangNs)] of set of Byte = ([], [], [lNLem], [], [], [], [], [], [], [], [lNLem, lModLem], [], [], [], [], [], [], [], []);
  RGBs:  array[0..High(LangNs)] of Integer = ($000000, $407000, $407000, $407000, $407000, $407000, $407000, $A1C200, $A0A0A0, $E7016F, $E7016F, $F728C1, $F728C1, $0000CA, $0000CA, $0000F1, $FF8000, $FF8000, $8C5B73);
  RGBsB: array[0..High(LangNs)] of Integer = ($FFFFFF, $D0ECC0, $D0ECC0, $D0ECC0, $D0ECC0, $D0ECC0, $D0ECC0, $F0FEE0, $E0E0E0, $FAC0DC, $FAC0DC, $FDD0EE, $FDD0EE, $C0C0F2, $C0C0F2, $E0E0F9, $FFE0C0, $FFE0C0, $E3D6DC);

  Reconstructed = [lPIE, lPrLem, lEHell, lPrWald, lPrCelt];
  HyphenAllowed = [lPIE..lNLem, lGhe, lEHell, lKoi, lOTroy, lPrWald, lElb, lPrCelt, lBesk];
  HyphenEndOnly = [lPrLem, lOLem];            

  ComboBoxDef: array[1..7] of Byte = (0,  4,  0, 0, 0, 0, 0);
  ComboBoxNrs: array[1..7] of Byte = (6, 10, 38, 0, 0, 0, 4);
  CheckBoxCaptions: array[1..11] of string = ('Lindeman’s variant', '[stem of tense-carrier]', '‘voiceless’ initial', 'feminine', '[‘big’ part of speech]', '[endingless noun]', '[masculine]',
    '[noun ending in -s]', 'haplology', '<FREE TO USE>', 'passive or substantivisation');
  CheckBoxHints: array[1..11] of string = ('ONLY for PIE monosyllables (F7)', 'stem of a verb or adjective (F7)', 'uncertain; probably from a PIE laryngeal (F7)', 'feminine form of adjective or aminal noun (F7)',
    'a verb, as opposed to a particle (F7)', 'endingless nominative of a noun, as opposed to a particle (F7)', '(F7)', '-xi or -psi consists of stem plosive + ending -s (F7)',
    'usual for words with >3 stem moræ, or 3 stem moræ and ending in -iryr (F7)', '<FREE TO USE> (F7)', 'passive form, substantivisation of an adjective, or the like (F7)');

  chFullstop = 254; chEnding = 253;  chAsterisk = 252;  chLength = 251;  chDiaeresis = 250;  chMorphBound = 249;
  NrChars: array[False..True, 0..High(LangNs)] of Byte = ((40, 34, 33, 29, 29, 29, 29, 5{Volg}, 26, 35, 28, 33, 26, 33, 39, 25, 25, 35, 1{Brug}),
                                                          (44, 34, 33, 29, 29, 29, 29, 5{Volg}, 26, 35, 28, 33, 26, 33, 39, 25, 25, 35, 1{Brug}));
  CharIds: array[0..High(LangNs), 0..43] of Byte =
         {  0    1    2    3    4    5    6    7    8    9   10   11   12   13   14   15   16   17   18   19   20   21   22   23   24   25   26   27   28   29   30   31   32   33   34   35   36   37   38   39   40   41   42   43}
{PIE}   (( 11,  13,   0,   2,  35,  37, 177,  22, 178,  48,  33, 181,  34, 183,  45, 185,  32, 179,  46, 187,  60, 189, 191, 192, 194, 195, 197, 198,  43,   8, 200,  47,  10, 201, 203, 204, 205,  31,  20, 202, 206, 207, 208, 164),
{PrLem}  ( 11,  13,   0,   2,  35,  37,  22,  24,  48,  50,  33,  34,  45,  32,  57, 210,  60, 217,  30, 211, 223,  19, 216,  46, 215, 219,  58,  21,   8,  10,  20,  43,  47,  31, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252),
{OLem}   (  0,  59,  35,  48,  11,  22, 169, 173,  57, 210,  60, 217,  30, 211,  19, 216,  46, 215, 219,  58,   8,  10,  20,  43,  47,  31,  33,  34,  45,  21,  32,  13,  24, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252),
{MLem}   (115, 117, 119, 121, 123, 125, 127, 129, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252),
{LMLem}  (115, 117, 119, 121, 123, 125, 127, 129, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252),
{NLem}   (115, 117, 119, 121, 123, 125, 127, 129, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252),
{ModLem} (115, 117, 119, 121, 123, 125, 127, 129, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252),
{Volg}   (  0,   9, 218, 107, 233,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0),
{Ghe}    (  0,  35, 160,  11, 169,  22,   2,  37, 162,  13, 171,  24,  43,  19,  47,  46, 238, 215,  44,  58, 240, 241, 242, 243, 244, 245, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252),
{EHell}  (  0,   2,   8,  10,  11,  13,  20,  21,  22,  24,  31, 212,  32, 179,  33, 181,  34, 183,  35,  37,  43, 213,  44, 234, 214,  45, 185,  46,  47, 216,  48,  50,  57,  59,  60, 252, 252, 252, 252, 252, 252, 252, 252, 252),
{Koi}    ( 61,  63,  66,  67,  68,  69,  75,  71,  76,  77,  79,  82,  83,  85,  86,  87,  88,  93,  95,  98,  99, 100, 102, 105, 106, 107,  90, 110, 109,  97, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252),
{OTroy}  ( 61,  63,  66,  67,  68,  69,  74,  75,  71,  76,  77,  79,  82,  83,  84,  85,  86,  87,  88,  93,  94,  95,  96,  98,  99, 100, 102, 105, 106, 107,  90, 112, 108, 109, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252),
{NTroy}  ( 61,  66,  67,  68,  69,  75,  71,  76,  77,  82,  83,  85,  86,  87,  88,  93,  95,  98,  99, 100, 105, 106, 107,  90, 112, 109, 232, 255, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252),
{PrWald} (  0,   2,   8, 209,  10, 210,  11,  13,  20, 211,  21,  22,  24,  30, 226, 212,  32,  33,  34,  35,  37, 169, 213,  45,  46, 236, 216,  48,  50,  56, 239, 220,  19, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252),
{Eth}    (  0,   4,   6,   8, 209,   9, 218,  10, 210,  11,  15,  17,  19,  20, 211, 224, 225,  22,  26,  28,  30, 226, 212,  32,  33,  34, 231, 232,  35,  39,  41,  45, 236, 216, 237,  48,  52,  54,  58, 227, 252, 252, 252, 252),
{Elb}    (  0,   8,   9, 218,  10, 220,  11,  19,  20, 222,  21,  22,  30,  31,  32,  33,  34,  35,  45,  46, 236,  47,  48,  56,  58, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252),
{PrCelt} (  0,   2,   8,  10,  11,  13, 105,  20, 207,  22,  24,  31, 206,  32,  33,  34,  35,  45,  46,  47,  48,  50,  57,  58,  59, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252),
{Besk}   (  0,   2, 152, 154, 156, 158,   8,  10,  11,  13,  19,  20, 222,  21, 111,  22,  24,  31,  32, 229,  33,  34, 230,  35,  37,  43,  45, 235,  46,  47,  48,  50,  58,  59, 251, 252, 252, 252, 252, 252, 252, 252, 252, 252),
{Brug}   ( 61,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0));

  SortChars: array[0..High(LangNs), -1..39] of Byte =
         { -1   0    1    2    3    4    5    6    7    8    9   10   11   12   13   14   15   16   17   18   19   20   21   22   23   24   25   26   27   28   29   30   31   32   33   34   35   36   37   38   39}
{PIE}   ((255,  2,   3,  29,  30,  32,  33,   0,   1,  35,  36,  38,  39,  41,  42,  22,  23,  24,  25,  26,  27,   7,   6,  34,  37,  40,  16,  17,  10,  11,  12,  13,   4,   5,  28,  14,  15,  18,  31,   9,   8),
{PrLem}  (255,  2,   3,  28,  25,  29,  15,   0,   1,  21,  30,  19,  27,  20,   6,   7,  18,  33,  13,  10,  11,   4,   5,  31,  12,  23,  24,  32,  22,   8,   9,  14,  26,  16,  17, 255,  35,  36,  37,  38,  39),
{OLem}   (255,  0,  20,  18,  21,   9,   4,  31,  14,  22,  13,  29,   5,  32,  12,  25,  30,  26,  27,   2,   6,  23,  28,  16,  17,  24,  15,   3,   7,   8,  19,   1,  10,  11, 255,  34,  35,  36,  37,  38,  39),
{MLem}   (255,  0,   1,   2,   3,   4,   5,   6,   7,  28,  27,  26,  24,  25,  18,  19,  20,  21,  22,  23,   8,   9,  10,  11,  12,  13,  14,  15,  16,  17, 255,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39),
{LMLem}  (255,  0,   1,   2,   3,   4,   5,   6,   7,  28,  27,  26,  24,  25,  18,  19,  20,  21,  22,  23,   8,   9,  10,  11,  12,  13,  14,  15,  16,  17, 255,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39),
{NLem}   (255,  0,   1,   2,   3,   4,   5,   6,   7,  28,  27,  26,  24,  25,  18,  19,  20,  21,  22,  23,   8,   9,  10,  11,  12,  13,  14,  15,  16,  17, 255,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39),
{ModLem} (255,  0,   1,   2,   3,   4,   5,   6,   7,  28,  27,  26,  24,  25,  18,  19,  20,  21,  22,  23,   8,   9,  10,  11,  12,  13,  14,  15,  16,  17, 255,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39),
{Volg}   (255,  0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,  15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39),
{Ghe}    (255,  0,   6,   3,   9,   2,   8,  13,   5,  11,   1,   7,   4,  10,  12,  18,  15,  17,  14,  16,  19,  24,  23,  20,  21,  22,  25, 255,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39),
{EHell}  (255,  0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,  15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39),
{Koi}    (255,  0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,  15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39),
{OTroy}  (255,  0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,  15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39),
{NTroy}  (255,  0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,  15,  16,  17,  25,  18,  19,  20,  21,  22,  23,  24,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39),
{PrWald} (255,  0,   1,   2,   3,   4,   5,  31,   6,   7,  32,   8,   9,  10,  11,  12,  13,  14,  15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  26,  27,  28,  29,  30,  33,  34,  35,  36,  37,  38,  39),
{Eth}    (255,  0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,  15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39),
{Elb}    (255,  0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,  15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39),
{PrCelt} (255,  0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,  15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39),
{Besk}   (255,  0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,  15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39),
{Brug}   (255,  0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,  15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39));

  Map1: array[0..High(LangNs), 'a'..'z'] of Byte =
         {  A    B    C    D    E    F    G    H    I    J    K    L    M    N    O    P    Q    R    S    T    U    V    W    X    Y    Z}
{PIE}   ((  2,  29,  34,  32,   0,  26,  38,  22,   7,   6,  37,  16,  10,  12,   4,  28,  40,  14,  18,  31,   9,  41,   8,  24,   6,  20),
{PrLem}  (  2,  28,  17,  29,   0,  21,  30,  27,   6,  18,  33,  13,  10,  11,   4,  31,  22,  12,  23,  32,   8,  15,  14,  26, 255,  16),
{OLem}   (  0,  20,  11,  21,   4,  14,  22,  29,   5,  12,  25,  30,  26,  27,   2,  23,  15,  28,  16,  24,   3,   9,   8,  19,   1,  10),
{MLem}   (  0,  20,   9,  19,   1,  17,  18,  14,   3,   8,  21,  28,  25,  24,   4,  23,  16,  26,  15,  22,   6,  11,  12,  13,   2,  10),
{LMLem}  (  0,  20,   9,  19,   1,  17,  18,  14,   3,   8,  21,  28,  25,  24,   4,  23,  16,  26,  15,  22,   6,  11,  12,  13,   2,  10),
{NLem}   (  0,  20,   9,  19,   1,  17,  18,  14,   3,   8,  21,  28,  25,  24,   4,  23,  16,  26,  15,  22,   6,  11,  12,  13,   2,  10),
{ModLem} (  0,  20,   9,  19,   1,  17,  18,  14,   3,   8,  21,  28,  25,  24,   4,  23,  16,  26,  15,  22,   6,  11,  12,  13,   2,  10),
{Volg}   (  0, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255),
{Ghe}    (  0, 255, 255, 255,   3,  13, 255,  24,   5, 255,  18,  23, 255,  20,   1,  12,  18,  21,  15,  14,   4,  22, 255,  19,   2,  25),
{EHell}  (  0,   2, 255,   3,   4, 255,   6,   7,   8,  33,  10,  12,  14,  16,  18,  20,  22,  25,  27,  28,  30,  32,  32, 255,  33,  34),
{Koi}    (  0,   2,  24,   4,   5,  23,   3,  27,   9, 255,  11,  12,  13,  14,  16,  17, 255,  18,  19,  20,  21, 255, 255,  15,  21,   6),
{OTroy}  (  0,   2,  28,   4,   5,  27,   3,  31,  10,  10,  12,  13,  15,  16,  18,  19,  20,  21,  23,  24,  25,   6,   6,  17,  25,   7),
{NTroy}  (  0,   1,  21,   3,   4,  20,   2,  24,   8, 255,   9,  10,  11,  12,  14,  15, 255,  16,  17,  18,  19, 255, 255,  13,  19,   5),
{PrWald} (  0,   2, 255,   4,   6,  32,   8,  10,  11,  13,  15,  16,  17,  18,  19,  22, 255,  23,  24,  26,  27,  29,  29, 255,  21,  30),
{Eth}    (  0,   3,   5,   7,   9,  12,  13, 255,  17,  20,  22,  23,  24,  25,  28, 255, 255,  31,  32,  33,  35, 255,  30,  38,  11, 255),
{Elb}    (  0,   1,   2,   4,   6,   7,   8,  10,  11,  12,  13,  14,  15,  16,  17, 255, 255,  18,  19,  21,  22,  23, 255,  24, 255, 255),
{PrCelt} (  0,   2, 255,   3,   4,   6,   7, 255,   9, 255,  11,  13,  14,  15,  16, 255,  12,  17,  18,  19,  20, 255,  22,  23,  24,  18),
{Besk}   (  0,   6, 255,   7,   8,  10,  11,  13,  15, 255,  17,  18,  20,  21,  23,  25, 255,  26,  28,  29,  30, 255, 255,  32,  33, 255),
{Brug}   (  0, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255));

  Map2: array[0..High(LangNs), 'A'..'Z'] of Byte =
         {  A    B    C    D    E    F    G    H    I    J    K    L    M    N    O    P    Q    R    S    T    U    V    W    X    Y    Z}
{PIE}   ((  3,  30,  35,  33,   1,  27,  39,  23,   6,  43,  37,  17,  11,  13,   5,  28,  40,  15,  19,  31,   8,  42,   8,  25,  43,  21),
{PrLem}  (  3,  28,  24,  29,   1,  21,  30,  20,   7,  19,  33,  13,  10,  11,   5,  31,  22,  12,  23,  32,   9,  15,  14,  25, 255,  16),
{OLem}   (  0,  20,  11,  21,  31,  14,  22,  17,  32,  13,  25,  30,  26,  27,   6,  23,  15,  28,  16,  24,   7,   9,   8,  18,   1,  10),
{MLem}   (  0,  20,   9,  19,   1,  17,  18,  14,   3,   8,  21,  28,  25,  24,   5,  23,  16,  27,  15,  22,   7,  11,  12,  13,   2,  10),
{LMLem}  (  0,  20,   9,  19,   1,  17,  18,  14,   3,   8,  21,  28,  25,  24,   5,  23,  16,  27,  15,  22,   7,  11,  12,  13,   2,  10),
{NLem}   (  0,  20,   9,  19,   1,  17,  18,  14,   3,   8,  21,  28,  25,  24,   5,  23,  16,  27,  15,  22,   7,  11,  12,  13,   2,  10),
{ModLem} (  0,  20,   9,  19,   1,  17,  18,  14,   3,   8,  21,  28,  25,  24,   5,  23,  16,  27,  15,  22,   7,  11,  12,  13,   2,  10),
{Volg}   (255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255),
{Ghe}    (  6, 255, 255, 255,   9,  13, 255,  24,  11, 255,  18,  23, 255,  20,   7,  12,  18,  21,  17,  16,  10,  22, 255,  19,   8,  25),
{EHell}  (  1,   2, 255,   3,   5, 255,  23,   7,   9,  33,  11,  13,  15,  17,  19,  21,  24,  26,  27,  29,  31,  32,  32, 255,  33,  34),
{Koi}    (  1,   2,  24,   4,   7,  23,   3,  27,  10, 255,  11,  12,  13,  14,  26,  25, 255,  18,  19,   8,  22, 255, 255,  15,  22,   6),
{OTroy}  (  1,   2,  28,   4,   8,  27,   3,  32,  11,  11,  12,  14,  15,  16,  30,  29,  20,  22,  23,   9,  26,   6,   6,  17,  26,   7),
{NTroy}  (  0,   1,  21,   3,   6,  20,   2,  24,   8, 255,   9,  10,  11,  12,  23,  22, 255,  16,  25,   7,  19, 255, 255,  13,  19,   5),
{PrWald} (  1,   3, 255,   5,   7,  32,   9,  10,  12,  14,  15,  16,  17,  18,  20,  22, 255,  23,  25,  26,  28,  29,  29, 255,  21,  30),
{Eth}    (  1,   4,   6,   8,  10,  12,  14, 255,  18,  21,  22,  15,  24,  26,  29, 255, 255,  16,  32,  34,  36, 255,  37,  38,  19, 255),
{Elb}    (  0,   1,   3,   5,   6,   7,   9,  10,  11,  12,  13,  14,  15,  16,  17, 255, 255,  18,  20,  21,  22,  23, 255,  24, 255, 255),
{PrCelt} (  1,   2, 255,   3,   5,   6,   8, 255,  10, 255,  12,  13,  14,  15,  16, 255,  12,  17,  18,  19,  21, 255,  22,  23,  24,  18),
{Besk}   (  1,   6, 255,   7,   9,  10,  12,  14,  16, 255,  17,  19,  20,  22,  24,  25, 255,  27,  28,  29,  31, 255, 255,  32,  33, 255),
{Brug}   (255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255));

  gZeroPlusV = -1;  gZeroPlusC = 0;  gFull = 1;  gLength = 2;  gO = 3;  gOLength = 4;

  caseA=0; caseE=1; caseY=2; caseI=3; caseO=4; caseOE=5; caseU=6; caseUE=7; caseB=8; caseP=9; caseW=10; caseF=11; caseN=12; caseNH=13;
  caseL=14; caseLH=15; caseBW=16; casePF=17;

implementation

uses SysUtils, MyUtils, Math;

const
  Cases: array[caseA..caseLH] of string = ('factive', 'nominative', 'dative', 'accusative', 'local', 'temporal', 'causative/persuasive', 'instrumental',
    'melioration', 'pejorative', 'strengthening', 'weakening', 'hardening', 'softening', 'quickening', 'slowing');
  Descriptors: array[0..2, caseA..casePF] of string =
   (('act',    'sender',  'addressee', 'content',   'place', 'time',    'cause/motive',   'means', 'good', 'bad', 'strong', 'weak', 'hard', 'soft', 'quick', 'slow', 'up', 'down'),
    ('itself', 'message', 'message',   'container', 'place', 'earlier', 'cause/motive',   'means', '',     '',    '',       '',     '',     '',     '',      '',     '',   ''),
    ('',       '',         '',         '',          'place', 'later',   'effect/purpose', 'aim',   '',     '',    '',       '',     '',     '',     '',      '',     '',   ''));
  Ass: array[False..True] of string = ('concretising', 'abstracting');

{
1. Elimination                            1. Narrowing = Specialisation
  1.1. Voiced    plosive                    1.1. Pejorative   [=Degeneration]
  1.2. Voiceless plosive                    1.2. Melioration  [=Elevation]
  1.3. Voiced    fricative                  1.3. Weakening
  1.4. Voiceless frivative                  1.4. Strengthening
  1.5. Voiced    nasal                      1.5. Softening
  1.6. Voiceless nasal                      1.6. Hardening
  1.7. Voiced    liquid                     1.7. Slowing
  1.8. Voiceless liquid                     1.8. Quickening
  1.9. Vowel                                1.9. case narrowing
2. Insertion                              2. Widening = Generalisation
  2.1. Vowel                                2.1. case widening
}
function Existence(Insertion: Boolean; ACase: TCase): string;
const S: array[False..True] of string = ('narrowing', 'widening');
begin
  if not Insertion and (ACase>=caseB) then ACase:=ACase div 2 *2 + (ACase+1) mod 2;
  if ACase<=caseLH then Result:=UpperCaseFirst(Cases[ACase])+' '+S[Insertion] else Result:=UpperCaseFirst(Cases[ACase-8])+' & '+Cases[ACase-6]+' '+S[Insertion];
end; {Existence}

{
3. Assimilation                           3. Cross-shift
  3.1. Type change                          3.1. Metonymy
    3.1.1. Fricative > plosive                3.1.1. ...
    3.1.2. Vowel     > consonant              3.1.2. case dependent (e.g. Content   > Container)  ... Earlier for later
    4.1.3. Consonant > vowel                  4.1.3.       "        (e.g. Container > Content)
4. Dissimilation                          4. Cross-shift
  4.1. Type change                          4.1. Metonymy
    4.1.1. Fricative > plosive                4.1.1. ...
    4.1.2. Vowel     > consonant              4.1.2. case dependent (e.g. Content   > Container)  ... Later for earlier
    4.1.3. Consonant > vowel                  4.1.3.       "        (e.g. Container > Content)
}
function TypeChange(Assim: Boolean; ACase1, ACase2: TCase): string;
const metdir: array[caseA..caseUE] of Byte = (0, 0, 0, 0, 1, 1, 1, 1);
var ca: Integer;
    b: Boolean;
begin
  if (ACase1 in [caseBW, casePF]) or (ACase2 in [caseBW, casePF]) then Result:='ERROR IN FUNCTION CALL TO “TypeChange”: no affricates allowed!' else
      if (ACase1 in [caseA..caseUE]) or (ACase2 in [caseA..caseUE]) then begin
    if (ACase1 in [caseA..caseUE]) and (ACase2 in [caseA..caseUE]) then Result:='Metonymy: '+Descriptors[0, ACase1]+' for '+Descriptors[0, ACase2]+' ('+Ass[Assim]+')' else begin
      if ACase1 in [caseA..caseUE] then ca:=ACase1 else ca:=ACase2;
      if metdir[ca]=0 then b:=ACase2 in [caseA..caseUE] else b:=Assim;
      Result:='Metonymy: '+Descriptors[metdir[ca]+Ord(b), ca]+' for '+Descriptors[metdir[ca]+1-Ord(b), ca];
    end;
  end else begin
    ACase1:=ACase1 div 2 *2 + (ACase1+1) mod 2;
    Result:='Metonymy ('+Cases[ACase1]+', '+Cases[ACase2]+', '+Ass[Assim]+')';
  end;
end; {TypeChange}

{
3. Assimilation                           3. Cross-shift
  3.2. Voice change                         3.2. Metaphor
    3.2.1. Plosive   voicing                  3.2.1. Melioration   (!)
    3.2.2. Plosive   devoicing                3.2.2. Pejorative    (!)
    3.2.3. Fricative voicing                  3.2.3. Strengthening (!)
    3.2.4. Fricative devoicing                3.2.4. Weakening     (!)
    3.2.5. Nasal     voicing                  3.2.5. Hardening     (!)
    3.2.6. Nasal     devoicing                3.2.6. Softening     (!)
    3.2.7. Liquid    voicing                  3.2.7. Quickening    (!)
    3.2.8. Liquid    devoicing                3.2.8. Slowing       (!)
4. Dissimilation                          4. Cross-shift
  4.2. Voice change                         4.2. Metaphor, 4.2.x. like 3.2.x.
}
function VoiceChange(Assim: Boolean; ACase1: TCase): string;
begin
  if ACase1>=caseB then ACase1:=ACase1 div 2 *2 + (ACase1+1) mod 2;
  if ACase1<=caseLH then Result:='Metaphor ('+Cases[ACase1]+', '+Ass[Assim]+')' else
    Result:='Metaphor ('+Cases[ACase1-8]+' & '+Cases[ACase1-6]+', '+Ass[Assim]+')';
end; {VoiceChange}

{
3. Assimilation                           3. Cross-shift
  3.3. Position change                      3.3. Pars pro toto
    3.3.1. Voiced    plosive                  3.3.1. Good   part
    3.3.2. Voiceless plosive                  3.3.2. Bad    part
    3.3.3. Voiced    fricative                3.3.3. Strong part
    3.3.4. Voiceless frivative                3.3.4. Weak   part
    3.3.5. Voiced    nasal                    3.3.5. hard   part
    3.3.6. Voiceless nasal                    3.3.6. soft   part
    3.3.7. Voiced    liquid                   3.3.7. quick  part
    3.3.8. Voiceless liquid                   3.3.8. slow   part
      EX!!  3.3.9. Vowel                              3.3.9. case dependent (e.g. o>u: the cause [=pars] of the place [=totum])
4. Dissimilation                          4. Cross-shift
  4.3. Position change                      4.3. Totum pro parte,         4.3.x. as 3.3.x., Good whole etc.
}
function PosChange(Assim: Boolean; ACase1, ACase2: TCase): string;
const P1: array[False..True] of string = ('Pars', 'Totum');
      P2: array[False..True] of string = ('toto', 'parte');
      P:  array[False..True] of string = ('part', 'whole');
begin
  if (ACase1>=caseB) or (ACase2>=caseB) then begin
    if ACase1=ACase2 then begin
      if ACase1<=caseLH then Result:=P1[Assim]+' pro '+P2[Assim]+' ('+Descriptors[0, ACase1]+' '+P[Assim]+')'
        else Result:=P1[Assim]+' pro '+P2[Assim]+' ('+Descriptors[0, ACase1-8]+' & '+Descriptors[0, ACase1-6]+' '+P[Assim]+')';
    end else Result:='ERROR IN FUNCTION CALL TO “PosChange”: type or voice changed!';
  end else if ACase1 div 4 = ACase2 div 4 then Result:=TypeChange(Assim, ACase1, ACase2) // Result:=P1[Assim]+' ('+Descriptors[0, ACase1]+') pro '+P2[Assim]+' ('+Descriptors[0, ACase2]+')'
    else Result:=LabialChange(Assim, ACase1);
end; {PosChange}

{
3. Assimilation                           3. Cross-shift
  3.4. Labialisation change                 3.4. Synecdoche: material for thing
4. Dissimilation                          4. Cross-shift
  4.4. Labialisation change                 4.4. Synecdoche: thing for material
}
function LabialChange(Assim: Boolean; ACase: TCase): string;
const P: array[False..True] of string = ('material/colour/sound/smell', '¶');
begin
  if (ACase<=caseUE) and Assim then ACase:=ACase mod 4 + 4*Ord(ACase<caseO);
  Result:=UpperCaseFirst(StringReplace(P[Assim]+' for '+P[not Assim], '¶', Descriptors[0, ACase], []));
end; {LabialChange}

{
3. Assimilation                           3. Cross-shift
  3.5. Aspiration                           3.5. Cohyponymic transfer: obscure for familiar
4. Dissimilation                          4. Cross-shift
  4.5. Aspiration                           4.5. Cohyponymic transfer: familiar for obscure
}
function AspirationChange(Assim: Boolean; ACase: TCase): string;
const P: array[False..True] of string = ('obscure', 'familiar');
begin
  if ACase in [caseB, caseP] then Result:='Cohyponymic transfer: '+P[Assim]+' for '+P[not Assim]+' thing ('+Cases[ACase]+')'
    else Result:='ERROR IN FUNCTION CALL TO “AspirationChange”: not a plosive!';
end; {AspirationChange}

{
5. Metathesis                             5. Auto-antonymy (complementary: bad <> good), auto-converse (opposite: take <> give), antiphrasis (contrastive: perfect lady > whore)
}
function Metathesis(ACase1, ACase2: TCase): string;
begin
  if ACase1=ACase2 then Result:='Auto-antonymy: '+Descriptors[0, ACase1]+' for '+Descriptors[0, ACase1 div 2 *2 +Ord(not Odd(ACase1))] else
    if ((ACase1<=caseUE) and (ACase2<=caseUE)) or ((ACase1>=caseB) and (ACase2>=caseB)) then Result:='Auto-converse: swap '+Descriptors[0, ACase1]+' and '+Descriptors[0, ACase2]  
      else Result:='Antiphrasis: '+Descriptors[0, ACase1]+' for '+Descriptors[0, ACase2];
end; {Metathesis}

{                    
6. n2O                                    6. n2O
}
function n2O(ACases: array of TCase; ACase2a, ACase2b, ACase2c: TCase): string;
var i: Integer;
begin
  Result:='';
  for i:=0 to Length(ACases)-1 do Result:=Result+' ° '+Descriptors[0, ACases[i]]; 
  Result:=Copy(Result, 4, MaxInt)+' -> '+Descriptors[0, ACase2a]+IfThen(ACase2b>0, ' ° '+Descriptors[0, ACase2b])
                                                                +IfThen(ACase2c>0, ' ° '+Descriptors[0, ACase2c])
end; {n2O}

{------------------------------------------------- Utilities ---------------------------------------------------------}

function CharWidth(i: Integer): Integer;
begin
  Result:=CharWidth(i, False, False);
end; {CharWidth}

function CharWidth(i: Integer; Ending, MorphBound: Boolean): Integer;
const offset = -1;
  cw: array[-1..255] of Byte = (0,
    9, 9, 9, 9, 9, 9, 18, 18, 10, 9, 10, 9, 9, 9, 9, 9, 9, 12, 12, 7, 10, 10, 8, 8, 8, 8, 8, 8, 10, 10, 8, 10, 8, 13, 10, 10, 10, 10, 10, 10, 10,
    18, 18, 10, 10, 8, 8, 8, 10, 10, 10, 10, 10, 10, 18, 18, 10, 12, 10, 10, 9, {Latin}
    10, 10, 10, 10, 10, 10, 9, 9, 9, 9, 10, 10, 10, 10, 8, 10, 7, 7, 7, 7, 7, 10, 10, 10, 10, 10, 10, 8, 8, 12, 12, 12, 10, 9, 9, 9, 9, 9, 9,
    10, 10, 10, 10, 10, 12, 10, 12, 9, 9, 6, 6, 9, 0, 0, {Greek}
    6, 6, 9, 9, 10, 10, 10, 10, 9, 9, 9, 9, 12, 12, 13, 13, 13, 12, 11, 12, 13, 13, 12, 11, 12, 13, 14, 11, 14, 14, 11, 14, 11, 11, 14, 14, 14, {Lemizh}
    9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 8, 8, 8, 8, 8, 10, 10, 10, 10, 10, 10, 10, 10, {additional vowels}
    8, 10, 9, 9, 13, 13, 10, 10, 9, 9, 8, 8, 9, 9, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 10, 9, 16, 15, 15, 19, {PIE}
    17, 17, 17, 17, 17, 17, 16, 14, 17, {Xh}
    9, 9, 9, 17, 9, 10, 14, 15, 7, 7, 16, 7, 10, 10, 10, 11, 10, 8, 8, 10, 10, 9, {additional consonants}
    9, 7, 7, 7, 9, 9, {Ghean modifiers}
    30, 30, 30, 8, 10, 5, 9, 8, 5, 16); {Symbols}
begin
  Result:=cw[i]+Ord(Ending)*cw[chEnding]+Ord(MorphBound)*cw[chMorphBound]+(1+Ord(Ending)+Ord(MorphBound))*offset;
end; {CharWidth}

function MCh(Lang, c: Byte): string;
begin
  Result:='%'+FormatFloat('00', Lang)+FormatFloat('00', c);
end; {MCh}

function IntToYear(i: Integer): string;
begin
  Result:=IntToStr(Abs(i))+' '+IfThen(i>=0, 'AD', 'BC');
end; {IntToYear}

function PercentToRTF(S: string): string;
var p: Integer;
begin
  repeat
    p:=Pos('%', S);
    if p>0 then S:=Copy(S, 1, p-1)+LoadStr(100+CharIds[StrToInt(Copy(S, p+1, 2)), StrToInt(Copy(S, p+3, 2))])+Copy(S, p+5, MaxInt);
  until p=0;
  Result:=S;
end; {PercentToRTF}

function GlossBrackets(S: string; Quotes: Boolean): string;
var p: Integer;
    b: Boolean;
begin
  p:=Pos('{', S);
  if p>0 then begin
    Delete(S, p, Pos('}', S)-p+1);
    S:=Trim(S);
  end;
  if Quotes then S:=StringReplace(S, ' [', '’ [', []);
  if Copy(S, 1, 5)='lit. ' then S:='<abbr title="literally">lit.</abbr> '+IfThen(Quotes, '‘')+Copy(S, 6, MaxInt) else S:=IfThen(Quotes, '‘')+S;
  Result:=StringReplace(S, ', lit. ', IfThen(Quotes, '’')+', <abbr title="literally">lit.</abbr> '+IfThen(Quotes, '‘'), []);
  for b:=False to True do Result:=StringReplace(Result, ' ['+IfThen(b, 'in')+'tr.]', ' [<abbr title="'+IfThen(b, 'in')+'transitive">'+IfThen(b, 'in')+'tr.</abbr>]', []);
  if Quotes and (Copy(Result, Length(Result), 1)<>']') then Result:=Result+'’';
end; {GlossBrackets}

end.

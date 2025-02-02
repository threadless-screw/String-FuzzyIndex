use lib 'lib';
use String::FuzzyIndex;
use Test;


# Some of the data for the test sequences were generated using an SW-teaching tool
# of the Department of Computer Science of the University of Freiburg, available here:
# http://rna.informatik.uni-freiburg.de/Teaching/index.jsp?toolName=Smith-Waterman
# https://github.com/BackofenLab/RNA-Playground

# Test plan
plan 12;

# Test data
my $haystack1 = 'GGTTGACTA';
my $needle1   = 'TGTTACGG';
my $R1        = (19/(4*8), 1, 6, 1, 5, <G T T G A C>, <G T T - A C>,
                (4, 8, 12, 11, 15, 19));

my $haystack2 = "ATAGACGACATACAGACAGCATACAGACAGCATACAGA";
my $needle2   = "TTTAGCATGCGCATATCAGCAATACAGACAGATACG";
my $tb_sc2    = (   3,  6,  9,  7, 10,  8,  6,  9, 12, 10, 13, 16, 19, 22,
                   20, 23, 26, 29, 27, 30, 33, 31, 29, 32, 35, 38, 41, 44,
                   47, 50, 53, 56, 59, 57, 60, 63, 66, 69, 67, 70);

my $haystack3 = "WHENTHEGOINGGETSTOUGHTHETOUGHGETGOING";
my $needle3   = "TOVGH";
my $R3        = ( ( 19/(5*5), 16, 20, 0, 4, <T O U G H>, <T O V G H>, (5, 10, 9, 14, 19) ),
                  ( 19/(5*5), 24, 28, 0, 4, <T O U G H>, <T O V G H>, (5, 10, 9, 14, 19) ) );

my $needle4   = "whenthegoinggetstough";
my $R4        = ();

my $needle5   = "TOUGH";
my $R5        = ( ( 25/(5*5), 16, 20, 0, 4, <T O U G H>, <T O U G H>, (5, 10, 15, 20, 25) ),
                  ( 25/(5*5), 24, 28, 0, 4, <T O U G H>, <T O U G H>, (5, 10, 15, 20, 25) ) );

my $haystack6 = "garçons mère canapé château sûr où Noël";
my $needle6   = "garcons mere canape chateau sur ou Noel";
my $R6        = 1/1;

my $haystack7 = "loboom:";
my $needle7   = "Iehc0n;";
my $R7        = 3/6;


# Tests
ok( fzindex($haystack1, $needle1).WHAT ~~ List, 'Return type' );
ok( fzindex($haystack1, $needle1)[0].elems ==  8, '8-Element match description' );
ok( fzindex("", $needle1) eqv (), 'Empty haystack');
ok( fzindex($haystack1, "") eqv (), 'Empty needle');
ok( fzindex("", "") eqv (), 'Empty haystack and empty needle');

ok( fzindex($haystack1, $needle1, :s_id(4), :s_nid(-1), :s_gap(-1))[0] eqv $R1, 'Match test 1' );
ok( fzindex($haystack2, $needle2, :s_id(3), :s_nid(-1), :s_gap(-2))[0;7] eqv $tb_sc2, 'Match test 2' );
ok( fzindex($haystack3, $needle3, :s_id(5), :s_nid(-1), :s_gap(-1)) eqv $R3, 'Match test 3' );
ok( fzindex($haystack3, $needle4, :s_id(5), :s_nid(-1), :s_gap(-1)) eqv $R4, 'No fuzzy match' );
ok( fzindex($haystack3, $needle5, :s_id(5), :s_nid(-1), :s_gap(-1)) eqv $R5, 'Multiple perfect matches' );
ok( fzindex($haystack6, $needle6, :ignore_diacritics)[0;0] eqv $R6, 'Ignore diacritics' );
ok( fzindex($haystack7, $needle7, :s_id(6), :s_ocr(3), :glossover_ocrerrors)[0;0] eqv $R7, 'Gloss over OCR errors' );
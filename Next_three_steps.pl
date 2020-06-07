#!usr/bin/perl
#open DB,"$ARGV[0]";
#open OUT,">$ARGV[1]";

$a=$ARGV[0];
$b=$ARGV[1];


#step 1
$c=$a."\\step1_format.pl";

$d=$b."\\SPPA_score.txt";

$e=$b."\\result_step1.txt";


system("perl $c $d $e");



#step 2
$c=$a."\\step2_filter.pl";

$d=$b."\\result_step1.txt";

$e=$b."\\result_step2_0.01.txt";
$f=$b."\\result_step2_0.05.txt";
$g=$b."\\result_step2_0.1.txt";


system("perl $c $d $e $f $g");



#step 3
$c=$a."\\step3_getinform.pl";

$d=$a."\\reactome_data.txt";

$e=$b."\\result_step2_0.01.txt";
$f=$b."\\result_step2_0.05.txt";
$g=$b."\\result_step2_0.1.txt";

$h=$b."\\result_step3_0.01.txt";
$i=$b."\\result_step3_0.05.txt";
$j=$b."\\result_step3_0.1.txt";


system("perl $c $d $e $h");
system("perl $c $d $f $i");
system("perl $c $d $g $j");




#step 4
$c=$a."\\step4_kind.pl";

$h=$b."\\result_step3_0.01.txt";
$i=$b."\\result_step3_0.05.txt";
$j=$b."\\result_step3_0.1.txt";

$k=$b."\\result_step4.txt";


system("perl $c $h $i $j $k");




#step 5
$c=$a."\\step5_data.pl";

$d=$b."\\result_step1.txt";
$e=$b."\\result_step3_0.05.txt";

$f=$b."\\result_step5.txt";


system("perl $c $d $e $f");



#step 6
$c=$a."\\step6_filterp.pl";

$d=$b."\\result_step5.txt";

$e=$b."\\result_step6.txt";
$f=$b."\\result_step6_sub.txt";


system("perl $c $d $e $f");




#step 7
$c=$a."\\step7_TES.pl";

$d=$b."\\result_step6_sub.txt";
$e=$b."\\result_step6.txt";

$f=$b."\\result_step7.txt";
$g=$b."\\result_step7_effect.txt";


system("perl $c $d $e $f $g");












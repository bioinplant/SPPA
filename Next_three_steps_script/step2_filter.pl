#!usr/bin/perl
open DB,"$ARGV[0]";
open OUTA,">$ARGV[1]";
open OUTB,">$ARGV[2]";
open OUTC,">$ARGV[3]";

#其中$4的值为对应的函数显著性,问题在于如何确定基因数，在这相当于把基因集中少于10个的基因集全部去掉
while(<DB>)
{
        chomp;
         #print "$_\n";
        if($_ =~ /\AREACTOME\s+(.*)\s+(\S+)(\s+\S+\s+\S+\s+)(\S+)\Z/)
        {


              
              if(($2>=10)&&($4<=0.01)){
              
             
                print OUTA "$1\n";

              }

              if(($2>=10)&&($4<=0.05)){
              
             
                print OUTB "$1\n";

              }

              if(($2>=10)&&($4<=0.1)){
              
             
                print OUTC "$1\n";

              }

        }
        
       

}




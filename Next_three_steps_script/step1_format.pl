#!usr/bin/perl
open DB,"$ARGV[0]";
open OUT,">$ARGV[1]";


#主要目的在于去除掉result结果中存在的下划线
while(<DB>)
{
        chomp;
        
        if($_ =~ /\AREACTOME_(\S+)\s+(\S+)\s+(.*)\s+(\S+)\Z/)
        {
              
              s/\_/ /g;
              #去除掉result结果中的下划线
             
                print OUT "$_\n";

              
        }
        
       

}




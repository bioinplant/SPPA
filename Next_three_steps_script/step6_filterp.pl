#!usr/bin/perl
open DB,"$ARGV[0]";
open OUT,">$ARGV[1]";
open OUTA,">$ARGV[2]";


#提取出两个文件，第一个文件表示的是哪些主要的功能类别
#第二个提取的是各通路已经按基因数加权的分值
while(<DB>)
{
        chomp;
        
        if($_ =~ /\A(\d+\s+.*)\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\Z/)
        {
              
            
                #print OUT "$1\n";
                print OUTA "$1\n";
              
        }elsif($_ =~ /\ACategory/){ print OUT "Category\tFunction\tPN\tGN\tES\tZS\tPvalue\tGWES\n";
        }
        elsif($_ =~ /(.*)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\Z/)
        {
              
            if(($4!=0)&&($2!=0)&&($5>=0)&&($5<=0.05)){
                $gwes=log($2)/log(10)*$4;
                print OUT "$1\t$2\t$3\t$4\t$5\t$gwes\n";
            }
              
        }

        
       

}




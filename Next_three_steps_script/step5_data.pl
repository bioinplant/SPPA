#!usr/bin/perl
open DB,"$ARGV[0]";
open IN,"$ARGV[1]";
open OUT,">$ARGV[2]";

print OUT "Category\tPathway\tPN\tGN\tES\tZS\tPvalue\n";


#此时的正则表达式匹配使用\Z就可以将后面的四个数值一次性提取出来
#同时也确保了中间通路名称的完整性
#同时建立以通路编号为键，后面4个数值为值的字典
while(<DB>)
{
        chomp;
        
        if($_ =~ /\AREACTOME\s+(.*)\s+(\S+\s+\S+\s+\S+\s+\S+)\Z/){
        
               $a{$1}=$2;
               #print "$1\n";
        }
        
       

}


#同样使用\Z正则表达式
#$2表示的是在0.05显著水平下，对应的通路名
#获得在0.05显著水平下对应的通路完整信息，包括Pathway_namber,gene_namber,Effect_score,z_score,P_value
while(<IN>)
{
        chomp;
        
        if($_ =~ /\A(\S+)\t(.*)\t(\S+)\Z/){
               #print "$2\n";
               if(exists$a{$2}){
                 #print "$2\n";
                 print OUT "$1\t$2\t$3\t$a{$2}\n";
               }else{
                 print OUT "$1\t$2\t$3\t0\t0\t0\t0\n";
               }
        }
 
      
}




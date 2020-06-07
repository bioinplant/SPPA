#!usr/bin/perl
open SUB,"$ARGV[0]";
open SIX,"$ARGV[1]";

open OUT,">$ARGV[2]";
open OUTA,">$ARGV[3]";

print OUT "Category\tFunction\tNES\n";

#首先建立一个对应的字典结构
while(<SUB>)
{
        chomp;
        
        if($_ =~ /\A(\S+)\s+(.*)\Z/)
        {
              
            
               $a{$1}=$2;

     
        }
}

#获取字典中所有的键
@k=keys %a;


#先获取子级通路的通路名
#同时$1是最高级通路对应的编号
#$2是每条通路的GWES值，就是基因数加权的Z-score
#将各个不同等级通路的分值全部相加起来的
while(<SIX>)
{
        chomp;
        
        if($_ =~ /\A(\d+)\..*\s+(\S+)\Z/)
        {
              
            
      
                  if(exists($a{$1})){
                     $b{$1}=$b{$1}+1;
                     $c{$1}=$c{$1}+$2;
                  }

               

     
        }
}


#再按照通路的个数进行加权？
#log在Perl中表示e为底的自然对数
#log中加1，是为了保证为整数
foreach $k (@k){
  
  $x=$b{$k};
  $y=$c{$k};
 if($x!=0){  
  $nes=$y/$x*log($x+1);
  print OUT "$k\t$a{$k}\t$nes\n";
  $an=$an+$nes;
 }
}

print OUTA "Effect score\t$an\n";
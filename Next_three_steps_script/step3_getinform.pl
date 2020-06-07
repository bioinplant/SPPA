#!usr/bin/perl
open DB,"$ARGV[0]";
open IN,"$ARGV[1]";
open OUT,">$ARGV[2]";


#在对应的reactome通路集中找到对应的显著表达的通路

#第一步建立了一个数组，两个字典
#第一个数组指的是对应的通路编号$1
#第二个字典指的是对应的通路名$3
#第三个字典指的是通路编号均先指向0
while(<DB>)
{
        chomp;
        
        if($_ =~ /(\S+)(\s+)(.*)/)
        {
               push(@array,$1);
               $nam{$1} = $3;
               $num{$1} = 0;
        }
        
       

}


#在reactome中查找不同显著水平的通路，如果找到，就将对应的字典值设定为1
#目前这个方法是将子级通路直接加到最高级的通路中的
#关于通路基因集还是有问题
#GSEA的通路集还是存在问题，因为他的划分还是有问题？？？？？？
while(<IN>)
{
      chomp;
      #print "$_\n";
      foreach $array (@array){
          
          if($nam{$array} eq $_){
             #print "$_  $array\n";
             $num{$array} = $num{$array} + 1;

             #$nam{$array} = "$nam{$array}"." _A_";

             $x = $array;

             while($x =~ /(.*)\.(\d+)$/){

                $num{$1} =  $num{$1} + 1;
                $x = $1;

             }

             last;
             #$num{$x} =  $num{$x} + 1;
 
          }


      }

      
}


foreach $key (sort keys %nam){
    
    if($num{$key} > 0){

       print OUT "$key\t$nam{$key}\t$num{$key}\n";

    }

}


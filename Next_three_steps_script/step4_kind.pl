#!usr/bin/perl
open EVO,"$ARGV[0]";
open EVF,"$ARGV[1]";
open EVS,"$ARGV[2]";
open OUT,">$ARGV[3]";

print OUT "Category\tFunction\tP\<0.01\tP\<0.05\tP\<0.1\n";

#完全匹配步骤三得到的文件（0.01），但是只匹配了最高级别的通路
#建立一个由通路等级及通路名组成的数组
#建立一个由通路等级和通路名作为键，个数作为值构成的字典
while(<EVO>)
{
        chomp;
        if($_ =~ /^(\d+\s.*)\s(\d+)/){

                 push(@name,$1);
                 $kind{$1} = $2;      
        }

}



#首先建立完全匹配0.05的文件
#显示在0.01和0.05条件下通路的个数
while(<EVF>)
{
        chomp;
        if($_ =~ /^(\d+\s.*)\s(\d+)/){

             if(!(exists($kind{$1}))){
                 push(@name,$1);
                 $kind{$1} = "0\t$2";
             }elsif(exists($kind{$1})){
                 $kind{$1} = "$kind{$1}"."\t$2";
             } 
            
        }

}


#如果在P<0.05中没有数字，就在后面加上一个0
foreach $name (@name){

      if($kind{$name} =~ /^(\d+)$/){

         $kind{$name} = "$kind{$name}"."\t0";
 
      }
    
}


#后面的三个数值作为前面名称为键的值，是一个宏观的字典
while(<EVS>)
{
        chomp;
        if($_ =~ /^(\d+\s.*)\s(\d+)/){

             if(!(exists($kind{$1}))){
                 push(@name,$1);
                 $kind{$1} = "0\t0\t$2";
             }elsif(exists($kind{$1})){
                 $kind{$1} = "$kind{$1}"."\t$2";
             } 
            
        }

}


#同理，如果P<0.1没有数值的话，就在其后加上一个0
foreach $name (@name){

      if($kind{$name} =~ /^(\d+)\s(\d+)$/){

         $kind{$name} = "$kind{$name}"."\t0";
 
      }
    
}

#
foreach $name (sort keys %kind){

   print OUT "$name\t$kind{$name}\n";

}



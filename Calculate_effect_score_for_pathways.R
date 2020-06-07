# Calculation of effect score for each biological signaling pathway
# Parameters：
# 1. Gene expression data for multiple samples
# 2. the column of the control data
# 3. the column of the data of treatment
# 4. Path to Reactome pathway information data
# 5. Path to store result

options(stringsAsFactors = FALSE)
args <- commandArgs(trailingOnly = TRUE)
# Loading data and preprocessing
exprdata <- read.table(args[1], header = TRUE, skipNul = TRUE, row.names = 1) # Load expression data of all samples
exprdata <- exprdata + 0.00000001  
numcol <- ncol(exprdata)   
numrow <- nrow(exprdata) 
air_mean <- matrix(0, nrow = numcol, ncol = 1)  
mss_mean <- matrix(0, nrow = numcol, ncol = 1)  
air_var <- matrix(0, nrow = numcol, ncol = 1)   
mss_var <- matrix(0, nrow = numcol, ncol = 1)   
for (i in 1:Ncol) {
  nba<-as.numeric(b[i,args[2]) # Set the column of the control data
  air_mean[i,1]<-mean(nba)
  air_var[i,1]<-var(nba) 
}
for (i in 1:Ncol) {
  nbs<-as.numeric(b[i,args[3]) # Set the column of the experiment data
  mss_mean[i,1]<-mean(nbs)
  mss_var[i,1]<-var(nbs)
}

mss_air_diff_mean <- mss_mean - air_mean 
s <- sqrt(mss_var/2 + air_var/2)
z <- mss_air_diff_mean / s
row.names(z)<-row.names(exprdata)
zabsna <- na.omit(abs(z))
zorder <- order(zabsna)
rn <- row.names(zabsna)
zorder <- order(zabsna,decreasing = TRUE) 
zsort <- t(rbind(rn[zorder],zabsna[zorder]))                        
zsort_gene <- as.matrix(zsort[,1])  
zsort_score <- as.matrix(zsort[,2])
nzs <- nrow(zsort) 

# Loading pathway data
geneset <- read.csv(args[4], header = FALSE)
gs_nr <- nrow(geneset)

# Score calculation
cal_ES<-function(nzs,gso,zsort_gene){
  zsum <- 0
  zt <- 0
  hitsum <- 0
  for(i in 1:nzs){
    if(zsort_gene[i,] %in% gso){
      zt <- zt + 1
      ss <- as.numeric(zsort_score[i,])  
      hitsum <- hitsum + ss 
    }
  }
  kk <- nzs - zt
  kka <- 1 / kk  
  ES <- 0   
  ww <- 0
  gst <- matrix(0, nrow = nzs, ncol = 2)
  gl <- matrix(0, nrow = zt, ncol = 2)
  zta <- 0
  for(i in 1:nzs){
    zta <- zta + 1
    if(zsort_gene[i,] %in% gso){
      ww <- ww + 1
      gl[ww,1] <- zsort_gene[i,1]
      gl[ww,2] <- i              
      pp <- as.numeric(zsort_score[i,1])
      EST <- pp / hitsum      
    }else{
      EST<--kka    
    }
    ES <- ES + EST     
    gst[zta,1] <- zta  
    gst[zta,2] <- ES
  }
  
  ng <- gst[,2] 
  
  mn <- max(ng)
  mp <- which.max(ng)  
  return(mn)
}
  
allset <- matrix(0, nrow=gs_nr, ncol=5) 
alles <- matrix(0, nrow=gs_nr, ncol=3)   

for(ii in 1:gs_nr){
  if((ii %% 20)==0){    
    print(ii)
  }
  zsum<-0
  zt<-0
  hitsum<-0
  gsa<-geneset[ii,] 
  gsa<-t(gsa) 
  gsname<-gsa[1,] 
  gso<-gsa[-1,]
  for(i in 1:nzs){
    if(zsort_gene[i,] %in% gso){
      zt<-zt+1
      ss<-as.numeric(zsort_score[i,])
      hitsum<-hitsum+ss 
    }
  }
  kk <- nzs - zt
  kka <- 1 / kk
  ES <- 0  
  ww <- 0
  gst <- matrix(0, nrow=nzs, ncol=2)
  gl <- matrix(0, nrow=zt, ncol=2)
  zta <- 0
  for(i in 1:nzs){
    zta <- zta+1
    if(zsort_gene[i,] %in% gso){
      ww <- ww+1
      gl[ww,1] <- zsort_gene[i,1]  
      gl[ww,2] <- i 
      pp <- as.numeric(zsort_score[i,1])
      EST <- pp/hitsum  
    }else{
      EST<--kka
    }
    ES <- ES + EST  
    gst[zta,1] <- zta  
    gst[zta,2] <- ES   
  
  ng <- gst[,2]
  
  mn <- max(ng)  
  mp <- which.max(ng) 
  alles[ii,1] <- gsname   
  alles[ii,2] <- zt       
  alles[ii,3] <- mn      
  
  #permutation
  to <- 520
  ep <- matrix(0, nrow=to, ncol=1) 
  
  for(p in 1:to){
    sample(zsort_gene,zt) -> rs 
    wc<-0
    rs_sc <- matrix(0, nrow=zt, ncol=2) 
    for(i in 1:nzs){       
      if(zsort_gene[i,] %in% rs){
        wc<-wc+1
        rs_sc[wc,1]<-zsort_gene[i,1]
        rs_sc[wc,2]<-zsort_score[i,1]
      }
      
    }
    
    row.names(rs_sc)<-rs_sc[,1]
    rs_sc<-rs_sc[,-1]   
    rs_sc<-as.matrix(rs_sc)
    rs_scm<-as.numeric(rs_sc)
    rscn<-row.names(rs_sc)
    rsorder<-order(rs_scm,decreasing = TRUE) 
    rsort<-rbind(rscn[rsorder],rs_sc[rsorder]) 
    rsort<-t(rsort)
    rgene<-rsort[,1]
    
    cal_ES(nzs,rgene,zsort_gene)->ep[p,1] 
    
  }
  ep <- ep[!is.na(ep[,1]),1]
  epm<-mean(ep)
  eps<-sd(ep) 
  
  nesz<-(mn-epm)/eps 
  pv<-1-pnorm(mn,mean=epm,sd=eps)  
  
  
  allset[ii,1] <- gsname  
  allset[ii,2] <- zt      
  allset[ii,3] <- mn      
  allset[ii,4] <- nesz   
  allset[ii,5] <- pv    
  
  ##plot enrichment score plot
  setwd(args[5]) # Set path to storage pictures
  future=paste(gsname,".png",sep="")
  png(file=future,width=600*3,height=3*600,res=72*3)
  par(fig=c(0,1,0.5,1))
  par(mar = c(0,4,2,1))
  plot(gst[,2],type="l",col="red",xlab="",ylab="Enrichment score",xaxt="n",main=gsname)
  sq<-seq(0,nzs,by=1000)
  abline(v = sq, col = "lightgray", lty = 3)
  sh<-seq(0,mn,by=0.1)
  abline(h = sh, col = "lightgray", lty = 3)
  mnr<-round(mn,2)
  points(mp,mn,col="darkgreen",cex=1,lwd=1,pch=19)
  text(mp,mn, mnr, col = "darkgreen", adj = c(-1, 0.9))
  abp<-gl[,2]
  abp<-as.numeric(abp)
  par(fig=c(0,1,0.4,0.5),mar = c(0,4,0,1),new=TRUE)
  plot(c(0,nzs), c(0,1), type = "n", xlab = "x", ylab = "Rank",yaxt="n",xaxt="n")
  abline(v = abp, col = "blue")
  as.numeric(zsort_score[,1])->dp
  dpl<-log2(dp+1)
  md<-max(dpl)
  par(fig=c(0,1,0.25,0.4),mar = c(0,4,0,1),new=TRUE)
  plot(dpl,type="h",xlab="Rank in Ordered Dataset",ylab="Z score",col="grey60")
  abline(v = sq, col = "lightgray", lty = 3)
  sx<-seq(0,md,by=2)
  abline(h = sx, col = "lightgray", lty = 3)
  
  par(fig=c(0,1,0,0.2),mar = c(0.12,4,1,1),new=TRUE)
  plot(c(0,1), c(0,4), type = "n", xlab = "", ylab = "",xaxt="n",yaxt="n")
  mnp<-round(mn,3)
  neszp<-round(nesz,3)
  pvp<-round(pv,3)
  sent<-paste("This figure represents the ES in ",gsname,".\nThe ES is ",mnp, ".\nThe rank of ",zt," genes in this gene set among all the genes.\n","And the Z score of all the genes.",sep="")
  x<-0
  y<-1.6
  text(x,y,sent,cex=1,font=3,pos=4)
  dev.off()
  
  setwd(args[5]) # Set path to storage pictures
  fu=paste(gsname,"_RES.png",sep="")
  png(file=fu,width=600*3,height=3*600,res=72*3)
  dp<-paste(gsname)
  par(fig=c(0,1,0.3,0.9))
  par(mar = c(1.2,4,1,4))
  hist(ep, freq = F, breaks = 30,main=dp,cex=.5,xlab="Random ES distribution",col = "lightblue",lty=2,col.main="red",cex.main=1,xlim=c(0,1))
  abline(v = mn, col = "red",lwd=2)
  mnr<-round(mn,2)
  text(mn,1, mnr, col = "red", adj = c(-.1, 1))
  par(fig=c(0,1,0.03,0.3),mar = c(1.2,4,1,4),new=TRUE)
  plot(c(0,1), c(0,4), type = "n", xlab = "", ylab = "",xaxt="n",yaxt="n")
  mnp<-round(mn,3)
  neszp<-round(nesz,3)
  pvp<-round(pv,3)
  sent<-paste("This figure represents the distribution of ES in ",to," permutations.\n","And the position of ",gsname,".\n","The ES is ",mnp,".\nThe Z score is ",neszp," and the p value is ",pvp,".\n",sep="")
  x<-0
  y<-1.4
  text(x,y,sent,cex=1,font=3,pos=4)
  dev.off()
}
}
path <- paste0(args[5],"./SPPA_score.txt")
write.table(allset, path,quote = FALSE, row.names = FALSE, col.names = FALSE,sep = "\t") # Save the reault

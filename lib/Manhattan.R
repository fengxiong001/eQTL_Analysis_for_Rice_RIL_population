library('qqman')
data <- read.table(" Ehd1_eQTL_result.txt ")
data <-data[,c(4,5,6,7)]
colnames(data)<-c('SNP','CHR','BP','P')
manhattan(data, suggestiveline = FALSE, genomewideline = FALSE , annotatePval = 5e-40, annotateTop = FALSE,ylim=c(0,50),cex = 0.9, cex.axis = 0.9)
abline(h=-log10(6.17e-04), col="blue", lty=1, lwd=3) 
abline(h=-log10(6.12e-04), col="red", lty=2, lwd=3)


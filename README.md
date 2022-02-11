# protocol
Bioinformatics Recipes for Rice eQTL - data, code and workflows
# Installation
## Running environment:
The workflow was constructed based on the Linux system
## Required software and versions:
### Installing Anaconda 
- wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-4.1.0-Linux-x86.sh
- bash Anaconda3-4.1.0-Linux-x86.sh
- echo 'export PATH="~/anaconda2/bin:$PATH"' >> ~/.bashrc
- source ~/.bashrc
### Installing Htslib
- conda install -c bioconda htslib
### Installing Bcftools
- conda install -c bioconda bcftools
### Installing Samtools
- conda install -c bioconda samtools 
### Installing R 3.6.1
- conda install r-base=3.6.1
### Installing QTLtools(download and unzip to use)
- wget https://qtltools.github.io/qtltools/binaries/QTLtools_1.2_CentOS7.8_x86_64.tar.gz
- tar xzvf QTLtools_1.2_CentOS7.8_x86_64.tar.gz
# Input Data
The raw data are available from the National Center for Biotechnology Information Gene Expression Omnibus database under the accession number GSE49020.
- a.	Genotype data（VCF/BCF format）:eQTL_genotype.vcf
- b.	eTrait/phenotype data（BED format）:flag_leaf_eTrait.bed
# Major steps
### Step 1: compressed and indexed raw data
       sh Compression.sh
- Script content of Compression.sh
```ruby 
bgzip eQTL_genotype.vcf
tabix -p vcf eQTL_genotype.vcf.gz
bgzip flag_leaf_eTrait.bed 
tabix -p flag_leaf_eTrait.bed.gz
``` 
### Step 2: cis-eQTL identification with QTLtools
       sh QTLtools_cis.sh
- Script content of QTLtools_cis.sh
```ruby 
QTLtools cis --vcf eQTL_genotype.vcf.gz --bed flag_leaf_eTrait.bed.gz --permute 1000 --out flag_leaf_eTrait_cis_permutation.txt
``` 
### Step 3: trans-eQTL identification with QTLtools
       sh QTLtools_trans.sh
- Script content of QTLtools_trans.sh
```ruby 
##command 1 
QTLtools trans --vcf eQTL_genotype.vcf.gz --bed flag_leaf_eTrait.bed.gz --nominal --threshold 0.05 --out flag_leaf005.trans.nominal.hits.txt.gz

##command 2
for i in {1..100};do
       QTLtools trans --vcf eQTL_genotype.vcf.gz --bed flag_leaf_eTrait.bed.gz --threshold 0.05 --permute --out flag_leaf005_trans_perm_${i} --seed ${i} 
done

##command 3
zcat flag_leaf005_trans_perm_*.hits.txt.gz | gzip -c > flag_leaf005_permutations_all.txt.gz
Rscript runFDR_ftrans.R flag_leaf005.trans.nominal.hits.txt.gz flag_leaf005_permutations_all.txt.gz flag_leaf_trans_005_permutations_all.txt
``` 
### Step 4: D.	Draw Manhattan diagram with R script
       sh get_Ehd1_eQTL_result.sh
- Script content of get_Ehd1_eQTL_result.sh
```ruby 
zcat flag_leaf005.trans.nominal.hits.txt.gz | grep OsAffx.30643.1.S1_at > Ehd1_eQTL_result.txt
``` 
        Rscript Manhattan.R
- Script content of Manhattan.R
```ruby 
library('qqman')
data <- read.table(" Ehd1_eQTL_result.txt ")
data <-data[,c(4,5,6,7)]
colnames(data)<-c('SNP','CHR','BP','P')
manhattan(data, suggestiveline = FALSE, genomewideline = FALSE , annotatePval = 5e-40, annotateTop = FALSE,ylim=c(0,50),cex = 0.9, cex.axis = 0.9)
abline(h=-log10(6.17e-04), col="blue", lty=1, lwd=3) 
abline(h=-log10(6.12e-04), col="red", lty=2, lwd=3)
``` 
# Expected results
### You will get cis-eQTL results and trans-eQTL results files
- flag_leaf_eTrait_cis_permutation.txt
- flag_leaf005.trans.nominal.hits.txt.gz 
- flag_leaf_trans_005_permutations_all.txt（ Compare to the “flag_leaf005.trans.nominal.hits.txt.gz”,this file has an additional column that gives the estimated false discovery rate (FDR) for each eTrait by 100 permutations.）
### Manhattan plot of OsAffx.30643.1.S1_at
![图片名称](https://github.com/ziongfen/protocol/blob/main/graphs/Manhattan_plot_of_OsAffx.30643.1.S1_at.png)

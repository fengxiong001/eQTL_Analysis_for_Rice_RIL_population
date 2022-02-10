# protocol
The repository will be created and you will be authorized to be able to submit the code directly
# Installation
## Running environment:
The workflow was constructed based on the Linux system
## Required software and versions:
### Installing Anaconda 
##### wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-4.1.0-Linux-x86.sh
##### bash Anaconda3-4.1.0-Linux-x86.sh
##### echo 'export PATH="~/anaconda2/bin:$PATH"' >> ~/.bashrc
##### source ~/.bashrc
### Installing Htslib
##### conda install -c bioconda htslib
### Installing Bcftools
##### conda install -c bioconda bcftools
### Installing Samtools
##### conda install -c bioconda samtools 
### Installing R 3.6.1
##### conda install r-base=3.6.1
### Installing QTLtools(download and unzip to use)
##### wget https://qtltools.github.io/qtltools/binaries/QTLtools_1.2_CentOS7.8_x86_64.tar.gz
##### tar xzvf QTLtools_1.2_CentOS7.8_x86_64.tar.gz
# Input Data
The raw data are available from the National Center for Biotechnology Information Gene Expression Omnibus database under the accession number GSE49020.
#### a.	Genotype data（VCF/BCF format）:eQTL_genotype.vcf
#### b.	eTrait/phenotype data（BED format）:flag_leaf_eTrait.bed

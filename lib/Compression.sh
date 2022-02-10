bgzip eQTL_genotype.vcf
tabix -p vcf eQTL_genotype.vcf.gz
bgzip flag_leaf_eTrait.bed 
tabix -p flag_leaf_eTrait.bed.gz


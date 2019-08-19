# GTEx fine-mapping with individual level data

## Goal

Create a pipeline to perform cis-eQTL fine-mapping using individual level data. This includes data preprocessing / formatting, fine-mapping and reporting the analysis results

## Data

- Genotype data `/project/compbio/GTEx_dbGaP/GTEx_Analysis_2017-06-05_v8/genotypes/WGS/variant_calls` there is a file called `GTEx_Analysis_2017-06-05_v8_WholeGenomeSeq_838Indiv_Analysis_Freeze.SHAPEIT2_phased.vcf.gz` which contains phased & imputed variants. 
- Expression data `/project/compbio/GTEx_dbGaP/GTEx_Analysis_2017-06-05_v8/eqtl/GTEx_Analysis_v8_eQTL_expression_matrices` has data for each tissue.
- Covariates data `/project/compbio/GTEx_dbGaP/GTEx_Analysis_2017-06-05_v8/eqtl/GTEx_Analysis_v8_eQTL_covariates` similarly organized as above.

## Prepare input

The key step here is to extract cis-SNPs for each gene. 

### Get cis-SNPs

We take into consideration all SNPs located 1Mb up and downstream of a gene's transcription start site (TSS). You need to:

1. Get a list of all genes that has expression & covariate data from "Expression data" above.
2. Add TSS info for these genes. That is, to annotate the genes. This can be done via R's `biomart`. I've got [an example here](http://stephenslab.github.io/gtex-eqtls/analysis/20170929_Genotype.html).
3. Once you have the TSS info you can extract SNPs from the genotype file for the range between `TSS - 1Mb` and `TSS + 1Mb`. This can be done using `bcftools`. You can drop multiallelic variants and focus on biallelic for the time being.
4. You need to create a numeric matrix from the VCF file by mapping genotype to numbers under additive model:

```
0/0 -> 0
0/1 -> 1
1/1 -> 2
```

It should be straightforward using any programming language (bash or Python) but someone (a collaborator of mine) suggested http://lindenb.github.io/jvarkit/BioAlcidae.html

### Get expression and covariates

Should be straightforward. But you have to make sure the ordering of samples in genotypes match that of phenotypes and covariates. You may need to drop some samples for missing either genotype or phenotype data. 

## Quality control

One should always assume QC is necessary, until evaluated and proven otherwise. For our case

1. No QC is needed for expression data because GTEx group have done it for the analysis-ready release.
2. No QC is needed for genotype calls because we use a version after imputation.
3. What you need to do: for each fine-mapping locus (tissue-gene-SNP data-set), SNPs with a minor allele frequency of <0.01 or have minor allele in <10 samples should be removed.

## Formatted data

You can format each fine-mapping locus to using DAP-G's input format. **However I really do suggest that we make a more generic and compact database for GTEx and use some wrapper to run DAP-G**. I therefore suggest formatting an analysis unit to a single RDS file. I'll pass that file example along on slack and discuss with you. 
1. All expression

## Build a pipeline

For starters, please start with analyzing one tissue, and write down everything using SoS Notebook. They do not have to be a formal SoS Workflow for now, but the notebook should have all commands needed with all details documented. 

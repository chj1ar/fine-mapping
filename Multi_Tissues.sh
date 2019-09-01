#! /bin/bash

echo "You should collect the Ensembl gene ID of all genes of interest into one file, and then pass this file as the argument of this script."

echo "sos run Multi_tissues.ipynb preprocessing"
sos run Multi_tissues.ipynb preprocessing

for ensembl_gene_id in $(less $1) 
do
	echo "sos run Multi_tissues.ipynb extract --ensembl-gene-id $ensembl_gene_id"
	sos run Multi_tissues.ipynb extract --ensembl-gene-id $ensembl_gene_id
done


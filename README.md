## NOrthGen
# Nucleotide Ortholog Generator

## Purpose
NOrthGen is developed to obtain orthologs from genomes/transcriptomes as nucleotides.

## Installation
This standalone tool is implemented in BASH and does not require any additional dependencies. Simple download or clone the files to your directory and they are ready to use.

## Usage 
1. Input files required for running NOrthGen are the full_table_taxon-name output of BUSCO (Simão et al. 2015) and the .mRNA file which is an output of TransDecoder (Haas et al. 2013). 

2. Create a directory raw/ and put bin full_tables and their respective .mRNA files in their taxon-name directory. You can use the "1.PreparingInput.sh" for this purpose, however READ comments in it before executing.

3. Once the input it ready, execute "2a.NOrthGen_till_nuc_buscos.sh" if you want only orthologs as nucleotides. If you desire to have gene files, you can run them sequentially "2a.NOrthGen_till_nuc_buscos.sh" and then "2b.NOrthGen_locus.sh" or "2.Complete_NOrthGen.sh" directly. 

4. Orthologs as nucleotides will be binned in the newly created nuc_BUSCOs/ directory and gene files will be binned in Loci/ directory. Gene files are ready to be aligned using the tool of your choice.

5. If you wish to delete all the intermediate files, execute "3.Clean.sh". Only the .mRNA input file and the output files will remain.

For any queries, email sskspider@gwmail.gwu.edu

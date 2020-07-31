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


## Discussion
Input
NOrthGen requires a BUSCO run on the translated data which aids in generating a match of assembly identifier with the ortholog identifier. The resulting BUSCO scores table and the .mRNA output file of TransDecoder (Haas et al. 2013) are used as input files.

Analysis modules
NOrthGen has three analysis modules:  nuc_BUSCOs, loci and cleaning.

nuc_BUSCOs: It obtains information from the BUSCO scores table to match the ortholog group with gene identity and bins that information in a file. The .mRNA file creates individual files for each sequence for all taxa. The BUSCO scores table file is then modified to an executable that searches and replaces the corresponding gene identities in the individual sequence files. The missing and duplicate orthologs are omitted. The resulting nucleotides with ortholog identifiers are then concatenated for each taxon and binned to a directory “nuc_BUSCOs/”.

Loci: For alignment purposes, orthologous sequences are required to be in a single file. This second module of NorthGen takes the output of nuc_BUSCOs and compiles them into gene-wise files. This however requires that all the taxa and orthogroups to be processed have already been subjected through nuc_BUSCOs module. It starts by generating a fasta file for each sequence from nuc_BUSCOs and creates a temporary executable to map the list of all orthogroups. The executable then concatenates the orthologs based on their identifier and then bins them into a directory “Loci/”. 

cleaning: The above two modules create many files like single sequence files for each .mRNA input and modified BUSCO scores tables. This optional module is designed to delete all files except the .mRNA input file and the results. 


For any queries, email sskspider@gwmail.gwu.edu

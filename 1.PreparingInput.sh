##1. Create a directory "raw" within NOrthGen/ directory and copy all .mRNA files into it (i.e. /NOrthGen/raw/)

###################################################################################################
##(Optional) can modify the following for loop to copy all .mRNA and  full_table_taxon-name files##
####for i in ./CD-HIT/run_*/full*; do cp $i ./raw/; done                                         ##
####for i in ./CD-HIT/*.mRNA; do cp $i ./raw/; done                                              ##
###################################################################################################


##-----------------------------------------------------------------------------------##
##IMPORTANT: This and the next script needs to be executed from the directory NOrthGen/##
##-----------------------------------------------------------------------------------##


##Copy .mRNA files to their taxon-name-wise directories. 
##Before using the following commands, make sure that the .mRNA file is in the format of ZZZZZZ.fasta.transdecoder.mRNA and the full_table_ZZZZZZ.##

for i in *.mRNA; do mkdir -- "${i%.fasta.transdecoder.mRNA}"; done
for i in *.mRNA; do mv -- "$i" ./"${i%.fasta.transdecoder.mRNA}";done
for f in full_table_*; do mv "$f" ./"${f#full_table_}"; done

echo "Check if all the .mRNA and full_table files are in their respective directories. If yes, go to NOrthGen/ directory and execute the next script"

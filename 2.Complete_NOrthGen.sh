echo "        _   _   ___       _   _      ____              "
echo "       | \ | | / _ \ _ __| |_| |__  / ___| ___ _ __    "
echo "       |  \| |  | | | '__| __| '_ \| |  _ / _ \ '_ \   "
echo "       | |\  |  |_| | |  | |_| | | | |_| |  __/ | | |  "
echo "       |_| \_| \___/|_|   \__|_| |_|\____|\___|_| |_|  "
echo "                                                        "
echo "       Nucleotide      Ortholog         Generator  "

echo
echo
echo "version 1"
echo "Developed by Siddharth Kulkarni, Gonzalo Giribet & Gustavo Hormiga"
echo
echo "---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo
echo "NOrthGen began at:"
date
echo
##Delete everything after pipe (|) from .mRNA file

echo "Cleaning .mRNA files now"

PWD=`pwd`
for p in $PWD/raw/*/; do cd "$p" &&
sed -i 's/|.*$//' *.mRNA
done
echo
echo "All .mRNA files cleaned"

cd ../../


##Create a directory name within /raw/taxon-name/ and explode the files
PWD=`pwd`
for p in $PWD/raw/*; do cd "$p" &&
mkdir explode
cp *.mRNA ./explode/
done

cd ../../

##Explode the files
echo
echo "Searching and exploding .mRNA files now. It takes about five minutes per .mRNA file"

PWD=`pwd`
for p in $PWD/raw/*/explode/; do cd "$p" &&

while read line
do
    if [[ ${line:0:1} == '>' ]]
    then
        outfile=${line#>}.fasta
        echo $line > $outfile
    else
        echo $line >> $outfile
    fi
done < *.mRNA
done

echo "Fasta file explosion complete"

cd ../../../

##6. DELETE the .mRNA file from explode/ directory
PWD=`pwd`
for p in $PWD/raw/*/explode/ ; do cd "$p" && rm *.mRNA; done

cd ../../../

##Processing Full_table_taxon-name file. Remove Busco entries from full table which are "Missing" and "Duplicated"
echo "Generating Trinity-to-BUSCO-matcher now. Any remaining duplicates will be displayed "No such file or directory""
echo
PWD=`pwd`
for p in $PWD/raw/*/ ; do cd "$p" &&
sed -i '/Missing/d' full_table_*
sed -i '/Duplicated/d' full_table_*
sed -i -r 's/\S+//2' full_table_*

sed -i -r 's/\S+//3' full_table_*
sed -i -r 's/\S+//3' full_table_*

sed -i 's/|.*$//' full_table_*
sed -i -e "1d" full_table_*

done

cd ../../
#echo $PWD

##Duplicate columns
PWD=`pwd`
for p in $PWD/raw/*/ ; do cd "$p" &&
awk 'BEGIN{FS=OFS=" "} {$2 = $2 OFS $0} 1' full_table_* > full_table_taxon-name.tmp

##Delete first column
sed -i -r 's/\S+//1' full_table_taxon-name.tmp

##Delete rows for buscos without corresponding Trinity ids (missing BUSCOS)
#sed -i '/TRINITY/!d' full_table_taxon-name.tmp

##Add .fasta extension to third column
sed -i 's/.*/&.fasta/' full_table_taxon-name.tmp

##Duplicate third column
awk 'BEGIN{FS=OFS=" "} {$3 = $3 OFS $3} 1' full_table_taxon-name.tmp > full_table_taxon-name.tmp2

##Combine column two and three with an underscore
awk '{print $1"\t"$2"_"$3"\t"$4}' full_table_taxon-name.tmp2 > full_table_taxon-name.tmp3

##Add sed commands in part and complete the sed command writing
awk '{print "sed -i s/"$1"/"$2"/g""\t"$3}' full_table_taxon-name.tmp3 > full_table_taxon-name.tmp4
awk '{print $1"\t"$2"\t""'"'"'"$3"'"'"'" "\t"$4}' full_table_taxon-name.tmp4 > full_table_taxon-name.tmp5
mkdir DNA_buscos

##Make a DNA_buscos directory and move all .fasta (from mRNA explode) with BUSCOXXXX headers to this directory
awk '{print "mv "$4" ../DNA_buscos"}' full_table_taxon-name.tmp5 > ./explode/move_DNA_buscos.sh
done

cd ../..


##Execute the move command
PWD=`pwd`
for p in $PWD/raw/*/explode/ ; do cd "$p" &&
bash move_DNA_buscos.sh
done

echo
echo "Moving complete. Labelling of Trinity ids with BUSCO ids will begin now"
echo

cd ../../..

#echo $PWD

PWD=`pwd`
for p in $PWD/raw/*/ ; do cd "$p" &&
cp full_table_taxon-name.tmp5 ./DNA_buscos/
done

echo "Trinity-to-BUSCO-matcher copied to DNA_buscos, now executing ..."

cd ../..

##Execute full_table_taxon-name.tmp5 file in DNA_buscos directory
PWD=`pwd`
for p in $PWD/raw/*/DNA_buscos/ ; do cd "$p" &&
bash full_table_taxon-name.tmp5
done

echo
echo "Trinity-to-BUSCO-matcher execution complete"

cd ../../..

##Remove full_table_taxon-name.tmp5 file from DNA_buscos directory
PWD=`pwd`
for p in $PWD/raw/*/DNA_buscos/ ; do cd "$p" &&
rm full_table_taxon-name.tmp5
done

cd ../../..

#echo $PWD

#Generate taxon-wise BUSCO files with nucleotide data

echo
echo "Generating  nuc_BUSCOs_[taxon_name] files now"
echo

PWD=`pwd`
for p in $PWD/raw/*/DNA_buscos/ ; do cd "$p" &&
cat T* > nuc_BUSCOs.fasta
done


cd ../../..
#echo $PWD


PWD=`pwd`
for p in $PWD/raw/*/DNA_buscos/ ; do cd "$p" &&
cat T* > nuc_BUSCOs.fasta
mv nuc_BUSCOs.fasta $p/../
done

cd ../../..

PWD=`pwd`
for p in $PWD/raw/*/; do cd "$p" &&
for i in *.mRNA
do
mv nuc_BUSCOs.fasta nuc_BUSCOs_"${i%.fasta.transdecoder.mRNA}".fasta
done
done

cd ../..

PWD=`pwd`
for p in $PWD/; do cd "$p" &&
mkdir nuc_BUSCOs
done


PWD=`pwd`

for p in $PWD/raw/*/; do cd "$p" &&
mv nuc_BUS*  $p/../../nuc_BUSCOs
done

cd ../..

##______
#3. Delete everything after underscore

PWD=`pwd`
for p in $PWD/nuc_BUSCOs/; do cd "$p" &&
for q in nuc_BUSCOs_*
do
sed -i 's/_.*$//' $q
done
done

echo "Inserting taxon names next to the BUSCO ids now"

# Insert taxon names

for p in nuc_BUSCOs_*
do
sed -i '/^>/s/$/'${p#nuc_BUSCOs}'/' $p
sed -i 's/.fasta//g' $p
done

cd ../


##3. Explode multiple fasta files: includes for loop outside while loop##
echo
echo "DONE. Exploding nuc_BUSCOs_taxon-name files now"

PWD=`pwd`

cd $PWD/nuc_BUSCOs/ &&


for a in `ls -1 nuc_*`
do
while read line
do
    if [[ ${line:0:1} == '>' ]]
   then
        outfile=${line#>}.fasta
        echo "$line" > $outfile
    else
       echo "$line" >> $outfile
    fi
done < $a
done

echo "Explosion complete"


cd ../

#Move all BUSCOXXX_taxon-name.fasta files to a new directory named "Loci"
mkdir Loci
mv ./nuc_BUSCOs/BUSC* ./Loci
cd Loci/

#Make a list of BUSCO list

ls BUSC* -1 > list
sed -i 's/_.*$//' list

#Remove duplicates from the list
sort list | uniq > list2

rm list

#Duplicate columns and concatenate locus files
awk 'BEGIN{FS=OFS=" "} {$2 = $2 OFS $0} 1' list2 > list3
sed -i 's/ /* > locus_/' list3
sed -i 's/_ B/_B/' list3
sed -i "s/.*/cat &.fasta/" list3
rm list2

echo "Creating locus files now"
bash list3
rm list3
rm BUSC*
echo

##______
PWD=`pwd`
echo $PWD
touch Clean.sh
echo
echo
echo "NOrthGen ended at:"
date
echo
echo "---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo
echo "All BUSCO orthologs in nucleotide format for all taxa are located in $PWD/nuc_BUSCOs/"
echo "Your locus files are ready to be aligned in $PWD"
echo "If you wish to delete the intermediate files, execute the file 3.Clean.sh"

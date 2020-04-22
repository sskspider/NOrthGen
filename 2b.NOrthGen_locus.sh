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

echo $PWD

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
echo "Your locus files are in $PWD and ready to be aligned"

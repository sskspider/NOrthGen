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



###Put them in their own directory

for f in nuc_BUSCOs_*; do mkdir "${f#nuc_BUSCOs_}"; done

for f in nuc_BUSCOs_*; do mv "$f" ./"${f#nuc_BUSCOs_}"; done


cd ../

##3. Explode multiple fasta files: includes for loop outside while loop##
echo
echo "DONE. Exploding nuc_BUSCOs_taxon-name files now"

##_________________________________

PWD=`pwd`
for p in $PWD/nuc_BUSCOs/*/; do cd "$p" &&

while read line
do
    if [[ ${line:0:1} == '>' ]]
    then
        outfile=${line#>}.fasta
        echo $line > $outfile
    else
        echo $line >> $outfile
    fi
done < nuc_BUSCOs_*
done


##_________________________________

echo "Explosion complete"


cd ../../
##------------------------------
#Move all BUSCOXXX_taxon-name.fasta files to a new directory named "Loci"
mkdir Loci

PWD=`pwd`
for p in $PWD/nuc_BUSCOs/*/; do cd "$p" &&
mv BUSC* ../../Loci/
done

cd ../../

#mv ./nuc_BUSCOs/BUSC* ./Loci
cd Loci/

#echo $PWD

#Make a list of BUSCO list

echo BUSC* | xargs ls -1 > list
#ls BUSC* -1 > list
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
find . -name 'BUS*' | xargs rm -f
#rm BUSC*
echo
echo "Your locus files are in $PWD and ready to be aligned"

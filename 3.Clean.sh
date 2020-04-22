echo Deleting intermediate files now. Only the original .mRNA files and your output files will remain 
echo                                                                       
PWD=`pwd`                                                             
for p in $PWD/raw/*/;                            
do cd "$p" &&                                    
rm -r explode/                                                         
rm -r DNA_buscos/                                                 
rm full*                                                          
done                                                            
echo "Intermediate files deleted"

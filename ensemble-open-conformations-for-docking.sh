start_dir=$( pwd )
cd ./MD/snapshots-for-docking/MD-dock

for dist in 09 
do

    m=1

rm dist-$dist+sugar.pdb ; touch dist-$dist+sugar.pdb
    
    for i in {1..20}
	     do
	pdb=$( echo .//MD/snapshots-for-docking/MD-dock/$i/dist_$dist\_nm.pdb )

	if [ -e $pdb ]
	then

	    {
 grep ATOM $pdb | grep -v BGLC | grep -v BGAL |  sed 's/HSD/HIS/g'    |  sed 's/HSE/HIS/g'   
	    egrep 'BGLC|BGAL' $pdb |  sed 's/BGLC/BDP /g'  |  sed 's/BGAL/ASG /g' |   sed 's/ATOM  /HETATM/g'   | sed 's/ X/ Y/g' 
	    } > tmp.pdb
	    gmx editconf -f tmp.pdb -o tmp2.pdb -resnr 1
	    
	    
	    {
	    echo $m | awk ' { printf( "MODEL       %2d\n",$1 ) } ' 
	    egrep 'ATOM|HETATM' tmp2.pdb 
            echo "TER"
	    echo "ENDMDL"
	    } 	    >> dist-$dist+sugar.pdb

rm -f tmp*

	    
	    
echo $pdb  $i $m

m=$[m+1]
fi
	done


    # change format according to pymol
    cat> tmp.pml <<EOF
load dist-$dist+sugar.pdb, conf
save tmp.pdb , conf & ! h. , state=0
EOF
    pymol -c tmp.pml 
    mv tmp.pdb dist-$dist+sugar.pdb
    	   
rm -f \#*\#
done


cd $start_dir

#Hydrogens after docking have to be corrected.
start_dir=$( pwd )

for site in minor dbl4-major
do
    dir=$( echo $start_dir/docking/$site-binding-site )
    cd $dir


    ls -lhrt *pdb  > pdb-list

    if [ $site = "minor" ]
    then
	grep -v cluster1_1.pdb pdb-list | grep -v cluster21_1.pdb > tmp
	mv tmp pdb-list
    fi

    #loop over poses
    for n in {1..10} 
    do

	pdb=$( head -n $n pdb-list | tail -n 1 | awk ' { print $NF } ' )

		       outdir=$( echo $dir/$pdb+H )
		       
		       mkdir $outdir
		       cd $outdir
		       pwd

		       # change the chain label of 21 mer to C and name of BDP 1974 to BDPE to add the two hydrogents to C4, and fix several redundant atoms 
		       
		       PDB=$( ls $dir/$pdb )

grep ATOM $PDB | awk '
{
atomindex=substr($0,7,5);
atomtype=substr($0,13,4);
resname=substr($0,18,4) ;
chain=substr($0,22,1) ;
resindex=substr($0,23,4)+0;
X=substr($0,31,8);
Y=substr($0,39,8);
Z=substr($0,47,8);
Occuppancy=substr($0,55,6);
Temperaturefactor=substr($0,61,6);




if(resindex>=1954 && resindex<=1974) chain="C"



if(resindex==1954 ) resname="BDPB"
if(resindex==1974 ) resname="BDPE"


if(chain=="B" && resindex==1 ) resname="BDPB"
if(chain=="B" && resindex==11 ) resname="BDPE"




printline=1

# 11mer has two extra oxygen 
if( resname=="BDP " && atomtype==" O1 " ) {printline=0}
if( resname=="BDPE" && atomtype==" O1 " ) {printline=0}
if( resname=="BDPE" && atomtype==" O4 " ) {printline=0}




if(printline==1 ) printf("%-6s%5d %4s %4s%1s%4d%4s%8.3f%8.3f%8.3f%6.2f%6.2f\n", "ATOM ", atomindex, atomtype , resname, chain, resindex," ",X , Y , Z , Occuppancy , Temperaturefactor) ;


}
' > tmpconf.pdb 


# include residue types
cp  /usr/share/gromacs/top/residuetypes.dat   residuetypes.dat
cat>>residuetypes.dat<<EOF
BDPB	Other
BDP	Other
BDPE	Other
ASG	Other
EOF
		       
		       # copy modified ff directory
		       cp -r $start_dir/charmm36-feb2021-add-hydrogens-after-docking.ff .

		       cat>input<<EOF
1
1
EOF

		       #histidines: all HSD
		       for i in {1..26} ; do  echo 0 >> input ; done



		 gmx pdb2gmx -f tmpconf.pdb  -o conf+H.pdb -ignh    -his < input  >& out || { cat out; exit 1; }

		       gmx editconf -f conf+H.pdb -bt cubic -d 20 -o tmp.pdb >& out || { cat out; exit 1; }
		       mv tmp.pdb conf+H.pdb 

		       
                       # minimize energy
		       topdir=$( echo ./MD-equil )
		       itp11mer=$( ls ./MD-dock-equil/test/charmm36-jul2022.ff/CARA-11.itp )

		       
		       
		       rm -f *itp *top $dir/*itp $dir/*top
		       
		       cp -rf $topdir/toppar $dir/
		       cp $itp11mer $dir/toppar/
		       cat >$dir/topol.top<<EOF
; Include forcefield parameters
#include "toppar/forcefield.itp"
#include "toppar/PROA.itp"
#include "toppar/CARA.itp"
#include "toppar/CARA-11.itp"


[ system ]
; Name
docked var2csa+csa 

[ molecules ]
; Compound	#mols
PROA	   1
CARA  	           1
CARA-11		   1
EOF


		       module use /sw/mbm/app/easybuild/modules/all; module load CUDA/10.1.243-GCC-8.3.0; source /sw/mbm/app/gromacs/2020.3/bin/GMXRC
		       
		       
gmx grompp -f $start_dir/em.mdp -c conf+H.pdb -p $dir/topol.top -o em.tpr -maxwarn 2

gmx mdrun  -deffnm em  
		       
		   

rm -rf \#*\# *itp *top charmm36-feb2021-add-hydrogens-after-docking.ff tmp* step*pdb residue*dat em.edr em.log em.trr input out 		       
		       cd $dir 
    
    done

    cd $start_dir
done


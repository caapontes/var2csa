start_dir=$( pwd )

outdir=$( echo $start_dir/protein-topol )
mkdir $outdir
cd $outdir
pwd

dothis=no
if [ $dothis = yes ]
then

    
conf=$( ls $start_dir/structures/modeller-chimera-dbl1-id3/m2.pdb )

{
    echo 1 \& \! a OXT 
    echo q
}  | gmx make_ndx -f $conf  >& out || { cat out; exit 1; }
group=$( echo  Protein_\&_\!OXT )

gmx editconf -f $conf -o prot+sugar-centered.pdb -d 2.5 -bt dodecahedron  >& out || { cat out; exit 1; }

conf=$( ls prot+sugar-centered.pdb )
echo $group   | gmx editconf -f $conf  -n index.ndx -o protein.gro   >& out || { cat out; exit 1; }
echo non-protein   | gmx editconf -f $conf -n index.ndx -o sugar.gro   >& out || { cat out; exit 1; }



	   # B ==== topology of the protein ===
	   cp -r ~/force_fields/charmm36-feb2021.ff . 




	   # force field
	   #1: current protein ff
	   # 1 tip3p
	   cat>ff<<EOF
	   1 
	   1	   
EOF

	     
	   #  histidines: default gromacs protonation states
	   

	   # cysteines (28 all yes)
	  { for i in {1..28} ; do echo y ; done ; } > cys
		    
	   
	   # termini (NH3+  - CT2 )
	   cat>termini<<EOF
           0
           2
EOF


	   cat ff cys termini     > input
	   	   gmx pdb2gmx -f protein.gro -ter  -ignh  -ss -o conf.pdb  < input  >& out || { cat out; exit 1; }



		   

	   # topol as itp
	   awk ' 
BEGING{printline=0}
{
if($2=="moleculetype") {printline=1}
if($0=="; Include water topology") { printline=0 }

if(printline==1) print $0
 }

 ' topol.top > protein.itp 




	   # energy minimization to bring conf.pdb to 7jgh structure
	   # ==== position restraint reference from 7jgh cryo structure ---
	   $start_dir/get-7jgh-posres-ref.sh  $start_dir/structures/7jgh.pdb  conf.pdb  conf-ref.pdb posre-protein-cryo.itp tmp-posre-sugar-cryo.itp
	   rm -f tmp-posre-sugar-cryo.itp


	   cat>>protein.itp<<EOF
; Include Position restraint file
#ifdef POSRESCRYO
#include "posre-protein-cryo.itp"
#endif
EOF


cat>topol_relax_em.top<<EOF
;; The main GROMACS topology file
;; generated by setup.sh 

; Include forcefield parameters
#include "./charmm36-feb2021.ff/forcefield.itp"
#include "protein.itp"

[ system ]
; Name
var2csa

[ molecules ]
; Compound	#mols
Protein	           1
EOF



	   
	   # C === minimize
  gmx grompp  -f $start_dir/minimization_cryo_posres.mdp -p topol_relax_em.top -c conf.pdb -r conf-ref.pdb -o conf-cryo.tpr  -maxwarn 1   >& out || { cat out; exit 1; }
gmx mdrun --deffnm conf-cryo -v


fi #dothis



gmx editconf -f conf-cryo.gro -o conf-cryo.pdb




	   # once more topol as itp with cryo posres defined only once 
	   awk ' 
BEGING{printline=0}
{
if($2=="moleculetype") {printline=1}
if($0=="; Include water topology") { printline=0 }

if(printline==1) print $0
 }

 ' topol.top > protein.itp 


	   cat>>protein.itp<<EOF
; Include Position restraint file
#ifdef POSRESCRYO
#include "posre-protein-cryo.itp"
#endif
EOF


rm -f \#*\#
cd $start_dir

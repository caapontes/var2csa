start_dir=$( pwd )


charmm_gui_dir=$( echo charmm36m-parameters/sugar/charmm-gui-resid-50-130-856-858/charmm-gui-2391589150/gromacs ) 



outdir=$( echo $start_dir/MD-11mer )
mkdir $outdir
cd $outdir
pwd




# A==== assemble protein and sugar
protein=$( ls $start_dir/protein-topol/conf-cryo.pdb )
protein_fragment_sugar_charmmgui=$( ls $charmm_gui_dir/step3_input.gro )

# align with pymol
cat>align.pml<<EOF
load $protein, ref
load $protein_fragment_sugar_charmmgui , charmm
align charmm & poly, ref & poly
select sugar, charmm & resn BGLCA+BGALN 
save sugar-charmm.pdb , sugar
EOF

pymol -c align.pml 


{
    grep CRYST $protein
    grep ATOM  $protein
    grep ATOM  sugar-charmm.pdb
} > box.pdb






# B=== joint topology ===
cp -r $charmm_gui_dir/toppar .





# replace fragment topology by whole protein topology 
cp $start_dir/protein-topol/protein.itp toppar/PROA.itp
cp $start_dir/protein-topol/posre.itp  toppar/
cp $start_dir/protein-topol/posre-protein-cryo.itp  toppar/


cp -r  $start_dir/protein-topol/charmm36-feb2021.ff . 




cat>topol.top<<EOF
;; The main GROMACS topology file
;; generated by setup.sh 

; Include forcefield parameters
#include "charmm36-feb2021.ff/forcefield.itp"
#include "toppar/PROA.itp"
#include "toppar/CARA.itp"
#include "toppar/SOD.itp"
#include "toppar/CLA.itp"
#include "toppar/TIP3.itp"

[ system ]
; Name
var2csa+csa

[ molecules ]
; Compound	#mols
Protein	           1
CARA  	           1
EOF



# ==== position restraint reference from 7jgh cryo structure ---
$start_dir/get-7jgh-posres-ref.sh  $start_dir/structures/7jgh.pdb  box.pdb  box-ref.pdb toppar/posre-protein-cryo.itp toppar/posre-sugar-cryo.itp


# include posres definitions in itp files

cat>>toppar/CARA.itp<<EOF
; Include Position restraint file
#ifdef POSRESCRYO
#include "posre-sugar-cryo.itp"
#endif
EOF



	   
	   # C === minimize
  gmx grompp  -f $start_dir/minimization_cryo_posres.mdp -p topol.top -c box.pdb -r box-ref.pdb -o em.tpr -maxwarn 2   >& out || { cat out; exit 1; }
gmx mdrun --deffnm em -v





# D === loop relaxation with the rest frozen at high temperature 500 K  ===

# index file
{
echo 1 \& r 407-485
echo 1 \& r 529-556
echo \"Protein_\&_r_407-485\" \| \"Protein_\&_r_529-556\"
echo \! \"Protein_\&_r_407-485_Protein_\&_r_529-556\"
echo q
} | gmx make_ndx -f em.gro  >& out || { cat out; exit 1; }


gmx grompp  -f $start_dir/sd-loop-relax.mdp  -p topol.top -c em.gro  -n index.ndx -o sd-loop-relax.tpr    >& out || { cat out; exit 1; }
module use /sw/mbm/app/easybuild/modules/all; module load GROMACS/2020-fosscuda-2019b 
gmx mdrun -deffnm sd-loop-relax -v -nb gpu -bonded gpu -ntmpi 4








rm -f \#*\# 
cd $start_dir

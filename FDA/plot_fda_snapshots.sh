#script to add connects to the important conan and fda pairs



start_dir=$( pwd )
nres=1953
gmx2pN=1.66053906717385
zscore_cutoff=$1

for type in all nonbonded
do
    for intrange in local global
    do
		dir=$( echo $start_dir/MD/fda )
		typedir=$( echo $dir/$type )
		intrangedir=$( echo $typedir/$intrange )
		outdir=$( echo $intrangedir/z$zscore_cutoff )
		cd $outdir
		pwd

	



 ref=$( ls ./input/dist_11_nm.pdb ) 


 
 pairs_file=$( ls Delta-fda-significant.dat )

      
 file_pymol=$( ls $pairs_file )


     awk '
{
ri=$1
rj=$2
Delta=$3+0.0  
if(Delta<0){ color="black"}
if(Delta>=0){ color="black"}

#width=sqrt(sqrt(Delta^2)/20) #scaled
width=sqrt(sqrt(Delta^2)/100) #scaled

printf("select bond-%d-%d,  resi %d+%d & name CA \n", ri,rj,ri,rj)
printf("bond resi %d & name CA, resi %d & name CA\n", ri,rj)
printf("set_bond line_color, %s, bond-%d-%d\n", color,ri,rj)
printf("set_bond line_width, %f, bond-%d-%d\n", width ,ri,rj)
printf("show line, bond-%d-%d\n", ri,rj)

}
 ' $file_pymol  > connect_fda


# pymol script

     
cat>snap-fda.pml<<EOF
load $ref, ref
hide 
cartoon loop 


show cartoon
set opaque_background, 0
bg_color white
set ray_shadow , 0
set spec_reflect, 0
set spec_power,  0
set ray_trace_mode,  0
set animation,0
set specular,0
set ortho,0
set two_sided_lighting,1
set ray_trace_gain, 0.0
set_color brown_Ct, [137,72,8]
set_color grey_Nt, [101,101,101]

set cartoon_color, grey_Nt , ref & resi 1-964
set cartoon_color, brown_Ct , ref & resi 965-1953


# highlight position of selected residues (not in the final render)
select high_res, resi 831+835+845+886+887+1863+1865+1874+1880+968
#show spheres, high_res and name CA
#set sphere_scale, 0.7
#set sphere_color, red
#set sphere_color, blue, resi 1865+887 and name CA


show spheres , resn BGLC+BGAL
color green, resn BGLC+BGAL
set sphere_transparency, 0.5, resn BGLC+BGAL



@connect_fda


#view1 
set_view (\
    -0.609623671,   -0.401125461,    0.683707714,\
     0.788063645,   -0.213624552,    0.577338517,\
    -0.085528500,    0.890764713,    0.446343839,\
     0.000007110,    0.000068545, -774.294433594,\
    56.360176086,   80.881118774,  116.911788940,\
   587.656494141,  960.927368164,  -20.000000000 )
### cut above here and paste into script ###



   



ray 2800,2000
png fda-score.png

EOF


pymol -c snap-fda.pml  >& out || { cat out; exit 1; }

cd $start_dir

    done
done




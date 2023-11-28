# script to compute <Fij>_r and sigma2_r over r simulation replicas 
start_dir=$( pwd ) 
nres=1953
min_replicas=15 # fij has been defined at least for 15 pairs

outdir=$( echo $start_dir/MD/fda )
cd $outdir
pwd

	for type in nonbonded all
	do
	for state in open closed
	do

  cat $start_dir/MD/fda/*/$state/$type/fda.pfr | grep -v frame | grep -v pair | awk '
BEGIN{ Nres='$nres'+0 ; Minr='$min_replicas'+0 }
{
i=$1+1
j=$2+1



fij_av[i,j]+=$3+0.0
fij_sd[i,j]+=$3*$3+0.0
fij_n[i,j]++
}
END{

print "#i j Fij sigma2 n"

for(i=1 ; i<=Nres ; i++ )
for(j=i+1 ; j<=Nres ; j++ )  #fda output: i<j then half diagonal can be looked
{

# warning in case inverse (fji was also populated) 
if(fij_n[j,i]>0) print "ERROR: fij_n[j,i] is not zero " fij_n[j,i]


if( fij_n[i,j]>=Minr   ) { 

av=fij_av[i,j] /  fij_n[i,j]

sigma2= fij_sd[i,j]/( fij_n[i,j] -1 ) - av*av*fij_n[i,j] / ( fij_n[i,j] -1 )

print i,j, av , sigma2, fij_n[i,j] 


}
}

}
' > Fij-$type-$state.dat


  done
	done


	cd $start_dir

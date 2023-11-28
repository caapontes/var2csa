# script to plot the 2d map of delta_fda 
# delta_ij  = F(open) - F(closed) is considered with F the pair-wise force from fda
# statistical criterion to select pairs: score= | <open> - <closed>|  / ( sqrt (sdopen^2 + sdclosed^2 )  ) > zscore_cutoff


start_dir=$( pwd )
nres=1953
gmx2pN=1.66053906717385
zscore_cutoff=$1
Fmin=-100 # pN
Fmax=100 # pN
Ncolors=20



for type in all nonbonded
do
    for intrange in local global
    do
		dir=$( echo $start_dir/MD/fda )
		typedir=$( echo $dir/$type )
		intrangedir=$( echo $typedir/$intrange )
		outdir=$( echo $intrangedir/z$zscore_cutoff )
		mkdir $typedir
		mkdir $intrangedir
		mkdir $outdir
		cd $outdir
		pwd

		DeltaFij=$( ls $dir/Delta-Fij-$type-$intrange.dat  )

		#A apply threshold and  sort according to |Fij|  and ignore all what is 1% smaller than Fmax
		
grep -v \#  $DeltaFij  | awk '
BEGIN {Z='$zscore_cutoff'+0.0 }
{
i=int($1)
j=int($2)
DFij=$3*'$gmx2pN'+0.0
z=$4

normDF=sqrt(DFij^2)

if(z>Z && normDF>0.01*'$Fmax' ) print i,j,DFij,z , normDF

}' | sort -n -k 5 >  Delta-fda-significant.dat 
	 


			 
			 # ---- plot the circle ----
			 file=$( ls Delta-fda-significant.dat  )


		    # plot domains
		    domains=$( ls ./input/domain-range.txt )

	    
	    

		    


# plot the domains too		
		cat $domains |  awk '


# print circle with the residue index, color coded and within 2ndary elements
BEGIN{
Nres='$nres'+0
Dtheta=6.28318530718/Nres


printf("@target G0.S0\n")
printf("@type xycolor\n")
}

$1=="DOMAIN" {

#theta radius=1 color

el_b=$3 ; el_e=$4  ; domain_type=substr($2,1,3)  ; domain_index=NR%2
for(i=el_b ; i<=el_e ; i++ ) {
thetai=i*Dtheta
if(domain_index==0) color=1
else color=7 # grey
print thetai,"1.0",color
}

#selected residues
#color=1
#thetai=831*Dtheta
#print thetai, "1.05", color
#thetai=835*Dtheta
#print thetai, "1.05", color
#thetai=845*Dtheta
#print thetai, "1.05", color
#thetai=886*Dtheta
#print thetai, "1.05", color
#thetai=887*Dtheta
#print thetai, "1.05", color
#thetai=1863*Dtheta
#print thetai, "1.05", color
#thetai=1865*Dtheta
#print thetai, "1.05", color
#thetai=1874*Dtheta
#print thetai, "1.05", color
#thetai=1874*Dtheta
#print thetai, "1.05", color
#thetai=1880*Dtheta
#print thetai, "1.05", color


}
' > tmp-domains

		cat $file | awk ' 
BEGIN{
Nres='$nres'+0
Dtheta=6.28318530718/Nres
}
		
$1!="DOMAIN" {

pairnumber++

i=$1
j=$2
fij=$3

thetai=i*Dtheta
thetaj=j*Dtheta

# color
ncolors='$Ncolors'+0
fmin='$Fmin'
fmax='$Fmax'
df=(fmax-fmin)/ncolors
color=16 + int( (fij-fmin)/df )
if(color<=16) color=16
if(color>=16+ncolors) color=16+ncolors-1


width=4
# print in xmgrace format
printf("@    s%d line color %d\n",pairnumber,color )
printf("@    s%d line linewidth %f\n",pairnumber,2 )
printf("@target G0.S%d\n",pairnumber)
printf("@type xy\n")
#theta radius=1 
print thetai, 1
print thetaj, 1
print "&\n"

}

'  > tmp





cat tmp-domains tmp   > tmp-polar.dat



# graph in polar coordinates in xmgrace:

# xmgrace 2d proj
cat>png.bfile<<EOF
PRINT TO "Delta-fda-score-$zscore_cutoff.png"
 HARDCOPY DEVICE "PNG"
 PAGE SIZE 3300, 2550
 DEVICE "PNG" FONT ANTIALIASING on
 DEVICE "PNG" OP "transparent:on"
 DEVICE "PNG" OP "compression:9"
EOF


gracebat -batch png.bfile -autoscale none -param $start_dir/polar_plot_pairs.par   -graphtype polar tmp-polar.dat -saveall fda\ij.agr   -hardcopy


# plot only the ring 
# xmgrace 2d proj
cat>png.bfile<<EOF
PRINT TO "Delta-fda-ring.png"
 HARDCOPY DEVICE "PNG"
 PAGE SIZE 3300, 2550
 DEVICE "PNG" FONT ANTIALIASING on
 DEVICE "PNG" OP "transparent:on"
 DEVICE "PNG" OP "compression:9"
EOF


gracebat -batch png.bfile -autoscale none -param $start_dir/polar_plot_pairs.par   -graphtype polar tmp-domains -saveall ring_fda\ij.agr   -hardcopy




rm -f tmp*			 
 			      
cd $start_dir



done
done

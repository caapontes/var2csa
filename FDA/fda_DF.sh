# script to compute DeltaFij = <F(open)> - <F(closed)>
# local vs global:
#local:  pair exists in both open and closed states
#global:  pair exists only in closed state. In open state it is assumed to be zero (likely due to the distancing of the residues beyond cutoffs)


start_dir=$( pwd ) 
nres=1953
min_replicas=15 # fij has been defined at least for 15 pairs

outdir=$( echo $start_dir/MD/fda )
cd $outdir
pwd

	for type in nonbonded all
	do
	    for intrange in local global  
			       do 

	    

	    fij_open=$( ls  Fij-$type-open.dat )
	    fij_closed=$( ls  Fij-$type-closed.dat )

	    grep -v \# $fij_open | awk ' { print "OPEN ", $0 } ' > tmp_open
	    grep -v \# $fij_closed | awk ' { print "CLOSED ", $0 } ' > tmp_closed


	    
	    
	    echo  "# ri,rj, Delta=<open>-<closed> , zscore= | <open> - <closed>| / sqrt ( sigma2(open) + sigma2(closed) )"   > Delta-Fij-$type-$intrange.dat 


	    		 cat tmp_open tmp_closed | awk ' 


{
if($1=="OPEN")   { i=$2 ; j=$3 ; av_open[i,j]=$4   ;  sigma2_open[i,j]=$5  ; n_open[i,j]=$6      ;  }
if($1=="CLOSED") { i=$2 ; j=$3 ; av_closed[i,j]=$4 ;  sigma2_closed[i,j]=$5 ; n_closed[i,j]=$6  }
}

END {
for(i=1;i<='$nres'+0;i++)
for(j=1;j<='$nres'+0;j++) 


#continue only if the pair was defined in closed states
if( n_closed[i,j]>0 )
{

# local: interaction must exist also in open state 
if ("'$intrange'"=="local" )  { nthreshold=14 } #nreplicas>15 as in fda_av_sigma.sh
if ("'$intrange'"=="global" ) { nthreshold=-1 } 


if(n_open[i,j]>nthreshold) { 

# set to zero for the global case
if(n_open[i,j]==0) { av_open[i,j]=0.0 ; sigma2_open[i,j]=0.0 }

DF=av_open[i,j]-av_closed[i,j]
zscore=  sqrt( DF*DF  /  ( sigma2_open[i,j] + sigma2_closed[i,j]   ) )

print i,j , DF, zscore
}
}
}
'  >> Delta-Fij-$type-$intrange.dat 

			 


	    done
	    done

	cd $start_dir

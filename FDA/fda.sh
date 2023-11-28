#script to run fda
start_dir=$( pwd )
DT=2000 # time window  (ps)
    for run in {1..20}
    do

	for state in open closed
	do
	    for type in nonbonded all
	    do
		rundir=$( echo $start_dir/MD/fda/$run )
		statedir=$( echo $rundir/$state )
		outdir=$( echo $statedir/$type )
		mkdir $rundir
		mkdir $statedir
		mkdir $outdir
	cd $outdir
	pwd

	rita_dir=$( echo ./input )
	ndx=$( ls $rita_dir/index.ndx )
	tpr=$( ls $rita_dir/run_pp.tpr )
	xtc=$( ls $rita_dir/$run/pull-run_pp_$state.xtc )

	# create a shorter time window of 1ns:
	if [ $state = "closed" ] ; then tb=10000  ; fi
	if [ $state = "open" ] ; then tb=90000  ; fi

	te=$[tb+DT]
	   
#	gmx trjconv -f $xtc -b $tb -e $te -o traj-shortDT.xtc >& out || { cat out; exit 1; }

cat> input.pfi <<EOF
onepair = summed
group1 = Protein
group2 = Protein
type = $type
atombased = no
residuebased = pairwise_forces_scalar
residuesrenumber = yes
time_averages_period = 0
no_end_zeros =  yes
ignore_missing_potentials = yes  
EOF

gmx_fda mdrun -nt 1  -pfi input.pfi -pfn $ndx -rerun traj-shortDT.xtc  -s $tpr  -g rerun.log -pfa -pfr 
	

	
	
	cd $start_dir
	    done
	done
    done

for z in 1 0.75 0.5 0.25  ; do
    ./plot_delta_fda_score_criterion.sh $z ;
    ./plot_fda_snapshots.sh $z ;
done 

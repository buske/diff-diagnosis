#!/usr/bin/env bash

set -eu
set -o pipefail

logdir=~/sge_logs/dispatch_pval/
mkdir -pv $logdir
type=$1

dis_list=`cat /dupa-filer/talf/diff-diagnosis/phenotype_annotation.tab | cut -f 1,2 | tr "\t" ":" | uniq`
i=0
for f in $dis_list; do
	(( i=$i+1 ))
	mkdir -p /dupa-filer/talf/diff-diagnosis/simgic_dists/pval_dist_simgic_${type}/$f 
	jobname=`echo $f | tr ':' '-'`
	qsub -l h_vmem=5G -N $jobname -e $logdir -o $logdir -cwd -b y -V "/filer/tools/python/Python-3.4.1/python /dupa-filer/talf/diff-diagnosis/pair_test_noise_imprecision/make_distribution.py $f /dupa-filer/talf/diff-diagnosis/simgic_dists/pval_dist_simgic_${type}/$f /dupa-filer/talf/diff-diagnosis/pair_test_noise_imprecision/ic/ic_${type}.txt"
	if ! (($i % 100)); then
		echo submitted $i jobs.
		sleep 1
	fi
done



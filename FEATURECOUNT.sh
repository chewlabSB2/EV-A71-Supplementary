#!/bin/bash

#PBS -q normal
#PBS -l select=1:ncpus=16:mem=40GB
#PBS -l walltime=24:00:00
#PBS -P Personal 
#PBS -N GIS_FeatureCount
#PBS -o /home/users/ntu/muhamma4/output/GIS_FeatureCount.3.o
#PBS -e /home/users/ntu/muhamma4/output/GIS_FeatureCount.3.e

EXPT=Human
rawPath='/home/users/ntu/muhamma4/scratch/GIS/290423'
outPath='/home/users/ntu/muhamma4/scratch/GIS/290423/STAR_RESULT'

GTF_FILE='/home/users/ntu/muhamma4/scratch/reference_STAR/Homo_sapiens/NCBI/GRCh38Decoy/Annotation/Genes.gencode/genes.gtf'
RESULTS=$outPath/RESULTS_FEATURECOUNT_${EXPT}
featureCountsPath='/home/users/ntu/muhamma4/packages/subread-2.0.3-Linux-x86_64/bin/featureCounts'

THREADS=16
MAPQ=10
GENEMX=EV71_genes.rerun.010523.mx

cd $RESULTS

$featureCountsPath -Q $MAPQ -T $THREADS -a $GTF_FILE -o ${EXPT}.1.count -p --countReadPairs *.bam 
cat ${EXPT}.1.count | cut -f1,7- | sed 1d > $outPath$GENEMX

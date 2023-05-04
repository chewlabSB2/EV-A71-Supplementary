#!/bin/bash

GTF_FILE='/home/users/ntu/muhamma4/scratch/reference_STAR/Homo_sapiens/NCBI/GRCh38Decoy/Annotation/Genes.gencode/genes.gtf'
outPath='/home/users/ntu/muhamma4/scratch/GIS/290423/STAR_RESULT'
RESULTS=$outPath/RESULTS_FEATURECOUNT_${EXPT}

cd $outPath
mkdir qualimapRNASEQ
mkdir qualimapBAMQC
cd $RESULTS

for file in *; 
do
    n=${file%.*} 
    qualimap rnaseq -bam $n -gtf $GTF_FILE -outdir ${outPath}/qualimapRNASEQ/${n}
    qualimap bamqc -bam $n -nw 400 -hm 3 -sd -outdir ${outPath}/qualimapBAMQC/${n}
done
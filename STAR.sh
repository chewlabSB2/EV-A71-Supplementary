#!/bin/bash

#PBS -q normal
#PBS -l select=1:ncpus=16:mem=64GB
#PBS -l walltime=24:00:00
#PBS -P Personal 
#PBS -N GIS_STAR 
#PBS -o /home/users/ntu/muhamma4/output/GIS_STAR.2.o
#PBS -e /home/users/ntu/muhamma4/output/GIS_STAR.2.e

## Liver and Heart First
EXPT=Human

THREADS=16

rawPath='/home/users/ntu/muhamma4/scratch/GIS/020523'
outPath='/home/users/ntu/muhamma4/scratch/GIS/020523/STAR_RESULT'
GENOME_DIR='/home/users/ntu/muhamma4/scratch/reference_STAR/Homo_sapiens/NCBI/GRCh38Decoy/STAR/'
GTF_FILE='/home/users/ntu/muhamma4/scratch/reference_STAR/Homo_sapiens/NCBI/GRCh38Decoy/Annotation/Genes.gencode/genes.gtf'

RESULTS=$outPath/RESULTS_FEATURECOUNT_${EXPT}

function process_STAR {
	PREFIX=$3
	echo $(date +"%Y-%m-%d %H:%M:%S") " - STAR PROCESSING ${PREFIX}"
	STAR --genomeDir $GENOME_DIR --sjdbGTFfile $GTF_FILE --readFilesIn $1 $2 --runThreadN $THREADS --twopassMode Basic --outSAMtype BAM SortedByCoordinate --readFilesCommand zcat --outFileNamePrefix $3 1>$3-STAR.o 2>$3-STAR.e
	
	mv ${PREFIX}Aligned.sortedByCoord.out.bam $RESULTS/${PREFIX}.out.bam
	echo $(date +"%Y-%m-%d %H:%M:%S") " - STAR COMPLETED ${PREFIX}"
}

function create_folder {
  	if [ -d $1 ]; then
    	rm -r $1
  	fi
  	mkdir $1
}

module load anaconda/3
source activate /home/users/ntu/muhamma4/.conda/envs/BS6214-2

x='_1.fq.gz'
y='_2.fq.gz'
create_folder $outPath
create_folder $RESULTS
cat /home/users/ntu/muhamma4/GIS_Scripts/sralist.020523.txt | while IFS='=' read -r col1 col2 
do
	echo $col1
	cd $outPath
	create_folder $col1
	cd $col1

	process_STAR $rawPath/$col1/$col2$x $rawPath/$col1/$col2$y $col1
done

source deactivate
module unload anaconda/3
echo All Done

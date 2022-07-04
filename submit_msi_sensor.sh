#run as...
# qsub -t 1-n MSISENSOR input.txt
#input.txt needs to be in format of:
# sample_name   suffix
#
#
#$ -N RHYTHM_MSISENSOR
#$ -j y
#$ -S /bin/bash
#$ -cwd
#$ -l h_vmem=8G
#$ -pe sharedmem 16
#$ -l h_rt=24:00:00

#sort out needed modules
#snp-pileup for FACETS
unset MODULEPATH
. /etc/profile.d/modules.sh
module load igmm/libs/htslib/1.6
module load igmm/apps/R/3.5.1

IDS=$1
sample=`head -n $SGE_TASK_ID $IDS | tail -n 1 | awk '{ print $1 }'`
suffix=`head -n $SGE_TASK_ID $IDS | tail -n 1 | awk '{ print $2 }'`


dest="/exports/igmm/eddie/tomlinson-Polyp-WGS-RNA/RHYTHM_BAM/"

module load anaconda

#use MSIsensor pro... Jia et al 2020
source activate MSIsensor
msisensor-pro msi -d /exports/igmm/eddie/tomlinson-lab/tools/msisensor_ref.list -n ${dest}${sample:0:6}N-sort.bam -t ${dest}$sample$suffix-sort.bam -o /exports/igmm/eddie/tomlinson-Polyp-WGS-RNA/RHYTHM_MSI/$sample$suffix

echo "Storage on Eddie/Scratch is limited... cleaning up tumour BAMs!"
#rm -v ${dest}/$sample$suffix-ready.bam
#rm -v ${dest}/$sample$suffix-ready.bam.bai

#!/bin/bash
#$ -l nc=4
#$ -p -50
#$ -r yes
#$ -q node.q

#SBATCH -n 4
#SBATCH --nice=50
#SBATCH --requeue
#SBATCH -p node03-06
SLURM_RESTART_COUNT=2

echo $@

ERRORS=(`cat output/tensorly/bestfit_rank/*/error.txt`)
BESTTRIAL=(`echo ${ERRORS[@]} | tr -s ' ' '\n' | awk '{print($0" "NR)}' |
sort -g -k1,1 | head -1`)

echo ${BESTTRIAL[1]} > output/tensorly/bestfit_rank/bestfit_trial.txt
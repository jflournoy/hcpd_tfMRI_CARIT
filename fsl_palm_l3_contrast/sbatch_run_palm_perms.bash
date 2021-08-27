#!/bin/bash
#SBATCH -J palm-test
#SBATCH --time=1-00:00:00
#SBATCH -n 1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=3G
#SBATCH -p ncf
#SBATCH --account=mclaughlin_lab
# Outputs ----------------------------------
#SBATCH -o log/%x-%A_%a.out
set -aeuxo pipefail
N=$(printf "%02d" $SLURM_ARRAY_TASK_ID)

datadir="/ncf/hcp/data/HCD-tfMRI-MultiRunFix/"
inputfile="../Go-CR.4d.dtseries.nii"
EBfile="../eb.csv"
echo "Loading FSL and Workbench"
source ~/code/FSL-6.0.4_workbench-1.0.txt

if  ! [ -f "${inputfile}" ]; then
	files=$( cat filelist.txt )
	mergefiles=$(printf -- "-cifti %s " ${files})
	echo "FILE NOT FOUND"
	echo "Concatenating..."
	wb_command -cifti-merge ${inputfile} ${mergefiles}
fi

echo "Loading matlab..."
module load matlab/R2021a-fasrc01

thisdir="perm_${N}"

echo "Changing to directory perms/"
cd perms/

echo "Running PALM"
/users/jflournoy/code/PALM/palm -i ${inputfile} -transposedata \
	-eb ../eb.csv \
	-d "l3_contrast_perm_$N.mat" \
	-t ../l3_contrast.con \
	-n 1000 \
	-within \
	-ee \
	-save1-p \
	-o "ten_perfect_l3_con_perm_$N" \
	-savemetrics \
	-savemax
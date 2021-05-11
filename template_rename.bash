#!/bin/bash
set -Eeuo pipefail

echo "Finding template files ..."
TEMPLATEFILES=($(cat /ncf/mclaughlin/users/jflournoy/code/hcpd_tfMRI_CARIT/template_fsf.txt))

dtfile="../tfMRI_CARIT_AP_Atlas_hp0_clean.dtseries.nii"

for file in "${TEMPLATEFILES[@]}"; do
	dir=$(dirname ${file})
	scan=${dir#*Results/}
	newfile="${dir}/${scan}.fsf"
	newnewfile="${dir}/${scan}_hp200_s4_level1.fsf"
	if [ ! -f "${newnewfile}" ]; then
		if [ -f "${newfile}" ]; then
			mv -v ${newfile} ${newnewfile}
		elif [ -f "${file}" ]; then
			mv -v ${file} ${newnewfile}
			newdtfile="../${scan}${dtfile#../tfMRI_CARIT_AP}"
			sed -i -e "s|${dtfile}|${newdtfile}|" ${newnewfile}
		fi
	fi
done

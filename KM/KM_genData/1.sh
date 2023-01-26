#!/bin/bash
#SBATCH --partition=medium
#SBATCH --time=024:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --job-name=KM
#SBATCH --array=1-16:16

module load MATLAB/R2019b

# create temporary directory and set it as MCR_CACHE_ROOT
export MCR_CACHE_ROOT=$(mktemp -d)

# KM_wrapper(fpath,k,delta_f_0,xi,a_max,n_a,f0_min,f0_max,n_f0,...
#   zeta,PRCfName,N,n_tr,n_pulses,dt,f_stim,freqSet,n_same,rndCycling)

./run_KmWrapper.sh /system/software/linux-x86_64/matlab/R2019b "KM_"$SLURM_ARRAY_JOB_ID 350 20 7.9 20000 200 3 350 200 "[0 0.15]" "HH_PRC" 100 5 400 0.0001 130 "[]" 1 "false"
# wait for all processes to finish                        
wait 


# wait for all processes to finish                        
wait 

# remove temporary directories
rm -rf ${MCR_CACHE_ROOT}
#rm -rf ${MATLAB_JOB_TMP}

#!/bin/bash
#SBATCH --partition=long
#SBATCH --time=099:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --mem-per-cpu=8G
#SBATCH --job-name=SCM
#SBATCH --array=1-480:16

module load MATLAB/R2019b

# create temporary directory and set it as MCR_CACHE_ROOT
export MCR_CACHE_ROOT=$(mktemp -d)

# SCM_wrapper(fpath,J,n_tasks_per_node,zeta_min,zeta_max,n_zeta,a_max,n_a,f0_min,f0_max,n_f0,f_stim,n_tr,N)

./run_SCM_wrapper.sh /system/software/linux-x86_64/matlab/R2019b "SCM_"$SLURM_ARRAY_JOB_ID ${SLURM_ARRAY_TASK_ID} 16 0 0.09 30 2 350 1 30 2000 13 10 10000
# wait for all processes to finish                        
wait 


# wait for all processes to finish                        
wait 

# remove temporary directories
rm -rf ${MCR_CACHE_ROOT}
#rm -rf ${MATLAB_JOB_TMP}

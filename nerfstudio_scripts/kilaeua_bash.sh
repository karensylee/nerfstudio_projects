#!/bin/bash
SBATCH --job-name=NeRF
SBATCH --mail-type=BEGIN,END,FAIL
SBATCH --mail-user=karensyl@hawaii.edu
SBATCH --partition=gpu
SBATCH --time=3-00:00:00
SBATCH --nodes=1
SBATCH --cpus-per-task=8
SBATCH --mem=32G
SBATCH --gres=gpu:1

module purge
module load tools/Vim/8.1-foss-2018b-Python-2.7.15
module load lang/Python/3.10.4-GCCcore-11.3.0
module load system/CUDA/11.0.2
module load vis/FFmpeg/4.1.3-intel-2018.5.274
module load lang/Anaconda3/2022.05
module load devel/CMake/3.23.1-GCCcore-11.3.0
module load tools/Ninja/1.10.2-GCCcore-11.3.0
module load devel/Boost/1.79.0-GCC-11.3.0

source activate nerfstudio

cd ~/nfs_scratch
git clone https://github.com/palewire/usgs-hawaii-volcano-drone-survey-october-2022
mkdir kilaeua
mv -v ~/nfs_scratch/usgs-hawaii-volcano-drone-survey-october-2022/Optical/Flight\ 1/* ~/nfs_scratch/kilaeua
mv -v ~/nfs_scratch/usgs-hawaii-volcano-drone-survey-october-2022/Optical/Flight\ 2/* ~/nfs_scratch/kilaeua
mv -v ~/nfs_scratch/usgs-hawaii-volcano-drone-survey-october-2022/Optical/Flight\ 3/* ~/nfs_scratch/kilaeua

ns-process-data --data ~/nfs_scratch/kilaeua --output-dir ~/data/nerfstudio/kilaeua &&
ns-train nerfacto-huge --data ~/data/nerfstudio/kilaeua --max-num-iterations 30000

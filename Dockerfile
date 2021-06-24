# FROM ubuntu:20.04
FROM nvidia/cuda:11.1.1-devel-ubuntu20.04

ARG PREFIX=/opt
ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=America/Sao_Paulo
# After installation, the path of the executable is: $PREFIX/gromacs/bin/GMXRC
# --- Prepare system ---
USER root 
WORKDIR $PREFIX

RUN apt-get update && apt-get install --yes openmpi-bin wget vim htop cmake python3 python3-dev
#   apt upgrade --yes
#
# --- Obtain required libraries and utilities ---
RUN wget -O ~/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-py38_4.9.2-Linux-x86_64.sh && \
chmod +x ~/miniconda.sh && \
~/miniconda.sh -b && \
rm ~/miniconda.sh

ENV \
    PATH="/root/miniconda3/bin:$PATH" \
    LD_LIBRARY_PATH="/root/miniconda3/lib:$LD_LIBRARY_PATH" \
    CUDA_TOOLKIT_ROOT_DIR="/usr/local/cuda" \
    # MAKEFLAGS="-j$(nproc)" \
    MAKEFLAGS="-j1" \
    TORCH_CUDA_ARCH_LIST="3.7;5.0;6.0;7.0;7.5" \
    CONDA_ENV=Gromacs_Docker \
    PYTHON_VERSION=3.7

# conda init
RUN conda create -y --name $CONDA_ENV python=${PYTHON_VERSION} ambertools=20 acpype mdtraj compilers pytorch torchvision torchaudio cudatoolkit=11.1 -c conda-forge -c pytorch -c nvidia && \
    conda init bash && \
    conda clean -ya


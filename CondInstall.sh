#!/bin/bash

# This file will install the necessary files for running the various quantum SDK backends. Pass download directory and install directory as arguments 1 and 2 respectively. Please specify full paths using $PWD if necessary

DL_DIR=$1
INSTALL_DIR=$2

if [ $# -eq 0 ]; then
    DL_DIR=$PWD
    INSTALL_DIR=$PWD
    mkdir -p ${DL_DIR}/downloads
    mkdir -p ${INSTALL_DIR}/install
elif [ $# ! -eq 2 ]; then
    echo "Please specify download directory and install directory as:"
    echo "./CondInstall.sh $PWD/download $PWD/install"
    exit
else
    if [ ! -d "${DL_DIR}" ];then
        mkdir -p ${DL_DIR}/downloads
    fi
    if [ ! -d "${INSTALL_DIR}" ];then
        mkdir -p ${INSTALL_DIR}/install
    fi
fi

SYS=$(uname -s)
if [ "${SYS}"=="Linux" ];then
    CONDA="Miniconda3-latest-Linux-x86_64.sh"
elif [ "${SYS}"=="Darwin" ];then
    CONDA="Miniconda3-latest-MacOSX-x86_64.sh"
else 
    echo "Unsupported configuration."
    exit
fi

#Fetch miniconda installer
function fetchConda(){
    echo "### fetchConda() ###"
    cd ${DL_DIR}/downloads
    if [ ! -e "${CONDA}" ]; then #if conda does not already exist, acquire.
        echo "Conda installer not found. Acquiring."
        #wget https://repo.continuum.io/miniconda/${CONDA} --no-check-certificate
        curl -OL https://repo.continuum.io/miniconda/${CONDA}
    fi
    cd -
}

#install miniconda and necessary packages
function condaEnvSetup(){
    echo "### condaEnvSetup() ###"
    chmod +x ${DL_DIR}/downloads/${CONDA}
    ${DL_DIR}/downloads//${CONDA} -b -p ${INSTALL_DIR}/install/duqt_conda;
    source ${INSTALL_DIR}/install/duqt_conda/etc/profile.d/conda.sh ;
    conda update -n base conda -y;
    conda create -n duqt -y python;
    conda activate duqt #Activate said environment
}

#Fetch SDKs if they do not exist already in Python environment
function fetchSDKs(){
    echo "### fetchSDKs() ###"

    conda activate duqt #Activate said environment

    # Declare the SDK names and packages array
    declare -a PIP_PACKAGES
    declare -a CONDA_PACKAGES
    PIP_PACKAGES=("beautifulsoup4" "qiskit" "pyquil" "projectq" "strawberryfields" "qutip" "qinfer")
    CONDA_PACKAGES=("tensorflow=1.6" "cython" "pybind11::conda-forge" "jupyter")

    #Loop through arrays and install the packages
    for s in $(seq 0 $(( ${#CONDA_PACKAGES[@]} -1 )) ); do
        echo ${CONDA_PACKAGES[${s}]}
        #If there are :: in the package name, read before delimiter as package and after as channel
        if [[ "${CONDA_PACKAGES[${s}]}" =~ "::" ]]; then
            PC=${CONDA_PACKAGES[${s}]} #Package::channel
            #Split string and install package in specified channel
            conda install ${PC%::*} -y -c ${PC#*::}
        else
            conda install ${CONDA_PACKAGES[${s}]} -y
        fi
    done
    for s in $(seq 0 $(( ${#PIP_PACKAGES[@]} -1 )) ); do
        echo ${PIP_PACKAGES[${s}]}
        python -m pip install ${PIP_PACKAGES[${s}]}
    done
}

##########################################
#                 main
##########################################
#Redirect logs to output and error files
fetchConda > >(tee -a CondInstall_out.log) 2> >(tee -a CondInstall_err.log >&2)
condaEnvSetup > >(tee -a CondInstall_out.log) 2> >(tee -a CondInstall_err.log >&2)
fetchSDKs > >(tee -a CondInstall_out.log) 2> >(tee -a CondInstall_err.log >&2)
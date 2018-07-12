#!/bin/bash

# This file will install the necessary files for running the various quantum SDK backends.

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
    if [ ! -e "${CONDA}" ]; then #if conda does not already exist, acquire.
        echo "Conda installer not found. Acquiring."
        wget https://repo.continuum.io/miniconda/${CONDA} --no-check-certificate
    fi
}

#install miniconda and necessary packages
function condaEnvSetup(){
    chmod +x ./${CONDA}
    ./${CONDA} -b -p ~/duct_conda;
    source ~/duct_conda/etc/profile.d/conda.sh ;
    conda update -y conda;
    conda create -n duqt -y python;
    conda activate duqt #Activate said environment
}

#Fetch SDKs if they do not exist already in Python environment
function fetchSDKs(){
    conda activate duqt #Activate said environment

    # Declare the SDK names and whether they exist as bash arrays
    declare -a SDKs
    declare -a isFound
    SDKs=("qiskit" "pyquil" "projectq" "strawberryfields")
    isFound=(false false false false)

    #Install a dep that is not pulled automatically
    python -m pip install beautifulsoup4

    #Check to see if the packages are already installed, and if so, set isFound
    for ii in $(python -m pip freeze); do
        if [[ "${ii}" = "qiskit="* ]];then 
            isFound[0]=true;
        elif [[ "${ii}" = "pyquil="* ]];then 
            isFound[1]=true; 
        elif [[ "${ii}" = "projectq="* ]];then 
            isFound[2]=true; 
        elif [[ "${ii}" = "strawberryfields="* ]];then 
            isFound[3]=true; 
        fi 
    done

    #For all packages not found, install via pip
    for s in $(seq 0 ${#isFound[@]}); do
        if ! ${isFound[${s}]}; then
            echo ${SDKs[${s}]}
            python -m pip install ${SDKs[${s}]}
        fi
    done
}

##########################################
#                 main
##########################################

if [ $# -gt 5 ]
  then
    echo "Too many arguments supplied"
    exit
fi
fetchConda
condaEnvSetup
fetchSDKs
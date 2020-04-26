#!/bin/bash

sort_home=$(pwd)

### Singularity generation 

## Parameters
version=ubuntu
case "$version" in
  ubuntu|centOS) echo "Building singularity image on a ${version} distribution";;
  *)             echo "\$version should be either ubuntu or centOS but is ${version}" && exit 1;;
esac

## Cleaning previous test
rm -rf bioinfo-pf-curie-mpiSORT-9d72e76 mpiSORT-version-1.0.zip

## Commands
wget https://zenodo.org/record/3727145/files/bioinfo-pf-curie/mpiSORT-version-1.0.zip
unzip mpiSORT-version-1.0.zip
pushd bioinfo-pf-curie-mpiSORT-9d72e76/containers/
singularity --version > ${sort_home}/singularity_env_${version}.txt
echo "***" >> ${sort_home}/singularity_env_${version}.txt
env | grep -v SL_USSER | grep -v SL_PASS | grep -v PLACE | grep -v SSH >> ${sort_home}/singularity_env_${version}.txt
sudo singularity build mpiSORT-${version}.img mpiSORT-${version}.def > ${sort_home}/singularity_${version}.out 2> ${sort_home}/singularity_${version}.err
popd

### Bare metal compilation
rm -rf mpiSORT
env | grep -v SL_USSER | grep -v SL_PASS | grep -v PLACE | grep -v SSH > ${sort_home}/mpi_compilation.txt
git clone https://github.com/bioinfo-pf-curie/mpiSORT.git

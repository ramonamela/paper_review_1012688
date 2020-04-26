#!/bin/bash

alignment_home=$(pwd)

### Singularity generation

## Parameters
version=ubuntu
case "$version" in
	ubuntu|centOS) echo "Building singularity image on a ${version} distribution";;
	*)             echo "\$version should be either ubuntu or centOS but is ${version}" && exit 1;;
esac

## Cleaning previous test
rm -rf bioinfo-pf-curie-mpiBWA-dbdcfe6 mpiBWA-version-1.0.zip

## Commands
wget https://zenodo.org/record/3727143/files/bioinfo-pf-curie/mpiBWA-version-1.0.zip
unzip mpiBWA-version-1.0.zip
pushd bioinfo-pf-curie-mpiBWA-dbdcfe6/containers/
singularity --version > ${alignment_home}/singularity_env_${version}.txt
echo "***" >> ${alignment_home}/singularity_env_${version}.txt
env | grep -v SL_USSER | grep -v SL_PASS | grep -v PLACE | grep -v SSH >> ${alignment_home}/singularity_env_${version}.txt
sudo singularity build mpiWA-${version}.img mpiBWA-${version}.def > ${alignment_home}/singularity_${version}.out 2> ${alignment_home}/singularity_${version}.err
popd

### Bare metal compilation
rm -rf mpiBWA "${HOME}/local/mpiBWA"
env | grep -v SL_USSER | grep -v SL_PASS | grep -v PLACE | grep -v SSH > ${alignment_home}/mpi_compilation.txt
git clone https://github.com/bioinfo-pf-curie/mpiBWA.git
pushd mpiBWA
aclocal > ${alignment_home}/compile_mpi.out 2> ${alignment_home}/compile_mpi.err
autoconf >> ${alignment_home}/compile_mpi.out 2>> ${alignment_home}/compile_mpi.err
automake --add-missing >> ${alignment_home}/compile_mpi.out 2>> ${alignment_home}/compile_mpi.err
./configure --prefix=${HOME}/local/mpiBWA >> ${alignment_home}/compile_mpi.out 2>> ${alignment_home}/compile_mpi.err
make >> ${alignment_home}/compile_mpi.out 2>> ${alignment_home}/compile_mpi.err
make install >> ${alignment_home}/compile_mpi.out 2>> ${alignment_home}/compile_mpi.err
export PATH=${PATH}:${HOME}/local/mpiBWA/bin 
popd

### Bare metal execution
mkdir -p bare_test
pushd bare_test
##  Binary map creation
mkdir -p binary_map
tar zxvf ${alignment_home}/mpiBWA/examples/data/hg19.small.tar.gz --directory ./binary_map
pushd binary_map
mpiBWAIdx ./hg19.small.fa
popd
##  mpiBWA alignment
mpirun -n 2 mpiBWA mem -t 4 -o ./HCC1187C.sam ./binary_map/hg19.small.fa ${alignment_home}/mpiBWA/examples/data/HCC1187C_R1_10K.fastq ${alignment_home}/mpiBWA/examples/data/HCC1187C_R2_10K.fastq
popd

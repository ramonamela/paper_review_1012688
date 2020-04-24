#!/bin/bash

### Dependencies:
#   - wget
#   - unzip
#   - singularity

### Singularity generation

## Parameters
#version=ubuntu
#case "$version" in
#	ubuntu|centOS) echo "Building singularity image on a ${version} distribution";;
#	*)             echo "\$version should be either ubuntu or centOS but is ${version}" && exit 1;;
#esac

## Cleaning previous test
#rm -rf bioinfo-pf-curie-mpiBWA-dbdcfe6 mpiBWA-version-1.0.zip

## Commands
#wget https://zenodo.org/record/3727143/files/bioinfo-pf-curie/mpiBWA-version-1.0.zip
#unzip mpiBWA-version-1.0.zip
#pushd bioinfo-pf-curie-mpiBWA-dbdcfe6/containers/
#singularity --version > ../../singularity_env_${version}.txt
#echo "***" >> ../../singularity_env_${version}.txt
#env | grep -v SL_USSER | grep -v SL_PASS | grep -v PLACE | grep -v SSH >> ../../singularity_env_${version}.txt
#sudo singularity build mpiWA-${version}.img mpiBWA-${version}.def > ../../singularity_${version}.out 2> ../../singularity_${version}.err
#popd

### Bare metal compilation


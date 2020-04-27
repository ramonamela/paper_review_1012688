#!/bin/bash

test_home=$(pwd)

mkdir -p data
rm -rf ./data/*

pushd alignment
./run_evaluation.sh ${test_home}/data/HCC1187C.sam
popd

mkdir -p ./data/sorted
pushd sorting
./run_evaluation.sh ${test_home}/data/HCC1187C.sam ${test_home}/data/sorted
popd

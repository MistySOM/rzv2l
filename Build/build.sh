#!/bin/bash
git submodule update --init --recursive
docker build -t rzv2l_vlp_v3.0.0 .

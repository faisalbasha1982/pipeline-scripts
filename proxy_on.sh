#!/bin/bash


export http_proxy="http://10.250.199.65:3128/"
export HTTP_PROXY="http://10.250.199.65:3128/"
export https_proxy="http://10.250.199.65:3128/"
export HTTPS_PROXY="http://10.250.199.65:3128/"
export no_proxy="kubectl"
export NO_PROXY="kubectl"

./run.sh


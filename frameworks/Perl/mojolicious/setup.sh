#!/bin/bash

fw_depends perl

sudo mkdir --mode=0777 local
carton install --cpanfile ${TROOT}/cpanfile

export LIBEV_FLAGS=7
carton exec hypnotoad ${TROOT}/app.pl

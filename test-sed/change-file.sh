#!/bin/bash

##  Needed functions - You need the ctos-functions package installed.
source ctos-functions

##  This script tests the function of sed and converts the server.cnf to a form for nextcloud.

testFolder='test-file'

if !( test_location $testFolder );
    mkdir $testFolder
else
    rm -r $testFolder
    mkdir $testFolder
fi
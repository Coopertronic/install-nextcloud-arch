#!/bin/bash

##  Needed functions - You need the ctos-functions package installed.
source ctos-functions

##  This script tests the function of sed and converts the server.cnf to a form for nextcloud.

testFolder='test-file'
testFile='server.cnf'
assetsFolder='../assets'

if !(test_location $testFolder); then
    mkdir $testFolder
else
    rm -r $testFolder
    mkdir $testFolder
fi

if !(test_location ../assets); then
    something_wrong
else
    cp -vir $assetsFolder/$testFile ./$testFolder/
fi

##  Alter original file and make a test file
sed -i '/\[mysqld\]/ a\
skip_networking\
transaction_isolation=READ-COMMITTED' $testFolder/$testFile
#sed -i '/\[mysqld\]/ a\
#transaction_isolation=READ-COMMITTED' $testFolder/$testFile

#!/bin/bash

##  Needed functions - You need the ctos-functions package installed.
source ctos-functions

##  This script tests the function of sed and edits a
##  specified file before creating a new file containing
##  the edit.

testFolder='test-file'
testFile='php-fpm.ini'
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
sed -i 's/;zend_extension=opcache/zend_extension=opcache/' $testFolder/$testFile
#;opcache.interned_strings_buffer=8
sed -i 's/;opcache.interned_strings_buffer=8/opcache.interned_strings_buffer=16/' $testFolder/$testFile
#;opcache.max_accelerated_files=10000
sed -i 's/;opcache.max_accelerated_files=10000/opcache.max_accelerated_files=10000/' $testFolder/$testFile
#;opcache.memory_consumption=128
sed -i 's/;opcache.memory_consumption=128/opcache.memory_consumption=128/' $testFolder/$testFile
#;opcache.save_comments=1
sed -i 's/;opcache.save_comments=1/opcache.save_comments=1/' $testFolder/$testFile
#;opcache.revalidate_freq=2
sed -i 's/;opcache.revalidate_freq=2/opcache.revalidate_freq=1/' $testFolder/$testFile

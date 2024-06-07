#!/bin/bash

##  Needed functions - You need the ctos-functions package installed.
source ctos-functions

##  This script installs Nextcloud on Archlinux

##  The location vars
webappName='nextcloud'
webappLoc='/etc/webapps/'
nextcloudRoot="$webappLoc$webappName"
configLoc="$nextcloudRoot/config"
assetsLoc="https://coopertronic-ws.ddns.net/ctos-assets/$webappName/"

##  Config.php vars
topConfigPHP=$(
    cat <<"EOT"
<?php
$CONFIG = array (
'datadirectory' => '/var/lib/nextcloud/data',
'logfile' => '/var/log/nextcloud/nextcloud.log',
'apps_paths' => [
  [
    'path'=> '/usr/share/webapps/nextcloud/apps',
    'url' => '/apps',
    'writable' => false,
  ],
  [
    'path'=> '/var/lib/nextcloud/apps',
    'url' => '/wapps',
    'writable' => true,
  ],
],
'trusted_domains' =>
  array (
    0 => 'localhost',
    1 => '
EOT
)
domainEnd=$(
    cat <<"EOT"
',
    2 => '
EOT
)
IPEnd=$(
    cat <<"EOT"
'
  ),
'overwrite.cli.url' => 'https://
EOT
)
URLEnd=$(
    cat <<"EOT"
',
'htaccess.RewriteBase' => '
EOT
)
subDIREnd=$(
    cat <<"EOT"
',
);
EOT
)

#check_root
clear
line_break '#'
cat <<EOT
    Welcome to the next cloud installer.
    To use this script you should be
    logged in as user with sudo privilges.

    Your current user path is:
    =>  $HOME

    The directory that this script has
    been launched from is:
    =>  $PWD

    You will need your user password and
    you may be asked to enter it more
    than once.

Are you ready to install Nextcloud?
EOT
to_continue
##  >>  Move user input to here
line_break
cat <<EOT
    The php.ini file has been successfully
    downloaded and installed. You will now
    need your computers IP address for the
    config.php that Nextcloud needs to
    make sure your able to reach it localy.

    In a moment you will see a list of
    network devices in your PC. The one
    you are looking for will start with
    somthing like 192.168.x.x but this may
    be different on your system.

Are you ready to scan the IP?
EOT
to_continue
##  >>  While all inputs start over okFlag (all correct)
##      Rename correctFlag to reflect the info being entered
##  Config Gen Start
configFlag=1
while [ $configFlag -ne 0 ]; do ## loop wrapps around the config gen
    ##  All OK start
    okFlag=1
    while [ $okFlag -ne 0 ]; do ## loop wrapps over all user input
        ##  IP Domain Start
        correctIPDomainFlag=1
        while [ $correctIPDomainFlag -ne 0 ]; do ## loop wrapps IP address
            ##  IP Address Start
            correctIPFlag=1
            while [ $correctIPFlag -ne 0 ]; do ## loop wrapps IP address
                clear
                line_break '#'
                echo "   You need to look in here for your IP address"
                line_break
                ip a
                line_break
                cat <<EOT
    Find your local IP address in the
    information above. It will look
    something like this:

    =>  192.168.x.x
EOT
                line_break
                echo "Please enter you IP address ..."
                read myIP
                clear
                line_break '#'
                cat <<EOT

    The IP you entered is:
    =>  $myIP

EOT
                line_break
                echo "Is this correct?"
                if is_correct $1; then
                    correctIPFlag=0
                fi
            done ## IP Address End
            correctDomainFlag=1
            ##  Domain Start
            while [ $correctDomainFlag -ne 0 ]; do ## loop wrapps Domain Name
                echo "It's best to use a domain name."
                echo "Please enter a domain name ..."
                read myDomain
                clear
                line_break '#'
                cat <<EOT

    The domain you entered is:
    =>  $myDomain

EOT
                line_break
                echo "Is this correct?"
                if is_correct $1; then
                    correctDomainFlag=0
                fi
            done ## Domain End
            clear
            line_break '#'
            cat <<EOT

    You have chosen to use:

    IP Address  =>  $myIP
    Domain Name =>  $myDomain

EOT
            line_break
            echo "Do you feel these are correct?"
            #to_continue
            if is_correct $1; then
                correctIPDomainFlag=0
            fi
        done ## IP Domain End
        clear
        line_break '#'
        cat <<EOT
    
    We will now create the new config.php
    file and copy it over to the correct
    directory for Nextcloud which is:

    =>  $configLoc

EOT
        line_break
        cat <<EOT
    
    Will you be installing in a subfolder?

    e.g =>  https://$myDomain/$webappName

    This would be useful if you are using
    a reverse proxy where other services
    are served from and where all the
    encryption is done.

EOT
        line_break
        echo "Are you installing to a subfolder?"
        subDIR=''
        subdirExists=1
        if is_correct $1; then
            subdirExists=0
            correctFlag=1
            while [ $correctFlag -ne 0 ]; do
                line_break
                echo "Please enter the sub directory you would like ..."
                read subDIR
                clear
                line_break '#'
                cat <<EOT
    You have entered:

    Directory   =>  $subDIR
    URL         =>  https://$myDomain/$subDIR/

    as the root of your Nextcloud service.

EOT
                echo "Is this correct?"
                if is_correct $1; then
                    correctFlag=0
                else
                    line_break
                    echo "Enter the sub directory again."
                fi
            done
        fi
        clear
        line_break '#'
        cat <<EOT
    The settings you have entered so far are:

    IP Address      =>  $myIP
    Domain Name     =>  $myDomain
EOT
        if [ $subdirExists -eq 0 ]; then
            cat <<EOT
    Sub Directory   =>  $subDIR

    This will mean that the domain,
    $myDomain which is
    assocated with the IP address
    $myIP will have Nextcloud
    installed at:

    =>  https://$myDomain/$subDIR/
    
EOT
        else
            cat <<EOT
    
    You did not use a sub folder, so
    your Nextcloud will be accessable
    via the following URL:

    =>  https://$myDomain

EOT
        fi
        line_break '~'
        echo "Do you feel that these setting are correct?"
        ##  >>  All correct Done
        if is_correct $1; then
            okFlag=0
        else
            line_break
            echo "Enter all the settings again?"
            to_continue
        fi
    done ## All OK End
    echo "So far, so good."
    clear
    line_break '#'
    cat <<EOT
    Here is the config generated based on
    if a sub directory was chosen or not.
EOT
    line_break '~'
    finalConfigPHP=''
    if [ $subdirExists -eq 0 ]; then
        finalConfigPHP="$topConfigPHP$myDomain$domainEnd$myIP$IPEnd$myDomain/$subDIR$URLEnd/$subDIR$subDIREnd"
    else
        finalConfigPHP="$topConfigPHP$myDomain$domainEnd$myIP$IPEnd$myDomain$URLEnd/$subDIREnd"
    fi
    echo "$finalConfigPHP"
    line_break
    echo "Do you feel this is correct?"
    if is_correct $1; then
        configFlag=0
    fi
    line_break
    echo "OK, let's get on with the rest."
done ## Config Gen End

##  >>  Move user input to here
line_break
echo "Installing packages ..."
if !( sudo pacman -Syu nextcloud php-legacy php-legacy-sodium php-legacy-imagick librsvg wget ); then
    echo "Failed to install packages."
    something_wrong
else
    if !( test_location "$nextcloudRoot" ); then
        echo "Check that Nextcloud has been installed."
        something_wrong
    else
        clear
        line_break '#'
        cat <<EOT
    Nextcloud is installed and ready
    to configure. Some configuration
    files will now be downloaded and
    installed. 

Are you ready to continue?
EOT
        to_continue
        line_break
        if !( sudo wget "${assetsLoc}php.ini" -P "$nextcloudRoot/" -O php.ini ); then
            echo "Cannot download file."
            something_wrong
        else
            sudo chown $webappName:$webappName "$nextcloudRoot/php.ini"
            line_break
            cat <<EOT
    The php.ini file has been successfully
    downloaded and installed.
EOT
            line_break
        fi ##   End Config Gen
    fi
fi
#sudo pacman -Syu nextcloud php-legacy php-legacy-sodium php-legacy-imagick librsvg wget

#sudo wget "${assetsLoc}php.ini" -P "$nextcloudRoot/"
#sudo chown $webappName:$webappName "$nextcloudRoot/php.ini"

#sudo wget "${assetsLoc}config.php" -P "$nextcloudRoot/config/"

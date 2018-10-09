#!/bin/sh
#
#
clear
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

now=$(date)
echo "Running project_updater.sh at $now \r\n
Current working dir: $SCRIPTPATH \r\n \r\n
 _____             _         _    _          _                                   
|     |___ ___ ___| |_ ___ _| |  | |_ _ _   |_|                                  
|   --|  _| -_| .'|  _| -_| . |  | . | | |   _                                   
|_____|_| |___|__,|_| |___|___|  |___|_  |  |_|                                  
                                     |___|                                       
                                                                                 
 _____ _       _     _           _              _____    __    _____             
|     | |_ ___|_|___| |_ ___ ___| |_ ___ ___   |     |__|  |  |   __|___ ___ _ _ 
|   --|   |  _| |_ -|  _| . | . |   | -_|  _|  | | | |  |  |  |  |  |  _| .'| | |
|_____|_|_|_| |_|___|_| |___|  _|_|_|___|_|    |_|_|_|_____|  |_____|_| |__,|_  |
                            |_|                                             |___|

Source: https://github.com/c2theg/path_checker/tree/master
Version:  0.0.4                             \r\n
Last Updated:  10/8/2018
\r\n \r\n"
#sudo -E apt-get update
wait
#sudo -E apt-get upgrade -y
#wait
#echo "Freeing up space"
#sudo apt-get autoremove -y
wait
#--------------------------------------------------------------------------------------------
echo "Checking Internet status...\r\n\r\n"
ping -q -c3 github.com > /dev/null
if [ $? -eq 0 ]
then
    echo "Connected!!! \r\n \r\n"
    echo "Deleting old files \r\n"	
    if [ -s "project_updater.sh" ]
    then
        rm project_updater.sh
        rm setup.sh
        rm get_metrics.py
        rm remote_listener.py
        rm register.py
        rm watchdog.sh
        rm watchdog.py
        #---------------
        rm /root/path_checker/project_updater.sh
        rm /root/path_checker/setup.sh
        rm /root/path_checker/get_metrics.py
        rm /root/path_checker/remote_listener.py
        rm /root/path_checker/register.py
        rm /root/path_checker/watchdog.sh
        rm /root/path_checker/watchdog.py
    fi

    echo "Downloading latest versions... \r\n\r\n"   
    sudo wget https://raw.githubusercontent.com/c2theg/path_checker/master/project_updater.sh
    sudo wget https://raw.githubusercontent.com/c2theg/path_checker/master/setup.sh
    sudo wget https://raw.githubusercontent.com/c2theg/path_checker/master/get_metrics.py
    sudo wget https://raw.githubusercontent.com/c2theg/path_checker/master/register.py
    sudo wget https://raw.githubusercontent.com/c2theg/path_checker/master/remote_listener.py
    sudo wget https://raw.githubusercontent.com/c2theg/path_checker/master/watchdog.sh
    sudo wget https://raw.githubusercontent.com/c2theg/path_checker/master/watchdog.py

    if [ ! -s "config.json" ]
    then
        sudo wget https://raw.githubusercontent.com/c2theg/path_checker/master/config.json
    fi

    #-----------------------------------------------
    chmod u+x project_updater.sh
    chmod u+x setup.sh
    chmod u+x get_metrics.py
    chmod u+x register.py
    chmod u+x remote_listener.py
    chmod u+x watchdog.sh
    chmod u+x watchdog.py
    wait
    
    if [ ! -d "/root/path_checker/" ]
    then
        mkdir /root/path_checker/
    fi
    
    mv project_updater.sh /root/path_checker/project_updater.sh
    mv setup.sh /root/path_checker/setup.sh
    mv get_metrics.py /root/path_checker/get_metrics.py
    mv register.py /root/path_checker/register.py
    mv remote_listener.py /root/path_checker/remote_listener.py
    mv watchdog.sh /root/path_checker/watchdog.sh
    mv watchdog.py /root/path_checker/watchdog.py
    wait

    #--------------------------------------------------------------
    #sh /root/update_ubuntu14.04.sh
else
    echo "Not connected to the Internet. Fix that first and try again \r\n \r\n"
fi


Cron_output=$(crontab -l | grep "project_updater.sh")
#echo "The output is: [ $Cron_output ]"
if [ -z "$Cron_output" ]
then
    echo "Script (project_updater) not in crontab. Adding."

    # run “At 02:21.” everyday
    line="21 2 * * * /root/path_checker/project_updater.sh >> /var/log/project_updater.log 2>&1"
    (crontab -u root -l; echo "$line" ) | crontab -u root -

    line="@reboot /root/path_checker/project_updater.sh >> /var/log/project_updater.log 2>&1"
    (crontab -u root -l; echo "$line" ) | crontab -u root -

    #------------------------------------------    
    # run “At 7 minutes past every hour”
    line="7 * * * * /root/path_checker/register.py >> /var/log/register.log 2>&1"
    (crontab -u root -l; echo "$line" ) | crontab -u root -
    
    # run “Run every 30 minutes”
    line="*/30 * * * * /root/path_checker/watchdog.sh >> /var/log/watchdog-sh.log 2>&1"
    (crontab -u root -l; echo "$line" ) | crontab -u root -
 
    # run “Run every 5 minutes”
    line="*/5 * * * * /root/path_checker/watchdog.py >> /var/log/watchdog-py.log 2>&1"
    (crontab -u root -l; echo "$line" ) | crontab -u root -
 
    wait
    /etc/init.d/cron restart  > /dev/null
else
    echo "Script was found in crontab. skipping addition"
fi


echo "Done! \r\n \r\n"

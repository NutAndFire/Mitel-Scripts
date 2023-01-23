#!/usr/bin/env bash

## KMS SO3732
## 
## Title
## NuPoint ports not answering (Ring No Answer) (RNA)
##
## Symptoms
## NuPoint ports not answering.
## When huntgroup or individual port called vccs and event recorder showed no activity. 
## All configuration on NuPoint was correct and on initial investigation all configuration on 
## MiVB correct set type was enabled for NuPoint license and Class of Service correctly set. 


printf "\033c"

banner()
{
printf "

    #                                   #####
   # #   ##### #        ##    ####     #     #  ####  #    # #    #  ####
  #   #    #   #       #  #  #         #       #    # ##  ## ##  ## #
 #     #   #   #      #    #  ####     #       #    # # ## # # ## #  ####
 #######   #   #      ######      #    #       #    # #    # #    #      #
 #     #   #   #      #    # #    #    #     # #    # #    # #    # #    #
 #     #   #   ###### #    #  ####      #####   ####  #    # #    #  ####
"
}

author()
{
printf "
##########################################################################
#Script Name : VMPortRedundancy                                          #
#Description : Check VM ports are correctly going to desired controller, #
#              rebuild redundancy file and view active VM ports          #
#Author      : Chris Bleakley                                            #
#Email       : chris.bleakley@atlas-comms.com                            #
#Version     : 23123-2300                                                #
##########################################################################
\n
"
}

banner
author

viewPort() {
    ps -ef | grep MitaiMonitor
}

activatecfgCmd() {
	printf "Start the build of the resilient.ini file\n"
	activetecfg -C
	printf "[*] Done!\n"
}

rebuldRedundancyFile() {
    FILE=/usr/vm/config/resilient.ini
    if [[ -f "$FILE" ]]; then
        printf "Removing resilient.ini file\n"
        rm $FILE -y
        printf "[*] Done!\n"
        printf "Start rebuild of the resilient.ini file\n"
        activatecfg -C
        printf "[*] Done!\n"
        viewPort
    else
		printf "$FILE does not exist.\n"
	    while true; do
		    read -p "Do you still wan to run activatecfg? (y/n)" yn
			case $yn in
				[Yy]* ) activatecfgCmd; break;;
				[Nn]* ) exit;;
				* ) echo "Please answer yes or no.";;
			esac
		done
    fi
}

livePortViewer() {
  vccs
}

help() {
    echo "VMPortRedundancy Usage:"
    echo "    ./VMPortRedundancy -h               Display this help message."
    echo "    ./VMPortRedundancy -v               View current Redundancy ports."
    echo "    ./VMPortRedundancy -R               Delete current Redundancy file and rebuild."
    echo "    ./VMPortRedundancy -s               Show Live calls accessing VM Ports."
}

main() {
    local OPTIND opt i
    while getopts ":hvRs" opt; do
        case $opt in
            v )
              viewPort
              ;;
            R )
              rebuldRedundancyFile
              ;;
            s )
              livePortViewer
              ;;
            h )
              help
              exit 0
              ;;
            \? )
              echo "Invalid Option: -$OPTARG" 1>&2
              echo
              help
              exit 1
              ;;
        esac
    done

    if [ $OPTIND -eq 1 ]; then
        echo "No options were passed"
        echo
        help
    fi

    shift $((OPTIND -1))
}

main $@

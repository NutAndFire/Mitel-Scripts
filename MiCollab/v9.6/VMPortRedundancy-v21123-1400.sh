#!/usr/bin/env bash

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
#Version     : 21123-1400                                                #
##########################################################################
\n
"
}

banner
author

viewPort() {
    ps -ef | grep MitaiMonitor
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
        printf "Start the build of the resilient.ini file\n"
        activetecfg -C
        printf "[*] Done!\n"
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

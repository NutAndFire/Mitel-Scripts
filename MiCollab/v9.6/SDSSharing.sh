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
#Script Name : SDSSharing-v030223-0900                                   #
#Description : Check VM ports are correctly going to desired controller, #
#              rebuild redundancy file and view active VM ports          #
#Author      : Chris Bleakley                                            #
#Email       : chris.bleakley@atlas-comms.com                            #
#Version     : 030223-0900                                               #
##########################################################################
\n
"
}

banner
author

stopSDSSharing() {
	printf "[*] Stopping SDS Sharing\n"
	/usr/mas/bin/sds-utility -s
	printf "[*] Done!\n"
}

startSDSSharing() {
	printf "[*] Starting SDS Sharing\n"
	/usr/mas/bin/sds-utility -c
	printf "[*] Done!\n"
}

viewLog() {
	tailf /var/log/tomcat/current
	printf "\n"
}

help() {
    echo "SDSSharing Usage:"
    echo "    ./SDSSharing -h               Display this help message."
    echo "    ./SDSSharing -S               Stop SDS Sharing."
    echo "    ./SDSSharing -c               Start SDS Sharing."
    echo "    ./SDSSharing -v               Show tail end of the log."
}

main() {
    local OPTIND opt i
    while getopts ":Scvh" opt; do
        case $opt in
            S )
              stopSDSSharing
              ;;
            c )
              startSDSSharing
              ;;
            v )
              viewLog
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
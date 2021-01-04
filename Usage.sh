#!/bin/bash

#########################################################################
#Help
########################################################################

Help()
{
    # Display help
    echo "This script helps you monitor your current disk and memory usage."
    echo
    echo "Syntax: usage [-l|h]"
    echo "Options: "
    echo "l [disk|ram]    Specify disk or RAM "
    echo "h    Print this help page"
    echo
}

#########################################################################
#Other functions
########################################################################

Memory()
{
    # Display memory
    echo "------------------Current Memory Usage---------------------"
    free -h
}

Disk()
{
    # Display Disk space usage
    echo "------------------Current Disk Usage-----------------------"
    df -h
}

#########################################################################
#Main Program
#########################################################################

optstring=":hl:"

while getopts ${optstring} arg ; do
    case ${arg} in
        l)
          #Check memory usage

          interest=${OPTARG,,} # OPTARG is built into getopts 
                               # while ,, is lower case

          if [[ "$interest" == "ram" ]]; then
             Memory
             exit 0

          elif [[ "$interest" == "disk" ]]; then
             Disk
             exit 0

          elif [[ "$interest" == "both" ]]; then
             Memory
             Disk
             exit 0

          else
             echo "Unknown argument: ${interest}"
             echo
             Help
             exit 1
          fi
          ;;

        h)
          # Prints help
          Help
          exit 0
          echo
          ;;

        ?)
          # For if the user enters invalid option
          echo "Invalid option: -${OPTARG}."
          echo 
          Help
          exit 1
          ;;
    esac
done

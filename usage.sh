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
    echo "Options:"
    printf "%-30s Specify disk or RAM \n" "l [disk|ram|freq|temp|all]"
    printf "%-30s Print this help page \n" "h"
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

Cpu_freq()
{
    # Display CPU frequency of all cores, ARM archictecture specific
    arm_core_path="/sys/devices/system/cpu/" #Don't put space between equal and variable
    # $(()) is for arithmic expansion, while $() is for command expansion 
    echo "------------------Current CPU frequency-----------------------"
    echo "Core count: $(ls ${arm_core_path} | grep -c "cpu[0-9]")"
    core_names=($(ls ${arm_core_path} | grep "cpu[0-9]")) # Outer bracket is to store in array for iteration

    for (( i=0; i<${#core_names[@]}; i++ ));
    do
        echo "CPU core ${i+1}: $(($(cat ${arm_core_path}/${core_names[$i]}/cpufreq/scaling_cur_freq)/1000))Ghz"
    done
}

Cpu_temp()
{
    #Display CPU temperature, ARM archictecture specific
    echo "------------------Current CPU Temperature-----------------------"
    cpu_temp=$(cat /sys/class/thermal/thermal_zone0/temp)
    echo "Current CPU Temperature: $((${cpu_temp}/1000)) 'C"
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

          elif [[ "$interest" == "all" ]]; then
             Memory
             Disk
             Cpu_freq
             Cpu_temp
             exit 0

          elif [[ "$interest" == "freq" ]]; then
             Cpu_freq
             exit 0

          elif [[ "$interest" == "temp" ]]; then
             Cpu_temp
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

if [ $OPTIND -eq 1 ]; then
    echo $'No options were passed. Please refer to help below. \n' 
    # This one is interesting, $'' is not the same as $"", the latter resulting in \n not being read
    # $'' follows the ANSI C implementation, which recognises newline character! 
    Help
    exit
fi

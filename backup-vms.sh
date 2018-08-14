#!/bin/bash
#
#
#	Backup Virtual Machines on server Ethiopia to Medemer
#
#
#

# create array with names of virtual machines


declare -a virtual_machines=("bitnami-edx_1")

# loop through virtual machines and shut them down
for i in "${virtual_machines[@]}"
do
	sshpass -p "bitnami" ssh -o StrictHostKeyChecking=no bitnami@IP poweroff
done

#!/bin/bash
#
#
#	Backup Virtual Machines on server Ethiopia to Medemer
#
#
#

# create array with names of virtual machines
echo
echo "Camara Virtual Machine Backup Utility 0.1"
echo

declare -A virtualmachines

virtualmachines=(
	[bitnami-edx_1]="172.16.10.249"
	)

users=(
	[bitnami-edx_1]="bitnami"
	)

passwords=(
	[bitnami-edx_1]="bitnami"
	)

#check if sshpass is installed and install it if not

if ! (dpkg-query -l sshpass) > /dev/null; then
   echo -e "sshpass not installed, installing (sudo might be required)... "
   sudo apt install sshpass
fi



# loop through virtual machines and shut them down
for i in "${!virtualmachines[@]}"
do

	echo "shutting down $i through ip ${virtualmachines[$i]}"
	sshpass -p ${passwords[$i]} ssh -o StrictHostKeyChecking=no ${users[$i]}@${virtualmachines[$i]} sudo poweroff

	echo "Waiting for machine $i to poweroff..."

	until $(VBoxManage showvminfo --machinereadable $i | grep -q ^VMState=.poweroff.)

	do
	  sleep 1
	  echo "poweroff state not reached for $i"
	done

	echo "poweroff of $i successful, building ova"
	echo

	# build .ova in home directory to then transport to medemer
	VBoxManage export $i -o $i.ova


done

echo



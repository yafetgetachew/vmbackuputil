#!/bin/bash
#
#
#	Backup Virtual Machines to SERVERNAME 
#
#
#

# create array with names, ips, usernames and passwords of virtual machines
echo
echo "Backup utility for VirtualBox virtual machines"
echo

ssh-add

declare -A virtualmachines

virtualmachines=(
	[VIRTUAL_MACHINE_NAME]="VIRTUAL_MACHINE_IPADDRESS"
	)

users=(
	[VIRTUAL_MACHINE_NAME]="VIRTUAL_MACHINE_USERNAME"
	)

passwords=(
	[VIRTUAL_MACHINE_NAME]="VIRTUAL_MACHINE_USER_PASSWORD"
	)

#make a directory 
mkdir -p backup-vms

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
	VBoxManage export $i -o backup-vms/$i-$(date +"%m-%d-%y").ova

	# Copy backed up file to remote backup folder
	rsync -e 'ssh -p 22' -avzpi --progress backup-vms BACKUP_SERVER_USER@BACKUP_SERVER_IP:~/backup/backup-vms
	#rm -rf backup-vms/*

	echo "SUCCESSFUL BACKUP OPERATION"
done

echo



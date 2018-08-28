Before you do anything with the shellscript you should create an RSA key with 

```shell
	ssh-keygen
```

then you should copy your public key to medemer with 

```shell
	ssh-copy-id -i ~/.ssh/id_rsa.pub BACKUP_SERVER_USERNAME@BACKUP_SERVER_IP

	ssh-add
```

make sure you have passwordless ssh access with 

```shell
	ssh BACKUP_SERVER_USERNAME@BACKUP_SERVER_IP
```



To add your virtual machine to the list of machines to be backed up to MEDEMER 

- open the backup-vms.sh shellscript
- append the following three lines to the three variables (virtualmachine, users, passwords)

```shell
	virtualmachines=(
		[your vm name]="your vm IP"
		)

	users=(
		[your vm name]="your vm user name"
		)

	passwords=(
		[your vm name]="your vm password"
		)
```

the vm name you use must be the one registered in the virtual box, to see a list of registered
vms in virtualbox use

```shell
	VBoxManage list vms
```
and the names should be in quotes like so "imagename"

		

#!/bin/bash

CurrentDir=$(pwd)
BoxBaseName=${PWD##*/}
VMName=win10
VMPath=~/VirtualBox\ VMs/${VMName}/${VMName}.vbox
BoxName=${BoxBaseName}.box
OVFName=box.ovf
VagrantBoxName=${VMName}

printf "Creating a vagrant basebox named $BoxName \n"

# Remove existing artifacts
rm -f box-disk1.vmdk
rm -f box.ovf
rm -f $BoxName
rm -f "${BoxName}.md5"

# Prepare the VM
# compacting for vmdk is not yet supported.
#vboxmanage modifyhd ~/VirtualBox\ VMs/${VMName}/${VMName}.vmdk --compact
#vmware-vdiskmanager -d "~/VirtualBox\ VMs/${VMName}/${VMName}.vmdk"
#vmware-vdiskmanager -k "~/VirtualBox\ VMs/${VMName}/${VMName}.vmdk"
vboxmanage export "$VMPath" -o $OVFName #--vsys 0 --eula "This is for evaluation purposes only. You must provide a valid license to use this box."

# Tar and gzip the box
tar --exclude='*.sh' -cvzf $BoxName ./*

# Remove the artifacts to save space
rm -f box-disk1.vmdk
rm -f box.ovf

# calculate md5 hash
md5 "$BoxName" > "${BoxName}.md5"

# Add/update the box
vagrant box add "$VagrantBoxName" $BoxName --provider virtualbox --force

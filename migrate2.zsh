#!/usr/bin/env zsh

sudo rm /etc/modprobe.d/nvidia-power-management.conf
echo 'options nvidia NVreg_UsePageAttributeTable=1 NVreg_PreserveVideoMemoryAllocations=1 NVreg_TemporaryFilePath=/var/tmp' | sudo tee /etc/modprobe.d/nvidia.conf > /dev/null

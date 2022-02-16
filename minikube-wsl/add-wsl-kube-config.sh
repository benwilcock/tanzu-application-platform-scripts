#!/bin/bash
# Make sure there is a .kube directory in the users WSL home directory.
mkdir ~/.kube
# Get the users Windows username (may differ)
export WINUSER=$(/mnt/c/Windows/System32/cmd.exe /c 'echo %USERNAME%')
# Copy the Kubectl config over from Windows to WSL
cp /mnt/c/Users/$WINUSER/.kube/config ~/.kube/config

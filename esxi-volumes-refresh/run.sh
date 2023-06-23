#!/bin/bash

# run on esxi host

esxcfg-advcfg -s 0 /LVM/DisallowSnapshotLun

# This returns output similar to:

# Value of DisallowSnapshotLun is 0

# After this is done, issue a storage controller rescan followed by a filesystem refresh:

esxcli storage core adapter rescan --all
vmkfstools -V
## iSCSI Demo WalkThru

### Requirements
* Minimum VM: 1vCPU x 1G mem, running RHEL 7.latest
* Will need root or sudo to install packages

### WalkThru
* iSCSI target Install
  * Run first, before initiator setup
```
      # iscsi-target.sh
```
* Script installs packages, starts services, configures firewall
  * It also assumes VM does not have an extra storage device, so it "steals" 100MB from swap
* iSCSI target Configuration
  * Script also does the following steps, included here to provide explanation
  * Create backstore, in this case one that is block-based (LVM)
    * Backstore name = ```rhel-target:disk1```
    * Block device (LVM) = ```/dev/rhel/iscsi_target```
```
      # targetcli /backstores/block create rhel-target:disk1 /dev/rhel/iscsi_target
```
  * Create target
    * Target name = ```iqn.2019-01.com.example:rhel-target```
```
      # targetcli /iscsi create iqn.2019-01.com.example:rhel-target
```
  * Create portal
```
      # targetcli /iscsi/iqn.2019-01.com.example:rhel-target/tpg1/portals create
```
  * Create LUN, notice use of backstore block device
```  
      # targetcli /iscsi/iqn.2019-01.com.example:rhel-target/tpg1/luns create /backstores/block/rhel-target:disk1
```
  * Set up ACLs
    * Specifies which initiator (client) can connect and use the target = ```iqn.2019-01.com.example:rhel-initiator```
```  
      # targetcli /iscsi/iqn.2019-01.com.example:rhel-target/tpg1/acls create iqn.2019-01.com.example:rhel-initiator
```
* To view the entire iSCSI target configuration:
```
      # targetcli ls
```
* iSCSI initiator Install
  * Assumes that name resolution does not necessarily exist between initiator and target (e.g. kvm/libvirt environment)
  * Edit script to include IP address of target
  * Run after target setup
  * Script installs packages, creates /etc/iscsi/initiatorname.iscsi file, and starts services
* iSCSI initiator Configuration  
  * Script also does the following steps, included here to provide explanation
  * Discover the target
```
      # iscsiadm -m discovery -t st -p $TargetIPAddr
```
  * Login to the target
```
      # iscsiadm -m node -T iqn.2019-01.com.example:rhel-target -p $TargetIPAddr -l
```
  * If everything was successful: create an entry in fstab and mount the volume
```
      # echo "UUID=$(blkid /dev/sdb | cut -f2 -d\") /iscsidisk xfs _netdev 0 2">>/etc/fstab
      # mkdir /iscsidisk && mount /iscsidisk
```
* Viewing & Troubleshooting initiator
  * If everything did not complete successfully, or other troubleshooting is required
  * Node information
```
      # iscsiadm -m node -P1
```
  * Session statistics
```
      # iscsiadm -m session -s
```
  * Session details
```
      # iscsiadm -m session -P1
```
* Session details, including disk information
```
      # iscsiadm -m session -P3
```

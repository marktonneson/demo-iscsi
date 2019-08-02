yum install -y targetd targetcli
systemctl enable target
systemctl enable targetd
systemctl start target
systemctl start targetd
firewall-cmd --permanent --add-port=3260/tcp
firewall-cmd --reload
swapoff -a
lvreduce -L -100M  /dev/rhel/swap
mkswap /dev/rhel/swap 
swapon -a
lvcreate -n iscsi_target -l 100%FREE rhel
mkfs.xfs /dev/rhel/iscsi_target 
targetcli /backstores/block create rhel7-target:disk1 /dev/rhel/iscsi_target
targetcli /iscsi create iqn.2018-01.org.tonneson:rhel7-target
targetcli /iscsi/iqn.2018-01.org.tonneson:rhel7-target/tpg1/acls create iqn.2018-01.org.tonneson:rhel7-initiator
targetcli /iscsi/iqn.2018-01.org.tonneson:rhel7-target/tpg1/luns create /backstores/block/rhel7-target:disk1
targetcli /iscsi/iqn.2018-01.org.tonneson:rhel7-target/tpg1/portals create 192.168.122.50

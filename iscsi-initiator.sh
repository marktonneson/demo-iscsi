yum install -y iscsi-initiator-utils
echo "InitiatorName=iqn.2018-01.org.tonneson:rhel7-initiator">/etc/iscsi/initiatorname.iscsi
systemctl enable iscsi
systemctl start iscsi
iscsiadm -m discovery -t st -p 192.168.122.50
iscsiadm -m node -T iqn.2018-01.org.tonneson:rhel7-target -p 192.168.122.50 -l
echo "UUID=$(blkid /dev/sdb | cut -f2 -d\") /iscsidisk xfs _netdev 0 2">>/etc/fstab
mkdir /iscsidisk
mount /iscsidisk 
touch /iscsidisk/file_from_rhel7_initiator

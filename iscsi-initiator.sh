yum install -y iscsi-initiator-utils
# Edit accordingly for target ip address
TargetIPAddr=192.168.122.55

echo "InitiatorName=iqn.2019-01.com.example:rhel-initiator">/etc/iscsi/initiatorname.iscsi
systemctl enable iscsi
systemctl start iscsi
iscsiadm -m discovery -t st -p $TargetIPAddr
iscsiadm -m node -T iqn.2019-01.com.example:rhel-target -p $TargetIPAddr -l
echo "UUID=$(blkid /dev/sdb | cut -f2 -d\") /iscsidisk xfs _netdev 0 2">>/etc/fstab
mkdir /iscsidisk
mount /iscsidisk 
touch /iscsidisk/file_from_rhel_initiator

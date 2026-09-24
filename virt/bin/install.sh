#!/bin/bash
VM_CONFIG_DIR="/virt/vm_configs"
VIRT_INSTALL="qm create"
GLOBAL_OPTS="-serial0 socket --localtime true --scsihw virtio-scsi-single --boot order=virtio0"
WIN_OPTS="--noreboot --force --import"
IMGDIR="images"
VIRSH="qm"
QEMUIMG="/usr/bin/qemu-img"

function get_extra_args {
	case ${INTERFACES[0]} in
		40)
			DOMAIN="ks.useractive.com"
			KSDEVICE="eth0"
			;;
		131)
			DOMAIN="local.useractive.com"
			KSDEVICE="eth0"
			;;
		141)
			DOMAIN="local.userworld.com"
			KSDEVICE="eth0"
			;;
		25)
			DOMAIN="win.userworld.com"
			KSDEVICE="eth0"
			;;
		199)
			DOMAIN="useractive.com"
			for (( INDEX=0; INDEX<${#INTERFACES[@]} ; INDEX++ ))
			do
        			if [ ${INTERFACES[$INDEX]} == "40" -o ${INTERFACES[$INDEX]} == "141" -o ${INTERFACES[$INDEX]} == "141" ]
        			then
                			KSDEVICE="eth$INDEX"
                			break
        			fi
			done
			IP=`get_ip $HOSTNAME.userworld.com`
                        if [ -z "$IP" ]; then
                            IP=`get_ip $HOSTNAME.useractive.com`
                        fi
                        ETH0="ip=$IP::199.27.148.1:255.255.255.0::eth0:none bootdev=eth1"
			
			;;
		*)
			echo "The INTERFACES variable in $VM_CONFIG_DIR/$HOSTNAME has a typo."
			;;
	esac
	if [ -z "$HOSTNAMEOVERRIDE" ]; then
	    HOSTNAMEOVERRIDE=$HOSTNAME.$DOMAIN
	fi
	if [ "$VERSION" == "8" ]; then
	    EIGHTARGS="net.ifnames=0 inst.waitfornet=10 ip=eth1:dhcp $ETH0 inst.net.noautodefault inst.notmux inst.kdump_addon=off"
	else
	    EIGHTARGS="ksdevice=$KSDEVICE"
	fi
	echo "ks=http://10.0.141.13/ks/$KSFILE $EIGHTARGS console=tty0 console=ttyS0 systype=$SYSTYPE extrakeys=$EXTRAKEYS hostname=$HOSTNAMEOVERRIDE"
}

function make_netlist {
        unset NETLIST
        IFN=0
	for NET in ${INTERFACES[@]}
	do
	        NETTAG=",tag=$NET"
	        case $NET in
			0)
			        IP=`get_ip $HOSTNAME.lan`
			        NETTAG=""
				;;
			5)
				IP=`get_ip $HOSTNAME.ilo.useractive.com`
				;;
			15)
				IP=`get_ip $HOSTNAME.win.useractive.com`
				;;
			17)
				IP=`get_ip $HOSTNAME.testwin.useractive.com`
				;;
			25)
				IP=`get_ip $HOSTNAME.win.userworld.com`
				;;
			40)
				IP=`get_ip $HOSTNAME.ks.useractive.com`
				;;
			69)
				IP=`get_ip $HOSTNAME.kvm.useractive.com`
				;;
			131)
				IP=`get_ip $HOSTNAME.local.useractive.com`
				;;
			141)
				IP=`get_ip $HOSTNAME.local.userworld.com`
				;;
			172)
				IP=`get_ip $HOSTNAME.cluster.useractive.com`
				;;
			199)
				IP=`get_ip $HOSTNAME.userworld.com`
				if [ -z "$IP" ]; then
				    IP=`get_ip $HOSTNAME.useractive.com`
				fi
				;;
			*)
				echo "The INTERFACES variable in $VM_CONFIG_DIR/$HOSTNAME has a typo."
				::
		esac
		MAC=`ip_to_mac $IP`
		NETLIST="$NETLIST --net$IFN virtio=$MAC,bridge=vmbr0$NETTAG"
		((IFN++))
	done
	echo $NETLIST
}

function get_ip {
	FQDN=$1

	# We want to make sure we get back an actual IP back here.
	# If so, store the output to an array.  The 3rd element is the IP.
	if OUTPUT=(`/usr/bin/host $FQDN`)
	then
		echo ${OUTPUT[3]}
	else
		echo "$FQDN did not resolve properly.  Please fix it." 1>&2
		exit 1
	fi
}

function ip_to_mac {
	IP=${1//./" "}
	HEXMAP=( 0 1 2 3 4 5 6 7 8 9 a b c d e f )
	MAC="54:52"

	for DQ in $IP
	do
        	let LOWER_INDEX=$DQ%16
        	let UPPER_INDEX=($DQ-$DQ%16)/16
        	MAC="$MAC:${HEXMAP[$UPPER_INDEX]}${HEXMAP[$LOWER_INDEX]}"
	done

	echo $MAC
}

function make_disklist {
	unset DISKLIST
	for DISK in ${DISKS[@]}
	do
		DISKLIST="$DISKLIST --disk $DISK"
	done

	echo $DISKLIST
}

# Make sure we have exactly the right amount of arguments
if [ $# -ne 1 ]
then
	echo "Usage: install.sh hostname"
	exit 1
fi

HOSTNAME=$1

# Read in our configuration parameters
if [ -f $VM_CONFIG_DIR/$HOSTNAME ]
then
	. $VM_CONFIG_DIR/$HOSTNAME
else
	echo "You don't have a configuration for this host yet."
	exit 1
fi

NETLIST=`make_netlist`

if [ $OSTYPE == "linux" ]
then
    
	EXTRA_ARGS=`get_extra_args`
	TMPFILE=`mktemp`
	chmod 755 $TMPFILE
	echo "#!/bin/bash" >> $TMPFILE
        if [ -z "$DISKS" ]; then
            DISKLIST="--scsi0=$IMGDIR:$FILESIZE,discard=on,format=qcow2,ssd=1"
        else
            DISKLIST=`make_disklist`
        fi
	VMID=$(pvesh get /cluster/nextid)
	echo $VIRT_INSTALL $VMID $GLOBAL_OPTS \
	$DISKLIST \
	--name $HOSTNAME \
	--memory $RAM \
	$NETLIST \
	--args \'"-kernel /virt/images/vmlinuz-$OSTYPE$VERSION -initrd /virt/images/initrd.img-$OSTYPE$VERSION -append \""$EXTRA_ARGS"\""\' | tee -a $TMPFILE
	echo $TMPFILE
	#	VISUAL="sed -i -e s/'utc'/'localtime'/" $VIRSH edit $HOSTNAME
	echo $VIRSH start $VMID \; $VIRSH terminal $VMID | tee -a $TMPFILE
	echo qm stop $VMID | tee -a $TMPFILE
	echo qm set $VMID --args \'\'  | tee -a $TMPFILE
        echo qm start $VMID \; $VIRSH terminal	$VMID  | tee -a $TMPFILE
	echo echo | tee -a $TMPFILE
	echo echo $VIRSH stop $VMID | tee -a $TMPFILE
	echo echo $VIRSH destroy $VMID | tee -a $TMPFILE
	echo echo | tee -a $TMPFILE
	echo echo $VIRSH terminal $VMID | tee -a $TMPFILE
	exec $TMPFILE
elif [ $OSTYPE == "windows" ]
then
	DISKLIST=`make_disklist`
	$QEMUIMG create -f qcow2 -b $BACKINGIMG $IMGDIR/$HOSTNAME.qcow2
	$VIRT_INSTALL $GLOBAL_OPTS $WIN_OPTS --os-type=$OSTYPE --os-variant=$OSVARIANT \
	--name $HOSTNAME \
	--vcpus $VCPUS --ram $RAM \
	$DISKLIST \
	$NETLIST
fi

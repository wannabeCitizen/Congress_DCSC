class ovs {
	
	package {"openvswitch":
		name    => "openvswitch-switch",
		ensure  => installed,
	}

	service {"openvswitch":
		name    => "openvswitch-switch",
		ensure  => running,
		enable  => true,
		requore => Package["openvswitch"],
	}
}

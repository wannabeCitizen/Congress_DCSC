define libvirt::libvirtd::setting ($key=$name, $value) {

	ini_setting {"libvirtd::$name":
		require => Package["libvirt-bin"],
		notify  => Service["libvirt-bin"],
		path    => "/etc/libvirt/libvirtd.conf",
		section => "",
		setting => $key,
		value   => $value,
	}
}

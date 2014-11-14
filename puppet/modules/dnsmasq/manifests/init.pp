class dnsmasq (
	$conf_source      = undef,
	$conf_content     = undef,
) {
	package {"dnsmasq":
		ensure  => installed,
	}

	service {"dnsmasq":
		ensure  => running,
		enable  => true,
		require => Package["dnsmasq"],
	}

	file {"/etc/dnsmasq.conf":
		source  => $conf_source,
		content => $conf_content,
		require => Package["dnsmasq"],
		notify  => Service["dnsmasq"],
	}

	file {["/etc/dnsmasq.d", "/etc/dnsmasq-hosts.d"]:
		ensure => directory,
		require => Package["dnsmasq"],
	}
}

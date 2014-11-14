class libvirt (
	$qemu_disable_default_network = true,
	$tls_cacert = undef,
	$tls_cert   = undef,
	$tls_key    = undef,
) {
	package {"libvirt-bin":
		ensure  => installed,
	}

	service {"libvirt-bin":
		ensure  => running,
		enable  => true,
		require => Package["libvirt-bin"],
	}

	if $qemu_disable_default_network {

		file {"/etc/libvirt/qemu/networks/autostart/default.xml":
			ensure  => absent,
			require => Package["libvirt-bin"],
			notify  => Service["libvirt-bin"],
		}

		exec {"virsh net-destroy default":
			refreshonly => true,
			require     => Service["libvirt-bin"],
			subscribe   => File["/etc/libvirt/qemu/networks/autostart/default.xml"],
		}
	}

	if $tls_cacert and $tls_cert and $tls_key {

		# For some reason the libvirt client has these paths hardcoded
		file {
			"/etc/pki/CA":
				ensure => directory;
			"/etc/pki/CA/cacert.pem":
				target => $tls_cacert;
			"/etc/pki/libvirt":
				ensure => directory;
			"/etc/pki/libvirt/private":
				ensure => directory;
			"/etc/pki/libvirt/private/clientkey.pem":
				target => $tls_key;
			"/etc/pki/libvirt/clientcert.pem":
				target => $tls_cert;
		}

		libvirt::libvirtd::setting {
			"listen_tls": value => 1;
			"key_file":   value => "\"$tls_key\"";
			"cert_file":  value => "\"$tls_cert\"";
			"ca_file":    value => "\"$tls_cacert\"";
		}

		env_setting {"libvirtd::opts":
			require => Package["libvirt-bin"],
			notify  => Service["libvirt-bin"],
			file    => "/etc/default/libvirt-bin",
			key     => "libvirtd_opts",
			value   => "-d --listen",
			quote   => '"',
		}
	}
}

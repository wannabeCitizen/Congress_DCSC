class nfs::server (
	$nfs_root = "/srv/nfs",
) {

	require nfs

	package {"nfs-kernel-server":
		ensure  => installed,
	}

	service {"nfs-kernel-server":
		ensure  => running,
		enable  => true,
		require => Package["nfs-kernel-server"],
	}

	file {$nfs_root:
		ensure => directory,
	}

	exec {"exportfs":
		refreshonly => true,
		command     => "exportfs -ra",
		require     => Package["nfs-kernel-server"],
	}

	concat {"/etc/exports":
		replace     => true,
		require     => Package["nfs-kernel-server"],
		notify      => Exec["exportfs"],
	}
	concat::fragment {"/etc/exports::header":
		target      => "/etc/exports",
		source      => "puppet:///modules/nfs/exports-header",
		order       => "00",
	}
}

class nfs (
	$idmapd        = undef,
	$idmapd_domain = undef,
	$statd         = undef,
	$gssd          = undef,
) {
	package {"nfs-common":
		ensure => present,
	}

	case $idmapd  {
		true: {
			service {"idmapd":
				ensure  => running,
				require => Package["nfs-common"],
			}
		}
		false: {
			service {"idmapd":
				ensure  => stopped,
				require => Package["nfs-common"],
			}
		}
	}

	if $idmapd_domain {
		ini_setting {"/etc/idmapd.conf::[General]::domain":
			path    => "/etc/idmapd.conf",
			section => "General",
			setting => "domain",
			value   => $idmapd_domain,
			require => Package["nfs-common"],
		}
	}

	case $statd {
		true: {
			service {"statd":
				ensure  => running,
				require => Package["nfs-common"],
			}
			nfs::default {"NEED_STATD": value=>"yes"}
		}
		false: {
			service {"statd":
				ensure  => stopped,
				require => Package["nfs-common"],
			}
			nfs::default {"NEED_STATD": value=>"no"}
		}
	}

	case $gssd {
		true: {
			service {"gssd":
				ensure  => running,
				require => Package["nfs-common"],
			}
			nfs::default {"NEED_GSSD": value=>"yes"}
		}
		false: {
			service {"gssd":
				ensure  => stopped,
				require => Package["nfs-common"],
			}
			nfs::default {"NEED_GSSD": value=>"no"}
		}
	}
}

define nfs::default ($value) {
	env_setting {"/etc/default/nfs-common::$name":
		file    => "/etc/default/nfs-common",
		key     => $name,
		value   => $value,
		quote   => "",
		require => Package["nfs-common"],
	}
}

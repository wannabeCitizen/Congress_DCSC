class tzdata ($timezone) {

	package {"tzdata":
		ensure => latest,
	}

	if $osfamily == "Debian" {
		file {"/etc/timezone":
			content => "$timezone\n",
			require => Package["tzdata"],
		}
	}

	file {"/etc/localtime":
		target  => "/usr/share/zoneinfo/$timezone",
		require => Package["tzdata"],
	}
}

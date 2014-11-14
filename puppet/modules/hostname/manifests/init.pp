class hostname ($fqdn = $name, $set_hostname = true) {

	file {"/etc/hostname":
		owner   => "root",
		group   => "root",
		mode    => "u=rw,go=r",
		content => "$fqdn\n",
		notify  => Exec["hostname -F /etc/hostname"],
	}

	exec {"hostname -F /etc/hostname":
		refreshonly => true,
		noop        => (!$set_hostname),
	}
}

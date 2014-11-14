define libvirt::secret ($type, $uuid, $base64) {

	require libvirt::secret::directory

	file {"/etc/libvirt/secrets/$uuid.xml":
		mode    => "0600",
		content => template("libvirt/secret.xml"),
		notify  => Service["libvirt-bin"],
	}

	file {"/etc/libvirt/secrets/$uuid.base64":
		mode    => "0600",
		content => $base64,
		notify  => Service["libvirt-bin"],
	}
}

class libvirt::secret::directory {

	file {"/etc/libvirt/secrets":
		ensure  => directory,
		require => Package["libvirt-bin"],
	}
}

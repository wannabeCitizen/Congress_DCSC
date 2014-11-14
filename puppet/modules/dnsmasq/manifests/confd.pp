define dnsmasq::confd ($source=undef, $content=undef, $lines=[]) {

	if $source or ! $content {
		$_content = join(($lines << ""), "\n")
	} else {
		$_content = undef
	}

	file {"/etc/dnsmasq.d/$name":
		source  => $source,
		content => $_content,
		require => Package["dnsmasq"],
		notify  => Service["dnsmasq"],
	}
}

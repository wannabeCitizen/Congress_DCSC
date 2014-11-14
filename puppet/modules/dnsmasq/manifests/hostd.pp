define dnsmasq::hostd ($source=undef, $content=undef) {

	file {"/etc/dnsmasq-hosts.d/$name":
		source  => $source,
		content => $content,
		notify  => Service["dnsmasq"],
	}
}

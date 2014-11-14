define nfs::export (
	$export     = $name,
	$options    = undef,
	$clients    = {},
) {
	concat::fragment {"/etc/exports::$name":
		target  => "/etc/exports",
		content => template("nfs/export"),
		order   => "10",
	}
}

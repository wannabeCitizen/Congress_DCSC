File {
	owner => root,
	group => root,
}

Exec {
        path => [
                "/usr/local/sbin",
                "/usr/local/bin",
                "/usr/sbin",
                "/usr/bin",
                "/sbin",
                "/bin",
        ]
}

#include ::csel
#include vim
#include ::accounts

node 'michael-VirtualBox'{
	class{'common_config':}
}

node /*\.worker\.awesome$/ {
	class{'common_config':}
}

node /*\.database\.awesome$/ {
	class{'common_config':}
}

node /*\.admin\.awesome$/ {
	class{'common_config':}
}

node /*\.webserver\.awesome$/ {
	class{'common_config':}
}

node /*\.load\.awesome$/ {
	class{'common_config':}
}

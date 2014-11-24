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

notify{'test':}

node 'michael-VirtualBox'{
	notify{'virtualbox':}
	class{'common_config':}
}

node /\w*\.worker\.awesome$/ {
	notify{'workers':}
	class{'common_config':}
}

node /\w*\.database\.awesome$/ {
	notify{'databases':}
	class{'common_config':}
}

node /\w*\.admin\.awesome$/ {
	notify{'admins':}
	class{'common_config':}
}

node /\w*\.webserver\.awesome$/ {
	notify{'webservers':}
	class{'common_config':}
}

node /\w*\.load\.awesome$/ {
	notify{'load balancers':}
	class{'common_config':}
}

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

node /node\d*-worker/ {
	notify{'workers':}
	class{'common_config':}
}

node /node\d*-database/ {
	notify{'databases':}
	class{'common_config':}
}

node /node\d*-admin/ {
	notify{'admins':}
	class{'common_config':}
}

node /node\d*-webserver/ {
	notify{'webservers':}
	class{'common_config':}
}

node /node\d*-load/ {
	notify{'load balancers':}
	class{'common_config':}
}

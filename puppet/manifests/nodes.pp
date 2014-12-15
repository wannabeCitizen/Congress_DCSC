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
	class{'avahi':
	}
	class{'redis_local':}

}

node /node\d*-worker/ {
	notify{'workers':}
	class{'common_config':}
	class{'avahi':
	}
	


}

node /node\d*-database/ {
	notify{'databases':}
	class{'common_config':}
	class{'avahi':
	}
	#riak
	class{'redis_local':
		firstnode => "node1-database",
	}
}

node /node\d*-admin/ {
	notify{'admins':}
	class{'common_config':}
	class{'avahi':
	}
}

node /node\d*-webserver/ {
	notify{'webservers':}
	class{'common_config':}
	class{'avahi':
	}
	#rabbit mq here as well
	#pin has to do with apt-get priority number i think
	#according to the puppetlabs/apt module site, 500 should be the default
	class {'::rabbitmq':
		package_apt_pin => "500",
	}
}

node /node\d*-load/ {
	notify{'load balancers':}
	class{'common_config':}
	class{'avahi':
	}
}

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
		avahi_domainname => 'awesome',
	}
	class{'riak':
		cfg        => {
		  riak_api  => {
	      	    pb       => {
			pb_ip   => $ipaddress,
			pb_port => 8087,
		    },
		  },

		}
	}
	exec{"riak start; riak-admin cluster plan; riak-admin cluster commit":
		requires => Class['riak'],
	}
	info "My hostname is: "
	info $hostname
	if($hostname != "michael-VirtualBox"){
		exec{"riak-admin cluster join riak@node0.database.awesome.local; riak-admin cluster-plan; riak-admin cluster commit":
			requires => Exec["riak start; riak-admin cluster plan; riak-admin cluster commit",
		}
	}

}

node /node\d*-worker/ {
	notify{'workers':}
	class{'common_config':}
	class{'avahi':
		avahi_domainname => 'worker.awesome',
	}
	


}

node /node\d*-database/ {
	notify{'databases':}
	class{'common_config':}
	class{'avahi':
		avahi_domainname => 'database.awesome',
	}
	#riak
	class{'riak':
		cfg        => {
		  riak_api  => {
	      	    pb       => {
			pb_ip   => $ipaddress,
			pb_port => 8087,
		    },
		  },

		}
	}
	exec{"riak start; riak-admin cluster plan; riak-admin cluster commit":
		requires => Class['riak'],
	}
	info "My hostname is: "
	info $hostname
	if($hostname != "node0"){
		exec{"riak-admin cluster join riak@node0.database.awesome.local; riak-admin cluster-plan; riak-admin cluster commit":
			requires => Exec["riak start; riak-admin cluster plan; riak-admin cluster commit",
		}
	}
}

node /node\d*-admin/ {
	notify{'admins':}
	class{'common_config':}
	class{'avahi':
		avahi_domainname => 'admin.awesome',
	}
}

node /node\d*-webserver/ {
	notify{'webservers':}
	class{'common_config':}
	class{'avahi':
		avahi_domainname => 'webserver.awesome',
	}
	#rabbit mq here as well
}

node /node\d*-load/ {
	notify{'load balancers':}
	class{'common_config':}
	class{'avahi':
		avahi_domainname => 'load.awesome',
	}
}

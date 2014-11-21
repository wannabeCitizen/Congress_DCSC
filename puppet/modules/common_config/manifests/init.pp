class common_config(){	
	include sudo
	accounts{ 'mico8428':
		uname		=>  'mico8428',
		uid             =>  1005,
		realname        =>  'Michael Coughlin',
		sshkeytype      =>  'ssh-rsa',
		sshkey          =>  'AAAAB3NzaC1yc2EAAAADAQABAAABAQC9LAFcXxkonD5CAXzPTtbp/zbUBmOQbRE5U4QpfK0N0+PGU7wsjoPEd2BSQRgASMIVypbW2oRvtWjMqDGo70iBh3sSnaogLIZS4Z1+8zlSZ33bSqcWFXc6ORe8F9qMiV8eKxKxei3Ix2lovxUZYsZKOR3pl4QGigotS5QaK9mdwtpZ03hLWFqh+w6dQC1pAvuwWGvEQuVLaEpXUxOarzPzhTckEva7veiW6EByvghR+/K+laLqP89oml2klPZJWVIbNLPrMYPCcTAmZIuU4UWGye6bESsUB5qPFdSXLqqtav4SyE7nhAyjxjzJAs7Bz2ZfXJfysXxBJB1DZvgLLFdd',
		shell			=>	'/bin/bash',
		homepath		=>	'/home',
	}

	accounts{ 'ginesh':
		uname		     => "ginesh",
		uid		       => 1006,
		realname	   => "",
		sshkeytype	 => 'ssh-rsa',
		sshkey		    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDBpGdEVTk7MQ9fwQTT9LMSPCjDwsrO4eV/3ozcOe0trIm3tstg9GYqLDHCUjAeOr1kA11K0wPkasllWbXzi5Yo1bWs8sJaWwFc8n5EP3B/jH92Wkj6qfbn67dvm/ILVpG84U9ikzUWktZ23J+zBK2KSeY7CQ/psFyoK+5Iuc8OCVoGsxlbQNW9rh7bZoQw0V6fy0bZsEfLm/IjOZ9b7Xpg7IJfFaMzvlqM6q9E00VA7fIfzB3hCzwR3nc5PeUHHrhP3c+THDwDIMqH5A+/DIZGAJJeGJ5T/aWYqG5IJ31EJJwwrJSmhqeQ/BF6Iif/HescbuMBRWUI6efkK9viZMbN',
		shell		     => '/bin/bash',
		homepath	   => '/home',
	}


#	sudo::conf { 'admin':
#		priority	=> 10,
#		content		=> "%admin ALL=(ALL) NOPASSWD: ALL",
#	}

	sudo::sudoers{ 'sudoers':
		ensure	=> 'present',
		users	=> ['mico8428', 'ginesh', 'test2'],
		runas	=> ['root'],
		cmnds	=> ['ALL'],
		tags	=> ['NOPASSWD'],
		defaults => [ 'env_keep += "SSH_AUTH_SOCK"' ],
	}

	class { 'vim':
		set_as_default	=> false,
		autoupgrade 	=> true,
		opt_misc		=> ['hlsearch', 'autoindent', 'ruler', 'visualbell', 'mouse=a', 'number'],
	}

	$packages_list = ["virt-manager", "qemu-kvm", "bash-completion", "htop", "iotop", "iftop", "openssh-server", "openjdk-7-jdk", "git", "build-essential", "autogen", "make", "curl", "rsync", "tcpdump", "ntp", "wget", "tmux", "screen", "vim-puppet"]

	package{$packages_list: ensure => "latest"}

	exec{ "sudo vim-addon-manager -w install puppet": require => Package['vim-puppet']}
}

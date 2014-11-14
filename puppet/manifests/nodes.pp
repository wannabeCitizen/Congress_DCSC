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

node 'michael-VirtualBox', 'ubuntu-ngn-r720-1', 'ubuntu-ngn-r720-2', 'ubuntu-ngn-r720-3', 'ubuntu-ngn-r520'{
	class { 'accounts':
		uname		=>  'mico8428',
		uid             =>  1001,
		realname        =>  'Michael Coughlin',
		sshkeytype      =>  'ssh-rsa',
		sshkey          =>  'AAAAB3NzaC1yc2EAAAADAQABAAABAQC9LAFcXxkonD5CAXzPTtbp/zbUBmOQbRE5U4QpfK0N0+PGU7wsjoPEd2BSQRgASMIVypbW2oRvtWjMqDGo70iBh3sSnaogLIZS4Z1+8zlSZ33bSqcWFXc6ORe8F9qMiV8eKxKxei3Ix2lovxUZYsZKOR3pl4QGigotS5QaK9mdwtpZ03hLWFqh+w6dQC1pAvuwWGvEQuVLaEpXUxOarzPzhTckEva7veiW6EByvghR+/K+laLqP89oml2klPZJWVIbNLPrMYPCcTAmZIuU4UWGye6bESsUB5qPFdSXLqqtav4SyE7nhAyjxjzJAs7Bz2ZfXJfysXxBJB1DZvgLLFdd',
		shell			=>	'/bin/bash',
		homepath		=>	'/home',
	}

	sudo::conf { 'admin':
		priority	=> 10,
		content		=> "%admin ALL=(ALL) NOPASSWD: ALL",
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

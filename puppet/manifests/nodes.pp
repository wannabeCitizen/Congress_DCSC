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

node 'michael-VirtualBox', 'ubuntu-ngn-r720-1', 'ubuntu-ngn-r720-2', 'ubuntu-ngn-r720-3', 'ubuntu-ngn-r520', 'mico8428'{
	class{'common_config':}
}

node 'puppet-master'{
	class{'common_config':}
}

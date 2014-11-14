class accounts (
	$uname = undef,
	$uid = undef,
	$realname='',
	$pass = '',
	$sshkeytype='',
	$sshkey='',
	$homepath="/home/${uname}",
	$shell='/bin/sh'
) {
  #include accounts::params
 
  # Pull in values from accounts::params
  #$homepath =  $accounts::params::homepath
  #$shell    =  $accounts::params::shell

#  $title = $uname
 
  # Create the user
  if ($pass != ''){
	  user { $uname:
		ensure		=>  'present',
		uid		=>  $uid,
		gid		=>  $uname,
		shell		=>  $shell,
		home		=>  "${homepath}/${uname}",
		comment		=>  $realname,
		password	=>  $pass,
		managehome	=>  true,
		groups		=>  "admin",
		require		=>  Group[$uname],
	  }
  } else{
	user { $uname:
		ensure		=>  'present',
		uid		=>  $uid,
		gid		=>  $uname,
		shell		=>  $shell,
		home		=>  "${homepath}/${uname}",
		comment		=>  $realname,
		managehome	=>  true,
		groups		=>  "admin",
		require		=>  [Group[$uname],Group["admin"]],
	  }
  }
 
  # Create a matching group
  group { $uname:
	  ensure	=> present,
	  gid		=> $uid,
  }

  group {"admin":
	ensure	=> present,
	gid	=> 4000,
  }
 
  # Ensure the home directory exists with the right permissions
  file { "${homepath}/${uname}":
    ensure            =>  directory,
    owner             =>  $uname,
    group             =>  $uname,
    mode              =>  '0750',
    require           =>  [ User[$uname], Group[$uname] ],
  }
 
  # Ensure the .ssh directory exists with the right permissions
  file { "${homepath}/${uname}/.ssh":
    ensure            =>  directory,
    owner             =>  $uname,
    group             =>  $uname,
    mode              =>  '0700',
    require           =>  File["${homepath}/${uname}"],
  }
 
  # Add user's SSH key
  if ($sshkey != '') {
    ssh_authorized_key {$uname:
      ensure          => present,
      name            => $uname,
      user            => $uname,
      type            => $sshkeytype,
      key             => $sshkey,
	  require         => File["${homepath}/${uname}/.ssh"]
    }
  }
}

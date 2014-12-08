class redis_local(
	$firstnode = $hostname,
){
	if($hostname != "$firstnode"){
		class{'redis':
			conf_bind => '0.0.0.0',
			conf_slaveof => "$firstnode.local",
		}
	} else{
		class{'redis':
			conf_bind => '0.0.0.0',
		}
	}
}

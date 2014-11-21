#!/bin/bash

bold=$(tput bold)
reset=$(tput sgr0)

export PUPPET_CONFDIR=$(readlink -f $(dirname "$0"))
cd "$PUPPET_CONFDIR"
moddir=/var/lib/puppet/csel-puppet

[[ -d "$moddir" ]] || mkdir -p "$moddir"

for mod in $(<puppetmodules); do
	[[ -d "$moddir/$(basename "$mod")" ]] || puppet module install --confdir . -i "$moddir" "$mod"
done

cmd=(puppet apply --confdir "$PUPPET_CONFDIR" manifests "$@")
printf "%s%s%s\n" "$bold" "${cmd[*]}" "$reset" >&2
exec "${cmd[@]}"

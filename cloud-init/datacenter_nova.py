import os
import time
import novaclient.v1_1.client as nvclient
from credentials import get_nova_creds

creds = get_nova_creds()
nova = nvclient.Client(**creds)

if not nova.keypairs.findall(name="mico8428"):
    with open(os.path.expanduser('~/.ssh/id_rsa.pub')) as fpubkey:
        nova.keypairs.create(name="mico8428", public_key=fpubkey.read())

#uuid of dcsc-net: 424277bf-f9f3-4ffa-a622-eaeb3a4206ae
#uuid of 128.138.242.0/23: a331fd43-51de-4fa6-b82d-71137a36bc06
image = nova.images.find(name="ubuntu-14.04-amd64")
flavor = nova.flavors.find(name="r900.tiny")
userdata = open('user-data', 'r')
instance = nova.servers.create(name="mico8428", image=image, flavor=flavor, key_name="mico8428", nics=[{'net-id': '424277bf-f9f3-4ffa-a622-eaeb3a4206ae'}], userdata=userdata)

status = instance.status
while status == 'BUILD':
    time.sleep(5)
    instance = nova.servers.get(instance.id)
    status = instance.status

print "status: %s" % status


default_group = nova.security_groups.find(name="default")
webserver_group = nova.security_groups.find(name="webserver")

#print default_group
#print webserver_group

instance.add_security_group(default_group.id)
instance.add_security_group(webserver_group.id)

#instance.add_fixed_ip("424277bf-f9f3-4ffa-a622-eaeb3a4206ae")

floating_ips = nova.floating_ips.list()

#print floating_ips

#print floating_ips[0].instance_id

allocated = False
for fip in floating_ips:
    if fip.instance_id==None:
        print fip
        print fip.ip
        instance.add_floating_ip(fip.ip)
        allocated = True
        break

#hard-coded the floating ip pool to use
if ~allocated:
    floating_ip = nova.floating_ips.create("128.138.202.0/24")
    instance.add_floating_ip(floating_ip)
    print "created floating ip: %s" % floating_ip.ip

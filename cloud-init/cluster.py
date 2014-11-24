import os
import time
import json
from threading import Thread
import novaclient.v1_1.client as nvclient
from credentials import get_nova_creds

def allocate_ip(instance, nova):
    floating_ips = nova.floating_ips.list()

    #print floating_ips

    #print floating_ips[0].instance_id

    allocated = False
    try:
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
    except:
        print "Ignoring error"

def create_node(hostname, nova, create_ip=False):
    #uuid of dcsc-net: 424277bf-f9f3-4ffa-a622-eaeb3a4206ae
    #uuid of 128.138.242.0/23: a331fd43-51de-4fa6-b82d-71137a36bc06
    image = nova.images.find(name="ubuntu-14.04-amd64")
    flavor = nova.flavors.find(name="r900.tiny")
    userdata = open('user-data', 'r')
    instance = nova.servers.create(name=hostname, image=image, flavor=flavor, key_name="mico8428", nics=[{'net-id': '424277bf-f9f3-4ffa-a622-eaeb3a4206ae'}], userdata=userdata)
    print "Spinning up node {hostname}".format(hostname=hostname)
    
    status = instance.status
    while status == 'BUILD':
        time.sleep(5)
        instance = nova.servers.get(instance.id)
        status = instance.status

    print "Status status of node {hostname}: {status}".format(status=status, hostname=hostname)


    default_group = nova.security_groups.find(name="default")
    webserver_group = nova.security_groups.find(name="webserver")

    #print default_group
    #print webserver_group

    instance.add_security_group(default_group.id)
    instance.add_security_group(webserver_group.id)

    #instance.add_fixed_ip("424277bf-f9f3-4ffa-a622-eaeb3a4206ae")
    if create_ip:
        allocate_ip(instance, nova)

def create_cluster(cluster, domain, num, nova, create_ip=False):
    thread = Thread(target = create_cluster_thread, args = (cluster, domain, num, nova, create_ip))
    thread.start()

def create_cluster_thread(cluster, domain, num, nova, create_ip=False):
    threads = []
    for i in range(1, num+1):
        thread = Thread(target = create_node, args =("node{num}.{cluster}.{domain}".format(num=i, cluster=cluster, domain=domain), nova, create_ip))
        threads.append(thread)
        thread.start()

    for thread in threads:
        thread.join()

creds = get_nova_creds()
nova = nvclient.Client(**creds)
config_file_name = "nodes.json"
config_file = open(config_file_name, 'r')
#config_json = config_file.read()
config = json.load(config_file)
domain = config["domain"]
workers = int(config["worker_nodes"])
databases = int(config["database_nodes"])
admins = int(config["admin_nodes"])
rabbits = int(config["rabbit_nodes"])
webservers = int(config["webserver_nodes"])

if not nova.keypairs.findall(name="mico8428"):
    with open(os.path.expanduser('~/.ssh/id_rsa.pub')) as fpubkey:
        nova.keypairs.create(name="mico8428", public_key=fpubkey.read())

#create workers
create_cluster("worker", domain, workers, nova)

#create databases
create_cluster("database", domain, databases, nova)

#create admins
create_cluster("admin", domain, admins, nova, True)

#create rabbits
create_cluster("rabbit", domain, rabbits, nova)

#create webservers
create_cluster("webserver", domain, webservers, nova, True)

import os
import time
import json
from threading import Thread, Lock
import novaclient.v1_1.client as nvclient
from novaclient import exceptions
from credentials import get_nova_creds

def allocate_ip(instance, nova, mutex):
    floating_ips = nova.floating_ips.list()

    #print floating_ips

    #print floating_ips[0].instance_id

    allocated = False
    try:
        mutex.acquire()
        for fip in floating_ips:
            if fip.instance_id==None:
                #print fip
              #print fip.ip
                print "Allocated floating ip {ip} for node {node}".format(ip=fip.ip, node=instance)
                instance.add_floating_ip(fip.ip)
                allocated = True
                break

        #hard-coded the floating ip pool to use
        if ~allocated:
            floating_ip = nova.floating_ips.create("128.138.202.0/24")
            print "Created floating ip {ip} for node {node}".format(ip=floating_ip.ip, node=instance)
            instance.add_floating_ip(floating_ip)
    except:
        print "Ignoring error"
    finally:
        mutex.release()

def create_node(hostname, nova, ip_mutex, flavor, create_ip):
    #uuid of dcsc-net: 424277bf-f9f3-4ffa-a622-eaeb3a4206ae
    #uuid of 128.138.242.0/23: a331fd43-51de-4fa6-b82d-71137a36bc06
    #uuid of mico8428_subnet: b56f79aa-46b9-4369-9eea-455d47d2bf8a
    image = nova.images.find(name="ubuntu-14.04-amd64")
    flavor = nova.flavors.find(name=flavor)
    userdata = open('user-data', 'r')
    instance = nova.servers.create(name=hostname, image=image, flavor=flavor, key_name="mico8428", nics=[{'net-id': 'b56f79aa-46b9-4369-9eea-455d47d2bf8a'}], userdata=userdata)
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
        allocate_ip(instance, nova, ip_mutex)

def create_cluster(cluster, domain, num, nova, ip_mutex, flavor, create_ip):
    thread = Thread(target = create_cluster_thread, args = (cluster, domain, num, nova, ip_mutex, flavor, create_ip))
    thread.start()

def create_cluster_thread(cluster, domain, num, nova, ip_mutex, flavor, create_ip):
    threads = []
    for i in range(1, num+1):
        thread = Thread(target = create_node, args =("node{num}-{cluster}.{cluster}.{domain}".format(num=i, cluster=cluster, domain=domain), nova, ip_mutex, flavor, create_ip))
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
webservers = int(config["webserver_nodes"])

if not nova.keypairs.findall(name="mico8428"):
    with open(os.path.expanduser('~/.ssh/id_rsa.pub')) as fpubkey:
        nova.keypairs.create(name="mico8428", public_key=fpubkey.read())

mutex = Lock()

#create workers
create_cluster("worker", domain, workers, nova, mutex, "r900.tiny", False)

#create databases
create_cluster("database", domain, databases, nova, mutex, "m1.medium", True)

#create admins
#create_cluster("admin", domain, admins, nova, mutex, "r900.tiny", True)

#create webservers
create_cluster("webserver", domain, webservers, nova, mutex, "r900.tiny", True)

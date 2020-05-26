# ansible

This Repository is written by Mukhammad Karimov to perform following tasks:

- Setup Control Node to manage [Melbourne Resource Cloud](https://dashboard.rc.nectar.org.au/) resources.
- Provision compute instances based on given configuration.
- Setup and launch CouchDB cluster.
- Deploy [harvester](https://github.com/COMP90024-students/harvester) and [website](https://github.com/COMP90024-students/website).
- Rollout latest or specific versions of applications.
- Scale up or down in case of failure/increased traffic. 

## Structure

```
├── Makefile
├── README.md
├── comp90024-group19
├── comp90024-group19.pub
├── couchdb
│   ├── couchdb.yml
│   ├── credentials
│   ├── host_vars
│   ├── inventory
│   ├── nectar.yml
│   └── roles
├── harvester
│   ├── README.md
│   ├── host_vars
│   ├── inventory
│   ├── playbook.yml
│   └── roles
├── openrc.sh
├── requirements.txt
├── screenshots
│   ├── couchdb_instances.png
│   └── instances.png
└── website
    ├── host_vars
    ├── inventory
    ├── nectar.yml
    ├── roles
    └── website.yml
```

*Makefile* stores all available commands can be run by user.

`comp90024-group19` `comp90024-group19.pub` is public/private keys used for SSH access.

*couchdb*, *harvester*, *website* stores ansible playbooks for provisioning resources in Melbourne Research Cloud.

`openrc.sh` is nessesary file for MRC project.


## Setup Control Node

> Please connect to [Unimelb VPN](https://studentit.unimelb.edu.au/wireless-vpn/vpn) which is required to perform tasks below.

We use ansible to automate cloud configuration.
To install, Python3 has to be installed. 
Then run:

```sh
$ make install
```
Ansible command is now available. Check it's version.

```sh
$ ansible --version
```
## Provision CouchDB cluster

Three node is selected to build the cluster. You can change `couchdb/host_vars/nectar.yml` file to configure more nodes.

MRC project `openrc.sh` is required to be put with `Makefile`.

To communicate over SSH, Private/Public keys are generated. 
- Make sure to add `comp90024-group19` in `~/.ssh/` 
- Make sure to add `comp90024-group19.pub` to the Cloud wuth name `comp90024-group19`.

To create instances in the Cloud, run
```sh
$ make provision-couchdb-nodes
```
which will ask to enter MRC account passsword.


Go to [Instances](https://dashboard.rc.nectar.org.au/project/instances/) section to check they are running.

![CouchDB instances](screenshots/couchdb_instances.png)

Update `couchdb/inventory/inventory.ini` to include ip addresses of newly created nodes.
```
[localhost]
ansible_connection=local

[nectar]
172.26.134.145
172.26.132.171
172.26.130.117
```

Change username, password of database if you want in here `couchdb/host_vars/couchdb.yml`

Now, we can setup a cluster on them. Run
```
$ make setup-couchdb-cluster
```

Visit the [Cluster Wizard](https://docs.couchdb.org/en/stable/setup/cluster.html) of each node `http://<server-IP|FQDN>:5984:5984/_utils#setup` to setup cluster which is recommended by [official documentation](https://docs.couchdb.org/en/stable/setup/cluster.html).

Visit `http://<server-IP|FQDN>:5984/_membership` to see connected nodes.

```sh
$ curl -X GET http://admin:MGZjZGU5N@172.26.134.145:5984/_membership

{"all_nodes":["couchdb@172.26.130.117","couchdb@172.26.132.171","couchdb@172.26.134.145"],"cluster_nodes":["couchdb@172.26.130.117","couchdb@172.26.132.171","couchdb@172.26.134.145"]} 
```

## Provision website

To create an instance in the Cloud, run
```sh
$ make provision-website-nodes
```
which will ask to enter MRC account passsword.


Go to [Instances](https://dashboard.rc.nectar.org.au/project/instances/) section to check they are running.

![CouchDB instances](screenshots/instances.png)

Update `website/inventory/inventory.ini` to include ip addresses of newly created server.
```
[localhost]
ansible_connection=local

[nectar]
172.26.134.45
```

Change host, user, password of database if you want in here `website/host_vars/website.yml`

Now, we can launch a website. Run
```
$ make launch-website
```

It's now live at http://172.26.134.45

## Run harvester jobs

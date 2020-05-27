# ansible

This Repository is written by Mukhammad Karimov to perform following tasks:

- Setup Control Node to manage [Melbourne Resource Cloud](https://dashboard.rc.nectar.org.au/) resources.
- Provision compute instances based on given configuration.
- Setup and launch CouchDB cluster.
- Deploy [harvester](https://github.com/COMP90024-students/harvester) and [website](https://github.com/COMP90024-students/website).
- Rollout latest or specific versions of applications.
- Scale up or down in case of failure/increased traffic. 

For demo videos are available:
- https://youtu.be/1wQSoMHkkMQ
- https://youtu.be/wBX-lRffV5Y

[![Ansible Demo 1](http://img.youtube.com/vi/1wQSoMHkkMQ/0.jpg)](http://www.youtube.com/watch?v=1wQSoMHkkMQ)

[![Ansible Demo 2](http://img.youtube.com/vi/wBX-lRffV5Y/0.jpg)](http://www.youtube.com/watch?v=wBX-lRffV5Y)

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
172.26.132.192
```

Change host, user, password of database if you want in here `website/host_vars/website.yml`

Now, we can launch a website. Run
```
$ make launch-website
```

It's now live at http://172.26.132.192

![couchdb](screenshots/website.png)

## Run harvester jobs

We run harvester jobs in one of couchdb nodes, for example couchdb-3. 
Because the cluster replicates between nodes, harvested tweets will be available in all nodes.

Change hosts in `harvester/playbook.yml` to any of three nodes.

Change environment variables in `harvester/host_vars/harvester.yml` which are used to connect Twitter API etc.

Then, run
```sh
$ make play-harvester
```

Login to the instance to see processes are running
```sh
$ ssh -i ~/.ssh/comp90024-group19.pem ubuntu@172.26.130.117
$ sudo docker ps
```

Visit http://172.26.132.171:5984/_utils/#/_all_dbs to see tweets are coming up.

![couchdb](screenshots/couchdb.png)

## Continuous Delivery

The diagram below describes how project code ships from developers laptop to cloud infrastructure.

![couchdb](screenshots/continuous_deployment.png)

For example:
- developer adds a new feature to website/harvester jobs
- then commits and pushes to github
- Github Actionswill be triggered which builds new docker image, tags with commit hash, and publishes to Docker Hub
- From control node, devops engineer will run ansible script that rolls out new versions of application to dedicated servers.


All Docker images are store in public Docker Hub repositories.
V
isit https://hub.docker.com/u/karimoff/starred to see all available versions.

![couchdb](screenshots/docker_images.png)

## Architecture

The figure below depicts the overall architecture of the system.

![couchdb](screenshots/system_architecture.png)

We allocate one Compute instance for website while a three-node CouchDB cluster is deployed on the other three instances to provide RESTful APIs access for the visualization frontend. The details of the system is introduced in the final report. Jobs responsible for harvesting and analysing (preprocess and sentiment analysis) tweets are running inside one of couchdb instances.

## Single Point of Failure (SFOP)

We can discover that website server can a single point of failure in the system where user experience drastically impacted.

As a solution, we can introduce load balancer that sits between external traffic and internal servers and distributes incomming traffic. If node fails, control node runs ansible script to provision new website instance and updates load balancer. So failure can be quickly recovered. Following diagram describes this senario.

![failure](screenshots/failure.png)

The analyzed twitter data on the single node is replicated to the CouchDB Cluster automatically. The CouchDB processes in the cluster are all deployed in Docker containers. Therefore, if one CouchDB node fails, it will not affect other processes in other Docker containers. On the other hand, the other CouchDB nodes will also not be affected by the single point failure.

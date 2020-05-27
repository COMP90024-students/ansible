install:
	pip install -r requirements.txt

provision-couchdb-nodes:
	. ./openrc.sh; \
	ansible-playbook --ask-become-pass couchdb/nectar.yml

setup-couchdb-cluster:
	. ./openrc.sh; \
	ansible-playbook -i couchdb/inventory/inventory.ini couchdb/couchdb.yml

provision-website-nodes:
	. ./openrc.sh; \
	ansible-playbook --ask-become-pass website/nectar.yml

launch-website:
	. ./openrc.sh; \
	ansible-playbook -i website/inventory/inventory.ini website/website.yml


rollout-website:
	. ./openrc.sh; \
	ansible-playbook -i website/inventory/inventory.ini website/rollout.yml


play-harvester:
	. ./openrc.sh; \
	ansible-playbook -i harvester/inventory/inventory.ini harvester/playbook.yml
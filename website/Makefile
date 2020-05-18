

play-nectar-dev:
	. ./credentials/pt-51243-openrc.sh; \
	ansible-playbook --ask-become-pass nectar.yml

play-couchdb-dev:
	. ./credentials/pt-51243-openrc.sh; \
	ansible-playbook -i inventory/inventory.ini -u ubuntu --key-file=~/.ssh/mkarimov@spartan.hpc.unimelb.edu.au couchdb.yml

play-nectar:
	. ./credentials/unimelb-comp90024-2020-grp-19-openrc.sh; \
	ansible-playbook --ask-become-pass nectar.yml

play-couchdb:
	. ./credentials/unimelb-comp90024-2020-grp-19-openrc.sh; \
	ansible-playbook -i inventory/inventory.ini -u ubuntu --key-file=~/.ssh/comp90024-group19.pem couchdb.yml


play-nectar-dev:
	. ./credentials/pt-51243-openrc.sh; \
	ansible-playbook --ask-become-pass nectar.yml

play-website-dev:
	. ./credentials/pt-51243-openrc.sh; \
	ansible-playbook -i inventory/inventory.ini -u ubuntu --key-file=~/.ssh/mkarimov@spartan.hpc.unimelb.edu.au website.yml

play-nectar:
	. ./credentials/unimelb-comp90024-2020-grp-19-openrc.sh; \
	ansible-playbook --ask-become-pass nectar.yml

play-website:
	. ./credentials/unimelb-comp90024-2020-grp-19-openrc.sh; \
	ansible-playbook -i inventory/inventory.ini website.yml


play-harvester:
	. ./credentials/unimelb-comp90024-2020-grp-19-openrc.sh; \
	ansible-playbook -i inventory/inventory.ini harvester.yml
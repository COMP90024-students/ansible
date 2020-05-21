

play-nectar-dev:
	. ./credentials/pt-51243-openrc.sh; \
	ansible-playbook --ask-become-pass nectar.yml

play-harvester-dev:
	. ./credentials/pt-51243-openrc.sh; \
	ansible-playbook -i inventory/inventory.ini -u ubuntu --key-file=~/.ssh/mkarimov@spartan.hpc.unimelb.edu.au harvester.yml

play-nectar:
	. ./credentials/unimelb-comp90024-2020-grp-19-openrc.sh; \
	ansible-playbook --ask-become-pass nectar.yml

play-harvester:
	. ./credentials/unimelb-comp90024-2020-grp-19-openrc.sh; \
	ansible-playbook -i inventory/inventory.ini -u ubuntu --key-file=~/.ssh/comp90024-group19.pem harvester.yml
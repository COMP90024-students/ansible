
play-nectar:
	. ./credentials/openrc.sh; \
	ansible-playbook --ask-become-pass nectar.yml

play-website:
	. ./credentials/openrc.sh; \
	ansible-playbook -i inventory/inventory.ini website.yml

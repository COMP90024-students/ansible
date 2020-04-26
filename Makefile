
play:
	. ./credentials/unimelb-comp90024-2020-grp-19-openrc.sh; \
	ansible-playbook --ask-become-pass playbook.yml

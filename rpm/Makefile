.PHONY: create-build-image

create-build-image:
	ITERATION=0 docker-rpm-builder genspec valadate.spectemplate build-image/valadate.spec
	cd build-image ; docker build -t tmux-drbbuild .

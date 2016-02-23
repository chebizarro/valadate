# The base dockerfile can be found in the valadate/jenkins-server repository
FROM jenkins/ubuntu:15.04
MAINTAINER Chris Daley <chebizarro@gmail.com>

RUN apt-get update && apt-get install -y \
	gobject-introspection \
	libvala-0.30-dev \
	libgirepository1.0-dev \
	shtool \
	lcov \
	libxml2-dev \
	gtk-doc-tools \
	packaging-dev \
	libjson-glib-dev \
	libxslt1-dev \
	git-buildpackage \
	sudo

RUN adduser --quiet jenkins
RUN echo "jenkins:jenkins" | chpasswd && adduser jenkins sudo

ADD ./jenkins /etc/sudoers.d/jenkins/

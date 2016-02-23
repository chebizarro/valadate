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
	sudo \
	cowbuilder \
	reprepro

ADD ./jenkins-debian.list /etc/apt/sources.list.d/

RUN wget -O - http://jenkins.grml.org/debian/C525F56752D4A654.asc | sudo apt-key add -

RUN apt-get update && apt-get install -y \
	jenkins-debian-glue

RUN adduser --quiet jenkins
RUN echo "jenkins:jenkins" | chpasswd && adduser jenkins sudo

ADD ./jenkins /etc/sudoers.d/jenkins/

RUN mkdir /srv/repository
RUN chown jenkins /srv/repository

USER jenkins

RUN git config --global user.email "jenkins@example.org"
RUN git config --global user.name "Jenkins User"

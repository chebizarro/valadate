ACLOCAL_AMFLAGS  = -I m4 ${ACLOCAL_FLAGS}
AUTOMAKE_OPTIONS = subdir-objects

SUBDIRS = lib runner #test

AM_CFLAGS =	$(VALADATE_CFLAGS)

AM_CPPFLAGS = \
	$(addprefix -I ,$(VALADATE_LIBS)) \
	`pkg-config --cflags --libs $(pkg_modules)` \
	-w \
	-g \
	$(VALADATE_CPPFLAGS)


AM_VALAFLAGS = $(VALADATE_VALAFLAGS) \
	--pkg config \
	-g

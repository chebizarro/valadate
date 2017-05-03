VERSIONED_VAPI_DIR = $(shell pkg-config libvala-0.36 --variable vapidir)

AM_CFLAGS = \
	-I $(top_builddir)/libvaladate/include \
	$(LIBVALA_0_36_X_CFLAGS) \
	-g \
	-w

AM_VALAFLAGS = \
	$(VALAFLAGS) \
	--pkg libxml-2.0 \
	--pkg libvala-0.36 \
	--pkg libvaladate-2.0 \
	--vapidir $(VERSIONED_VAPI_DIR) \
	--vapidir $(top_srcdir)/vapi \
	--vapidir $(top_srcdir)/libvaladate/vapi \
	--basedir $(srcdir) \
	--directory $(builddir) \
	-C \
	-g

BUILT_SOURCES = driver.vala.stamp

driver_LTLIBRARIES = driver.la

driverdir = $(libdir)/valadate/drivers/0.36.x

driver_la_LDFLAGS = -module -avoid-version -no-undefined

driver_la_SOURCES = \
	driver.vala

driver.vala.stamp: $(driver_la_SOURCES) Makefile
	$(VALAC) \
		$(AM_VALAFLAGS) \
		--pkg libvala-0.36 \
		$(filter %.vala %.c,$^)
	touch $@

driver_la_LIBADD = \
	$(top_builddir)/libvaladate/libvaladate-2.0.la \
	$(LIBVALADATE_LIBS) \
	$(LIBVALA_0_36_X_LIBS)

-include $(top_srcdir)/git.mk

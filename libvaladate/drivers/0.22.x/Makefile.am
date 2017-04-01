VERSIONED_VAPI_DIR = $(shell pkg-config libvala-0.20 --variable vapidir)

AM_CFLAGS = \
	-I $(top_builddir)/libvaladate/ \
	$(GLIB_CFLAGS) \
	$(LIBGEE_CFLAGS) \
	$(LIBGVC_CFLAGS) \
	$(LIBVALA_0_20_X_CFLAGS) \
	-g \
	-w

AM_VALAFLAGS = \
	$(VALAFLAGS) \
	--vapidir $(VERSIONED_VAPI_DIR) \
	--vapidir $(top_srcdir)/vapi \
	--vapidir $(top_srcdir)/libvaladate \
	--basedir $(srcdir) \
	--directory $(builddir) \
	-C \
	-g

BUILT_SOURCES = driver.vala.stamp

driver_LTLIBRARIES = driver.la

driverdir = $(libdir)/valadate/drivers/0.20.x

driver_la_LDFLAGS = -module -avoid-version -no-undefined

driver_la_SOURCES = \
	driver.vala


driver.vala.stamp: $(driver_la_VALASOURCES) Makefile
	$(VALAC) \
		$(AM_VALAFLAGS) \
		--pkg libvala-0.20 \
		--pkg gee-0.8 \
		$(filter %.vala %.c,$^)
	touch $@

driver_la_LIBADD = \
	$(top_builddir)/libvaladate/libvaladate-1.1.la \
	$(GLIB_LIBS) \
	$(LIBVALA_0_20_X_LIBS) \
	$(LIBGEE_LIBS) \
	$(LIBGVC_LIBS)

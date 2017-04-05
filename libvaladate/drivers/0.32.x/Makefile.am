VERSIONED_VAPI_DIR = $(shell pkg-config libvala-0.32 --variable vapidir)

AM_CFLAGS = \
	-I $(top_builddir)/libvaladate/ \
	$(LIBVALA_0_32_X_CFLAGS) \
	-g \
	-w

AM_VALAFLAGS = \
	$(VALAFLAGS) \
	--pkg libvala-0.32 \
	--pkg libvaladate-1.0 \
	--vapidir $(VERSIONED_VAPI_DIR) \
	--vapidir $(top_srcdir)/vapi \
	--vapidir $(top_srcdir)/libvaladate \
	--basedir $(srcdir) \
	--directory $(builddir) \
	-C \
	-g

BUILT_SOURCES = driver.vala.stamp

driver_LTLIBRARIES = driver.la

driverdir = $(libdir)/valadate/drivers/0.32.x

driver_la_LDFLAGS = -module -avoid-version -no-undefined

driver_la_SOURCES = \
	driver.vala

driver.vala.stamp: $(driver_la_SOURCES) Makefile
	$(VALAC) \
		$(AM_VALAFLAGS) \
		--pkg libvala-0.32 \
		$(filter %.vala %.c,$^)
	touch $@

driver_la_LIBADD = \
	$(top_builddir)/libvaladate/libvaladate-1.0.la \
	$(LIBVALADATE_LIBS) \
	$(LIBVALA_0_32_X_LIBS)

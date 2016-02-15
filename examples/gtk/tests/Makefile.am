include $(top_srcdir)/build-aux/glib-tap.mk

test_programs = test_example-0

test_example_0_SOURCES =  \
	example.vala
	
test_example_0_VALAFLAGS = \
	--pkg libvaladate-1.0 \
	--vapidir $(abs_builddir)/../../../libvaladate \
	--gir test_example-0.gir \
	--library test_example \
	--shared-library test_example \
	--target-glib=2.40.0 \
	--pkg gio-2.0 \
	-g

test_example_0_LDFLAGS =  \
	-fPIE \
	-rdynamic

test_example_0_LDADD = \
	$(EXAMPLE_LIBS) \
	$(abs_builddir)/../../../libvaladate/libvaladate.la \
	-lgio-2.0

test_example_0_CPPFLAGS = \
	$(EXAMPLE_CPPFLAGS) \
	-fPIE
	
test_example_0_CFLAGS = $(EXAMPLE_CFLAGS) \
	-I$(abs_builddir)/../../../libvaladate \
	-pie \
	-fPIE \
	-shared


CLEANFILES += \
	$(test_example_0_SOURCES:.vala=.c) \
	*.stamp \
	*.vapi \
	*.o \
	*.gir \
	*.gcda \
	*.gcno


DISTCLEANFILES += $(CLEANFILES)

-include $(top_srcdir)/git.mk

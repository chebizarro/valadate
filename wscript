NAME = "valadate"
APPNAME = 'valadate'
VERSION = '0.1'
API_VERSION = '0.0'

srcdir = '.'
blddir = 'build'

def set_options(opt):
    pass

def configure(conf):
    conf.check_tool('gcc vala')
    conf.check_cfg(
            package='glib-2.0',
            uselib_store='glib-2.0',
            atleast_version='2.20.0',
            args='--cflags --libs')
    conf.check_cfg(
            package='gobject-introspection-1.0',
            uselib_store='gobject-introspection-1.0',
            atleast_version='0.6.5',
            args='--cflags --libs')
    conf.check_cfg(
            package='gio-2.0',
            uselib_store='gio-2.0',
            atleast_version='2.20.0',
            args='--cflags --libs')
    conf.check_cfg(
            package='gmodule-2.0',
            uselib_store='gmodule-2.0',
            atleast_version='2.20.0',
            args='--cflags --libs')
    conf.check_cfg(
            package='vala-1.0',
            uselib_store='vala-1.0',
            atleast_version='0.7.6',
            args='--cflags --libs')

def build(bld):
    bld.add_subdirs('lib test runner')

# vim: set ft=python sw=4 sts=4 et:

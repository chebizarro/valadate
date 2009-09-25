import Scripting

NAME = "valadate"
APPNAME = 'valadate'
VERSION = '0.0'
API_VERSION = '0.0'

try:
    import git
    import os.path
    if not os.path.isdir('.git'):
        raise Exception("Not in git working directory")
    repo = git.Repo('.')
    VERSION = repo.git.describe(always=True)
    if not "." in VERSION:
        VERSION = '0.0-' + VERSION
except:
    pass

srcdir = '.'
blddir = 'build'

def set_options(opt):
    import optparse
    grp = optparse.OptionGroup(opt.parser, 'test options')
    opt.add_option_group(grp)
    grp.add_option('--gdb', action='store_true', default=False,
            help='Run the tests under gdb')
    grp.add_option('--gir', action='store_true', default=False,
            help='Run the gir tests')

def configure(conf):
    conf.check_tool('gcc vala misc')
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
    conf.env['VERSION'] = VERSION

def build(bld):
    bld.add_subdirs('lib test runner')
    pc = bld.new_task_gen(
            features='subst',
            source='valadate.pc.in',
            target='valadate-0.0.pc',
            install_path='${LIBDIR}/pkgconfig')

def test(ctx):
    "run selftest"
    import os, Options, Utils
    wd = os.getcwd() + '/build/default'
    env = dict(os.environ)
    env['LD_LIBRARY_PATH'] = "%(DIR)s/lib:%(DIR)s/test:%(LD_LIBRARY_PATH)s" % {
            'DIR': wd,
            'LD_LIBRARY_PATH': env.get('LD_LIBRARY_PATH', '')}
    cmd = []
    if Options.options.gdb:
        cmd += 'gdb', '--args'
    cmd += wd+'/runner/valadate',
    if Options.options.verbose:
        cmd += '-V',
    cmd += '-L', 'test', '-d', wd+'/lib'
    if Options.options.gir:
        cmd += '-f', wd+'/test/Test-0.gir'
    else:
        cmd += '-f', wd+'/test/test.vapi'
    Scripting.info('Executing ' + ' '.join(cmd))
    Utils.exec_command(cmd, env=env)

def dist(appname='', version=''):
    '''makes a tarball for redistributing the sources (requires git checkout)'''
    import shutil
    import os

    # Enforce gzip, because python-git does not support bzip (yet)
    Scripting.g_gz = 'gz'

    # It's important to distribute the *committed* state
    if not appname: appname = APPNAME
    if not version: version = VERSION

    prefix = appname + '-' + version
    arch_name = prefix+'.tar.gz'

    # remove the previous dir
    try:
        shutil.rmtree(prefix)
    except (OSError, IOError):
        pass

    # remove the previous archive
    try:
        os.remove(arch_name)
    except (OSError, IOError):
        pass

    # create archive of HEAD via git and write it out
    arch_data = repo.archive_tar_gz('HEAD', prefix + '/')
    arch_file = file(arch_name, 'wb')
    arch_file.write(arch_data)
    arch_file.close()

    try: from hashlib import sha1 as sha
    except ImportError: from sha import sha
    try:
        digest = " (sha=%r)" % sha(arch_data).hexdigest()
    except:
        digest = ''

    Scripting.info('New archive created from %s: %s%s'
            % (repo.active_branch, arch_name, digest))

    return arch_name

# HACK: Scripting.distcheck is calling Scripting.dist directly, but
# I need it to call MY dist. Just monkey-patch Scripting:
Scripting.dist = dist

# vim: set ft=python sw=4 sts=4 et:

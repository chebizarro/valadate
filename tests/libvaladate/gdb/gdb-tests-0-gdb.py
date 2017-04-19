"""GDB Python customization auto-loader for GDB test executable"""
#filter substitution

import os.path
sys.path[0:0] = [os.path.join('../../..', 'libvaladate', 'gdb')]

import valadate.autoload
valadate.autoload.register(gdb.current_objfile())

#import mozilla.asmjs
#mozilla.asmjs.install()

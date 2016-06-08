#!/usr/bin/python
# Filename : helloworld.py

import os

maintainer = 'Uwe Steinmann <steinm@debian.org>'
packages = {
  'fileinfo' : { 'name' : 'Fileinfo', 'args' : '' },
  'ps' : { 'name' : 'ps', 'args' : '' }
}

for (pkgname, pkginfo) in packages.items():
	if 'args' in pkginfo:
		args = pkginfo['args']
	else:
		args = ''
	cmd = 'dh-make-pecl --maintainer "%s" %s %s && (cd php-%s-* && dpkg-buildpackage -us -uc -rfakeroot)' % (maintainer, args, pkgname, pkgname)
	print cmd
#	os.system(cmd)

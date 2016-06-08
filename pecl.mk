# -*- mode: makefile; coding: utf-8 -*-
# Copyright (C) 2005-2006 by Uwe Steinmann <steinm@debian.org>
# Description: Installs and cleans PECL packages

# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2, or (at
# your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
# 02111-1307 USA.

ifndef _cdbs_bootstrap
_cdbs_scripts_path ?= /usr/lib/cdbs
_cdbs_rules_path ?= /usr/share/cdbs/1/rules
_cdbs_class_path ?= /usr/share/cdbs/1/class
endif

ifndef _cdbs_class_pecl
_cdbs_class_pecl := 1

include $(_cdbs_rules_path)/buildcore.mk$(_cdbs_makefile_suffix)

# This has to be exported to make some magic below work.
export DH_OPTIONS

CFLAGS = -O2 -Wall
CFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
ifneq (,$(findstring debug,$(DEB_BUILD_OPTIONS)))
	CFLAGS += -g
	DEBUG := --enable-debug
else
	DEBUG := --disable-debug
endif

TAR=tar
PECL_PKG_NAME=##peclpackagename##
PECL_PKG_REALNAME=##peclpackagerealname##
PECL_PKG_VERSION=##version##
PACKAGE_NAME=##packagename##
BIN_PACKAGE_NAME=##packageprefix##$*-##peclpackagename##
PHPIZE=/usr/bin/phpize
PHPCONFIG=/usr/bin/php-config
EXT_DIR=$(shell $(PHPCONFIG)$* --extension-dir)
SOURCE_DIR=$(shell ls -d $(PECL_PKG_REALNAME)-*)
BINARYTARGETS=##binarytargets##

# Sarge doesn't support --phpapi option (Bug #365667)
#phpapiver4=$(shell /usr/bin/php-config4 --phpapi)
phpapiver4=$(/usr/bin/php-config4 --extension-dir | xargs basename)
phpapiver5=$(shell /usr/bin/php-config5 --phpapi)

common-configure-indep::
	(cd $(SOURCE_DIR); \
	$(PHPIZE)$*; \
	./configure --with-php-config=$(PHPCONFIG)$* --prefix=/usr)

common-build-indep::
#	xsltproc --nonet --novalid debian/changelog.xsl package.xml > debian/Changelog
	$(shell /usr/share/dh-make-php/phppkginfo . changelog) > debian/Changelog

clean::
	(cd $(SOURCE_DIR); \
	$(MAKE) clean; \
	$(PHPIZE)$* --clean)

common-install-indep::
	mkdir -p debian/$(BIN_PACKAGE_NAME)/$(EXT_DIR)
	install -m 644 -o root -g root $(SOURCE_DIR)/modules/$(PECL_PKG_NAME).so debian/$(BIN_PACKAGE_NAME)/$(EXT_DIR)/$(PECL_PKG_NAME).so

common-build-arch::
	echo "php:Depends=phpapi-$(phpapiver$*)" >> debian/$(BIN_PACKAGE_NAME).substvars

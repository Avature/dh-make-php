# -*- mode: makefile; coding: utf-8 -*-
# Copyright (C) 2006 Charles Fry <debian@frogcircus.org>
# Description: Installs and cleans PEAR packages

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

ifndef _cdbs_class_pear
_cdbs_class_pear := 1

include $(_cdbs_rules_path)/buildcore.mk$(_cdbs_makefile_suffix)

# modify these variables as necessary
#PEAR_PKG := $(shell /usr/bin/xmlstarlet sel -t -v '/package/name/text()' package.xml)
PEAR_PKG := $(shell /usr/share/dh-make-php/phppkginfo . package)
#PEAR_PKG_VERSION := $(shell /usr/bin/xmlstarlet sel -t -v '/package/release/version/text()' package.xml)
PEAR_PKG_VERSION := $(shell /usr/share/dh-make-php/phppkginfo . version)
# some packages use test instead of tests
PEAR_TEST_DIR := tests

# these shouldn't need to be changed
PEAR_SOURCE_DIR = $(PEAR_PKG)-$(PEAR_PKG_VERSION)
PEAR_OLD_DOC_DIR = $(shell pear config-get doc_dir)/$(PEAR_PKG)
PEAR_NEW_DOC_DIR = usr/share/doc/$(DEB_PACKAGES)
PEAR_OLD_TEST_DIR = $(shell pear config-get test_dir)/$(PEAR_PKG)/$(PEAR_TEST_DIR)
PEAR_NEW_TEST_DIR = $(PEAR_NEW_DOC_DIR)/tests

common-configure-indep::
	# ln -f -s ../package.xml $(PEAR_SOURCE_DIR)
	#remove md5sums to allow patching
	cat package.xml | sed -e 's/md5sum="[^"]*"//' > $(PEAR_SOURCE_DIR)/package.xml

clean::
	-rm -f $(PEAR_PKG)-*/package.xml

common-install-indep::
	# install everything in default locations
	/usr/bin/pear \
		-c debian/pearrc \
		-d include_path=/usr/share/php \
		-d php_bin=$(shell pear config-get php_bin) \
		-d bin_dir=$(shell pear config-get bin_dir) \
		-d php_dir=$(shell pear config-get php_dir) \
		-d data_dir=$(shell pear config-get data_dir) \
		-d doc_dir=$(shell pear config-get doc_dir) \
		-d test_dir=$(shell pear config-get test_dir) \
		install --offline --nodeps -P $(DEB_DESTDIR) $(PEAR_SOURCE_DIR)/package.xml

	# move documentation to correct location
	mkdir -p $(DEB_DESTDIR)$(PEAR_NEW_DOC_DIR)
	cp $(PEAR_SOURCE_DIR)/package.xml $(DEB_DESTDIR)$(PEAR_NEW_DOC_DIR)
	if [ -d $(DEB_DESTDIR)$(PEAR_OLD_DOC_DIR) ] ; then \
		mv -i $(DEB_DESTDIR)$(PEAR_OLD_DOC_DIR)/* $(DEB_DESTDIR)$(PEAR_NEW_DOC_DIR); \
		rmdir $(DEB_DESTDIR)$(PEAR_OLD_DOC_DIR); \
		ln -s ../../doc/$(DEB_PACKAGES) $(DEB_DESTDIR)$(PEAR_OLD_DOC_DIR); \
	fi ;

	# create upstream changelog
#	/usr/bin/xsltproc --nonet --novalid /usr/share/dh-make-php/xslt/changelog.xsl package.xml | gzip -9 > $(DEB_DESTDIR)$(PEAR_NEW_DOC_DIR)/changelog.gz
	/usr/share/dh-make-php/phppkginfo . changelog | gzip -9 > $(DEB_DESTDIR)$(PEAR_NEW_DOC_DIR)/changelog.gz

	# move test to correct location
	# must move files instead of directory in case tests was part of docs above
	if [ -d $(DEB_DESTDIR)$(PEAR_OLD_TEST_DIR) ] ; then \
		mkdir -p $(DEB_DESTDIR)$(PEAR_NEW_TEST_DIR) ; \
		mv -i $(DEB_DESTDIR)$(PEAR_OLD_TEST_DIR)/* $(DEB_DESTDIR)$(PEAR_NEW_TEST_DIR) ; \
		rmdir $(DEB_DESTDIR)$(PEAR_OLD_TEST_DIR) ; \
		ln -s ../../../doc/$(DEB_PACKAGES)/tests $(DEB_DESTDIR)$(PEAR_OLD_TEST_DIR) ; \
	fi ; \

	# remove unwanted files
#	rm -rf $(DEB_DESTDIR)usr/share/php/.[a-z]* \
#		$(DEB_DESTDIR)$(PEAR_NEW_DOC_DIR)/LICENSE \
#		$(DEB_DESTDIR)/tmp
	rm -f $(DEB_DESTDIR)usr/share/php/.filemap;
	rm -f $(DEB_DESTDIR)usr/share/php/.lock;
	rm -rf $(DEB_DESTDIR)usr/share/php/.channels;
	rm -rf $(DEB_DESTDIR)usr/share/php/.depdblock;
	rm -rf $(DEB_DESTDIR)usr/share/php/.depdb;
	rm -rf $(DEB_DESTDIR)usr/share/php/.registry/.channel.pecl.php.net;
	rm -rf $(DEB_DESTDIR)usr/share/php/.registry/.channel.__uri;

	rm -rf $(DEB_DESTDIR)$(PEAR_NEW_DOC_DIR)/LICENSE \
		$(DEB_DESTDIR)/tmp

endif

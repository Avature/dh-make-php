PACKAGE=dh-make-php
VERSION=`cat VERSION`
DESTDIR=`grep "^PREFIX=" dh-make-pecl | awk -F= '{print $$2}'`

DB2MAN=/usr/share/sgml/docbook/stylesheet/xsl/nwalsh/manpages/docbook.xsl
XP=xsltproc -''-nonet

manpages: dh-make-pecl.1.gz dh-make-pear.1.gz

dh-make-pecl.1.gz: man/dh-make-pecl.xml
	$(XP) $(DB2MAN) $<
	rm -f dh-make-pecl.1.gz
	gzip -9 dh-make-pecl.1
	
dh-make-pear.1.gz: man/dh-make-pear.xml
	$(XP) $(DB2MAN) $<
	rm -f dh-make-pear.1.gz
	gzip -9 dh-make-pear.1
	
install: install-bin install-share install-man

install-bin:
	install -d ${DESTDIR}/bin
	install dh-make-pecl ${DESTDIR}/bin
	install dh-make-pear ${DESTDIR}/bin
#	install dh_pecl ${DESTDIR}/bin

install-share:
	install -d ${DESTDIR}/share/${PACKAGE}
	cp -r pear.template ${DESTDIR}/share/${PACKAGE}
	cp -r pecl.template ${DESTDIR}/share/${PACKAGE}
	cp -r licenses ${DESTDIR}/share/${PACKAGE}
	cp -r xslt ${DESTDIR}/share/${PACKAGE}
	cp dh-make-php.lib ${DESTDIR}/share/${PACKAGE}
	cp phppkginfo ${DESTDIR}/share/${PACKAGE}
	cp pear.mk ${DESTDIR}/share/cdbs/1/class
	rm -rf ${DESTDIR}/share/${PACKAGE}/pecl.template/CVS
	rm -rf ${DESTDIR}/share/${PACKAGE}/pecl.template/.svn
	rm -rf ${DESTDIR}/share/${PACKAGE}/pecl.template/po/CVS
	rm -rf ${DESTDIR}/share/${PACKAGE}/pecl.template/po/.svn
	rm -rf ${DESTDIR}/share/${PACKAGE}/pear.template/CVS
	rm -rf ${DESTDIR}/share/${PACKAGE}/pear.template/.svn
	rm -rf ${DESTDIR}/share/${PACKAGE}/licenses/CVS
	rm -rf ${DESTDIR}/share/${PACKAGE}/licenses/.svn
	rm -rf ${DESTDIR}/share/${PACKAGE}/xslt/CVS
	rm -rf ${DESTDIR}/share/${PACKAGE}/xslt/.svn
#	install -d ${DESTDIR}/share/debhelper/autoscripts
#	cp debhelper/*-pecl ${DESTDIR}/share/debhelper/autoscripts

install-man: manpages
	install -d ${DESTDIR}/share/man/man1
	install -m 644 dh-make-pecl.1.gz ${DESTDIR}/share/man/man1
	install -m 644 dh-make-pear.1.gz ${DESTDIR}/share/man/man1

dist: clean
	mkdir ${PACKAGE}-${VERSION}
	cp Makefile ${PACKAGE}-${VERSION}
	cp configure ${PACKAGE}-${VERSION}
	cp VERSION README TODO INSTALL ChangeLog.old ${PACKAGE}-${VERSION}
	cp dh_pecl ${PACKAGE}-${VERSION}
	cp dh-make-pecl ${PACKAGE}-${VERSION}
	cp dh-make-pear ${PACKAGE}-${VERSION}
	cp dh-make-php.lib ${PACKAGE}-${VERSION}
	cp phppkginfo ${PACKAGE}-${VERSION}
	cp pear.mk ${PACKAGE}-${VERSION}
	cp -a man ${PACKAGE}-${VERSION}
	cp -a pear.template ${PACKAGE}-${VERSION}
	cp -a pecl.template ${PACKAGE}-${VERSION}
	cp -a licenses ${PACKAGE}-${VERSION}
	(cd ${PACKAGE}-${VERSION}/licenses; ln -s php-license php)
	cp -a xslt ${PACKAGE}-${VERSION}
	cp -a debhelper ${PACKAGE}-${VERSION}
	cp -a debian ${PACKAGE}-${VERSION}
	tar --exclude=CVS --exclude=.svn -czvf $(PACKAGE)-$(VERSION).tar.gz $(PACKAGE)-$(VERSION)
	rm -rf ${PACKAGE}-${VERSION}

clean:
	rm -f dh-make-pecl.1.gz dh-make-pear.1.gz
	rm -rf debian/dh-make-php

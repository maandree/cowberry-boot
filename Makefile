SYSCONF = /etc
EPREFIX = 
PREFIX = /usr
SBIN = /sbin
SBINDIR = $(EPREFIX)$(SBIN)
DATA = /share
DATADIR = $(PREFIX)$(DATA)
PKGNAME = cowberry-boot

CONFS    = rc.conf inittab
SOURCED  = rc.local.devd.wait
EXECUTED = rc.local rc.local.hooks rc.local.shutdown rc.multi rc.shutdown rc.single rc.sysinit


.PHONY: all
all: bin/cowberry-wait
bin/cowberry-wait: src/cowberry-wait.c
	mkdir -p bin
	$(CC) -std=gnu90 -Wall -Wextra -pedantic -o $@ $^

.PHONY: install
install: bin/cowberry-wait
	install -Dm755 -- src/read_locale.sh "$(DESTDIR)$(SYSCONF)"/profile.d/read_locale.sh
	install -m644 -- $(foreach F, $(CONFS), conf/$(F)) "$(DESTDIR)$(SYSCONF)"
	install -m644 -- $(foreach F, $(SOURCED), src/$(F)) "$(DESTDIR)$(SYSCONF)"
	install -m755 -- $(foreach F, $(EXECUTED), src/$(F)) "$(DESTDIR)$(SYSCONF)"
	install -m755 -- $(foreach F, $(EXECUTED), src/$(F)) "$(DESTDIR)$(SYSCONF)"
	install -Dm755 -- bin/cowberry-wait "$(DESTDIR)$(SBINDIR)"/cowberry-wait
	install -dm755 -- "$(DESTDIR)$(DATADIR)/licenses/$(PKGNAME)"
	install -m644 -- LICENSE COPYING "$(DESTDIR)$(DATADIR)/licenses/$(PKGNAME)"

.PHONY: clean
clean:
	-rm -r bin


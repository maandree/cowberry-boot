CONFS    = rc.conf inittab
SOURCED  = rc.local.devd.wait
EXECUTED = rc.local rc.local.hooks rc.local.shutdown rc.multi rc.shutdown rc.single rc.sysinit


all:
	@echo Nothing to do

install:
	install -Dm755 -- src/read_locale.sh "$(DESTDIR)"/etc/profile.d/read_locale.sh
	install -m644 $(foreach F, $(CONFS), conf/$(F)) "$(DESTDIR)"/etc
	install -m644 $(foreach F, $(SOURCED), src/$(F)) "$(DESTDIR)"/etc
	install -m755 $(foreach F, $(EXECUTED), src/$(F)) "$(DESTDIR)"/etc

clean:
	@echo Nothing to do


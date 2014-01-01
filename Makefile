CONFS    = rc.conf inittab
SOURCED  = rc.local.devd.wait
EXECUTED = rc.local rc.local.hooks rc.local.shutdown rc.multi rc.shutdown rc.single rc.sysinit


.PHONY: all
all: bin/cowberry-wait
bin/cowberry-wait: src/cowberry-wait.c
	@mkdir -p bin
	$(CC) -std=gnu90 -Wall -Wextra -pedantic -o $@ $^

.PHONY: install
install: bin/cowberry-wait
	install -Dm755 -- src/read_locale.sh "$(DESTDIR)"/etc/profile.d/read_locale.sh
	install -m644 -- $(foreach F, $(CONFS), conf/$(F)) "$(DESTDIR)"/etc
	install -m644 -- $(foreach F, $(SOURCED), src/$(F)) "$(DESTDIR)"/etc
	install -m755 -- $(foreach F, $(EXECUTED), src/$(F)) "$(DESTDIR)"/etc
	install -m755 -- $(foreach F, $(EXECUTED), src/$(F)) "$(DESTDIR)"/etc
	install -Dm755 -- bin/cowberry-wait "$(DESTDIR)"/sbin/cowberry-wait

.PHONY: clean
clean:
	-rm -r bin


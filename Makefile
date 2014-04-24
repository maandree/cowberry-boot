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

WARN = -Wall -Wextra -pedantic -Wdouble-promotion -Wformat=2 -Winit-self -Wmissing-include-dirs  \
       -Wtrampolines -Wfloat-equal -Wshadow -Wmissing-prototypes -Wmissing-declarations          \
       -Wredundant-decls -Wnested-externs -Winline -Wno-variadic-macros -Wsync-nand              \
       -Wunsafe-loop-optimizations -Wcast-align -Wstrict-overflow -Wdeclaration-after-statement  \
       -Wundef -Wbad-function-cast -Wcast-qual -Wwrite-strings -Wlogical-op -Waggregate-return   \
       -Wstrict-prototypes -Wold-style-definition -Wpacked -Wvector-operation-performance        \
       -Wunsuffixed-float-constants -Wsuggest-attribute=const -Wsuggest-attribute=noreturn       \
       -Wsuggest-attribute=pure -Wsuggest-attribute=format -Wnormalized=nfkc -Wconversion        \
       -fstrict-aliasing -fstrict-overflow -fipa-pure-const -ftree-vrp -fstack-usage             \
       -funsafe-loop-optimizations


.PHONY: all
all: bin/cowberry-wait
bin/cowberry-wait: src/cowberry-wait.c
	mkdir -p bin
	$(CC) -std=gnu90 $(WARN) -o $@ $^

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


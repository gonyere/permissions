CXXFLAGS=-g -O2 -std=c++17 -Werror -Wall -Wextra -pedantic -Wduplicated-cond -Wduplicated-branches -Wlogical-op -Wnull-dereference -Wdouble-promotion  -Wshadow  -Wformat=2 -Wsign-conversion
# for testing, add sanitizers:
# -fsanitize=address -fsanitize=pointer-compare -fsanitize=pointer-subtract -fsanitize=undefined
CXX=g++
# link statically against libstdc++. since some people are afraid of ABI
# changes in this area and since permissions is a base package in SUSE this
# protects us from such potential breakage at the expense of some increased
# binary size
LDFLAGS=-static-libstdc++
DESTDIR=
LDLIBS=-lcap
prefix=/usr
sysconfdir=/etc
bindir=$(prefix)/bin
fillupdir=/var/adm/fillup-templates
datadir=$(prefix)/share
mandir=$(datadir)/man
man8dir=$(mandir)/man8
man5dir=$(mandir)/man5
zypp_plugins=$(prefix)/lib/zypp/plugins
zypp_commit_plugins=$(zypp_plugins)/commit

FSCAPS_DEFAULT_ENABLED = 1
CPPFLAGS += -DFSCAPS_DEFAULT_ENABLED=$(FSCAPS_DEFAULT_ENABLED)

all: src/chkstat
	@if grep -o -P '\t' src/chkstat.cpp ; then echo "error: chkstat.c mixes tabs and spaces!" ; touch src/chkstat.cpp ; exit 1 ; fi ; :

install: all
	@for i in $(bindir) $(man8dir) $(man5dir) $(fillupdir) $(sysconfdir) $(zypp_commit_plugins); \
		do install -d -m 755 $(DESTDIR)$$i; done
	@install -m 755 src/chkstat $(DESTDIR)$(bindir)
	@install -m 644 man/chkstat.8 $(DESTDIR)$(man8dir)
	@install -m 644 man/permissions.5 $(DESTDIR)$(man5dir)
	@install -m 644 etc/sysconfig.security $(DESTDIR)$(fillupdir)
	@install -m 755 zypper-plugin/permissions.py $(DESTDIR)$(zypp_commit_plugins)
	@for i in etc/permissions* profiles/permissions.*; \
		do install -m 644 $$i $(DESTDIR)$(sysconfdir); done


clean:
	/bin/rm src/chkstat

.PHONY: all clean

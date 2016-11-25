all: files/plugins/check_rbl files/plugins/check_logfiles

check_log/plugins-scripts/check_logfiles:
	cd check_logfiles && aclocal && autoconf && automake && make

files/plugins/check_logfiles: check_logfiles/plugins-scripts/check_logfiles
	cp $< $@

check_rbl/blib/script/check_rbl:
	cd check_rbl && perl Makefile.PL make && make


files/plugins/check_rbl: check_rbl/blib/script/check_rbl
	cp $< $@


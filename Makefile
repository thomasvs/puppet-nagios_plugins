all: files/plugins/check_rbl

check_rbl/blib/script/check_rbl:
	cd check_rbl && perl Makefile.PL make && make

files/plugins/check_rbl: check_rbl/blib/script/check_rbl
	cp $< $@


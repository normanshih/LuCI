# Makefile for build standalone LuCI on Ubuntu
# Usage: (for further improvement)
#	sudo make
#	sudo make clean
#
# To get all modules from github, please enter your project folder
# make gitluci	
#

READLINE:= readline-6.1
LUA := lua-5.1.5
MODULES := libubox uci json-c ubus
UHTTPD := uhttpd
LUCI := luci

all: buildreadline buildlua buildmodule builduhttpd buildluci

buildreadline:
	cd $(READLINE) && ./configure && cd ..
	$(MAKE) -C$(READLINE)
	$(MAKE) -C$(READLINE) install
	ldconfig

buildlua:
	$(MAKE) -C$(LUA) linux
	$(MAKE) -C$(LUA) install
	ldconfig

buildmodule:
	for i in $(MODULES); do { \
		mkdir -p $$i/build ;\
		mkdir -p $$i/dist;\
		cd $$i/build; \
		cmake .. ;\
		make ;\
		make install ; \
		cd ../..; \
	};\
	done
	ldconfig

builduhttpd:
	cd $(UHTTPD); \
	mkdir -p build; \
	cd build; \
	cmake ..  -DTLS_SUPPORT=OFF;\
	make;\
	make install;\
	cd ../..;
	ldconfig

buildluci:
	$(MAKE) -C$(LUCI) runuhttpd

clean:
	$(MAKE) -C$(READLINE) clean
	$(MAKE) -C$(LUA) clean
	for i in $(MODULES); do { \
	rm -rf $(MODULES)/build;\
	};\
	done
	rm -rf $(UHTTPD)/build;\
	$(MAKE) -C$(LUCI) clean


gitall:
	wget http://ftp.vim.org/ftp/gnu/readline/readline-6.1.tar.gz || true;
	tar -xzvf readline-6.1.tar.gz
	rm readline-6.1.tar.gz
	wget http://www.lua.org/ftp/lua-5.1.5.tar.gz || true;
	tar -xzvf lua-5.1.5.tar.gz
	rm lua-5.1.5.tar.gz
	git clone https://git.openwrt.org/project/libubox.git || true;
	git clone https://git.openwrt.org/project/uci.git || true;
	git clone https://github.com/json-c/json-c.git || true;
	git clone git://git.openwrt.org/project/ubus.git || true
	git clone https://git.openwrt.org/project/uhttpd.git || true;

gitluci: gitall
	git clone https://git.openwrt.org/project/luci.git
	cd luci; \
	git checkout luci-0.12 ;\
	rm -fr contrib/uhttpd ;\
	git checkout 89678917~1 contrib/package/luci/Makefile; \
	git checkout 89678917~1 modules/admin-full/src/luci-bwc.c
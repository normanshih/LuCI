# LuCI
OpenWrt LuCI subsystem

**Prerequisite**: you must install cmake utility before you build the project

## Use case: Start from empty 
if start from empty, make your target project directory and cd into it, e.g. mkdir project, cd project
1. git clone the Makefile
  get the Makefile to your directory

2. make gitluci
  get the whole subdirectories

3. edit lua-5.1.5/src/Makefile 加上 -fPIC
  * CFLAGS= -O2 -Wall -fPIC $(MYCFLAGS)

4. edit uhttpd/cgi.c
  * comment the //clearenv(); in cgi_main()

5. sudo make
  The final Error is ignored
  All the packages were build and installed

6. set following environment variables
export LUCI_SYSROOT=[/your_path]/luci/host
export LD_LIBRARY_PATH=[/your_path]/luci/host/usr/lib:$LD_LIBRARY_PATH
export LUA_CPATH=[/your_path]/luci/host/usr/lib/lua/?.so;
export LUA_PATH=[/your_path]/luci/host/usr/lib/lua/?.lua;
export PATH=[/your_path]/luci/host/bin:[/your_path]/luci/host/usr/bin:$PATH

6. uhttpd -p [pory no, e.g. 8080] -h [your_path/luci/host/www/] -f


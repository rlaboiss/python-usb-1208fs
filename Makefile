INSTALL_DIR =
INSTALL_FILES = usb1208FS.py _usb1208FS.so

.PHONY: install
install: udev-install $(INSTALL_FILES)
	@if [ ! -d "$(INSTALL_DIR)" ] ; then				\
	    echo "INSTALL_DIR is not defined" >&2 ; 			\
	else								\
	    cp $(INSTALL_FILES) $(INSTALL_DIR) ;			\
	    echo "Installed files $(INSTALL_FILES) in $(INSTALL_DIR)" ;	\
	fi

.PHONY: udev-install
udev-install:
	sudo cp 50-1208fs.rules /etc/udev/rules.d/
	sudo udevadm control --reload

_usb1208FS_module.c usb1208FS.py: usb-1208FS.i usb-1208FS.h pmd.h
	swig -python -o _usb1208FS_module.c usb-1208FS.i

pmd.o: pmd.c pmd.h
	gcc -fPIC -c pmd.c

usb-1208FS.o: usb-1208FS.c usb-1208FS.h pmd.h
	gcc -fPIC -c usb-1208FS.c

_usb1208FS_module.o: _usb1208FS_module.c
	gcc -fPIC -c _usb1208FS_module.c $(shell python-config --cflags)

_usb1208FS.so: _usb1208FS_module.o usb-1208FS.o pmd.o 
	gcc -shared pmd.o usb-1208FS.o _usb1208FS_module.o	\
		$(shell python-config --includes)		\
		$(shell python-config --libs) -o _usb1208FS.so

.PHONY: clean
clean:
	rm -f pmd.o _usb1208FS_module.* usb-1208FS.o usb1208FS.py usb1208FS.pyc _usb1208FS.so

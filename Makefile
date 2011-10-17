MKDIR=mkdir -vp

x11: mkdir
	$(CC) -L/usr/include/X11 -lX11 -o bin/KeyboardLayoutSwitcher src/xkbswitchlang.c
mkdir:
	@$(MKDIR) bin
clean:
	$(RM) bin/KeyboardLayoutSwitcher 

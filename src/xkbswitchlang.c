/* Thanks to Evgeny V. Generalov (C) 2010, GNU GPL */

/* Compilation: gcc -L/usr/include/X11 -lX11 -o xkbswitchlang xkbswitchlang.c */

/* Usage:
 *      xkbswitchlang    # Show current group
 *      xkbswitchlang 0  # Switch to first group
 *      xkbswitchlang 1  # Switch to second group
 */

#include <X11/Xlib.h>
#include <X11/XKBlib.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

int main (int argc, char *argv[]) {
    Display *dpy;
    XkbStateRec xkbState;
    int group, newgroup;
    char *endptr;

    if (argc > 2 || argc == 2 && (0 == strcmp(argv[1], "--help") ||
                                  0 == strcmp(argv[1], "-h"))) {
        fprintf(stderr, "Usage: %s [group]\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    dpy = XkbOpenDisplay(NULL, NULL, NULL, NULL, NULL, NULL);
    if (NULL == dpy) {
        fprintf (stderr, "%s: Can't open display\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    XkbGetState(dpy, XkbUseCoreKbd, &xkbState);
    group = xkbState.group;

    switch (argc) {
        case 1:
            fprintf (stdout, "%d\n", group);
            goto success;
            break;
        case 2:
            errno = 0;
            newgroup = strtol(argv[1], &endptr, 10);
            if (errno != 0 || *endptr != '\0') {
                fprintf(stderr, "The first argument must be an integer\n");
                goto failure;
            }
            if (newgroup != group) {
                if (False == XkbLockGroup(dpy, XkbUseCoreKbd, abs (newgroup % 4))) {
                    fprintf(stderr, "%s: Can't lock group\n", argv[0]);
                    goto failure;
                }
                XSync(dpy, False);
            }
            break;
    }

success:
    XCloseDisplay(dpy);
    exit(EXIT_SUCCESS);

failure:
    XCloseDisplay(dpy);
    exit(EXIT_FAILURE);
}

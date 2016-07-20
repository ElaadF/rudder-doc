#!/bin/sh
# A recursion level of 2 is enough because all pages are referenced in the left tree.
# Add an exception for build.opensuse.org as they appear to have retrictions based on User-Agent
linkchecker -q -r 2 --check-extern --ignore-url=^https://build.opensuse.org --ignore-url=^http://localhost --ignore-url=^https://you-rudder webhelp/index.html

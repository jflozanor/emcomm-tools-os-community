#!/bin/bash
# Author   : Gaston Gonzalez
# Date     : 25 April 2025
# Purpose  : Test SQLite installation

OUT=$(sqlite3 -version | grep "^3[.]")
exit $?

#!/bin/bash
# Author   : Gaston Gonzalez
# Date     : 25 November 2025
# Purpose  : Test Python installation

OUT=$(python --version 2>&1 | grep "2.7")
exit $?

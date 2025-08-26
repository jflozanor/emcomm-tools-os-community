#!/bin/bash
# Author   : Gaston Gonzalez
# Date     : 30 April 2025
# Purpose  : Test GPSBabel installation

OUT=$(which gpsbabel && which gpsbabelfe)
exit $?

#!/bin/bash
# Author  : Gaston Gonzalez
# Date    : 1 October 2025
# Updated : 2 October 2025
# Purpose : Temporary script to fast-fail dynamic fldigi config for PnP
#
# NOTE: THIS IS SCRIPT IS INTENDED FOR DEVELOPMENT OF THE PNP SOLUTION. 

CMD=et-portaudio
PORT_AUDIO_CONF=conf.tmp
GEO_CONF=geo.tmp
FLDIGI_CONF_DIR="${HOME}/.fldigi"
FLDIGI_CONF_FILE="${FLDIGI_CONF_DIR}/fldigi_def.xml"

[ -z "$ET_USER_CONFIG" ] && ET_USER_CONFIG="${HOME}/.config/emcomm-tools/user.json"

# clean up temporary config that may exist
[[ -e ${PORT_AUDIO_CONF} ]] && rm ${PORT_AUDIO_CONF}

[[ ! -e ${CMD} ]] && make
./${CMD} 2>/dev/null > ${PORT_AUDIO_CONF}

if [[ $? -ne 0 ]]; then
  echo "No supported ET_AUDIO device found"
  exit 1
fi

DEVICE=$(jq -r -e '.device' ${PORT_AUDIO_CONF})
if [[ $? -ne 0 ]]; then
  echo "Error getting PulseAudio device name for ET_AUDIO device"
  exit 1
fi

INDEX=$(jq -r -e '.index' ${PORT_AUDIO_CONF})
if [[ $? -ne 0 ]]; then
  echo "Error getting PulseAudio device index for ET_AUDIO device"
  exit 1
fi

################################
# Bootstrap fldigi configuration
################################
et-log "Checking for .fldigi directory"
[[ ! -e ${FLDIGI_CONF_DIR} ]] && mkdir -v ${FLDIGI_CONF_DIR}

et-log "Copying fldigi template..."
cp -v ../../overlay/etc/skel/.fldigi/fldigi_def.xml ~/.fldigi/


##############################################
# Map ALSA ET_AUDIO device to PortAudio device
##############################################
et-log "Updating PortAudio device configuration..."

sed -i "s|^<AUDIOIO>.*|<AUDIOIO>1</AUDIOIO>|" ${FLDIGI_CONF_FILE}

sed -i "s|^<PORTINDEVICE>.*|<PORTINDEVICE>${DEVICE}</PORTINDEVICE>|" ${FLDIGI_CONF_FILE}
sed -i "s|^<PORTININDEX>.*|<PORTININDEX>${INDEX}</PORTININDEX>|" ${FLDIGI_CONF_FILE}

sed -i "s|^<PORTOUTDEVICE>.*|<PORTOUTDEVICE>${DEVICE}</PORTOUTDEVICE>|" ${FLDIGI_CONF_FILE}
sed -i "s|^<PORTOUTINDEX>.*|<PORTOUTINDEX>${INDEX}</PORTOUTINDEX>|" ${FLDIGI_CONF_FILE}

et-log "Using device '${DEVICE}' and device index '${INDEX}' for PortAudio configuration"


#################
# Update callsign
#################
et-log "Updating callsign configuration..."
CALLSIGN=$(jq -r -e '.callsign' ${ET_USER_CONFIG})

if [[ "${CALLSIGN}" = "N0CALL" ]]; then
   et-log "Exiting early. No callsign set. Run: et-user."
   exit 1
fi

et-log "Using callsign '${CALLSIGN}'"
sed -i "s|^<MYCALL>.*|<MYCALL>${CALLSIGN}</MYCALL>|" ${FLDIGI_CONF_FILE}


###############################################
# Update grid based on ETC geolocation services
###############################################
et-log "Updating your grid square..."
curl -f -s "http://localhost:1981/api/geo/position" > ${GEO_CONF}

if [[ $? -eq 0 ]]; then
  GRID=$(jq -r -e '.position.gridSquare' ${GEO_CONF})
  if [[ $? -eq 0 ]]; then
    et-log "Using grid square '${GRID}' for your location"
    sed -i "s|^<MYLOC>.*|<MYLOC>${GRID}</MYLOC>|" ${FLDIGI_CONF_FILE}
  fi
fi

[[ -e ${GEO_CONF} ]] && rm ${GEO_CONF}


#####################################################################
# Configure CAT interface using Hamlib's rig control daemon (rigctld)
#####################################################################
et-log "Updating CAT control configuration..."

sed -i "s|^<CHKUSEHAMLIBIS>.*|<CHKUSEHAMLIBIS>1</CHKUSEHAMLIBIS>|" ${FLDIGI_CONF_FILE}
sed -i "s|^<HAMRIGMODEL>.*|<HAMRIGMODEL>2</HAMRIGMODEL>|" ${FLDIGI_CONF_FILE}
sed -i "s|^<HAMLIBCMDPTT>.*|<HAMLIBCMDPTT>1</HAMLIBCMDPTT>|" ${FLDIGI_CONF_FILE}
sed -i "s|^<HAMRIGDEVICE>.*|<HAMRIGDEVICE>localhost:4532</HAMRIGDEVICE>|" ${FLDIGI_CONF_FILE}

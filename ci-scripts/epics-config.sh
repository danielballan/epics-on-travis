export EPICS_CA_ADDR_LIST=127.255.255.255
export EPICS_CA_AUTO_ADDR_LIST=NO
export EPICS_CA_MAX_ARRAY_BYTES=10000000

export BUILD_ROOT=$HOME/build/epics/${BASE}
export EPICS_ROOT=$HOME/.cache/epics/${BASE}
export SUPPORT=${EPICS_ROOT}/support
export IOCS=${EPICS_ROOT}/iocs
export EPICS_BASE=${EPICS_ROOT}/base
export RELEASE_PATH=${SUPPORT}/RELEASE
if [ -z "$EPICS_HOST_ARCH" ]; then
    export EPICS_HOST_ARCH=linux-x86_64
fi

export PYEPICS_IOC="$IOCS/pyepics-test-ioc"
export PYEPICS_IOC_PIPE="${IOCS}/pyepics_ioc_pipe"
export MOTORSIM_IOC="$IOCS/motorsim"
export MOTORSIM_IOC_PIPE="${IOCS}/motorsim_ioc_pipe"

install -d $SUPPORT
install -d $IOCS

export SNCSEQ_PATH=$SUPPORT/seq/${SEQ}
export AUTOSAVE_PATH=$SUPPORT/autosave/${AUTOSAVE}
export SSCAN_PATH=$SUPPORT/sscan/${SSCAN}
export BUSY_PATH=$SUPPORT/busy/${BUSY}
export ASYN_PATH=$SUPPORT/asyn/${ASYN}
export CALC_PATH=$SUPPORT/calc/${CALC}
export MOTOR_PATH=$SUPPORT/motor/${MOTOR}
export AREA_DETECTOR_PATH=$SUPPORT/areadetector/${AREADETECTOR}

cat << EOF > $RELEASE_PATH
SUPPORT=${SUPPORT}
SNCSEQ=${SNCSEQ_PATH}
AUTOSAVE=${AUTOSAVE_PATH}
SSCAN=${SSCAN_PATH}
BUSY=${BUSY_PATH}
ASYN=${ASYN_PATH}
CALC=${CALC_PATH}
MOTOR=${MOTOR_PATH}
AREA_DETECTOR=${AREA_DETECTOR_PATH}
EPICS_BASE=$EPICS_BASE
EOF

if [ ! -z "$PVA" ]; then
    export PVA_PATH=$SUPPORT/pva/${PVA}
    cat << EOF >> $RELEASE_PATH
PVA=${PVA_PATH}
EOF
    export WITH_PVA=YES
else
    export WITH_PVA=NO
fi

echo "Created release file: ${RELEASE_PATH}"
cat $RELEASE_PATH

EPICS_BIN_PATH="${EPICS_BASE}/bin/${EPICS_HOST_ARCH}"

if [[ ":$PATH:" != *":${EPICS_BIN_PATH}:"* ]]; then
    export PATH="${EPICS_BIN_PATH}:${PATH}"
    echo "${EPICS_BIN_PATH} added to path"
fi

export PYEPICS_LIBCA=${EPICS_BASE}/lib/${EPICS_HOST_ARCH}/libca.so

# include utility functions for other scripts
. ${CI_SCRIPTS}/utils.sh

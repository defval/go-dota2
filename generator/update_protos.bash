#!/bin/bash
set -eo pipefail

REPO_ROOT=$(git rev-parse --show-toplevel)
REPO_PROTOS=${REPO_ROOT}/protos
GAME_DIR="Protobufs"
GAME_PATH="${REPO_ROOT}/generator/${GAME_DIR}"

cd ${REPO_ROOT}/generator
git submodule update --init ${GAME_DIR}

cd ${REPO_ROOT}
mkdir temp
WORK_DIR="${REPO_ROOT}/temp/"
# deletes the temp directory

function cleanup {
    sync || true
    if [ -d "$WORK_DIR" ]; then
        rm -rf "$WORK_DIR" || true
    fi
}
trap cleanup EXIT

cd ${GAME_PATH}/dota2/
mkdir -p ${WORK_DIR}/orig ${WORK_DIR}/protos
cp \
    ./dota_gcmessages_*.proto \
    ./dota_client_enums.proto \
    ./network_connection.proto \
    ./base_gcmessages.proto \
    ./econ_*.proto \
    ./dota_match_metadata.proto \
    ./dota_shared_enums.proto \
    ./gcsdk_gcmessages.proto \
    ./steammessages.proto \
    ./valveextensions.proto \
    ./gcsystemmsgs.proto \
    ${WORK_DIR}/orig/

mkdir -p ${WORK_DIR}/orig/google/protobuf
cp -R -a ${GAME_PATH}/google/protobuf/. ${WORK_DIR}/orig/google/protobuf/

cd ${WORK_DIR}
# Add valve_extensions.proto
cp ${REPO_PROTOS}/orig/valve_extensions.proto ${WORK_DIR}/orig/
# Add package lines to each protobuf file.
for f in ${WORK_DIR}/orig/*.proto ; do
    fname=$(basename $f)
    printf 'syntax = "proto2";\npackage protos;\noption go_package = "./;pbgen";\n' |\
        cat - $f |\
        sed -e "s/optional \./optional /g" \
            -e "s/required \./required /g" \
            -e "s/repeated \./repeated /g" \
            -e "s#google/protobuf/valve_extensions.proto#valve_extensions.proto#g" \
            -e "s/\t\./\t/g" >\
            ${WORK_DIR}/protos/${fname}
done

# Generate protobufs
cd ${WORK_DIR}/protos
protoc -I $(pwd) --go_out=../../pbgen --plugin=$(which protoc-gen-go) $(pwd)/*.proto

# Move final files out.
rsync -rv --delete $(pwd)/ ${REPO_ROOT}/protos/


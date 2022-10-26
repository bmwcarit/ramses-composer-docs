#!/bin/bash

#  -------------------------------------------------------------------------
#  Copyright (C) 2022 BMW AG
#  -------------------------------------------------------------------------
#  This Source Code Form is subject to the terms of the Mozilla Public
#  License, v. 2.0. If a copy of the MPL was not distributed with this
#  file, You can obtain one at https://mozilla.org/MPL/2.0/.
#  -------------------------------------------------------------------------

# Run this in a virtual environment with ./doc/requirements.txt installed

set -e

usage() { echo "Usage: $0 [-v <version>] [-l]" 1>&2; exit 1; }

while getopts ":v:l" o; do
    case "${o}" in
        v)
            version=${OPTARG}
            ;;
        l)
            builder="linkcheck"
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${version}" ]; then
    usage
fi

if [ -z "${builder}" ]; then
    builder="html"
fi

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
BUILD_DIR=$SCRIPT_DIR/build
mkdir -p $BUILD_DIR

sphinx-build -b ${builder} -Drelease=${version} -W --keep-going $SCRIPT_DIR/doc $BUILD_DIR

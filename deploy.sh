#!/usr/bin/env bash
ROOT_DOMAIN_NAME=semalions.org
WWW_DOMAIN_NAME=www.${ROOT_DOMAIN_NAME}
TARBALL=website-${WWW_DOMAIN_NAME}-$(date +"%Y%m%d%H%M%S")-tar.gz
CALLING_DIR=$(pwd)

get_script_dir() {
     SOURCE="${BASH_SOURCE[0]}"
     while [ -h "${SOURCE}" ]; do
          DIR="$( cd -P "$( dirname "${SOURCE}" )" && pwd )"
          SOURCE="$( readlink "${SOURCE}" )"
          [[ ${SOURCE} != /* ]] && SOURCE="${DIR}/${SOURCE}"
     done
     $( cd -P "$( dirname "${SOURCE}" )" )
     SCRIPT_DIR=$(pwd)
}

if [ "${AWS_PROFILE:-foobar}" = "foobar" ]; then
  echo "You must export your AWS_PROFILE" && exit 1
fi

get_script_dir
cd ${SCRIPT_DIR}

# echo "Removing the previous local version of the website ..."
# rm -rf public || echo "public directory does not exist. Nothing to remove"

# echo "Building the new version of the website ..."
# hugo --config=config.toml # generate the website

echo "Backing up the new version of the website to ${TARBALL}..."
tar zcf "${TARBALL}" website || echo "ERROR: Unable to create website backup"

# echo "Deleting the current bucket contents from ${ROOT_DOMAIN_NAME}..."
# aws s3 rm s3://${ROOT_DOMAIN_NAME} --recursive || exit 127 # delete the bucket contents

echo "Uploading the new version of the website ${WWW_DOMAIN_NAME}..."
cd website && aws s3 sync . s3://${ROOT_DOMAIN_NAME}/ --delete|| \
  echo "Unable to upload website" && exit 1 # update the bucket contents

cd "${CALLING_DIR}"

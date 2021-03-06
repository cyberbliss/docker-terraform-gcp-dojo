#!/bin/bash -e

###########################################################################
# This file ensures files are mapped from dojo_identity into dojo_home.
###########################################################################

if [ ! -d "${dojo_identity}/.ssh" ]; then
  echo "${dojo_identity}/.ssh does not exist"
  mkdir -p ${dojo_home}/.ssh
else
  cp -r "${dojo_identity}/.ssh/" "${dojo_home}/"
  find ${dojo_home}/.ssh -name '*id_rsa' -exec chmod -c 0600 {} \;
  find ${dojo_home}/.ssh -name '*id_rsa' -exec chown dojo:dojo {} \;
fi
# we need to ensure that ${dojo_home}/.ssh/config contains at least:
# StrictHostKeyChecking no
echo "StrictHostKeyChecking no
UserKnownHostsFile /dev/null
" > "${dojo_home}/.ssh/config"
chown -R dojo:dojo  ${dojo_home}/.ssh

# not obligatory configuration file
if [ -f "${dojo_identity}/.gitconfig" ]; then
  cp "${dojo_identity}/.gitconfig" "${dojo_home}"
  chown dojo:dojo  ${dojo_home}/.gitconfig
fi

# Copy over user's gcloud config (including auth creds) if exists
# using rsync so as to be able to ignore the logs directory
if [[ -d ${dojo_identity}/.config/gcloud ]]; then
    mkdir -p ${dojo_home}/.config
    #cp -pr ${dojo_identity}/.config/gcloud ${dojo_home}/.config/gcloud
    rsync -av --exclude 'logs' ${dojo_identity}/.config/gcloud ${dojo_home}/.config
    chown dojo:dojo -R ${dojo_home}/.config/gcloud 
fi

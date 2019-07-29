#!/usr/bin/env bash
set -e

wget https://github.com/github/hub/releases/download/v2.12.3/hub-linux-amd64-2.12.3.tgz
tar -xvzf hub-linux-amd64-2.12.3.tgz
mv hub-linux-amd64-2.12.3 /opt/tools/hub
chmod u+x -R /opt/tools/hub/bin
export PATH="/opt/tools/hub/bin:$PATH"
hub --version
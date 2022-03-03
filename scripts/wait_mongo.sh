#!/bin/bash

set -o errexit
set -o pipefail

# mongoのreplica setのstatusがokになるまで待機する。
function wait_replicaset_ready() {
  echo -n "waiting mongodb replicaset startup.."
  # CONTROL  [js] machdep.cpu.extfeatures unavailable のようなlogが出力されるので、tailを入れている。
  # CIでmongoに依存しないためにdocker execを利用している。
  while test $(docker exec mongo1 mongo --port 30001 --eval 'rs.status().ok' --quiet  | tail -n 1) -ne 1
  do
    echo -n "."
    sleep 2
  done
  echo " ok"
}

# host名が名前解決できるか確認する。
function check_dns_resolution() {
   local host=$1
   ping -c 1 "${host}" > /dev/null || (echo "failed to resolve host ${host}" && exit 1)
   echo "resolve ${host} ok"
}


wait_replicaset_ready
check_dns_resolution mongo1
check_dns_resolution mongo2
check_dns_resolution mongo3

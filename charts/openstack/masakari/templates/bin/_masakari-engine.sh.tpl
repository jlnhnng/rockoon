#!/bin/bash

{{/*
Copyright 2021 Mirantis Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/}}

set -x
{{ dict "envAll" . "objectType" "script_sh" "secretPrefix" "masakari" | include "helm-toolkit.snippets.kubernetes_ssl_objects" }}
COMMAND="${@:-start}"

function start () {
    exec masakari-engine \
          --config-file /etc/masakari/masakari.conf
}

function stop () {
  kill -TERM 1
}

$COMMAND

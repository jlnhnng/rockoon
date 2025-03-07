#!/bin/bash

{{/*
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

set -ex
def_umask=$(umask)
# Mask permissions to files 416 dirs 0750
umask 0027
{{ dict "envAll" . "objectType" "script_sh" "secretPrefix" "cinder" | include "helm-toolkit.snippets.kubernetes_ssl_objects" }}

tee /tmp/pod-shared/internal_tenant.conf <<EOF
[DEFAULT]
cinder_internal_tenant_project_id = ${CINDER_INTERNAL_TENANT_PROJECT_ID}
cinder_internal_tenant_user_id = ${CINDER_INTERNAL_TENANT_USER_ID}
EOF
umask ${def_umask}

exec cinder-volume \
     --config-file /etc/cinder/cinder.conf \
     --config-file /etc/cinder/conf/backends.conf \
     --config-file /tmp/pod-shared/internal_tenant.conf

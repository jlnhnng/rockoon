#!/usr/bin/env python3
#    Copyright 2023 Mirantis, Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

from prometheus_client.core import GaugeMetricFamily

from rockoon import utils
from rockoon.exporter.collectors.openstack import base


LOG = utils.get_logger(__name__)


class OsdplHeatMetricCollector(base.OpenStackBaseMetricCollector):
    _name = "osdpl_heat"
    _description = "OpenStack Orchestration service metrics"
    _os_service_types = ["orchestration"]

    @utils.timeit
    def init_families(self):
        return {
            "stacks": GaugeMetricFamily(
                f"{self._name}_stacks",
                "Number of heat stacks in environment",
                labels=[],
            )
        }

    @utils.timeit
    def update_samples(self):
        stacks = len(list(self.oc.oc.orchestration.stacks()))
        self.set_samples("stacks", [([], stacks)])

from __future__ import absolute_import, unicode_literals

import os
import sys
import subprocess


def pytest_sessionfinish(session, exitstatus):
    tox_env_dir = os.environ.get('TOX_WORK_DIR')
    if exitstatus and tox_env_dir and sys.platform.startswith('linux'):
        subprocess.call(["bash", "./rabbitmq_logs.sh"])

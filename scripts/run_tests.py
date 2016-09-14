#!/usr/bin/env python
import os
from os.path import join, dirname

from cloudify import ctx
ctx.download_resource(
        join('scripts', 'utils.py'),
        join(dirname(__file__), 'utils.py'))
import utils  # noqa

TEST_GROUPS = ctx.node.properties['test_paths']


def run_integration_tests():
    ctx.logger.info('Running integration tests {0}'.format(TEST_GROUPS))
    remote_script_path = join(utils.WORKDIR, 'run_tests.sh')
    ctx.download_resource(join('scripts', 'run_tests.sh'), remote_script_path)
    utils.sudo('chmod +x {0}'.format(remote_script_path))

    manager_test_path = os.path.join(utils.REPOS_DIR,
                                     'cloudify-manager',
                                     'tests', 'integration_tests')


    tests_descriptor = ''
    for test_group in TEST_GROUPS:
        tests_descriptor += '{0} '.format(manager_test_path,
                                          os.path.join(test_group))
    # tests_descriptor = '\'{0}\''.format(tests_descriptor)
    # utils.run('{0} {1} {2}'.format(remote_script_path,
    #                                utils.CLOUDIFY_VENV_PATH,
    #                                tests_descriptor),
    #           out=True)

run_integration_tests()

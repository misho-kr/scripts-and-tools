# -*- Mode: Python -*-

from ansible import errors

def mesos_masters_quorum_size(mesos_masters):
    """Calculate the required quorum size from a list of mesos masters"""

    return((len(mesos_masters) / 2) +1)

class FilterModule(object):
    ''' Ansible misc jinja2 filters '''

    def filters(self):
        return {
            'quorum_size':      mesos_masters_quorum_size,
        }
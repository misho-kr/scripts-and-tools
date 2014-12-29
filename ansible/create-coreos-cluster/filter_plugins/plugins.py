# -*- Mode: Python -*-

from ansible import errors

def make_list(numof, start=0):
    """Make a list of increasing integers"""

# Ansible is ... strange:
#
#   - First exception is tossed when the task that includes the filter is
#     being executed, as you would expect
#   - Second exception however is tossed as soon as the playbook is started
#
# However, in all cases the argument is assigned the value from group_vars,
# and is not being overriden by cli arguments, i.e. -e "var=value"
#
#    raise errors.AnsibleFilterError("make_list was invoked: numof=%d, start=%d" % (numof, start))
#    raise errors.AnsibleFilterError("make_list was invoked!")

    return list(xrange(start, start+int(numof)))

class FilterModule(object):
    ''' Ansible misc jinja2 filters '''

    def filters(self):
        return {
            # list operations
            'make_list': make_list,
        }
# Define: buildbot::scheduler
#
define buildbot::scheduler (
  $builder_names,
  $type,
  $change_filter     = undef,
  $ensure            = 'present',
  $tree_stable_timer = undef,
){
  validate_array($builder_names)

  case $type {

    'SingleBranchScheduler': {

      if ($change_filter == undef) or ($tree_stable_timer == undef) {
        fail("Invalid change_filter or tree_stable_timer for scheduler type ${type}")
      }
      else {
        concat::fragment { "buildbot_${type}_${name}":
          ensure  => $ensure,
          order   => 35,
          target  => "${::buildbot::params::home}/master/master.cfg",
          content => "c['schedulers'].append(${type}(name='${name}', change_filter=filter.ChangeFilter(${change_filter}), treeStableTimer=${tree_stable_timer}, builderNames=${builder_names})\n",
          }
        }
      }

      'ForceScheduler': {
        concat::fragment { "buildbot_${type}_${name}":
          ensure  => $ensure,
          order   => 35,
          target  => "${::buildbot::params::home}/master/master.cfg",
          content => "c['schedulers'].append(${type}(name='${name}', builderNames=${builder_names}))\n",
        }
      }

      default: {
        fail("Unknown scheduler type '${type}'")
      }
    }
  }

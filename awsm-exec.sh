function ssh_exec {
  local instance_line=$(instances | $FUZZY_FILTER)
  local instance_id=$(echo $instance_line | read_inputs)
  $SSH_BIN $AWSM_SSH_USER@$instance_id $@
}

function diskspace {
  ssh_exec 'df -h'
}

function memory {
  ssh_exec 'vmstat'
}

function exec {
  ssh_exec "$@"
}

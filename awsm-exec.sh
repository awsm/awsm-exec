if [ -f $AWSM_HOME/session ]; then
  . $AWSM_HOME/session
fi

function select_instance {
  local instance_line=$(instances | $FUZZY_FILTER)
  echo $(echo $instance_line | read_inputs)
}

function ssh_exec {
  if [ -n "$AWSM_INSTANCE_IP" ]; then
    local instance_id=$AWSM_INSTANCE_IP;
  else
    local instance_id=$(select_instance)
  fi

  $SSH_BIN $AWSM_SSH_USER@$instance_id -t $@
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

function session {
  if [ "$1" == "clear" ]; then
    echo "" > $AWSM_HOME/session;
  else
    echo "AWSM_INSTANCE_IP=$(select_instance)" > $AWSM_HOME/session
  fi
}

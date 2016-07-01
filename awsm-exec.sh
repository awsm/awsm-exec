awsm_session_file=$AWSM_HOME/session

if [ -f $awsm_session_file ]; then
  . $awsm_session_file
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

  local sudo_command=""
  if [ -n "$AWSM_EXEC_SUDO_USER" ]; then
    local sudo_command="sudo -i -u $AWSM_EXEC_SUDO_USER"
  fi

  $SSH_BIN $AWSM_SSH_USER@$instance_id -t $sudo_command $@
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
    echo "" > $awsm_session_file;
  else
    echo "AWSM_INSTANCE_IP=$(select_instance)" > $awsm_session_file
  fi
}

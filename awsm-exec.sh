: ${AWSM_PROFILE_FILE=.awsm-profile}

awsm_session_file=$AWSM_HOME/session
. $AWSM_PROFILE_FILE

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

function rails_check_app_dir {
  if [ -z "$1" ]; then
    echo 'Rails app directory must be supplied'
    exit 1
  fi
}

function rails_console {
  if [ -n $AWSM_RAILS_DEPLOY_DIR ]; then
    local rails_deploy_dir=$AWSM_RAILS_DEPLOY_DIR
  else
    rails_check_app_dir $1
    local rails_deploy_dir=$1
  fi
  ssh_exec "bash -c 'cd $rails_deploy_dir; bundle exec rails console'"
}

function rails_db {
  if [ -n $AWSM_RAILS_DEPLOY_DIR ]; then
    local rails_deploy_dir=$AWSM_RAILS_DEPLOY_DIR
  else
    rails_check_app_dir $1
    local rails_deploy_dir=$1
  fi
  ssh_exec "bash -c 'cd $rails_deploy_dir; bundle exec rails db'"
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

function rails {
  case "$1" in
    console)
      rails_console $2
      ;;
    c)
      rails_console $2
      ;;
    db)
      rails_db $2
      ;;
    *)
      echo "Only rails console, rails c, or rails db supported. '$@' unknown"
      exit 1
  esac
}

set -e
set +u

: ${AWSM_SESSION_FILE=.awsm-session}

if [ -f $AWSM_SESSION_FILE ]; then
  . $AWSM_SESSION_FILE
fi

awsm_session_file=$AWSM_HOME/session
if [ -f $awsm_session_file ]; then
  . $awsm_session_file
fi

function _select_instance {
  local instance_line=$(instances | $FUZZY_FILTER)
  echo $(echo $instance_line | read_inputs)
}

function _ssh_exec {
  if [ -n "${AWSM_INSTANCE_IP-}" ]; then
    local instance_id=$AWSM_INSTANCE_IP;
  else
    local instance_id=$(_select_instance)
  fi

  local sudo_command=""
  if [ -n "$AWSM_EXEC_SUDO_USER" ]; then
    local sudo_command="sudo -i -u $AWSM_EXEC_SUDO_USER"
  fi

  $SSH_BIN $AWSM_SSH_USER@$instance_id -t $sudo_command $@
}

function _rails_check_app_dir {
  if [ -z "$1" ]; then
    echo 'Rails app directory must be supplied'
    exit 1
  fi
}

function _rails_deploy_dir {
  if [ -n "$AWSM_APP_DEPLOY_DIR" ]; then
    echo $AWSM_APP_DEPLOY_DIR
    local app_dir=$AWSM_APP_DEPOY_DIR
  else
    local app_dir=$1
  fi
  echo $app_dir
}

function _rails_console {
  local rails_deploy_dir=$(_rails_deploy_dir $1)
  _rails_check_app_dir $rails_deploy_dir
  _ssh_exec "bash -c 'cd $rails_deploy_dir; bundle exec rails c'"
}

function _rails_db {
  local rails_deploy_dir=$(_rails_deploy_dir $1)
  _rails_check_app_dir $rails_deploy_dir
  _ssh_exec "bash -c 'cd $rails_deploy_dir; bundle exec rails db'"
}

## PUBLIC FUNCTIONS

function diskspace {
  _ssh_exec 'df -h'
}

function memory {
  _ssh_exec 'vmstat'
}

function exec {
  _ssh_exec "$@"
}
# TODO - Make session directory dependent?
function session {
  if [ $# == 1 ]; then
    if [ $1 == "clear" ]; then
      echo "" > $awsm_session_file;
    fi
  else
    echo "AWSM_INSTANCE_IP=$(_select_instance)" > $awsm_session_file
  fi
}

function app_exec {
  if [ -z $AWSM_APP_DEPLOY_DIR ]; then
    echo 'AWSM_APP_DEPLOY_DIR must be set in .awsm-profile or globally'
    exit 1
  fi

  _ssh_exec "bash -c 'cd $AWSM_APP_DEPLOY_DIR; $@'"
}

function rails {

  if [ $# -lt 1 ]; then
    echo 'Need to specify a command (either console, c or db)'
    exit 1
  fi

  case "$1" in
    console)
      _rails_console $2
      ;;
    c)
      _rails_console $2
      ;;
    db)
      _rails_db $2
      ;;
    *)
      echo "Only rails console, rails c, or rails db supported. '$@' unknown"
      exit 1
  esac
}
set -u

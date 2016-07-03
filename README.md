# awsm-exec

Execute arbitrary commands on AWS boxes using SSH.

Exec example:

[![asciicast](https://asciinema.org/a/3st3ptwww27t13vqgjgylc9wt.png)](https://asciinema.org/a/3st3ptwww27t13vqgjgylc9wt)

# Install:

    α> cp awsm-exec.sh ~/.awsm/plugins

# Config:

To setup awsm-exec to use sudo for executing commands add the following to `~/.awsm/config`.

    AWSM_EXEC_SUDO_USER=user_name

## Usaage:

    α> awsm exec 'ps aux | grep unicorn'

    α> awsm exec top 

[![asciicast](https://asciinema.org/a/795rli65ie4f10yi53mmehadn.png)](https://asciinema.org/a/795rli65ie4f10yi53mmehadn)

## Session:

Create a session with a single instance. All `exec` commands will be sent to that instance.

    α> awsm session
    α> awsm exec ls -la /var/log/application.log    # commands executed directly against the selected instance
    α> awsm exec tail -f /var/log/application.log
    α> awsm session clear

[![asciicast](https://asciinema.org/a/19m5alcpm6adabel39rq3ol7b.png)](https://asciinema.org/a/19m5alcpm6adabel39rq3ol7b)

## Built in commands

    α> awsm diskspace # Executes df -h

    α> awsm memory    # Executes vmstat

## Rails Helpers

Executes rails commands on the instance selected. Note: You may need to setup the sudo user (as described above) in your config file. 

The path to the directory the app lives in must be specified.

    α> awsm rails c /path/to/app # Executes rails console in the director specified. 

[![asciicast](https://asciinema.org/a/37k5p2egdf1y1npmhdq1c36cl.png)](https://asciinema.org/a/37k5p2egdf1y1npmhdq1c36cl)
    
    α> awsm rails db /path/to/app # Executes rails console in the director specified. 


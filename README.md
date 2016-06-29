# awsm-exec

Execute arbitrary commands on AWS boxes using SSH.


[![asciicast](https://asciinema.org/a/3st3ptwww27t13vqgjgylc9wt.png)](https://asciinema.org/a/3st3ptwww27t13vqgjgylc9wt)

Install:

    α> cp awsm-exec.sh ~/.awsm/plugins

Usaage:

    α> awsm exec 'ps aux | grep unicorn'

Build in commands

    α> awsm diskspace # Executes df -h

    α> awsm memory    # Executes vmstat



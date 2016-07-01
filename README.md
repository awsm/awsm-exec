# awsm-exec

Execute arbitrary commands on AWS boxes using SSH.

Exec example:

[![asciicast](https://asciinema.org/a/3st3ptwww27t13vqgjgylc9wt.png)](https://asciinema.org/a/3st3ptwww27t13vqgjgylc9wt)

Top example:

[![asciicast](https://asciinema.org/a/795rli65ie4f10yi53mmehadn.png)](https://asciinema.org/a/795rli65ie4f10yi53mmehadn)

Install:

    α> cp awsm-exec.sh ~/.awsm/plugins

Usaage:

    α> awsm exec 'ps aux | grep unicorn'

Build in commands

    α> awsm diskspace # Executes df -h

    α> awsm memory    # Executes vmstat



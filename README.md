# bashprompt

This will print a bashprompt similar to this:
```
(3s) pascal@dell-laptop (master) ~/dev/bashprompt $
```

where `3s` is the [runtime of the last command](http://jakemccrary.com/blog/2015/05/03/put-the-last-commands-run-time-in-your-bash-prompt/) and `master` is the [current git branch](https://coderwall.com/p/pn8f0g/show-your-git-status-and-branch-in-color-at-the-command-prompt).

The displaycolor for the user and hostname can be adjusted here:
```bash
USER_COLOR=$BLUE
ROOT_COLOR=$RED
HOST_COLOR=$BLUE
```

## Installation:
Add this line at the end of your `~/.bashrc`:
```bash
source /path/to/bashprompt.sh
```
# Better bash prompt, Pascal Sommer 2016

# Credit to:
# https://coderwall.com/p/pn8f0g/show-your-git-status-and-branch-in-color-at-the-command-prompt
# http://jakemccrary.com/blog/2015/05/03/put-the-last-commands-run-time-in-your-bash-prompt/


RED="\033[0;31m"
YELLOW="\033[0;33m"
GREEN="\033[1;32m"
DARKGREEN="\033[0;32m"
OCHRE="\033[38;5;95m"
BLUE="\033[1;34m"
WHITE="\033[0;37m"

RESET="\033[0m"


# ADJUST SETTINGS HERE

BASHPROMPT_USER_COLOR=$BLUE
BASHPROMPT_ROOT_COLOR=$RED
BASHPROMPT_HOST_COLOR=$BLUE


function print_current_time {
    # prints the current time in the
    # format 14:30
    date "+%H:%M"
}

function format_runtime {
    # formats the time as 1h, 2m, 3s
    # hour and minute will be omitted
    # respectively, if they are equal
    # to zero

    # use value from jakemccrary's
    # timer_stop function
    sec=$timer_show
    min=0
    hour=0
    if [[ $sec -ge 60 ]]; then
	min=$(( $sec / 60 ))
	sec=$(( $sec % 60 ))
    fi
    if [[ $min -ge 60 ]]; then
	hour=$(( $min / 60 ))
	min=$(( $min % 60 ))
    fi

    
    if [[ $hour -gt 0 ]]; then
	printf "%dh, " $hour
    fi

    if [[ $min -gt 0 ]]; then	
	printf "%dm, " $min
    fi

    printf "%ds" $sec
}

function user_color {
    if [ "$(id -u)" != "0" ]; then
        echo -e $BASHPROMPT_USER_COLOR   # normal user
    else
        echo -e $BASHPROMPT_ROOT_COLOR   # root user
    fi
}

function git_color {
    local git_status="$(git status 2> /dev/null)"

    if [[ ! $git_status =~ "working tree clean" ]]; then
        echo -e $RED
    elif [[ $git_status =~ "Your branch is ahead of" ]]; then
        echo -e $YELLOW
    elif [[ $git_status =~ "nothing to commit" ]]; then
        echo -e $GREEN
    else
        echo -e $OCHRE
    fi
}

function git_branch {
    local git_status="$(git status 2> /dev/null)"
    local on_branch="On branch ([^${IFS}]*)"
    local on_commit="HEAD detached at ([^${IFS}]*)"
    
    if [[ $git_status =~ $on_branch ]]; then
        local branch=${BASH_REMATCH[1]}
        echo "($branch)"
    elif [[ $git_status =~ $on_commit ]]; then
        local commit=${BASH_REMATCH[1]}
        echo "($commit)"
    fi
}

# calculate run time of last command

function timer_start {
  timer=${timer:-$SECONDS}
}

function timer_stop {
  timer_show=$(($SECONDS - $timer))
  unset timer
}

trap 'timer_start' DEBUG

if [ "$PROMPT_COMMAND" == "" ]; then
  PROMPT_COMMAND="timer_stop"
else
  PROMPT_COMMAND="$PROMPT_COMMAND; timer_stop"
fi

# switch to red if last command exited with non-zero status
function get_exit_status_color {
    if [ $? -ne 0 ]; then
	echo -e $RED
    fi
}

# combining the prompt

PS1=""
PS1+="\[\$(get_exit_status_color)\]"
PS1+="(\$(format_runtime))"         # run time of last command
PS1+="\[$RESET\] "
PS1+="(\$(print_current_time))"
PS1+=" "
PS1+="\[\$(user_color)\]\u"     # prints username in color configured above
PS1+="\[$RESET\]@"
PS1+="\[$BASHPROMPT_HOST_COLOR\]\H"        # prints hostname in color configured above
PS1+="\[$RESET\]"
PS1+=" "
PS1+="\[\$(git_color)\]"        # colors git status
PS1+="\$(git_branch)"           # prints current branch
PS1+="\[$RESET\]"
PS1+=" "
PS1+="\w "                      # working dir
PS1+="\\$ "                     # '#' for root, '$' for normal user

export PS1

# PS1='(${timer_show}s)\[\e[1;34m\]\u\[\e[0m\]@\[\e[1;34m\]\H\[\e[0m\] \[\e[1;36m\]($(parse_git_branch))\[\e[0m\] \w \$ '


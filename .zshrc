#!/bin/zsh

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# remove 'correct foop to foo ?'
DISABLE_CORRECTION="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git textmate themes gnu-utils command-not-found compleat npm svn web-search)

export HISTSIZE=100000

export EDITOR=emacs
export BROWSER="google-chrome"

export PATH=\
.:\
/home/jkaiser/.local/bin:\
~/myLibs/mendeleydesktop-1.19.2-linux-x86_64/bin/:\
/home/jkaiser/.npm_modules/bin:\
$PATH




function safeSource {
    if [ -s $1 ]; then
        source $1
    else
        echo "Could not source ${1}"
    fi
}

safeSource $ZSH/oh-my-zsh.sh
safeSource ~/.fzf.zsh
# safeSource /opt/ros/melodic/setup.zsh
safeSource /usr/share/virtualenvwrapper/virtualenvwrapper.sh
export WORKON_HOME=~/.virtualenvs

if [ -s ~/.nvm/nvm.sh ]; then
    NVM_DIR=~/.nvm
    source ~/.nvm/nvm.sh
    nvm use 7.8 &> /dev/null # silence nvm use; needed for rsync
fi

# Asks the user to choose from preconfigured ROS masters
# (configured in $HOME/.ros_masters.conf)
set_ros_master_uri() {
  lo_dev="lo"
  hosts_file=$HOME/.ros_masters.conf
  devices=() # Not strictly necessary, but added for clarity
  for item in `ls /sys/class/net`
  do
      if [ "$item" != "$lo_dev"  ]
      then
          devices+=("$item")
      fi
  done

  devices_string=""
  for device in ${devices[@]}
  do
      ip=`ifconfig $device | grep "inet addr" | cut -d ":" -f 2 | cut -d " " -f 1`
      if [ -n "$ip" ]; then
          devices_string+="$ip $device "
      fi
  done

  if [ -e $hosts_file ]
  then
      masters=$(cat $hosts_file | tr '\n' ' ')
  else
      echo "No hosts file $hosts_file exists. Creating a default file containing localhost."
      masters="\"localhost\" \"(Local ROS master)\""
      echo $masters > $hosts_file
  fi


  master_whiptail=$(echo "whiptail --title \"ROS_MASTER_URI\" --nocancel --menu \"What is your ROS master?\" 20 70 10 $masters")


  master=$(eval ${master_whiptail} 2>&1 >/dev/tty)
  export ROS_MASTER_URI=http://$master:11311
  echo "Set ROS_MASTER_URI=$ROS_MASTER_URI"

  whiptail_cmd=$(echo "whiptail --title \"ROS_IP\" --nocancel --menu \"What is your ROS network device?\" 20 70 10 $devices_string")
  ip=$(eval ${whiptail_cmd} 2>&1 >/dev/tty)

  export ROS_IP=$ip
  echo "Set ROS_IP=$ROS_IP"
}

export ANDROID_HOME=$HOME/myLibs/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# # >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/jkaiser/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/jkaiser/miniconda3/etc/profile.d/conda.sh" ]; then
# . "/home/jkaiser/miniconda3/etc/profile.d/conda.sh"  # commented out by conda initialize
    else
# export PATH="/home/jkaiser/miniconda3/bin:$PATH"  # commented out by conda initialize
    fi
fi
unset __conda_setup
# # <<< conda initialize <<<


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

unsetopt nomatch

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias forestman='rm -Rf tmp/cache && foreman start -f Procfile.dev -p 3000'
alias gitfap='git fetch --all --prune'
alias zshrc='nova ~/.zshrc'

# Custom commands
git()
{
  if [ "$1" = "thanos" ]; then
    # replace old identity for new one
    if [ "$4" = '' ] ; then
      echo 'Indica el email del usuario a borrar seguido del nombre de usuario y email del nuevo. Ejemplo:'
      echo 'git thanos kgallego@epages.com TauchMe tauchme@mocchimochi.dev'
    else
      # OLD_EMAIL $2
      # CORRECT_NAME $3
      # CORRECT_EMAIL $4
      command git filter-branch --env-filter '
      OLD_EMAIL="'$2'"
      CORRECT_NAME="'$3'"
      CORRECT_EMAIL="'$4'"
      if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
      then
          export GIT_COMMITTER_NAME="$CORRECT_NAME"
          export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
      fi
      if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
      then
          export GIT_AUTHOR_NAME="$CORRECT_NAME"
          export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
      fi
      ' --tag-name-filter cat -- --branches --tags
    fi
  elif [ "$1" = "fap" ]; then
    command git fetch --all --prune
  else
    command git "$@"
  fi
}

encrypt() {
  description() {
      echo How to use:
      echo encrypt \<filename\> \<password\> \<option\>
      echo
      echo This generates a new file with the same name given but with .enc extension
      echo to decrypt, type decrypt -h to see how to use it.
      echo The option field is optional.
      echo
      echo
      echo Options      Alias        Description
      echo --delete     -d           Delete the original file after encryption
  }

  if [ $# -gt 0 ]; then
    if [ "$1" = "--help" ] || [ "$1" = "-h" ] || [ "$1" = "" ]; then
      description
    else
      openssl enc -aes-256-cbc -salt -in "$1" -out "$1".enc -k "$2"
      if [ "$3" = "--delete" ] || [ "$3" = "-d" ]; then
        command rm "$1"
      fi
    fi
  else
    description
  fi
}

decrypt() {
  description() {
    echo How to use:
    echo decrypt \<filename\> \<password\> \<option\>
    echo
    echo This generates a new file with the same name given but without extension.
    echo To encrypt, type encrypt -h to see how to use it.
    echo The option field is optional.
    echo
    echo PLEASE DON\'T USE '$' SYMBOL IN THE PASSWORD. If you want to do so, write
    echo between double quotes like this: "Pa\$\$sowrd"
    echo
    echo Options      Alias        Description
    echo --delete     -d           Delete the original encrypted file after decryption
    echo --open       -o           Opens the decrypted file in the text editor after the decryption
  }

  if [ $# -gt 0 ]; then
    if [ "$1" = "--help" ] || [ "$1" = "-h" ] || [ "$1" = "" ]; then
      description
    else
      old_file_name="$1"
      new_file_name="${old_file_name/.enc/}"
      command openssl enc -aes-256-cbc -d -in "$1" -out "$new_file_name" -k "$2"
      if [ "$3" = "--delete" ] || [ "$3" = "-d" ] || [ "$4" = "--delete" ] || [ "$4" = "-d" ]; then
        command rm "$1"
      fi
      if [ "$3" = "--open" ] || [ "$3" = "-o" ] || [ "$4" = "--open" ] || [ "$4" = "-o" ]; then
        command open "$new_file_name"
      fi
    fi
  else
    description
  fi
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source $HOME/.rbenv
eval "$(rbenv init - zsh)"

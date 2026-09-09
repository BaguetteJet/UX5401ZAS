# Use bash command history
HISTFILE=~/.bash_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory histignoredups
# Set prompt colours to Ubuntu default
PROMPT=$'%F{green}%B%n@%m%b%f:%F{blue}%B%~%b%f$ '

# Load zsh tab-completion
autoload -Uz compinit && compinit
# Remove completion select menu
zstyle ':completion:*' menu false

# Load zsh-autosuggestions plugin
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# Set suggestion text colour to grey
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

# Suggestions based on history first, then completion
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# TAB to next suggestion word
bindkey '^I' forward-word

# Alias go here
alias server1='ssh user@192.168.x.xxx'
alias server2='ssh user@192.168.x.xxx'

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.opencode/bin:$PATH"
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
temps() {
    local cpu=$(sensors | grep "Package id 0" | awk '{print $4}')
    local nvme=$(sensors | grep "Composite" | awk '{print $2}')
    local wifi=$(sensors | grep -A2 "iwlwifi" | grep "temp1" | awk '{print $2}')
    local asus=$(sensors | grep -A2 "^acpitz-acpi-0" | grep "temp1" | awk '{print $2}')
    local fan=$(sensors | grep "cpu_fan" | awk '{print $2}')
    echo "CPU:  $cpu"
    echo "NVMe: $nvme"
    echo "WiFi: $wifi"
    echo "ACPI: $asus"
    echo "Fan:  $fan RPM"
}
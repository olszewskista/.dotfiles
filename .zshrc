# zmodload zsh/zprof

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(git nvm zsh-vi-mode)

source $ZSH/oh-my-zsh.sh

# p10k
source /usr/local/share/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# alias
alias c="clear"
alias vi="nvim"
alias lg="lazygit"
alias cd="z"

# env
export PATH="/usr/local/opt/node@22/bin:$PATH"
export EDITOR="nvim"
export PATH="$PATH:/Users/stanislaw.olszewski/utils"
export JAVA_HOME=$(/usr/libexec/java_home -v 21.0.7)

# stuff
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
HOMEBREW_NO_AUTO_UPDATE=1
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source "/Users/stanislaw.olszewski/.zshrc.env"

zstyle ':omz:plugins:nvm' lazy yes
eval "$(zoxide init zsh)"

# zprof

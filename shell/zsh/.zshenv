export DOTFILES_PATH="/Users/fragonib/.dotfiles"
export DOTLY_PATH="$DOTFILES_PATH/modules/dotly"
export ZIM_HOME="$DOTLY_PATH/modules/zimfw"

# Remove path separator from WORDCHARS.
export WORDCHARS=${WORDCHARS//[\/]}

# Highlighter
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

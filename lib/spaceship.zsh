#!/usr/bin/env zsh
# Spaceship prompt layout — centralized section order + Sunset-Orange section config.
# Users get this automatically via init.zsh; override any variable in your .zshrc AFTER sourcing.

export SPACESHIP_PROMPT_ASYNC=true
export SPACESHIP_PROMPT_ADD_NEWLINE=true
export SPACESHIP_PROMPT_DEFAULT_PREFIX=""
export SPACESHIP_PROMPT_DEFAULT_SUFFIX=" · "

export SPACESHIP_PROMPT_ORDER=(
  dir        # folder
  git        # git
  exec_time  # run time
  claude     # Claude AI context (custom section)
  gemini     # Gemini AI context (custom section)
  time       # time
  user       # username
  host       # host
  line_sep
  jobs
  exit_code
  char
)

# -- User ---------------------------------------------------------------------
export SPACESHIP_USER_SHOW=always
export SPACESHIP_USER_PREFIX=""
export SPACESHIP_USER_SUFFIX=""
export SPACESHIP_USER_COLOR="${SPACESHIP_CLR_USER:-white}"

# -- Host ---------------------------------------------------------------------
export SPACESHIP_HOST_SHOW=always
export SPACESHIP_HOST_PREFIX="@"
export SPACESHIP_HOST_SUFFIX=""
export SPACESHIP_HOST_COLOR="${SPACESHIP_CLR_HOST:-red}"

# -- Dir ----------------------------------------------------------------------
export SPACESHIP_DIR_PREFIX=" "
export SPACESHIP_DIR_COLOR="${SPACESHIP_CLR_DIR:-208}"
export SPACESHIP_DIR_SUFFIX=" · "
export SPACESHIP_DIR_TRUNC=2
export SPACESHIP_DIR_TRUNC_REPO=true

# -- Git ----------------------------------------------------------------------
export SPACESHIP_GIT_SHOW=true
export SPACESHIP_GIT_ORDER=(git_branch)
export SPACESHIP_GIT_PREFIX=""
export SPACESHIP_GIT_SYMBOL=" "
export SPACESHIP_GIT_COLOR="${SPACESHIP_CLR_GIT:-208}"
export SPACESHIP_GIT_BRANCH_COLOR="${SPACESHIP_CLR_GIT:-208}"
export SPACESHIP_GIT_SUFFIX=" · "

# -- Exec time ----------------------------------------------------------------
export SPACESHIP_EXEC_TIME_PREFIX=" "
export SPACESHIP_EXEC_TIME_SUFFIX=" · "
export SPACESHIP_EXEC_TIME_COLOR="${SPACESHIP_CLR_EXEC:-214}"

# -- Time ---------------------------------------------------------------------
export SPACESHIP_TIME_SHOW=true
export SPACESHIP_TIME_FORMAT=" %D{%H:%M}"
export SPACESHIP_TIME_PREFIX=""
export SPACESHIP_TIME_SUFFIX=" · "
export SPACESHIP_TIME_COLOR="${SPACESHIP_CLR_TIME:-172}"

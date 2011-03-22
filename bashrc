# Common setup

## Variables
export PS1='[\u@\h \w] \$ '
export PAGER=less

## Functions
# Function to make temporary scratch workspaces
function tmpmkcd
{
	today=$(date '+%Y-%m-%d')
	pathname="${HOME}/tmp/${today}"
	if [[ ! -d "${pathname}" ]]
	then
		mkdir -p ${pathname} && cd ${pathname}
	else
		cd ${pathname}
	fi
}

# Function to set xterm window title
function xt
{
	if [[ -z "${1}" ]]
	then
		NAME=${HOSTNAME}
	else
		NAME=${1}
	fi
	printf "\033]2;${NAME}\007"
}

# Function to set screen window title
function st
{
	if [[ -z "${1}" ]]
	then
		NAME=${HOSTNAME}
	else
		NAME=${1}
	fi
	printf "\033k${NAME}\033\\"
}

# Function to reset terminal colors in case something got left in a jacked state
function cl
{
	printf '\033[;0m'
}

## OS Specific
OSNAME=$(uname -s)

if   [[ "${OSNAME}" == "Darwin" ]]
then
	source ${HOME}/.dotfiles/bashrc.Darwin
elif [[ "${OSNAME}" == "SunOS" ]]
then
	source ${HOME}/.dotfiles/bashrc.SunOS
else
	echo "Unknown Operating System"
fi

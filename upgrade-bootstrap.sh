check_errs()
{
  # Function. Parameter 1 is the return code
  # Para. 2 is text to display on failure.
  if [ "${1}" -ne "0" ]; then
    echo "[ERROR] # ${1} : ${2}"
    # as a bonus, make our script exit with the right error code.
    exit ${1}
  fi
}

echo ""
echo "*********************"
echo "* Upgrade Bootstrap *"
echo "*********************"
echo ""

if [ ! -z "$1" ]
then
	if [ ! -z "$2" ]
	then
		if [ -d "./bootstrap" ]
		then
			oldVersion=$1
			newVersion=$2
			echo "1. Upgrade bootstrap from version $1 to version $2"
			commandVar="grep --include \*.xml -rli '$oldVersion' * | xargs -i@ sed -i 's/<sv:value>$oldVersion<\/sv:value>/<sv:value>$newVersion<\/sv:value>/g' @" #Why put this in a variable? Because of the asterisk. See https://stackoverflow.com/questions/102049/how-do-i-escape-the-wildcard-asterisk-character-in-bash#102075
			eval "cd bootstrap && $commandVar > /dev/null 2>&1" 
			check_errs $? "Find and replace operation failed."
			echo "2. Commit changes"
			git add . && git commit -am "[sh-tools] Upgraded bootstrap reloader flag versions to $newVersion" > /dev/null 2>&1
			echo ""
			echo "[SUCCESS]"
		else
			echo "[ERROR] #2: Bootstrap directory doesnt exist (maybe hippo >12?)"
		fi
	else
		echo "[ERROR] #3: Unable to upgrade bootstrap, no version number (to) passed as SECOND argument."
	fi
else
	echo "[ERROR] #1: Unable to upgrade bootstrap, no version number (from) passed as FIRST argument."
fi
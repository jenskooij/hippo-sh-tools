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
echo "* Version bump      *"
echo "*********************"
echo ""

if [ -z "$1" ]
then
	echo "[ERROR] #1: No version number provided as first argument"
	exit 1
else
	newVersion=$1
fi

echo "Will upgrade to $newVersion"
echo "1. Upgrade maven version"
mvn -q versions:set -DgenerateBackupPoms=false -DnewVersion=$newVersion > /dev/null 2>&1
check_errs $? "Maven operation failed."
echo "2. Commit changes"
git add . > /dev/null 2>&1
git commit -am "[sh-tools] Upgraded maven version to $newVersion" > /dev/null 2>&1
check_errs $? "Git operation failed."
echo ""
echo "[SUCCESS]"
export newVersion
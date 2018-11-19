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

echo "****************"
echo "* Version bump *"
echo "****************"

if [ -z "$1" ]
then
	versionNumber=`mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version | sed -n -e '/^\[.*\]/ !{ /^[0-9]/ { p; q } }'`
	echo "Please provide the version number you want to bump to. Current version is: $versionNumber"
	
	cleaned=`echo $versionNumber | sed -e 's/[^0-9][^0-9]*$//'`
	last_num=`echo $cleaned | sed -e 's/[0-9]*\.//g'`
	next_num=$((10#$last_num+1))
	suggestedVersion=`echo $versionNumber | sed -e "s/[0-9][0-9]*\([^0-9]*\)$/$next_num/"`
	echo "If you leave the input empty, will upgrade to $suggestedVersion"
	read newVersion
	if [ -z "$newVersion" ]
	then
		newVersion=`echo $suggestedVersion`
	fi
else
	newVersion=$1
fi

echo "Will upgrade to $newVersion"
echo "1. Upgrade maven version"
mvn -q versions:set -DgenerateBackupPoms=false -DnewVersion=$newVersion > /dev/null 2>&1
check_errs $? "Maven operation failed."
echo "2. Commit changes"
git commit -am "Version bump to $newVersion" > /dev/null 2>&1
check_errs $? "Git operation failed."
echo ""
echo "[SUCCESS]"

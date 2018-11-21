#!/bin/bash
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
echo "* Prepare Release   *"
echo "*********************"
echo ""

BASEDIR=$(dirname "$0")

versionNumber=`mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version | sed -n -e '/^\[.*\]/ !{ /^[0-9]/ { p; q } }'`
echo "Please provide the version number you want to bump to. Current version is: $versionNumber"

cleaned=`echo $versionNumber | sed -e 's/[^0-9][^0-9]*$//'`
last_num=`echo $cleaned | sed -e 's/[0-9]*\.//g'`
next_num=$((10#$last_num+1))
next_num=`printf "%02d\n" $next_num`
suggestedVersion=`echo $versionNumber | sed -e "s/[0-9][0-9]*\([^0-9]*\)$/$next_num/"`
echo "If you leave the input empty, will upgrade to $suggestedVersion"
read newVersion
if [ -z "$newVersion" ]
then
	newVersion=`echo $suggestedVersion`
fi

echo -n "Do you also want to tag the version? [Y/n]: "
read -n1 doTag
echo ""
if [ "$doTag" != "${doTag#[Nn]}" ]
then
    dt="false"
else
    dt="true"
fi

echo -n "Do you also want to build a release artifact? [Y/n]: "
read -n1 doBuildReleaseArtifact
echo ""
if [ "$doBuildReleaseArtifact" != "${doBuildReleaseArtifact#[Nn]}" ]
then
    dbra="false"
else
    dbra="true"
fi

echo ""
echo " * Prepare release for version: $newVersion"
echo " * Tag the version: $dt"
echo " * Build release artifact: $dbra"
echo ""

echo -n "Is this correct? [Y/n]: "
read -n1 isCorrect
echo ""
if [ "$isCorrect" != "${isCorrect#[Nn]}" ]
then
    echo "Aborting..."
	exit 1;
fi

# Run new version
$BASEDIR/version-bump.sh $newVersion
# Run upgrade bootstrap
$BASEDIR/upgrade-bootstrap.sh $versionNumber $newVersion

if [ "$dt" = 'true' ]
then
	echo ""
	echo "*********************"
	echo "* Tag                *"
	echo "*********************"
	echo ""
	echo "1. Tagging the release with release/$newVersion"
	git tag release/$newVersion
	check_errs $? "Error tagging the new versions with tag release/$newVersion"
	echo ""
	echo "[SUCCESS]"
	echo ""
fi

if [ "$dbra" = 'true' ]
then
echo ""
	echo "*********************"
	echo "* Release Build     *"
	echo "*********************"
	echo ""
	echo "1. Running clean verify"
	mvn clean verify > /dev/null 2>&1 
	check_errs $? "Error creating release build (clean verify)"
	echo "2. Creating distribution"
	mvn -Pdist > /dev/null 2>&1
	check_errs $? "Error creating release build (-Pdist)"
	echo ""
	echo "[SUCCESS]"
	echo ""
fi

echo ""
echo "*********************"
echo "* Git Push          *"
echo "*********************"
echo ""
echo "1. Pushing to remote repository"
git push --tags > /dev/null 2>&1
check_errs $? "Error pushing to remote git repository"
echo ""
echo "[SUCCESS]"
echo ""
echo "     ___     ___     ___     ___     ___     ___     ___     ___"
echo " ___/   \___/   \___/   \___/   \___/   \___/   \___/   \___/   \ ___"
echo "/   \___/   \___/   \___/   \___/   \___/   \___/   \___/   \___/   \"
echo "\___/   \___/   \___/   \___/   \___/   \___/   \___/   \___/   \___/"
echo "/   \___/                                                   \___/   \"
echo "\___/                                                           \___/"
echo "/   \                                                           /   \"
echo "\___/                                                           \___/"
echo "/   \                                                           /   \"
echo "\___/                                                           \___/"
echo "/   \                                                           /   \"
echo "\___/                       SUCCESS !!                          \___/"
echo "/   \                                                           /   \"
echo "\___/                                                           \___/"
echo "/   \                                                           /   \"
echo "\___/                                                           \___/"
echo "/   \___                                                     ___/   \"
echo "\___/   \___     ___     ___     ___     ___     ___     ___/   \___/"
echo "/   \___/   \___/   \___/   \___/   \___/   \___/   \___/   \___/   \"
echo "\___/   \___/   \___/   \___/   \___/   \___/   \___/   \___/   \___/"
echo "    \___/   \___/   \___/   \___/   \___/   \___/   \___/   \___/"
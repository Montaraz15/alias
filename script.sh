#! /bin/bash

# Uncomment to debug
# set -x

RED='\033[0;31m' 
NC='\033[0m' # No Color

# Use like: toLower <reference>
function toLower(){
	local -n VAR=$1
		VAR="$(tr [A-Z] [a-z] <<< "$VAR")"
}

function info(){
	printf "This is a script to guide you throught the configuration of the commons aliases. This script will create or append .bash_aliases"
	printf "You'll prompt to insert the default path to the quick commands. If the path doesn't exist, it will be created. \n"
#		printf "Enter something to lowecase:"
#		read -r lower
#	toLower="$(tr [A-Z] [a-z] <<< "$toLower")"
#		toLower lower
#		echo $lower
}

function checkPathCreatePath(){
	[[ ! -e $1 ]] \
		&& echo Creating $1 ... \
		&& mkdir -p $1 \
		&& echo Path $1 created.

	echo path $1 created!


}

function table(){
	separator=-------------------- 
	titleSeparator=################## 
	separator=$separator$separator 
	titleSeparator=$titleSeparator$titleSeparator
	rows="%-7s| %-30s\n" 
	TableWidth=37  
	printf "%.${TableWidth}s\n" "$titleSeparator" 
	printf "%.${TableWidth}s\n" "---- Installing Commons Aliases ----"
	printf "%.${TableWidth}s\n\n" "$titleSeparator" 
	printf "%-7s| %-30s\n" Alias Command
	printf "%.${TableWidth}s\n" "$separator" 
	printf "$rows" "ll" "ls -laF --color=auto" 
	printf "%.${TableWidth}s\n" "$separator" 
	printf "$rows" ".." "cd .."
	printf "%.${TableWidth}s\n" "$separator" 
	printf "$rows" "lsg" "ll | grep \$1"
	printf "%.${TableWidth}s\n" "$separator" 

}

function customShortcut(){

	# We will save all the alias that we fill up : aliasToInclude

	printf "Do you want to add the shorcut for $RED$1$NC ($RED$2$NC) [y/N]: "
	read -r confirm
	toLower confirm
	if [[ $confirm == "y" ]];then
		printf "\nSet the path for your $RED$1$NC. The command will be '$RED$2$NC'"
		printf "\nUse absolute paths. Now you are at: `pwd`"
		printf "\n$RED$2$NC:"
		read -r path
		aliasToInclude="$aliasToInclude\nalias $2=\"cd $path\"\n"
		checkPathCreatePath $path
	fi


}

function installCommonAlias(){

	table
	
	# We will save all the alias that we fill up : aliasToInclude
	aliasToInclude="alias ll=\"ls -laF --color=auto\""
	aliasToInclude="$aliasToInclude\nalias ..=\"cd ..\""
	aliasToInclude="$aliasToInclude\nalias lsg=\"ll | grep \$1\""

	customShortcut "workspace" "ws"
	customShortcut "vagrant config machines" "dva"
	customShortcut "git repository" "repo"


	echo -e $aliasToInclude > output.log

	# Check that .bash_aliases exists
	 if [ ! -f ~/.bash_aliases ] 
	 then
	     touch ~/.bash_aliases
	     echo -e $aliasToInclude > ~/.bash_aliases
	 else
		printf "\nThere is a .bash_aliases at your system already.\nDo you want to overwrite your previous .bash_aliases or append the new info [overwrite/APPEND]:"		
		read -r confirm
		toLower confirm
		if [[ $confirm == "overwrite" ]];then
	     		echo -e $aliasToInclude > ~/.bash_aliases
		else
	     		echo -e $aliasToInclude >> ~/.bash_aliases
		fi
	 fi


	printf "All done!\n Remember that any modification that you want to add to your aliases you have to add it to $HOME/.bash_aliases\n"
	
}
info
installCommonAlias

source ~/.bashrc
#echo Installation finished. Remember to execute 'source $HOME/.bash_aliases' to finish the installation



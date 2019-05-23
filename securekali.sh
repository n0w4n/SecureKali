#!/bin/bash

# This script is to help securing Kali pentesting OS and 
# install a lot of security tools and wordlists which are very handy
# when doing pentesting.

# Created by n0w4n

#---------------------Variables---------------------#

# Current Version
Version="1.5.4"

# Setup colors
bold="\e[1m"
cyan="\e[36m"
green="\e[32m"
red='\e[31m'
yellow="\e[33m"
blue="\e[94m"
magenta="\e[95m"
reset="\e[0m"

# Variables for Data files & temp files
path="/opt/tools/"
aliases="./aliases.txt"
vmGuest=0

#---------------------functions---------------------#

function logo () {
	echo -e "
//////////////////////////////////////////////////////////////////////////////////////   
//////////////////////////////////////////////////////////////////////////////////////
$blue                              
         ............         
       ................      	  _______  _______  _______           _______  _______ 
     .....          .....    	(  ____ \(  ____ \(  ____ \|\     /|(  ____ )(  ____ \   
     ....            ....    	| (    \/| (    \/| (    \/| )   ( || (    )|| (    \/ 
     ....            ....    	| (_____ | (__    | |      | |   | || (____)|| (__     
     ....            ....    	(_____  )|  __)   | |      | |   | ||     __)|  __)    
     ....            ....    	      ) || (      | |      | |   | || (\ (   | (       
    .....      .......'''....	/\____) || (____/\| (____/\| (___) || ) \ \__| (____/\ 
 .''''''''''''';;;;;;;;;;;;;;	\_______)(_______/(_______/(_______)|/   \__/(_______/ 
 .''''''''''''';;;;;;;;;;;;;;	  _        _______  _       _________ 
 .''''''''''',cl:;;;;;;;;;;;;	| \    /\(  ___  )( \      \__   __/ 
 .''''''''''cNNNNo;;;;;;;;;;;	|  \  / /| (   ) || (         ) (    
 .'''''''''';ONN0c;;;;;;;;;;;	|  (_/ / | (___) || |         | |    
 .''''''''''''XN;;;;;;;;;;;;;	|   _ (  |  ___  || |         | | 
 .''''''''''''0K;;;;;;;;;;;;;	|  ( \ \ | (   ) || |         | |   
 .''''''''''''';;;;;;;;;;;;;,	|  /  \ \| )   ( || (____/\___) (___    
  .......................... 	|_/    \/|/     \|(_______/\_______/   
 
								created by n0w4n
								version $Version
$reset
//////////////////////////////////////////////////////////////////////////////////////  
//////////////////////////////////////////////////////////////////////////////////////                                                                                      
                       

"
}

function header () {
	pad=$(printf '%0.1s' "."{1..90})
	padlength=70
	check='[OK]'
	title="$*"
	printf "%s" "[-] $title"
	printf '%*.*s' 0 $(( padlength - ${#title} - ${#check} )) "$pad"
	printf "$green%s$reset\n" "$check"
}

function headerS () {
	pad=$(printf '%0.1s' "."{1..90})
	padlength=70
	check='[STARTING]'
	title="$*"
	printf '%s' "[-] $title"
	printf '%*.*s' 0 $(( padlength - ${#title} - ${#check} )) "$pad"
	printf "$magenta%s$reset\n" "$check"
}

function headerW () {
	pad=$(printf '%0.1s' "."{1..90})
	padlength=70
	check='[WARNING]'
	title="$*"
	printf '%s' "[-] $title"
	printf '%*.*s' 0 $(( padlength - ${#title} - ${#check} )) "$pad"
	printf "$red%s$reset\n" "$check"
}

function headerF () {
	pad=$(printf '%0.1s' ""{1..90})
	padlength=70
	check='[FALSE]'
	title="$*"
	printf '%s' "[-] $title"
	printf '%*.*s' 0 $(( padlength - ${#title} - ${#check} )) "$pad"
	printf "$yellow%s$reset\n" "$check"
}

function line () {
	pad=$(printf '%0.1s' "-"{1..90})
	padlength=55
	title="$*"
	echo
	printf "$cyan$bold%*.*s" 0 $(( padlength - ${#title} )) "$pad"
	printf '%s' "[$title]"
	printf "%s$reset\n\n" "-----------------"
}

function vmChecker () {
	vmCheck=$(dmidecode -s system-manufacturer | grep -i 'vmware\|virtualbox')
	if [[ ! -z $vmCheck ]]; then
		vmGuest=1
	else
		vmGuest=0
	fi
}

function starWars () {
	# check if there is an internet connection
	internetCheck=$(ping -c1 1.1.1.1 | grep ' 0%')
	if [[ ! -z $internetCheck ]]; then
		# check if netcat is installed (is needed for star wars)
		ncCheck=$(dpkg -s netcat 2>/dev/null || dpkg -s nc 2>/dev/null || dpkg -s netcat-traditional 2>/dev/null )
		if [[ $? == 0 ]]; then
			# check if xterm is installed (to open extra window)
			xtermCheck=$(dpkg -s xterm 2>/dev/null)
			if [[ $? == 0 ]]; then
				headerS activating Star Wars
				xterm -e /usr/bin/nc towel.blinkenlights.nl 23 &
			fi
		else
			# check if telnet is installed (is needed for star wars)
			telnetCheck=$(dpkg -s telnet 2>/dev/null)
			if [[ $? == 0 ]]; then
				headerS activating Star Wars
				xterm -e /usr/bin/telnet towel.blinkenlights.nl &
			fi
		fi
	fi
}

clear
logo
vmChecker

#-------------------dependencies-----------------#

line DEPENDENCIES

# This program should run as root so the files cannot be tempered by lower privileged users
if [[ $EUID -ne 0 ]]; then 
	headerW this script needs to run as root
	exit 1
else
	header this script runs as root
fi

# Check for needed programs

# checking for git
dpkg -s wget &> /dev/null

if [[ $? -eq 0 ]]; then
	header found wget
else
	header installing wget
	xterm -e apt install git -y
fi

# checking for wget
dpkg -s git &> /dev/null

if [[ $? -eq 0 ]]; then
	header found git
else
	header installing git
	xterm -e apt install git -y
fi

#checking for pip
dpkg -s python-pip &> /dev/null

if [[ $? -eq 0 ]]; then
    header found pip
else
	header installing pip
	xterm -e apt install -y python-pip
fi

#checking for pip3
dpkg -s python3-pip &> /dev/null

if [[ $? -eq 0 ]]; then
	pip3 --version &> /dev/null
	if [[ -z $? ]]; then
		apt remove python3-pip &> /dev/null; apt install python3-pip -y &> /dev/null
	fi
    header found pip3
else
	header installing pip3
	xterm -e apt install -y python3-pip
fi


#-------------------Securing-----------------#

line SECURITY

# Notification about running inside VM
if (( vmGuest = 1 )); then
	header running inside a Virtual Machine
fi

# Place file on system with '0' as content, which will function as flag
# This script will check this flag to see if it already ran
if [[ ! -f /root/secure-kali-flag ]]; then
	echo "0" > /root/secure-kali-flag
	header placed file \"secure-kali-flag\" on system
fi

# Checking for script flag (check if script has already ran)
checkFlag=$(cat /root/secure-kali-flag)
if [[ ! $checkFlag == 0 ]]; then
	header flag check
	headerW this script already ran on system
	echo
	read -p '[-] continue to run script? (yes/no) ' varContinue
	echo
	if [[ $varContinue =~ [nN] ]]; then
		echo
		header exiting
		exit 0
	else
		header continuing script
	fi
else
	header flag check
	header continuing script
fi

# Updating repository Kali
headerS updating repository
apt update 2>/dev/null | grep 'packages can be upgraded' | awk '{print $1}' > ./update.tmp
header repository updated

# Upgrading packages
numberPackages=$(cat ./update.tmp)
if [[ -z $numberPackages ]]; then
	header no packages to upgrade
	rm ./update.tmp
elif (( numberPackages >= 1 && numberPackages <= 100 )); then
	headerS upgrading \[$numberPackages\] packages
	xterm -e apt full-upgrade -y
	rm ./update.tmp
	header packages upgraded
elif (( numberPackages >= 101 && numberPackages <= 250 )); then
	headerS upgrading \[$numberPackages\] packages \- be patient
	# starts extra screen with star wars movie (ascii)
	starWars
	xterm -e apt full-upgrade -y
	rm ./update.tmp
	header upgraded packages
else
	headerW upgrading \[$numberPackages\] packages \- this can take a while
	# starts extra screen with star wars movie (ascii)
	starWars
	xterm -e apt full-upgrade -y
	rm ./update.tmp
	header packages upgraded
fi

# Changing the default password
headerS changing root password
echo
passwd root
if [[ ! $? -eq 0 ]]; then
	echo
	headerW root password has NOT changed
else
	echo
	header changing root password
fi

# Creating an unpriv user
headerS creating an unprivileged user
echo
read -p 'What is the new username? ' newUsername
	sleep 0.1
	useradd -m -s /bin/bash $newUsername
	if [[ ! $? -eq 0 ]]; then
		echo
		headerW unable to create an unprivileged user
	else
		usermod -aG sudo $newUsername
		echo
		passwd $newUsername
		if [[ ! $? -eq 0 ]]; then
			echo
			headerW no password set for $newUsername
			header creating an unprivileged user
		else
			echo
			header creating an unprivileged user
		fi
	fi

# Backing up default SSH Keys
if [[ ! -d /etc/ssh/old_keys ]]; then
	mkdir /etc/ssh/old_keys
	header create backup of old SSH keys
	mv /etc/ssh/ssh_host* /etc/ssh/old_keys

	# Creating new SSH Keys
	header replacing old SSH keys with new ones
	dpkg-reconfigure openssh-server &> /dev/null
	# Verifying that new keys are different from old keys
	md5sum /etc/ssh/ssh_host* | sort -k 2 | awk '{print $1}' > ./ssh-keys1.tmp
	md5sum /etc/ssh/old_keys/ssh_host* | sort -k 2 | awk '{print $1}' > ./ssh-keys2.tmp
	varDiff=$(diff ./ssh-keys1.tmp ./ssh-keys2.tmp)

	if [[ ! -z $varDiff ]]; then
		header new SSH Keys are different \(hash check\)
	else
		headerW new SSH Keys are same as old ones \(hash check\)
	fi
	rm ./ssh-keys1.tmp
	rm ./ssh-keys2.tmp
fi

# Settings aliases on the system
header placing list of aliases in .bash_aliases
echo "$(cat $aliases)" >> /root/.bash_aliases
echo "$(cat $aliases)" >> /home/$newUsername/.bash_aliases
chown $newUsername:$newUsername /home/$newUsername/.bash_aliases

#------------------Configuration---------------#

line CONFIGURATION

# disable SSH server
header disable SSH server to run by default
systemctl disable ssh &> /dev/null

# disable log in as root (SSH)
if [[ -f /etc/ssh/sshd_config ]]; then
	cat /etc/ssh/sshd_config | grep '\#PermitRootLogin*.*\#' &> /dev/null
	if [[ ! $? -eq 0 ]]; then
		header disable PermitRootLogin in SSH server
		sed -i 's/PermitRootLogin/\#PermitRootLogin/g' /etc/ssh/sshd_config
	else
		header PermitRootLogin in SSH server is disabled
	fi
fi

# Downgrading Java
header downgrade system to Java 8
update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java &> /dev/null

# Disable NTP service
header disable NTP service
systemctl disable ntp &> /dev/null

#-------------------Installing-----------------#

line INSTALLING

if (( vmGuest = 1 )); then
	# Downloading open-vm-tools
	dpkg -s open-vm-tools-desktop &> /dev/null

	if [[ $? -eq 0 ]]; then
	    header found open-vm-tools
	else
	   header installing open-vm-tools
	   xterm -e apt install -y open-vm-tools-desktop fuse
	fi
fi

# Downloading Seclists on the system
if [[ -d /usr/share/wordlists/seclists ]]; then
    header found wordlists seclists
else
    header installing wordlists seclists
    xterm -e git clone https://github.com/danielmiessler/SecLists.git /usr/share/wordlists/seclists
fi

# Downloading Impacket on the system
if [[ -d /opt/tools/impacket ]]; then
    header found toolset impacket
else
    header installing toolset impacket
    xterm -e git clone https://github.com/CoreSecurity/impacket.git /opt/tools/impacket
    pip install . &> /dev/null
    python /opt/tools/impacket/setup.py build &> /dev/null
    python /opt/tools/impacket/setup.py install &> /dev/null
fi

# Downloading PenTest scripts on the system
if [ -d /opt/scripts ]; then
	header found pentesting scripts
else
    header installing pentesting scripts
	mkdir /opt/scripts/ && cd /opt/scripts
	xterm -e git clone https://github.com/rebootuser/LinEnum.git
	sleep 0.1
	xterm -e git clone https://github.com/sleventyeleven/linuxprivchecker.git
	sleep 0.1
	xterm -e git clone https://github.com/InteliSecureLabs/Linux_Exploit_Suggester.git
	sleep 0.1
	xterm -e git clone https://github.com/pentestmonkey/unix-privesc-check.git
	sleep 0.1
	xterm -e git clone https://github.com/Hack-with-Github/Windows.git
	sleep 0.1
	xterm -e git clone https://github.com/NullArray/AutoSploit.git
	sleep 0.1
	xterm -e git clone https://github.com/inquisb/icmpsh.git
	sleep 0.1
    xterm -e git clone https://github.com/cheetz/Easy-P.git
	sleep 0.1
    xterm -e git clone https://github.com/cheetz/Password_Plus_One
	sleep 0.1
    xterm -e git clone https://github.com/cheetz/PowerShell_Popup
	sleep 0.1
    xterm -e git clone https://github.com/cheetz/icmpshock
	sleep 0.1
    xterm -e git clone https://github.com/cheetz/brutescrape
	sleep 0.1
    xterm -e git clone https://www.github.com/cheetz/reddit_xss
fi

# Downloading dirsearch directory bruteforcer (similar like dirb and dirbuster)
if [ -d /opt/tools/dirsearch ]; then
    header found webfuzzer \"DirSearch\"
else
    header installing webfuzzer \"DirSearch\"
    xterm -e git clone https://github.com/maurosoria/dirsearch.git /opt/tools/dirsearch
fi

# Downloading gobuster directory bruteforcer (similar like dirb and dirbuster)
if [ -d /opt/tools/gobuster ]; then
    header found webfuzzer \"gobuster\"
else
    header installing webfuzzer \"gobuster\"
    xterm -e git clone https://github.com/OJ/gobuster.git /opt/tools/gobuster
fi

# Downloading vim
dpkg -s vim &> /dev/null
if [[ $? -eq 0 ]]; then
	header found vim
else
	header installing vim
	xterm -e apt install -y vim
fi

# Downloading asciinema
dpkg -s asciinema &> /dev/null
if [[ $? -eq 0 ]]; then
	header found asciinema
else
	header installing asciinema
	xterm -e apt install -y asciinema
fi

# Downloading exiftool
dpkg -s libimage-exiftool-perl &> /dev/null
if [[ $? -eq 0 ]]; then
	header found exiftool
else
	header installing exiftool
	xterm -e apt install -y exiftool
fi

# Downloading terminator
dpkg -s terminator &> /dev/null
if [[ $? -eq 0 ]]; then
	header found terminator
else
	header installing terminator
	xterm -e apt install -y terminator
fi

header setting terminator as default x-terminal-emulator
update-alternatives --set x-terminal-emulator /usr/bin/terminator &> /dev/null

#Downloading sublime3
dpkg -s sublime-text &> /dev/null

if [[ $? -eq 0 ]]; then
    header found sublime
else
	header installing sublime
    xterm -e wget --no-check-certificate -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    echo "deb https://download.sublimetext.com/ apt/stable/" >> /etc/apt/sources.list.d/sublime-text.list
	xterm -e apt install -y sublime-text
fi

# Downloading cmsmap
if [[ -d /opt/tools/cmsmap ]]; then
	header found cmsmap
else
	header installing cmsmap
	xterm -e git clone https://github.com/Dionach/CMSmap /opt/tools/cmsmap
fi

# Downloading patator
if [[ -d /opt/tools/patator ]]; then
	header found patator
else
	header installing patator
	xterm -e git clone https://github.com/lanjelot/patator.git /opt/tools/patator
fi

# Downloading hash-buster
if [[ -d /opt/tools/hash-buster ]]; then
	header found hash-buster
else
	header installing hash-buster
	xterm -e git clone https://github.com/s0md3v/Hash-Buster.git /opt/tools/hash-buster
fi

# Downloading JD-Gui (java decompiler)
if [[ -d /opt/tools/jd-gui ]]; then
	header found jd-gui
else
	header installing jd-gui
	xterm -e git clone https://github.com/java-decompiler/jd-gui.git /opt/tools/jd-gui
	cd /opt/tools/jd-gui
	# temporary upgrade java for installing purposes
	update-alternatives --set java /usr/lib/jvm/java-11-openjdk-amd64/bin/java &> /dev/null
	xterm -e ./gradlew build
	# downgrading java again
	update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java &> /dev/null
fi

# Downloading DNScan
if [[ -d /opt/tools/dnscan ]]; then
	header found dnscan
else
	header installing dnscan
	xterm -e git clone https://github.com/rbsec/dnscan.git /opt/tools/dnscan
fi

# Downloading JXplorer
if [[ -d /opt/tools/jxplorer ]]; then
	header found jxplorer
else
	header installing jxplorer
	xterm -e git clone https://github.com/pegacat/jxplorer.git /opt/tools/jxplorer
fi

#Downloading FTP
dpkg -s ftp &> /dev/null

if [[ $? -eq 0 ]]; then
    header found ftp
else
	header installing ftp
	xterm -e apt install -y ftp
fi

#Downloading SNMP + MIBS
dpkg -s snmp &> /dev/null

if [[ $? -eq 0 ]]; then
    header found snmp
else
	header installing snmp
    xterm -e apt install -y snmp snmp-mibs-downloader
    if [[ -f /etc/snmp/snmp.conf ]]; then
	    varSnmp=$(cat /etc/snmp/snmp.conf.bak | grep -E '^[a-z]ibs \:')
	    if [[ ! -z $varSnmp ]]; then
	    	header installing snmp
	    	cp /etc/snmp/snmp.conf /etc/snmp/snmp.conf.bak
	    	cat /etc/snmp/snmp.conf.bak | grep -E '^[a-z]ibs \:' | sed 's/mibs/\#mibs/g' > /etc/snmp/snmp.conf
	    	download-mibs &> /dev/null
	    fi
	fi
fi

#Downloading Bloodhound
dpkg -s bloodhound &> /dev/null

if [[ $? -eq 0 ]]; then
    header found bloodhound
else
	header installing bloodhound
    xterm -e apt install -y bloodhound
fi

# downloading shells
header downloading shell scripts
wget --quiet http://pentestmonkey.net/tools/php-reverse-shell/php-reverse-shell-1.0.tar.gz -P /opt/tools/shells
wget --quiet http://pentestmonkey.net/tools/perl-reverse-shell/perl-reverse-shell-1.0.tar.gz -P /opt/tools/shells
sleep 0.1
tar -C /opt/tools/shells --wildcards --no-anchored '*.php' -xzf /opt/tools/shells/php-reverse-shell-1.0.tar.gz --strip 1
tar -C /opt/tools/shells --wildcards --no-anchored '*.pl' -xzf /opt/tools/shells/perl-reverse-shell-1.0.tar.gz --strip 1

header primary security update is complete
echo
read -p '[-] do you want to install additional packages? (yes/no) ' installMore
echo

#-------------------Optional-----------------#

if [[ $installMore =~ [nN] ]]; then
	header exiting
	echo "1" > /root/secure-kali-flag
	echo
	echo
	exit 0
else
	line OPTIONAL

	header Installing
	# checking for Empire
	if [[ -d /opt/tools/empitre ]]; then
	    header found toolset empire
	else
	    headerS installing toolset empire
	    xterm -e git clone https://github.com/EmpireProject/Empire.git /opt/tools/empire
	    cd /opt/tools/empire/setup
	    xterm -e ./install.sh
	    echo
	    header installing toolset empire
	fi
fi

header exiting
echo "1" > /root/secure-kali-flag
echo
echo
exit 0

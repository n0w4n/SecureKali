#!/bin/bash

# This script is to help securing Kali pentesting OS
# in a semi-automated way.

# Created by n0w4n

#---------------------Variables---------------------#

# Current Version
Version="1.4"

# Setup colors
bold="\e[1m"
cyan="\e[36m"
green="\e[32m"
red='\e[31m'
yellow="\e[33m"
orange="\e[38m"
magenta="\e[95m"
reset="\e[0m"

# Variables for Data files & temp files
aliases="./aliases.txt"

#---------------------functions---------------------#

function logo () {
	echo -e "
/////////////////////////////////////////////////////////////////////////////////////////////   
/////////////////////////////////////////////////////////////////////////////////////////////
                              
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
 
									created by$orange n0w4n $reset
									version$orange $Version $reset

/////////////////////////////////////////////////////////////////////////////////////////////   
/////////////////////////////////////////////////////////////////////////////////////////////                                                                                       
                       

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
	padlength=70
	title="$*"
	echo
	printf "$cyan$bold%*.*s" 0 $(( padlength - ${#title} )) "$pad"
	printf '%s' "[$title]"
	printf "%s$reset\n\n" "-----"
}

clear
logo

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
	apt install git -y &> /dev/null
fi

# checking for wget
dpkg -s git &> /dev/null

if [[ $? -eq 0 ]]; then
	header found git
else
	header installing git
	apt install git -y &> /dev/null
fi

#checking for pip
dpkg -s python-pip &> /dev/null

if [[ $? -eq 0 ]]; then
    header found pip
else
	header installing pip
	apt install -y python-pip &> /dev/null
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
	apt install -y python3-pip &> /dev/null
fi


#-------------------Securing-----------------#

line SECURITY

# Place file on system with '0' as content, which will function as flag
# This script will check this flag to see if it already ran
if [[ ! -f /root/securing-kali-flag ]]; then
	echo "0" > /root/securing-kali-flag
	header placed file \"securing-kali-flag\" on system
fi

# Checking for script flag (check if script has already ran)
checkFlag=$(cat /root/securing-kali-flag)
if [[ ! $checkFlag == 0 ]]; then
	header flag check
	headerW exiting because scipt already ran on system
	echo
	exit 0
else
	header flag check
	header continuing script
fi

# Updating repository Kali
headerS updating repository
apt update &> /dev/null
header updating repository

# Upgrading packages
headerS upgrading packages
apt full-upgrade -y &> /dev/null
header upgrading packages

# Changing the default password
headerS changing root password
echo
passwd root
if [[ $? -eq 10 ]]; then
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
useradd -m -U -s /bin/bash $newUsername
usermod -aG sudo $newUsername
echo
passwd $newUsername
if [[ $? -eq 10 ]]; then
	echo
	headerW no password set for $newUsername
	header creating an unprivileged user
else
	echo
	header creating an unprivileged user
fi

# Backing up default SSH Keys
if [[ ! -d /etc/ssh/old_keys ]]; then
	mkdir /etc/ssh/old_keys
fi
header create backup of old SSH keys
mv /etc/ssh/ssh_host* /etc/ssh/old_keys

# Creating new SSH Keys
header replacing old SSH keys with new ones
dpkg-reconfigure openssh-server &> /dev/null
# Verifying that new keys are different from old keys
md5sum /etc/ssh/ssh_host* | sort -k 2 | awk '{print $1}' > ./ssh-keys1.tmp
md5sum /etc/ssh/old_keys/ssh_host* | sort -k 2 | awk '{print $1}' > ./ssh-keys2.tmp
diff ./ssh-keys1.tmp ./ssh-keys2.tmp &> /dev/null
if [[ -z $? ]]; then
	header new SSH Keys are different \(hash check\)
else
	headerW new SSH Keys are same as old ones \(hash check\)
fi
rm ./ssh-keys1.tmp
rm ./ssh-keys2.tmp

# Settings aliases on the system
header placing list of aliases in .bash_aliases
echo "$(cat $aliases)" >> /root/.bash_aliases
echo "$(cat $aliases)" >> /home/$newUsername/.bash_aliases
chown $newUsername:$newUsername /home/$newUsername/.bash_aliases

#------------------Configuration---------------#

line CONFIGURATION

# setting postgresql to startup automatically and setting up database for metasploit framework
header enabling postgresql for metasploit
systemctl enable postgresql &> /dev/null
header initializing metasploit database
msfdb init &> /dev/null

# disable SSH server
header disable SSH server to run by default
systemctl disable ssh &> /dev/null

# disable log in as root (SSH)
cat /etc/ssh/sshd_config | grep '\#PermitRootLogin*.*\#' &> /dev/null
if [[ ! $? -eq 0 ]]; then
	header disable PermitRootLogin in SSH server
	sed -i 's/PermitRootLogin/\#PermitRootLogin/g' /etc/ssh/sshd_config
else
	header PermitRootLogin in SSH server is disabled
fi

# Downgrading Java
header downgrade system to Java 8
update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java &> /dev/null

# Disable NTP service
header disable NTP service
systemctl disable ntp &> /dev/null

#-------------------Installing-----------------#

line INSTALLING

# Downloading open-vm-tools
dpkg -s open-vm-tools-desktop &> /dev/null

if [[ $? -eq 0 ]]; then
    header found open-vm-tools
else
   header installing open-vm-tools
   apt install -y open-vm-tools-desktop fuse &> /dev/null
fi

# Downloading Seclists on the system
if [[ -d /usr/share/wordlists/seclists ]]; then
    header locating wordlists seclists
else
    header installing wordlists seclists
    git clone https://github.com/danielmiessler/SecLists.git /usr/share/wordlists/seclists &> /dev/null
fi

# Downloading Impacket on the system
if [[ -d /opt/tools/impacket ]]; then
    header locating toolset impacket
else
    header installing toolset impacket
    git clone https://github.com/CoreSecurity/impacket.git /opt/tools/impacket &> /dev/null
    pip install . &> /dev/null
    python /opt/tools/impacket/setup.py build &> /dev/null
    python /opt/tools/impacket/setup.py install &> /dev/null
fi

# Downloading PenTest scripts on the system
if [ -d /opt/scripts ]; then
	header locating pentesting scripts
else
    header installing pentesting scripts
	mkdir /opt/scripts/ && cd /opt/scripts
	git clone https://github.com/rebootuser/LinEnum.git &> /dev/null
	git clone https://github.com/sleventyeleven/linuxprivchecker.git &> /dev/null
	git clone https://github.com/InteliSecureLabs/Linux_Exploit_Suggester.git &> /dev/null
	git clone https://github.com/pentestmonkey/unix-privesc-check.git &> /dev/null
	git clone https://github.com/Hack-with-Github/Windows.git &> /dev/null
	git clone https://github.com/NullArray/AutoSploit.git &> /dev/null
	git clone https://github.com/inquisb/icmpsh.git &> /dev/null
    git clone https://github.com/cheetz/Easy-P.git &> /dev/null
    git clone https://github.com/cheetz/Password_Plus_One &> /dev/null
    git clone https://github.com/cheetz/PowerShell_Popup &> /dev/null
    git clone https://github.com/cheetz/icmpshock &> /dev/null
    git clone https://github.com/cheetz/brutescrape &> /dev/null
    git clone https://www.github.com/cheetz/reddit_xss &> /dev/null
fi

# Downloading dirsearch directory bruteforcer (similar like dirb and dirbuster)
if [ -d /opt/tools/dirsearch ]; then
    header locating webfuzzer \"DirSearch\"
else
    header installing webfuzzer \"DirSearch\"
    git clone https://github.com/maurosoria/dirsearch.git /opt/tools/dirsearch &> /dev/null
fi

# Downloading gobuster directory bruteforcer (similar like dirb and dirbuster)
if [ -d /opt/tools/gobuster ]; then
    header locating webfuzzer \"gobuster\"
else
    header installing webfuzzer \"gobuster\"
    git clone https://github.com/OJ/gobuster.git /opt/tools/gobuster &> /dev/null
fi

# Downloading vim
dpkg -s vim &> /dev/null
if [[ $? -eq 0 ]]; then
	header locating vim
else
	header installing vim
	apt install -y vim &> /dev/null
fi

# Downloading asciinema
dpkg -s asciinema &> /dev/null
if [[ $? -eq 0 ]]; then
	header locating asciinema
else
	header installing asciinema
	apt install -y asciinema &> /dev/null
fi

# Downloading exiftool
dpkg -s libimage-exiftool-perl &> /dev/null
if [[ $? -eq 0 ]]; then
	header locating exiftool
else
	header installing exiftool
	apt install -y exiftool &> /dev/null
fi

# Downloading terminator
dpkg -s terminator &> /dev/null
if [[ $? -eq 0 ]]; then
	header locating terminator
else
	header installing terminator
	apt install -y terminator &> /dev/null
fi

header setting terminator as default x-terminal-emulator
update-alternatives --set x-terminal-emulator /usr/bin/terminator &> /dev/null

#Downloading sublime3
dpkg -s sublime-text &> /dev/null

if [[ $? -eq 0 ]]; then
    header locating sublime
else
	header installing sublime
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - &> /dev/null
    echo "deb https://download.sublimetext.com/ apt/stable/" >> /etc/apt/sources.list.d/sublime-text.list
	apt install -y sublime-text &> /dev/null
fi

# Downloading cmsmap
if [[ -d /opt/tools/cmsmap ]]; then
	header locating cmsmap
else
	header installing cmsmap
	git clone https://github.com/Dionach/CMSmap /opt/tools/cmsmap &> /dev/null
fi

# Downloading patator
if [[ -d /opt/tools/patator ]]; then
	header locating patator
else
	header installing patator
	git clone https://github.com/lanjelot/patator.git /opt/tools/patator &> /dev/null
fi

# Downloading hash-buster
if [[ -d /opt/tools/hash-buster ]]; then
	header locating hash-buster
else
	header installing hash-buster
	git clone https://github.com/s0md3v/Hash-Buster.git /opt/tools/hash-buster &> /dev/null
fi

# Downloading JD-Gui (java decompiler)
if [[ -d /opt/tools/jd-gui ]]; then
	header locating jd-gui
else
	header installing jd-gui
	git clone https://github.com/java-decompiler/jd-gui.git /opt/tools/jd-gui &> /dev/null
	cd /opt/tools/jd-gui
	# temporary upgrade java for installing purposes
	update-alternatives --set java /usr/lib/jvm/java-11-openjdk-amd64/bin/java &> /dev/null
	./gradlew build &> /dev/null
	# downgrading java again
	update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java &> /dev/null
fi

# Downloading DNScan
if [[ -d /opt/tools/dnscan ]]; then
	header locating dnscan
else
	header installing dnscan
	git clone https://github.com/rbsec/dnscan.git /opt/tools/dnscan &> /dev/null
fi

# Downloading JXplorer
if [[ -d /opt/tools/jxplorer ]]; then
	header locating jxplorer
else
	header installing jxplorer
	git clone https://github.com/pegacat/jxplorer.git /opt/tools/jxplorer &> /dev/null
fi

#Downloading FTP
dpkg -s ftp &> /dev/null

if [[ $? -eq 0 ]]; then
    header locating ftp
else
	header installing ftp
	apt install -y ftp &> /dev/null
fi

#Downloading SNMP + MIBS
dpkg -s snmp &> /dev/null

if [[ $? -eq 0 ]]; then
    header locating snmp
else
	header installing snmp
    apt install -y snmp snmp-mibs-downloader &> /dev/null
    varSnmp=$(cat /etc/snmp/snmp.conf.bak | grep -E '^[a-z]ibs \:')
    if [[ ! -z $varSnmp ]]; then
    	header installing snmp
    	cp /etc/snmp/snmp.conf /etc/snmp/snmp.conf.bak
    	cat /etc/snmp/snmp.conf.bak | grep -E '^[a-z]ibs \:' | sed 's/mibs/\#mibs/g' > /etc/snmp/snmp.conf
    	download-mibs &> /dev/null
    fi
fi

#Downloading Bloodhound
dpkg -s bloodhound &> /dev/null

if [[ $? -eq 0 ]]; then
    header locating bloodhound
else
	header installing bloodhound
    apt install -y bloodhound &> /dev/null
fi

header primary security update is complete
read -p '[-] do you want to install additional packages? (yes/no) ' installMore

#-------------------Optional-----------------#

line OPTIONAL

if [[ $installMore =~ [nN] ]]; then
	header exiting
	echo "1" > /root/securing-kali-flag
	echo
	echo
	exit 0
else
	header Installing
	# checking for Empire
	if [[ -d /opt/tools/empitre ]]; then
	    header locating toolset empire
	else
	    headerS installing toolset empire
	    git clone https://github.com/EmpireProject/Empire.git /opt/tools/empire &> /dev/null
	    cd /opt/tools/empire/setup
	    ./install.sh
	    echo
	    header installing toolset empire
	fi
fi

header exiting
echo "1" > /root/securing-kali-flag
echo
echo
exit 0

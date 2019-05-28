# SecureKali

SecureKali is a semi-automated tool to secure your freshly installed Kali OS.

Using a fresh Kali behind a NAT for practising pentest-exercises and challenges gives a low security risk.
But when using Kali as a real-time pentesting tool, it is wise to tweak it and makes sure you are ready for the challenge.

This script will tighten security on your Kali host, it will install common security tools and add well-known wordlists.


*If you don't have git installed*

```
user@kali[~]# sudo apt update
user@kali[~]# sudo apt install git -y
```

## Downloading script

```
user@kali[~]# git clone https://github.com/n0w4n/SecureKali.git
```

## Running script

```
user@kali[~]# cd SecureKali
user@kali[~]# chmod +x securekali.sh
user@kali[~]# sudo ./securekali.sh
```

## Star Wars

When is a long list of packages that needs to be upgraded, there will be some entertainment in the form of Star Wars.



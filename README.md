# Net Guard

A command line tool to detect possible malicious activity in your network using ARP protocol. Maybe someone is hacking in your network! Alerts are sent via email.


## Features

* Detection of unknown devices
* Detection of devices in promiscuous mode (approach taken from [here](http://www.securityfriday.com/promiscuous_detection_01.pdf))


## Install 

### Mac

On Mac, install arp-scan:

`brew install arp-scan`

Configure `mail` on terminal, [here's a tutorial on Gmail](http://codana.me/2014/11/23/sending-gmail-from-os-x-yosemite-terminal/)

### Other Platforms:

TODO. 
PRs are welcome :)


## Configure

Edit `settings.cnf` to set `ALERT_EMAIL_ADD`. 

Add the Mac addresses of devices you know to `whitelist.txt`. You can list current connected devices using:

`arp-scan --interface=<xx> --localnet` 

Newly found devices are recorded at `new_found.txt`, and are only reported once.

Both `whitelist.txt` and `new_found.txt` can be edited to include comments, such as:

`00:11:22:33:44:55 # My iPhone`

There are two equivalent lists for promiscuous mode devices (`p_whitelist.txt` and `p_new_found.txt`).

## Usage
`./net_guard.sh <interface>`

`E.g.: ./net_guard.sh en0`

To list all network interfaces:

`ifconfig`







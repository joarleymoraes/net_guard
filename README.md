# Net Guard

A command line tool to detect new unknown device in your network using ARP protocol. Maybe someone is hacking in your network! Alerts are sent via email.

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

## Usage
`./net_guard.sh <interface>`

`E.g.: ./net_guard.sh en0`

To list all network interfaces:

`ifconfig`







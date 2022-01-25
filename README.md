# ufw-auto-whitelist
Auto Whitelist for UFW to be used with dynamic IP address

No installer yet...<br />
Requires UFW to be installed.<br />
Requires domains to be dynamic updated already (use [namecheap](https://www.namecheap.com/))<br />
Will require basic shell script knowledge.<br />

- copy bin/ folder to $HOME
- add bin/ folder to $PATH
- edit bin/auto-whitelist and change the 3 domains
- add cronjob to execute every 5mins

All three domains will be resolved and then whitelisted in UFW. The old IP address will be removed each update.

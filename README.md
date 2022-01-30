# ufw-autowhitelist v1.0.0

Auto Whitelist for UFW to be used with dynamic IP address. Featuring a new installer. Linux only.

Force update with `ufw-autowhitelist --force`

All three domains will be resolved and then whitelisted in UFW. The old IP address will be removed each update.

### Disclaimer:
**I am not liable in any way for damages to your computer due to bugs, being hacked, exploited, or any other malfunction of the scripts. Having a script that automatically whitelist's ip addresses is possibly dangerous and can be exploited for malicious purposes. Please be advised of the risks and ensure the domains/webservices are hosted at a registrar/host with 2fa enabled and secure passwords. This source code is open, it is your responsibility to audit the code.**

#### Notes:
- It is important the instructions are completed in order
- Read the notes about [cronjobs](#cronjobs) before installing
- Do not delete the git repository directory, it installs in it's place

#### Setup:
1. change to the directory where you want ufw-autowhitelist installed
2. `git clone https://gogs.easyx.cc/EasyX-Community/ufw-autowhitelist.git`
3. `cd ufw-autowhitelist`
4. `./install_ufw-autowhitelist.sh`
5. enter domains one at a time (do not put https:// or trailing / - leave blank when finished)
6. `source ~/.bashrc`

#### Updating (manual):
1. `ufw-autowhitelist`

#### Cronjobs:
The installer will ask if you want it to install cronjob for you. It will also ask if you want it to install a weekly update cronjob for you.

It is advised you select **'yes'** and then if you want to change it you can use `crontab -e` later.

If you are unsure about crontab times, this calculator will come in handy [https://crontab.guru/](https://crontab.guru/)

#### Coming features:
- Can't think of any at the moment, but please create GitHub or Gogs issue ticket if you have any suggestions.


#### Donations:
**XMR:** 84wwa7EKo8uasZAHijHKtBTuBaMPuNjCJgnfGJrsLFo4aZcfrzGvUX33sSeFNdno8fPiTDGnz4h1bCvsdFQYWRuR2619FzS <br />
**ETH(ERC-20):** 0xc89eEa9b5C0cfa7f583dc1A6405a7d5730ADB603 <br />
**BNB(BSC)** 0xc89eEa9b5C0cfa7f583dc1A6405a7d5730ADB603 <br />
**RTM:** RDg5KstHYvxip77EiGhPKYNL3TZQr6456T <br />
**AVN:** R9zSPpKjo6tCutMT5FyyGNr2vRaAssEtrm <br />
**PHL:** F7XaUosKYEXPP62o31DdpDoADo3VcxoFP4 <br />
**PEXA:** XBghzGLdeUzspUcJpeggPFLs3mAyTRHpPH <br />

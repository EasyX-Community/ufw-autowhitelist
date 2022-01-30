#!/usr/bin/env bash

# Autofilled Variables (do not change)
export vPWD=$(pwd)
export vPATH=$(echo $PATH)
export vVER=$(cat bin/.crypto-autosend.version)

if [ -f "bin/.crypto-autosend.config" ] ; then

  source bin/.crypto-autosend.config

  echo ""
  echo "crypto-autosend ${vVER}"
  echo ""

else

  echo "apt updating..."
  apt update
  echo ""

  vDIALOG=$(dpkg-query -l dialog)
  if [[ "no packages found matching" == *"${vDIALOG}"* ]]; then
    echo "installing dialog"
    echo ""
    apt install -y dialog
    echo ""
  fi

  vUFW=$(dpkg-query -l ufw)
  if [[ "no packages found matching" == *"${vUFW}"* ]]; then
    echo "installing ufw"
    echo ""
    apt install -y ufw
    echo ""
  fi

  vCONTINUEVAR=1
  while [ "$vCONTINUEVAR" == "1" ]
  do

    vHOST=""
    vHOSTCTR=0
    while : ; do

      while [ "$vHOST" == "" ]
      do
        vHOST=$(dialog --stdout --title "Configuration" \
          --backtitle "crypto-autosend ${vVER} setup" \
          --inputbox "Host ${vHOSTCTR}: " 8 60)
      done

      vHOSTCTR++;

      [[ "$vHOST" == "" ]] || break

    done



    dialog --stdout --title "Configuration" \
      --backtitle "crypto-autosend ${vVER} setup" \
      --yesno "Should I install cronjob to run every 5 min?" 10 60 \
    3>&1 1>&2 2>&3 3>&-
    vCRONJOB=$?

    dialog --stdout --title "Configuration" \
      --backtitle "crypto-autosend ${vVER} setup" \
      --yesno "Should I install cronjob to update crypto-autosend weekly?" 10 60 \
    3>&1 1>&2 2>&3 3>&-
    vCRONJOBUPDATE=$?

    if [ $vCRONJOB -eq 0 ] ; then
      vCRONJOBENG="yes"
    else
      vCRONJOBENG="no"
    fi

    if [ $vCRONJOBUPDATE -eq 0 ] ; then
      vCRONJOBUPDATEENG="yes"
    else
      vCRONJOBUPDATEENG="no"
    fi

    dialog --stdout --title "Configuration" \
      --backtitle "crypto-autosend ${vVER} setup" \
      --yesno "Is this information correct?\nRPC IP: ${vHOST}\RPC Port: ${vPORT}\nRPC User: ${vUSER}\nRPC Password: ${vPASS}\nWallet Password: ${vWALLETPASS}\nSend To Address: ${vTOADDR}\nMinimum transfer amount: ${vMINXFER}\nComment: ${vCOMMENT}\nInstall Cronjob: ${vCRONJOBENG}\nInstall Update Cronjob: ${vCRONJOBUPDATEENG}" 15 60 \
    3>&1 1>&2 2>&3 3>&-
    vCONTINUEVAR=$?

  done

  echo "" | tee bin/.crypto-autosend.config > /dev/null 2>&1
  echo "#!/usr/bin/env bash" | tee -a bin/.crypto-autosend.config > /dev/null 2>&1
  echo "" | tee -a bin/.crypto-autosend.config > /dev/null 2>&1
  echo "#" | tee -a bin/.crypto-autosend.config > /dev/null 2>&1
  echo "## coind RPC Connection Info" | tee -a bin/.crypto-autosend.config > /dev/null 2>&1
  echo "#" | tee -a bin/.crypto-autosend.config > /dev/null 2>&1
  echo "" | tee -a bin/.crypto-autosend.config > /dev/null 2>&1
  echo "# Coind settings" | tee -a bin/.crypto-autosend.config > /dev/null 2>&1
  echo "export vHOST=\"192.168.2.50\"" | tee -a bin/.crypto-autosend.config > /dev/null 2>&1
  echo "export vPORT=\"4200\"" | tee -a bin/.crypto-autosend.config > /dev/null 2>&1
  echo "export vUSER=\"myrpcusername\"" | tee -a bin/.crypto-autosend.config > /dev/null 2>&1
  echo "export vPASS=\"myrpcpassword\"" | tee -a bin/.crypto-autosend.config > /dev/null 2>&1
  echo "" | tee -a bin/.crypto-autosend.config > /dev/null 2>&1
  echo "# Wallet password to unlock wallet (leave blank for none)" | tee -a bin/.crypto-autosend.config > /dev/null 2>&1
  echo "export vWALLETPASS=\"MyRTMWalletPasswordOrSeed\"" | tee -a bin/.crypto-autosend.config > /dev/null 2>&1
  echo "" | tee -a bin/.crypto-autosend.config > /dev/null 2>&1
  echo "#" | tee -a bin/.crypto-autosend.config > /dev/null 2>&1
  echo "## General Settings" | tee -a bin/.crypto-autosend.config > /dev/null 2>&1
  echo "#" | tee -a bin/.crypto-autosend.config > /dev/null 2>&1
  echo "" | tee -a bin/.crypto-autosend.config > /dev/null 2>&1
  echo "# Address to send RTM's to" | tee -a bin/.crypto-autosend.config > /dev/null 2>&1
  echo "export vTOADDR=\"mysendtoaddress\"" | tee -a bin/.crypto-autosend.config > /dev/null 2>&1
  echo "" | tee -a bin/.crypto-autosend.config > /dev/null 2>&1
  echo "# Minimum RTM to send" | tee -a bin/.crypto-autosend.config > /dev/null 2>&1
  echo "export vMINXFER=\"15\"" | tee -a bin/.crypto-autosend.config > /dev/null 2>&1
  echo "" | tee -a bin/.crypto-autosend.config > /dev/null 2>&1
  echo "# Comment to add" | tee -a bin/.crypto-autosend.config > /dev/null 2>&1
  echo "export vCOMMENT=\"To INodez Onboarding (CRON)\"" | tee -a bin/.crypto-autosend.config > /dev/null 2>&1
  echo "" | tee -a bin/.crypto-autosend.config > /dev/null 2>&1
  echo "# Location of this repository" | tee -a bin/.crypto-autosend.config > /dev/null 2>&1
  echo "export vREPODIR=\"${vPWD}\"" | tee -a bin/.crypto-autosend.config > /dev/null 2>&1
  echo "" | tee -a bin/.crypto-autosend.config > /dev/null 2>&1

fi

source bin/.crypto-autosend.config

# CHMOD the crypto-autosend scripts
chmod +x bin/crypto-autosend*

# Check if vPWD/bin is added to $PATH
if [[ "${vPATH}" == *"${vPWD}/bin"* ]]; then
  echo "crypto-autosend directory already in path [${vPATH}]"
  echo ""
else
  echo "Adding crypto-autosend directory to \$PATH"
  echo "export PATH=${vPWD}/bin:\$PATH" | tee -a ${HOME}/.bashrc
  echo ""
  echo "Please execute 'source ${HOME}/.bashrc' or log out and back in again"
  echo ""
fi

# ADD CRYPTO-AUTOSEND CRONJOB
if [[ $vCRONJOB -eq 0 ]] ; then
  vCRONJOBENG="yes"
  vCRONENTRIES=$(crontab -l)
  if [[ "$vCRONENTRIES" != *"${vPWD}/bin/crypto-autosend ;"* ]] ; then
    echo "installing crypto-autosend cronjob"
    echo -e "$(crontab -l)\n\n# crypto-autosend cronjob" | crontab -
    echo -e "$(crontab -l)\n0 * * * * ${vPWD}/bin/crypto-autosend ;" | crontab -
  else
    echo "refusing to install crypto-autosend cron, cron already exists!"
  fi
else
  vCRONJOBENG="no"
  echo "skipping crypto-autosend cronjob install"
fi

# ADD CRYPTO-AUTOSEND-UPDATE CRONJOB
if [[ $vCRONJOBUPDATE -eq 0 ]] ; then
  vCRONJOBUPDATEENG="yes"
  vCRONENTRIES=$(crontab -l)
  if [[ "$vCRONENTRIES" != *"@weekly ${vPWD}/bin/crypto-autosend-update ;"* ]] ; then
    echo "installing crypto-autosend-update cronjob"
    echo -e "$(crontab -l)\n\n# crypto-autosend-update cronjob" | crontab -
    echo -e "$(crontab -l)\n@weekly ${vPWD}/bin/crypto-autosend-update ;" | crontab -
  else
    echo "refusing to install crypto-autosend-update cron, cron already exists!"
  fi
else
  vCRONJOBUPDATEENG="no"
  echo "skipping crypto-autosend-update cronjob install"
fi

echo ""

echo "crypto-autosend installation is complete!"
echo ""

# Clear ENV vars for security
source bin/.crypto-autosend.config.clear

#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd ${SCRIPT_DIR}

# Autofilled Variables (do not change)
export vPWD=$(pwd)
export vPATH=$(echo $PATH)
export vVER=$(cat bin/.ufw-autowhitelist.version)

# Init array of hostnames
declare -a HOSTNAMES
declare -a HOSTNAMESIPS
declare -a PREVIOUSIPS

if [ -f "bin/.ufw-autowhitelist.config" ] ; then

  source bin/.ufw-autowhitelist.config

  echo ""
  echo "ufw-autowhitelist ${vVER}"
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

  export vHOSTCTR=0
  export vCONTINUEVAR=1
  export vHOST="thiscanbeanythingtostart"
  while [ "$vCONTINUEVAR" == "1" ]
  do

    dialog --stdout --title "Configuration" \
      --backtitle "ufw-autowhitelist ${vVER} setup" \
      --inputbox "Enter hostnames, enter blank when finished" 8 60

    while : ; do

      vHOST=$(dialog --stdout --title "Configuration" \
        --backtitle "ufw-autowhitelist ${vVER} setup" \
        --inputbox "Host $vHOSTCTR (blank to finish): \n" 8 60)

      # Add host to arrays
      declare -a HOSTNAMES+=(${vHOST})

      if [[ ! -z "${vHOST}" ]] ; then
        ((vHOSTCTR+=1))
      else
        break;
      fi

    done



    dialog --stdout --title "Configuration" \
      --backtitle "ufw-autowhitelist ${vVER} setup" \
      --yesno "Should I install cronjob to run every 5 min?" 10 60 \
    3>&1 1>&2 2>&3 3>&-
    vCRONJOB=$?

    dialog --stdout --title "Configuration" \
      --backtitle "ufw-autowhitelist ${vVER} setup" \
      --yesno "Should I install cronjob to update ufw-autowhitelist weekly?" 10 60 \
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

    export vHOSTNAMESLEN=${#HOSTNAMES[@]}
    export vYESNOLEN=11

    export vYESNOCONFIRM="Is this information correct?\n\n"
    if [ $vHOSTCTR -gt 11 ] ; then
      vYESNOLEN=$vHOSTNAMESLEN+11
    fi
    for (( j=0; j<vHOSTNAMESLEN; j++ ));
    do
      vYESNOCONFIRM+="Host ${j}: ${HOSTNAMES[$j]}\n"
    done
    vYESNOCONFIRM+="\nInstall Cronjob: ${vCRONJOBENG}\nInstall Update Cronjob: ${vCRONJOBUPDATEENG}\n"

    dialog --stdout --title "Configuration" \
      --backtitle "ufw-autowhitelist ${vVER} setup" \
      --yesno "${vYESNOCONFIRM}" ${vYESNOLEN} 60 \
    3>&1 1>&2 2>&3 3>&-
    vCONTINUEVAR=$?

    if [ "$vCONTINUEVAR" == "1" ] ; then
      export vHOSTCTR=0
      export vHOST="thiscanbeanythingtostart"
      declare -a HOSTNAMES=()
    else
      break
    fi

  done

  echo "" | tee bin/.ufw-autowhitelist.config > /dev/null 2>&1
  echo "#!/usr/bin/env bash" | tee -a bin/.ufw-autowhitelist.config > /dev/null 2>&1
  echo "" | tee -a bin/.ufw-autowhitelist.config > /dev/null 2>&1
  echo "# Add or remove as many lines as you need" | tee -a bin/.ufw-autowhitelist.config > /dev/null 2>&1

  for (( j=0; j<vHOSTNAMESLEN; j++ ));
  do
    echo "declare -a HOSTNAMES+=(\"${HOSTNAMES[$j]}\")" | tee -a bin/.ufw-autowhitelist.config > /dev/null 2>&1
  done

  echo "" | tee -a bin/.ufw-autowhitelist.config > /dev/null 2>&1

fi

source bin/.ufw-autowhitelist.config

# CHMOD the ufw-autowhitelist scripts
chmod +x bin/ufw-autowhitelist*

# Check if vPWD/bin is added to $PATH
if [[ "${vPATH}" == *"${vPWD}/bin"* ]]; then
  echo "ufw-autowhitelist directory already in path [${vPATH}]"
  echo ""
else
  echo "Adding ufw-autowhitelist directory to \$PATH"
  echo "export PATH=${vPWD}/bin:\$PATH" | tee -a ${HOME}/.bashrc
  echo ""
fi

# ADD CRYPTO-AUTOSEND CRONJOB
if [[ $vCRONJOB -eq 0 ]] ; then
  vCRONJOBENG="yes"
  vCRONENTRIES=$(crontab -l)
  if [[ "$vCRONENTRIES" != *"${vPWD}/bin/ufw-autowhitelist ;"* ]] ; then
    echo "installing ufw-autowhitelist cronjob"
    echo -e "$(crontab -l)\n\n# ufw-autowhitelist cronjob" | crontab -
    echo -e "$(crontab -l)\n*/5 * * * * ${vPWD}/bin/ufw-autowhitelist ;" | crontab -
  else
    echo "refusing to install ufw-autowhitelist cron, cron already exists!"
  fi
else
  vCRONJOBENG="no"
  echo "skipping ufw-autowhitelist cronjob install"
fi

# ADD CRYPTO-AUTOSEND-UPDATE CRONJOB
if [[ $vCRONJOBUPDATE -eq 0 ]] ; then
  vCRONJOBUPDATEENG="yes"
  vCRONENTRIES=$(crontab -l)
  if [[ "$vCRONENTRIES" != *"@weekly ${vPWD}/bin/ufw-autowhitelist-update ;"* ]] ; then
    echo "installing ufw-autowhitelist-update cronjob"
    echo -e "$(crontab -l)\n\n# ufw-autowhitelist-update cronjob" | crontab -
    echo -e "$(crontab -l)\n@weekly ${vPWD}/bin/ufw-autowhitelist-update ;" | crontab -
  else
    echo "refusing to install ufw-autowhitelist-update cron, cron already exists!"
  fi
else
  vCRONJOBUPDATEENG="no"
  echo "skipping ufw-autowhitelist-update cronjob install"
fi

echo ""
echo "Please execute 'source ${HOME}/.bashrc' or log out and back in again"
echo ""
echo "ufw-autowhitelist installation is complete!"
echo ""

# Clear ENV vars for security
source bin/.ufw-autowhitelist.config.clear

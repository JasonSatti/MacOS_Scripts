#!/usr/bin/env bash
## Install Homebrew and Caskroom

## Apple approved way to get the currently logged in user
LOGGED_IN_USER=`/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys;\
 username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0];\
 username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

## Check to see if we have XCode already
CHECK_FOR_XCODE=$( pkgutil --pkgs | grep com.apple.pkg.CLTools_Executables | wc -l | awk '{ print $1 }' )

## If XCode is missing we will install the Command Line tools only as that's all Homebrew needs
if [[ "$CHECK_FOR_XCODE" != 1 ]];
then
    # This temporary file prompts the 'softwareupdate' utility to list the Command Line Tools
    touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
    CLT=$(softwareupdate -l | grep -B 1 -E "Command Line (Developer|Tools)" | awk -F"*" '/^ +\\*/ {print $2}' | sed 's/^ *//' | tail -n1)
    softwareupdate -i "$CLT"
    rm -f /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
    /usr/bin/xcode-select --switch /Library/Developer/CommandLineTools
fi

## Test if Homebrew is installed and install it if it is not
if test ! "$(sudo -u $LOGGED_IN_USER which brew)"; then
  # Jamf will have to execute all of the directory creation functions Homebrew normally does so we can bypass the need for sudo
  /bin/chmod u+rwx /usr/local/bin
  /bin/chmod g+rwx /usr/local/bin
  /usr/sbin/chown $LOGGED_IN_USER /usr/local/bin
  /usr/bin/chgrp admin /usr/local/bin
  /bin/mkdir -p /usr/local/Cellar /usr/local/Homebrew /usr/local/Frameworks /usr/local/etc /usr/local/include /usr/local/lib /usr/local/opt /usr/local/sbin /usr/local/share /usr/local/share/man/man1 /usr/local/share/zsh /usr/local/share/zsh/site-functions /usr/local/var
  /bin/chmod g+rwx /usr/local/Cellar /usr/local/Homebrew /usr/local/Frameworks /usr/local/etc /usr/local/include /usr/local/lib /usr/local/opt /usr/local/sbin /usr/local/share /usr/local/share/man/ /usr/local/share/man/man1  /usr/local/share/zsh /usr/local/share/zsh/site-functions /usr/local/var
  /bin/chmod 755 /usr/local/share/zsh /usr/local/share/zsh/site-functions /usr/local/share/man/ /usr/local/share/man/man1 
  /usr/sbin/chown $LOGGED_IN_USER /usr/local/Cellar /usr/local/Homebrew /usr/local/Frameworks /usr/local/etc /usr/local/include /usr/local/lib /usr/local/opt /usr/local/sbin /usr/local/share /usr/local/share/man/ /usr/local/share/man/man1 /usr/local/share/zsh /usr/local/share/zsh/site-functions /usr/local/var
  /usr/bin/chgrp admin /usr/local/Cellar /usr/local/Homebrew /usr/local/Frameworks /usr/local/etc /usr/local/include /usr/local/lib /usr/local/opt /usr/local/sbin /usr/local/share /usr/local/share/man/ /usr/local/share/man/man1 /usr/local/share/zsh /usr/local/share/zsh/site-functions /usr/local/var
  /bin/mkdir -p /Users/$LOGGED_IN_USER/Library/Caches/Homebrew
  /bin/chmod g+rwx /Users/$LOGGED_IN_USER/Library/Caches/Homebrew
  /usr/sbin/chown $LOGGED_IN_USER /Users/$LOGGED_IN_USER/Library/Caches/Homebrew
  /bin/mkdir -p /Library/Caches/Homebrew
  /bin/chmod g+rwx /Library/Caches/Homebrew
  /usr/sbin/chown $LOGGED_IN_USER /Library/Caches/Homebrew

  # Install Homebrew as the currently logged in user
  sudo -H -u $LOGGED_IN_USER ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"  </dev/null
# If Homebrew is already installed then just echo that there is nothing to do
else
  echo "Homebrew is already installed"
fi

  # Create folder 'Caskroom' and take ownership of it so sudo is not required 
  /bin/mkdir -p /usr/local/Caskroom
  /bin/chmod g+rwx /usr/local/Caskroom
  /bin/chmod 755 /usr/local/Caskroom
  /usr/sbin/chown $LOGGED_IN_USER /usr/local/Caskroom
  /usr/bin/chgrp admin /usr/local/Caskroom
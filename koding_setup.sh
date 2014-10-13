#!/bin/bash
#title           :koding_setup.sh
#description     :This script will setup the basic haskell/yesod develop enviornment for koding
#author		 :lingpo.huang@plowtech.net
#date            :20141010
#version         :0.1
#usage		 :bash koding_setup.sh
#notes           :Install Vim and Emacs to use this script.
#bash_version    :4.1.5(1)-release
#==============================================================================

mv /.zshrc ~/.zshrc_config
mv /.emacs ~/.emacs_config
cd $Home

# Clean up Diretory
rm *.md
rm *.sh
rm -rf ./Documents
rm -rf ./Backup

# Set up basic folders
mkdir Desktop
mkdir Documents
mkdir Downloads
mkdir Music
mkdir Pictures
mkdir Videos
mkdir Public
mkdir Share
mkdir temp

# Install basic needed packages
sudo apt-get update
sudo apt-get install -y build-essential libedit2 libglu1-mesa-dev libgmp3-dev zlib1g-dev curl
sudo apt-get install -y freeglut3-dev wget ncurses-dev libcurl4-gnutls-dev git autoconf subversion 
sudo apt-get install -y libtool

# Install other tool
RUN sudo apt-get install -y zsh
RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
RUN sudo chsh -s $(which zsh) $(whoami)

mv ~/.zshrc_config ~/.zshrc

# Install libgmp3c2
wget -c launchpadlibrarian.net/70575439/libgmp3c2_4.3.2%2Bdfsg-2ubuntu1_amd64.deb
sudo dpkg -i libgmp3c2_4.3.2*.deb
rm -rf libgmp3c2_4.3.2*.deb

# Install ghc7.8.3
wget -O ghc.tar.bz2 http://www.haskell.org/ghc/dist/7.8.3/ghc-7.8.3-x86_64-unknown-linux-deb7.tar.bz2
tar xvfj ghc.tar.bz2
cd ghc-7.8.3 && ./configure --prefix=$HOME/.ghc-7.8.3-rc11 
cd ghc-7.8.3 && make install
rm -rf ghc.tar.bz2 ghc-7.8.3
export PATH=$HOME/.ghc-7.8.3-rc11/bin:$PATH
ghc --version

# Install cabal1.20.0.3
wget -O cabal.tar.gz http://hackage.haskell.org/package/cabal-install-1.20.0.3/cabal-install-1.20.0.3.tar.gz
tar xvfz cabal.tar.gz
cd cabal-install-1.20.0.3 && ./bootstrap.sh
rm -rf cabal-install-1.20.0.3 cabal.tar.gz
export PATH=$HOME/.cabal/bin:$PATH

# Make sure cabal upto date
cabal update
cabal install cabal cabal-install 

# Add hackage plowtech
echo remote-repo: hackage.plowtech.net:http://hackage.plowtech.net/packages/archive >> ~/.cabal/config 
cabal update
cabal install yesod-bin --reinstall
cabal install alex happy hi

# Libraries for database
sudo apt-get install -y zlib1g-dev libpcre3 libpcre3-dev
sudo apt-get install -y mysql-server
sudo apt-get install -y libmysqlclient-dev

# MongoDB setup
sudo apt-get install -y mongodb

# Emacs Setup
sudo add-apt-repository ppa:cassou/emacs
sudo apt-get update
sudo apt-get install -y emacs24 emacs24-el emacs24-common-non-dfsg

mv ~/.emacs_config ~/.emacs

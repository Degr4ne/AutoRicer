#!/bin/bash

#Author: DeGr4ne

#Colors

greenColor="\e[0;32m\033[1m"
endColor="\033[0m\e[0m"
redColor="\e[0;31m\033[1m"
blueColor="\e[0;34m\033[1m"
yellowColor="\e[0;33m\033[1m"
purpleColor="\e[0;35m\033[1m"
turquoiseColor="\e[0;36m\033[1m"
grayColor="\e[0;37m\033[1m"

function Logo(){
    echo -e "\n${blueColor}"
    echo -e "\t  ___        _       ______ _"
    echo -e "\t / _ \      | |      | ___ (_)" 
    echo -e "\t/ /_\ \_   _| |_ ___ | |_/ /_  ___ ___ _ __"
    echo -e "\t|  _  | | | | __/ _ \|    /| |/ __/ _ \ '__|"
    echo -e "\t| | | | |_| | || (_) | |\ \| | (_|  __/ |"
    echo -e "\t|_| |_/\__,_|\__\___/\_| \_|_|\___\___|_|"
    echo -e "${endColor}"
}

# Variables
filePath=$(pwd)
configFiles=$filePath'/config'

function dependencies(){
    echo -e "\n${grayColor}[+] Updating the Kali Linux system.${endColor}" && sleep 0.5
    sudo apt update
    echo -e "\n${grayColor}[+] Upgrading the Kali Linux system.${endColor}" && sleep 0.5
    sudo apt upgrade -y
    echo -e "\n${grayColor}[+] Installing bspwm's dependencies.${endColor}" && sleep 0.5
    sudo apt install build-essential git vim libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev libuv1.dev -y
    echo -e "\n${grayColor}[+] Installing polybar's dependencies.${endColor}" && sleep 0.5
    sudo apt install cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev -y
    echo -e "\n${grayColor}[+] Installing picom's dependencies.${endColor}" && sleep 0.5
    sudo apt install meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libpcre3-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev -y
    sudo apt install terminator feh bspwm flameshot rofi acpi wmname lxsession xclip -y
}

function bspwm_sxhkd(){

    echo -e "\n${grayColor}[+] Installing bspwm and sxhkd.${endColor}" && sleep 0.5
    cd ~/.config
    git clone https://github.com/baskerville/bspwm.git
    git clone https://github.com/baskerville/sxhkd.git
    cd bspwm && make && sudo make install
    cd ../sxhkd && make && sudo make install

    # coping sxhkdrc configuration
    # this configuration don't work for windows in floating mode
    cp $configFiles"/sxhkdrc" ~/.config/sxhkd/
     
    cd ~/.config/bspwm
    touch bspwmrc
    # coping bspwmrc configuration
    cat $configFiles"/bspwmrc" | sed "s/username/$(whoami)/g" > ~/.config/bspwm/bspwmrc
    # coping wallpaper to ~/.config/bspwm
    cp $configFiles"/mr-robot.jpg" ~/.config/bspwm/
    chmod +x ~/.config/bspwm/bspwmrc

    sudo rm -r artworks/ contrib/ doc/ src/ tests/ bspc bspc.o bspwm bspwm.o desktop.o events.o ewmh.o geometry.o helpers.o history.o jsmn.o LICENSE Makefile messages.o monitor.o parse.o pointer.o query.o README.md restore.o rule.o settings.o Sourcedeps stack.o subscribe.o tree.o VERSION window.o
    cd ../sxhkd
    sudo rm -r contrib/ doc/ examples/ src/ grab.o helpers.o LICENSE Makefile parse.o README.md Sourcedeps sxhkd sxhkd.o types.o VERSION
}

function polybar(){

    cd ~/.config
    
    echo -e "\n${grayColor}[+] Installing polybar.${endColor}" && sleep 0.5
    
    git clone --recursive https://github.com/polybar/polybar
    git clone https://github.com/ibhagwan/picom.git

    cd polybar
    mkdir build
    cd build
    cmake ..
    make -j$(nproc)
    sudo make install
    
    echo -e "\n${grayColor}[+] Installing picom.${endColor}" && sleep 0.5
    
    cd ~/.config/picom
    git submodule update --init --recursive
    meson --buildtype=release . build
    ninja -C build
    
    sudo ninja -C build install
    sudo rm -r *.md *.conf *.desktop *.txt *.build *.spdx *.glsl COPYING Doxyfile CONTRIBUTORS bin/ build/ dbus-examples/ LICENSES/ man/ media/ meson/ src/ subprojects/ tests/
    cp $configFiles"/picom.conf" .

    font
    
    cd ~/.config/polybar
    # https://github.com/Murzchnvok/polybar-collection for more awesome themes
    cp -r $configFiles"/murz" .
    chmod +x murz/{hackthebox.sh,ipmachine.sh,launch.sh,targetmachine.sh} 
}

function font(){
    
    echo -e "\n${grayColor}[+] Installing Hack Nerd Font.${endColor}" && sleep 0.5
	sudo wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip -O /usr/local/share/fonts/Hack.zip
	sudo unzip /usr/local/share/fonts/Hack.zip -d /usr/local/share/fonts/
	sudo rm /usr/local/share/fonts/Hack.zip
	
    echo -e "\n${grayColor}[+] Installing JetBrainsMono Nerd Font.${endColor}" && sleep 0.5
	sudo wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip -O /usr/local/share/fonts/JetBrainsMono.zip
	sudo unzip /usr/local/share/fonts/JetBrainsMono.zip -d /usr/local/share/fonts/
    sudo rm /usr/local/share/fonts/JetBrainsMono.zip
    
    echo -e "\n${grayColor}[+] Installing Iosevka Nerd Font.${endColor}" && sleep 0.5
	sudo wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.2/Iosevka.zip -O /usr/local/share/fonts/Iosevka.zip
	sudo unzip /usr/local/share/fonts/Iosevka.zip -d /usr/local/share/fonts/
    sudo rm /usr/local/share/fonts/Iosevka.zip

    

}

function p10k(){
    
    echo -e "\n${grayColor}[+] Installing Powerevel10k.${endColor}" && sleep 0.5
    username=$(whoami)
    
    cp -v $configFiles"/.zshrc" ~/
    sudo ln -sfv ~/.zshrc /root/.zshrc
    cp -v $dir/.p10k.zsh ~/.p10k.zsh
    sudo ln -sfv ~/.p10k.zsh /root/.p10k.zsh

    cd ~
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.config/powerlevel10k
    sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.config/powerlevel10k
    
    sudo usermod --shell /usr/bin/zsh $username 2>/dev/null
	sudo usermod --shell /usr/bin/zsh root 2>/dev/null
    
	sudo apt install zsh-syntax-highlighting zsh-autosuggestions -y
	cd /usr/share 
    sudo mkdir zsh-sudo
    cd zsh-sudo 
    sudo wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh
	sudo chmod +x /usr/share/zsh-sudo/sudo.plugin.zsh
	cd /usr/share 
    sudo chown $username:$username -R zsh-*
    
    echo -e "\n${redColor}[+] Proceed to logout and select bspwn.${endColor}" && read
    
}

function config(){
    
    echo -e "\n${grayColor}[+] Terminator,rofi and vim configuration.${endColor}" && sleep 0.5
    # Terminator configuration
    mkdir -p ~/.config/terminator
    cp $configFiles"/config" ~/.config/terminator/
    
    # rofi theme
    sudo cp $configFiles"/murz.rasi" /usr/share/rofi/themes/murz.rasi 
    mkdir -p ~/.config/rofi
    touch ~/.config/rofi/config.rasi
    echo "@theme \"/usr/share/rofi/themes/murz.rasi\"" >> ~/.config/rofi/config.rasi
    
    # vim color scheme
    cp $configFiles"/.vimrc" ~/
    mkdir -p ~/.vim/colors
    cp $configFiles"/angr.vim" ~/.vim/colors
    sudo ln -s ~/.vimrc /root/.vimrc
    sudo ln -s ~/.vim /root/.vim
    
    echo -e "\n${grayColor}[+] Installing lsd.${endColor}" && sleep 0.5
    cd /opt 
    sudo wget https://github.com/Peltoche/lsd/releases/download/0.20.1/lsd_0.20.1_amd64.deb
	sudo dpkg -i lsd_0.20.1_amd64.deb
    sudo rm lsd_0.20.1_amd64.deb
}

Logo
dependencies
bspwm_sxhkd
polybar
config
p10k

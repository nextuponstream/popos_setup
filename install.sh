#!/bin/bash

# This script was tested with Pop_!OS 21.04. This script does:
# - configure sensible default for the desktop environnement
# - download some apps and projects for productivity
# - sets up a Neovim environnement
# - sets up steam to play Windows games with the help of Proton and Wine(tricks)

# update_terminal_configurations takes an array and update various terminal
# configuration files
#
# from: https://askubuntu.com/a/674347
function update_terminal_configurations() {
	lines=("$@") # array
	for line in "${lines[@]}"; do
		echo $line >> $HOME/.bashrc
		echo $line >> $HOME/.zshrc
	done

	# note: update_terminal_configurations "${array[@]}"
}

echo "*************"
echo "***GENERAL***"
echo "*************"
sudo apt update && \
sudo apt upgrade -y

sudo apt install neofetch
gsettings set \
	org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0
	
echo "Change bootloader"
sudo apt install refind # bootloader
# bootloader theme
sudo bash -c \
"$(curl -fsSL https://raw.githubusercontent.com/bobafetthotmail/refind-theme-regular/master/install.sh)"

echo "**********"
echo "***MISC***"
echo "**********"
echo "* updating general appearance"
# note: dconf watch /
# allows to see which variables in settings are affected
gsettings set org.gnome.shell.extensions.pop-shell gap-inner 1
gsettings set org.gnome.shell.extensions.pop-shell gap-outer 1
gsettings set org.gnome.shell.extensions.pop-shell active-hint true
gsettings set org.gnome.shell.extensions.pop-shell hint-color-rgba \
	'rgb(68,68,68)'
	
gsettings set org.gnome.shell.extensions.pop-cosmic \
	show-workspaces-button false
gsettings set org.gnome.shell.extensions.pop-cosmic \
show-applications-button false
	
gsettings set org.gnome.desktop.interface show-battery-percentage true

gsettings set org.gnome.shell.extensions.dash-to-dock multi-monitor true
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock intellihide true
gsettings set org.gnome.shell.extensions.dash-to-dock intellihide-mode \
	'ALL_WINDOWS'
gsettings set org.gnome.shell favorite-apps "[\
'firefox.desktop',
'org.gnome.Nautilus.desktop',
'org.gnome.Terminal.desktop',
'gnome-control-center.desktop'
]"

gsettings set org.gnome.desktop.notifications show-banners false
 
# Note: zsh auto-completion helped noticing FileChooser not being file-chooser
# as seen in 'dconf watch /'
gsettings set org.gtk.Settings.FileChooser show-hidden true

gsettings set org.gnome.shell.extensions.ding show-drop-place false
gsettings set org.gnome.shell.extensions.ding show-trash true
gsettings set org.gnome.shell.extensions.ding show-network-volumes true
gsettings set org.gnome.shell.extensions.ding show-home true
gsettings set org.gnome.shell.extensions.ding show-volumes true

gsettings set org.gnome.nautilus.preferences show-delete-permanently true

gsettings set org.gnome.desktop.peripherals.mouse accel-profile 'flat'
gsettings set org.gnome.desktop.peripherals.mouse speed 0

gsettings set org.gnome.desktop.screensaver lock-enabled 'false'

echo "* changing desktop background"
WALLPAPERS_DIRECTORY=$HOME/Pictures/wallpapers
BACKGROUND_IMG=$WALLPAPERS_DIRECTORY/persona_background.jpg
mkdir -p $WALLPAPERS_DIRECTORY && \
	wget https://imgur.com/CtPh7j5.jpg -O $BACKGROUND_IMG

# changing image
gsettings set org.gnome.desktop.background picture-uri file://$BACKGROUND_IMG

echo "* installing zsh"
sudo apt install zsh -y
yes | sh -c "$(wget -O- \
https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -y

chsh -s $(which zsh)

echo "* adding GIT alias"
aliases=(
"gpl=\"git pull\""
"gap=\"git add .\""
"gcm=\"git commit -m\""
"gam=\"git commit -am\""
"gps=\"git push\""
"gst=\"git status\""
"gch=\"git checkout\""
"gcb=\"git checkout -b\""
"gbd=\"git branch -d\""
"gbr=\"git branch\""
)

args=()
for i in "${aliases[@]}"; do
	args+=("alias $i")
done

update_terminal_configurations "${args[@]}"

echo "* customizing terminal plugins"
sudo echo "plugins=(git github gitignore golang scala sbt colorize cp docker 
debian)" >> $HOME/.zshrc

echo "* customizing terminal prompt"

# time: https://askubuntu.com/a/770970
# color: https://www.tecmint.com/customize-bash-colors-terminal-prompt-linux/
# non printing caracters like \e: https://stackoverflow.com/a/14225726
# copy-paste emojis: https://emojipedia.org/search/?q=sloth
echo "export PS1=\"\[\e[1;32m\]\t \w 🐬🏐🐋🌴🍹 \[\e[0;37m\]\"" >> $HOME/.bashrc

echo "**********"
echo "***Apps***"
echo "**********"
apps=(
	org.gnome.Rhythmbox3
	com.calibre_ebook.calibre
	org.texstudio.TeXstudio
	org.telegram.desktop
	com.discordapp.Discord
	org.mozilla.Thunderbird
	org.gnome.EasyTAG
	org.videolan.VLC
	com.github.PintaProject.Pinta
)

flatpak remote-add --if-not-exists flathub \
	https://dl.flathub.org/repo/flathub.flatpakrepo
for a in "${apps[@]}"; do
	sudo flatpak install -y flathub $a
done

gsettings set org.gnome.shell favorite-apps "[\
'org.telegram.desktop.desktop',
'com.discordapp.Discord.desktop',
'org.mozilla.Thunderbird.desktop',
'firefox.desktop',
'org.gnome.Nautilus.desktop',
'com.calibre_ebook.calibre.desktop',
'org.gnome.Terminal.desktop',
'gnome-control-center.desktop'
]"

echo "************"
echo "***Coding***"
echo "************"
echo "* installing nerdfont"
NF=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest \
| grep /FiraMono.zip | awk '{ print $2 }' | sed 's/,$//' | sed 's/"//g')
curl --create-dirs --output-dir $HOME/.local/share/fonts -JLO $NF
unzip $HOME/.local/share/fonts/FiraMono.zip -d $HOME/.local/share/fonts
rm $HOME/.local/share/fonts/FiraMono.zip

echo "* modify current terminal default settings"
# disable default cursor color in neovim
profileName='TakeCare'
gnome_default_uuid=$(gsettings get org.gnome.Terminal.ProfilesList default | \
tr -d "'")
gsettings set \
org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_default_uuid/ \
visible-name $profileName
gsettings set \
org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_default_uuid/ \
use-system-font "false"
gsettings set \
org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_default_uuid/ \
scrollback-unlimited "true"
gsettings set \
org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_default_uuid/ \
cursor-colors-set "false"
gsettings set \
org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_default_uuid/ \
bold-color-same-as-fg "true"
gsettings set \
org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_default_uuid/ \
highlight-colors-set "false"
gsettings set \
org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_default_uuid/ \
use-theme-colors "false"

# set font of default profile
# Note: this can take some time to be applied. This may lead to weird spacing
# for a while but do not panic, this get fixed by itself (in my experience).
gsettings set \
org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_default_uuid/ \
font 'FiraMono Nerd Font Mono 12'

echo "* installing neovim"
sudo apt install neovim

args=(
	"alias vim=\"nvim\""
	"alias vim-real=\"vim\""
)
update_terminal_configurations "${args[@]}"

echo "* installing neovim plugin manager"
# coupled with init.vim at plugins declaration
mkdir -p $HOME/.config/nvim/plugins
sh -c 'curl -fLo \
"${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim \
--create-dirs \
https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

echo "* installing plugins from neovim configuration"
mkdir -p $HOME/.config/nvim && \
	cp init.vim $HOME/.config/nvim/init.vim
nvim --headless +PlugInstall +qa

echo "* coc extensions"
nvim --headless +'CocInstall -sync $extensions' +qall

# from: 
# https://github.com/neoclide/coc.nvim/wiki/Install-coc.nvim#automation-script
sudo curl -sL install-node.now.sh | sudo bash
npm --version

mkdir -p $HOME/.config/coc/extensions
cd $HOME/.config/coc/extensions

# coc-jedi prerequisite
sudo apt install python3.9-venv

# Note: there is a dependency with init.vim global coc extensions list 
extensions=(
coc-calc
coc-css
coc-eslint
coc-git
coc-go
coc-html
coc-json
coc-markdownlint
coc-metals
coc-rust-analyzer
coc-sh
coc-sql
coc-texlab
coc-toml
coc-xml
coc-yaml
coc-jedi
coc-pydocstring
)

echo "* installing coc extensions ${extensions[@]}"

# Change extension names to the extensions you need
npm install ${extensions[@]} \
	--global-style \
	--ignore-scripts \
	--no-bin-links \
	--no-package-lock \
	--only=prod
cd

echo "* installing Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env # this file sets $PATH and makes cargo available
cargo --version

echo "* installing Go"
# this is not officially supported but mentionned
# https://github.com/golang/go/wiki/Ubuntu
sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt update
sudo apt install golang-go

args=(
"export PATH=\$PATH:$HOME/go/bin"
)

update_terminal_configurations "${args[@]}"

export PATH="$HOME/go/bin:$PATH" # for current shell
go version

echo "* installing air for golang developpement"
curl -sSfL https://raw.githubusercontent.com/cosmtrek/air/master/install.sh | \
	sh -s -- -b $(go env GOPATH)/bin
air -v 

echo "* installing conda for python dev"
python3 --version
# https://dev.to/waylonwalker/installing-miniconda-on-linux-from-the-command-line-4ad7
mkdir -p $HOME/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O \
$HOME/miniconda3/miniconda.sh
bash $HOME/miniconda3/miniconda.sh -b -u -p $HOME/miniconda3
rm -rf $HOME/miniconda3/miniconda.sh
# update bash/zshrc with conda init
$HOME/miniconda3/bin/conda init bash
$HOME/miniconda3/bin/conda init zsh
export PATH=$PATH:$HOME/miniconda3/bin
conda --version
# remove "(base)" from terminal prompt
conda config --set auto_activate_base false

echo "******************"
echo "***Productivity***"
echo "******************"
echo "todo app"
cd $HOME/Public
git clone https://github.com/nextuponstream/todo.git
cd todo
cargo build --release
sudo ln -s $HOME/Public/todo/target/release/todo /bin/todo
todo --version

echo "CLI presentation"
cd $HOME/Public
git clone https://github.com/maaslalani/slides.git
cd slides
go install
cd
slides --help

echo "***********"
echo "***Games***"
echo "***********"
echo "* steam install"
sudo apt upgrade # clean up file from first time installation I guess
sudo apt autoremove
sudo apt install steam

echo "* proton prerequisite: wine"
cd $HOME
wget -nc https://dl.winehq.org/wine-builds/winehq.key
sudo -H gpg -o /etc/apt/trusted.gpg.d/winehq.key.gpg --dearmor winehq.key
sudo add-apt-repository \
	'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main'
sudo apt update
sudo apt install --install-recommends winehq-stable
wine --version
rm winehq.key

echo "* proton prerequisite: winetricks"
sudo apt-get purge winetricks
cd "${HOME}/Downloads"
wget \
https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
chmod +x winetricks
sudo mv winetricks /usr/local/bin
rm $HOME/winehq.key
sudo apt autoremove

echo "Installation first part is over. Now rebooting"
gnome-session-quit --logout

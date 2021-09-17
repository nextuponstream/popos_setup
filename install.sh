#!/bin/bash

echo "**********"
echo "***MISC***"
echo "**********"
echo "* Changing desktop background"
WALLPAPERS_DIRECTORY=$HOME/Pictures/wallpapers
BACKGROUND_IMG=$WALLPAPERS_DIRECTORY/persona_background.jpg
mkdir -p $WALLPAPERS_DIRECTORY && \
	wget https://imgur.com/CtPh7j5.jpg -O $BACKGROUND_IMG

# changing image
gsettings set org.gnome.desktop.background picture-uri file://$BACKGROUND_IMG

echo "* adding zsh"
apt install zsh -y
yes | sh -c "$(wget -O- \
https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -y

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
for i in "${aliases[@]}"; do
	echo "alias $i" >> $HOME/.bashrc
	echo "alias $i" >> $HOME/.zshrc
done

echo "* customizing terminal plugins"
echo "plugins=(git github gitignore golang scala sbt colorize cp docker 
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
flatpak install \
	rhythmbox \
	calibre \
	texstudio \
	rhythmbox \
	telegram \
	thunderbird \
	easytag \
	steam \
	vlc \
	-y

echo "***********"
echo "***Games***"
echo "***********"
echo "* Adding proton flavor to make games work"
PROTON_OUTPUT_DIR=$HOME/.steam/root/compatibilitytools.d
mkdir -p $PROTON_OUTPUT_DIR
# https://gist.github.com/gvenzl/1386755861fb42db492276d3864a378c#gistcomment-3651279
GE_PROTON=$(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-cust\
om/releases/latest \
| grep browser_download_url | grep .tar.gz | awk '{ print $2 }' | sed 's/,$//' \
| sed 's/"//g' )
curl --create-dirs --output-dir $PROTON_OUTPUT_DIR \
	-JLO $GE_PROTON
for f in $PROTON_OUTPUT_DIR/*.tar.gz; do
	tar -xf "$f" -C "$PROTON_OUTPUT_DIR"
	rm $f
done

games=(
	570 # dota 2
	1384160 # GGST
)

echo "* installing steam games"
echo "note: You can quit steam to launch the next command."
for game in "${games[@]}"; do
	# I think you have to quit steam in between each command
	steam steam://install/$game
	read -p "Are you done installing game $game? [Yy] " -n 1 -r
	echo    # (optional) move to a new line
done

### ======
echo "Logging out so zsh shell change take effect"
gnome-session-quit

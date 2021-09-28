#!/bin/zsh

echo "* launching steam once"
echo "Enable steam Play under Steam > settings > Steam Play"
echo "Once down, close steam and proceed with the installation"
steam

# xbox one controller wireless driver
# TODO tried but unable to make it work again (reconnection problem). 
# Wired controller works though.
#git clone https://github.com/atar-axis/xpadneo.git
#cd xpadneo
#sudo ./install.sh
#cd $HOME

#sudo bluetoothctl
# scan on
# press the pairing button with the controller
# copy the MAC address
# scan off
# pair MAC
# trust MAC
# connect MAC

echo "* Adding Proton GloriousEggroll flavor to make games work"
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
	sudo tar -xf "$f" -C "$PROTON_OUTPUT_DIR" # with root permissions
	rm $f
done
echo "* Set Proton-GE to your games and play..."            
steam                                             

echo "Installation is over."

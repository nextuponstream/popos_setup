# Pop!_OS setup

This is a minimal setup for developping and playing steam games with Pop!_OS
21.04. The install scripts set up:

* (neo)vim
* zsh
* many applications flatpacks
* rust+go+python developpement
* desktop environnement
* steam + wine + winetricks to play games that work better with custom Proton
versions.

![desktop example](img/de-example.png)

## Usage

```bash
chmod +x install.sh post-reboot.sh
./install.sh

# Accept reboot...

./post-reboot.sh
```

**Note**: User profile picture has to be changed manually.

## Desktop entries

Drop the `.desktop` file in your Desktop, open Properties, left-click the icon
to change the icon with an image of your own.

## Notes

As of 28.09.2021, this install script was iterated upon 10-20 times
(meaning the installation process was performed 10-20 times). With good internet
speed, going from wiping everything to having essentials applications installed
takes around ~15 minutes, while configuring steam (one reboot and many client
restarts) takes ~20 minutes more.

The specs of the computer which was under test are:

* OS: Pop!_OS 21.04 x86_64
* Host: OMEN by HP Laptop 17-cb1xxx
* CPU: Intel i7-10750H (12) @ 5.000GHz
* GPU: NVIDIA GeForce RTX 2060 Mobile
* Memory: 15840MiB

This script was not made for other users in mind but please feel free to take
inspiration for your own install script. I am currently feeling at home with
Pop!_OS and I do not plan on changing OS for a LONG time (hence why I made that
script).

#!/bin/bash
sudo apt install default-jdk
sudo apt update && apt -y upgrade
if [ ${ps aux | grep forge} == "" ]; then
wget -O forge-1.12.2-14.23.5.2854-installer.jar #**DIRECT_DOWNLOAD_LINK_GOES_HERE**
sudo java -jar ~/opt/minecraft/forge-1.12.2-14.23.5.2854-installer.jar --installServer
cat >~/opt/minecraft/eula.txt<<EOF
#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).
#Thu Mar 25 20:00:00 UTC 2021
eula=true
EOF
cat >/etc/init/startServer.sh<<EOF
#!/bin/bash
# Starts the forge server
sudo java -Xms1024M -Xmx4000M -jar ~/opt/minecraft/forge-1.12.2-14.23.5.2854.jar --nogui
EOF
cat >/etc/init/stopServer.sh<<EOF
#!/bin/bash
# Grabs and kill a process from the pidlist that has the word forge
pid=`ps aux | grep forge | awk '{print $2}'`
kill -9 $pid
EOF
cat >/etc/init.d/forgeServer<<EOF
#!/bin/bash
# ForgeServer
case $1 in
    start)
        /bin/bash /etc/init/startServer.sh
    ;;
    stop)
        /bin/bash /etc/init/stopServer.sh
    ;;
    restart)
        /bin/bash /etc/init/stopServer.sh
        /bin/bash /etc/init/startServer.sh
    ;;
esac
exit 0
EOF
sudo update-rc.d forgeServer defaults
fi
/etc/init.d/forgeServer start
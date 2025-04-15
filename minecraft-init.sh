#!/bin/bash

# Asegura que se ejecuta como root
if [ "$EUID" -ne 0 ]; then
  echo "Este script debe ejecutarse como root" >&2
  exit 1
fi

# Actualiza sistema e instala Java
apt-get update
apt-get install -y openjdk-17-jre-headless screen wget

# Crea usuario para Minecraft (sin acceso a login)
useradd -r -m -d /opt/minecraft -s /usr/sbin/nologin minecraft

# Crea carpeta del servidor
mkdir -p /opt/minecraft/server

# Descarga el servidor oficial
wget https://piston-data.mojang.com/v1/objects/f69c284232d7c7580bd89a5a4931c3581eae1378/server.jar -O /opt/minecraft/server/server.jar

# Acepta EULA automáticamente
echo "eula=true" > /opt/minecraft/server/eula.txt

# Asigna permisos al usuario minecraft
chown -R minecraft:minecraft /opt/minecraft

# Crea archivo del servicio systemd
cat <<EOF > /etc/systemd/system/minecraft.service
[Unit]
Description=Minecraft Server
After=network.target

[Service]
User=minecraft
WorkingDirectory=/opt/minecraft/server
ExecStart=/usr/bin/java -Xmx2G -Xms1G -jar server.jar nogui
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Recarga systemd, habilita e inicia el servicio
systemctl daemon-reload
systemctl enable minecraft
systemctl start minecraft
# Minecraft Server on Azure with Terraform

[English](#minecraft-server-on-azure-with-terraform) | [Español](#servidor-de-minecraft-en-azure-con-terraform)

This project contains Terraform configuration files to deploy a Minecraft server on Azure. It automatically provisions all necessary infrastructure including a virtual machine, networking components, and security settings to run a Minecraft server in the cloud.

## Project Overview

This Terraform project creates:
- Azure Resource Group in East US region
- Virtual Network and Subnet
- Network Security Group with rules for Minecraft (25565) and SSH (22)
- Public IP address (static)
- Ubuntu 22.04 LTS Virtual Machine (Standard_B1ms)
- Network interface with security group association

## Prerequisites

Before you begin, ensure you have:

1. **Terraform installed** (version 1.0.0 or newer)
   - [Download from terraform.io](https://www.terraform.io/downloads.html)
   - Verify with: `terraform -v`

2. **Azure CLI installed**
   - [Installation instructions](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
   - Verify with: `az --version`

3. **Azure subscription**
   - You will need your Subscription ID

4. **SSH Key Pair**
   - Generate with: `ssh-keygen -t rsa -b 4096`
   - Save the public key path for terraform.tfvars (you can save in a .ssh folder on the root)

5. **Minecraft initialization script**
   - Create a file named `minecraft-init.sh` with server setup commands

## Configuration

1. Create a `local.tfvars` file with your specific values:

```hcl
subscription_id = "your-azure-subscription-id"
ssh_public_key  = "path/to/id_rsa.pub"
```

Optional configuration (defaults provided in variables.tf):
```hcl
location      = "East US"
project       = "minecraftserver"
environment   = "gaming"
vm_size       = "Standard_B1ms"
admin_username = "minecraft"
```

## Deployment Steps

### Azure CLI Setup

1. **Login to Azure CLI**:
   ```
   az login
   ```

2. **Set your subscription** (if you have multiple):
   ```
   az account set --subscription "your-subscription-id"
   ```

3. **Verify active subscription**:
   ```
   az account show
   ```

### Terraform Deployment

1. **Initialize Terraform** (downloads providers and modules):
   ```
   terraform init
   ```

2. **Preview the changes** (create a deployment plan):
   ```
   terraform plan -var-file="local.tfvars"
   ```

3. **Apply the configuration** (create the resources):
   ```
   terraform apply -var-file="local.tfvars"
   ```

4. **View outputs** (after deployment):
   ```
   terraform output
   ```
   Note the `minecraft_public_ip` value for connecting to your server.

## Verification and Access

### SSH to the Virtual Machine

```
ssh minecraft@<public-ip-address>
```

### Verify Minecraft Server

1. **Check if the server process is running**:
   ```
   ps aux | grep java
   ```

2. **View server logs**:
   ```
   sudo journalctl -u minecraft
   ```

3. **Connect to the server** from Minecraft client:
   - Server address: `<public-ip-address>:25565`

## Resource Cleanup

When you're done with the Minecraft server, you can destroy all resources to avoid unnecessary charges:

```
terraform destroy
```

This will remove all resources created by this Terraform project.

## Troubleshooting

1. **Cannot connect to Minecraft server**:
   - Verify NSG rules allow traffic on port 25565
   - Check if the Minecraft service is running on the VM
   - Ensure your client is using the correct Minecraft version

2. **SSH connection issues**:
   - Verify NSG rules allow traffic on port 22
   - Check that you're using the correct username and SSH key

## Custom Modifications

- To change VM size: edit `size` in vms.tf
- To modify network settings: edit networks.tf
- To adjust server configuration: modify minecraft-init.sh

## Additional Resources

- [Terraform Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Minecraft Server Setup Guide](https://minecraft.net/en-us/download/server/)
- [Azure VM Sizes and Pricing](https://azure.microsoft.com/en-us/pricing/details/virtual-machines/)

---

# Servidor de Minecraft en Azure con Terraform

Este proyecto contiene archivos de configuración de Terraform para desplegar un servidor de Minecraft en Azure. Aprovisiona automáticamente toda la infraestructura necesaria, incluyendo una máquina virtual, componentes de red y configuraciones de seguridad para ejecutar un servidor de Minecraft en la nube.

## Descripción General del Proyecto

Este proyecto de Terraform crea:
- Grupo de Recursos de Azure en la región Este de EE.UU. (East US)
- Red Virtual y Subred
- Grupo de Seguridad de Red con reglas para Minecraft (25565) y SSH (22)
- Dirección IP pública (estática)
- Máquina Virtual Ubuntu 22.04 LTS (Standard_B1ms)
- Interfaz de red con asociación de grupo de seguridad

## Requisitos Previos

Antes de comenzar, asegúrate de tener:

1. **Terraform instalado** (versión 1.0.0 o más reciente)
   - [Descargar desde terraform.io](https://www.terraform.io/downloads.html)
   - Verificar con: `terraform -v`

2. **Azure CLI instalado**
   - [Instrucciones de instalación](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
   - Verificar con: `az --version`

3. **Suscripción de Azure**
   - Necesitarás tu ID de Suscripción

4. **Par de Claves SSH**
   - Generar con: `ssh-keygen -t rsa -b 4096`
   - Guardar la ruta de la clave pública para terraform.tfvars

5. **Script de inicialización de Minecraft**
   - Crear un archivo llamado `minecraft-init.sh` con comandos de configuración del servidor

## Configuración

1. Crear un archivo `local.tfvars` con tus valores específicos:

```hcl
subscription_id = "tu-id-de-suscripción-de-azure"
ssh_public_key  = "ruta/a/id_rsa.pub"
```

Configuración opcional (valores predeterminados proporcionados en variables.tf):
```hcl
location      = "East US"
project       = "minecraftserver"
environment   = "gaming"
vm_size       = "Standard_B1ms"
admin_username = "minecraft"
```

## Pasos de Despliegue

### Configuración de Azure CLI

1. **Iniciar sesión en Azure CLI**:
   ```
   az login
   ```

2. **Establecer tu suscripción** (si tienes varias):
   ```
   az account set --subscription "tu-id-de-suscripción"
   ```

3. **Verificar la suscripción activa**:
   ```
   az account show
   ```

### Despliegue con Terraform

1. **Inicializar Terraform** (descarga proveedores y módulos):
   ```
   terraform init
   ```

2. **Validar la configuración**:
   ```
   terraform validate
   ```

3. **Previsualizar los cambios** (crear un plan de despliegue):
   ```
   terraform plan -var-file="local.tfvars"
   ```

4. **Aplicar la configuración** (crear los recursos):
   ```
   terraform apply -var-file="local.tfvars"
   ```

5. **Ver salidas** (después del despliegue):
   ```
   terraform output
   ```
   Anota el valor de `minecraft_public_ip` para conectarte a tu servidor.

## Verificación y Acceso

### SSH a la Máquina Virtual

```
ssh minecraft@<dirección-ip-pública>
```

### Verificar el Servidor de Minecraft

1. **Comprobar si el proceso del servidor está ejecutándose**:
   ```
   ps aux | grep java
   ```

2. **Ver los registros del servidor**:
   ```
   sudo journalctl -u minecraft
   ```

3. **Conectarse al servidor** desde el cliente de Minecraft:
   - Dirección del servidor: `<dirección-ip-pública>:25565`

## Limpieza de Recursos

Cuando hayas terminado con el servidor de Minecraft, puedes destruir todos los recursos para evitar cargos innecesarios:

```
terraform destroy
```

Esto eliminará todos los recursos creados por este proyecto de Terraform.

## Solución de Problemas

1. **No puedo conectarme al servidor de Minecraft**:
   - Verifica que las reglas NSG permitan tráfico en el puerto 25565
   - Comprueba si el servicio de Minecraft está ejecutándose en la VM
   - Asegúrate de que tu cliente esté usando la versión correcta de Minecraft

2. **Problemas de conexión SSH**:
   - Verifica que las reglas NSG permitan tráfico en el puerto 22
   - Comprueba que estés usando el nombre de usuario y la clave SSH correctos

## Modificaciones Personalizadas

- Para cambiar el tamaño de la VM: edita `vm_size` en terraform.tfvars
- Para modificar la configuración de red: edita networks.tf
- Para ajustar la configuración del servidor: modifica minecraft-init.sh

## Recursos Adicionales

- [Documentación del Proveedor Azure para Terraform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Guía de Configuración del Servidor de Minecraft](https://minecraft.net/en-us/download/server/)
- [Tamaños y Precios de VM de Azure](https://azure.microsoft.com/en-us/pricing/details/virtual-machines/)

# ☁️ Azure Cloud Architecture: High Availability & Secure Deployment (TFG)

[![Terraform](https://img.shields.io/badge/Infrastructure-Terraform-623CE4?logo=terraform)](https://www.terraform.io/)
[![Ansible](https://img.shields.io/badge/Config-Ansible-EE0000?logo=ansible)](https://www.ansible.com/)
[![Docker](https://img.shields.io/badge/Container-Docker-2496ED?logo=docker)](https://www.docker.com/)
[![Azure](https://img.shields.io/badge/Cloud-Azure-0078D4?logo=microsoftazure)](https://azure.microsoft.com/)

Este repositorio contiene el **despliegue automatizado** de una infraestructura web en **Alta Disponibilidad** sobre **Microsoft Azure**. El proyecto aplica el paradigma de **Infraestructura como Código (IaC)** y principios de **hardening** para garantizar un entorno **seguro, escalable y reproducible**.
![Status](https://img.shields.io/badge/status-en%20desarrollo-yellow)

## 🚧 Proyecto en construcción

Pendiente de implementación:
- Azure Pipeline
- Azure Key Vault
---

## 🏗️ Arquitectura del Proyecto

La solución se basa en una **arquitectura de tres capas** diseñada para eliminar puntos únicos de fallo (SPOF):

* **Capa de Acceso (Networking):** Un **Azure Load Balancer** distribuye el tráfico **HTTPS** de forma equitativa entre los nodos.
* **Capa de Aplicación (Compute):** Dos máquinas virtuales **Ubuntu 22.04** ejecutan **Docker** y están orquestadas con **Docker Compose**. Cada nodo cuenta con **Nginx** como *reverse proxy* y **WordPress** como aplicación.
* **Capa de Datos (PaaS):** Servicio gestionado **Azure Database for MySQL (Flexible Server)**, que aporta **persistencia**, **alta disponibilidad del servicio** y **copias de seguridad automáticas**.

---

## 🛠️ Stack Tecnológico

| Herramienta        | Función                                                                                      |
| ------------------ | -------------------------------------------------------------------------------------------- |
| **Terraform**      | Aprovisionamiento de red (VNET, subnets, NSG), máquinas virtuales y base de datos.           |
| **Ansible**        | Automatización de la configuración, hardening del sistema operativo e instalación de Docker. |
| **Docker Compose** | Orquestación de contenedores (WordPress + Nginx).                                            |
| **Azure DevOps**   | Gestión del ciclo de vida del proyecto y *pipelines* de despliegue (CI/CD).                  |

---

## 🔒 Seguridad (Hardening por Diseño)

Para cumplir con los requisitos de seguridad del TFG, se han implementado las siguientes medidas:

1. **Gestión de secretos:** Uso de variables de entorno y archivos `.env` (excluidos del control de versiones) para evitar *hardcoded secrets*.
2. **Conexiones cifradas:** Comunicación obligatoria mediante **SSL/TLS** tanto en el acceso web (Nginx) como en la conexión con **Azure Database for MySQL**.
3. **Principio de mínimo privilegio:** **Network Security Groups (NSG)** configurados para permitir únicamente el tráfico necesario (**80**, **443** y **22**).

---

## 🚀 Guía de Despliegue

Por motivos de seguridad, los archivos con credenciales reales están excluidos del repositorio. Para replicar el entorno, sigue los pasos siguientes.

### 0. Configuración de Ansible

Antes de ejecutar los *playbooks*, es necesario configurar dos archivos esenciales:

#### 0.1 Archivo `ansible/ansible.cfg`

Crea el archivo `ansible/ansible.cfg` basándote en [ansible/ansible.cfg.example](ansible/ansible.cfg.example):

```bash
cp ansible/ansible.cfg.example ansible/ansible.cfg
```

Luego edita la ruta absoluta del archivo de inventario y de la clave SSH privada:

```ini
[defaults]
inventory = /path/to/TFG_Infraestructura_Segura/ansible/inventory/hosts.ini
remote_user = ansible
private_key_file = /path/to/.ssh/ansible_id_rsa
host_key_checking = False
ask_pass = False
```

#### 0.2 Archivo `ansible/inventory/hosts.ini`

Crea el archivo `ansible/inventory/hosts.ini` basándote en [ansible/inventory/hosts.ini.example](ansible/inventory/hosts.ini.example):

```bash
cp ansible/inventory/hosts.ini.example ansible/inventory/hosts.ini
```

Actualiza las direcciones IP de las máquinas virtuales (obtenidas de la salida de Terraform) y la ruta a tu clave SSH privada:

```ini
[wordpress_servers]
vm-prod-1 ansible_host=<IP_VM_1> ansible_user=azureuser ansible_ssh_private_key_file=/path/to/.ssh/ansible_id_rsa
vm-prod-2 ansible_host=<IP_VM_2> ansible_user=azureuser ansible_ssh_private_key_file=/path/to/.ssh/ansible_id_rsa

[all:vars]
ansible_python_interpreter=/usr/bin/python3
```

> ⚠️ **Nota:** Asegúrate de que estos archivos estén incluidos en `.gitignore` para evitar compartir credenciales.

### 1. Preparación de Terraform

Crea el archivo `terraform/terraform.tfvars` con la configuración básica:

```hcl
admin_username = "azureuser"
ssh_public_key = "ssh-rsa AAAAB3Nza..."
location       = "France Central"
```

### 2. Configuración de Docker

Crea un archivo `.env` en `ansible/deploy/` basándote en [ansible/deploy/.env.example](ansible/deploy/.env.example):

```bash
cp ansible/deploy/.env.example ansible/deploy/.env
```

Actualiza las credenciales de la base de datos:

```env
DB_HOST=tu-servidor-mysql.mysql.database.azure.com
DB_USER=micky_admin
DB_PASSWORD=TuPasswordSeguro
DB_NAME=wordpress_db
```

> ⚠️ **Nota:** Asegúrate de que este archivo esté incluido en `.gitignore`.

### 3. Ejecución del Despliegue

Lanza el *playbook* para configurar los nodos y levantar los contenedores:

```bash
cd ansible
ansible-playbook -i inventory/hosts.ini site.yml
```

Al finalizar el proceso, la aplicación estará disponible a través de la **IP pública del Azure Load Balancer**.

---

## 📌 Estado del Proyecto

Proyecto desarrollado como **Trabajo de Fin de Grado (TFG)**, enfocado en **cloud computing**, **automatización** y **seguridad en infraestructuras**.

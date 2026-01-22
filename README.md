# Mi TFG: Despliegue de Infraestructura Segura y Automatizada

Este es el repositorio de mi Trabajo de Fin de Grado. Mi objetivo ha sido diseñar y montar una infraestructura en Azure que no solo sea automática, sino que sea segura por diseño. Para ello, he aplicado políticas de **Hardening** y he utilizado el paradigma de **Infraestructura como Código (IaC)** para que todo el entorno sea reproducible y fácil de auditar.

### ¿Cómo está montado esto?
El proyecto se divide principalmente en dos partes:
1.  **Aprovisionamiento:** Uso **Terraform** para levantar toda la base (redes, firewalls, instancias, etc.) de forma controlada.
2.  **Configuración y Seguridad:** Uso **Ansible** para gestionar los servidores, instalar los servicios y aplicar las medidas de seguridad necesarias.

Todo el flujo de trabajo y el despliegue continuo lo gestiono a través de **Azure DevOps**.

---

## Notas para el despliegue (Setup local)

Ojo: por seguridad, he ignorado los archivos que contienen claves o IPs reales en el `.gitignore`. Si quieres replicar el despliegue, tendrás que crear estos archivos en tu máquina:

Ojo: por seguridad, he ignorado los archivos que contienen claves o IPs reales en el `.gitignore`. Si quieres replicar el despliegue, tendrás que configurar esto localmente:

### 1. Terraform (`terraform/terraform.tfvars`)
Crea un archivo `terraform.tfvars` con tus datos:
```hcl
admin_username = "tu_usuario"
ssh_public_key = "tu_clave_publica_ssh"
location       = "West Europe"
```

### 2. Acceso SSH
Asegúrate de tener un par de claves SSH generadas. La clave pública se usará en Terraform para el acceso a las instancias, y la clave privada será necesaria para que Ansible pueda conectarse y configurar los nodos.

### 3. Inventario de Ansible
Configura el archivo `inventory.ini` o similar con las direcciones IP generadas por Terraform:
```ini
[webservers]
10.0.1.4 ansible_user=tu_usuario ansible_ssh_private_key_file=~/.ssh/id_rsa
```
Crea un archivo `.env` en la carpeta `ansible/deploy/` para las credenciales de Docker:
```env
MYSQL_ROOT_PASSWORD=tu_contraseña_maestra
WORDPRESS_DB_HOST=tu_host_de_base_de_datos
WORDPRESS_DB_USER=tu_usuario_db
WORDPRESS_DB_PASSWORD=tu_contraseña_db
WORDPRESS_DB_NAME=nombre_de_tu_db

## Despliegue

### Paso 1: Infraestructura
Navega al directorio de Terraform e inicializa el entorno:
```bash
terraform init
terraform plan
terraform apply
```

### Paso 2: Configuración
Una vez levantada la infraestructura, ejecuta los playbooks de Ansible:
```bash
ansible-playbook -i inventory.ini site.yml
```

## Validación y Tests
*   **Terraform:** Ejecuta `terraform validate` para comprobar la sintaxis.
*   **Ansible:** Ejecuta `ansible-playbook --syntax-check` para validar los archivos YAML.

---
*Este proyecto ha sido desarrollado como parte de un entorno académico para el Trabajo de Fin de Grado.*

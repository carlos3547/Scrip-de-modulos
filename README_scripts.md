# Proyecto de Ejecución de Scripts Multiplataforma
#nuestra documentacion 
Este proyecto permite ejecutar diversos scripts en Python, PowerShell y Bash desde una misma interfaz en Python. Ideal para tareas automatizadas en Windows y Linux.

## Scripts incluidos

1. **API_IPABUSE.py** - Analiza IPs en relación con abusos conocidos.
2. **Complejo.py** - Calcula la complejidad de un conjunto de datos.
3. **deteccion.py** - Realiza detección de patrones en datos.
4. **escaneo_puertos.sh** - Escanea puertos en una red específica.
5. **ListadoDeArchivosOcultos.psm1** - Lista archivos ocultos en el sistema.
6. **modulo2.psm1** - Ejecuta funciones del segundo módulo de PowerShell.
7. **Modulo_UsoRecursos.psm1** - Monitorea el uso de recursos del sistema.
8. **Monitoreo_Red.sh** - Realiza monitoreo de tráfico de red.
9. **trafico.py** - Analiza el tráfico de red en tiempo real.
10. **virus.psm1** - Proporciona funciones para gestionar virus y malware.

#usted puede de esta manera instalar el repositorio 

1. Clona este repositorio:
    ```bash
    git clone https://github.com/usuario/proyecto.git
    cd proyecto
    ```
2. Asegúrate de tener los permisos necesarios para ejecutar scripts:
    - En Windows: habilitar la política de ejecución para PowerShell (`Set-ExecutionPolicy Bypass -Scope Process`).
    - En Linux: dar permisos de ejecución a los scripts Bash (`chmod +x nombre_script.sh`).

## Uso

Ejecuta el script principal `menu_principal.py`:
```bash
python menu_principal.py -o <opción>

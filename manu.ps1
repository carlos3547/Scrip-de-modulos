Set-StrictMode -Version Latest
<#
.SYNOPSIS
Menu para revisión de los comandos get-help.
#>
<#
.DESCRIPTION
Con este script podrás tomar entre diversas opciones para revision de ciberseguridad.
#>
<#
.NOTES
Este menú tiene diferentes módulos para correr correctamente y solo se podrá elegir de la opción 1 a 5 para funciones.
#>

# Crear el manifiesto del módulo
New-ModuleManifest -Path "C:\Users\carlo\OneDrive\Escritorio\Scrip de modulos\virustotal-manifiesto.psd1" -RootModule "virus.psm1"
New-ModuleManifest -Path "C:\Users\carlo\OneDrive\Escritorio\Scrip de modulos\ListarArchivosOcultos.psd1" -RootModule "modulo2.psm1"
New-ModuleManifest -Path "C:\Users\carlo\OneDrive\Escritorio\Scrip de modulos\Modulo_UsoRecursos.psd1" -RootModule "Modulo_UsoRecursos.psm1"
New-ModuleManifest -Path "C:\Users\carlo\OneDrive\Escritorio\Scrip de modulos\persistensia_tareas.psd1" -RootModule "Funcion_persistencia.psm1"

# Importar los módulos
Import-Module "C:\Users\carlo\OneDrive\Escritorio\Scrip de modulos\virus.psm1"
Import-Module "C:\Users\carlo\OneDrive\Escritorio\Scrip de modulos\modulo2.psm1"
Import-Module "C:\Users\carlo\OneDrive\Escritorio\Scrip de modulos\Modulo_UsoRecursos.psm1"
Import-Module "C:\Users\carlo\OneDrive\Escritorio\Scrip de modulos\Funcion_persistencia.psm1"

# Verificar que los módulos estén importados correctamente
Get-Module -Name Get-VirusTotal, Get-HiddenFiles, Get-UsoMemoria, Get-UsoDisco, Get-UsoProcesador, Get-UsoRed, Get-Persistence

# Función para mostrar el menú principal
function menu {
    # Dibujar el menú con formato más claro
    Write-Host "`n===== Menú Principal ====="
    Write-Host "1. Generar el módulo 1"
    Write-Host "2. Generar el módulo 2"
    Write-Host "3. Generar el módulo 3"
    Write-Host "4. Generar el módulo 4"
    Write-Host "5. Mostrar el manifiesto 1"
    Write-Host "6. Mostrar el manifiesto 2"
    Write-Host "7. Mostrar el manifiesto 3"
    Write-Host "8. Mostrar el manifiesto 4"
    Write-Host "9. Salir"
    Write-Host "==========================="

    # Seleccionar una opción
    $opcion = Read-Host "`nSelecciona una opción (1-9)"

    # Procesar la opción seleccionada usando switch
    switch ($opcion) {
        1 {
            Write-Host "Generando el módulo 1..."
            Get-VirusTotal
        }
        2 {
            Write-Host "Generando el módulo 2..."
            $ruta = Read-Host "Introduce la ruta para buscar archivos ocultos"
            Write-Host "Ruta proporcionada: $ruta"
            Get-HiddenFiles -Path $ruta
        }
        3 {
            Write-Host "Generando el módulo 3..."
            Write-Host "Uso de memoria:"
            Get-UsoMemoria | Format-Table

            Write-Host "Uso del disco:"
            Get-UsoDisco | Format-Table

            Write-Host "Uso del procesador:"
            Get-UsoProcesador | Format-Table

            Write-Host "Uso de la red:"
            Get-UsoRed | Format-Table
        }
        4 {
            Write-Host "Generando el módulo 4..."
            Get-Persistence
        }
        5 {
            $manifestPath1 = "C:\Users\carlo\OneDrive\Escritorio\Scrip de modulos\virustotal-manifiesto.psd1"
            try (Test-Path $manifestPath1) {
                $manifest1 = Get-Content -Path $manifestPath1 -Raw
                Write-Host "`nContenido del manifiesto 1:`n"
                Write-Host $manifest1
            } catch {
                Write-Host "El archivo de manifiesto no se encuentra en la ruta especificada."
            }
        }
        6 {
            $manifestPath2 = "C:\Users\carlo\OneDrive\Escritorio\Scrip de modulos\ListarArchivosOcultos.psd1"
            if (Test-Path $manifestPath2) {
                $manifest2 = Get-Content -Path $manifestPath2 -Raw
                Write-Host "`nContenido del manifiesto 2:`n"
                Write-Host $manifest2
            } else {
                Write-Host "El archivo de manifiesto no se encuentra en la ruta especificada."
            }
        }
        7 {
            $manifestPath3 = "C:\Users\carlo\OneDrive\Escritorio\Scrip de modulos\Modulo_UsoRecursos.psd1"
            if (Test-Path $manifestPath3) {
                $manifest3 = Get-Content -Path $manifestPath3 -Raw
                Write-Host "`nContenido del manifiesto 3:`n"
                Write-Host $manifest3
            } else {
                Write-Host "El archivo de manifiesto no se encuentra en la ruta especificada."
            }
        }
        8 {
            $manifestPath4 = "C:\Users\carlo\OneDrive\Escritorio\Scrip de modulos\persistencia_tareas.psd1"
            if (Test-Path $manifestPath4) {
                $manifest4 = Get-Content -Path $manifestPath4 -Raw
                Write-Host "`nContenido del manifiesto 4:`n"
                Write-Host $manifest4
            } else {
                Write-Host "El archivo de manifiesto no se encuentra en la ruta especificada."
            }
        }
        9 {
            Write-Host "Saliendo..."
            exit
        }
        default {
            Write-Host "`nOpción no válida, intenta nuevamente."
        }
    }
}

menu


Set-StrictMode -Version Latest
#funcion2
function Get-HiddenFiles {
    <#
    .SYNOPSIS
    Busca archivos ocultos en la ruta especificada.

    .DESCRIPTION
    La función `Get-HiddenFiles` busca archivos ocultos en la carpeta especificada por el parámetro `-Path`. Muestra los archivos ocultos encontrados en la ruta proporcionada.

    .PARAMETER Path
    La ruta completa a la carpeta en la que se buscan archivos ocultos.

    .EXAMPLE
    Get-HiddenFiles -Path "C:\Users\carlo\OneDrive\Escritorio\ciberseguridad"
    Muestra todos los archivos ocultos en la carpeta especificada.

    .NOTES
    Nombre del módulo: NombreDelModulo
    Autor: TuNombre
    Fecha: 2024-09-11

    #>

    param (
        [string]$Path
    )

    # Verificar si se proporcionó una ruta
    if ([string]::IsNullOrWhiteSpace($Path)) {
        Write-Error "No se ha proporcionado una ruta válida."
        return
    }

    # Mostrar la ruta proporcionada para verificación
    Write-Host "Ruta proporcionada: $Path"

    # Verificar si la ruta existe
    if (-Not (Test-Path -Path $Path)) {
        Write-Error "La ruta especificada no existe."
        return
    }

    # Buscar archivos ocultos
    $hiddenFiles = Get-ChildItem -Path $Path -Force | Where-Object { $_.Attributes -match "Hidden" }
    
    if ($hiddenFiles) {
        $hiddenFiles | ForEach-Object { Write-Output "Archivo oculto: $($_.FullName)" }
    } else {
        Write-Host "No se encontraron archivos ocultos en la ruta especificada."
    }
}

Get-HiddenFiles











































































Set-StrictMode -Version Latest

# Funciones para revisar el uso de recursos del sistema

function Get-UsoMemoria {
    <#
    .SYNOPSIS
    Muestra el uso de la memoria del sistema.

    .DESCRIPTION
    La función `Get-UsoMemoria` obtiene la memoria total, libre y usada del sistema y la muestra en megabytes.

    .EXAMPLE
    Get-UsoMemoria
    Muestra el uso actual de la memoria del sistema.

    .NOTES
    Nombre del módulo: NombreDelModulo
    Autor: TuNombre
    Fecha: 2024-09-11
    #>

    $memoria = Get-CimInstance Win32_OperatingSystem | Select-Object TotalVisibleMemorySize, FreePhysicalMemory
    [PSCustomObject]@{
        'Memoria Total (MB)'   = [math]::round($memoria.TotalVisibleMemorySize / 1KB, 2)
        'Memoria Libre (MB)'   = [math]::round($memoria.FreePhysicalMemory / 1KB, 2)
        'Memoria Usada (MB)'   = [math]::round(($memoria.TotalVisibleMemorySize - $memoria.FreePhysicalMemory) / 1KB, 2)
    }
}

function Get-UsoDisco {
    <#
    .SYNOPSIS
    Muestra el uso del espacio en disco de todos los drives del sistema.

    .DESCRIPTION
    La función `Get-UsoDisco` muestra el espacio total, usado y libre en cada unidad de disco del sistema en gigabytes.

    .EXAMPLE
    Get-UsoDisco
    Muestra el uso del espacio en disco de todas las unidades del sistema.

    .NOTES
    Nombre del módulo: NombreDelModulo
    Autor: TuNombre
    Fecha: 2024-09-11
    #>

    Get-PSDrive -PSProvider FileSystem | Select-Object Name, Used, Free, @{Name='Total (GB)'; Expression={[math]::round(($_.Used + $_.Free) / 1GB, 2)}}, @{Name='Usado (GB)'; Expression={[math]::round($_.Used / 1GB, 2)}}, @{Name='Libre (GB)'; Expression={[math]::round($_.Free / 1GB, 2)}}
}

function Get-UsoProcesador {
    <#
    .SYNOPSIS
    Muestra el tiempo total de CPU usado por los procesos en el sistema.

    .DESCRIPTION
    La función `Get-UsoProcesador` muestra el tiempo total de CPU utilizado por todos los procesos en segundos.

    .EXAMPLE
    Get-UsoProcesador
    Muestra el tiempo total de CPU usado por los procesos en el sistema.

    .NOTES
    Nombre del módulo: NombreDelModulo
    Autor: TuNombre
    Fecha: 2024-09-11
    #>

    $totalCPU = (Get-Process | Measure-Object -Property CPU -Sum).Sum
    [PSCustomObject]@{
        'TotalCPUTime (s)' = [math]::round($totalCPU, 2)
    }
}

function Get-UsoRed {
    <#
    .SYNOPSIS
    Muestra el uso de la red para cada adaptador de red.

    .DESCRIPTION
    La función `Get-UsoRed` muestra la cantidad de datos recibidos y enviados por cada adaptador de red en megabytes.

    .EXAMPLE
    Get-UsoRed
    Muestra el uso de la red de todos los adaptadores de red en el sistema.

    .NOTES
    Nombre del módulo: NombreDelModulo
    Autor: TuNombre
    Fecha: 2024-09-11
    #>

    Get-NetAdapterStatistics | Select-Object Name, ReceivedBytes, SentBytes, @{Name='Recibido (MB)'; Expression={[math]::round($_.ReceivedBytes / 1MB, 2)}}, @{Name='Enviado (MB)'; Expression={[math]::round($_.SentBytes / 1MB, 2)}}
}

# Llamadas a las funciones

Write-Host "===== Uso de Memoria ====="
Get-UsoMemoria | Format-Table -AutoSize

Write-Host "`n===== Uso de Disco ====="
Get-UsoDisco | Format-Table -AutoSize

Write-Host "`n===== Uso del Procesador ====="
Get-UsoProcesador | Format-Table -AutoSize

Write-Host "`n===== Uso de la Red ====="
Get-UsoRed | Format-Table -AutoSize

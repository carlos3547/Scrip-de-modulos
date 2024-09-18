function Get-VirusTotal {
    <#
    .SYNOPSIS
    Consulta la API de VirusTotal para obtener el reporte de un archivo basado en su hash.

    .DESCRIPTION
    La función `Get-VirusTotal` toma una clave de API y una lista de archivos, calcula el hash de cada archivo y consulta VirusTotal para verificar si hay anomalías. Los resultados se almacenan en un diccionario que se devuelve al finalizar.

    .PARAMETER key
    La clave de API para acceder a la API de VirusTotal. Si no se proporciona, se usa una clave predeterminada.

    .PARAMETER dic
    Un diccionario (Hashtable) que se utiliza para almacenar los resultados de la consulta de VirusTotal para cada archivo.

    .PARAMETER ve2
    Una lista de archivos para procesar. Por defecto, se usa una lista de archivos en el directorio actual.

    .EXAMPLE
    Get-VirusTotal -key 'your_api_key' -dic @{} -ve2 (Get-ChildItem -Name)

    .NOTES
    Requiere una clave de API válida de VirusTotal. Asegúrate de tener los permisos adecuados para consultar la API.
    #>

    param(
        [parameter(mandatory)][string]$Apikey,
        $dic = @{},
        $ve2 = [System.Collections.ArrayList]@(Get-ChildItem -name)
        )

    process {
        foreach ($item in $ve2) {
            $filePath = ".\$item"
            Write-Host "Procesando archivo: $filePath"  # Depuración: archivo procesado
            $fileHash = (Get-FileHash -Path $filePath).Hash
            Write-Host "Hash del archivo: $fileHash"  # Depuración: hash del archivo

            $body = @{
                resource = $fileHash
                apikey   = $key
            }

            try {
                # Invocar el método REST con POST
                $result = Invoke-RestMethod -Method Post -Uri 'https://www.virustotal.com/vtapi/v2/file/report' -Body $body -ContentType 'application/x-www-form-urlencoded'
                Write-Host "Resultado de la API: $($result | ConvertTo-Json)"  # Depuración: resultado de la API

                if ($result.response_code -eq 1) {
                    if ($result.positives -eq 0) {
                        $dic[$item] = 'No se encontró ninguna anomalía'
                    } else {
                        $dic[$item] = "Se encontraron $($result.positives) anomalías"
                    }
                } else {
                    $dic[$item] = 'No funcionó, intenta hacerlo manualmente'
                }
            } catch {
                # Manejar cualquier error durante la solicitud
                $dic[$item] = 'Error al procesar la solicitud'
                Write-Host "Error: $_"  # Depuración: error durante la solicitud
            }
        }

        # Devolver el diccionario con los resultados
        $dic
    }
}

# Ejecutar la función para probar
$result = Get-VirusTotal
$result | Format-Table -AutoSize

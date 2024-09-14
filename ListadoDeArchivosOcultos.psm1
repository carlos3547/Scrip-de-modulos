function Get-HiddenFiles {
    param (
        [string]$Path
    )
 
    if (-Not (Test-Path -Path $Path)) {
        Write-Error "La ruta especificada no existe."
        return
    }
 
    Get-ChildItem -Path $Path -Force | Where-Object { $_.Attributes -match "Hidden" } | ForEach-Object {
        Write-Output "Archivo oculto: $($_.FullName)"
    }
}
 
Export-ModuleMember -Function Get-HiddenFiles
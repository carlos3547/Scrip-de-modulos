#ruta del reporte
report="reporte_escaneo.txt"

#menu
show_menu() {
  clear
  echo "escaneo de puertos"
  echo "1. escaneo de puertos"
  echo "2. escaneo rapido"
  echo "3. escaneo detallado"
  echo "4. escanear puertos abiertos especificos"
  echo "5. Generar reporte"
  echo "6. salir
  read -p "eligue una opcion:" opcion
}
# mi funcion principal para el menu
start_menu() {
  while true; do
    mostrar_menu
    read -p "Elige una opción: " opcion  # Captura la entrada del usuario
    case $opcion in
      1) echo "Escaneo de puertos" ;;  
      2) echo "Escaneo rápido" ;;      
      3) echo "Escaneo detallado" ;;   
      4) echo "Escaneo de puertos abiertos" ;;  
      5) echo "Generar reporte" ;;     
      6) echo "Saliendo..."; exit ;;   
      *) echo "Opción no válida" ;;    
    esac
    read -p "Presiona Enter para continuar..."  # Pausa antes de mostrar el menú de nuevo
  done
}



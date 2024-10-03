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

#mi funcion para realizar el scaneo de puertos
scann_puertos() {
  read -p "introduce la Ip del dominio a escanear:" ip
  read -p "pon el rango de puertos (ej. 1-1000):" rango 
  echo "inicie escaneo de puertos en $ip, rango de puertos $rango...."
  nmap -p $rango $ip
  echo "escaneode puertos terminado"
}

#Mi funcion para generar mi reporte 
function_report() {
  read -p "puedes poner la IP de dominio a escanear para el reporte: "ip 
  echo "iniciando el reporte de escaneo para $ip..."
  nmap -oN $reporte $reporte $ip
  echo "reporte  generado en $reporte."

#creo mi funcion para generar el escaneo rapido 
scann_fast() {
  read -p "introduce la IP o dominioa escanear:" ip
  echo "iniciando escaneo rapido en $ip...."
  nmap -T4 $ip
  echo "escaneo rapido finalizado."
}

#podemos crear una funcion para hacer un escaneo detallado
scann_detallado() {
  read -p "puedes poner la IP o dominio a escanear:" ip
  echo "inicie el escaneo detallado en $ip..."
  nmap -A $ip
  echo "haciedo un escaneo detallado terminado"
}

#creo mi funcion para poder escanear puertos abiertos
scann_puertos_filled () {
  read -p "introduce la IP o dominio a escanear" ip 
  read -p "pon los puertos especificos separado por comas (80,443,8080)" puertos
  echo "iniciando los escaneos de puertos especificosde $ip."
  nmap -p $puertos $ip
  echo "escaneo de puertos especificos finalizado"
}

# Tienes que verificar si nmap esta instalado de esta manera
if ! command -v nmap &> /dev/null
then
    echo "nmap no está instalado. Instalándolo..."
    sudo apt-get install nmap -y
fi

iniciar_menu

  


}



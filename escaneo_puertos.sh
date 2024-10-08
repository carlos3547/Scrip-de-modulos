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
  echo "6. "salir"
  read -p "eligue una opcion:" opcion
}
# mi funcion principal para el menu
start_menu() {
  while true; do
    mostrar_menu
    read -p "Elige una opción: " opcion  
    case $opcion in
      1) echo "Escaneo de puertos" ;;  
      2) echo "Escaneo rápido" ;;      
      3) echo "Escaneo detallado" ;;   
      4) echo "Escaneo de puertos abiertos" ;;  
      5) echo "Generar reporte" ;;     
      6) echo "Saliendo..."; exit ;;   
      *) echo "Opción no válida" ;;    
    esac
    read -p "Presiona Enter para continuar"  
  done
}

#mi funcion para realizar el scaneo de puertos locales aqui usu lsof
scann_puertos_local() {
	echo "Mostro puertos abiertos locales"
 	sudo lsof -i -P -n | grep LISTEN
  	echo "escaneo de mis puertos locales terminado"
   }

#Usando ping podemos hacer un escaneo rapido
scann_fast() {
    # Obtenemos la IP local
    local_ip=$(hostname -I | awk '{print $1}')
    
    # Pedir al usuario la IP o dominio
    read -p "Ponga la IP o dominio a escanear (presione Enter para usar la IP de esta computadora: $local_ip): " ip
    
    # Si el usuario no ingresa nada, usar la IP local
    ip=${ip:-$local_ip}

    echo "Iniciando el escaneo rápido (ping) en $ip"
    
    # Ejecutar el ping
    ping -c 4 $ip > /dev/null 2>&1

    # Verificar si el host responde
    if [ $? -eq 0 ]; then
        echo "El host $ip está activo."
    else
        echo "El host $ip no está respondiendo."
    fi

    echo "Escaneo detallado terminado."
}


#creo mi funcion para hacer un escaneo detallado de las conexiones usando ss de BASH 
scann_datailed() {
	echo "muestro todas las conexiones de red activas (TCP,VPN)  "
 	ss -tuln 
  	echo "escaneo detallado finalizado"
}

#podemos crear una funcion para escanear puertos especificos especificos usando lsof de BASH
scann_puertos_abiertos () {
    # Puertos predeterminados
    puertos_predeterminados=("80" "443" "22")

    # Pedir puertos específicos al usuario
    read -p "Escribe los puertos específicos separados por comas (dejar vacío para usar predeterminados 80, 443, 22): " puertos_usuario

    # Validar que el usuario introduzca solo números y comas
    while ! [[ "$puertos_usuario" =~ ^[0-9,]*$ ]]; do
        echo "Entrada no válida. Por favor, ingresa solo números separados por comas."
        read -p "Escribe los puertos específicos separados por comas (dejar vacío para usar predeterminados 80, 443, 22): " puertos_usuario
    done

    # Si el usuario no proporciona puertos, usar los predeterminados
    if [ -z "$puertos_usuario" ]; then
        puertos=("${puertos_predeterminados[@]}")
    else
        # Convertir los puertos proporcionados por el usuario en un array
        IFS=',' read -r -a puertos <<< "$puertos_usuario"
    fi

    echo "Iniciando el escaneo de puertos específicos..."

    # Escanear cada puerto proporcionado
    for puerto in "${puertos[@]}"; do
        echo "Escaneando puerto $puerto..."
        sudo lsof -i :$puerto -P -n | grep LISTEN || echo "No se encontraron servicios en el puerto $puerto."
    done

    echo "El escaneo de puertos específicos ha terminado."
}


#creo mi funcion para hacer el reporte de la red es decir (escaneo basico de hosts activos)
function_report() {
	read -p "ponga el rando de IPs (ejemplo. 192.169.2.)" red
 	echo "haciendo el escaneo de escaneo de red para la red $red.." >$report
  	for ip in {1...254}; do 
   		ping -c 1 -W 1 ${red}$ip > /dev/null 2>&1
     		if [ $? -eq 0]; then
       			echo "host activo: ${red}$ip" >> $report
	  	fi 
    	done
    	echo "reporte generado por en el $report"
}

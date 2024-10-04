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

show_menu() {
    clear
    echo "Escaneo de Puertos"
    echo "1. Escaneo completo"
    echo "2. cambiar objetos "
    echo "3. Generar reporte"
    echo "4. Tipo de puerto"
    echo "5. Salir"
    read -p "Elige una opción: " op2
}

escaneo_completo() {
for puerto in "${puertos[@]}"
do
    echo "puerto ${puerto}"
    echo "el puerto se encuentra: "
    (echo > /dev/tcp/"$ip"/"$puerto") > /dev/null 2>&1 && echo "abierto" || echo "cerrado"
    echo "el sitema operativo de la ip es(64:linux, 128:Windows, 255:Cisco): "
    ping -c 1 "$ip" | grep 'bytes' | grep -v PING | awk '{print $1}'
    echo "la latencia es: "
    ping -c 1 "$ip" | grep 'time=' | awk '{print $7}'
done
}

generar_reporte() {
    num=0
    report="reporte_$(date +%Y%m%d_%H%M%S).txt"
    echo "Generando reporte de escaneo..."
    echo "Fecha: $(date)" > $report
    echo "Reporte de Escaneo de Puertos" >> $report
    echo "============================" >> $report
    for puerto in "${puertos[@]}"
    do
        g1=$( (echo > /dev/tcp/"$ip"/"$puerto") > /dev/null 2>&1 && echo "abierto" || echo "cerrado" )
        g2=$(ping -c 1 "$ip" | grep 'bytes' | grep -v PING | awk '{print $1}')
        g3=$(ping -c 1 "$ip" | grep 'time=' | awk '{print $7}')
        echo "puerto ${puerto}" >> $report
        echo "1. el puerto se encuentra: ${g1}" >> $report
        echo "2. el sitema operativo de la ip es(64:linux, 128:Windows, 255:Cisco): ${g2}" >> $report
        echo "3. la latencia es: ${g3}" >> $report
        num+=1
        gu1+="${g1}\n"
        gu2+="${g2}\n"
        gu3+="${g3}\n"
    done
    echo "Reporte guardado en: $report"
}

tipo_de_puerto() {
    for puerto in "${puertos[@]}"
    do  
        case $puerto in
            22)
                echo "el puerto 22 es para ssh"
                ;;
            53)
                echo "el puerto 55 es para domain"
                ;;
            70)
                echo "el puerto 70 es para gopher"
                ;;
            80)
                echo "el puerto 80 es para http"
                ;;
            113)
                echo "el puerto 113 es para auth"
                ;;
            *)
                echo "el puerto ${puerto} no es de un unico uso"
                ;;
        esac
    done
}

funcion() {
	declare -a puertos
	read -p "¿sera un autoescaneo? " op1
	if [ "$op1" = "si" ] || [ "$op1" = "Si" ] || [ "$op1" = "sI" ] || [ "$op1" = "SI" ]; then
	    lista=($(ip addr show | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | cut -d/ -f1))
	    ip="${lista[0]}"
	else
	    read -p "introduzca la dirección a escanear: " ip
	fi

	read -p "¿Cuántos puertos va a escanear? " cant
	if [ "$cant" -gt 1 ]; then
	    for ((i=1; i<=cant;i++))
	    do
		read -p "Introduce los puertos a escanear (por ejemplo, 22,80,443): " pts
		puertos+=("$pts")
	    done
	elif [ "$cant" -eq 0 ]; then
	    echo "Entendido, adiós"
	    op2=7
	else
	    read -p "Introduce el puerto a escanear: " puertos
	fi
	while true; do
	    show_menu
	    case $op2 in
		1)
		    escaneo_completo
		    ;;
		2)
		    puertos=()
		    declare -a puertos
		    read -p "¿sera un autoescaneo? " op1
		    if [ "$op1" = "si" ] || [ "$op1" = "Si" ] || [ "$op1" = "sI" ] || [ "$op1" = "SI" ]; then
			lista=($(ip addr show | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | cut -d/ -f1))
			ip="${lista[0]}"
		    else
			read -p "introduzca la dirección a escanear: " ip
		    fi

		    read -p "¿Cuántos puertos va a escanear? " cant
		    if [ "$cant" -gt 1 ]; then
			for ((i=1; i<=cant;i++))
			do
			    read -p "Introduce los puertos a escanear (por ejemplo, 22,80,443): " pts
			    puertos+=("$pts")
			done
		    elif [ "$cant" -eq 0 ]; then
			echo "Entendido, adiós"
			op2=7
		    else
			read -p "Introduce el puerto a escanear: " puertos
		    fi
		    ;;
		3)
		    generar_reporte
		    ;;
		4)
		    tipo_de_puerto
		    ;;
		5)
		    echo "Saliendo..."
		    exit 0
		    ;;
		*)
		    echo "Opción no válida. Inténtalo de nuevo."
		    ;;
	    esac
	    read -p "Presiona [Enter] para continuar..."
	done
}

funcion



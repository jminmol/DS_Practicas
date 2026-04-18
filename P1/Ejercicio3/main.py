from contexto import ContextoScraping
from estrategiaBs4 import EstrategiaBeautifulSoup
from estrategiaSelenium import EstrategiaSelenium
import csv

def guardar_datos_csv(datos: list, nombre_archivo: str = "estadisticas_hockey.csv"):
    
    if not datos:
        print("No hay datos para guardar.")
        return

    print(f"Guardando los datos en {nombre_archivo}...")

    # Abrir el archivo en blanco (y prepararlo para que se cierre solo)
    with open(nombre_archivo, mode='w', newline='', encoding='utf-8') as archivo_csv:
        
        # Definir las columnas (las sacamos de las etiquetas del primer equipo, la primera linea y leemos solo team win...)
        nombres_columnas = datos[0].keys()
        
        # Preparamos la herramienta que sabe escribir diccionarios en CSV, le damos el archivo y las columnas
        escritor = csv.DictWriter(archivo_csv, fieldnames=nombres_columnas)
        
        # Escribir la primera fila (las cabeceras), las que les hemos pasado en nombres_columnas
        escritor.writeheader()

        # Escribir los datos (escribe todas las "fichas" de golpe)
        escritor.writerows(datos)

    print("¡Archivo guardado con éxito!")


if __name__ == "__main__":
    urlBase = "https://www.scrapethissite.com/pages/forms/"
    numPaginas = 5

    print("Seleccione la estrategia de scraping que desea utilizar:\n")
    print("1. BeautifulSoup")
    print("2. Selenium\n")
    opcion = input("Ingrese el número de la opción deseada (1 o 2): ")

    

    if opcion == "1":
        # Crear el contexto con la estrategia de BeautifulSoup
        contexto = ContextoScraping(EstrategiaBeautifulSoup())
    elif opcion == "2":
        # Crear el contexto con la estrategia de Selenium
        contexto = ContextoScraping(EstrategiaSelenium())
    else:
        print("Opción no válida.")
        raise SystemExit("Saliendo del programa.\n")
    
    print("Iniciando el proceso de scraping...\n")

    datos = contexto.ejecutar_estrategia(urlBase, numPaginas)
    guardar_datos_csv(datos, "estadisticas_hockey.csv")
    print("Programa finalizado\n")


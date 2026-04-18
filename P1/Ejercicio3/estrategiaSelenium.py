from estrategiaScraping import EstrategiaScraping
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
import time

class EstrategiaSelenium(EstrategiaScraping):

    def extraer_datos(self, urlBase: str, numPaginas: int) -> list:
        print(f"Iniciando scraping con Selenium para {numPaginas} páginas...")
        datos_equipos = []
        
        # Opciones de Chrome
        opciones = Options()
        #opciones.add_argument("--headless") # Modo fantasma: no abre la ventana gráfica
        opciones.add_argument("--disable-gpu") # Recomendado para evitar errores en Windows/Linux
        opciones.add_argument("--window-size=1920,1080")
        
        # Arrancar el motor
        driver = webdriver.Chrome(options=opciones)
        
        # Bloque try para asegurarnos de que el navegador siempre se cierre,
        # incluso si ocurre un error a mitad de camino.
        try:
            # El bucle de páginas
            for pagina in range(1, numPaginas + 1):
                print(f"Selenium scrapeando página {pagina}...")
                
                # Montamos la URL de la página actual
                url_actual = f"{urlBase}?page_num={pagina}"
                
                # nos metemos en la web
                driver.get(url_actual)
                
                # damos 2 segundos para que la página cargue, no es necesario pero podemos llegar a evitar errores
                time.sleep(2) 
                
                # cogemos todas la filas que son equipos de la tabla que tengan la clase "team" y las guardamos en una lista
                equipos = driver.find_elements(By.CLASS_NAME, "team")
                
                # Extraer los datos y crear la ficha
                for equipo in equipos:

                    #Si no encuentra un elemento se queda pillado con esto evitamos eso diciendo que en caso de que pase ponga 0
                    try:
                        ot_losses = equipo.find_element(By.CLASS_NAME, "ot-losses").text.strip()
                    except:
                        ot_losses = "0"
                        
                    try:
                        win_pct = equipo.find_element(By.CLASS_NAME, "pct").text.strip()
                    except:
                        win_pct = "0"

                    ficha = {
                        "Team Name": equipo.find_element(By.CLASS_NAME, "name").text.strip(),
                        "Year": equipo.find_element(By.CLASS_NAME, "year").text.strip(),
                        "Wins": equipo.find_element(By.CLASS_NAME, "wins").text.strip(),
                        "Losses": equipo.find_element(By.CLASS_NAME, "losses").text.strip(),
                        "OT Losses": ot_losses,
                        "Win %": win_pct,
                        "Goals For": equipo.find_element(By.CLASS_NAME, "gf").text.strip(),
                        "Goals Against": equipo.find_element(By.CLASS_NAME, "ga").text.strip(),
                        "+ / -": equipo.find_element(By.CLASS_NAME, "diff").text.strip()
                    }
                    
                    # Metemos la ficha en la caja
                    datos_equipos.append(ficha)
                    
        finally:
            # Apagar el motor
            print("Cerrando el navegador Selenium...")
            driver.quit()
            
        return datos_equipos
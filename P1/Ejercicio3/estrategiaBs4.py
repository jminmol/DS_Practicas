from estrategiaScraping import EstrategiaScraping
from bs4 import BeautifulSoup
import requests
import time

class EstrategiaBeautifulSoup(EstrategiaScraping):
    
    def extraer_datos(self, url_base: str, num_paginas: int) -> list:
        print(f"Iniciando scraping con BeautifulSoup para {num_paginas} páginas...")
        datos_equipos = [] # resultado
        
        # Bucle del 1 al 5
        for pagina in range(1, num_paginas + 1):
            print(f"Scrapeando página {pagina}...")
            
            # Construimos la URL de la página actual
            url_actual = f"{url_base}?page_num={pagina}"
            
            # Extraemos toda la informacion de la pagina web
            respuesta = requests.get(url_actual)

            # Ordenamos la informacion para poder consultarka como queramos 
            conjuntoBusqueda = BeautifulSoup(respuesta.text, 'html.parser')
            
            # Buscamos todas las filas de la tabla que sean equipos
            equipos = conjuntoBusqueda.find_all('tr', class_='team')

            # Sacamos los datos de cada equipo y creamos la ficha
            for equipo in equipos:
                ficha = {
                    "Team Name": equipo.find('td', class_='name').text.strip(),
                    "Year": equipo.find('td', class_='year').text.strip(),
                    "Wins": equipo.find('td', class_='wins').text.strip(),
                    "Losses": equipo.find('td', class_='losses').text.strip(),
                    "OT Losses": equipo.find('td', class_='ot-losses').text.strip() if equipo.find('td', class_='ot-losses') else "0",
                    "Win %": equipo.find('td', class_='pct').text.strip() if equipo.find('td', class_='pct') else "0",
                    "Goals For": equipo.find('td', class_='gf').text.strip(),
                    "Goals Against": equipo.find('td', class_='ga').text.strip(),
                    "+ / -": equipo.find('td', class_='diff').text.strip()
                }
                
                # Metemos la ficha en la caja
                datos_equipos.append(ficha)
            
            # Hacemos una pausa
            time.sleep(1)
            
        return datos_equipos

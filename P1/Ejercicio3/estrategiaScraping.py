from abc import ABC, abstractmethod

class EstrategiaScraping(ABC):

    # Clase abstracta que define el contrato para todas las estrategias de scraping.

    @abstractmethod
    def extraer_datos(self, urlBase: str, numPaginas: int) -> list:
        # Extrae la información de los equipos de hockey.
        # Debe devolver una lista de diccionarios con los datos extraídos.
        pass


    
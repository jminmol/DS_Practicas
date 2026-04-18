from estrategiaScraping import EstrategiaScraping

class ContextoScraping:
    def __init__(self, estrategia: EstrategiaScraping):
        self.estrategia = estrategia

    def ejecutar_estrategia(self, urlBase: str, numPaginas: int):
        return self.estrategia.extraer_datos(urlBase, numPaginas)


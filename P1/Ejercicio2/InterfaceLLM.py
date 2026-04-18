from abc import ABC, abstractmethod

    # Define el contrato para todas las clases de procesamiento LLM.

class InterfaceLLM(ABC):        
    @abstractmethod
    def generate_summary(self, text: str): 
        # Este metodo recibe un texto y las clases que hereden implementaran la logica.
        pass

    
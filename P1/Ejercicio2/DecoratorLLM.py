import requests
from InterfaceLLM import InterfaceLLM

# ==========================================
# 1. EL DECORADOR BASE 
# ==========================================
class LLMDecorator(InterfaceLLM):

    def __init__(self, llm: InterfaceLLM):
        self.llm_envuelto = llm

    def generate_summary(self, text: str) -> str:
        # Por defecto, solo llama al método del objeto que tiene dentro
        return self.llm_envuelto.generate_summary(text)


# ==========================================
# 2. DECORADOR DE TRADUCCIÓN
# ==========================================
class TranslationDecorator(LLMDecorator):

    # Traduce el texto

    def __init__(self, llm: InterfaceLLM, model_translation: str, token: str):
        super().__init__(llm) # Inicializa la caja con el LLM base
        self.api_url = f"https://router.huggingface.co/hf-inference/models/{model_translation}"
        self.headers = {"Authorization": f"Bearer {token}"}

    def generate_summary(self, text: str) -> str:
        # Conseguimos el texto del LLM que tenemos envuelto
        texto_original = super().generate_summary(text)
        
        print("[TranslationDecorator] Traduciendo el texto al español...")
        
        # Lo traducimos usando la API
        payload = {"inputs": texto_original}
        try:
            respuesta = requests.post(self.api_url, headers=self.headers, json=payload)
            respuesta.raise_for_status()
            
            datos = respuesta.json()
            # La API de traducción devuelve una clave 'translation_text'
            texto_traducido = datos[0].get('translation_text', 'Error en traducción.')
            return texto_traducido
            
        except Exception as e:
            return f"{texto_original}\n[Error de traducción: {e}]"


# ==========================================
# 3. DECORADOR DE SENTIMIENTOS
# ==========================================
class SentimentDecorator(LLMDecorator):

    # Analiza el sentimiento del texto

    def __init__(self, llm: InterfaceLLM, model_sentiment: str, token: str):
        super().__init__(llm)
        self.api_url = f"https://router.huggingface.co/hf-inference/models/{model_sentiment}"
        self.headers = {"Authorization": f"Bearer {token}"}

    def generate_summary(self, text: str) -> str:
        # Conseguimos el texto del LLM que tenemos envuelto
        texto_original = super().generate_summary(text)
        
        print("[SentimentDecorator] Analizando el sentimiento...")
        
        # Analizamos el sentimiento de ese texto
        payload = {"inputs": texto_original}
        try:
            respuesta = requests.post(self.api_url, headers=self.headers, json=payload)
            respuesta.raise_for_status()
            
            datos = respuesta.json()
            # Cogemos la etiqueta con más puntuación, la api devuelve una lista dentro de otra
            etiqueta = datos[0][0].get('label', 'Desconocido')
            
            # Pegamos la etiqueta al final del texto original
            return f"{texto_original} \n\n[Etiqueta de Sentimiento: {etiqueta}]"
            
        except Exception as e:
            return f"{texto_original}\n[Error de sentimiento: {e}]"
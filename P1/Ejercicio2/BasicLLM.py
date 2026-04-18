import requests
from InterfaceLLM import InterfaceLLM

class BasicLLM(InterfaceLLM):
    
    def __init__(self, model_llm: str, token: str):

        # Guardamos la URL exacta del modelo que nos pasa el JSON
        self.api_url = f"https://router.huggingface.co/hf-inference/models/{model_llm}"
        
        # Preparamos la "llave" para que Hugging Face nos deje pasar
        self.headers = {"Authorization": f"Bearer {token}"}

    def generate_summary(self, text: str) -> str:
        print("[BasicLLM] Generando resumen básico...")
        
        # Preparamos los datos que le vamos a enviar a la API
        payload = {"inputs": text}
        
        try:
            # Hacemos la petición POST a Hugging Face
            respuesta = requests.post(self.api_url, headers=self.headers, json=payload)
            respuesta.raise_for_status() # Comprueba que no haya errores de conexión, de haberlo salta al exception
            
            # Hugging Face nos devuelve una lista con un diccionario. Lo extraemos.
            datos = respuesta.json()
            
            # El texto resumido viene guardado bajo la clave 'summary_text'
            resumen = datos[0].get('summary_text', 'No se pudo generar el resumen.')
            return resumen
            
        except Exception as e:
            return f"Error al conectar con Hugging Face (Resumen): {e}" 
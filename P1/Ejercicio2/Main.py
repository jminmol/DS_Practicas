import json
from BasicLLM import BasicLLM
from DecoratorLLM import TranslationDecorator, SentimentDecorator

def main():
    print("=== INICIANDO PROGRAMA LLM CON DECORADORES ===\n")

    # Leer la configuración del JSON
    try:
        # Abrimos el archivo config.json y cargamos su contenido en un diccionario
        with open('config.json', 'r', encoding='utf-8') as archivo:
            config = json.load(archivo)
        # Guardamos las variables de configuración
        texto_original = config['texto']
        token = config['huggingface_api_token']
        modelo_base = config['model_llm']
        modelo_trad = config['model_translation']
        modelo_sent = config['model_sentiment']
    
    #Prevenimos errores comunes al cargar el JSON.
    except FileNotFoundError:
        print("Error: No se encuentra el archivo 'config.json'.")
        return
    except KeyError as e:
        print(f"Error: Falta la clave {e} en el archivo JSON.")
        return

    print("Configuración cargada correctamente.\n")

    # Instanciar el LLM Básico, pasamos el modelo y el token 
    llm_base = BasicLLM(modelo_base, token)

    # Ejecutamos un resumen basico
    print("\nRUEBA 1: Resumen Básico")
    resumen_basico = llm_base.generate_summary(texto_original)
    print(f"Resultado:\n{resumen_basico}\n")

    # Resumen + Traducción
    print("\nPRUEBA 2: Resumen Traducido al Español")
    #Le pasamos el llm_base ya creado el modelo y el token
    llm_traducido = TranslationDecorator(llm_base, modelo_trad, token)
    #Lo resumen y traduce
    resumen_traducido = llm_traducido.generate_summary(texto_original)
    print(f"Resultado:\n{resumen_traducido}\n")

    # Resumen + Sentimiento
    print("\nPRUEBA 3: Resumen en Inglés + Análisis de Sentimiento")
    llm_sentimiento = SentimentDecorator(llm_base, modelo_sent, token)
    resumen_con_sentimiento = llm_sentimiento.generate_summary(texto_original)
    print(f"Resultado:\n{resumen_con_sentimiento}\n")

    # Ejecutar Prueba 4: Combinación Total (Resumen -> Traducción -> Sentimiento)
    print("\nPRUEBA 4: Combinación Total (Traducido y Analizado)")
    llm_completo = SentimentDecorator(TranslationDecorator(llm_base, modelo_trad, token),modelo_sent, token)
    resumen_total = llm_completo.generate_summary(texto_original)
    print(f"Resultado:\n{resumen_total}\n")

    print("=== FIN DEL PROGRAMA ===")

    # ==========================================
    # MODO INTERACTIVO
    # ==========================================
    print("\n" + "="*50)
    print("MODO INTERACTIVO: Construye tu propia IA")
    print("="*50)

    while True:
        # Preguntamos si quiere usar el modo interactivo
        iniciar = input("\n¿Quieres crear tu propia cadena de IA personalizada? (s/n): ")
        if iniciar.lower() != 's':
            print("\n¡Saliendo del programa!")
            break

        print("\nEmpezando con la IA Base (Resumidor)...")
        # Creamos siempre el componente base
        mi_ia_personalizada = BasicLLM(config["model_llm"], config["huggingface_api_token"])
        nombres_capas = ["Resumen Base"]

        # Bucle para ir añadiendo decoradores a gusto del usuario
        while True:
            print(f"\nTu cadena actual es: {' -> '.join(nombres_capas)}")
            print("¿Qué más quieres añadirle?")
            print("1. Añadir Traducción al Español")
            print("2. Añadir Análisis de Sentimiento")
            print("3. Ejecutar la cadena actual")
            print("4. Cancelar")

            opcion = input("Elige una opción (1-4): ")

            if opcion == '1':
                # Envolvemos la IA actual con el traductor
                mi_ia_personalizada = TranslationDecorator(mi_ia_personalizada, config["model_translation"], config["huggingface_api_token"])
                nombres_capas.append("Traducción")
                print("Traductor añadido.")
                
            elif opcion == '2':
                # Envolvemos la IA actual con el sentimiento 
                mi_ia_personalizada = SentimentDecorator(mi_ia_personalizada, config["model_sentiment"], config["huggingface_api_token"])
                nombres_capas.append("Sentimiento")
                print("Sentimiento añadido.")
                
            elif opcion == '3':
                # Ejecutamos la cadena que haya montado
                print(f"\nProcesando texto con: {' -> '.join(nombres_capas)} ")
                try:
                    resultado_interactivo = mi_ia_personalizada.generate_summary(config["texto"])
                    print("\n" + "="*40)
                    print("RESULTADO DE TU CADENA:")
                    print("="*40)
                    print(resultado_interactivo)
                    print("="*40 + "\n")
                except Exception as e:
                    print(f"Ups, algo falló en la ejecución: {e}")
                break # Salimos del bucle de montaje
                
            elif opcion == '4':
                print("Cancelando esta cadena...")
                break
                
            else:
                print("Opción no válida. Escribe 1, 2, 3 o 4.")


if __name__ == "__main__":
    main()
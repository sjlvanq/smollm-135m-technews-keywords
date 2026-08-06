import ollama

def ejecutar_extraccion_segura():
    try:
        response = ollama.chat(
            model='technews-keywords-extractor-alpha01',
            messages=[
                {
                    'role': 'user',
                    'content': 'Main terms of: The article details the evolution of Apple app icon formats, focusing on the introduction of rounded-square icons on iOS and the recent restriction in macOS to a squircle shape.'
                }
            ],
            options={
                'temperature': 0.01,
                'top_k': 25,
                'repeat_penalty': 1.1,
                'num_predict': 50,  # Límite estricto de tokens de salida para evitar bucles infinitos
                'stop': ['<|im_end|>', '<|im_start|>']
            }
        )
        print("Resultado obtenido con éxito:")
        print(response['message']['content'])
        
    except ConnectionError:
        print("Error crítico: No se pudo establecer conexión con el servidor de Ollama en localhost:11434.")
    except Exception as e:
        print(f"Excepción capturada durante la inferencia: {str(e)}")

if __name__ == '__main__':
    ejecutar_extraccion_segura()

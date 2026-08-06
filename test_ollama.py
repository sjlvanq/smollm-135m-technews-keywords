import ollama

def extract_keywords(source_text):
    try:
        response = ollama.chat(
            model='smollm-135m-technews-kw-02-q8_0',
            messages=[
                {
                    'role': 'user',
                    'content': source_text
                }
            ],
            options={
                'temperature': 0.01,
                'top_k': 25,
                'repeat_penalty': 1.1,
                'stop': ['<|im_end|>', '<|im_start|>']
            }
        )
        keywords = response['message']['content']
        print("Result obtained successfully:")
        print(keywords)
        return keywords

    except ConnectionError:
        print("Critical error: Could not establish connection with Ollama server at localhost:11434.")
        return None
    except Exception as e:
        print(f"Exception caught during inference: {str(e)}")
        return None

if __name__ == '__main__':
    source_text='Main terms of: The article details the evolution of Apple app icon formats, focusing on the introduction of rounded-square icons on iOS and the recent restriction in macOS to a squircle shape.'
    print(source_text)
    extract_keywords(source_text)

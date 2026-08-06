user_message='The company NeoTech Robotics announced the official launch of the \"Aura-X\", the first household assistant powered by general artificial intelligence and a flexible polymer body capable of performing complex home tasks with total autonomy. This device, which will hit the market next month for a price of $999, promises to revolutionize daily life by learning users routines in real time and operating silently 24 hours a day.'
echo $user_message

curl http://localhost:11434/api/chat \
  -H "Content-Type: application/json" \
  -d '{
    "model": "technews-keywords-extractor-alpha01",
    "messages": [
      {
        "role": "user",
        "content": "'"$user_message"'"
      }
    ],
    "stream": false,
    "options": {
      "num_predict": 250,
      "temperature": 0.0
    },
    "format": {
      "type": "object",
      "properties": {
        "keywords": {
          "type": "array",
          "items": {
            "type": "string"
          },
          "description": "Text keywords/terms identified.",
	  "minItems": 4,
	  "maxItems": 4
        }
      },
      "required": ["keywords"]
    }
  }'

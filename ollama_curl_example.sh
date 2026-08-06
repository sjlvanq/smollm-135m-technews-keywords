#!/bin/bash

# Check if jq is available
if command -v jq &> /dev/null; then
    # Use jq to parse JSON and iterate through summaries
    jq -c '.[]' summaries-for-testing.json | while IFS= read -r item; do
        id=$(echo "$item" | jq -r '.id')
        title=$(echo "$item" | jq -r '.title')
        summary=$(echo "$item" | jq -r '.summary')
        
        echo "============================================================"
        echo "ID: $id"
        echo "Title: $title"
        echo "============================================================"
        echo "Summary: $summary"
        echo "============================================================"
        
        curl http://localhost:11434/api/chat \
          -H "Content-Type: application/json" \
          -d "{
            \"model\": \"smollm-135m-technews-kw-02-q8_0\",
            \"messages\": [
              {
                \"role\": \"user\",
                \"content\": \"$summary\"
              }
            ],
            \"stream\": false,
            \"options\": {
              \"temperature\": 0.2,
              \"top_k\": 30,
              \"repeat_penalty\": 1.15,
              \"num_predict\": 120,
              \"stop\": [\"<|im_end|>\", \"<|im_start|>\"]
            }
          }"
        echo ""
        echo ""
    done
else
    echo "Error: jq is not installed. Please install jq to parse JSON files."
    echo "On Ubuntu/Debian: sudo apt-get install jq"
    echo "On macOS: brew install jq"
    echo ""
    echo "Falling back to using Python for JSON parsing..."
    
    python3 -c "
import json
import subprocess
import sys

with open('summaries-for-testing.json', 'r') as f:
    summaries = json.load(f)

for item in summaries:
    print('=' * 60)
    print(f\"ID: {item['id']}\")
    print(f\"Title: {item['title']}\")
    print('=' * 60)
    print(f\"Summary: {item['summary']}\")
    print('=' * 60)
    
    payload = json.dumps({
        'model': 'smollm-135m-technews-kw-02-q8_0',
        'messages': [{'role': 'user', 'content': item['summary']}],
        'stream': False,
        'options': {
            'temperature': 0.2,
            'top_k': 30,
            'repeat_penalty': 1.15,
            'num_predict': 120,
            'stop': ['<|im_end|>', '<|im_start|>']
        }
    })
    
    result = subprocess.run([
        'curl', 'http://localhost:11434/api/chat',
        '-H', 'Content-Type: application/json',
        '-d', payload
    ], capture_output=True, text=True)
    
    print(result.stdout)
    print()
"
fi

import os
import re

API_KEY_STR = "'8deca313c70c6195eba4skshgjsk7979897ss'"
API_KEY_VAR = "ApiServices.apiKey"
IMPORT_STMT = "import 'package:garamina/services/api_services.dart';\n"

def process_file(filepath):
    if "api_services.dart" in filepath:
        return
        
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    if API_KEY_STR in content:
        content = content.replace(API_KEY_STR, API_KEY_VAR)
        
        if IMPORT_STMT.strip() not in content:
            imports = list(re.finditer(r"^import\s+['\"].*?['\"];", content, re.MULTILINE))
            if imports:
                last_import = imports[-1]
                insert_idx = last_import.end() + 1
                content = content[:insert_idx] + IMPORT_STMT + content[insert_idx:]
            else:
                content = IMPORT_STMT + "\n" + content
                
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Updated APIKEY in {filepath}")

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))

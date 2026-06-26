import os
import re

def find_urls(directory):
    urls = set()
    url_pattern = re.compile(r"https?://[a-zA-Z0-9./_-]+")
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith('.dart'):
                filepath = os.path.join(root, file)
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()
                    matches = url_pattern.findall(content)
                    urls.update(matches)
    for url in sorted(list(urls)):
        print(url)

if __name__ == '__main__':
    find_urls('lib')

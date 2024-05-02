##################################################
# Version
#
# Sync version info between files
# Version 0.1.1
# Chadnaut 2024
# https://github.com/Chadnaut/Attract-Mode-Modules
#
##################################################

import os, re, glob, argparse

parser = argparse.ArgumentParser(description="Sync versions")
parser.add_argument("-s", action="store_true", help="show skipped")
parser.add_argument("-w", action="store_true", help="apply changes")
args = parser.parse_args()
skipped = args.s
apply = args.w

os.chdir(os.path.dirname(__file__))

class Info():
    title = ""
    description = ""
    version = ""
    author = ""
    url = ""
    image = ""
    readme = ""
    examples = ""

    def __init__(self, arr = None):
        if arr: self.parse(arr)

    def __repr__(self):
        return f'{str(self.title)}, {str(self.version)}, {str(self.description)}, {str(self.author)}, {str(self.url)}, {str(self.image)}, {str(self.readme)}, {str(self.examples)}'

    def __eq__(self, other):
        if not other: return False
        if other.title != self.title: return False
        if other.description != self.description: return False
        if other.version != self.version: return False
        if other.author != self.author: return False
        if other.url != self.url: return False
        if other.image != self.image: return False
        if other.readme != self.readme: return False
        if other.examples != self.examples: return False
        return True

    def max_len(self):
        return max(
            len(self.title),
            len(self.description),
            len(self.version),
            len(self.author),
            len(self.url),
        )

    def parse(self, arr):
        for n in arr:
            if (re.match(r'^Version[:\s][\d\.]+', n)):
                self.version = re.sub(r'^Version[:\s]*', '', n)
                continue
            if (re.match(r'^Url', n) or re.match(r'^http', n)):
                self.url = re.sub(r'^Url[:\s]*', '', n)
                continue
            if (re.match(r'^Title', n)):
                self.title = re.sub(r'^Title[:\s]*', '', n)
                continue
            if (re.match(r'^Author', n)):
                self.author = re.sub(r'^Author[:\s]*', '', n)
                continue
            if (re.match(r'^Description', n)):
                self.description = re.sub(r'^Description[:\s]*', '', n)
                continue
            if not self.title:
                self.title = n
                continue
            if not self.description:
                self.description = n
                continue
            if not self.author:
                self.author = n
                continue

def parseReadme(path: str):
    if (os.path.isfile(path)):
        arr = []
        head = False
        with open(path, encoding='utf-8') as file:
            for line in file:
                if head:
                    m = re.findall(r'> (.*)\n', line)
                    if m:
                        arr.append(m[0].strip())
                    if re.match(r'^#', line):
                        head = False
                        break
                else:
                    m = re.findall(r'^# (.*)\n', line)
                    if m:
                        arr.append(m[0].strip())
                        head = True
        return Info(arr)
    return None

def parseScript(path: str):
    if (os.path.isfile(path)):
        arr = []
        with open(path, encoding='utf-8') as file:
            for n in file:
                if re.match(r'^/\*', n): continue
                if re.match(r'^//', n): continue
                if re.match(r'^\s*\n', n): continue
                if re.match(r'^#*\s*\n', n): continue

                if re.match(r'^#\s+', n):
                    arr.append(re.sub(r'^#\s+', '', n.strip()))
                    continue
                if re.match(r'^>\s+', n):
                    arr.append(re.sub(r'^>\s+', '', n.strip()))
                    continue

                # print('no match')
                # print(n)
                break
        return Info(arr)
    return None

def summaryPattern(info: Info):
    return rf'\|([^|]*)\|v?([\d\.]+)\|\[([^\]]+)\]\(({info.readme})\)[\s-]*([^|]*)\|([^|]*)\|'

def parseSummary(path: str, find_info: Info):
    if (os.path.isfile(path)):
        with open(path, encoding='utf-8') as file:
            for line in file:
                m = re.findall(summaryPattern(find_info), line)
                if m:
                    info = Info()
                    info.image = m[0][0]
                    info.version = m[0][1]
                    info.title = m[0][2]
                    info.readme = m[0][3]
                    info.description = m[0][4]
                    info.examples = m[0][5]
                    return info
    return None

def updateScript(path: str, r: Info):
    with open(path, 'r', encoding='utf-8') as file: content = file.read()
    content = re.sub(r'^/\*[\w\W]*?\*/\n', '', content)
    while re.match(r'^(#[^\n]*)?\s*\n', content): content = re.sub(r'^(\s*|#[^\n]*)\n', '', content)

    max_len = r.max_len() + 2
    is_py = re.match(r'.*?\.py$', path)
    header = [
        ('' if is_py else '/*').ljust(max_len, '#'),
        f'# {r.title}',
        '#',
        f'# {r.description}',
        f'# Version {r.version}',
        f'# {r.author}',
        f'# {r.url}',
        '#',
        ('' if is_py else '*/').rjust(max_len, '#')
    ]
    content = '\n'.join(header) + '\n\n' + content
    with open(path, 'w', encoding='utf-8') as file: file.write(content)

def updateSummary(path: str, r: Info):
    with open(path, 'r', encoding='utf-8') as file: content = file.read()
    replace = f'|{r.image}|v{r.version}|[{r.title}]({r.readme}) - {r.description}|{r.examples}|'
    content = re.sub(summaryPattern(r), replace, content)
    with open(path, 'w', encoding='utf-8') as file: file.write(content)

# ===================================================

def updateItems(summary, path, readme_file, script_file):
    print()
    print(f'[{path}]')

    dir = [ f.path for f in os.scandir(path) if f.is_dir() ]
    for d in dir:
        readme = f'{d.replace('\\', '/')}/{readme_file}'
        readme_data = parseReadme(readme)
        if not readme_data:
            if skipped: print(f'{readme} - skipped (no readme)')
            continue
        readme_data.readme = readme.replace('../.', '')

        script = f'{d.replace('\\', '/')}/{script_file}'
        if not os.path.isfile(script):
            results = glob.glob(script)
            script = results[0] if results else ''
        script_data = parseScript(script)
        if not script_data:
            if skipped: print(f'{readme_data.title} - skipped (no script)')
            continue
        script_data.readme = readme_data.readme

        summary_data = parseSummary(summary, readme_data)
        # if not summary_data:
        #     if skipped: print(f'{readme_data.title} - skipped (no summary)')
        #     continue

        if summary_data:
            # copy things not in summary
            summary_data.author = readme_data.author
            summary_data.url = readme_data.url
            # copy things not in readme
            readme_data.image = summary_data.image
            readme_data.examples = summary_data.examples
            # copy things not in script
            script_data.readme = summary_data.readme
            script_data.image = summary_data.image
            script_data.examples = summary_data.examples

        update_script = not script_data == readme_data
        update_summary = summary_data and not summary_data == readme_data

        applied = 'applied' if apply else 'required'
        if update_script:
            print(f'{'✔️' if apply else '⚠️'}  {readme_data.title} - script update {applied}')
            if apply: updateScript(script, readme_data)
        if update_summary:
            print(f'{'✔️' if apply else '⚠️'}  {readme_data.title} - summary update {applied}')
            if apply: updateSummary(summary, readme_data)
        if not update_script and not update_summary:
            print(f'✔️  {readme_data.title}')

updateItems('../../README.md', '../../modules', 'README.md', 'module.nut')
updateItems('../../README.md', '../../plugins', 'README.md', 'plugin.nut')
updateItems('../../README.md', '../../scripts', 'README.md', '*.py')

if not apply:
    print()
    print('run with -w to apply changes')
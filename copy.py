import os
import json
import shutil
from git import Repo
from pathlib import Path

working_dir = "/home/seva/git/backup"
json_file = "/home/seva/projects/python/conf/data.json"

# Получаем список всех конфигов, кроме .git и env
configs = [f for f in os.listdir(working_dir) if f not in {".git", "env", "copy.py"}]

# Удаляем старые файлы
for filename in configs:
    full_path = os.path.join(working_dir, filename)
    if os.path.isfile(full_path):
        os.remove(full_path)

# Загружаем пути из JSON
with open(json_file) as f:
    data = json.load(f)

# Копируем файлы в рабочую директорию
for src in data.values():
    if os.path.isfile(src):
        shutil.copy(src, working_dir)

# --- Git часть ---
repo_path = Path(working_dir)
repo = Repo(repo_path)

# Добавляем все файлы в индекс
repo.git.add(all=True)

# Проверяем наличие изменений
if repo.is_dirty(untracked_files=True):
    # Делаем коммит
    repo.index.commit("Автоматическое обновление конфигов")

    # Пушим изменения в origin (по умолчанию main, если не указано иное)
    origin = repo.remote(name="origin")
    origin.push()
    print("✅ Изменения закоммичены и запушены.")
else:
    print("ℹ️ Нет изменений для коммита.")


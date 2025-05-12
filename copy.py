import os
import json
from os.path import isfile
import shutil
import sys
import subprocess
from git import Repo
from pathlib import Path

working_dir = "/home/seva/git/backup"
json_file = "/home/seva/projects/python/conf/data.json"

# Получаем список всех конфигов, кроме .git и env
configs = [f for f in os.listdir(working_dir) if f not in {".git", "env", "copy.py", "pkglist_official.txt","pkglist_aur.txt"}]

# Удаляем старые файлы
for filename in configs:
    full_path = os.path.join(working_dir, filename)
    if os.path.isfile(full_path):
        os.remove(full_path)

# Загружаем пути из JSON
with open(json_file) as f:
    data = json.load(f)

import subprocess

def generate_package_lists(
    pacman_output="pkglist_official.txt",
    aur_output="pkglist_aur.txt"
):
    aur_path=os.path.join(working_dir, aur_output)
    pacman_path=os.path.join(working_dir, pacman_output)
    if os.path.isfile(pacman_path):
        os.remove(pacman_path)
    if os.path.isfile(aur_path):
        os.remove(aur_path)
    """Создаёт два файла: список официальных пакетов pacman и AUR-пакетов"""

    # Получаем явно установленные пакеты (не зависимости)
    result = subprocess.run(["pacman", "-Qqe"], capture_output=True, text=True)
    if result.returncode != 0:
        raise RuntimeError("Ошибка при выполнении pacman -Qqe")

    installed_packages = result.stdout.strip().split("\n")

    # Получаем все пакеты из официальных репозиториев
    repo_result = subprocess.run(["pacman", "-Slq"], capture_output=True, text=True)
    if repo_result.returncode != 0:
        raise RuntimeError("Ошибка при выполнении pacman -Slq")

    official_packages = set(repo_result.stdout.strip().split("\n"))

    # Разделение пакетов
    official = []
    aur = []

    for pkg in installed_packages:
        (official if pkg in official_packages else aur).append(pkg)

    # Сохраняем в файлы
    with open(pacman_path, "w") as f:
        f.write("\n".join(official) + "\n")

    with open(aur_path, "w") as f:
        f.write("\n".join(aur) + "\n")

    print(f"[✓] Список официальных пакетов сохранён в {pacman_output}")
    print(f"[✓] Список AUR-пакетов сохранён в {aur_output}")
    print(f"Всего: {len(official)} официальных, {len(aur)} AUR")





if len(sys.argv) > 1 and sys.argv[1] == "-pkg":
    generate_package_lists()


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


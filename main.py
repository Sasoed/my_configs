from pathlib import Path
import subprocess
from git import Repo

working_dir = "/home/seva/git/backup/.config"



# Команда rsync с параметрами
command = [
    "rsync",
    "-rp",
    "--exclude=*chrome*",
    "--exclude=discord",
    "/home/seva.config/",
    working_dir
]

# Запуск команды
try:
    subprocess.run(command, check=True)
    print("Резервное копирование завершено успешно.")
except subprocess.CalledProcessError as e:
    print(f"Ошибка при выполнении rsync: {e}")


def save_package_lists(backup_dir=working_dir):
    Path(backup_dir).mkdir(parents=True, exist_ok=True)

    # Путь к файлам
    pacman_file = Path(backup_dir) / "pkglist_official.txt"
    yay_file = Path(backup_dir) / "pkglist_aur.txt"

    # Сохраняем официальные пакеты
    pacman_result = subprocess.run(
        ["pacman", "-Qqe"],
        capture_output=True,
        text=True,
        check=True
    )
    with pacman_file.open("w") as f:
        f.write(pacman_result.stdout)

    # Сохраняем AUR-пакеты (установленные не из оф. репозиториев)
    aur_result = subprocess.run(
        ["pacman", "-Qqm"],
        capture_output=True,
        text=True,
        check=True
    )
    with yay_file.open("w") as f:
        f.write(aur_result.stdout)

    print(f"Списки пакетов сохранены в:\n- {pacman_file}\n- {yay_file}")


# --- Git часть ---
repo_path = Path("/home/seva/git/backup")
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

#!/usr/bin/env python3
"""
Резервное копирование ~/.config в git-репозиторий и
сохранение списков пакетов pacman/aur.
"""
from pathlib import Path
import subprocess
from git import Repo
import sys

# ────────────────────── Параметры ──────────────────────
HOME          = Path.home()
SRC_DIR       = HOME / ".config"                       # Что копируем
DEST_REPO     = HOME / "git" / "backup"               # Корень репозитория
DEST_DIR      = DEST_REPO / ".config"                 # Куда копируем
EXCLUDES      = ["*chrome*", "discord"]               # Шаблоны исключений
PACMAN_FILE   = DEST_DIR / "pkglist_official.txt"
AUR_FILE      = DEST_DIR / "pkglist_aur.txt"

# ────────────────────── Rsync ──────────────────────────
def run_rsync():
    DEST_DIR.mkdir(parents=True, exist_ok=True)
    cmd = ["rsync", "-rp"] + sum([["--exclude", pat] for pat in EXCLUDES], []) \
          + [f"{SRC_DIR}/", str(DEST_DIR)]
    try:
        subprocess.run(cmd, check=True)
        print("✅ Конфиги скопированы.")
    except subprocess.CalledProcessError as e:
        print(f"❌ Rsync завершился с ошибкой ({e.returncode}). "
              f"Команда: {' '.join(cmd)}")
        sys.exit(1)

# ────────────────────── Сохранение списков пакетов ────
def save_package_lists():
    for cmd, outfile in [(["pacman", "-Qqe"], PACMAN_FILE),
                         (["pacman", "-Qqm"], AUR_FILE)]:
        try:
            result = subprocess.run(cmd, capture_output=True, text=True, check=True)
            outfile.write_text(result.stdout)
        except subprocess.CalledProcessError as e:
            print(f"❌ Не удалось получить список пакетов ({' '.join(cmd)}): {e}")
            sys.exit(1)
    print(f"✅ Списки пакетов сохранены:\n   ✅ {PACMAN_FILE}\n  ✅ {AUR_FILE}")

# ────────────────────── Git-часть ──────────────────────
def commit_and_push():
    repo = Repo(DEST_REPO)
    repo.git.add(all=True)
    if repo.is_dirty(untracked_files=True):
        repo.index.commit("Автоматическое обновление конфигов")
        repo.remote(name="origin").push()
        print("✅ Изменения закоммичены и запушены.")
    else:
        print("ℹ️ Изменений нет — коммит не нужен.")

# ────────────────────── main ───────────────────────────
if __name__ == "__main__":
    run_rsync()
    save_package_lists()
    commit_and_push()


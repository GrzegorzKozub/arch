#!/usr/bin/env python3

import os
import shutil
import subprocess
import tarfile
from datetime import datetime
from pathlib import Path
from typing import Any

import requests

DIR = "/run/media/greg/data/github"


def env() -> None:
    path = Path(__file__).with_name("github.env")
    if not path.exists():
        return
    for line in path.read_text().splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        key = key.strip()
        if key and key not in os.environ:
            os.environ[key] = value.strip().strip('"').strip("'")


def fetch() -> list[dict[str, Any]]:
    url = "https://api.github.com/user/repos?per_page=100&page=1"
    headers = {"Authorization": f"Bearer {os.environ.get('GITHUB_PAT')}"}
    repos: list[dict[str, Any]] = []
    while url:
        res = requests.get(url, headers=headers, timeout=15)
        repos += res.json()
        url = res.links["next"]["url"] if "next" in res.links else None
    repos = list(filter(lambda repo: repo["owner"]["login"] == "GrzegorzKozub", repos))
    repos.sort(key=lambda repo: repo["name"].lower())
    return repos


def mkdir() -> Path:
    dir = Path(DIR) / datetime.now().strftime("%Y%m%d%H%M")
    if dir.exists():
        shutil.rmtree(dir)
    dir.mkdir()
    return dir


def clone(repos: list[dict[str, Any]], dir: Path) -> None:
    print("\033[33m \033[37mcloning \033[0m", end="", flush=True)
    for repo in repos:
        print(f"\033[36m{repo['name']} \033[0m", end="", flush=True)
        subprocess.run(
            [
                "git",
                "clone",
                "--mirror",
                "--quiet",
                repo["ssh_url"],
                str(dir / f"{repo['name']}.git"),
            ],
            check=True,
        )
    print()


def compress(dir: Path) -> None:
    file = dir.with_suffix(".tar.gz")
    if file.exists():
        file.unlink()
    with tarfile.open(file, "w:gz") as tar:
        tar.add(dir, arcname=dir.name)
    shutil.rmtree(dir)
    print(f"\033[33m \033[37mbackup file \033[36m{file} \033[37mcreated\033[0m")


def main() -> None:
    env()
    dir = mkdir()
    clone(fetch(), dir)
    compress(dir)


if __name__ == "__main__":
    main()

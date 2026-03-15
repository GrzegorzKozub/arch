#!/usr/bin/env python3

import os
import shutil
import subprocess
import tarfile
from concurrent.futures import ThreadPoolExecutor, as_completed
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


def list_repos() -> list[dict[str, Any]]:
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


def make_backup_dir() -> Path:
    dir = Path(DIR) / datetime.now().strftime("%Y%m%d%H%M")
    if dir.exists():
        shutil.rmtree(dir)
    dir.mkdir()
    return dir


def clone_repo(repo: dict[str, Any], dir: Path) -> str:
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
    return str(repo["name"])


def clone_repos(repos: list[dict[str, Any]], dir: Path) -> None:
    print("\033[33m \033[37mcloning \033[0m", end="", flush=True)
    with ThreadPoolExecutor(max_workers=min(8, len(repos))) as exec:
        for future in as_completed(
            {exec.submit(clone_repo, repo, dir): repo["name"] for repo in repos}
        ):
            print(f"\033[36m{future.result()} \033[0m", end="", flush=True)
    print()


def compress(dir: Path) -> None:
    file = dir.with_suffix(".tar.gz")
    print(f"\033[33m \033[37mcreating \033[36m{file} \033[0m")
    if file.exists():
        file.unlink()
    with tarfile.open(file, "w:gz") as tar:
        tar.add(dir, arcname=dir.name)
    shutil.rmtree(dir)


def main() -> None:
    env()
    dir = make_backup_dir()
    clone_repos(list_repos(), dir)
    compress(dir)


if __name__ == "__main__":
    main()

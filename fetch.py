#!/usr/bin/env python3

import os
import re
from typing import Any

import requests

repos: list[Any] = []


def fetch(owner: str, token: str, public: bool = False) -> list[Any]:
    url = f"https://api.github.com/{owner}/repos?per_page=100&page=1"
    if not public:
        url += "&type=private"
    headers = {"Authorization": f"Bearer {os.environ.get(token)}"}
    repos: list[Any] = []
    while url:
        res = requests.get(url, headers=headers, timeout=15)
        repos += res.json()
        url = res.links["next"]["url"] if "next" in res.links else None
    return repos


repos += fetch("orgs/efficy-sa", "GITHUB_PAT_EFFICY")
repos += fetch("user", "GITHUB_PAT_GREG", True)

repos = list(
    filter(
        lambda repo: not repo["archived"] and not re.match(r"^-|\.", repo["name"]),
        repos,
    )
)
repos = list(map(lambda repo: f"{repo['name']} {repo['owner']['login']}", repos))
repos.sort()

DIR = f"{os.environ.get('XDG_CACHE_HOME')}/fetch"
os.makedirs(DIR, exist_ok=True)

with open(f"{DIR}/repos", "w", encoding="utf-8") as file:
    file.write("\n".join(repos))

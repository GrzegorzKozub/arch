#!/usr/bin/env python3

import os
from typing import Any

import requests

repos: list[Any] = []


def fetch() -> list[Any]:
    url = "https://api.github.com/user/repos?per_page=100&page=1"
    headers = {"Authorization": f"Bearer {os.environ.get('GITHUB_PAT')}"}
    repos: list[Any] = []
    while url:
        res = requests.get(url, headers=headers, timeout=15)
        repos += res.json()
        url = res.links["next"]["url"] if "next" in res.links else None
    return repos


repos += fetch()

repos = list(filter(lambda repo: not repo["archived"], repos))
repos = list(map(lambda repo: f"{repo['name']} {repo['owner']['login']}", repos))
repos.sort()
print(repos)

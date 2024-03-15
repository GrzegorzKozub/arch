#!/usr/bin/env python3

# pylint: disable=C0103

import os
import re

import requests

repos: list[str] = []

url = "https://api.github.com/orgs/ApsisInternational/repos?per_page=100&page=1&type=private"
headers = {"Authorization": f"Bearer {os.environ.get('GITHUB_PAT')}"}

while url:
    res = requests.get(url, headers=headers, timeout=15)
    repos = repos + list(map(lambda repo: repo["name"], res.json()))
    url = res.links["next"]["url"] if "next" in res.links else None

repos = list(filter(lambda repo: not re.match(r"^-|\.", repo), repos))
repos.sort()

DIR = f"{os.environ.get('XDG_CACHE_HOME')}/fetch"
os.makedirs(DIR, exist_ok=True)

with open(f"{DIR}/repos", "w", encoding="utf-8") as file:
    file.write("\n".join(repos))

#!/usr/bin/env python3
"""Fuzzy kitty tab picker: lists tabs by git repo name and focuses the chosen one.

Run inside a kitty overlay with remote control granted to it, e.g.:
    map ctrl+f launch --type=overlay --allow-remote-control python3 ~/.config/kitty/tab_picker.py

Talks to kitty over the controlling tty (same protocol `kitty @` uses) to avoid
spawning a second kitty process; falls back to `kitty @` if that fails.
"""
import json
import os
import select
import shutil
import subprocess
import sys
import termios
import tty

FZF_FALLBACKS = ("/opt/homebrew/bin/fzf", "/usr/local/bin/fzf")
PROTOCOL_VERSION = [0, 14, 2]
PREFIX = b"\x1bP@kitty-cmd"
SUFFIX = b"\x1b\\"


def find_fzf():
    found = shutil.which("fzf")
    if found:
        return found
    for path in FZF_FALLBACKS:
        if os.access(path, os.X_OK):
            return path
    sys.exit("fzf not found")


def send_command(name, payload=None, want_response=True):
    message = {"cmd": name, "version": PROTOCOL_VERSION, "no_response": not want_response}
    if payload:
        message["payload"] = payload
    fd = os.open("/dev/tty", os.O_RDWR | os.O_NOCTTY)
    saved = termios.tcgetattr(fd)
    try:
        tty.setraw(fd)
        os.write(fd, PREFIX + json.dumps(message).encode() + SUFFIX)
        if not want_response:
            termios.tcdrain(fd)
            return None
        buf = b""
        while not buf.endswith(SUFFIX):
            if not select.select([fd], [], [], 3)[0]:
                raise TimeoutError("no response from kitty")
            buf += os.read(fd, 65536)
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, saved)
        os.close(fd)
    start = buf.index(PREFIX) + len(PREFIX)
    response = json.loads(buf[start:-len(SUFFIX)])
    if not response.get("ok"):
        raise RuntimeError(response.get("error", "kitty command failed"))
    data = response.get("data")
    return json.loads(data) if isinstance(data, str) else data


def kitty_ls():
    try:
        return send_command("ls")
    except Exception:
        return json.loads(subprocess.check_output(["kitty", "@", "ls"]))


def focus_tab(tab_id):
    try:
        send_command("focus_tab", {"match": f"id:{tab_id}"}, want_response=False)
    except Exception:
        subprocess.run(["kitty", "@", "focus-tab", "--match", f"id:{tab_id}"])


_repo_cache = {}


def repo_name(cwd):
    """Name of the nearest ancestor containing .git, else the directory's own name."""
    if cwd in _repo_cache:
        return _repo_cache[cwd]
    path = cwd
    while True:
        if os.path.lexists(os.path.join(path, ".git")):
            break
        parent = os.path.dirname(path)
        if parent == path:
            path = cwd
            break
        path = parent
    name = os.path.basename(path.rstrip("/")) or cwd
    _repo_cache[cwd] = name
    return name


def window_cwd(window):
    # Foreground process cwd follows `cd` in the shell; window["cwd"] may be the launch dir.
    procs = window.get("foreground_processes") or []
    for proc in reversed(procs):
        if proc.get("cwd"):
            return proc["cwd"]
    return window.get("cwd") or ""


def list_tabs():
    rows = []
    for os_window in kitty_ls():
        for index, tab in enumerate(os_window["tabs"], start=1):
            if tab.get("is_focused"):
                continue
            windows = tab["windows"]
            active = next((w for w in windows if w.get("is_active")), windows[0])
            cwd = window_cwd(active)
            rows.append((tab["id"], index, repo_name(cwd) if cwd else "?", tab["title"], cwd))
    return rows


def main():
    rows = list_tabs()
    if not rows:
        return
    home = os.path.expanduser("~")
    lines = [
        f"{tab_id}\t{repo}\t{index}: {title}\t{cwd.replace(home, '~', 1)}"
        for tab_id, index, repo, title, cwd in rows
    ]
    result = subprocess.run(
        [find_fzf(), "--delimiter=\t", "--with-nth=2..", "--nth=1,2",
         "--tabstop=4", "--reverse", "--prompt=tab> ", "--exit-0",
         "--margin=20%,25%", "--border=rounded", "--padding=1,2"],
        input="\n".join(lines), stdout=subprocess.PIPE, text=True,
    )
    choice = result.stdout.strip()
    if choice:
        focus_tab(choice.split("\t", 1)[0])


if __name__ == "__main__":
    main()

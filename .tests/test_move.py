"""Runs ./move between two fake WoW installs that share one fake GitHub repo.

    uv run --with pytest pytest .tests/test_move.py -q
"""
import os
import shutil
import subprocess
from pathlib import Path

ADDONS = Path(__file__).resolve().parent.parent


def git(*args, cwd):
    subprocess.run(["git", *args], cwd=cwd, check=True, capture_output=True)


def write(path, text, age=0):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text)
    t = 2_000_000_000 - age
    os.utime(path, (t, t))


def setup(tmp_path):
    wow = tmp_path / "World of Warcraft"
    work = tmp_path / "work"
    for script in ("move", "characters"):
        write(work / script, (ADDONS / script).read_text())
        (work / script).chmod(0o755)
    write(work / ".gitignore", "Personal/\nZ-Settings/ZCharacters.lua\n")
    write(work / "Shared" / "Shared.toc", "## SavedVariables: SharedDB\n")
    write(work / "Z-Settings" / "ZSettings.lua", "-- addon\n")
    git("init", "-q", "-b", "main", cwd=work)
    git("add", "-A", cwd=work)
    git("-c", "user.name=t", "-c", "user.email=t@t", "commit", "-q", "-m", "init", cwd=work)
    origin = tmp_path / "origin.git"
    git("clone", "-q", "--bare", str(work), str(origin), cwd=tmp_path)

    src = wow / "_classic_beta_"
    src_addons = src / "Interface" / "AddOns"
    src_addons.parent.mkdir(parents=True)
    git("clone", "-q", str(origin), str(src_addons), cwd=tmp_path)
    write(src_addons / "Personal" / "Personal.toc", "## Title: mine\n")
    for account, age in (("1#1", 0), ("1#3", 100)):
        sv = src / "WTF" / "Account" / account / "SavedVariables"
        write(sv / "Questie.lua", f"QuestieConfig = {{ from = '{account}' }}\n", age)
        write(sv / "Questie.lua.bak", "old\n", age)
    write(src / "WTF" / "Account" / "1#1" / "SavedVariables" / "Z-Settings.lua",
          'ZSettingsDB = {\n["characters"] = {\n["Lock-Realm"] = "ZC1:abc",\n},\n}\n')

    dst = wow / "_forever_"
    write(dst / "Interface" / "AddOns" / "WoWCompanion" / "WoWCompanion.toc", "## Title: c\n")
    write(dst / "WTF" / "Account" / "1#1" / "SavedVariables" / "Questie.lua", "QuestieConfig = { fresh = true }\n")
    return src_addons, dst, origin


def run(src_addons, tasklist="true"):
    env = {**os.environ, "TASKLIST": tasklist}
    return subprocess.run(["sh", str(src_addons / "move")], env=env, capture_output=True, text=True)


def test_moves_addons_settings_and_saves(tmp_path):
    src_addons, dst, origin = setup(tmp_path)
    r = run(src_addons)
    assert r.returncode == 0, r.stderr
    addons = dst / "Interface" / "AddOns"
    out = subprocess.run(["git", "remote", "get-url", "origin"], cwd=addons, capture_output=True, text=True)
    assert out.stdout.strip() == str(origin)
    assert (addons / "Shared" / "Shared.toc").exists()
    assert (addons / "Personal" / "Personal.toc").exists()
    assert '"ZC1:abc"' in (addons / "Z-Settings" / "ZCharacters.lua").read_text()
    for account in ("1#1", "1#3"):
        sv = dst / "WTF" / "Account" / account / "SavedVariables"
        assert "from = '1#1'" in (sv / "Questie.lua").read_text()   # the newest copy wins
        assert (sv / "Z-Settings.lua").exists()
        assert not (sv / "Questie.lua.bak").exists()
    [backup] = dst.glob("before-move-*")
    assert (backup / "AddOns" / "WoWCompanion" / "WoWCompanion.toc").exists()
    assert "fresh" in (backup / "WTF" / "Account" / "1#1" / "SavedVariables" / "Questie.lua").read_text()


def test_second_run_updates_the_checkout(tmp_path):
    src_addons, dst, _ = setup(tmp_path)
    assert run(src_addons).returncode == 0
    shutil.rmtree(dst / "Interface" / "AddOns" / "Personal")
    r = run(src_addons)
    assert r.returncode == 0, r.stderr
    assert (dst / "Interface" / "AddOns" / "Personal" / "Personal.toc").exists()
    assert not list(dst.glob("before-move-*/AddOns/AddOns"))


def test_refuses_unpublished_changes(tmp_path):
    src_addons, dst, _ = setup(tmp_path)
    write(src_addons / "NewAddon" / "NewAddon.toc", "## Title: new\n")
    r = run(src_addons)
    assert r.returncode == 1 and "./publish" in r.stderr
    assert (dst / "Interface" / "AddOns" / "WoWCompanion").exists()


def test_refuses_while_wow_runs(tmp_path):
    src_addons, dst, _ = setup(tmp_path)
    r = run(src_addons, tasklist="echo Wow.exe 123 Console")
    assert r.returncode == 1 and "WoW is running" in r.stderr
    assert not list(dst.glob("before-move-*"))

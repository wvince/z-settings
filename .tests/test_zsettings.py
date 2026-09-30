"""Runs Z-Settings inside the simulated WoW (sim.lua) under Lua 5.1, and the commit hook on a fake install.

    uv run --with lupa --with pytest pytest .tests/test_zsettings.py -q
"""
import subprocess
from pathlib import Path

from lupa import lua51

ADDONS = Path(__file__).resolve().parent.parent
HOOK = ADDONS / ".githooks" / "pre-commit"


def test_simulated_export_import_undo():
    addon = (ADDONS / "Z-Settings" / "ZSettings.lua").read_text()
    sim = (ADDONS / ".tests" / "sim.lua").read_text()
    lua = lua51.LuaRuntime()
    out = []
    lua.globals().io = lua.table(write=lambda *a: out.append("".join(str(x) for x in a)))
    lua.eval("function(src, addon) local f, e = loadstring(src) if not f then error(e) end return f(addon) end")(sim, addon)
    report = "".join(out)
    assert not [l for l in report.splitlines() if l.startswith("FAIL")], report
    assert " 0 failed" in report


def fake_install(tmp_path, exports):
    """exports: {account: text or None}, oldest first."""
    addons = tmp_path / "Interface" / "AddOns"
    (addons / "Z-Settings").mkdir(parents=True)
    subprocess.run(["git", "init", "-q"], cwd=addons, check=True)
    for i, (account, text) in enumerate(exports.items()):
        sv = tmp_path / "WTF" / "Account" / account / "SavedVariables"
        sv.mkdir(parents=True)
        body = 'ZSettingsDB = {\n["exportMade"] = "x",\n["export"] = "%s",\n}\n' % text if text else "ZSettingsDB = {\n}\n"
        f = sv / "Z-Settings.lua"
        f.write_text(body)
        subprocess.run(["touch", "-d", f"2026-01-0{i + 1}", str(f)], check=True)
    return addons


def run_hook(addons):
    return subprocess.run(["sh", str(HOOK)], cwd=addons, capture_output=True, text=True)


def test_hook_bundles_newest_export(tmp_path):
    addons = fake_install(tmp_path, {"1#1": "ZS1:old", "2#3": "ZS1:new+/="})
    r = run_hook(addons)
    assert r.returncode == 0, r.stderr
    assert (addons / "Z-Settings" / "ZBundle.lua").read_text() == 'Z_BUNDLE = "ZS1:new+/="\n'
    staged = subprocess.run(["git", "diff", "--cached", "--name-only"], cwd=addons, capture_output=True, text=True).stdout
    assert "Z-Settings/ZBundle.lua" in staged


def test_hook_blocks_commit_without_export(tmp_path):
    addons = fake_install(tmp_path, {"1#1": None})
    r = run_hook(addons)
    assert r.returncode != 0
    assert "/z export" in r.stderr
    assert not (addons / "Z-Settings" / "ZBundle.lua").exists()

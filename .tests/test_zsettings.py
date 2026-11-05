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
    characters = (ADDONS / "Z-Settings" / "Characters.lua").read_text()
    minimap = (ADDONS / "Z-Settings" / "Minimap.lua").read_text()
    sim = (ADDONS / ".tests" / "sim.lua").read_text()
    lua = lua51.LuaRuntime()
    out = []
    lua.globals().io = lua.table(write=lambda *a: out.append("".join(str(x) for x in a)))
    lua.eval("function(src, ...) local f, e = loadstring(src) if not f then error(e) end return f(...) end")(sim, addon, characters, minimap)
    report = "".join(out)
    assert not [l for l in report.splitlines() if l.startswith("FAIL")], report
    assert " 0 failed" in report


def fake_install(tmp_path, exports):
    """exports: {account: text or None}, oldest first."""
    addons = tmp_path / "Interface" / "AddOns"
    (addons / "Z-Settings").mkdir(parents=True)
    (addons / "GTFO").mkdir()
    (addons / "GTFO" / "GTFO.toc").write_bytes(b"## Title: GTFO\r\n## SavedVariables: GTFOData, GTFOOther\r\n## SavedVariablesPerCharacter: GTFOChar\r\ncore.lua\r\n")
    (addons / "GTFO" / "GTFO_Mainline.toc").write_text("## SavedVariables: GTFOData\n")
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


def export_with_loaded_list(addons, account):
    """/reload loads the ZBundle.lua the hook wrote, then /z export records its Z_VARS_ID."""
    bundle = (addons / "Z-Settings" / "ZBundle.lua").read_text()
    var_id = bundle.split('Z_VARS_ID = "')[1].split('"')[0]
    f = addons.parent.parent / "WTF" / "Account" / account / "SavedVariables" / "Z-Settings.lua"
    f.write_text(f.read_text().replace("{\n", '{\n["exportVars"] = "%s",\n' % var_id, 1))


def test_hook_bundles_newest_export(tmp_path):
    addons = fake_install(tmp_path, {"1#1": "ZS1:old", "2#3": "ZS1:new+/="})
    # first commit: the game never loaded these names, so the export can't hold their settings
    r = run_hook(addons)
    assert r.returncode != 0 and "/z export" in r.stderr
    # trying again without a new export changes nothing
    assert run_hook(addons).returncode != 0
    # after /reload and /z export the export matches the list and the commit goes through
    export_with_loaded_list(addons, "2#3")
    r = run_hook(addons)
    assert r.returncode == 0, r.stderr
    bundle = (addons / "Z-Settings" / "ZBundle.lua").read_text()
    assert 'Z_BUNDLE = "ZS1:new+/="\n' in bundle
    # every flavor's toc merged; per-character tables in their own list
    z_vars, z_charvars = bundle.split("Z_CHARVARS = {")
    assert '["GTFO"] = { "GTFOData","GTFOOther" },' in z_vars and "GTFOChar" not in z_vars
    assert '["GTFO"] = { "GTFOChar" },' in z_charvars
    staged = subprocess.run(["git", "diff", "--cached", "--name-only"], cwd=addons, capture_output=True, text=True).stdout
    assert "Z-Settings/ZBundle.lua" in staged


def test_hook_refuses_an_empty_publish(tmp_path):
    addons = fake_install(tmp_path, {"2#3": "ZS1:same"})
    run_hook(addons)   # the first run writes the settings names and asks for a re-export
    export_with_loaded_list(addons, "2#3")
    assert run_hook(addons).returncode == 0
    git = ["git", "-c", "user.name=t", "-c", "user.email=t@t", "commit", "-q", "--no-verify", "-m", "setup"]
    subprocess.run(git, cwd=addons, check=True)
    # publishing again with the same export and no other change: nothing to commit
    r = run_hook(addons)
    assert r.returncode != 0 and "Nothing new to publish" in r.stderr


def test_hook_blocks_commit_without_export(tmp_path):
    addons = fake_install(tmp_path, {"1#1": None})
    r = run_hook(addons)
    assert r.returncode != 0
    assert "/z export" in r.stderr
    assert not (addons / "Z-Settings" / "ZBundle.lua").exists()


def test_characters_gathers_every_accounts_saves(tmp_path):
    addons = fake_install(tmp_path, {"1#1": None, "2#3": None})
    script = addons / "characters"
    script.write_text((ADDONS / "characters").read_text())
    old = tmp_path / "WTF" / "Account" / "1#1" / "SavedVariables" / "Z-Settings.lua"
    new = tmp_path / "WTF" / "Account" / "2#3" / "SavedVariables" / "Z-Settings.lua"
    old.write_text('ZSettingsDB = {\r\n["characters"] = {\r\n["Alt-Realm"] = "ZC1:alt",\r\n["Main-Realm"] = "ZC1:stale",\r\n},\r\n["undo"] = {\r\n["Alt-Realm"] = "ZS1:undo",\r\n},\r\n}\r\n')
    new.write_text('ZSettingsDB = {\n["characters"] = {\n["Main-Realm"] = "ZC1:new+/="\n},\n}\n')
    subprocess.run(["touch", "-d", "2026-01-01", str(old)], check=True)
    subprocess.run(["touch", "-d", "2026-01-02", str(new)], check=True)
    r = subprocess.run(["sh", str(script)], capture_output=True, text=True)
    assert r.returncode == 0, r.stderr
    out = (addons / "Z-Settings" / "ZCharacters.lua").read_text()
    assert '["Main-Realm"] = "ZC1:new+/=",' in out and "stale" not in out
    assert '["Alt-Realm"] = "ZC1:alt",' in out and "undo" not in out
    assert "\r" not in out and out.rstrip().endswith("}")


def test_hook_catches_an_addon_added_after_the_export(tmp_path):
    addons = fake_install(tmp_path, {"2#3": "ZS1:x"})
    run_hook(addons)
    export_with_loaded_list(addons, "2#3")
    assert run_hook(addons).returncode == 0
    (addons / "NewAddon").mkdir()
    (addons / "NewAddon" / "NewAddon.toc").write_text("## SavedVariables: NewDB\n")
    r = run_hook(addons)
    assert r.returncode != 0 and "/reload" in r.stderr and "NewAddon" in r.stderr
    assert run_hook(addons).returncode != 0   # still refused until a new export


def test_hook_ignores_addons_that_are_never_shared(tmp_path):
    addons = fake_install(tmp_path, {"2#3": "ZS1:x"})
    run_hook(addons)
    export_with_loaded_list(addons, "2#3")
    git = ["git", "-c", "user.name=t", "-c", "user.email=t@t", "commit", "-q", "--no-verify", "-m", "setup"]
    assert run_hook(addons).returncode == 0
    subprocess.run(git, cwd=addons, check=True)
    # a private addon, gitignored: no re-export, and its names stay out of the bundle
    (addons / "Private").mkdir()
    (addons / "Private" / "Private.toc").write_text("## SavedVariables: PrivateDB\n")
    (addons / ".gitignore").write_text("Private/\n")
    subprocess.run(["git", "add", ".gitignore"], cwd=addons, check=True)
    r = run_hook(addons)
    assert r.returncode == 0, r.stderr
    assert "PrivateDB" not in (addons / "Z-Settings" / "ZBundle.lua").read_text()
    subprocess.run(git, cwd=addons, check=True)
    # an addon removed since the export: nothing missing, so still no re-export
    for f in (addons / "GTFO").iterdir():
        f.unlink()
    (addons / "GTFO").rmdir()
    (addons / "README.md").write_text("changed\n")
    subprocess.run(["git", "add", "README.md"], cwd=addons, check=True)
    r = run_hook(addons)
    assert r.returncode == 0, r.stderr


def test_hook_drops_a_tocs_load_conditions_from_the_names(tmp_path):
    addons = fake_install(tmp_path, {"2#3": "ZS1:x"})
    (addons / "Trainer").mkdir()
    (addons / "Trainer" / "Trainer.toc").write_text(
        "## SavedVariables: WT_Icon, WT_Waypoint [AllowLoadGameType classic][ExcludeLoadGameType camelot]\n"
        "## SavedVariables: WT_Icon, WT_Profession [AllowLoadGameType camelot]\n")
    run_hook(addons)
    bundle = (addons / "Z-Settings" / "ZBundle.lua").read_text()
    assert '["Trainer"] = { "WT_Icon","WT_Profession","WT_Waypoint" },' in bundle

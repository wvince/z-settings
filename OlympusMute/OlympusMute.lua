-- OlympusMute: hides chat from players whose guild name contains "Olympus"
-- (or any other guild name you add to the list).
-- Purely client-side. Nothing is added to the ignore list; senders aren't notified.
--
-- Chat events don't carry the sender's guild, so the addon learns guilds by
-- watching players it can see (target, mouseover, nameplates, group) and from
-- any /who results you run. Learned players are saved between sessions.

local DEFAULT_KEYWORDS = { "olympus" }   -- case-insensitive parts of guild names
local MIN_KEYWORD_LEN = 3                  -- stops "a" from muting half the server
local PREFIX = "|cff66ccffOlympusMute:|r "

local db
local playerGUID
local playerKey                     -- your own normalized name, set at login
local panel, category, CreatePanel   -- options panel, built at login
local pendingInvite                 -- normalized name of an unidentified group inviter
local OnChatLine                    -- set below; runs on every line added to chat
local listWindow, ShowListWindow     -- muted-list pop-up, built on first use
local scanStep = 0                  -- position in the Scan rotation
local SCAN_COOLDOWN = 5             -- seconds between Scan clicks
local lastScanTime = -SCAN_COOLDOWN
local scanRetryFrom, scanSentAt     -- step before the last send, and when it went out
local scanQueries                   -- /who scan rotation, rebuilt when a higher level is seen
local scanQueriesBound              -- level bound the cached rotation was built for
local mutationGen = 0               -- bumped on any change that can alter a filter decision

local CHAT_EVENTS = {
    "CHAT_MSG_SAY", "CHAT_MSG_YELL", "CHAT_MSG_EMOTE", "CHAT_MSG_TEXT_EMOTE",
    "CHAT_MSG_WHISPER", "CHAT_MSG_CHANNEL",
    "CHAT_MSG_GUILD", "CHAT_MSG_OFFICER",
    "CHAT_MSG_PARTY", "CHAT_MSG_PARTY_LEADER",
    "CHAT_MSG_RAID", "CHAT_MSG_RAID_LEADER", "CHAT_MSG_RAID_WARNING",
    "CHAT_MSG_INSTANCE_CHAT", "CHAT_MSG_INSTANCE_CHAT_LEADER",
    "CHAT_MSG_AFK", "CHAT_MSG_DND", "CHAT_MSG_COMMUNITIES_CHANNEL",
}

local function Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage(PREFIX .. msg)
end

-- Auto-decline notices: at most one line per player per minute, so someone
-- spamming duels or invites can't flood your chat through the addon.
local PrintThrottled
do
    local lastNotice = {}
    PrintThrottled = function(id, msg)
        local now = GetTime()
        if lastNotice[id] and now - lastNotice[id] < 60 then return end
        lastNotice[id] = now
        Print(msg)
    end
end

local IsSecret = issecretvalue or function() return false end

-- True if the guild name contains any keyword on the list.
local function IsOlympus(guild)
    if type(guild) ~= "string" or guild == "" or not db then return false end
    local g = guild:lower()
    if db.guildAllow[g] then return false end   -- on the guild whitelist (exact name)
    for _, kw in ipairs(db.keywords) do
        if g:find(kw, 1, true) then return true end
    end
    return false
end

-- "Name" or "Name-Realm" -> "name-realm" (the realm written the way chat links write it)
local realmCache   -- your realm, looked up once it's available
local function OwnRealm()
    if not realmCache then
        local r = GetNormalizedRealmName and GetNormalizedRealmName()
        if (not r or r == "") and GetRealmName then
            r = GetRealmName()
            if r then r = r:gsub("[%s%-]", "") end
        end
        if r and r ~= "" then realmCache = r end
    end
    return realmCache
end

local function Normalize(name)
    if type(name) ~= "string" or name == "" then return nil end
    local dash = name:find("-", 1, true)
    if not dash then
        local realm = OwnRealm()
        if realm then name = name .. "-" .. realm end
    elseif name:find("[%s%-]", dash + 1) then
        -- Typed "Name-Aerie Peak" or "Name-Azjol-Nerub": chat writes "AeriePeak", "AzjolNerub".
        name = name:sub(1, dash) .. name:sub(dash + 1):gsub("[%s%-]", "")
    end
    return name:lower()
end

-- Remove every chat line that links any of the given player names (one pass per window).
-- Every chat window, including whisper pop-out tabs (ChatFrame11 and up).
local function ChatFrames()
    local list = {}
    if type(CHAT_FRAMES) == "table" then
        for _, f in ipairs(CHAT_FRAMES) do
            if type(f) == "string" then f = _G[f] end
            if type(f) == "table" then list[#list + 1] = f end
        end
    end
    if #list == 0 then
        for i = 1, (NUM_CHAT_WINDOWS or 10) do
            local f = _G["ChatFrame" .. i]
            if f then list[#list + 1] = f end
        end
    end
    return list
end

-- Remove every chat line that links any of the given players (a set of list keys).
-- Matches by the full name, so capitalization doesn't matter and a same-named
-- player from another realm keeps their lines.
local INCOMING = {}
for _, e in ipairs(CHAT_EVENTS) do INCOMING[e] = true end

-- When the game tells us which event a line came from and who sent it, use
-- that: only incoming chat, matched on the sender (not on any name linked in
-- the line, which would also catch your own whispers to them). Otherwise fall
-- back to the player link in the text.
local function PurgeOneFrame(frame, keys)
    frame:RemoveMessagesByPredicate(function(msg, _, _, _, _, _, typeID, event, args)
        if type(msg) == "table" then msg = msg.message end
        -- Lines copied into a "Move to Whisper Window" tab carry no event, only
        -- their chat type: keep the whispers you sent.
        if event == nil and type(typeID) == "number" and not IsSecret(typeID) and ChatHistory_GetChatType then
            local ok, t = pcall(ChatHistory_GetChatType, typeID)
            if ok and (t == "WHISPER_INFORM" or t == "BN_WHISPER_INFORM") then return false end
        end
        if type(event) == "string" and not IsSecret(event) then
            if not INCOMING[event] then return false end
            if type(args) == "table" and not IsSecret(args) then
                local guid = args[12]
                if type(guid) == "string" and not IsSecret(guid) then
                    local k = db.guids[guid]
                    if k and keys[k] then return true end
                end
                local author = args[2]
                if type(author) == "string" and not IsSecret(author) and author ~= "" then
                    local k = Normalize(author)
                    return k ~= nil and keys[k] == true
                end
                return false
            end
        end
        if type(msg) ~= "string" or IsSecret(msg) then return false end
        -- Only links with a line ID (real chat). Bare links are /who results and
        -- system lines, which are kept so a /who you just ran doesn't vanish.
        for target in msg:gmatch("|Hplayer:([^:|]+):") do
            if keys[Normalize(target)] then return true end
        end
        return false
    end)
end

-- Removing old lines is queued instead of done on the spot: nameplates and
-- mouseover can identify many players in a moment in a busy city. Players
-- found within ~0.1 s are combined into one batch, and the batch sweeps one
-- chat window per frame so no single frame does all the work. New messages
-- are still filtered immediately; only the cleanup of older lines waits.
local PurgeHistory, RunBatched, CancelPurges
do
    local pending, queued = {}, false   -- names waiting for the next batch
    local batch, frames, idx            -- the batch being worked on
    local worker = CreateFrame("Frame")
    worker:Hide()

    -- Recheck each name right before its lines go: it may have been
    -- unmuted, allowed or given a party pass since it was queued.
    local function StillMuted(keys)
        local live = {}
        for key in pairs(keys) do
            if db.names[key] ~= nil and not db.allow[key]
                and not (db.partyPass and db.partyPass[key]) then
                live[key] = true
            end
        end
        return live
    end

    local function Finish()
        batch, frames, idx = nil, nil, nil
        worker:Hide()
    end

    local function Start()
        queued = false
        if batch or not next(pending) then return end   -- the running batch picks it up after
        batch, pending = pending, {}
        frames, idx = ChatFrames(), 0
        worker:Show()
    end

    worker:SetScript("OnUpdate", function()
        if not db.enabled then Finish() return end
        idx = idx + 1
        local frame = frames[idx]
        if not frame then
            Finish()
            if next(pending) then Start() end   -- names found while this batch ran
            return
        end
        local live = StillMuted(batch)
        if not next(live) then Finish(); if next(pending) then Start() end return end
        if frame.RemoveMessagesByPredicate then pcall(PurgeOneFrame, frame, live) end
    end)

    PurgeHistory = function(key)
        if not key or not db.enabled then return end
        pending[key] = true
        if queued then return end
        queued = true
        if C_Timer and C_Timer.After then C_Timer.After(0.1, Start) else Start() end
    end

    -- Kept for callers that group discoveries (a /who list, a group scan);
    -- the queue above already combines them.
    RunBatched = function(fn, ...) return pcall(fn, ...) end

    -- Filtering turned off: drop queued removals.
    CancelPurges = function()
        wipe(pending)
        Finish()
    end
end

local function CountMuted()
    local n = 0
    for _ in pairs(db.names) do n = n + 1 end
    return n
end

-- One place that hears about data changes: invalidates cached filter decisions,
-- and refreshes the list window / panel counts once on the next frame.
local refreshQueued = false
local function RefreshListViews()
    refreshQueued = false
    if listWindow and listWindow:IsShown() then pcall(listWindow.Refresh, listWindow) end
    if panel and panel:IsShown() and panel.UpdateStats then pcall(panel.UpdateStats, panel, CountMuted()) end
end

local function DataChanged(listChanged)
    mutationGen = mutationGen + 1
    if listChanged and not refreshQueued then
        refreshQueued = true
        if C_Timer and C_Timer.After then C_Timer.After(0, RefreshListViews) else RefreshListViews() end
    end
end

-- On WoW Forever, a two-part character name ("Bacon Eggz") comes back from
-- UnitFullName/UnitName as "Bacon" plus "Eggz" in the slot other clients use
-- for the realm. GetUnitName joins it the way chat shows it, so prefer that.
local function IsPlaceholderName(n)
    return n == "Unknown" or (type(UNKNOWNOBJECT) == "string" and n == UNKNOWNOBJECT)
end

local function UnitNameString(unit)
    local full
    if GetUnitName then
        local ok, v = pcall(GetUnitName, unit, true)
        if ok and not IsSecret(v) and type(v) == "string" and v ~= "" then full = v end
    end
    if not full then
        local n, realm
        if UnitFullName then n, realm = UnitFullName(unit) else n, realm = UnitName(unit) end
        if not n or IsSecret(n) then return nil end
        if realm and not IsSecret(realm) and realm ~= "" then full = n .. "-" .. realm else full = n end
    end
    -- Name data not loaded yet ("Unknown", or "Unknown-Realm"): not a real player.
    if IsPlaceholderName(full:match("^([^%-]+)") or full) then return nil end
    -- Chat links use the normalized realm, with no spaces or hyphens ("Name-AeriePeak").
    local n, realm = full:match("^([^%-]+)%-(.+)$")
    if n then full = n .. "-" .. (realm:gsub("[%s%-]", "")) end
    return full
end

-- Before 1.1.1 those names were saved as "bacon-eggz". Move an entry saved
-- under an old key to the correct one (keeping never-mute / added-by-hand).
local function Rekey(old, new)
    if not old or not new or old == new then return end
    local moved = false
    if db.names[old] ~= nil then
        if db.names[new] == nil then db.names[new] = db.names[old] end
        db.names[old] = nil; moved = true
    end
    if db.manual[old] then db.manual[new] = true; db.manual[old] = nil end
    if db.allow[old] then db.allow[new] = true; db.allow[old] = nil; moved = true end
    if moved then
        for g, k in pairs(db.guids) do if k == old then db.guids[g] = new end end
        DataChanged(true)
    end
end

-- Key for a typed or whispered name. If the player is only saved under the
-- old "first-last" key, move them to the correct key first.
-- Typed names: on this client "Tiny-Yackle" usually means first name + surname
-- ("Tiny Yackle"), not a realm. Treat the part after the dash as a realm only if
-- it's your realm or a realm already seen on a saved name.
local TypedName
do
    local realms
    TypedName = function(name)
        name = (strtrim(name or ""):gsub("%s+", " "))   -- "Bacon  Eggz" -> "Bacon Eggz"
        if name:find(" ", 1, true) then return name end
        -- Only on clients with surnames (WoW Forever); elsewhere a dash means a realm.
        if not (CHARACTERNAME_SURNAME_SEPARATOR or (C_NameUtil and C_NameUtil.ReplaceSurnameSeparatorWithLinkSeparator)) then
            return name
        end
        local f, l = name:match("^([^%-]+)%-([^%-]+)$")
        if not f then return name end
        local own = OwnRealm()
        if not own then return name end
        if not realms then
            realms = { [own:lower()] = true }
            for k in pairs(db.names) do
                local r = k:find(" ", 1, true) and k:match("%-([^%-]+)$")
                if r then realms[r] = true end
            end
        end
        if realms[l:lower():gsub("[%s%-]", "")] then return name end
        return f .. " " .. l
    end
end

local function ResolveKey(name)
    local key = Normalize(name)
    if not key or db.names[key] ~= nil or db.allow[key] then return key end
    local base = (name:match("^(.-)%-") or name)
    local first, last = base:match("^%s*(%S+)%s+(%S+)%s*$")
    if first then
        local old = (first .. "-" .. last):lower()
        if db.names[old] ~= nil or db.allow[old] then Rekey(old, key) end
        return key
    end
    -- "Bacon-Eggz" (first and last name joined by a dash) -> "bacon eggz-realm"
    local f, l = name:match("^%s*([^%s%-]+)%-([^%s%-]+)%s*$")
    if f then
        local alt = Normalize(f .. " " .. l)
        if alt and (db.names[alt] ~= nil or db.allow[alt]) then return alt end
    end
    return key
end

-- Human-speed declines: an instant decline every time is a pattern someone
-- could look for. Group invites and duels are hidden from you right away,
-- then declined after a random 2-8 seconds, like a person clicking Decline.
-- Short enough that other invites still reach you and resending can't lock
-- you out. Turn off with "Decline instantly" (/omute instant on).
local Humanlike = {}
do
    local jobs = {}   -- kind -> the decline waiting to run
    -- valid(): still decline? (option on, sender still muted, same request).
    -- restore(): give the request back if not.
    function Humanlike.Run(kind, fn, valid, restore)
        jobs[kind] = nil
        if db.instantDecline or not (C_Timer and C_Timer.After) then fn() return end
        local job = { fn = fn, valid = valid, restore = restore }
        jobs[kind] = job
        local wait = (math.random and math.random(2000, 8000) or 4000) / 1000
        C_Timer.After(wait, function()
            if jobs[kind] ~= job then return end   -- cancelled, or replaced
            jobs[kind] = nil
            if job.valid and not job.valid() then
                if job.restore then pcall(job.restore) end
                return
            end
            pcall(job.fn)
        end)
    end
    -- The request ended on its own (cancelled by them, timed out): nothing to decline.
    function Humanlike.Cancel(kind) jobs[kind] = nil end
    function Humanlike.Waiting(kind) return jobs[kind] ~= nil end
    -- A setting changed while waiting: give the request back if it shouldn't be
    -- declined anymore, or decline it now if "instantly" was just turned on.
    function Humanlike.Recheck()
        for kind, job in pairs(jobs) do
            if job.valid and not job.valid() then
                jobs[kind] = nil
                if job.restore then pcall(job.restore) end
            elseif db.instantDecline then
                jobs[kind] = nil
                pcall(job.fn)
            end
        end
    end
end

-- Blizzard's invite window declines the invite when it's hidden, unless it
-- was accepted. Mark it handled so hiding it doesn't decline on the spot:
-- the decline is sent by us after the pause.
local function HideGroupInvite()
    if StaticPopup_Hide then
        local frame
        if StaticPopup_Visible then
            local a, b = StaticPopup_Visible("PARTY_INVITE")
            frame = (type(b) == "table" and b) or (type(a) == "table" and a) or (type(a) == "string" and _G[a]) or nil
        end
        if frame then
            frame.inviteAccepted = true
            -- Keep Blizzard's own wording in case the invite is given back.
            if not Humanlike.inviteText then
                local t = frame.text or frame.Text
                local ok, txt = pcall(function() return t and t.GetText and t:GetText() end)
                if ok and type(txt) == "string" and not IsSecret(txt) and txt ~= "" then Humanlike.inviteText = txt end
            end
        end
        StaticPopup_Hide("PARTY_INVITE")
        if frame then frame.inviteAccepted = nil end
    end
    -- Role-check invites use a different window.
    if LFGInvitePopup and LFGInvitePopup:IsShown() and StaticPopupSpecial_Hide then
        pcall(StaticPopupSpecial_Hide, LFGInvitePopup)
    end
end

local pendingInviteAt = 0
local function DeclinePartyInvite(name, guild, listKey)
    pendingInvite = nil
    local key = ResolveKey(name)          -- who the open invite is from
    local mkey = listKey or key           -- their entry on the mute list
    HideGroupInvite()
    -- The game can open its window just after the event: hide it again.
    if C_Timer and C_Timer.After then C_Timer.After(0.2, function()
        if Humanlike.Waiting("group") then pcall(HideGroupInvite) end
    end) end
    Humanlike.Run("group", function()
        DeclineGroup()
        HideGroupInvite()
        PrintThrottled("group:" .. tostring(name), ("declined a group invite from %s <%s>."):format(tostring(name), tostring(guild)))
    end, function()   -- still the same invite, still muted, option still on
        return db.declineGroup and Humanlike.invite == key and key ~= nil and mkey ~= nil
            and db.names[mkey] ~= nil and not db.allow[mkey] and not db.partyPass[mkey]
    end, function()
        if Humanlike.invite ~= key then return end
        local a = Humanlike.inviteArgs or {}
        local isTank, isHealer, isDamage = a[2], a[3], a[4]
        if (isTank or isHealer or isDamage) and LFGInvitePopup and StaticPopupSpecial_Show and LFGInvitePopup_Update then
            StaticPopupSpecial_Show(LFGInvitePopup)   -- role-check invite: its own window, roles and all
            LFGInvitePopup_Update(name, isTank, isHealer, isDamage, a[6], a[8])
            return
        end
        local text = Humanlike.inviteText
        if not text then
            text = (type(INVITATION) == "string" and INVITATION:format(name)) or name
            if WillAcceptInviteRemoveQueues and WillAcceptInviteRemoveQueues() and type(ACCEPTING_INVITE_WILL_REMOVE_QUEUE) == "string" then
                text = text .. "\n\n" .. ACCEPTING_INVITE_WILL_REMOVE_QUEUE
            end
        end
        if StaticPopup_Show then StaticPopup_Show("PARTY_INVITE", text) end
    end)
end

-- Highest level seen on an Olympus member; the Scan rotation stops there.
local function NoteLevel(level)
    level = tonumber(level)
    if not level or level < 1 or level > 200 then return end
    if level > (db.maxSeenLevel or 0) then
        db.maxSeenLevel = level
        scanQueries = nil
    end
end

local function Block(guid, name, guild)
    local key = ResolveKey(name)
    if not key or db.allow[key] then return end   -- on the never-mute list
    if key == playerKey or (guid and guid == playerGUID) then return end   -- never yourself
    local isNew, listChanged = false, false
    local current = db.names[key]
    if current == nil then
        db.names[key] = guild; isNew = true; listChanged = true
    elseif guild ~= nil and current ~= guild and not db.manual[key] then
        db.names[key] = guild; listChanged = true     -- moved to another muted guild: keep it current
    end
    if guid and db.guids[guid] ~= key then db.guids[guid] = key; isNew = true end
    if pendingInvite == key and Humanlike.invite == key and db.declineGroup and GetTime() - pendingInviteAt < 60 then
        DeclinePartyInvite(name, guild)   -- identified while their invite was still open
    end
    if isNew or listChanged then DataChanged(listChanged) end
    if isNew then
        if db.debug then Print(("debug: muted %s <%s>"):format(tostring(name), tostring(guild))) end
        PurgeHistory(key)
    end
end

local function Unblock(guid, name, force)
    local key = ResolveKey(name)
    if key and db.manual[key] and not force then return end   -- added by hand; keep
    local changed, listChanged = false, false
    if guid and db.guids[guid] ~= nil then db.guids[guid] = nil; changed = true end
    if key and db.names[key] ~= nil then
        db.names[key] = nil; listChanged = true
        -- GUID entries only ever point at muted names, so this sweep is only
        -- needed when the player was actually on the list.
        for g, k in pairs(db.guids) do
            if k == key then db.guids[g] = nil end
        end
    end
    if key then db.manual[key] = nil end
    if changed or listChanged then DataChanged(listChanged) end
end

-- Unmute a whole set of keys at once (one sweep of the ID table, not one per player).
local function UnblockMany(keys)
    local n = 0
    for k in pairs(keys) do
        if db.names[k] ~= nil then db.names[k] = nil; n = n + 1 end
        db.manual[k] = nil
    end
    if n > 0 then
        for g, k in pairs(db.guids) do if keys[k] then db.guids[g] = nil end end
        DataChanged(true)
    end
    return n
end

-- Keys saved with a realm written with spaces or hyphens ("kael-aerie peak")
-- are moved to the form chat uses ("kael-aeriepeak"). Runs once.
local function FixRealmKeys()
    if (db.revision or 0) >= 2 then return end
    local map = {}
    local function consider(k)
        local n, r = k:match("^([^%-]+)%-(.+)$")
        if r and r:find("[%s%-]") then map[k] = n .. "-" .. (r:gsub("[%s%-]", "")) end
    end
    for k in pairs(db.names) do consider(k) end
    for k in pairs(db.allow) do consider(k) end
    for old, new in pairs(map) do
        if db.names[old] ~= nil then
            if db.names[new] == nil then db.names[new] = db.names[old] end
            db.names[old] = nil
        end
        if db.manual[old] then db.manual[new] = true; db.manual[old] = nil end
        if db.allow[old] then db.allow[new] = true; db.allow[old] = nil end
    end
    if next(map) then
        for g, k in pairs(db.guids) do if map[k] then db.guids[g] = map[k] end end
        DataChanged(true)
    end
    db.revision = 2
end

-- 1.1.1 could save players under "unknown-<realm>" while their name was still loading.
local function PurgePlaceholderKeys()
    local placeholder = { unknown = true }
    if type(UNKNOWNOBJECT) == "string" then placeholder[UNKNOWNOBJECT:lower()] = true end
    local function isPlaceholder(k) return placeholder[k:match("^([^%-]+)") or k] end
    local drop = {}
    for k in pairs(db.names) do if isPlaceholder(k) then drop[k] = true end end
    for k in pairs(db.allow) do if isPlaceholder(k) then db.allow[k] = nil end end
    if next(drop) then UnblockMany(drop) end   -- also clears added-by-hand flags and ID links
    db.nameKeysFixed = true   -- unused now; stops a downgrade to 1.1.1 from running its old repair
end

local function UnblockFormer(name, newGuild)
    local key = ResolveKey(name)   -- also finds entries saved under the old "first-last" key
    if not key or not db.names[key] or db.manual[key] then return end
    Unblock(nil, name)
    if db.debug then Print(("debug: unmuted %s, now %s"):format(name,
        (newGuild and newGuild ~= "") and ("<" .. newGuild .. ">") or "unguilded")) end
end

---------------------------------------------------------------------------
-- Learning guilds
---------------------------------------------------------------------------
local keyCheckedThisSession = {}   -- ID -> true once its saved key was compared with the game's name

local function ScanUnit(unit)
    if not UnitExists(unit) or not UnitIsPlayer(unit) or UnitIsUnit(unit, "player") then return end
    local guid = UnitGUID(unit)
    if IsSecret(guid) then return end
    local guild = GetGuildInfo(unit)
    if IsSecret(guild) then return end
    -- Already muted, key already checked this session, still in the same guild:
    -- nothing new to learn (nameplates and mouseover fire constantly in cities).
    local known = guid and db.guids[guid]
    if known and keyCheckedThisSession[guid] and guild and db.names[known] == guild
        and pendingInvite ~= known then
        NoteLevel(UnitLevel(unit))
        return
    end
    local name = UnitNameString(unit)
    if not name then return end                       -- includes "Unknown" (name not loaded yet)
    if known then
        Rekey(known, Normalize(name))                 -- saved under an old-style or renamed key
        keyCheckedThisSession[guid] = true
    end

    if IsOlympus(guild) then
        NoteLevel(UnitLevel(unit))
        Block(guid, name, guild)
        if guid and db.guids[guid] then keyCheckedThisSession[guid] = true end   -- skip the name check next time
    elseif guild then
        Unblock(guid, name)      -- they're now in a different guild
    end
    -- A blank guild isn't proof they left: guild info can still be loading.
end

local function SafeScan(unit) pcall(ScanUnit, unit) end

-- Normalized list key for a unit, or nil
local function UnitKey(unit)
    local guid = UnitGUID(unit)
    local key = guid and not IsSecret(guid) and db.guids[guid]
    if key then return key end
    return Normalize(UnitNameString(unit))
end

local function ScanGroupNow()
    if IsInRaid() then
        for i = 1, GetNumGroupMembers() do SafeScan("raid" .. i) end
    else
        for i = 1, 4 do SafeScan("party" .. i) end
    end
end

local function ScanGroup() RunBatched(ScanGroupNow) end

-- Warn once per player per group when someone on the mute list is in it.
-- (Answers given in the window are also saved in db.groupWarned, so a /reload
-- mid-group doesn't ask again.)
local warnedInGroup = {}
-- Which players the open group / invite windows are about, and invites you sent.
local popupState = { group = nil, invite = nil, sent = {} }

local function Now() return time and time() or GetTime() end

-- Keys of everyone currently in your group (not you).
local function GroupKeys()
    local present = {}
    if not IsInGroup() then return present end
    local prefix, count = "party", 4
    if IsInRaid() then prefix, count = "raid", GetNumGroupMembers() end
    for i = 1, count do
        local unit = prefix .. i
        if UnitExists(unit) and UnitIsPlayer(unit) and not UnitIsUnit(unit, "player") then
            local key = UnitKey(unit)
            if key then present[key] = unit end
        end
    end
    return present
end

local UpdatePasses
do
    local gen = 0
    UpdatePasses = function()
        if not next(db.partyPass) then return end
        local present, grouped = GroupKeys(), IsInGroup()
        local left, never, changed, soonest = {}, {}, false, nil
        for key, p in pairs(db.partyPass) do
            local age = Now() - (tonumber(p.t) or 0)
            if present[key] then
                p.joined = true
            elseif p.joined or age > 120 or (not grouped and age > 5) then
                db.partyPass[key] = nil
                changed = true
                -- Only announce players who really are muted again.
                if db.names[key] ~= nil and not db.allow[key] then
                    local nm = type(p.name) == "string" and p.name or (key:match("^[^%-]+") or key)
                    if p.joined then left[#left + 1] = nm else never[#never + 1] = nm end
                end
            else
                -- Still waiting for them to join: look again right after the limit.
                local due = (grouped and 121 or 6) - age
                if not soonest or due < soonest then soonest = due end
            end
        end
        if changed then DataChanged(true) end
        if #left > 0 then Print("muted again (left the group): " .. table.concat(left, ", ") .. ".") end
        if #never > 0 then Print("muted again (didn't join): " .. table.concat(never, ", ") .. ".") end
        -- One timer at a time; it also survives nothing else changing in the group.
        if soonest and C_Timer and C_Timer.After then
            gen = gen + 1
            local mine = gen
            C_Timer.After(math.max(1, soonest), function() if gen == mine then pcall(UpdatePasses) end end)
        end
    end
end

-- "Unmute while grouped": the pass ends when they leave your group (or you
-- leave), or if they never join (invite declined or expired). Checked on
-- every roster change, and also on timers so a pass can't outlive its limits
-- when nothing in the group changes.
local function GrantPass(key, joined, name)
    -- Only for players who are muted right now (not never-muted, not unmuted since).
    if not key or db.allow[key] or db.names[key] == nil then return false end
    db.partyPass[key] = { joined = joined and true or false, t = Now(),
        name = type(name) == "string" and name or nil }
    DataChanged(true)
    pcall(UpdatePasses)   -- schedules the checks that end it on time
    return true
end

local function CheckGroupForMuted()
    if not db.groupWarn then return end
    if not IsInGroup() then wipe(warnedInGroup); wipe(db.groupWarned) return end
    local present = GroupKeys()
    -- The player you invited has joined: the group window takes over from the invite window.
    if popupState.invite and present[popupState.invite] and StaticPopup_Hide then
        popupState.invite = nil
        StaticPopup_Hide("OLYMPUSMUTE_INVITE")
    end
    local found, seen = {}, {}
    for key, unit in pairs(present) do
        if db.names[key] and not db.allow[key] and not db.partyPass[key]
            and not warnedInGroup[key] and not db.groupWarned[key] then
            warnedInGroup[key] = true
            seen[key] = true
            found[#found + 1] = { key = key, name = UnitNameString(unit) or key, guild = tostring(db.names[key]) }
        end
    end
    if #found == 0 then return end
    -- A window is already open: add the new players to it instead of replacing it.
    if popupState.group and StaticPopup_Visible and StaticPopup_Visible("OLYMPUSMUTE_GROUP") then
        for _, m in ipairs(popupState.group) do
            if not seen[m.key] and present[m.key] and db.names[m.key] and not db.allow[m.key] and not db.partyPass[m.key] then
                seen[m.key] = true
                found[#found + 1] = m
            end
        end
    end
    table.sort(found, function(a, b) return a.name < b.name end)
    local lines = {}
    for i, m in ipairs(found) do lines[i] = ("%s <%s>"):format(m.name, m.guild) end
    popupState.group = found
    local popup = StaticPopup_Show and StaticPopup_Show("OLYMPUSMUTE_GROUP", table.concat(lines, "\n"), nil, found)
    if not popup then
        popupState.group = nil
        Print("|cffff5555muted in your group:|r " .. table.concat(lines, ", ") .. ". Their chat is hidden.")
    end
end

local CheckGroupSoon
do
    local queued = false
    CheckGroupSoon = function()
        pcall(CheckGroupForMuted)
        -- guild info for new members can arrive a moment late; look again (once)
        if not queued and C_Timer and C_Timer.After then
            queued = true
            C_Timer.After(2, function() queued = false; ScanGroup(); pcall(CheckGroupForMuted) end)
        end
    end
end

-- Roster updates arrive in bursts (several per join or leave): handle the
-- burst once, ~0.1 s after it starts.
local RosterChanged
do
    local queued = false
    local function Run()
        queued = false
        ScanGroup()
        pcall(UpdatePasses)
        CheckGroupSoon()
    end
    RosterChanged = function()
        if queued then return end
        if C_Timer and C_Timer.After then queued = true; C_Timer.After(0.1, Run) else Run() end
    end
end

local function ScanWho()
    if not (C_FriendList and C_FriendList.GetNumWhoResults and C_FriendList.GetWhoInfo) then return end
    for i = 1, C_FriendList.GetNumWhoResults() do
        local info = C_FriendList.GetWhoInfo(i)
        if info and IsOlympus(info.fullGuildName) then
            NoteLevel(info.level)
            Block(nil, info.fullName, info.fullGuildName)
        elseif info and info.fullName then
            UnblockFormer(info.fullName, info.fullGuildName)   -- left the guild
        end
    end
end

-- Shift-clicking a name in chat runs /who on that player. When the result is
-- small, the game prints it as a system line instead of opening the Who window:
--   [Name]: Level 20 Human Warrior <Guild Name> - Zone
-- Read the player link and <guild> straight from that line (works in any language).
-- On this client the result line is written straight to the chat window
-- (no CHAT_MSG_SYSTEM event, which is why it has no timestamp), so we also
-- watch what gets added to the chat frames. A /who line starts with a bare
-- player link followed by "|h: "; normal chat links carry ":lineID:CHANNEL"
-- and never match, so players can't get muted by typing text that looks similar.
-- Takes a line with any leading color code already removed. Returns true if it
-- had the exact /who result shape (so the caller can de-duplicate it).
local function ParseWhoBody(body)
    local name, rest = body:match("^|Hplayer:([^:|]+)|h%[[^%]]*%]|h: (.*)$")
    if not name then return false end
    local guild = rest:match("<([^<>]+)>")
    if IsOlympus(guild) then
        NoteLevel(rest:match("(%d+)"))
        Block(nil, name, guild)
    else
        UnblockFormer(name, guild)   -- /who shows a different guild, or none
    end
    return true
end

-- Entry point for raw text (CHAT_MSG_SYSTEM): validate and strip, then parse.
local function ParseWhoLine(msg)
    if type(msg) ~= "string" or IsSecret(msg) then return false end
    return ParseWhoBody((msg:gsub("^|c%x%x%x%x%x%x%x%x", "")))
end

local hookedFrames = {}
local function HookChatFrames()
    for _, frame in ipairs(ChatFrames()) do
        if not hookedFrames[frame] and frame.AddMessage then
            hookedFrames[frame] = true
            hooksecurefunc(frame, "AddMessage", function(self, msg) OnChatLine(msg, self) end)
        end
    end
end

-- Show errors instead of failing silently, so problems can be reported.
local function ReportError(err)
    Print("|cffff4444error:|r " .. tostring(err))
end

-- Auto-decline guild invites from Olympus guilds, and mute the inviter.
local lastGuildDecline = 0
local lastGuildEvent = 0   -- when the game's own guild-invite event last fired

local function GuildInviteVisible()
    if GuildInviteFrame and GuildInviteFrame:IsShown() then return true end
    return StaticPopup_Visible and StaticPopup_Visible("GUILD_INVITE") and true or false
end

local function DeclineGuildInvite()
    -- Press the invite window's own Decline button when it exists, so the game
    -- does exactly what a manual click does; fall back to the API call.
    local btn = _G.GuildInviteFrameDeclineButton
    if btn and btn:IsVisible() then
        btn:Click()
    elseif DeclineGuild then
        DeclineGuild()
    elseif C_GuildInfo and C_GuildInfo.DeclineGuild then
        C_GuildInfo.DeclineGuild()
    end
    if StaticPopup_Hide then StaticPopup_Hide("GUILD_INVITE") end
    if GuildInviteFrame and GuildInviteFrame:IsShown() then GuildInviteFrame:Hide() end
end

local function HandleGuildInvite(inviter, guildName)
    if db.debug then Print(("debug: guild invite from %s <%s>"):format(tostring(inviter), tostring(guildName))) end
    if not db.declineGuild or IsSecret(guildName) or not IsOlympus(guildName) then return end
    DeclineGuildInvite()
    -- The invite window can open a moment after the event; check again shortly.
    if C_Timer and C_Timer.After then
        C_Timer.After(0.2, function()
            if GuildInviteVisible() then xpcall(DeclineGuildInvite, ReportError) end
        end)
    end
    if type(inviter) == "string" and not IsSecret(inviter) then
        Block(nil, inviter, guildName)
    end
    PrintThrottled("guild:" .. tostring(guildName), ("declined a guild invite from <%s>."):format(guildName))
    lastGuildDecline = GetTime()
end

-- Backup trigger: the "[Name] invites you to join Guild." line printed to chat.
-- Only acted on while an invite window is actually open, and only for bare
-- player links (player chat lines carry ":lineID:CHANNEL" and never match).
local function ParseInviteBody(body)
    local now = GetTime()
    -- The game's event already handled this invite (declined or whitelisted).
    if now - lastGuildDecline < 2 or now - lastGuildEvent < 3 or not GuildInviteVisible() then return end
    local name, rest = body:match("^|Hplayer:([^:|]+)|h%[[^%]]*%]|h (.*)$")
    if not name or not IsOlympus(rest) then return end
    local guild = rest:gsub("|r$", ""):match("join (.-)%.?$")
    if not guild then return end   -- couldn't read the guild name (other languages): don't guess
    HandleGuildInvite(name, guild)
end

-- The server sometimes answers one /who with the same player listed several
-- times. Collapse repeated identical result lines into one.
local lastWhoLine = setmetatable({}, { __mode = "k" })   -- chat frame -> {text, time}

-- Only called for lines already confirmed to have the /who result shape.
local function DedupeWhoLine(msg, frame)
    if not frame or not frame.RemoveMessagesByPredicate then return end
    local last, now = lastWhoLine[frame], GetTime()
    if last and last.text == msg and now - last.time < 3 then
        -- Remove only the line just added (the newest copy), never an older one.
        local count = 0
        frame:RemoveMessagesByPredicate(function(m)
            if type(m) == "table" then m = m.message end
            if m == msg then count = count + 1 end
            return false
        end)
        if count >= 2 then
            local n = 0
            frame:RemoveMessagesByPredicate(function(m)
                if type(m) == "table" then m = m.message end
                if m ~= msg then return false end
                n = n + 1
                return n == count
            end)
        end
    end
    lastWhoLine[frame] = { text = msg, time = now }
end

-- "You must wait a moment longer before using /who again": undo the step.
local function CheckWhoThrottle(msg)
    if not scanSentAt or GetTime() - scanSentAt > 2 then return end
    if type(msg) ~= "string" or IsSecret(msg) then return end
    -- Not our own lines ("scan 3/9: /who g-\"waiting\"..."), and not players' chat.
    if msg:sub(1, #PREFIX) == PREFIX or msg:find("|Hplayer:", 1, true) then return end
    local m = msg:lower()
    if m:find("/who", 1, true) and (m:find("wait", 1, true) or m:find("again", 1, true)) then
        scanStep, scanSentAt = scanRetryFrom, nil
        lastScanTime = GetTime()
        Print("the server wanted a longer pause; that search will run again on your next click.")
        if panel and panel.UpdateScanButton then panel:UpdateScanButton() end
    end
end

-- Runs for every line added to a chat window, so it rejects ordinary lines fast.
OnChatLine = function(msg, frame)
    if type(msg) ~= "string" or IsSecret(msg) then return end
    -- The server's "/who too soon" notice is a plain system line: only look for it
    -- in the 2 seconds after one of our scans.
    if scanSentAt and GetTime() - scanSentAt <= 2 then pcall(CheckWhoThrottle, msg) end
    -- Everything else we care about starts with a player link, maybe after a color
    -- code and/or a timestamp ("07:15 ", "[7:15 PM] "). Guild, party and channel
    -- lines start with a channel link instead, so they're rejected here for free.
    local body = msg
    local at = body:find("|H", 1, true)
    if not at or body:find("|Hplayer:", at, true) ~= at then return end
    if at > 1 then
        local pre = body:sub(1, at - 1):gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
        if #pre > 16 or not pre:find("^[%d:%.%s%[%]APMapm]*$") then return end
        body = body:sub(at)
    end
    -- /who and invite lines use a bare link (|Hplayer:Name|h). Links on normal chat
    -- lines carry ":lineID:CHANNEL", so those are rejected here without further work.
    if not body:find("^|Hplayer:[^:|]+|h") then return end
    local ok, isWho = pcall(ParseWhoBody, body)
    if ok and isWho then
        pcall(DedupeWhoLine, msg, frame)
    elseif db and db.declineGuild then
        xpcall(function() ParseInviteBody(body) end, ReportError)
    end
end

-- Group invites don't say which guild the inviter is in, so decline right away
-- if they're already on the mute list. Otherwise remember them: if they get
-- identified while the invite is still open (mouseover, target, shift-click),
-- the invite is declined at that point.
local function HandlePartyInvite(inviter, ...)
    if not db.declineGroup or type(inviter) ~= "string" or IsSecret(inviter) then return end
    local guid = select(6, ...)
    local key = ResolveKey(inviter)
    local guild = key and db.names[key]
    local listKey = guild and key
    if not guild and guid and not IsSecret(guid) and db.guids[guid] then
        listKey = db.guids[guid]
        guild = db.names[listKey]
    end
    if guild and not db.partyPass[listKey] then
        DeclinePartyInvite(inviter, guild, listKey)
    elseif guild then
        return   -- unmuted while grouped: let the invite through
    else
        pendingInvite, pendingInviteAt = key, GetTime()
    end
end

-- Shift-clicking a name can fire the same /who several times in a row
-- (you get the result repeated, or a "You must wait" message). Let identical
-- /who searches through once, and drop repeats sent within 3 seconds.
local WHO_REPEAT_WINDOW = 3
local lastWhoFilter, lastWhoTime = nil, 0

local function WhoAllowed(filter)
    local now = GetTime()
    if filter == lastWhoFilter and now - lastWhoTime < WHO_REPEAT_WINDOW then
        if db and db.debug then Print("debug: skipped repeat /who " .. tostring(filter)) end
        return false
    end
    lastWhoFilter, lastWhoTime = filter, now
    if db and db.debug then Print("debug: /who " .. tostring(filter)) end
    return true
end

local function InstallWhoDebounce()
    if C_FriendList and C_FriendList.SendWho then
        local orig = C_FriendList.SendWho
        C_FriendList.SendWho = function(filter, ...)
            if WhoAllowed(filter) then return orig(filter, ...) end
        end
    end
    if type(SendWho) == "function" then
        local orig = SendWho
        SendWho = function(filter, ...)
            if WhoAllowed(filter) then return orig(filter, ...) end
        end
    end
end

---------------------------------------------------------------------------
-- Chat bubbles
-- The game draws bubbles separately from the chat window. After a muted
-- player's say/yell/party/raid message, look for a bubble with that exact text
-- and make it invisible. Bubbles inside dungeons and raid instances are locked
-- away from addons, so this only works in the open world.
---------------------------------------------------------------------------
local BUBBLE_EVENTS = {
    CHAT_MSG_SAY = true, CHAT_MSG_YELL = true,
    CHAT_MSG_PARTY = true, CHAT_MSG_PARTY_LEADER = true,
    CHAT_MSG_RAID = true, CHAT_MSG_RAID_LEADER = true,
}
local mutedTexts = {}      -- text -> time it stops being hidden
local allowedTexts = {}    -- text an unmuted player just said -> time; never hidden
local hiddenHolders = {}   -- bubble frames we've made invisible
local watchUntil, lastBubbleClean = 0, 0
local bubbleWatcher = CreateFrame("Frame")
bubbleWatcher:Hide()

local function BubbleHolder(bubble)
    local holder = bubble.GetChildren and bubble:GetChildren()
    if holder and holder.String then return holder end
    if bubble.String then return bubble end
end

-- Tidy expired texts, at most once a second.
local function PruneBubbleTexts(now)
    if now - lastBubbleClean < 1 then return end
    lastBubbleClean = now
    for text, t in pairs(mutedTexts) do
        if t < now then mutedTexts[text] = nil end
    end
    for text, t in pairs(allowedTexts) do
        if t < now then allowedTexts[text] = nil end
    end
end

local function ScanBubbles()
    if not (C_ChatBubbles and C_ChatBubbles.GetAllChatBubbles) then return end
    local now = GetTime()
    PruneBubbleTexts(now)
    for _, bubble in pairs(C_ChatBubbles.GetAllChatBubbles(false)) do
        local holder = BubbleHolder(bubble)
        if holder then
            local text = holder.String:GetText()
            local secret = not text or IsSecret(text)
            local untilT = not secret and mutedTexts[text]
            local okT = not secret and allowedTexts[text]
            -- Same text from a muted and an unmuted player: leave it visible.
            if untilT and untilT >= now and not (okT and okT >= now) then
                if not hiddenHolders[holder] then holder:SetAlpha(0); hiddenHolders[holder] = true end
            elseif hiddenHolders[holder] then
                holder:SetAlpha(1); hiddenHolders[holder] = nil   -- bubble reused for someone else
            end
        end
    end
end

local elapsedSince = 0
bubbleWatcher:SetScript("OnUpdate", function(self, elapsed)
    elapsedSince = elapsedSince + elapsed
    if elapsedSince < 0.1 then return end   -- 10 checks a second at most
    elapsedSince = 0
    pcall(ScanBubbles)
    if GetTime() > watchUntil then self:Hide() end
end)

-- Called for every bubble-type message: bubbles get reused, so we also need
-- to watch after unmuted messages to restore any bubble we hid earlier.
local function WatchBubbles(text, muted)
    if not db.hideBubbles then return end
    local now = GetTime()
    PruneBubbleTexts(now)   -- keeps the tables small even when nobody muted speaks
    local usable = type(text) == "string" and not IsSecret(text)
    if usable and muted then
        mutedTexts[text] = now + 5
        -- An unmuted player said this first: keep their bubble safe for as long.
        local okT = allowedTexts[text]
        if okT and okT >= now and okT < now + 5 then allowedTexts[text] = now + 5 end
    elseif usable then
        allowedTexts[text] = now + 10
        if mutedTexts[text] then muted = true end   -- scan now to put a matching bubble back
    end
    if muted or next(hiddenHolders) then
        watchUntil = GetTime() + 1.5
        bubbleWatcher:Show()
    end
end

local sessionHidden = 0

-- Muted-messages log: the last 50 hidden messages from the last 15 minutes.
-- Kept in memory only: never saved to disk, and cleared by /reload or logout.
local LOG_MAX, LOG_AGE = 50, 15 * 60
local mutedLog, logHead = {}, 0
local function LogMuted(event, msg, author, lineID, guid)
    if type(msg) ~= "string" or type(author) ~= "string" then return end
    logHead = logHead % LOG_MAX + 1
    local e = {}   -- a new table each time, so an open window keeps its message
    mutedLog[logHead] = e
    e.t, e.clock, e.event, e.text, e.author = GetTime(), date and date("%H:%M") or "", event, msg, author
    e.lineID = (type(lineID) == "number" and lineID > 0) and lineID or nil
    e.guid = guid
end
local lastHiddenLine, lastHiddenEvent

-- Pieces of one filter decision. The sender's name is normalized at most once.
local function GuidBlocked(guid)
    if guid and guid ~= playerGUID then
        local k = db.guids[guid]
        return k ~= nil and db.names[k] ~= nil and not db.allow[k]
    end
    return false
end

local function NameBlocked(key)
    return key ~= nil and key ~= playerKey and db.names[key] ~= nil and not db.allow[key]
end

-- Muted guild for a name, or nil (used for duels, trades, invites and warnings)
local function MutedGuildForName(name)
    local key = ResolveKey(name)
    if not key or db.allow[key] or db.partyPass[key] then return nil end
    return db.names[key]
end

-- Word filter: hides a message from anyone if it contains a listed phrase.

-- A filter entry matches when the message contains ALL of its words, in any
-- order and anywhere ("inv layer" catches "inv to asmon layer pls" and
-- "invite to asmon layer pls"). Parts also match inside longer words.
-- Put an entry in quotes to require that exact phrase instead.
local wordParts = {}   -- entry -> list of pieces that must all appear
local function WordParts(entry)
    local p = wordParts[entry]
    if not p then
        local exact = entry:match('^"(.+)"$')
        if exact then
            p = { exact }
        else
            p = {}
            for part in entry:gmatch("%S+") do p[#p + 1] = part end
        end
        wordParts[entry] = p
    end
    return p
end

-- Messages from Blizzard staff are never word-filtered.
local STAFF_FLAGS = { GM = true, DEV = true }

local function WordBlocked(msg, key, guid, flag)
    if #db.words == 0 or type(msg) ~= "string" or IsSecret(msg) then return false end
    if flag and STAFF_FLAGS[flag] then return false end
    if guid and guid == playerGUID then return false end          -- never your own
    if key and (key == playerKey or db.allow[key]) then return false end  -- you, or never-mute list
    -- Match what the reader sees: drop color codes and hidden link data, keep
    -- the [link text]. Otherwise "item" would hide every message with an item link.
    local m = msg
    if m:find("|", 1, true) then
        m = m:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|H.-|h(.-)|h", "%1")
    end
    m = m:lower()
    for _, entry in ipairs(db.words) do
        local parts = WordParts(entry)
        local all = #parts > 0
        for i = 1, #parts do
            if not m:find(parts[i], 1, true) then all = false break end
        end
        if all then return true end
    end
    return false
end

-- Name keywords: hide chat from any player whose character name contains one.
local function NameWordBlocked(author, key, guid, flag)
    local list = db.nameWords
    if #list == 0 or type(author) ~= "string" or IsSecret(author) then return false end
    if flag and STAFF_FLAGS[flag] then return false end
    if guid and guid == playerGUID then return false end
    if key and (key == playerKey or db.allow[key]) then return false end
    local n = author:match("^[^%-]+")
    if not n then return false end
    n = n:lower()
    for i = 1, #list do
        if n:find(list[i], 1, true) then return true end
    end
    return false
end

-- Full decision. Returns hit, reliable (false if any step errored, so the
-- result isn't cached and the next delivery tries again).
local function Evaluate(msg, author, guid, flag)
    local okK, key = pcall(Normalize, author)
    if not okK then key = nil end
    if next(db.partyPass) then   -- unmuted while grouped
        local gk = guid and db.guids[guid]
        if (key and db.partyPass[key]) or (gk and db.partyPass[gk]) then return false, okK end
    end
    local ok1, hit1 = pcall(GuidBlocked, guid)
    if ok1 and hit1 then return true, true end
    local ok2, hit2 = pcall(NameBlocked, key)
    if ok2 and hit2 then return true, true end
    local okN, hitN = pcall(NameWordBlocked, author, key, guid, flag)
    if okN and hitN then return true, true end
    local ok3, hit3 = pcall(WordBlocked, msg, key, guid, flag)
    if ok3 and hit3 then return true, true end
    return false, (ok1 and okK and ok2 and okN and ok3)
end

-- The game runs this filter once per chat window that shows a message. Remember
-- the last decision so the second, third... window reuses it. The decision is a
-- pure function of these inputs plus mutationGen, so matching inputs = same answer.
local cache = { valid = false }

-- Chat event arguments: arg6 = flag ("GM", "DEV", "AFK"...), arg11 = lineID, arg12 = guid
local function Filter(_, event, msg, author, _, _, _, flag, _, _, _, _, lineID, guid)
    if not db or not db.enabled then return false end
    if IsSecret(author) or IsSecret(guid) then return false end
    if IsSecret(flag) or type(flag) ~= "string" then flag = nil end

    local hit
    local msgUsable = not IsSecret(msg)
    if msgUsable and cache.valid and cache.gen == mutationGen and cache.event == event
        and cache.msg == msg and cache.author == author and cache.guid == guid
        and cache.flag == flag then
        hit = cache.hit
    else
        local reliable
        hit, reliable = Evaluate(msg, author, guid, flag)
        if reliable and msgUsable then
            cache.valid, cache.gen, cache.event, cache.flag = true, mutationGen, event, flag
            cache.msg, cache.author, cache.guid, cache.hit = msg, author, guid, hit
        else
            cache.valid = false
        end
    end

    if hit then
        -- Count each hidden line once, not once per chat window.
        local usable = lineID ~= nil and not IsSecret(lineID)
        if not usable or lineID ~= lastHiddenLine or event ~= lastHiddenEvent then
            if usable then lastHiddenLine, lastHiddenEvent = lineID, event
            else lastHiddenLine, lastHiddenEvent = nil, nil end
            sessionHidden = sessionHidden + 1
            db.hiddenTotal = (db.hiddenTotal or 0) + 1
            if msgUsable then pcall(LogMuted, event, msg, author, usable and lineID or nil, guid) end
            if panel and panel:IsShown() and panel.UpdateStats then panel:UpdateStats() end
        end
        return true
    end
    return false
end

---------------------------------------------------------------------------
-- Duels, trades, tooltips
---------------------------------------------------------------------------
local function HandleDuel(challenger, which)
    if not db.declineDuel or type(challenger) ~= "string" or IsSecret(challenger) then return end
    local guild = MutedGuildForName(challenger)
    if not guild then return end
    local function HideDuel()
        if not StaticPopup_Hide then return end
        StaticPopup_Hide("DUEL_REQUESTED")
        StaticPopup_Hide("DUEL_TO_THE_DEATH_REQUESTED")
        StaticPopup_Hide("DUEL_TO_THE_DEATH_REQUESTED_CONFIRM")
    end
    HideDuel()
    if C_Timer and C_Timer.After then C_Timer.After(0.2, function()
        if Humanlike.Waiting("duel") then pcall(HideDuel) end
    end) end
    Humanlike.Run("duel", function()
        CancelDuel()
        HideDuel()
        PrintThrottled("duel:" .. challenger, ("declined a duel from %s <%s>."):format(challenger, tostring(guild)))
    end, function()
        return db.declineDuel and MutedGuildForName(challenger) ~= nil
    end, function()   -- give the duel request back (death duels use the name twice)
        if not StaticPopup_Show then return end
        local ok = pcall(StaticPopup_Show, which or "DUEL_REQUESTED", challenger, challenger)
        if not ok then CancelDuel() end   -- couldn't show it: don't leave it hidden and unanswered
    end)
end

-- Trades: muted players can still sell you enchants or mats, so instead of
-- declining on the spot, ask. "Allow trade" lets this trade (and any more
-- with them in the next 10 minutes) go ahead; "Decline" cancels it.
local HandleTrade
do
    local allowedUntil, askedAt = {}, {}   -- key -> time

    local function CloseTradePrompt()
        if StaticPopup_Hide then StaticPopup_Hide("OLYMPUSMUTE_TRADE") end
    end

    StaticPopupDialogs["OLYMPUSMUTE_TRADE"] = {
        text = "Trade with %s <%s>?\n\nThey're on your OlympusMute list.",
        button1 = "Allow trade", button2 = "Decline",
        OnAccept = function(self, data)
            if not data then return end
            allowedUntil[data.key] = GetTime() + 600
            Print(("trading with %s allowed for the next 10 minutes. They stay muted."):format(data.name))
        end,
        OnCancel = function(self, data, reason)
            if not self then return end                 -- the window couldn't open (handled below)
            if reason == "override" then return end   -- closed because the trade ended
            if not data then return end
            CancelTrade()
            if StaticPopup_Hide then StaticPopup_Hide("TRADE") end
            Print(("cancelled the trade with %s <%s>."):format(data.name, tostring(data.guild)))
        end,
        timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
    }

    HandleTrade = function(name)
        if not db.declineTrade or IsSecret(name) then return end
        if type(name) ~= "string" then
            name = UnitNameString("NPC")
            if not name then return end
        end
        local guild = MutedGuildForName(name)
        if not guild then return end
        local key = ResolveKey(name)
        if not key or (allowedUntil[key] or 0) > GetTime() then return end
        -- The request and the trade window both fire: ask once per trade.
        if GetTime() - (askedAt[key] or 0) < 3 and StaticPopup_Visible and StaticPopup_Visible("OLYMPUSMUTE_TRADE") then return end
        askedAt[key] = GetTime()
        local popup = StaticPopup_Show and StaticPopup_Show("OLYMPUSMUTE_TRADE", name, tostring(guild),
            { key = key, name = name, guild = guild })
        if not popup then   -- no window available: decline, as before
            CancelTrade()
            if StaticPopup_Hide then StaticPopup_Hide("TRADE") end
            PrintThrottled("trade:" .. name, ("cancelled the trade with %s <%s>."):format(name, tostring(guild)))
        end
    end

    -- The trade ended on its own (they cancelled, walked away): close the question.
    Humanlike.TradeEnded = CloseTradePrompt
end

local function OnTooltipUnit(tooltip)
    if not db or not tooltip or not tooltip.GetUnit then return end
    local _, unit = tooltip:GetUnit()
    if not unit or IsSecret(unit) or not UnitIsPlayer(unit) then return end
    SafeScan(unit)   -- learn them now so the very first tooltip is right
    local key = UnitKey(unit)
    if not key then return end
    if db.allow[key] then
        tooltip:AddLine("OlympusMute: never muted", 0.4, 1, 0.4)
    elseif db.names[key] then
        if db.partyPass[key] then
            tooltip:AddLine("OlympusMute: unmuted while grouped", 1, 0.82, 0)
        else
            tooltip:AddLine("Muted by OlympusMute <" .. tostring(db.names[key]) .. ">", 1, 0.3, 0.3)
        end
    end
end

---------------------------------------------------------------------------
-- Whisper warning: when you start a whisper to someone on your mute list, the
-- chat box header turns red and one line explains their replies will be hidden.
-- (Addons can't safely put a confirm step in front of Blizzard's Send, so the
-- warning comes while typing, before Enter.) If that hook isn't available, the
-- same note appears right after the whisper is sent.
---------------------------------------------------------------------------
local warnedWhisper = {}

local function WarnWhisper(target, guid)
    local guild = MutedGuildForName(target)
    local key = ResolveKey(target)
    if not guild and guid and not IsSecret(guid) then
        -- Fall back to the character ID the game sends with the whisper.
        local k = db.guids[guid]
        if k and db.names[k] and not db.allow[k] and not db.partyPass[k] then guild, key = db.names[k], k end
    end
    if not guild then return false end
    if key and not warnedWhisper[key] then
        warnedWhisper[key] = true
        Print(("%s is |cffff5555muted|r <%s>. You won't see their replies."):format(target, tostring(guild)))
    end
    return true
end

local function CheckWhisperBox(editBox)
    if not db or not db.whisperWarn or not editBox then return end
    local chatType = (editBox.GetAttribute and editBox:GetAttribute("chatType")) or editBox.chatType
    if chatType ~= "WHISPER" then return end
    local target = (editBox.GetAttribute and editBox:GetAttribute("tellTarget")) or editBox.tellTarget
    if type(target) ~= "string" or target == "" or IsSecret(target) then return end
    if WarnWhisper(target) then
        local header = editBox.header or (editBox.GetName and editBox:GetName() and _G[editBox:GetName() .. "Header"])
        if header and header.SetTextColor then header:SetTextColor(1, 0.25, 0.25) end
    end
end

-- Invites: WoW sends the invite right away, so this warns just after, before they join.
local warnedInvite = {}
local function WarnInvite(target)
    if not db or not db.whisperWarn then return end
    if type(target) ~= "string" or target == "" or IsSecret(target) then return end
    local guild = MutedGuildForName(target)
    if not guild then return end
    local key = ResolveKey(target)
    popupState.invite = key
    local popup = StaticPopup_Show and StaticPopup_Show("OLYMPUSMUTE_INVITE", target, tostring(guild),
        { key = key, name = target })
    if not popup then popupState.invite = nil end
    if not popup then   -- no popup available: one chat line per player instead
        local key = Normalize(target)
        if not key or warnedInvite[key] then return end
        warnedInvite[key] = true
        Print(("invited %s, who's |cffff5555muted|r <%s>. You won't see their party chat."):format(target, tostring(guild)))
    end
end

local hookedBoxes = {}
local function HookEditBoxes()
    for _, frame in ipairs(ChatFrames()) do
        local eb = frame.editBox or (frame.GetName and frame:GetName() and _G[frame:GetName() .. "EditBox"])
        if eb and not hookedBoxes[eb] and type(eb.UpdateHeader) == "function" then
            hookedBoxes[eb] = true
            hooksecurefunc(eb, "UpdateHeader", function(box) pcall(CheckWhisperBox, box) end)
        end
    end
end

local function InstallWhisperWarning()
    local invHook = function(name)
        if type(name) == "string" and not IsSecret(name) then popupState.sent[name:lower()] = GetTime() end
        pcall(WarnInvite, name)
    end
    if C_PartyInfo and type(C_PartyInfo.InviteUnit) == "function" then
        hooksecurefunc(C_PartyInfo, "InviteUnit", invHook)
    end
    if type(InviteUnit) == "function" then
        hooksecurefunc("InviteUnit", invHook)
    end
    local hook = function(box) pcall(CheckWhisperBox, box) end
    if type(ChatEdit_UpdateHeader) == "function" then
        hooksecurefunc("ChatEdit_UpdateHeader", hook)
    end
    HookEditBoxes()
end

local function InstallTooltip()
    local hook = function(tt) pcall(OnTooltipUnit, tt) end
    if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall
        and Enum and Enum.TooltipDataType and Enum.TooltipDataType.Unit then
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, hook)
    elseif GameTooltip and GameTooltip:HasScript("OnTooltipSetUnit") then
        GameTooltip:HookScript("OnTooltipSetUnit", hook)
    end
end

-- Newer clients moved this function into ChatFrameUtil; use whichever exists.
local AddFilter = (ChatFrameUtil and ChatFrameUtil.AddMessageEventFilter) or ChatFrame_AddMessageEventFilter
local filterAvailable = type(AddFilter) == "function"
if filterAvailable then
    for _, event in ipairs(CHAT_EVENTS) do AddFilter(event, Filter) end
end

---------------------------------------------------------------------------
-- Events
---------------------------------------------------------------------------
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event, arg1, ...)
    if event == "ADDON_LOADED" then
        if arg1 ~= "OlympusMute" then return end
        -- A damaged settings file is repaired instead of breaking the addon.
        if type(OlympusMuteDB) ~= "table" then OlympusMuteDB = {} end
        db = OlympusMuteDB
        -- 1.0.5 split the single invite setting into guild and group
        local old = db.declineInvites
        if type(old) ~= "boolean" then old = true end
        if type(db.declineGuild) ~= "boolean" then db.declineGuild = old end
        if type(db.declineGroup) ~= "boolean" then db.declineGroup = old end
        db.declineInvites = nil
        for _, k in ipairs({ "guids", "names", "manual", "allow", "guildAllow", "words", "nameWords", "partyPass", "groupWarned" }) do
            if type(db[k]) ~= "table" then db[k] = {} end
        end
        if type(db.keywords) ~= "table" then
            db.keywords = {}
            for _, kw in ipairs(DEFAULT_KEYWORDS) do db.keywords[#db.keywords + 1] = kw end
        end
        if type(db.hiddenTotal) ~= "number" then db.hiddenTotal = 0 end
        for k, v in pairs({ enabled = true, declineDuel = true, declineTrade = true,
                            groupWarn = true, whisperWarn = true, hideBubbles = true, acceptShares = true }) do
            if type(db[k]) ~= "boolean" then db[k] = v end
        end
        -- Entries: drop anything that isn't the right kind of value.
        for k, v in pairs(db.names) do
            if type(k) ~= "string" then db.names[k] = nil
            elseif type(v) ~= "string" then db.names[k] = "added manually" end
        end
        for g, k in pairs(db.guids) do
            if type(g) ~= "string" or type(k) ~= "string" or db.names[k] == nil then db.guids[g] = nil end
        end
        for k in pairs(db.manual) do
            if type(k) ~= "string" or db.names[k] == nil then db.manual[k] = nil end
        end
        for _, t in ipairs({ db.allow, db.guildAllow }) do
            for k in pairs(t) do if type(k) ~= "string" then t[k] = nil end end
        end
        local words, seenWord = {}, {}
        for _, w in pairs(db.words) do
            if type(w) == "string" then
                w = strtrim(w):lower():gsub("%s+", " ")
                if w ~= "" and not seenWord[w] then seenWord[w] = true; words[#words + 1] = w end
            end
        end
        db.words = words
        local kws = {}
        for _, k in pairs(db.keywords) do if type(k) == "string" then kws[#kws + 1] = k end end
        db.keywords = kws
        for k, v in pairs(db.partyPass) do
            if type(k) ~= "string" or type(v) ~= "table" then db.partyPass[k] = nil
            elseif v.name ~= nil and type(v.name) ~= "string" then v.name = nil end
        end
        for k, v in pairs(db.groupWarned) do
            if type(k) ~= "string" or v ~= true then db.groupWarned[k] = nil end
        end
        local nws, seenNW = {}, {}
        for _, k in pairs(db.nameWords) do
            if type(k) == "string" then
                k = strtrim((k:lower():gsub('[%*%%"]', "")))   -- "tiny " from 1.3.1 -> "tiny"
                if k ~= "" and not seenNW[k] then seenNW[k] = true; nws[#nws + 1] = k end
            end
        end
        db.nameWords = nws
        local ga = {}
        for k, v in pairs(db.guildAllow) do
            if type(k) == "string" and v then
                k = strtrim((k:lower():gsub('"', "")))
                if k ~= "" then ga[k] = true end
            end
        end
        db.guildAllow = ga
        local lvl = db.maxSeenLevel
        if type(lvl) ~= "number" or lvl ~= lvl or lvl < 1 or lvl > 200 then db.maxSeenLevel = nil end
        DataChanged(false)
        self:UnregisterEvent("ADDON_LOADED")
    elseif event == "PLAYER_LOGIN" then
        -- Saved passes: check them once group info has loaded.
        if C_Timer and C_Timer.After then C_Timer.After(5, function()
            pcall(UpdatePasses)
            -- The group may have broken up while you were offline.
            if not IsInGroup() then wipe(db.groupWarned) end
        end) end
        playerGUID = UnitGUID("player")
        playerKey = Normalize(UnitNameString("player"))
        pcall(PurgePlaceholderKeys)
        pcall(FixRealmKeys)
        pcall(function()   -- names saved with doubled spaces ("bacon  eggz") never matched chat
            local map = {}
            for _, t in ipairs({ db.names, db.allow, db.manual, db.partyPass }) do
                for k in pairs(t) do
                    if type(k) == "string" and k:find("%s%s") then map[k] = (k:gsub("%s+", " ")) end
                end
            end
            for old, new in pairs(map) do
                Rekey(old, new)
                if db.manual[old] then db.manual[new] = true; db.manual[old] = nil end
                if db.partyPass[old] then db.partyPass[new] = db.partyPass[new] or db.partyPass[old]; db.partyPass[old] = nil end
            end
            if next(map) then DataChanged(true) end
        end)
        pcall(function()   -- a /who result could add you to your own list
            local drop = {}
            if playerKey and db.names[playerKey] ~= nil then drop[playerKey] = true end
            if playerGUID and db.guids[playerGUID] then
                local k = db.guids[playerGUID]
                db.guids[playerGUID] = nil
                if db.names[k] ~= nil then drop[k] = true end
            end
            if next(drop) then UnblockMany(drop) end
        end)
        if not filterAvailable then
            Print("|cffff5555chat filtering isn't available on this game version.|r Other features still work.")
        end
        DataChanged(false)
        self:RegisterEvent("PLAYER_TARGET_CHANGED")
        self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
        self:RegisterEvent("NAME_PLATE_UNIT_ADDED")
        self:RegisterEvent("GROUP_ROSTER_UPDATE")
        self:RegisterEvent("WHO_LIST_UPDATE")
        self:RegisterEvent("CHAT_MSG_SYSTEM")
        self:RegisterEvent("GUILD_INVITE_REQUEST")
        self:RegisterEvent("PARTY_INVITE_REQUEST")
        self:RegisterEvent("PARTY_INVITE_CANCEL")
        self:RegisterEvent("DUEL_REQUESTED")
        pcall(self.RegisterEvent, self, "DUEL_TO_THE_DEATH_REQUESTED")   -- hardcore rules only
        self:RegisterEvent("DUEL_FINISHED")
        self:RegisterEvent("TRADE_SHOW")
        pcall(self.RegisterEvent, self, "TRADE_REQUEST")   -- not on every client
        self:RegisterEvent("TRADE_CLOSED")
        pcall(self.RegisterEvent, self, "TRADE_REQUEST_CANCEL")
        -- Bubbles: watched here, not in the chat filter, so they're hidden even
        -- when no chat tab shows that kind of chat.
        for e in pairs(BUBBLE_EVENTS) do self:RegisterEvent(e) end
        ScanGroup()
        HookChatFrames()
        InstallWhoDebounce()
        pcall(InstallTooltip)
        pcall(InstallWhisperWarning)
        -- You answered an invite yourself: forget it, so nothing declines it later.
        local answered = function()
            pendingInvite = nil
            Humanlike.invite = nil
            Humanlike.Cancel("group")
        end
        if type(DeclineGroup) == "function" then hooksecurefunc("DeclineGroup", answered) end
        if type(AcceptGroup) == "function" then hooksecurefunc("AcceptGroup", answered) end
        if type(FCF_OpenTemporaryWindow) == "function" then
            -- Whisper pop-out tabs are created later: hook them as they open.
            hooksecurefunc("FCF_OpenTemporaryWindow", function(chatType, chatTarget, sourceChatFrame)
                pcall(HookChatFrames); pcall(HookEditBoxes)
                -- A tab the game opened for a new whisper (not one you made): if the
                -- whisper was hidden, the tab is empty. Close it right after.
                if chatType ~= "WHISPER" or sourceChatFrame ~= nil or type(chatTarget) ~= "string"
                    or IsSecret(chatTarget) or not db.enabled or not (C_Timer and C_Timer.After) then return end
                C_Timer.After(0, function()
                    for _, fr in ipairs(ChatFrames()) do
                        if fr.isTemporary and fr.chatType == "WHISPER" and fr.chatTarget == chatTarget
                            and fr.GetNumMessages and fr:GetNumMessages() == 0 and FCF_Close then
                            pcall(FCF_Close, fr)
                        end
                    end
                end)
            end)
        end
        self:RegisterEvent("CHAT_MSG_WHISPER_INFORM")
        CreatePanel()
    elseif BUBBLE_EVENTS[event] then
        if not db.enabled or not db.hideBubbles then return end
        local author = ...
        local flag, guid = select(5, ...), select(11, ...)
        if IsSecret(author) or IsSecret(guid) then return end
        if IsSecret(flag) or type(flag) ~= "string" then flag = nil end
        local ok, hit = pcall(Evaluate, arg1, author, guid, flag)
        pcall(WatchBubbles, arg1, ok and hit)
    elseif event == "PLAYER_TARGET_CHANGED" then
        SafeScan("target")
    elseif event == "UPDATE_MOUSEOVER_UNIT" then
        SafeScan("mouseover")
    elseif event == "NAME_PLATE_UNIT_ADDED" then
        SafeScan(arg1)
    elseif event == "GROUP_ROSTER_UPDATE" then
        pendingInvite = nil
        if IsInGroup() then Humanlike.invite = nil; Humanlike.Cancel("group") end
        RosterChanged()
    elseif event == "PARTY_INVITE_REQUEST" then
        Humanlike.Cancel("group")   -- a new invite: any older wait is stale
        Humanlike.invite = type(arg1) == "string" and not IsSecret(arg1) and ResolveKey(arg1) or nil
        Humanlike.inviteText, Humanlike.inviteArgs = nil, { arg1, ... }
        local n = select("#", ...)
        local args = { arg1, ... }
        xpcall(function() HandlePartyInvite(unpack(args, 1, n + 1)) end, ReportError)
    elseif event == "DUEL_REQUESTED" or event == "DUEL_TO_THE_DEATH_REQUESTED" then
        xpcall(function() HandleDuel(arg1, event) end, ReportError)
    elseif event == "TRADE_REQUEST" then
        xpcall(function() HandleTrade(arg1) end, ReportError)
    elseif event == "TRADE_SHOW" then
        xpcall(function() HandleTrade(nil) end, ReportError)
    elseif event == "TRADE_CLOSED" or event == "TRADE_REQUEST_CANCEL" then
        pcall(Humanlike.TradeEnded)
    elseif event == "PARTY_INVITE_CANCEL" then
        pendingInvite = nil
        Humanlike.Cancel("group")
        Humanlike.invite = nil
    elseif event == "DUEL_FINISHED" then
        Humanlike.Cancel("duel")
    elseif event == "WHO_LIST_UPDATE" then
        RunBatched(ScanWho)
    elseif event == "CHAT_MSG_SYSTEM" then
        pcall(ParseWhoLine, arg1)
    elseif event == "CHAT_MSG_WHISPER_INFORM" then
        local target = ...   -- arg2: who you whispered
        local guid = select(11, ...)   -- arg12
        if db.whisperWarn and type(target) == "string" and not IsSecret(target) then
            pcall(WarnWhisper, target, guid)
        end
    elseif event == "GUILD_INVITE_REQUEST" then
        local inviter, guildName = arg1, ...
        lastGuildEvent = GetTime()
        xpcall(function() HandleGuildInvite(inviter, guildName) end, ReportError)
    end
end)

---------------------------------------------------------------------------
-- Shared actions (used by both /omute and the options panel)
---------------------------------------------------------------------------
local function SetEnabled(on)
    db.enabled = on and true or false
    DataChanged(false)
    if not db.enabled then   -- put back any bubbles we hid
        for holder in pairs(hiddenHolders) do pcall(holder.SetAlpha, holder, 1) end
        wipe(hiddenHolders); wipe(mutedTexts); wipe(allowedTexts)
        bubbleWatcher:Hide()
        CancelPurges()
    end
    Print("filtering " .. (db.enabled and "|cff00ff00ON|r" or "|cffff0000OFF|r"))
    if panel and panel:IsShown() then panel:Refresh() end
end

local function OnOff(v) return v and "|cff00ff00ON|r" or "|cffff0000OFF|r" end

local function SetDeclineGuild(on)
    db.declineGuild = on and true or false
    Print("auto-decline invites from muted guilds " .. OnOff(db.declineGuild))
    if panel and panel:IsShown() then panel:Refresh() end
end

local function SetDeclineGroup(on)
    db.declineGroup = on and true or false
    if not db.declineGroup then pendingInvite = nil end
    Humanlike.Recheck()
    Print("auto-decline group invites from muted players " .. OnOff(db.declineGroup))
    if panel and panel:IsShown() then panel:Refresh() end
end

local MANUAL_TAG = "added manually"

local function AddPlayer(name)
    if not name or name == "" then return end
    name = TypedName(name)
    local key = ResolveKey(name)
    if not key then return end
    if key == playerKey then Print("you can't mute yourself.") return end
    -- Muting by hand ends "unmute while grouped" for them.
    local passEnded = db.partyPass[key] ~= nil
    if passEnded then db.partyPass[key] = nil; DataChanged(true) end
    if db.names[key] then
        if passEnded then
            db.manual[key] = true
            PurgeHistory(key)
            Print(name .. " is muted again (ended unmute while grouped).")
        elseif db.manual[key] then
            Print(name .. " is already muted.")
        else
            -- Found automatically before; pin them so a guild change doesn't unmute them.
            db.manual[key] = true
            DataChanged(true)
            Print(name .. " will now stay muted even if they change guilds.")
        end
    else
        if db.allow[key] then db.allow[key] = nil; DataChanged(true); key = ResolveKey(name) end
        db.manual[key] = true
        Block(nil, name, MANUAL_TAG)
        Print("muted " .. name .. ".")
    end
    if panel and panel:IsShown() then panel:Refresh() end
end

local function SetInstantDecline(on)
    db.instantDecline = on and true or false
    Humanlike.Recheck()
    Print("decline group invites and duels instantly " .. OnOff(db.instantDecline)
        .. (db.instantDecline and "" or " (they're declined after a few seconds, like a person would)"))
    if panel and panel:IsShown() then panel:Refresh() end
end

local function SetDeclineDuel(on)
    db.declineDuel = on and true or false
    Humanlike.Recheck()
    Print("auto-decline duels from muted players " .. OnOff(db.declineDuel))
    if panel and panel:IsShown() then panel:Refresh() end
end

local function SetDeclineTrade(on)
    db.declineTrade = on and true or false
    Print("ask before trading with muted players " .. OnOff(db.declineTrade))
    if panel and panel:IsShown() then panel:Refresh() end
end

local function SetWhisperWarn(on)
    db.whisperWarn = on and true or false
    Print("warning when you whisper or invite a muted player " .. OnOff(db.whisperWarn))
    if panel and panel:IsShown() then panel:Refresh() end
end

local function SetGroupWarn(on)
    db.groupWarn = on and true or false
    Print("warning when a muted player is in your group " .. OnOff(db.groupWarn))
    if db.groupWarn then pcall(CheckGroupForMuted) end
    if panel and panel:IsShown() then panel:Refresh() end
end

local function SetHideBubbles(on)
    db.hideBubbles = on and true or false
    if not db.hideBubbles then
        for holder in pairs(hiddenHolders) do pcall(holder.SetAlpha, holder, 1) end
        wipe(hiddenHolders); wipe(mutedTexts); wipe(allowedTexts)
        bubbleWatcher:Hide()
    end
    Print("hiding chat bubbles from muted players " .. OnOff(db.hideBubbles))
    if panel and panel:IsShown() then panel:Refresh() end
end

-- One-way "never mute" for buttons (group window, muted messages log):
-- clicking twice never takes the protection away again.
local function NeverMuteKey(key, display)
    if not key then return end
    db.allow[key] = true
    db.names[key], db.manual[key], db.partyPass[key] = nil, nil, nil
    for g, k in pairs(db.guids) do if k == key then db.guids[g] = nil end end
    DataChanged(true)
    Print(tostring(display or key) .. " will never be muted.")
    if panel and panel:IsShown() then panel:Refresh() end
end

-- Never-mute list: toggles the player on or off it.
local function AllowPlayer(name)
    if not name or name == "" then return end
    name = TypedName(name)
    local key = ResolveKey(name)
    if not key then return end
    if db.allow[key] then
        db.allow[key] = nil
        Print(name .. " can be muted again.")
    else
        db.allow[key] = true
        db.partyPass[key] = nil
        Unblock(nil, name, true)
        Print(name .. " will never be muted.")
    end
    DataChanged(true)
    if panel and panel:IsShown() then panel:Refresh() end
end

local function FormatNum(n)
    return BreakUpLargeNumbers and BreakUpLargeNumbers(n) or tostring(n)
end

local function RemovePlayer(name)
    if not name or name == "" then return end
    name = TypedName(name)
    local key = ResolveKey(name)
    if key and db.names[key] then
        Unblock(nil, name, true)
        Print("unmuted " .. name .. ".")
    else
        Print(name .. " isn't on the mute list.")
    end
    if panel and panel:IsShown() then panel:Refresh() end
end

local function ClearAll()
    wipe(db.guids); wipe(db.names); wipe(db.manual)
    DataChanged(true)
    Print("cleared all muted players.")
    if panel and panel:IsShown() then panel:Refresh() end
end

-- Guild names match any part of a guild's name, so * wildcards aren't needed.
local function CleanKeyword(text)
    return strtrim(((text or ""):lower():gsub('[%*%%"]', "")))   -- remove * % " first, then trim
end

-- The existing entry that already matches everything kw would, if any.
local function CoveredBy(kw, list)
    for _, k in ipairs(list) do
        if k ~= kw and kw:find(k, 1, true) then return k end
    end
end

-- Strip wildcards, merge duplicates, and drop entries another entry already covers
-- (e.g. "olympusa" when "olympus" is on the list). Returns what was removed.
local function TidyKeywords()
    local seen, cleaned = {}, {}
    local changed = false
    for _, k in pairs(db.keywords) do
        local c = type(k) == "string" and CleanKeyword(k) or ""
        if c ~= k then changed = true end
        if #c >= MIN_KEYWORD_LEN and not seen[c] then
            seen[c] = true
            cleaned[#cleaned + 1] = c
        else
            changed = true
        end
    end
    local kept, dropped = {}, {}
    for _, k in ipairs(cleaned) do
        if CoveredBy(k, cleaned) then dropped[#dropped + 1] = k else kept[#kept + 1] = k end
    end
    if changed or #dropped > 0 then
        db.keywords = kept
        scanQueries = nil
        return true, dropped
    end
    return false, dropped
end

-- Lists are shown alphabetically; the saved order doesn't matter.
local function SortedList(t)
    if #t == 0 then return "(none)" end
    local c = {}
    for i, v in ipairs(t) do c[i] = v end
    table.sort(c)
    return table.concat(c, ", ")
end

local function KeywordList()
    return SortedList(db.keywords)
end

local function AddKeyword(text)
    local raw = strtrim(text or "")
    local kw = CleanKeyword(raw)
    if #kw < MIN_KEYWORD_LEN then
        Print(("guild names need at least %d letters."):format(MIN_KEYWORD_LEN))
        return
    end
    if raw:find("*", 1, true) then
        Print("no * needed: guild names already match any part of the name.")
    end
    for _, k in ipairs(db.keywords) do
        if k == kw then Print('"' .. kw .. '" is already on the list.') return end
    end
    local cover = CoveredBy(kw, db.keywords)
    if cover then
        Print(('"%s" is already covered by "%s", since guild names match any part of the name.'):format(kw, cover))
        return
    end
    -- A shorter name makes longer ones that contain it redundant (e.g. "olymp" covers "olympus").
    local dropped = {}
    for i = #db.keywords, 1, -1 do
        if db.keywords[i]:find(kw, 1, true) then
            table.insert(dropped, 1, table.remove(db.keywords, i))
        end
    end
    db.keywords[#db.keywords + 1] = kw
    scanQueries = nil
    Print(('now muting guilds containing "%s". Guild list: %s'):format(kw, KeywordList()))
    if #dropped > 0 then
        Print(("removed %s from the list (now covered by \"%s\")."):format(table.concat(dropped, ", "), kw))
    end
    if panel and panel:IsShown() then panel:Refresh() end
end

local function RemoveKeyword(text)
    local kw = CleanKeyword(text)
    for i, k in ipairs(db.keywords) do
        if k == kw then
            table.remove(db.keywords, i)
            scanQueries = nil
            -- Unmute players who were only muted because of this guild name
            -- (players you added by hand stay).
            local drop = {}
            for name, guild in pairs(db.names) do
                if not db.manual[name] and not IsOlympus(guild) then drop[name] = true end
            end
            local n = UnblockMany(drop)
            Print(('removed "%s" (%d players unmuted). Guild list: %s'):format(kw, n, KeywordList()))
            if panel and panel:IsShown() then panel:Refresh() end
            return
        end
    end
    Print('"' .. kw .. '" isn\'t on the guild list. Current list: ' .. KeywordList())
end

do
    local tidy = CreateFrame("Frame")
    tidy:RegisterEvent("PLAYER_LOGIN")
    tidy:SetScript("OnEvent", function(self)
        self:UnregisterEvent("PLAYER_LOGIN")
        if not db then return end
        local changed, dropped = TidyKeywords()
        if changed then
            if #dropped > 0 then
                Print(("tidied your guild list: removed %s, already covered by a shorter name (guild names match any part of the name)."):format(table.concat(dropped, ", ")))
            end
            Print("guild list: " .. KeywordList())
        end
    end)
end

local function WordList()
    return SortedList(db.words)
end

local function Quoted(w)
    return w:sub(1, 1) == '"' and w or ('"' .. w .. '"')
end

-- One cleanup for adding and removing: lowercase, single spaces, and no
-- spaces just inside quotes (" asmon layer " -> "asmon layer").
local function CleanWordEntry(text)
    local w = strtrim(text or ""):lower():gsub("%s+", " ")
    local inner = w:match('^"(.*)"$')
    if inner then w = '"' .. strtrim(inner) .. '"' end
    return w
end

local function AddWord(text)
    local w = CleanWordEntry(text)
    local exact = w:match('^"(.+)"$')
    if #(exact or w) < 3 then Print("filter entries need at least 3 characters.") return end
    if not exact then
        for part in w:gmatch("%S+") do
            if #part < 2 then
                Print(('"%s" is too short to filter on; single letters would hide almost everything.'):format(part))
                return
            end
        end
    end
    for _, x in ipairs(db.words) do
        if x == w then Print(Quoted(w) .. " is already filtered.") return end
    end
    db.words[#db.words + 1] = w
    DataChanged(false)
    if exact then
        Print(('hiding messages containing the exact phrase "%s".'):format(exact))
    elseif w:find(" ", 1, true) then
        Print(('hiding messages that contain all of: %s (any order).'):format(w:gsub(" ", ", ")))
    else
        Print(('hiding messages containing "%s".'):format(w))
    end
    Print("filtered words: " .. WordList())
    if panel and panel:IsShown() then panel:Refresh() end
end

local function RemoveWord(text)
    local w = CleanWordEntry(text)
    -- Exact match first; otherwise accept the quoted/unquoted twin.
    local inner = w:match('^"(.*)"$')
    local twin = inner or ('"' .. w .. '"')
    for _, target in ipairs({ w, twin }) do
        for i, x in ipairs(db.words) do
            if x == target then
                table.remove(db.words, i)
                wordParts[x] = nil
                DataChanged(false)
                local what = x:sub(1, 1) == '"' and ("the exact phrase " .. x)
                    or x:find(" ", 1, true) and (x .. " (any order)") or Quoted(x)
                Print(("stopped filtering %s. Filtered words: %s"):format(what, WordList()))
                if panel and panel:IsShown() then panel:Refresh() end
                return
            end
        end
    end
    Print(Quoted(w) .. " isn't filtered. Filtered words: " .. WordList())
end

local function ExemptList()
    local t = {}
    for g in pairs(db.guildAllow) do t[#t + 1] = g end
    table.sort(t)
    return #t > 0 and table.concat(t, ", ") or "(none)"
end

-- Guild whitelist: exact guild names that are never muted, even if they contain a muted name
-- (e.g. a guild called "Anti Olympus"). Toggles on/off.
local function ExemptGuild(text)
    local g = strtrim(((text or ""):lower():gsub('"', "")))
    if g == "" then return end
    if db.guildAllow[g] then
        db.guildAllow[g] = nil
        Print(('"%s" removed from the guild whitelist.'):format(g))
    else
        db.guildAllow[g] = true
        local drop = {}
        for name, guild in pairs(db.names) do
            if not db.manual[name] and type(guild) == "string" and guild:lower() == g then drop[name] = true end
        end
        local n = UnblockMany(drop)
        Print(('"%s" added to the guild whitelist and will never be muted (%d players unmuted).'):format(g, n))
    end
    if panel and panel:IsShown() then panel:Refresh() end
end

-- Comma-separated entry: "olympus, holypmus" adds both. Commas inside quotes
-- stay part of the entry, so a quoted word filter phrase can still contain one.
local function SplitEntries(text)
    text = text or ""
    if not text:find(",", 1, true) then return { text } end
    local out, cur, inQuote = {}, {}, false
    for i = 1, #text do
        local c = text:sub(i, i)
        if c == '"' then inQuote = not inQuote end
        if c == "," and not inQuote then
            out[#out + 1] = table.concat(cur); cur = {}
        else
            cur[#cur + 1] = c
        end
    end
    out[#out + 1] = table.concat(cur)
    local list = {}
    for _, e in ipairs(out) do
        e = strtrim(e)
        if e ~= "" then list[#list + 1] = e end
    end
    return list
end

-- Remove/toggle commands first try the whole text, so entries saved with a comma
-- before 1.1.0 ("Alpha, Beta") can still be removed by typing them as shown.
local function EachEntry(fn, existsWhole)
    return function(text)
        if existsWhole and text and text:find(",", 1, true) and existsWhole(text) then
            return fn(strtrim(text))
        end
        for _, e in ipairs(SplitEntries(text)) do fn(e) end
    end
end

do
local function HasWord(t)
    local w = CleanWordEntry(t)
    for _, x in ipairs(db.words) do
        if x == w or x == '"' .. w .. '"' then return true end
    end
end
local function HasKeyword(t)
    local kw = CleanKeyword(t)
    for _, k in ipairs(db.keywords) do if k == kw then return true end end
end
local function HasExempt(t) return db.guildAllow[strtrim((t:lower():gsub('"', "")))] end
local function HasMuted(t) local k = Normalize((strtrim(t):gsub("%s+", " "))); return k and db.names[k] ~= nil end
local function HasAllowed(t) local k = Normalize((strtrim(t):gsub("%s+", " "))); return k and db.allow[k] end

AddKeyword, RemoveKeyword, ExemptGuild = EachEntry(AddKeyword), EachEntry(RemoveKeyword, HasKeyword), EachEntry(ExemptGuild, HasExempt)
AddWord, RemoveWord = EachEntry(AddWord), EachEntry(RemoveWord, HasWord)
AddPlayer, AllowPlayer, RemovePlayer = EachEntry(AddPlayer), EachEntry(AllowPlayer, HasAllowed), EachEntry(RemovePlayer, HasMuted)
end

---------------------------------------------------------------------------
-- Muted players and groups: unmute while grouped, or for good.
---------------------------------------------------------------------------
do
local function PassAll(list, joined)
    local names = {}
    for _, m in ipairs(list) do
        if GrantPass(m.key, joined, m.name) then names[#names + 1] = m.name end
    end
    if #names == 0 then return end
    Print(("unmuted while you're grouped: %s. They're muted again when the group ends."):format(table.concat(names, ", ")))
end

-- A real answer in the group window: don't ask about these players again in
-- this group, even after a /reload.
local function Answered(list)
    for _, m in ipairs(list) do if m.key then db.groupWarned[m.key] = true end end
end

local function AllowAll(list)
    for _, m in ipairs(list) do NeverMuteKey(m.key, m.name) end
end

-- The game sends an invite the moment you click, so this window can only come
-- right after. "Cancel invite" withdraws it before they can accept.
local function CancelInvite(name)
    if C_PartyInfo and C_PartyInfo.UninviteUnit then pcall(C_PartyInfo.UninviteUnit, name)
    elseif UninviteUnit then pcall(UninviteUnit, name) end
    -- While the invite is pending, the game holds you in a group of one, and
    -- leaving it cancels the invite for certain. But leaving also withdraws any
    -- other invites you just sent, so only do it when this was the only one.
    local others = false
    for n, t in pairs(popupState.sent) do
        if GetTime() - t > 120 then popupState.sent[n] = nil
        elseif n ~= tostring(name):lower() then others = true end
    end
    local members = GetNumGroupMembers and GetNumGroupMembers() or 0
    if members <= 1 and IsInGroup and IsInGroup() and not others then
        if C_PartyInfo and C_PartyInfo.LeaveParty then pcall(C_PartyInfo.LeaveParty)
        elseif LeaveParty then pcall(LeaveParty) end
    end
    popupState.sent[tostring(name):lower()] = nil
    Print(("cancelled the invite to %s."):format(tostring(name)))
end

StaticPopupDialogs["OLYMPUSMUTE_INVITE"] = {
    text = "%s is on your OlympusMute list <%s>.\n\nIf they join, you won't see their party chat.",
    button1 = "Unmute while grouped", button2 = "Keep muted", button3 = "Cancel invite",
    OnAccept = function(self, data)
        popupState.invite = nil
        if data then PassAll({ data }, false) end
    end,
    OnCancel = function(self, data, reason)
        -- Only a real "Keep muted" (or Escape) counts as an answer: not the window
        -- being replaced, closed by logout, or failing to open.
        if not self or reason ~= "clicked" then return end
        popupState.invite = nil
        if data and data.key then warnedInGroup[data.key] = true; db.groupWarned[data.key] = true end
    end,
    OnAlt = function(self, data)
        popupState.invite = nil
        if data and data.name then CancelInvite(data.name) end
    end,
    timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
}

StaticPopupDialogs["OLYMPUSMUTE_GROUP"] = {
    text = "Muted players in your group:\n\n%s\n\nYou won't see their party chat.",
    button1 = "Unmute while grouped", button2 = "Keep muted", button3 = "Unmute forever",
    OnAccept = function(self, data)
        popupState.group = nil
        if not data then return end
        Answered(data)
        local present, still = GroupKeys(), {}
        for _, m in ipairs(data) do if present[m.key] then still[#still + 1] = m end end
        if #still > 0 then PassAll(still, true) else Print("they've already left your group.") end
    end,
    OnCancel = function(self, data, reason)
        if not self or not data then return end
        if reason == "clicked" then          -- Keep muted / Escape
            popupState.group = nil
            Answered(data)
        elseif reason == "override" and popupState.group == data then
            -- Closed by something else (like logout): ask again later.
            popupState.group = nil
            for _, m in ipairs(data) do warnedInGroup[m.key] = nil end
        end
    end,
    OnAlt = function(self, data)
        popupState.group = nil
        if data then Answered(data); AllowAll(data) end
    end,
    timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
}
end

---------------------------------------------------------------------------
-- Name keywords: mute any player whose character name contains the text.
---------------------------------------------------------------------------
local function NameWordList()
    return #db.nameWords > 0 and table.concat(db.nameWords, ", ") or "(none)"
end

local function CleanNameWord(text)
    return strtrim(((text or ""):lower():gsub('[%*%%"]', "")))   -- remove * % " first, then trim
end

local function AddNameWord(text)
    local w = CleanNameWord(text)
    if #w < MIN_KEYWORD_LEN then
        Print(("name keywords need at least %d letters."):format(MIN_KEYWORD_LEN)) return
    end
    for _, x in ipairs(db.nameWords) do
        if x == w then Print('"' .. w .. '" is already on the name list.') return end
    end
    db.nameWords[#db.nameWords + 1] = w
    DataChanged(true)
    Print(('hiding chat from players whose name contains "%s". Name list: %s'):format(w, NameWordList()))
    if panel and panel:IsShown() then panel:Refresh() end
end

local function RemoveNameWord(text)
    local w = CleanNameWord(text)
    for i, x in ipairs(db.nameWords) do
        if x == w then
            table.remove(db.nameWords, i)
            DataChanged(true)
            Print(('removed "%s". Name list: %s'):format(w, NameWordList()))
            if panel and panel:IsShown() then panel:Refresh() end
            return
        end
    end
    Print('"' .. w .. '" isn\'t on the name list. Name list: ' .. NameWordList())
end

-- Panel button: adds the text, or removes it if it's already listed.
local function ToggleNameWord(text)
    local w = CleanNameWord(text)
    for _, x in ipairs(db.nameWords) do
        if x == w then RemoveNameWord(w) return end
    end
    AddNameWord(w)
end
AddNameWord, RemoveNameWord, ToggleNameWord = EachEntry(AddNameWord), EachEntry(RemoveNameWord), EachEntry(ToggleNameWord)

local ShowLogWindow, StartIgnoreImport   -- defined in the block below
---------------------------------------------------------------------------
-- Muted-messages log window: see what was hidden, report what deserves it.
---------------------------------------------------------------------------
do
local CHANNEL_LABEL = {
    CHAT_MSG_SAY = "Say", CHAT_MSG_YELL = "Yell", CHAT_MSG_EMOTE = "Emote", CHAT_MSG_TEXT_EMOTE = "Emote",
    CHAT_MSG_WHISPER = "Whisper", CHAT_MSG_CHANNEL = "Channel", CHAT_MSG_GUILD = "Guild",
    CHAT_MSG_OFFICER = "Officer", CHAT_MSG_PARTY = "Party", CHAT_MSG_PARTY_LEADER = "Party",
    CHAT_MSG_RAID = "Raid", CHAT_MSG_RAID_LEADER = "Raid", CHAT_MSG_RAID_WARNING = "Raid Warning",
    CHAT_MSG_INSTANCE_CHAT = "Instance", CHAT_MSG_INSTANCE_CHAT_LEADER = "Instance",
    CHAT_MSG_AFK = "Auto-reply", CHAT_MSG_DND = "Auto-reply",
}

-- Newest first, dropping anything older than LOG_AGE.
local function LogEntries()
    local list, now = {}, GetTime()
    for i, e in pairs(mutedLog) do
        if e.t and now - e.t <= LOG_AGE then list[#list + 1] = e else mutedLog[i] = nil end
    end
    table.sort(list, function(a, b) return a.t > b.t end)
    return list
end

local function ShortName(author) return (author:match("^[^%-]+") or author) end

local function PlainText(msg)
    return (msg:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|H.-|h(.-)|h", "%1"):gsub("|T.-|t", ""))
end

local function ReportEntry(e)
    if not (e and e.lineID and PlayerLocation and PlayerLocation.CreateFromChatLineID and ReportFrame
            and ReportFrame.InitiateReport and ReportInfo and ReportInfo.CreateReportInfoFromType
            and Enum and Enum.ReportType and Enum.ReportType.Chat) then
        Print("this message can't be reported from here. You can still report the player from their right-click menu.")
        return
    end
    local ok, err = pcall(function()
        local loc = PlayerLocation:CreateFromChatLineID(e.lineID)
        if C_ReportSystem and C_ReportSystem.CanReportPlayer and not C_ReportSystem.CanReportPlayer(loc) then
            Print("this message can't be reported anymore (it may be too old). You can still report the player from their right-click menu.")
            return
        end
        local info = ReportInfo:CreateReportInfoFromType(Enum.ReportType.Chat)
        ReportFrame:InitiateReport(info, e.author, loc)
    end)
    if not ok then Print("couldn't open the report window: " .. tostring(err)) end
end

StaticPopupDialogs["OLYMPUSMUTE_LOGMSG"] = {
    text = "%s said:\n\n%s",
    button1 = "Report...", button2 = CLOSE or "Close", button3 = "Never mute",
    OnAccept = function(self, data) ReportEntry(data) end,
    OnAlt = function(self, data)
        if not data or type(data.author) ~= "string" then return end
        local key = data.guid and not IsSecret(data.guid) and db.guids[data.guid] or Normalize(data.author)
        NeverMuteKey(key, ShortName(data.author))
    end,
    timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
}

local function OpenLogEntry(e)
    local text = PlainText(e.text)
    if #text > 220 then text = text:sub(1, 220) .. "..." end
    StaticPopup_Show("OLYMPUSMUTE_LOGMSG", ShortName(e.author) .. " (" .. (CHANNEL_LABEL[e.event] or "Chat") .. ", " .. e.clock .. ")",
        '"' .. text .. '"', e)
end

local logWindow
ShowLogWindow = function()
    if not logWindow then
        local ok, w = pcall(CreateFrame, "Frame", "OlympusMuteLogWindow", UIParent, "BasicFrameTemplateWithInset")
        if not ok or not w then
            w = CreateFrame("Frame", "OlympusMuteLogWindow", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
            if w.SetBackdrop then
                w:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
                    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
                    tile = true, tileSize = 32, edgeSize = 32,
                    insets = { left = 8, right = 8, top = 8, bottom = 8 } })
            end
            local close = CreateFrame("Button", nil, w, "UIPanelCloseButton")
            close:SetPoint("TOPRIGHT", -4, -4)
        end
        w:SetSize(560, 440)
        w:SetPoint("CENTER")
        w:SetFrameStrata("DIALOG")
        w:SetMovable(true); w:EnableMouse(true)
        w:RegisterForDrag("LeftButton")
        w:SetScript("OnDragStart", w.StartMoving)
        w:SetScript("OnDragStop", w.StopMovingOrSizing)
        w:SetClampedToScreen(true)
        tinsert(UISpecialFrames, "OlympusMuteLogWindow")

        local title = w:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        title:SetPoint("TOP", 0, -6)
        title:SetText("OlympusMute: muted messages")
        local hint = w:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        hint:SetPoint("TOPLEFT", 20, -34)
        hint:SetText("Last 15 minutes, cleared on /reload. Click a message to report it or never mute the sender.")

        local ROWS, ROW_H, TOP = 22, 16, 56
        local rows, entries, offset = {}, {}, 0
        for i = 1, ROWS do
            local b = CreateFrame("Button", nil, w)
            b:SetHeight(ROW_H)
            b:SetPoint("TOPLEFT", 16, -(TOP + (i - 1) * ROW_H))
            b:SetPoint("RIGHT", w, "RIGHT", -34, 0)
            b:RegisterForClicks("LeftButtonUp", "RightButtonUp")
            local hl = b:CreateTexture(nil, "HIGHLIGHT")
            hl:SetAllPoints()
            if hl.SetColorTexture then hl:SetColorTexture(1, 1, 1, 0.08) end
            local fs = b:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
            fs:SetAllPoints(); fs:SetJustifyH("LEFT")
            if fs.SetWordWrap then fs:SetWordWrap(false) end
            b.fs = fs
            b:SetScript("OnClick", function(self) if self.entry then OpenLogEntry(self.entry) end end)
            b:SetScript("OnEnter", function(self)
                if not self.entry then return end
                GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
                GameTooltip:SetText(ShortName(self.entry.author))
                GameTooltip:AddLine(PlainText(self.entry.text), 1, 1, 1, true)
                GameTooltip:AddLine("Click to report or never mute", 0.6, 0.6, 0.6)
                GameTooltip:Show()
            end)
            b:SetScript("OnLeave", GameTooltip_Hide)
            rows[i] = b
        end

        local function Render()
            for i = 1, ROWS do
                local e = entries[offset + i]
                local b = rows[i]
                b.entry = e
                if e then
                    b.fs:SetText(("|cff999999%s [%s]|r |cffffd100%s|r: %s"):format(e.clock,
                        CHANNEL_LABEL[e.event] or "Chat", ShortName(e.author), PlainText(e.text)))
                    b:Show()
                else
                    b.fs:SetText(""); b:Hide()
                end
            end
        end

        local bar = CreateFrame("Slider", nil, w)
        bar:SetOrientation("VERTICAL"); bar:SetWidth(14)
        bar:SetPoint("TOPRIGHT", -14, -TOP)
        bar:SetPoint("BOTTOMRIGHT", -14, 44)
        local thumb = bar:CreateTexture(nil, "OVERLAY")
        thumb:SetTexture("Interface\\Buttons\\UI-ScrollBar-Knob"); thumb:SetSize(18, 24)
        bar:SetThumbTexture(thumb)
        bar:SetMinMaxValues(0, 0); bar:SetValueStep(1); bar:SetValue(0)
        bar:SetScript("OnValueChanged", function(_, v) offset = math.floor(v + 0.5); Render() end)
        w:EnableMouseWheel(true)
        w:SetScript("OnMouseWheel", function(_, d) bar:SetValue(bar:GetValue() - d * 3) end)

        local empty = w:CreateFontString(nil, "OVERLAY", "GameFontDisable")
        empty:SetPoint("TOP", 0, -(TOP + 20))
        empty:SetText("No muted messages in the last 15 minutes.")

        local clear = CreateFrame("Button", nil, w, "UIPanelButtonTemplate")
        clear:SetSize(100, 22); clear:SetPoint("BOTTOMRIGHT", -16, 14)
        clear:SetText("Clear log")
        clear:SetScript("OnClick", function() wipe(mutedLog); logHead = 0; w:Refresh() end)

        function w:Refresh()
            entries = LogEntries()
            local maxOffset = math.max(0, #entries - ROWS)
            bar:SetMinMaxValues(0, maxOffset); bar:SetShown(maxOffset > 0)
            if offset > maxOffset then offset = maxOffset end
            bar:SetValue(offset)
            empty:SetShown(#entries == 0)
            Render()
        end
        w:SetScript("OnShow", w.Refresh)
        w:Hide()
        logWindow = w
    end
    if logWindow:IsShown() then logWindow:Hide() else logWindow:Show() end
end

---------------------------------------------------------------------------
-- Ignore-list import: move players from WoW's ignore list (which has a small
-- cap) onto your mute list, optionally freeing up the ignore slots.
---------------------------------------------------------------------------
local IGNORE_TAG = "from ignore list"

local function IgnoreNames()
    local names = {}
    local n = (C_FriendList and C_FriendList.GetNumIgnores and C_FriendList.GetNumIgnores())
        or (GetNumIgnores and GetNumIgnores()) or 0
    for i = 1, n do
        local name = (C_FriendList and C_FriendList.GetIgnoreName and C_FriendList.GetIgnoreName(i))
            or (GetIgnoreName and GetIgnoreName(i))
        if type(name) == "string" and name ~= "" and not IsSecret(name) and name ~= UNKNOWN then
            names[#names + 1] = name
        end
    end
    return names
end

local function ImportIgnores(removeFromIgnore)
    local names = IgnoreNames()
    local added, removed, already, skipped = 0, 0, 0, 0
    for _, name in ipairs(names) do
        local key = ResolveKey(name)
        if key and db.allow[key] then
            skipped = skipped + 1   -- on your never-mute list: left alone, and left on the ignore list
        elseif key and key ~= playerKey then
            if db.names[key] == nil then
                db.manual[key] = true
                Block(nil, name, IGNORE_TAG)
                added = added + 1
            else
                db.manual[key] = true   -- keep them muted whatever guild they join
                already = already + 1
            end
            if removeFromIgnore then
                local ok = pcall(function()
                    if C_FriendList and C_FriendList.DelIgnore then C_FriendList.DelIgnore(name)
                    elseif DelIgnore then DelIgnore(name) end
                end)
                if ok then removed = removed + 1 end
            end
        end
    end
    DataChanged(true)
    if removeFromIgnore then
        Print(("imported %d players from your ignore list (%d were already muted) and removed %d from the ignore list."):format(
            added, already, removed))
    else
        Print(("imported %d players from your ignore list (%d were already muted). Your ignore list is unchanged."):format(
            added, already))
    end
    if skipped > 0 then
        Print(("skipped %d on your never-mute list (left on your ignore list)."):format(skipped))
    end
    if panel and panel:IsShown() then panel:Refresh() end
end

StaticPopupDialogs["OLYMPUSMUTE_IMPORT"] = {
    text = "Add the %s players on your ignore list to your OlympusMute list?\n\nThey'll stay muted whatever guild they're in. "
        .. "Removing them from the ignore list frees up ignore slots.",
    button1 = "Import", button2 = CANCEL or "Cancel", button3 = "Import + clear ignore list",
    OnAccept = function() ImportIgnores(false) end,
    OnAlt = function() ImportIgnores(true) end,
    timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
}

StartIgnoreImport = function()
    local n = #IgnoreNames()
    if n == 0 then Print("your ignore list is empty, nothing to import.") return end
    StaticPopup_Show("OLYMPUSMUTE_IMPORT", tostring(n))
end

end

local SendShare, SetAcceptShares   -- defined in the block below
---------------------------------------------------------------------------
-- List sharing (idea from delro_ed): send your guild names and filtered words
-- to another OlympusMute user. Never players. Nothing changes on their side
-- until they accept.
---------------------------------------------------------------------------
do
local SHARE_PREFIX = "OMuteShare"
local SHARE_MAX_ITEMS = 100          -- per list
local SHARE_CHUNK = 220              -- characters of payload per addon message
local shareSendable = C_ChatInfo and C_ChatInfo.SendAddonMessage and true or false
if C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix then
    pcall(C_ChatInfo.RegisterAddonMessagePrefix, SHARE_PREFIX)
end

local function Esc(v) return (v:gsub("[%%;|]", function(c) return ("%%%02X"):format(c:byte()) end)) end
local function Unesc(v) return (v:gsub("%%(%x%x)", function(h) return string.char(tonumber(h, 16)) end)) end

local SHARE_MAX_BYTES = 20 * 220   -- what a receiver accepts (20 pieces)
local function BuildSharePayload()
    local items, size, ng, nw = { "v1" }, 2, 0, 0
    local function add(prefix, v)
        local item = prefix .. Esc(v)
        if size + 1 + #item > SHARE_MAX_BYTES then return false end
        items[#items + 1] = item; size = size + 1 + #item
        return true
    end
    for i, k in ipairs(db.keywords) do
        if i <= SHARE_MAX_ITEMS and add("g:", k) then ng = ng + 1 end
    end
    for i, w in ipairs(db.words) do
        if i <= SHARE_MAX_ITEMS and add("w:", w) then nw = nw + 1 end
    end
    return table.concat(items, ";"), ng, nw, (#db.keywords - ng) + (#db.words - nw)
end

local function ParseSharePayload(payload)
    local guilds, words = {}, {}
    local first = true
    for item in (payload .. ";"):gmatch("([^;]*);") do
        if first then
            if item ~= "v1" then return nil end
            first = false
        else
            local kind, v = item:match("^([gw]):(.+)$")
            v = v and Unesc(v)
            if v and v:find("|", 1, true) then v = nil end   -- no color/link/texture codes
            if v and kind == "g" and #guilds < SHARE_MAX_ITEMS then guilds[#guilds + 1] = v
            elseif v and kind == "w" and #words < SHARE_MAX_ITEMS then words[#words + 1] = v end
        end
    end
    return guilds, words
end

SendShare = function(target)
    if not shareSendable then Print("sharing isn't available on this game version.") return end
    local channel
    target = strtrim(target or "")
    if target == "" then
        if IsInRaid() then channel = "RAID" elseif IsInGroup() then channel = "PARTY"
        else Print("join a group to share with it, or type a name: /omute share Name") return end
    elseif target:lower() == "guild" then
        if not (IsInGuild and IsInGuild()) then Print("you're not in a guild.") return end
        channel, target = "GUILD", nil
    else
        channel = "WHISPER"
    end
    local payload, ng, nw, left = BuildSharePayload()
    if ng + nw == 0 then Print("your guild list and word filter are both empty, nothing to share.") return end
    local id = tostring(math.random(10000, 99999))
    local total = math.ceil(#payload / SHARE_CHUNK)
    local who = channel == "WHISPER" and target or (channel == "GUILD" and "your guild" or "your group")
    -- Send one piece at a time, retrying briefly if the game says to slow down.
    local i, retries = 1, 0
    local function step()
        local part = payload:sub((i - 1) * SHARE_CHUNK + 1, i * SHARE_CHUNK)
        local ok, res = pcall(C_ChatInfo.SendAddonMessage, SHARE_PREFIX, ("%s:%d/%d:%s"):format(id, i, total, part), channel, target)
        local code = ok and (type(res) == "number" and res or 0) or -1
        if code == 3 or code == 8 then          -- throttled: wait and try this piece again
            retries = retries + 1
            if retries > 5 then Print("sharing failed: the game is limiting addon messages right now. Try again in a minute.") return end
            C_Timer.After(1, step) return
        elseif code ~= 0 and res ~= true then
            Print(("sharing failed (the game refused the message, code %s)."):format(tostring(res))) return
        end
        if i < total then
            i, retries = i + 1, 0
            if C_Timer and C_Timer.After then C_Timer.After(0.2, step) else step() end
            return
        end
        Print(("shared %d guild names and %d filtered words with %s. They'll be asked before anything changes."):format(ng, nw, who))
        if left > 0 then Print(("(%d more entries didn't fit in one share.)"):format(left)) end
        if channel == "WHISPER" then
            Print("(shares sent by whisper only arrive if you're on their friends list or in their group.)")
        end
    end
    step()
end

-- Adding shared entries quietly (one summary line instead of one per entry).
local function MergeShared(guilds, words)
    local ng, nw = 0, 0
    local haveK = {}
    for _, k in ipairs(db.keywords) do haveK[k] = true end
    for _, g in ipairs(guilds) do
        local kw = CleanKeyword(g)
        if #kw >= MIN_KEYWORD_LEN and not haveK[kw] and not CoveredBy(kw, db.keywords) then
            db.keywords[#db.keywords + 1] = kw; haveK[kw] = true; ng = ng + 1
        end
    end
    TidyKeywords()
    scanQueries = nil
    local haveW = {}
    for _, w in ipairs(db.words) do haveW[w] = true end
    for _, raw in ipairs(words) do
        local w = CleanWordEntry(raw)
        local exact = w:match('^"(.+)"$')
        local ok = #(exact or w) >= 3
        if ok and not exact then
            for part in w:gmatch("%S+") do if #part < 2 then ok = false end end
        end
        if ok and not haveW[w] then db.words[#db.words + 1] = w; haveW[w] = true; nw = nw + 1 end
    end
    DataChanged(true)
    return ng, nw
end

local function ReplaceWithShared(guilds, words)
    db.keywords, db.words = {}, {}
    wipe(wordParts)
    local ng, nw = MergeShared(guilds, words)
    -- Unmute players who were only muted because of a guild name that's gone now.
    local drop = {}
    for name, guild in pairs(db.names) do
        if not db.manual[name] and not IsOlympus(guild) then drop[name] = true end
    end
    UnblockMany(drop)
    return ng, nw
end

local function ShareSummary(list)
    if #list == 0 then return "(none)" end
    local shown = {}
    for i = 1, math.min(5, #list) do shown[i] = list[i] end
    local s = table.concat(shown, ", ")
    if #list > 5 then s = s .. (" and %d more"):format(#list - 5) end
    return s
end

StaticPopupDialogs["OLYMPUSMUTE_SHARE"] = {
    text = "%s wants to share their OlympusMute lists with you.\n\n%s\n\nNothing changes unless you choose below.",
    button1 = "Add to mine", button2 = "Cancel", button3 = "Replace mine",
    OnAccept = function(self, data)
        local ng, nw = MergeShared(data.guilds, data.words)
        Print(("added %d guild names and %d filtered words from %s."):format(ng, nw, data.from))
        if panel and panel:IsShown() then panel:Refresh() end
    end,
    OnAlt = function(self, data)
        local ng, nw = ReplaceWithShared(data.guilds, data.words)
        Print(("replaced your lists with %s's: %d guild names, %d filtered words."):format(data.from, ng, nw))
        if panel and panel:IsShown() then panel:Refresh() end
    end,
    timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
}

StaticPopupDialogs["OLYMPUSMUTE_SHARE_SEND"] = {
    text = "Share your guild names and filtered words with:\n(a player's name, or leave empty to share with your group)",
    button1 = "Share", button2 = CANCEL or "Cancel",
    hasEditBox = 1,
    OnAccept = function(self)
        local eb = self.editBox or self.EditBox
        SendShare(eb and eb:GetText() or "")
    end,
    EditBoxOnEnterPressed = function(self)
        local parent = self:GetParent()
        SendShare(self:GetText() or "")
        if parent then parent:Hide() end
    end,
    timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
}

local incoming = {}       -- sender|id -> { parts, total, got, t }
local lastOfferFrom = {}  -- sender -> time of their last offer shown
-- Shares are only accepted from people you already know: your group, your
-- guild, or your friends list. Strangers can't send you popups.
local function TrustedSender(sender, channel)
    if channel == "PARTY" or channel == "RAID" or channel == "INSTANCE_CHAT" or channel == "GUILD" then return true end
    if channel ~= "WHISPER" then return false end
    local short = sender:match("^[^%-]+") or sender
    local ok, inGroup = pcall(function()
        return (UnitInParty and (UnitInParty(sender) or UnitInParty(short)))
            or (UnitInRaid and (UnitInRaid(sender) or UnitInRaid(short)))
    end)
    if ok and inGroup then return true end
    local okF, friend = pcall(function()
        return C_FriendList and C_FriendList.GetFriendInfo
            and (C_FriendList.GetFriendInfo(sender) or C_FriendList.GetFriendInfo(short))
    end)
    return okF and friend and true or false
end

local SHARE_MAX_PENDING = 5      -- unfinished shares kept at once
local SHARE_GLOBAL_GAP = 60      -- seconds between any two share popups
local lastOfferAny = -SHARE_GLOBAL_GAP
local function OnShareMessage(text, channel, sender)
    if not db.acceptShares or type(text) ~= "string" or type(sender) ~= "string" then return end
    if IsSecret(text) or IsSecret(sender) then return end
    local key = Normalize(sender)
    if key == playerKey then return end                 -- our own group/guild broadcast
    if MutedGuildForName(sender) then return end        -- never from muted players
    if not TrustedSender(sender, channel) then return end
    local id, i, total, part = text:match("^(%d+):(%d+)/(%d+):(.*)$")
    i, total = tonumber(i), tonumber(total)
    if not id or not i or not total or total < 1 or total > 20 or i < 1 or i > total then return end
    local slot = sender .. "|" .. id
    local entry = incoming[slot]
    if not entry then
        local n = 0
        for k, v in pairs(incoming) do
            if GetTime() - v.t > 30 then incoming[k] = nil else n = n + 1 end
        end
        if n >= SHARE_MAX_PENDING then return end         -- flood: drop new ones
        entry = { parts = {}, total = total, got = 0, t = GetTime() }
        incoming[slot] = entry
    end
    if total ~= entry.total or entry.parts[i] then return end
    entry.parts[i] = part; entry.got = entry.got + 1
    if entry.got < entry.total then return end
    incoming[slot] = nil
    for n = 1, entry.total do if not entry.parts[n] then return end end
    local guilds, words = ParseSharePayload(table.concat(entry.parts, "", 1, entry.total))
    if not guilds or (#guilds + #words == 0) then return end
    if lastOfferFrom[key] and GetTime() - lastOfferFrom[key] < 300 then return end   -- one per sender per 5 min
    if GetTime() - lastOfferAny < SHARE_GLOBAL_GAP then return end                     -- one per minute overall
    if StaticPopup_Visible and StaticPopup_Visible("OLYMPUSMUTE_SHARE") then return end
    local preview = ("Guild names (%d): %s\nFiltered words (%d): %s"):format(
        #guilds, ShareSummary(guilds), #words, ShareSummary(words))
    local popup = StaticPopup_Show("OLYMPUSMUTE_SHARE", sender, preview, { from = sender, guilds = guilds, words = words })
    if popup then
        lastOfferFrom[key] = GetTime(); lastOfferAny = GetTime()   -- limits count only shown offers
    else
        PrintThrottled("sharefail:" .. key, ("%s shared their lists, but the window couldn't open right now. Ask them to send it again."):format(sender))
    end
end

local shareFrame = CreateFrame("Frame")
shareFrame:RegisterEvent("CHAT_MSG_ADDON")
shareFrame:SetScript("OnEvent", function(_, _, prefix, text, channel, sender)
    if prefix == SHARE_PREFIX and db then pcall(OnShareMessage, text, channel, sender) end
end)

SetAcceptShares = function(on)
    db.acceptShares = on and true or false
    Print("accepting shared lists from other players " .. OnOff(db.acceptShares))
end
end

-- /who only returns the first 50 matches, so one search can't cover every
-- member. Each click runs the next search in a rotation: every guild name on
-- the list, split into level ranges, reaching members a plain search cuts off.

local function ScanBound()
    local cap = (GetMaxPlayerLevel and GetMaxPlayerLevel()) or 60
    local seen = math.max(db.maxSeenLevel or 0, UnitLevel("player") or 1)
    return math.min(cap, seen)
end

local function BuildScanQueries(maxLevel)
    local q = {}
    local cap = (GetMaxPlayerLevel and GetMaxPlayerLevel()) or 60
    for _, kw in ipairs(db.keywords) do
        local base = 'g-"' .. kw .. '"'
        q[#q + 1] = base
        -- Members above any level seen so far: one search for all of them,
        -- so a full first search can't hide them forever.
        if maxLevel < cap then q[#q + 1] = ("%s %d-%d"):format(base, maxLevel + 1, cap) end
        local lo = 1
        while lo <= maxLevel - 4 do
            q[#q + 1] = ("%s %d-%d"):format(base, lo, lo + 3)
            lo = lo + 4
        end
        for lvl = lo, maxLevel do      -- most players sit near the cap: one level each
            q[#q + 1] = ("%s %d-%d"):format(base, lvl, lvl)
        end
    end
    return q
end

-- The one place the rotation is built. Reused until the guild list changes
-- (those clear scanQueries) or the level bound moves.
local function GetScanQueries()
    local bound = ScanBound()
    if not scanQueries or scanQueriesBound ~= bound then
        scanQueries, scanQueriesBound = BuildScanQueries(bound), bound
    end
    return scanQueries
end

-- The server only allows a /who every few seconds. Enforce that on our side
-- so a fast click never skips a search, and if the server still says "wait",
-- step back so the same search runs again on the next click.

local function ScanCooldownLeft()
    return SCAN_COOLDOWN - (GetTime() - lastScanTime)
end

local function WhoScan()
    GetScanQueries()
    if #scanQueries == 0 then Print("the guild list is empty, nothing to scan.") return end
    local left = ScanCooldownLeft()
    if left > 0 then
        Print(("next scan ready in %d s."):format(math.ceil(left)))
        return
    end
    local from = scanStep
    lastScanTime = GetTime()
    scanStep = scanStep % #scanQueries + 1
    local query = scanQueries[scanStep]
    if C_FriendList and C_FriendList.SendWho then
        C_FriendList.SendWho(query)
    elseif SendWho then
        SendWho(query)
    end
    Print(("scan %d/%d: /who %s"):format(scanStep, #scanQueries, query))
    -- Start listening for the server's "too soon" notice only after our own lines.
    scanRetryFrom, scanSentAt = from, GetTime()
    if panel and panel.UpdateScanButton then panel:UpdateScanButton() end
end

local function CheckPlayer(name)
    name = TypedName(name)
    local key = ResolveKey(name)
    if key and db.names[key] then
        Print(("%s is muted <%s>."):format(name, tostring(db.names[key])))
    else
        Print(name .. " is not on the mute list.")
    end
end

local function OpenOptionsNow()
    if Settings and Settings.OpenToCategory and category then
        Settings.OpenToCategory(category.GetID and category:GetID() or category.ID)
    elseif InterfaceOptionsFrame_OpenToCategory and panel then
        InterfaceOptionsFrame_OpenToCategory(panel)
        InterfaceOptionsFrame_OpenToCategory(panel) -- old client quirk: needs two calls
    end
end

-- The game won't let addons open the Settings window during combat (it shows an
-- "action blocked" error). Wait for combat to end, then open it.
local combatWaiter = CreateFrame("Frame")
combatWaiter:SetScript("OnEvent", function(self)
    self:UnregisterEvent("PLAYER_REGEN_ENABLED")
    OpenOptionsNow()
end)

local function OpenOptions()
    if InCombatLockdown and InCombatLockdown() then
        if not combatWaiter:IsEventRegistered("PLAYER_REGEN_ENABLED") then
            combatWaiter:RegisterEvent("PLAYER_REGEN_ENABLED")
            Print("the options can't open during combat. They'll open as soon as combat ends.")
        end
        return
    end
    OpenOptionsNow()
end

StaticPopupDialogs["OLYMPUSMUTE_CLEAR"] = {
    text = "Unmute all %s players on your mute list?\n\nThis can't be undone (you'd need to scan again). Your guild list is kept.",
    button1 = YES, button2 = NO,
    OnAccept = ClearAll,
    timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
}

---------------------------------------------------------------------------
-- Muted list window (opened from the options page or /omute list)
---------------------------------------------------------------------------
-- Lines for the list window, filtered by the search box. One line per entry, so
-- the window can show any number of players (a single text block gets cut off).
local function BuildListLines(filter)
    local f = (filter and filter ~= "") and filter:lower() or nil
    local lines, total = {}, 0
    local allowed = {}
    for name in pairs(db.allow) do
        if not f or name:find(f, 1, true) then allowed[#allowed + 1] = name end
    end
    table.sort(allowed)
    for _, name in ipairs(allowed) do
        lines[#lines + 1] = "|cff66ff66never muted|r  " .. name
    end
    local byGuild = db.listSort == "guild"
    local muted = {}
    for name, guild in pairs(db.names) do
        total = total + 1
        local g = tostring(guild)
        local gl = g:lower()
        if not f or name:find(f, 1, true) or gl:find(f, 1, true) then
            muted[#muted + 1] = { name = name, g = g, gl = gl }
        end
    end
    if byGuild then
        table.sort(muted, function(a, b)
            if a.gl ~= b.gl then return a.gl < b.gl end
            return a.name < b.name
        end)
        for _, m in ipairs(muted) do lines[#lines + 1] = "|cff999999<" .. m.g .. ">|r  " .. m.name end
    else
        table.sort(muted, function(a, b) return a.name < b.name end)
        for _, m in ipairs(muted) do lines[#lines + 1] = m.name .. "  |cff999999<" .. m.g .. ">|r" end
    end
    return lines, total, #allowed + #muted
end

ShowListWindow = function()
    if not listWindow then
        local ok, w = pcall(CreateFrame, "Frame", "OlympusMuteListWindow", UIParent, "BasicFrameTemplateWithInset")
        if not ok or not w then
            w = CreateFrame("Frame", "OlympusMuteListWindow", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
            if w.SetBackdrop then
                w:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
                    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
                    tile = true, tileSize = 32, edgeSize = 32,
                    insets = { left = 8, right = 8, top = 8, bottom = 8 } })
            end
            local close = CreateFrame("Button", nil, w, "UIPanelCloseButton")
            close:SetPoint("TOPRIGHT", -4, -4)
        end
        w:SetSize(440, 480)
        w:SetPoint("CENTER")
        w:SetFrameStrata("DIALOG")
        w:SetMovable(true)
        w:EnableMouse(true)
        w:RegisterForDrag("LeftButton")
        w:SetScript("OnDragStart", w.StartMoving)
        w:SetScript("OnDragStop", w.StopMovingOrSizing)
        w:SetClampedToScreen(true)
        tinsert(UISpecialFrames, "OlympusMuteListWindow")   -- Esc closes it

        local title = w:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        title:SetPoint("TOP", 0, -6)

        -- search box
        local search = CreateFrame("EditBox", nil, w, "InputBoxTemplate")
        search:SetSize(200, 20)
        search:SetPoint("TOPLEFT", 22, -32)
        search:SetAutoFocus(false)
        local hint = search:CreateFontString(nil, "OVERLAY", "GameFontDisable")
        hint:SetPoint("LEFT", 4, 0)
        hint:SetText("Search name or guild")
        local shown = w:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        shown:SetPoint("LEFT", search, "RIGHT", 10, 0)

        local lines, offset = {}, 0

        -- Sort toggle: by player name, or by guild (then name)
        local sortBtn = CreateFrame("Button", nil, w, "UIPanelButtonTemplate")
        sortBtn:SetSize(110, 22)
        sortBtn:SetPoint("TOPRIGHT", -16, -30)
        local function SortLabel()
            sortBtn:SetText(db.listSort == "guild" and "Sort: Guild" or "Sort: Name")
        end
        SortLabel()
        sortBtn:SetScript("OnClick", function()
            db.listSort = (db.listSort == "guild") and "name" or "guild"
            SortLabel()
            offset = 0
            w:Refresh()
        end)
        sortBtn:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText("Sort order")
            GameTooltip:AddLine("Click to switch between sorting by player name and by guild.", 1, 1, 1, true)
            GameTooltip:Show()
        end)
        sortBtn:SetScript("OnLeave", GameTooltip_Hide)

        -- fixed rows, filled from the current scroll position
        local ROWS, ROW_H, TOP = 24, 16, 60
        local rows = {}
        for i = 1, ROWS do
            local fs = w:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
            fs:SetPoint("TOPLEFT", 18, -(TOP + (i - 1) * ROW_H))
            fs:SetPoint("RIGHT", w, "RIGHT", -34, 0)
            fs:SetJustifyH("LEFT")
            if fs.SetWordWrap then fs:SetWordWrap(false) end
            rows[i] = fs
        end

        local function Render()
            for i = 1, ROWS do rows[i]:SetText(lines[offset + i] or "") end
        end

        local bar = CreateFrame("Slider", nil, w)
        bar:SetOrientation("VERTICAL")
        bar:SetWidth(14)
        bar:SetPoint("TOPRIGHT", -14, -TOP)
        bar:SetPoint("BOTTOMRIGHT", -14, 16)
        local track = bar:CreateTexture(nil, "BACKGROUND")
        track:SetAllPoints()
        if track.SetColorTexture then track:SetColorTexture(0, 0, 0, 0.35) end
        local thumb = bar:CreateTexture(nil, "OVERLAY")
        thumb:SetTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
        thumb:SetSize(18, 24)
        bar:SetThumbTexture(thumb)
        bar:SetMinMaxValues(0, 0)
        bar:SetValueStep(1)
        if bar.SetObeyStepOnDrag then bar:SetObeyStepOnDrag(true) end
        bar:SetValue(0)
        bar:SetScript("OnValueChanged", function(_, v)
            offset = math.floor(v + 0.5)
            Render()
        end)

        w:EnableMouseWheel(true)
        w:SetScript("OnMouseWheel", function(_, delta)
            bar:SetValue(bar:GetValue() - delta * 3)
        end)

        function w:Refresh()
            local total, matched
            lines, total, matched = BuildListLines(search:GetText())
            title:SetText(("OlympusMute: muted players (%s)"):format(FormatNum(total)))
            local filtering = (search:GetText() or "") ~= ""
            hint:SetShown(not filtering and not search:HasFocus())
            shown:SetText(filtering and ("%s found"):format(FormatNum(matched)) or "")
            local maxOffset = math.max(0, #lines - ROWS)
            bar:SetMinMaxValues(0, maxOffset)
            bar:SetShown(maxOffset > 0)
            if offset > maxOffset then offset = maxOffset end
            bar:SetValue(offset)
            if #lines == 0 then
                rows[1]:SetText(filtering and "|cff999999No matches.|r" or "|cff999999No players muted yet.|r")
                for i = 2, ROWS do rows[i]:SetText("") end
            else
                Render()
            end
        end

        search:SetScript("OnTextChanged", function() offset = 0; w:Refresh() end)
        search:SetScript("OnEditFocusGained", function() hint:Hide() end)
        search:SetScript("OnEditFocusLost", function() hint:SetShown((search:GetText() or "") == "") end)
        search:SetScript("OnEscapePressed", search.ClearFocus)
        search:SetScript("OnEnterPressed", search.ClearFocus)

        -- DataChanged() refreshes it while open; it also rebuilds whenever shown.
        w:SetScript("OnShow", w.Refresh)
        w:Hide()
        listWindow = w
    end
    if listWindow:IsShown() then listWindow:Hide() else listWindow:Show() end
end

---------------------------------------------------------------------------
-- Options > AddOns panel
---------------------------------------------------------------------------
CreatePanel = function()
    panel = CreateFrame("Frame")
    panel.name = "OlympusMute"

    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("OlympusMute")

    local desc = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    desc:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    desc:SetPoint("RIGHT", panel, "RIGHT", -16, 0)
    desc:SetJustifyH("LEFT")
    desc:SetText("Hides chat from players whose guild name contains any name on your guild list "
        .. "(Olympus by default). Only affects your screen and doesn't use your ignore list. "
        .. "Chat doesn't show a player's guild, so players are added to your mute list automatically "
        .. "when you target them, mouse over them, see their nameplate, group with them, shift-click "
        .. "their name in chat, or find them with /who (the Scan button).")

    -- Stats line: the first thing you see when opening the panel
    local statsText = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    statsText:SetPoint("TOPLEFT", desc, "BOTTOMLEFT", 0, -10)
    statsText:SetJustifyH("LEFT")

    -- Checkboxes in two columns so the page fits inside the Settings window
    local COL2 = 300
    local function MakeCheck(text, onClick)
        local c = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
        local label = c.Text or c.text or c:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        label:ClearAllPoints()
        label:SetPoint("LEFT", c, "RIGHT", 2, 1)
        label:SetText(text)
        c:SetScript("OnClick", function(self) onClick(self:GetChecked()) end)
        return c
    end
    local function Below(c, anchor) c:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, 0) end
    local function RightOf(c, leftCheck) c:SetPoint("TOPLEFT", leftCheck, "TOPLEFT", COL2, 0) end

    local enable = MakeCheck("Enable filtering", SetEnabled)
    enable:SetPoint("TOPLEFT", statsText, "BOTTOMLEFT", -2, -6)
    local hideBubbles = MakeCheck("Hide their chat bubbles (open world)", SetHideBubbles)
    RightOf(hideBubbles, enable)
    local declineGuild = MakeCheck("Auto-decline guild invites", SetDeclineGuild)
    Below(declineGuild, enable)
    local declineGroup = MakeCheck("Auto-decline group invites", SetDeclineGroup)
    RightOf(declineGroup, declineGuild)
    local declineDuel = MakeCheck("Auto-decline duels", SetDeclineDuel)
    Below(declineDuel, declineGuild)
    local declineTrade = MakeCheck("Ask before trades", SetDeclineTrade)
    RightOf(declineTrade, declineDuel)
    local instantDecline = MakeCheck("Decline group invites and duels instantly", SetInstantDecline)
    Below(instantDecline, declineDuel)
    local groupWarn = MakeCheck("Warn when a muted player is in my group", SetGroupWarn)
    Below(groupWarn, instantDecline)
    local whisperWarn = MakeCheck("Warn if I whisper/invite a muted player", SetWhisperWarn)
    RightOf(whisperWarn, groupWarn)

    local function MakeButton(text, width, onClick, anchor, x, y)
        local b = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
        b:SetSize(width, 22)
        b:SetText(text)
        b:SetPoint("TOPLEFT", anchor, x and "TOPRIGHT" or "BOTTOMLEFT", x or 0, y or 0)
        b:SetScript("OnClick", onClick)
        return b
    end
    local function Tip(btn, title, ...)
        local lines = { ... }
        btn:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(title)
            for _, l in ipairs(lines) do GameTooltip:AddLine(l, 1, 1, 1, true) end
            GameTooltip:Show()
        end)
        btn:SetScript("OnLeave", GameTooltip_Hide)
    end
    local function MakeBox(anchor, yGap)
        local b = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
        b:SetSize(180, 20)
        b:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 6, yGap or -4)
        b:SetAutoFocus(false)
        b:SetScript("OnEscapePressed", b.ClearFocus)
        return b
    end
    local function BoxAction(box, fn)
        return function()
            fn(strtrim(box:GetText() or ""))
            box:SetText(""); box:ClearFocus()
        end
    end

    -- Guild names
    local kwLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    kwLabel:SetPoint("TOPLEFT", groupWarn, "BOTTOMLEFT", 2, -8)
    kwLabel:SetText("Muted guild names (matches any part, so \"olympus\" covers Olympus II, OLYMPUS WOW...):")
    local kwBox = MakeBox(kwLabel)
    kwBox:SetScript("OnEnterPressed", BoxAction(kwBox, AddKeyword))
    local kwAdd = MakeButton("Add guild", 90, BoxAction(kwBox, AddKeyword), kwBox, 8, 1)
    Tip(kwAdd, "Add guild", "Mutes every guild whose name contains this text, anywhere in the name. "
        .. "No * or wildcards needed: \"olympus\" already covers OLYMPUS, Olympus LXIV, Olympus Canada, and so on.",
        "Add several at once with commas: olympus, holypmus")
    local kwRemove = MakeButton("Remove guild", 110, BoxAction(kwBox, RemoveKeyword), kwAdd, 6, 0)
    local kwExempt = MakeButton("Guild whitelist", 120, BoxAction(kwBox, ExemptGuild), kwRemove, 6, 0)
    Tip(kwExempt, "Guild whitelist", "Type a full guild name to whitelist it: it's never muted, even if it contains a muted name "
        .. "(for example \"Anti Olympus\"). Click again with the same name to undo.")

    local kwText = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    kwText:SetPoint("TOPLEFT", kwBox, "BOTTOMLEFT", -6, -5)
    kwText:SetPoint("RIGHT", panel, "RIGHT", -16, 0)
    kwText:SetJustifyH("LEFT")

    local whoBtn = MakeButton("Scan /who", 200, WhoScan, kwText, nil, -6)
    local shareBtn = MakeButton("Share lists...", 120, function() StaticPopup_Show("OLYMPUSMUTE_SHARE_SEND") end, whoBtn, 12, 0)
    Tip(shareBtn, "Share lists", "Send your guild names and filtered words to another OlympusMute user, or to your whole group.",
        "They see what's in it and choose to add it to theirs, replace theirs, or cancel. Players are never shared.",
        "Shares are only accepted from your group, your guild, or your friends list.")
    function panel:UpdateScanButton()
        local total = #GetScanQueries()
        if total == 0 then whoBtn:SetText("Scan /who (no guilds)") return end
        local left = ScanCooldownLeft()
        if left > 0 then
            whoBtn:SetText(("Next scan %d/%d in %ds"):format(scanStep % total + 1, total, math.ceil(left)))
            whoBtn:Disable()
        else
            whoBtn:SetText(("Scan /who (%d/%d)"):format(scanStep % total + 1, total))
            whoBtn:Enable()
        end
    end
    local tick = 0
    whoBtn:HookScript("OnUpdate", function(_, elapsed)
        tick = tick + elapsed
        if tick < 0.25 then return end
        tick = 0
        if not whoBtn:IsEnabled() or ScanCooldownLeft() > 0 then panel:UpdateScanButton() end
    end)

    -- Word filter
    local wLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    wLabel:SetPoint("TOPLEFT", whoBtn, "BOTTOMLEFT", 0, -10)
    wLabel:SetText("Hide messages from anyone containing all of these words (any order):")
    local wBox = MakeBox(wLabel)
    wBox:SetScript("OnEnterPressed", BoxAction(wBox, AddWord))
    local wAdd = MakeButton("Add word", 90, BoxAction(wBox, AddWord), wBox, 8, 1)
    Tip(wAdd, "Add word", "A message is hidden if it contains every word you enter, in any order. "
        .. "\"inv layer\" hides \"inv to asmon layer pls\" and \"invite to asmon layer pls\". "
        .. "Parts also match inside longer words (\"inv\" matches \"inventory\").",
        "Put it in quotes, like \"asmon layer\", to match only that exact phrase.",
        "Add several at once with commas: inv layer, \"asmon layer\"")
    MakeButton("Remove word", 110, BoxAction(wBox, RemoveWord), wAdd, 6, 0)

    local wText = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    wText:SetPoint("TOPLEFT", wBox, "BOTTOMLEFT", -6, -5)
    wText:SetPoint("RIGHT", panel, "RIGHT", -16, 0)
    wText:SetJustifyH("LEFT")

    -- One player box for mute / never mute / unmute
    local pLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    pLabel:SetPoint("TOPLEFT", wText, "BOTTOMLEFT", 0, -10)
    pLabel:SetText("Player (First Last):")
    local box = MakeBox(pLabel)
    box:SetScript("OnEnterPressed", BoxAction(box, AddPlayer))
    local muteBtn = MakeButton("Mute", 70, BoxAction(box, AddPlayer), box, 8, 1)
    Tip(muteBtn, "Mute", "Add this player to your mute list by hand. They stay muted even if they change guilds.",
        "Several at once with commas: Tiny Yackle, Bacon Eggz")
    local neverBtn = MakeButton("Never mute", 100, BoxAction(box, AllowPlayer), muteBtn, 6, 0)
    Tip(neverBtn, "Never mute", "This player is never muted, even in a muted guild. Click again with the same name to undo.")
    local unmuteBtn = MakeButton("Unmute", 80, BoxAction(box, RemovePlayer), neverBtn, 6, 0)
    local nameBtn = MakeButton("Name contains", 110, BoxAction(box, ToggleNameWord), unmuteBtn, 6, 0)
    Tip(nameBtn, "Name contains", "Hides chat from any player whose character name contains this text (at least 3 letters). "
        .. "Click again with the same text to remove it.")

    local nText = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    nText:SetPoint("TOPLEFT", box, "BOTTOMLEFT", -6, -5)
    nText:SetPoint("RIGHT", panel, "RIGHT", -16, 0)
    nText:SetJustifyH("LEFT")

    -- Muted list row: count, then its two buttons right next to it
    local countText = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    countText:SetPoint("TOPLEFT", nText, "BOTTOMLEFT", 0, -10)

    local viewBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    viewBtn:SetSize(90, 22)
    viewBtn:SetText("View list")
    viewBtn:SetPoint("LEFT", countText, "RIGHT", 12, 0)
    viewBtn:SetScript("OnClick", function() ShowListWindow() end)

    local clearBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    clearBtn:SetSize(150, 22)
    clearBtn:SetText("Unmute all players...")
    clearBtn:SetPoint("LEFT", viewBtn, "RIGHT", 24, 0)   -- a gap so it isn't hit by accident

    -- Second row: the muted-messages log and the ignore-list import
    local logBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    logBtn:SetSize(150, 22)
    logBtn:SetText("Muted messages...")
    logBtn:SetPoint("TOPLEFT", countText, "BOTTOMLEFT", 0, -12)
    logBtn:SetScript("OnClick", function() ShowLogWindow() end)
    Tip(logBtn, "Muted messages", "See the messages OlympusMute hid in the last 15 minutes. Click one to report it "
        .. "or never mute the sender. Cleared on /reload.")
    local importBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    importBtn:SetSize(170, 22)
    importBtn:SetText("Import ignore list...")
    importBtn:SetPoint("LEFT", logBtn, "RIGHT", 8, 0)
    importBtn:SetScript("OnClick", function() StartIgnoreImport() end)
    Tip(importBtn, "Import ignore list", "Adds everyone on your WoW ignore list to your mute list, so they stay muted "
        .. "whatever guild they're in. You can also clear them from the ignore list to free up slots.")
    clearBtn:SetScript("OnClick", function()
        StaticPopup_Show("OLYMPUSMUTE_CLEAR", FormatNum(CountMuted()))
    end)

    local mutedCount = 0
    function panel:UpdateStats(n)
        if n then mutedCount = n end
        statsText:SetText(("Hidden |cffffd100%s|r messages (%s this session)  ·  |cffffd100%s|r players muted"):format(
            FormatNum(db.hiddenTotal or 0), FormatNum(sessionHidden), FormatNum(mutedCount)))
        countText:SetText(("Muted players: %s"):format(FormatNum(mutedCount)))
    end

    function panel:Refresh()
        enable:SetChecked(db.enabled)
        kwText:SetText("Current list: |cffffffff" .. KeywordList() .. "|r"
            .. (next(db.guildAllow) and ("   Whitelist: |cff66ff66" .. ExemptList() .. "|r") or ""))
        wText:SetText("Filtered words: |cffffffff" .. WordList() .. "|r")
        nText:SetText("Names containing: |cffffffff" .. NameWordList() .. "|r")
        self:UpdateScanButton()
        declineGuild:SetChecked(db.declineGuild)
        declineGroup:SetChecked(db.declineGroup)
        declineDuel:SetChecked(db.declineDuel)
        declineTrade:SetChecked(db.declineTrade)
        groupWarn:SetChecked(db.groupWarn)
        instantDecline:SetChecked(db.instantDecline)
        whisperWarn:SetChecked(db.whisperWarn)
        hideBubbles:SetChecked(db.hideBubbles)
        self:UpdateStats(CountMuted())
        if listWindow and listWindow:IsShown() then listWindow:Refresh() end
    end
    panel:SetScript("OnShow", panel.Refresh)

    if Settings and Settings.RegisterCanvasLayoutCategory then
        category = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
        Settings.RegisterAddOnCategory(category)
    elseif InterfaceOptions_AddCategory then
        InterfaceOptions_AddCategory(panel)
    end
end

---------------------------------------------------------------------------
-- /omute
---------------------------------------------------------------------------
SLASH_OLYMPUSMUTE1 = "/omute"
SlashCmdList.OLYMPUSMUTE = function(input)
    if not db then return end
    local cmd, rest = (input or ""):match("^%s*(%S*)%s*(.-)%s*$")
    cmd = cmd:lower()
    -- on/off in any case ("ON", "Off"); names and words keep their case
    local arg = rest:lower()
    local onoff
    if arg == "on" then onoff = true elseif arg == "off" then onoff = false end

    if cmd == "on" or cmd == "off" then
        SetEnabled(cmd == "on")
    elseif cmd == "log" then
        ShowLogWindow()
    elseif cmd == "import" then
        StartIgnoreImport()
    elseif cmd == "list" then
        ShowListWindow()
    elseif cmd == "debug" then
        db.debug = not db.debug
        Print("debug " .. (db.debug and "ON" or "OFF"))
    elseif cmd == "guild" then
        local sub, arg = rest:match("^(%S*)%s*(.-)$")
        sub = (sub or ""):lower()
        if sub == "add" and arg ~= "" then AddKeyword(arg)
        elseif sub == "remove" and arg ~= "" then RemoveKeyword(arg)
        elseif (sub == "whitelist" or sub == "exempt") and arg ~= "" then ExemptGuild(arg)
        else Print("guild list: " .. KeywordList() .. "  (/omute guild add|remove|whitelist Name). Whitelist: " .. ExemptList()) end
    elseif cmd == "allow" and rest ~= "" then
        AllowPlayer(rest)
    elseif cmd == "instant" and onoff ~= nil then
        SetInstantDecline(onoff)
    elseif cmd == "duels" and onoff ~= nil then
        SetDeclineDuel(onoff)
    elseif cmd == "trades" and onoff ~= nil then
        SetDeclineTrade(onoff)
    elseif cmd == "bubbles" and onoff ~= nil then
        SetHideBubbles(onoff)
    elseif (cmd == "whisperwarn" or cmd == "invitewarn") and onoff ~= nil then
        SetWhisperWarn(onoff)
    elseif cmd == "groupwarn" and onoff ~= nil then
        SetGroupWarn(onoff)
    elseif cmd == "tally" or cmd == "stats" then   -- "stats" kept for anyone used to it
        Print(("hidden %s messages (%s this session) from %s muted players."):format(
            FormatNum(db.hiddenTotal or 0), FormatNum(sessionHidden), FormatNum(CountMuted())))
    elseif cmd == "word" then
        local sub, arg = rest:match("^(%S*)%s*(.-)$")
        sub = (sub or ""):lower()
        if sub == "add" and arg ~= "" then AddWord(arg)
        elseif sub == "remove" and arg ~= "" then RemoveWord(arg)
        else Print("filtered words: " .. WordList() .. "  (/omute word add|remove text)") end
    elseif cmd == "check" and rest ~= "" then
        CheckPlayer(rest)
    elseif cmd == "add" and rest ~= "" then
        AddPlayer(rest)
    elseif cmd == "remove" and rest ~= "" then
        RemovePlayer(rest)
    elseif cmd == "clear" then
        StaticPopup_Show("OLYMPUSMUTE_CLEAR", FormatNum(CountMuted()))
    elseif cmd == "invites" and onoff ~= nil then
        SetDeclineGuild(onoff); SetDeclineGroup(onoff)
    elseif cmd == "guildinvites" and onoff ~= nil then
        SetDeclineGuild(onoff)
    elseif cmd == "groupinvites" and onoff ~= nil then
        SetDeclineGroup(onoff)
    elseif cmd == "name" then
        local sub, a = rest:match("^(%S*)%s*(.-)$")
        sub = (sub or ""):lower()
        if sub == "add" and a ~= "" then AddNameWord(a)
        elseif sub == "remove" and a ~= "" then RemoveNameWord(a)
        else Print("name list: " .. NameWordList() .. "  (/omute name add|remove text)") end
    elseif cmd == "share" then
        SendShare(rest)
    elseif cmd == "shares" and onoff ~= nil then
        SetAcceptShares(onoff)
    elseif cmd == "scan" then
        WhoScan()
    elseif cmd == "" or cmd == "config" or cmd == "options" then
        OpenOptions()
    else
        Print(("filtering %s, %d players muted."):format(
            db.enabled and "|cff00ff00ON|r" or "|cffff0000OFF|r", CountMuted()))
        Print("/omute (opens options) | config | on | off | invites on|off | guildinvites on|off | groupinvites on|off | guild add|remove|whitelist Name | word add|remove text | duels on|off | instant on|off | trades on|off | groupwarn on|off | whisperwarn on|off | bubbles on|off | allow Name (again to undo) | name add|remove text | share [Name|guild] | shares on|off | tally | log | import | list | scan | check Name | add Name | remove Name | clear | debug")
        Print("Separate several names or words with commas: /omute add Name1, Name2")
    end
end

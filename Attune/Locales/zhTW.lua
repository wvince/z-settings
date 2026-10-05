--localization file for english/United States
local Lang = LibStub("AceLocale-3.0"):NewLocale("Attune", "zhTW")
if (not Lang) then
	return;
end


-- INTERFACE
Lang["Credits"] = "非常感謝我的公會|cffffd100<Calm Down>|r在我測試插件時給予的支持與理解。\n\n如果在遊戲裡見到我，給我一個|cffffd100/hug|r吧！\n\nCixi Delmont / Gaya Greyhoof"
Lang["Zoom"] = "縮放"
Lang["Pan_DESC"] = "按住拖曳可平移任務鏈。Shift+滾輪可橫向平移。"
Lang["Version"] = "Attune v##VERSION## by Cixi Delmont / Gaya Greyhoof"
Lang["Splash"] = "v##VERSION## by Cixi Delmont / Gaya Greyhoof. 輸入/attune開始。"
Lang["Survey"] = "調查"
Lang["Guild"] = "公會"
Lang["Party"] = "隊伍"
Lang["Raid"] = "團隊"
Lang["Run an attunement survey (for people with the addon)"] = "進行開門任務調查（安裝此插件的玩家）"
Lang["Toggle between attunements and survey results"] = "切換調查結果" 
Lang["Close"] = "關閉" 
Lang["Export"] = "匯出"
Lang["My Data"] = "我的資料"
Lang["Last Survey"] = "上次調查"
Lang["Guild Data"] = "公會數據"
Lang["All Data"] = "所有數據"
Lang["Export your Attune data to the website"] = "將您的Attune數據匯出到網站"
Lang["Copy the text below, then upload it to"] = "複製下面的文本，然後將其上傳到"
Lang["Results"] = "調查結果"
Lang["Not in a guild"] = "沒有加入公會"
Lang["Click on a header to sort the results"] = "點擊標題以對結果進行排序" 
Lang["Character"] = "特質" 
Lang["Characters"] = "角色"
Lang["Last survey results"] = "上次調查结果"	
Lang["All FACTION results"] = "所有 ##FACTION## 结果"
Lang["Guild members"] = "公會成員" 
Lang["All results"] = "所有結果" 
Lang["Minimum level"] = "最低等級" 
Lang["Click to navigate to that attunement"] = "點擊以導航到該開門任務權限"
Lang["Click to show map"] = "點擊查看獎勵和地圖。再次點擊返回。"
Lang["Starts at"] = "起始於"
Lang["Attunes"] = "使用權"
Lang["Guild members on this step"] = "同任務進度的公會成員"
Lang["Attuned guild members"] = "Attuned 公會成員"
Lang["Attuned alts"] = "Attuned 超越"
Lang["Alts on this step"] = "超越該任務進度"
Lang["Settings"] = "設定"
Lang["Survey Log"] = "調查紀錄"
Lang["LeftClick"] = "左鍵點選"
Lang["OpenAttune"] = "打開 Attune"
Lang["RightClick"] = "右鍵點選"
Lang["OpenSettings"] = "打開設定"
Lang["Addon disabled"] = "插件已禁用"
Lang["StartAutoGuildSurvey"] = "開始公會自動調查"
Lang["SendingDataTo"] = "發送Attune數據给 |cffffd100NA##NAME##|r"
Lang["NewVersionAvailable"] = "一個Attune的 |cffffd100新版本|r 可用, 請更新它！"
Lang["CompletedStep"] = "已完成該 ##TYPE## |cffe4e400##STEP##|r  |cffe4e400##NAME##|r."
Lang["AttuneComplete"] = " |cffe4e400##NAME##|r 聲望已達到!"
Lang["AttuneCompleteGuild"] = "##NAME## 聲望已達到!"
Lang["SendingSurveyWhat"] = "發送調查"
Lang["SendingGuildSilentSurvey"] = "發送公會靜默調查"
Lang["SendingYellSilentSurvey"] = "發送 /大喊 靜默調查"
Lang["ReceivedDataFromName"] = "從 |cffffd100##NAME##接收的數據|r"
Lang["ExportingData"] = "統計Attune人物數據 ##COUNT##"
Lang["ReceivedRequestFrom"] = "收到 |cffffd100##FROM##的請求|r"
Lang["Help1"] = "該插件可讓您檢查並導出聲望進度。"
Lang["Help2"] = "運行 |cfffff700/attune|r 開始。"
Lang["Help3"] = "要調查公會的進度，請點擊 |cfffff700調查|r 收集訊息。"
Lang["Help4"] = "您將從帶有插件的任何公會成員那裡收到任務進度數據。"
Lang["Help5"] = "獲得足夠的訊息後，請點擊 |cfffff700導出|r 以導出公會進度。"
Lang["Help6"] = "數據可以上傳到 |cfffff700https://warcraftratings.com/attune/upload|r"
Lang["Survey_DESC"] = "進行聲望調查 (安裝本插件的玩家)"
Lang["Export_DESC"] = "將您的Attune數據導出到網站"
Lang["Toggle_DESC"] = "顯示調查結果"
--Lang["PreferredLocale_TEXT"] = "首選語言"
--Lang["PreferredLocale_DESC"] = "選擇您想要使用的Attune語言。對此進行更改將需要重新加載才能生效。"
--v220
Lang["My Toons"] = "我的角色"
Lang["No Target"] = "你沒有目標"
Lang["No Response From"] = " ##PLAYER##沒有回應"
Lang["Sync Request From"] = "來自:\n\n##PLAYER##的同步請求"
Lang["Could be slow"] = "根據您擁有的數據量，這可能是一個非常緩慢的過程。"
Lang["Accept"] = "接受"
Lang["Reject"] = "拒絕"
Lang["Busy right now"] = "##PLAYER## 正在忙碌，稍後再試"
Lang["Sending Sync Request"] = "發送同步請求到 ##PLAYER##"
Lang["Request accepted, sending data to "] = "請求已接受，將數據發送到 ##PLAYER##"
Lang["Received request from"] = "收到來自 ##PLAYER##的請求"
Lang["Request rejected"] = "請求被拒絕"
Lang["Sync over"] = "同步結束，使用時間##DURATION##"
Lang["Syncing Attune data with"] = "與##PLAYER##數據同步"
Lang["Cannot sync while another sync is in progress"] = "無法同時進行兩個同步"
Lang["Sync with target"] = "正在與目標同步"
Lang["Show Profiles"] = "顯示個人資料"
Lang["Show Progress"] = "顯示進度"
Lang["Status"] = "狀態"
Lang["Role"] = "角色"
Lang["Last Surveyed"] = "上次的調查"
Lang['Seconds ago'] = "##DURATION## 秒"
Lang["Main"] = "主選單"
Lang["Alt"] = "備用角色"
Lang["Tank"] = "坦克"
Lang["Healer"] = "治療"
Lang["Melee DPS"] = "近戰輸出"
Lang["Ranged DPS"] = "遠程輸出"
Lang["Bank"] = "銀行"
Lang["DelAlts_TEXT"] = "刪除所有備用角色。"
Lang["DelAlts_DESC"] = "刪除所有標記為備用角色訊息。"
Lang["DelAlts_CONF"] = "確定刪除所有備用角色?"
Lang["DelAlts_DONE"] = "所有備用角色已刪除。"
Lang["DelUnspecified_TEXT"] = "刪除未指定。"
Lang["DelUnspecified_DESC"] = "刪除有關未指定主/備用狀態的玩家的所有訊息。"
Lang["DelUnspecified_CONF"] = "確定刪除所有未指定主/備用狀態的玩家的所有訊息嗎？"
Lang["DelUnspecified_DONE"] = "所有未指定的主/備用狀態的玩家的所有訊息都已刪除。"
--v221
Lang["Open Raid Planner"] = "公開團隊副本設計師"
Lang["Unspecified"] = "未指定"
Lang["Empty"] = "空的"
Lang["Guildies only"] = "僅顯示公會成員"
Lang["Show Mains"] = "顯示主要角色"
Lang["Show Unspecified"] = "顯示未指定角色"
Lang["Show Alts"] = "顯示備用角色"
Lang["Show Unattuned"] = "顯示未完成開門任務角色"
Lang["Raid spots"] = "##SIZE## 團隊副本陣地"
Lang["Group Number"] = "團本 ##NUMBER##"
Lang["Move to next group"] = "移至下一組"
Lang["Remove from raid"] = "從團隊副本中移除"
Lang["Select a raid and click on players to add them in"] = "選擇一個團隊並點擊玩家以添加他們"
Lang["Planner"] = "規劃師"
--v224
Lang["Enter a new name for this raid group"] = "輸入此團隊的新名稱"
Lang["Save"] = "保存"
--v226
Lang["Invite"] = "邀請"
Lang["Send raid invites to all listed players?"] = "向所有列出的玩家發送團隊副本邀請？"
Lang["External link"] = "連接到在線數據庫"
Lang["Quest rewards"] = "任務獎勵"
Lang["No item rewards"] = "此任務沒有物品獎勵。"
Lang["Rewards only if available"] = "僅顯示此角色可接任務的物品獎勵。"
Lang["Loading rewards"] = "正在載入獎勵..."
Lang["Show link"] = "顯示連結"
Lang["Choose one reward"] = "任選其一"
--v243
Lang["Ogrila"] = "奧格瑞拉"
Lang["Ogri'la Quest Hub"] = "奧格瑞拉宣教中心"
Lang["Ogrila_Desc"] = "聰明而開化的奧格瑞拉食人魔居住在刀鋒山的西部區域。"
Lang["DelInactive_TEXT"] = "刪除不活動"
Lang["DelInactive_DESC"] = "刪除所有標記為非活動玩家的信息"
Lang["DelInactive_CONF"] = "真的刪除所有非活動嗎？"
Lang["DelInactive_DONE"] = "已刪除所有非活動"
Lang["RAIDS"] = "團隊"
Lang["KEYS"] = "鑰匙"
Lang["MISC"] = "雜項"
Lang["HEROICS"] = "英雄"
--v244
Lang["Ally of the Netherwing"] = "靈翼之盟"
Lang["Netherwing_Desc"] = "虛空之翼是位於外域的一個龍派系。"
--v247
Lang["Tirisfal Glades"] = "提瑞斯法林地"
Lang["Scholomance"] = "通灵学院"
--v248
Lang["Target"] = "目標"
Lang["SendingSurveyTo"] = "向 ##TO## 發送調查"


-- OPTIONS
Lang["MinimapButton_TEXT"] = "顯示小地圖按鈕"
Lang["MinimapButton_DESC"] = "顯示小地圖按鈕可快速訪問插件介面或選項。"
Lang["FullMap_TEXT"] = "使用完整地圖顯示任務給予者位置"
Lang["FullMap_DESC"] = "點擊任務時開啟世界地圖並定位到任務給予者，而不是在側邊欄顯示地圖。任務獎勵會延伸至側邊欄底部。"
Lang["AutoSurvey_TEXT"] = "對登入玩家進行公會自動調查"
Lang["AutoSurvey_DESC"] = "每當您登入遊戲時，插件都會進行公會調查。"
Lang["ShowSurveyed_TEXT"] = "在接受調查時顯示"
Lang["ShowSurveyed_DESC"] =  "接受（和回答）調查請求時顯示聊天訊息。"
Lang["ShowResponses_TEXT"] = "進行調查時顯示答覆"
Lang["ShowResponses_DESC"] = "顯示每隔調查響應的聊天消訊息。"
Lang["ShowSetMessages_TEXT"] = "顯示步驟完成訊息"
Lang["ShowSetMessages_DESC"] = "當步調完成時，顯示聊天訊息。"
Lang["AnnounceToGuild_TEXT"] = "在公會聊天中宣布完成"
Lang["AnnounceToGuild_DESC"] = "開門任務完成後發送公會訊息。"
Lang["ShowOther_TEXT"] = "顯示其他聊天訊息"
Lang["ShowOther_DESC"] = "顯示所有其他常規聊天訊息（啟動訊息，發送調查，可用更新等）。"
Lang["ShowGuildies_TEXT"] = "在每個使用權步驟中顯示公會成員列表。               最大清單大小"  --this has a gap for the editbox
Lang["ShowGuildies_DESC"] = "當前在使用權步驟中的公會成員列表顯示在步驟工具提示中。\n如有必要，請調整要在每個調整步驟中列出的最大結果數。"
Lang["ShowAltsInstead_TEXT"] = "顯示備用角色，而不是公會成員"
Lang["ShowAltsInstead_DESC"] = "步驟工具提示將顯示您當前在該使用權步驟中的所有備用角色，而不是公會成員。"
Lang["ClearAll_TEXT"] = "刪除所有結果"
Lang["ClearAll_DESC"] = "刪除所有收集的有關其他玩家的訊息。"
Lang["ClearAll_CONF"] = "真的要刪除所有結果嗎？"
Lang["ClearAll_DONE"] = "所有結果已刪除。"
Lang["DelNonGuildies_TEXT"] = "刪除非公會成員"
Lang["DelNonGuildies_DESC"] = "從公會外部刪除所有有關玩家的信息。"
Lang["DelNonGuildies_CONF"] = "真的刪除所有非公會會員嗎？"
Lang["DelNonGuildies_DONE"] = "公會以外的所有結果均已刪除。"
Lang["DelUnder60_TEXT"] = "刪除60等以下的角色"
Lang["DelUnder60_DESC"] = "刪除所有收集的有關60級以下玩家的信息。"
Lang["DelUnder60_CONF"] = "真的要刪除60級以下的所有角色嗎？"
Lang["DelUnder60_DONE"] = "所有低於60的角色均已刪除。"
Lang["DelUnder70_TEXT"] = "刪除70等以下的角色"
Lang["DelUnder70_DESC"] = "刪除所有收集的有關70級以下玩家的信息。"
Lang["DelUnder70_CONF"] = "真的要刪除70級以下的所有角色嗎？"
Lang["DelUnder70_DONE"] = "所有低於70的角色均已刪除。"


-- TREEVIEW
Lang["World of Warcraft"] = "魔獸世界"
Lang["The Burning Crusade"] = "燃燒的遠征"
Lang["Molten Core"] = "熔火之心"
Lang["Onyxia's Lair"] = "奧妮克希亞的巢穴"
Lang["Blackwing Lair"] = "黑翼之巢"
Lang["Naxxramas"] = "納克薩馬斯"
Lang["Scepter of the Shifting Sands"] = "流沙節杖"
Lang["Shadow Labyrinth"] = "暗影迷宮"
Lang["The Shattered Halls"] = "破碎大廳"
Lang["The Arcatraz"] = "亞克崔茲"
Lang["The Black Morass"] = "黑色沼澤"
Lang["Thrallmar Heroics"] = "索爾瑪英雄"
Lang["Honor Hold Heroics"] = "榮譽堡英雄"
Lang["Cenarion Expedition Heroics"] = "塞納里奧遠征隊英雄"
Lang["Lower City Heroics"] = "陰鬱城英雄"
Lang["Sha'tar Heroics"] = "薩塔英雄"
Lang["Keepers of Time Heroics"] = "時光守望者英雄"
Lang["Nightbane"] = "夜禍"
Lang["Karazhan"] = "卡拉贊"
Lang["Serpentshrine Cavern"] = "毒蛇神殿"
Lang["The Eye"] = "風暴要塞"
Lang["Mount Hyjal"] = "海加爾山"
Lang["Black Temple"] = "黑暗神廟"
Lang["MC_Desc"] = "團隊中的所有成員都必須完成該任務，才能進入該副本，除非他們通過黑石深淵進入。" 
Lang["Ony_Desc"] = "團隊中的所有成員都必須在其背包中攜帶龍火護符，才能進入該副本。"
Lang["BWL_Desc"] = "團隊中的所有成員都必須完成該任務，才能進入該副本，除非他們從黑石塔上層進入。"
Lang["All_Desc"] = "團隊中的所有成員都必須完成該任務，才能進入該副本"
Lang["AQ_Desc"] = "每個伺服器只要有一個人完成此任務，就能打開安琪拉之門。"
Lang["OnlyOne_Desc"] = "隊伍中只需要有一個人擁有此鑰匙。350開鎖技能的盜賊也可以打開大門。"
Lang["Heroic_Desc"] = "隊伍中地所有成員都需要聲望和鑰匙，才能進入英雄難度的副本。"
Lang["NB_Desc"] = "團隊中需要有一名成員擁有黑色骨灰才能招喚夜禍。"
Lang["BT_Desc"] = "團隊中的所有成員都必須擁有卡拉伯爾勳章，才能進入該團隊副本。"
Lang["BM_Desc"] = "團隊中的所有成員都需要完成任務鏈才能劃分到團隊副本中。" 
--v250
Lang["Aqual Quintessence"] = "水之精萃"
Lang["MC2_Desc"] = "用於召喚 管理者埃克索图斯。 除了兩個以外，熔火之心中的每個 Boss 都在地面上有符文，需要將其澆灌以使 管理者埃克索图斯 生成。" 


-- GENERIC
Lang["Reach level"] = "達到等級"
Lang["Attuned"] = "完成"
Lang["Not attuned"] = "未完成"
Lang["AttuneColors"] = "藍色: 完成\n红色:未完成"
Lang["Minimum Level"] = "接取任務的最低等級。"
Lang["NPC Not Found"] = "找不到NPC訊息"
Lang["Level"] = "等級"
Lang["Exalted with"] = "崇拜"
Lang["Revered with"] = "崇敬"
Lang["Honored with"] = "尊敬"
Lang["Friendly with"] = "友好"
Lang["Neutral with"] = "中立"
Lang["Quest"] = "任務"
Lang["Pick Up"] = "拾取"
Lang["Inside"] = "副本內"
Lang["Inside the dungeon"] = "在副本內"
Lang["Turn In"] = "上繳"
Lang["Kill"] = "擊殺"
Lang["Interact"] = "互動"
Lang["Item"] = "物品"
Lang["Required level"] = "所需等級"
Lang["Requires level"] = "需要等級"
Lang["Attunement or key"] = "開門任務或鑰匙"
Lang["Reputation"] = "聲望"
Lang["in"] = "進入"
Lang["Unknown Reputation"] = "未知聲望"
Lang["Current progress"] = "當前進度"
Lang["Completion"] = "完成時間"
Lang["Quest information not found"] = "找不到任務訊息"
Lang["Information not found"] = "找不到訊息"
Lang["Solo quest"] = "單人任務"
Lang["Party quest"] = "隊伍任務 (##NB##-man)"
Lang["Raid quest"] = "團隊任務   (##NB##-man)"
Lang["HEROIC"] = "英雄"
Lang["Elite"] = "精英"
Lang["Boss"] = "首領"
Lang["Rare Elite"] = "稀有精英"
Lang["Dragonkin"] = "龍類"
Lang["Troll"] = "食人妖"
Lang["Ogre"] = "巨魔"
Lang["Orc"] = "獸人"
Lang["Half-Orc"] = "半獸人"
Lang["Dragonkin (in Blood Elf form)"] = "龍類（血精靈型態）"
Lang["Human"] = "人類"
Lang["Dwarf"] = "矮人"
Lang["Mechanical"] = "機械"
Lang["Arakkoa"] = "阿拉卡"
Lang["Dragonkin (in Humanoid form)"] = "龍類（人形態）"
Lang["Ethereal"] = "乙太"
Lang["Blood Elf"] = "血精靈"
Lang["Elemental"] = "元素"
Lang["Shiny thingy"] = "閃亮的東東"
Lang["Naga"] = "納迦"
Lang["Demon"] = "惡魔"
Lang["Gronn"] = "戈隆"
Lang["Undead (in Dragon form)"] = "不死族（龍型態）"
Lang["Tauren"] = "牛頭人"
Lang["Qiraji"] = "其拉蟲族"
Lang["Gnome"] = "地精"
Lang["Broken"] = "破碎者"
Lang["Draenei"] = "德萊尼"
Lang["Undead"] = "不死族"
Lang["Gorilla"] = "猩猩"
Lang["Shark"] = "鯊魚"
Lang["Chimaera"] = "奇美拉"
Lang["Wisp"] = "幽光"
Lang["Night-Elf"] = "夜精靈"


-- REP
Lang["Argent Dawn"] = "銀色黎明"
Lang["Brood of Nozdormu"] = "諾茲多姆的子嗣"
Lang["Thrallmar"] = "索爾瑪"
Lang["Honor Hold"] = "榮譽堡"
Lang["Cenarion Expedition"] = "塞納里奧遠征隊"
Lang["Lower City"] = "陰鬱城"
Lang["The Sha'tar"] = "薩塔"
Lang["Keepers of Time"] = "時光守望者"
Lang["The Violet Eye"] = "紫羅蘭之眼"
Lang["The Aldor"] = "奧爾多"
Lang["The Scryers"] = "占卜者"


-- LOCATIONS
Lang["Blackrock Mountain"] = "黑石山"
Lang["Blackrock Depths"] = "黑石深淵"
Lang["Badlands"] = "荒蕪之地"
Lang["Lower Blackrock Spire"] = "黑石塔下層"
Lang["Upper Blackrock Spire"] = "黑石塔上層"
Lang["Orgrimmar"] = "奧格瑪"
Lang["Western Plaguelands"] = "西瘟疫之地"
Lang["Desolace"] = "淒涼之地"
Lang["Dustwallow Marsh"] = "塵泥沼澤"
Lang["Tanaris"] = "塔納利斯"
Lang["Winterspring"] = "冬泉谷"
Lang["Swamp of Sorrows"] = "悲傷沼澤"
Lang["Wetlands"] = "濕地"
Lang["Burning Steppes"] = "燃燒平原"
Lang["Redridge Mountains"] = "赤脊山"
Lang["Stormwind City"] = "暴風城"
Lang["Eastern Plaguelands"] = "東瘟疫之地"
Lang["Silithus"] = "希利蘇斯"
Lang["The Temple of Atal'Hakkar"] = "阿塔哈卡神廟"
Lang["Teldrassil"] = "泰達希爾"
Lang["Moonglade"] = "月光林地"
Lang["Hinterlands"] = "辛特蘭"
Lang["Ashenvale"] = "梣谷"
Lang["Feralas"] = "菲拉斯"
Lang["Duskwood"] = "暮色森林"
Lang["Azshara"] = "艾薩拉"
Lang["Blasted Lands"] = "詛咒之地"
Lang["Undercity"] = "幽暗城"
Lang["Silverpine Forest"] = "銀松森林"
Lang["Shadowmoon Valley"] = "影月谷"
Lang["Hellfire Peninsula"] = "地獄火半島"
Lang["Sethekk Halls"] = "塞司克大廳"
Lang["Caverns Of Time"] = "時光之穴"
Lang["Netherstorm"] = "虛空風暴"
Lang["Shattrath City"] = "撒塔斯城"
Lang["The Mechanaar"] = "麥克納爾"
Lang["The Botanica"] = "波塔尼卡"
Lang["Zangarmarsh"] = "贊格沼澤"
Lang["Terokkar Forest"] = "泰洛卡森林"
Lang["Deadwind Pass"] = "逆風小徑"
Lang["Alterac Mountains"] = "奧特蘭克山脈"
Lang["The Steamvault"] = "蒸氣洞窟"
Lang["Slave Pens"] = "奴隸監獄"
Lang["Gruul's Lair"] = "戈魯爾的巢穴"
Lang["Magtheridon's Lair"] = "瑪瑟里頓的巢穴"
Lang["Zul'Aman"] = "祖阿曼"
Lang["Sunwell Plateau"] = "太陽之井高地"



-- ITEMS
Lang["Drakkisath's Brand"] = "達基薩斯的烙印"
Lang["Crystalline Tear"] = "水晶之淚"
Lang["I_18412"] = "熔核碎片"			-- https://cn.tbc.wowhead.com/?item=18412
Lang["I_12562"] = "重要的黑石文件"			-- https://cn.tbc.wowhead.com/?item=12562
Lang["I_16786"] = "黑色龍人的眼球"			-- https://cn.tbc.wowhead.com/?item=16786
Lang["I_11446"] = "弄皺的便箋"			-- https://cn.tbc.wowhead.com/?item=11446
Lang["I_11465"] = "溫德索爾元帥遺失的情報"			-- https://cn.tbc.wowhead.com/?item=11465
Lang["I_11464"] = "溫德索爾元帥遺失的情報"			-- https://cn.tbc.wowhead.com/?item=11464
Lang["I_18987"] = "黑手的命令"			-- https://cn.tbc.wowhead.com/?item=18987
Lang["I_20383"] = "勒西雷爾的頭顱"			-- https://cn.tbc.wowhead.com/?item=20383
Lang["I_21138"] = "紅色節杖碎片"			-- https://cn.tbc.wowhead.com/?item=21138
Lang["I_21146"] = "腐蝕夢魘的碎片"			-- https://cn.tbc.wowhead.com/?item=21146
Lang["I_21147"] = "腐蝕夢魘的碎片"			-- https://cn.tbc.wowhead.com/?item=21147
Lang["I_21148"] = "腐蝕夢魘的碎片"			-- https://cn.tbc.wowhead.com/?item=21148
Lang["I_21149"] = "腐蝕夢魘的碎片"			-- https://cn.tbc.wowhead.com/?item=21149
Lang["I_21139"] = "綠色節杖碎片"			-- https://cn.tbc.wowhead.com/?item=21139
Lang["I_21103"] = "龍語傻瓜教程"			-- https://cn.tbc.wowhead.com/?item=21103
Lang["I_21104"] = "龍語傻瓜教程"			-- https://cn.tbc.wowhead.com/?item=21104
Lang["I_21105"] = "龍語傻瓜教程"			-- https://cn.tbc.wowhead.com/?item=21105
Lang["I_21106"] = "龍語傻瓜教程"			-- https://cn.tbc.wowhead.com/?item=21106
Lang["I_21107"] = "龍語傻瓜教程"			-- https://cn.tbc.wowhead.com/?item=21107
Lang["I_21108"] = "龍語傻瓜教程"			-- https://cn.tbc.wowhead.com/?item=21108
Lang["I_21109"] = "龍語傻瓜教程"			-- https://cn.tbc.wowhead.com/?item=21109
Lang["I_21110"] = "龍語傻瓜教程"			-- https://cn.tbc.wowhead.com/?item=21110
Lang["I_21111"] = "龍語傻瓜教程：第二卷"			-- https://cn.tbc.wowhead.com/?item=21111
Lang["I_21027"] = "拉克麥拉的屍體"			-- https://cn.tbc.wowhead.com/?item=21027
Lang["I_21024"] = "奇美洛克的腰肋肉"			-- https://cn.tbc.wowhead.com/?item=21024
Lang["I_20951"] = "納里安的占卜眼鏡"			-- https://cn.tbc.wowhead.com/?item=20951
Lang["I_21137"] = "藍色節杖碎片"			-- https://cn.tbc.wowhead.com/?item=21137
Lang["I_21175"] = "流沙節杖"			-- https://cn.tbc.wowhead.com/?item=21175
Lang["I_31241"] = "原始鑰匙模子"			-- https://cn.tbc.wowhead.com/?item=31241
Lang["I_31239"] = "原始鑰匙模子"			-- https://cn.tbc.wowhead.com/?item=31239
Lang["I_27991"] = "暗影迷宫鑰匙"			-- https://cn.tbc.wowhead.com/?item=27991
Lang["I_31086"] = "亞克崔茲鑰匙的底部裂片"			-- https://cn.tbc.wowhead.com/?item=31086
Lang["I_31085"] = "亞克崔茲鑰匙的頂部裂片"			-- https://cn.tbc.wowhead.com/?item=31085
Lang["I_31084"] = "亞克崔茲鑰匙"			-- https://cn.tbc.wowhead.com/?item=31084
Lang["I_30637"] = "火鑄之鑰"			-- https://cn.tbc.wowhead.com/?item=30637
Lang["I_30622"] = "火鑄之鑰"			-- https://cn.tbc.wowhead.com/?item=30622
Lang["I_30623"] = "蓄湖之鑰"			-- https://cn.tbc.wowhead.com/?item=30623
Lang["I_30633"] = "奧奇奈鑰匙"			-- https://cn.tbc.wowhead.com/?item=30633
Lang["I_30634"] = "扭曲鍛造鑰匙"			-- https://cn.tbc.wowhead.com/?item=30634
Lang["I_30635"] = "時光之鑰"			-- https://cn.tbc.wowhead.com/?item=30635
Lang["I_185686"] = "火鑄之鑰"			-- https://cn.tbc.wowhead.com/?item=30637
Lang["I_185687"] = "火鑄之鑰"			-- https://cn.tbc.wowhead.com/?item=30622
Lang["I_185690"] = "蓄湖之鑰"			-- https://cn.tbc.wowhead.com/?item=30623
Lang["I_185691"] = "奧奇奈鑰匙"			-- https://cn.tbc.wowhead.com/?item=30633
Lang["I_185692"] = "扭曲鍛造鑰匙"			-- https://cn.tbc.wowhead.com/?item=30634
Lang["I_185693"] = "時光之鑰"			-- https://cn.tbc.wowhead.com/?item=30635
Lang["I_24514"] = "第一塊鑰匙碎片"			-- https://cn.tbc.wowhead.com/?item=24514
Lang["I_24487"] = "第二塊鑰匙碎片"			-- https://cn.tbc.wowhead.com/?item=24487
Lang["I_24488"] = "第三塊鑰匙碎片"			-- https://cn.tbc.wowhead.com/?item=24488
Lang["I_24490"] = "麥迪文的鑰匙"			-- https://cn.tbc.wowhead.com/?item=24490
Lang["I_23933"] = "麥迪文的日記"			-- https://cn.tbc.wowhead.com/?item=23933
Lang["I_25462"] = "黑暗之書"			-- https://cn.tbc.wowhead.com/?item=25462
Lang["I_25461"] = "遺忘之名魔典"			-- https://cn.tbc.wowhead.com/?item=25461
Lang["I_24140"] = "燻黑的骨灰甕"			-- https://cn.tbc.wowhead.com/?item=24140
Lang["I_31750"] = "土靈徽記"			-- https://cn.tbc.wowhead.com/?item=31750
Lang["I_31751"] = "熾亮徽記"			-- https://cn.tbc.wowhead.com/?item=31751
Lang["I_31716"] = "劊子手的廢棄之斧"			-- https://cn.tbc.wowhead.com/?item=31716
Lang["I_31721"] = "卡利斯瑞的三叉戟"			-- https://cn.tbc.wowhead.com/?item=31721
Lang["I_31722"] = "莫爾墨的精華"			-- https://cn.tbc.wowhead.com/?item=31722
Lang["I_31704"] = "風暴鑰匙"			-- https://cn.tbc.wowhead.com/?item=31704
Lang["I_29905"] = "凱爾薩斯的殘存之瓶"			-- https://cn.tbc.wowhead.com/?item=29905
Lang["I_29906"] = "瓦許的殘存之瓶"			-- https://cn.tbc.wowhead.com/?item=29906
Lang["I_31307"] = "狂怒之心"			-- https://cn.tbc.wowhead.com/?item=31307
Lang["I_32649"] = "卡拉伯爾勳章"			-- https://cn.tbc.wowhead.com/?item=32649
--v247
Lang["Shrine of Thaurissan"] = "索瑞森神殿"
Lang["I_14610"] = "阿拉基的圣甲虫"
--v250
Lang["I_17332"] = "沙斯拉爾之手"
Lang["I_17329"] = "魯西弗隆之手"
Lang["I_17331"] = "基赫納斯之手"
Lang["I_17330"] = "薩弗隆之手"
Lang["I_17333"] = "水之精萃"
-- Wailing Caverns
Lang["I_5334"] = "99年波爾多陳釀"
Lang["I_5339"] = "毒蛇花"
Lang["I_6443"] = "變異皮革"
Lang["I_6464"] = "哀嚎香精"
-- Shadowfang Keep
Lang["I_5442"] = "阿魯高的頭顱"
Lang["I_5535"] = "墮落者綱要"
Lang["I_5536"] = "泰坦神話"
Lang["I_5538"] = "沃瑞爾的結婚戒指"
Lang["I_5805"] = "狂熱之心"
Lang["I_5861"] = "亡靈的起源"
Lang["I_6283"] = "烏爾之書"
-- Blackfathom Deeps
Lang["I_5359"] = "洛迦里斯手稿"
Lang["I_5952"] = "墮落者的腦幹"
Lang["I_5879"] = "暮光墜飾"
Lang["I_5881"] = "克爾里斯的頭顱"
Lang["I_16762"] = "深淵之核"
Lang["I_16784"] = "阿庫麥爾藍寶石"
Lang["I_16790"] = "潮濕的便箋"
-- Gnomeregan
Lang["I_9278"] = "基礎模組"
Lang["I_9309"] = "機械內膽"
Lang["I_9284"] = "裝滿的鉛瓶"
Lang["I_9277"] = "尖端機器人的記憶體核心"
Lang["I_9153"] = "鑽探設備藍圖"
Lang["I_9299"] = "機電師的保險箱密碼"
-- Razorfen Kraul
Lang["I_5801"] = "沼澤蝙蝠的糞便"
Lang["I_5825"] = "塔莎拉的墜飾"
Lang["I_5793"] = "卡爾加·刺肋的心臟"
Lang["I_5792"] = "卡爾加·刺肋的徽章"
Lang["I_5876"] = "藍葉薯"


-- QUESTS - Classic
Lang["Q1_7848"] = "熔火之心的傳送門"			-- https://cn.tbc.wowhead.com/?quest=7848
Lang["Q2_7848"] = "進入黑石深淵，在通往熔火之心的傳送門附近找到一塊熔核碎片，然後回到黑石山的洛索斯·天痕那裡。"
Lang["Q1_4903"] = "高圖斯的命令"			-- https://cn.tbc.wowhead.com/?quest=4903
Lang["Q2_4903"] = "殺死歐莫克大王、將領沃恩和維姆薩拉克主宰。找到重要的黑石文件，然後向卡加斯的督軍高圖斯彙報。"
Lang["Q1_4941"] = "伊崔格的智慧"			-- https://cn.tbc.wowhead.com/?quest=4941
Lang["Q2_4941"] = "和奧格瑪的伊崔格談一談。討論完畢後，諮詢索爾的意見。\n\n你回憶起曾在索爾的大廳中見過伊崔格。"
Lang["Q1_4974"] = "為部落而戰！"			-- https://cn.tbc.wowhead.com/?quest=4974
Lang["Q2_4974"] = "去黑石塔殺死大酋長雷德·黑手，帶著他的頭顱返回奧格瑪。"
Lang["Q1_6566"] = "風吹來的消息"			-- https://cn.tbc.wowhead.com/?quest=6566
Lang["Q2_6566"] = "聽索爾講話。"
Lang["Q1_6567"] = "部落的勇士"			-- https://cn.tbc.wowhead.com/?quest=6567
Lang["Q2_6567"] = "按照酋長的指示找到雷克薩。他在石爪山脈和菲拉斯之間的淒涼之地遊蕩。"
Lang["Q1_6568"] = "雷克薩的證明"			-- https://cn.tbc.wowhead.com/?quest=6568
Lang["Q2_6568"] = "把雷克薩的證明交给西瘟疫之地的巫女米蘭達。"
Lang["Q1_6569"] = "黑龍幻象"			-- https://cn.tbc.wowhead.com/?quest=6569
Lang["Q2_6569"] = "到黑石塔去收集20顆黑色龍人的眼球，完成任務之後回到巫女米蘭達那裡。"
Lang["Q1_6570"] = "埃博斯塔夫"			-- https://cn.tbc.wowhead.com/?quest=6570
Lang["Q2_6570"] = "到塵泥沼澤中的巨龍沼澤去，找到埃博斯塔夫的洞穴。進入洞穴之後戴上龍形護符，然後跟埃博斯塔夫交談。"
Lang["Q1_6584"] = "龍骨試煉，克鲁纳里斯"			-- https://cn.tbc.wowhead.com/?quest=6584
Lang["Q2_6584"] = "諾茲多姆的孩子克魯納裡斯在塔納利斯沙漠守衛著時光之穴。殺了他，把他的顱骨交給埃博斯塔夫。"
Lang["Q1_6582"] = "龍骨試煉，斯克利爾"			-- https://cn.tbc.wowhead.com/?quest=6582
Lang["Q2_6582"] = "找到藍龍斯克利爾並殺掉他。從他的身上取下他的顱骨，然後將其交給埃博斯塔夫。"
Lang["Q1_6583"] = "龍骨試煉，索姆努斯"			-- https://cn.tbc.wowhead.com/?quest=6583
Lang["Q2_6583"] = "殺掉綠龍索姆努斯，把他的顱骨交給埃博斯塔夫。"
Lang["Q1_6585"] = "龍骨試煉，埃克托兹"			-- https://cn.tbc.wowhead.com/?quest=6585
Lang["Q2_6585"] = "到格瑞姆巴托去殺掉紅龍埃克托兹，把他的顱骨交給埃博斯塔夫。"
Lang["Q1_6601"] = "晉升……"			-- https://cn.tbc.wowhead.com/?quest=6601
Lang["Q2_6601"] = "看來這場假面舞會就要結束了。你知道米蘭達為你製作的龍形護符在黑石塔裡面不會發揮作用，也許你應該去找雷克薩，將你的困境告訴他。把黯淡的龍火護符給他看看，也許他知道下一步該怎麼做。"
Lang["Q1_6602"] = "黑龍勇士之血"			-- https://cn.tbc.wowhead.com/?quest=6602
Lang["Q2_6602"] = "到黑石塔去殺掉達基薩斯將軍，把它的血交給雷克薩。"
Lang["Q1_4182"] = "黑龍的威脅"			-- https://cn.tbc.wowhead.com/?quest=4182
Lang["Q2_4182"] = "殺掉15條黑色小龍、10條黑色龍人、4條火鱗龍人和1條黑色幼龍。"
Lang["Q1_4183"] = "真正的主人"			-- https://cn.tbc.wowhead.com/?quest=4183
Lang["Q2_4183"] = "把赫林迪斯·河角的信交给赤脊山湖畔鎮的索羅門鎮長。"
Lang["Q1_4184"] = "真正的主人"			-- https://cn.tbc.wowhead.com/?quest=4184
Lang["Q2_4184"] = "到暴風成去把索羅門的求援信交给伯瓦爾·弗塔根公爵。\n\n伯瓦爾在暴風要塞裡。"
Lang["Q1_4185"] = "真正的主人"			-- https://cn.tbc.wowhead.com/?quest=4185
Lang["Q2_4185"] = "與女伯爵卡特拉娜·普瑞斯托談話，然後再與伯瓦爾·弗塔根公爵談話。"
Lang["Q1_4186"] = "真正的主人"			-- https://cn.tbc.wowhead.com/?quest=4186
Lang["Q2_4186"] = "把伯瓦爾的命令交给湖畔鎮的索羅門鎮長。"
Lang["Q1_4223"] = "真正的主人"			-- https://cn.tbc.wowhead.com/?quest=4223
Lang["Q2_4223"] = "和燃燒平原的麥克斯爾元帥談一談。"
Lang["Q1_4224"] = "真正的主人"			-- https://cn.tbc.wowhead.com/?quest=4224
Lang["Q2_4224"] = "和狼狽不堪的約翰談談來了解溫德索爾元帥的命運，然後回到麥克斯爾元帥那裡。\n\n你想起麥克斯爾元帥說過他在一個北面的洞穴那裡。"
Lang["Q1_4241"] = "溫德索爾元帥"			-- https://cn.tbc.wowhead.com/?quest=4241
Lang["Q2_4241"] = "到西北部的黑石山脈去，在黑石深淵中找到溫德索爾元帥的下落。\n\n狼狽不堪的約翰曾告訴你說溫德索爾被關進了一個監獄。"
Lang["Q1_4242"] = "被遺棄的希望"			-- https://cn.tbc.wowhead.com/?quest=4242
Lang["Q2_4242"] = "把這個壞消息傳達給麥克斯爾元帥。"
Lang["Q1_4264"] = "弄皺的便箋"			-- https://cn.tbc.wowhead.com/?quest=4264
Lang["Q2_4264"] = "溫德索爾元帥也許會對你手中的東西感興趣。畢竟，希望還沒有被完全扼殺。"
Lang["Q1_4282"] = "一絲希望"			-- https://cn.tbc.wowhead.com/?quest=4282
Lang["Q2_4282"] = "找回溫德索爾元帥遺失的情報。\n\n溫德索爾元帥確信那些情報在安格佛將軍和魔像領主阿格曼奇的手裡。"
Lang["Q1_4322"] = "衝破牢籠！"			-- https://cn.tbc.wowhead.com/?quest=4322
Lang["Q2_4322"] = "幫助溫德索爾元帥拿回他的裝備並救出他的朋友。當你成功之後就回去向麥克斯爾元帥覆命。"
Lang["Q1_6402"] = "集合在暴風成"			-- https://cn.tbc.wowhead.com/?quest=6402
Lang["Q2_6402"] = "前往暴風城的城門。與侍衛洛文交談，他會通知溫德索爾元帥你已經到達了。"
Lang["Q1_6403"] = "潛藏者"			-- https://cn.tbc.wowhead.com/?quest=6403
Lang["Q2_6403"] = "跟隨雷吉納德·溫德索爾元帥在暴風城中前進。保護他，別讓他受到傷害！"
Lang["Q1_6501"] = "巨龍之眼"			-- https://cn.tbc.wowhead.com/?quest=6501
Lang["Q2_6501"] = "你必須尋遍世界以找到一種能恢復龍眼碎片的能量的生物。你對這種生物的唯一了解就是：他們確實存在。"
Lang["Q1_6502"] = "龍火護符"			-- https://cn.tbc.wowhead.com/?quest=6502
Lang["Q2_6502"] = "你必須從達基薩斯將軍身上取回黑龍勇士之血，你可以在黑石塔的晋升大廳後面的房間裡找到他。"
Lang["Q1_7761"] = "黑手的命令"			-- https://cn.tbc.wowhead.com/?quest=7761
Lang["Q2_7761"] = "真是個愚蠢的獸人。看來你需要找到那枚烙印並獲得達基薩斯徽記才可以使用命令寶珠。\n\n你從信中獲知，達基薩斯將軍守衛著烙印。也許你應該就此進行更深入的調查。"
Lang["Q1_9121"] = "驚懼城塞，納克薩瑪斯"			-- https://cn.tbc.wowhead.com/?quest=9121
Lang["Q2_9121"] = "東瘟疫之地聖光之願禮拜堂的大法師安琪拉·多桑杜需要5個秘法水晶，2個聯結水晶，1個正義寶珠和60金。你一定要在銀色黎明達到尊敬聲望。"
Lang["Q1_9122"] = "驚懼城塞，納克薩瑪斯"			-- https://cn.tbc.wowhead.com/?quest=9122
Lang["Q2_9122"] = "東瘟疫之地聖光之願禮拜堂的大法師安琪拉·多桑杜需要2個秘法水晶、1個聯結水晶和30金。你在銀色黎明中的聲望必須達到崇敬。"
Lang["Q1_9123"] = "驚懼城塞，納克薩瑪斯"			-- https://cn.tbc.wowhead.com/?quest=9123
Lang["Q2_9123"] = "東瘟疫之地聖光之願禮拜堂的大法師安琪拉·多桑杜會免費為你施放奧術遮罩的咒語。你在銀色黎明中的聲望必須達到崇拜。"
Lang["Q1_8286"] = "明天的希望"			-- https://cn.tbc.wowhead.com/?quest=8286
Lang["Q2_8286"] = "到塔納利斯的時光之穴尋找諾茲多姆的子嗣安納克羅斯。"
Lang["Q1_8288"] = "唯一的領袖"			-- https://cn.tbc.wowhead.com/?quest=8288
Lang["Q2_8288"] = "到黑石山中的黑翼之巢去，殺死勒西雷爾，並帶回他的頭顱。\n\n將勒西雷爾的頭顱交给希利蘇斯塞納裡奧城堡的流沙守望者巴里斯托爾斯。"
Lang["Q1_8301"] = "正義之路"			-- https://cn.tbc.wowhead.com/?quest=8301
Lang["Q2_8301"] = "為流沙守望者巴里斯托爾斯收集200塊異種蠍殼碎片。"
Lang["Q1_8303"] = "阿納克洛斯"			-- https://cn.tbc.wowhead.com/?quest=8303
Lang["Q2_8303"] = "到塔納利斯的時光之穴去尋找阿納克洛斯。"
Lang["Q1_8305"] = "久遠的記憶"			-- https://cn.tbc.wowhead.com/?quest=8305
Lang["Q2_8305"] = "找到希利蘇斯的水晶之淚，並凝視它。"
Lang["Q1_8519"] = "往日的回憶"			-- https://cn.tbc.wowhead.com/?quest=8519
Lang["Q2_8519"] = "了解所有可以了解的關於的過去的事情，然後和塔納利斯時光之穴的阿納克洛斯談談。"
Lang["Q1_8555"] = "守護之龍"			-- https://cn.tbc.wowhead.com/?quest=8555
Lang["Q2_8555"] = "伊蘭尼庫斯、瓦拉斯塔兹、和艾索雷葛斯……你的確知道這些龍，凡人。這不是巧合，他們看守我們的世界，扮演著如此有影響力的角色。\n\n不幸的是(有部份也要怪我涉世未深)不論是上古諸神的密探或者稱他們為朋友的背叛者，每個首位都淪陷了。其程度只加深了我對你的種族的不信任。\n\n找到他们……，做好最壞的準備吧。"
Lang["Q1_8730"] = "奈法里奥斯的腐蝕"			-- https://cn.tbc.wowhead.com/?quest=8730
Lang["Q2_8730"] = "殺死奈法利安，並拿到红色節杖碎片。把红色節杖碎片交给塔納利斯時光之穴入口處的阿納克洛斯。你必須在5小時之內完成這個任務。"
Lang["Q1_8733"] = "伊蘭尼庫斯，夢境之暴君"			-- https://cn.tbc.wowhead.com/?quest=8733
Lang["Q2_8733"] = "到達納蘇斯的城牆外去找到瑪法里恩的親信。"
Lang["Q1_8734"] = "泰蘭達和雷姆洛斯"			-- https://cn.tbc.wowhead.com/?quest=8734
Lang["Q2_8734"] = "到月光林地去，和守護者雷姆洛斯談一談。"
Lang["Q1_8735"] = "腐蝕夢魘"			-- https://cn.tbc.wowhead.com/?quest=8735
Lang["Q2_8735"] = "到艾澤拉斯世界的四個翡翠夢境入口去，分别收集該處的腐蝕夢魘的碎片。當你任務完成之後，就回到月光林地的守護者雷姆洛斯那裡。"
Lang["Q1_8736"] = "噩夢顯現"			-- https://cn.tbc.wowhead.com/?quest=8736
Lang["Q2_8736"] = "保護永夜港免受伊蘭尼庫斯的傷害。不要讓守護者雷姆洛斯死亡。不要殺掉伊蘭尼庫斯。保護好你們自己。等待泰蘭達。"
Lang["Q1_8741"] = "勇士歸來"			-- https://cn.tbc.wowhead.com/?quest=8741
Lang["Q2_8741"] = "把綠色節杖碎片交给塔納利斯時光之穴的阿納克洛斯。"
Lang["Q1_8575"] = "艾索雷葛斯的魔法帳本"			-- https://cn.tbc.wowhead.com/?quest=8575
Lang["Q2_8575"] = "把魔法帳本交给塔納利斯的納瑞安。"
Lang["Q1_8576"] = "翻譯龍語"			-- https://cn.tbc.wowhead.com/?quest=8576
Lang["Q2_8576"] = "先處理當務之急，我們必須搞清楚艾索雷葛斯到底在石板上寫了什麽。\n\n你說它叫你做一個奧金浮標而這只是個概要圖嗎?可是他會用龍語寫還真奇怪。那個討厭的老傢伙知道我看不懂這亂七八糟的文字。\n\n如果有用的話，我需要我的水晶球護目鏡，一隻500磅的雞和〝龍語傻瓜教程〞第二卷。不需要按照順序。"
Lang["Q1_8597"] = "龍語傻瓜教程"			-- https://cn.tbc.wowhead.com/?quest=8597
Lang["Q2_8597"] = "尋找納瑞安埋在南海的某座小島上的書。"
Lang["Q1_8599"] = "唱给納瑞安的情歌"			-- https://cn.tbc.wowhead.com/?quest=8599
Lang["Q2_8599"] = "把米莉蒂私的情書交给塔納利斯的納瑞安。"
Lang["Q1_8598"] = "敲詐"			-- https://cn.tbc.wowhead.com/?quest=8598
Lang["Q2_8598"] = "把勒索信交给塔納利斯的納瑞安。"
Lang["Q1_8606"] = "螳螂捕蟬！"			-- https://cn.tbc.wowhead.com/?quest=8606
Lang["Q2_8606"] = "塔納利斯的納瑞安要你去冬泉谷，把一袋金子放在绑匪的勒索信上所寫的位置。他還要求你教訓一下那些傢伙！"
Lang["Q1_8620"] = "唯一的方案"			-- https://cn.tbc.wowhead.com/?quest=8620
Lang["Q2_8620"] = "把8章《龍語傻瓜教程》的章節用魔法書封面合起来，然後把完整的《龍語傻瓜教程：第二卷》交给塔納利斯的納瑞安。"
Lang["Q1_8584"] = "少管閒事"			-- https://cn.tbc.wowhead.com/?quest=8584
Lang["Q2_8584"] = "塔納利斯的納瑞安讓你和加基森的迪爾格·奎克里弗談一談。"
Lang["Q1_8585"] = "恐怖之島！"			-- https://cn.tbc.wowhead.com/?quest=8585
Lang["Q2_8585"] = "加基森的迪爾格·奎克里弗要你去菲拉斯的恐怖之島擊殺拉克麥拉，獲得拉克麥拉的屍體，並從島上收集20份奇美洛克的腰肋肉。"
Lang["Q1_8586"] = "迪爾格的超美味奇美拉肉片"			-- https://cn.tbc.wowhead.com/?quest=8586
Lang["Q2_8586"] = "加基森的迪爾格·奎克里弗要你給他帶去20份地精火箭燃油和20份石中鹽。"
Lang["Q1_8587"] = "向納瑞安回覆"			-- https://cn.tbc.wowhead.com/?quest=8587
Lang["Q2_8587"] = "把500磅的小雞交给塔納利斯的納瑞安。"
Lang["Q1_8577"] = "斯圖沃爾，前任死黨"			-- https://cn.tbc.wowhead.com/?quest=8577
Lang["Q2_8577"] = "納瑞安要你找到他的前任死黨斯圖沃爾，從他那裡拿回從納瑞安那裡偷走的占卜眼鏡。"
Lang["Q1_8578"] = "占卜眼鏡？沒問題！"			-- https://cn.tbc.wowhead.com/?quest=8578
Lang["Q2_8578"] = "找到納瑞安的占卜眼鏡。"
Lang["Q1_8728"] = "好消息和壞消息"			-- https://cn.tbc.wowhead.com/?quest=8728
Lang["Q2_8728"] = "塔納利斯的納瑞安要你給他帶去20塊奥金錠、10塊原質礦石、10顆艾澤拉斯鑽石，以及10顆藍寶石。"
Lang["Q1_8729"] = "耐普圖洛斯的憤怒"			-- https://cn.tbc.wowhead.com/?quest=8729
Lang["Q2_8729"] = "在艾薩拉風暴海灣一帶的湍急的漩渦處使用奥金魚標。"
Lang["Q1_8742"] = "卡利姆多的力量"			-- https://cn.tbc.wowhead.com/?quest=8742
Lang["Q2_8742"] = "一千年過去了，正如命中注定的那樣，一位勇士站在了我的面前。這位勇士將會帶領他的人民走向新的紀元。\n\n上古之神在顫抖，是的，它在你堅定的信念面前恐懼地顫抖著。打破克蘇恩的預言吧。\n\它知道你會到來的，勇士―它還知道卡利姆多的力量與你同在。當你做好準備之後，請通知我，我將把流沙節杖賜予你。"
Lang["Q1_8745"] = "時光之王的財寶"			-- https://cn.tbc.wowhead.com/?quest=8745
Lang["Q2_8745"] = "你好，勇士。我是神聖之鑼和青銅龍軍團的永恆觀察者，喬納森。\n\n永恆之王授權我讓你從他永恆的寶物箱裡選擇一樣物品。願它能在你對抗克蘇恩的戰役中幫助你。"


-- QUESTS - TBC
Lang["Q1_10755"] = "進入堡壘"			-- https://cn.tbc.wowhead.com/?quest=10755
Lang["Q2_10755"] = "將原始鑰匙模子帶去給地獄火半島上索爾瑪的納茲格雷爾。"
Lang["Q1_10756"] = "洛赫克大師"			-- https://cn.tbc.wowhead.com/?quest=10756
Lang["Q2_10756"] = "將原始鑰匙模子交給索爾瑪的洛赫克。"
Lang["Q1_10757"] = "洛赫克的請求"			-- https://cn.tbc.wowhead.com/?quest=10757
Lang["Q2_10757"] = "帶4個魔鐵錠，2個魔塵和4個火焰微粒回到地獄火半島的索爾瑪交給洛赫克。"
Lang["Q1_10758"] = "比地獄還熱"			-- https://cn.tbc.wowhead.com/?quest=10758
Lang["Q2_10758"] = "在地獄火半島破壞一部惡魔劫奪者，並且將未淬火的鑰匙模插入它的殘骸裡。將燒焦的鑰匙模型帶到洛赫克給索爾瑪。"
Lang["Q1_10754"] = "進入堡壘"			-- https://cn.tbc.wowhead.com/?quest=10754
Lang["Q2_10754"] = "將原始鑰匙模子帶去給地獄火半島上榮譽堡的軍隊指揮官達納斯。"
Lang["Q1_10762"] = "戴夫利大師"			-- https://cn.tbc.wowhead.com/?quest=10762
Lang["Q2_10762"] = "將原始鑰匙模子交給榮譽堡的戴夫利。"
Lang["Q1_10763"] = "戴夫利的請求"			-- https://cn.tbc.wowhead.com/?quest=10763
Lang["Q2_10763"] = "帶4個魔鐵錠，2個魔塵和4個火焰微粒回到地獄火半島的榮譽堡給戴夫利。"
Lang["Q1_10764"] = "比地獄還熱"			-- https://cn.tbc.wowhead.com/?quest=10764
Lang["Q2_10764"] = "在地獄火半島破壞一部惡魔劫奪者，並且將未淬火的鑰匙模插入它的殘骸裡。將燒焦的鑰匙模型帶到榮譽堡給戴夫利。"
Lang["Q1_10279"] = "前往主人的巢穴"			-- https://cn.tbc.wowhead.com/?quest=10279
Lang["Q2_10279"] = "與時光之穴的安杜姆談談。"
Lang["Q1_10277"] = "時光之穴"			-- https://cn.tbc.wowhead.com/?quest=10277
Lang["Q2_10277"] = "在時光之穴的安杜姆要你跟隨洞穴附近的時間管理人。"
Lang["Q1_10282"] = "舊時的希爾斯布萊德"			-- https://cn.tbc.wowhead.com/?quest=10282
Lang["Q2_10282"] = "時光之穴的安杜姆要你到希爾斯布萊德丘陵去跟伊洛森談談。"
Lang["Q1_10283"] = "塔蕾莎的聲東擊西"			-- https://cn.tbc.wowhead.com/?quest=10283
Lang["Q2_10283"] = "前往敦霍爾德城堡，使用伊洛森交給你的燃燒炸彈包裹，在每一個拘留守衛室裡的桶中放置5個燃燒炸藥。\n\n當你引爆拘留守衛室後，與敦霍爾德城堡地牢裡的索爾談談。"
Lang["Q1_10284"] = "逃離敦霍爾德"			-- https://cn.tbc.wowhead.com/?quest=10284
Lang["Q2_10284"] = "當你準備開始時，讓索爾知道。跟著索爾離開敦霍爾德城堡，並協助他釋放塔蕾莎以及完成他的天命。\n\n任務完成後到希爾斯布萊德找伊洛森談談。"
Lang["Q1_10285"] = "回去安杜姆身邊"			-- https://cn.tbc.wowhead.com/?quest=10285
Lang["Q2_10285"] = "回去塔納利斯沙漠的時光之穴找小孩安杜姆。"
Lang["Q1_10265"] = "聯合團水晶收集"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10265
Lang["Q2_10265"] = "取得阿克隆水晶手工品，並且將它帶回虛空風暴的52區交給虛空巡者凱澤。"
Lang["Q1_10262"] = "一堆以太族"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10262
Lang["Q2_10262"] = "收集10枚薩希斯徽記，並且將它們帶回虛空風暴的52區交給虛空巡者凱澤。"
Lang["Q1_10205"] = "星移劫掠者尼薩德"			-- https://cn.tbc.wowhead.com/?quest=10205
Lang["Q2_10205"] = "殺掉星移劫掠者尼薩德，完成後回到虛空風暴的52區找虛空巡者凱澤。"
Lang["Q1_10266"] = "要求幫助"			-- https://cn.tbc.wowhead.com/?quest=10266
Lang["Q2_10266"] = "尋找並提供加魯你的幫助。他就在虛空風暴的秘境領地裡的領地崗哨。"
Lang["Q1_10267"] = "合法的回收"			-- https://cn.tbc.wowhead.com/?quest=10267
Lang["Q2_10267"] = "收集10箱勘探設備帶回虛空風暴秘境領地的領地崗哨給加魯。"
Lang["Q1_10268"] = "晉見王子"			-- https://cn.tbc.wowhead.com/?quest=10268
Lang["Q2_10268"] = "將勘探設備送到虛空風暴的風暴之尖交給奈薩斯王子哈拉瑪德的影像。"
Lang["Q1_10269"] = "三角測量點之一"			-- https://cn.tbc.wowhead.com/?quest=10269
Lang["Q2_10269"] = "使用三角裝置指引你前往第一個三角測量點的方向。一旦你找到它，把位置報告給虛空風暴法力熔爐奧崔斯島上護國者哨站的商人海辛。"
Lang["Q1_10275"] = "三角測量點之二"			-- https://cn.tbc.wowhead.com/?quest=10275
Lang["Q2_10275"] = "使用三角裝置指引你前往第二個三角測量點的方向。一旦你找到它，將位置報告給在虛空風暴的吐魯曼平臺的風之貿易者吐魯曼，他就在從法力熔爐艾拉島出來的橋的另一邊。"
Lang["Q1_10276"] = "完整三角形"			-- https://cn.tbc.wowhead.com/?quest=10276
Lang["Q2_10276"] = "取回阿塔莫水晶並且將它帶到虛空風暴的風暴之尖交給奈薩斯王子哈拉瑪德的影像。"
Lang["Q1_10280"] = "給撒塔斯城的特件"			-- https://cn.tbc.wowhead.com/?quest=10280
Lang["Q2_10280"] = "將阿塔莫水晶送交到撒塔斯城的聖光露臺交給阿達歐。"
Lang["Q1_10704"] = "闖入亞克崔茲的方法"			-- https://cn.tbc.wowhead.com/?quest=10704
Lang["Q2_10704"] = "阿達歐派你去取得亞克崔茲鑰匙的頂部和底部裂片。將它們帶回去給他，他會將他們合成亞克崔茲鑰匙後交給你。"
Lang["Q1_9824"] = "秘法干擾"			-- https://cn.tbc.wowhead.com/?quest=9824
Lang["Q2_9824"] = "到大師的地窖，在靠近地下水源的地方使用紫羅蘭占卜水晶再回到卡拉贊外面的大法師艾特羅斯那裡。"
Lang["Q1_9825"] = "不安的活動"			-- https://cn.tbc.wowhead.com/?quest=9825
Lang["Q2_9825"] = "帶10個鬼魅精華給卡拉贊外面的大法師艾特羅斯。"
Lang["Q1_9826"] = "達拉然的聯繫"			-- https://cn.tbc.wowhead.com/?quest=9826
Lang["Q2_9826"] = "將艾特羅斯的報告帶給達拉然陷坑郊區的大法師賽卓克。"
Lang["Q1_9829"] = "卡德加"			-- https://cn.tbc.wowhead.com/?quest=9829
Lang["Q2_9829"] = "將艾特羅斯的報告送到泰洛卡森林給撒塔斯城的卡德加。"
Lang["Q1_9831"] = "卡拉贊的入口"			-- https://cn.tbc.wowhead.com/?quest=9831
Lang["Q2_9831"] = "卡德加要你進入奧齊頓的暗影迷宮並從藏在那裡的秘法容器取得第一塊鑰匙碎片。"
Lang["Q1_9832"] = "第二和第三個碎片"			-- https://cn.tbc.wowhead.com/?quest=9832
Lang["Q2_9832"] = "在盤牙蓄湖的秘法容器裡取得第二塊鑰匙碎片，風暴要塞的秘法容器裡取得第三塊鑰匙碎片。完成任務後回到撒塔斯城的卡德加那裡。"
Lang["Q1_9836"] = "大師之觸"			-- https://cn.tbc.wowhead.com/?quest=9836
Lang["Q2_9836"] = "進入時光之穴說服麥迪文讓復原的初生之鑰恢復能力。"
Lang["Q1_9837"] = "回到卡德加那裡"			-- https://cn.tbc.wowhead.com/?quest=9837
Lang["Q2_9837"] = "回到撒塔斯城的卡德加那裡並給他大師之鑰。"
Lang["Q1_9838"] = "紫羅蘭之眼"			-- https://cn.tbc.wowhead.com/?quest=9838
Lang["Q2_9838"] = "和卡拉贊外的大法師艾特羅斯談談。"
Lang["Q1_9630"] = "麥迪文的日記"			-- https://cn.tbc.wowhead.com/?quest=9630
Lang["Q2_9630"] = "逆風小徑的大法師艾特羅斯要你進入卡拉贊並和瑞依恩談談。"
Lang["Q1_9638"] = "妥善保管"			-- https://cn.tbc.wowhead.com/?quest=9638
Lang["Q2_9638"] = "到卡拉贊和守護者圖書館的葛瑞戴談談。"
Lang["Q1_9639"] = "康席斯"			-- https://cn.tbc.wowhead.com/?quest=9639
Lang["Q2_9639"] = "到卡拉贊和守護者圖書館的康席斯談談。"
Lang["Q1_9640"] = "埃蘭之影"			-- https://cn.tbc.wowhead.com/?quest=9640
Lang["Q2_9640"] = "取得麥迪文的日記並帶到卡拉贊的守護者圖書館交給康席斯。"
Lang["Q1_9645"] = "大師的露臺"			-- https://cn.tbc.wowhead.com/?quest=9645
Lang["Q2_9645"] = "前往卡拉贊的大師的露臺並閱讀麥迪文的日記。完成任務後將麥迪文的日記交給大法師艾特羅斯。"
Lang["Q1_9680"] = "挖掘历史"			-- https://cn.tbc.wowhead.com/?quest=9680
Lang["Q2_9680"] = "大法師艾特羅斯要你去卡拉贊南方山脈的逆風小徑取回一個燒焦的白骨碎片。"
Lang["Q1_9631"] = "朋友的協助"			-- https://cn.tbc.wowhead.com/?quest=9631
Lang["Q2_9631"] = "將燒焦的白骨碎片帶給虛空風暴的凱娜·拉斯蕊德。"
Lang["Q1_9637"] = "凱娜的要求"			-- https://cn.tbc.wowhead.com/?quest=9637
Lang["Q2_9637"] = "凱娜·拉斯蕊德要你到地獄火堡壘的破碎大廳，從大術士奈德克斯那裡取得黑暗之書，再到奧齊頓的塞司克大廳，從暗織者希斯那裡取得遺忘之名魔典。這個任務必須在英雄難度中完成。"
Lang["Q1_9644"] = "夜禍"			-- https://cn.tbc.wowhead.com/?quest=9644
Lang["Q2_9644"] = "前往卡拉贊大師的露臺並碰觸燻黑的骨灰甕來召喚夜禍。從夜禍的屍體取得微弱的秘法精華並帶給大法師艾特羅斯。"
Lang["Q1_10901"] = "卡德許的鬥棍"			-- https://cn.tbc.wowhead.com/?quest=10901
Lang["Q2_10901"] = "盤牙蓄湖中奴隸監獄的『異端』司卡利斯要你帶給他土靈徽記和熾烈徽記。"
Lang["Q1_10900"] = "瓦許的印記"			-- https://cn.tbc.wowhead.com/?quest=10900
Lang["Q2_10900"] = ""
Lang["Q1_10681"] = "古爾丹火山"			-- https://cn.tbc.wowhead.com/?quest=10681
Lang["Q2_10681"] = "跟影月谷詛咒祭壇的大地治癒者托爾洛克交談。"
Lang["Q1_10458"] = "火與大地的暴怒之靈"			-- https://cn.tbc.wowhead.com/?quest=10458
Lang["Q2_10458"] = "影月谷裡詛咒祭壇的大地治癒者托爾洛克要你使用靈魂圖騰捕捉8個土靈之魂及8個熾熱之魂"
Lang["Q1_10480"] = "暴怒的水靈"			-- https://cn.tbc.wowhead.com/?quest=10480
Lang["Q2_10480"] = "影月谷的詛咒祭壇的大地治癒者托爾洛克要你使用靈魂圖騰去捕獲5個水之魂。"
Lang["Q1_10481"] = "暴怒的風之靈"			-- https://cn.tbc.wowhead.com/?quest=10481
Lang["Q2_10481"] = "影月谷的詛咒祭壇的大地治癒者托爾洛克要你使用靈魂圖騰去捕獲10個大氣之魂。"
Lang["Q1_10513"] = "歐朗諾克·碎心"			-- https://cn.tbc.wowhead.com/?quest=10513
Lang["Q2_10513"] = "到破碎暗礁去找歐朗諾克·碎心 - 就在考斯卡水池的北方。"
Lang["Q1_10514"] = "我經歷過很多事..."			-- https://cn.tbc.wowhead.com/?quest=10514
Lang["Q2_10514"] = "影月谷內歐朗諾克的農場的歐朗諾克·碎心要你去破碎平原取回10個影月塊莖。\n\n他也要你在完成任務後將歐朗諾克的野豬哨帶回來。"
Lang["Q1_10515"] = "學到一課"			-- https://cn.tbc.wowhead.com/?quest=10515
Lang["Q2_10515"] = "影月谷內歐朗諾克的農場的歐朗諾克·碎心要你去破碎平原破壞10個掠食鐮奪怪的蛋。"
Lang["Q1_10519"] = "毀滅密碼 - 歷史與真相"			-- https://cn.tbc.wowhead.com/?quest=10519
Lang["Q2_10519"] = "影月谷裡歐朗諾克的農場的歐朗諾克·碎心要你聆聽他的故事。"
Lang["Q1_10521"] = "葛洛姆特，歐朗諾克之子"			-- https://cn.tbc.wowhead.com/?quest=10521
Lang["Q2_10521"] = "在影月谷的考斯卡崗哨找到葛洛姆特，歐朗諾克之子。"
Lang["Q1_10527"] = "阿爾托，歐朗諾克之子"			-- https://cn.tbc.wowhead.com/?quest=10527
Lang["Q2_10527"] = "在影月谷的伊利達瑞崗哨找到阿爾托，歐朗諾克之子。"
Lang["Q1_10546"] = "柏爾拉克，歐朗諾克之子"			-- https://cn.tbc.wowhead.com/?quest=10546
Lang["Q2_10546"] = "到影月谷的日蝕崗哨附近尋找柏爾拉克，歐朗諾克之子。"
Lang["Q1_10522"] = "毀滅密碼 - 葛洛姆特的命令"			-- https://cn.tbc.wowhead.com/?quest=10522
Lang["Q2_10522"] = "在影月谷考斯卡崗哨的葛洛姆特，歐朗諾克之子要你奪回毀滅密碼第一部。"
Lang["Q1_10528"] = "惡魔水晶囚牢"			-- https://cn.tbc.wowhead.com/?quest=10528
Lang["Q2_10528"] = "在伊利達瑞崗哨找到並殺掉痛苦魔女卡布利莎，拿著結晶鑰匙回到阿爾托，歐朗諾克之子的屍體那。"
Lang["Q1_10547"] = "血薊與蛋"			-- https://cn.tbc.wowhead.com/?quest=10547
Lang["Q2_10547"] = "在日蝕崗哨北邊橋上的柏爾拉克, 歐朗諾克之子要你找到腐爛的阿拉卡蛋然後交給泰洛卡森林西北邊撒塔斯城的『骯髒暴食者』托比亞斯。"
Lang["Q1_10523"] = "毀滅密碼 - 取回第一部"			-- https://cn.tbc.wowhead.com/?quest=10523
Lang["Q2_10523"] = "帶著葛洛姆特的帶鎖箱到影月谷的歐朗諾克的農場給歐朗諾克·碎心。"
Lang["Q1_10537"] = "羅恩格隆，碎心之弓"			-- https://cn.tbc.wowhead.com/?quest=10537
Lang["Q2_10537"] = "影月谷內伊利達瑞崗哨的阿爾托之靈要你去從本地的惡魔手中取回羅恩格隆，碎心之弓。"
Lang["Q1_10550"] = "一捆血薊"			-- https://cn.tbc.wowhead.com/?quest=10550
Lang["Q2_10550"] = "將一捆血薊交給影月谷的日蝕崗哨附近橋上的柏爾拉克，歐朗諾克之子。"
Lang["Q1_10540"] = "毀滅密碼 - 阿爾托的命令"			-- https://cn.tbc.wowhead.com/?quest=10540
Lang["Q2_10540"] = "影月谷中伊利達瑞崗哨的阿爾托之靈要你從『百觸』威納拉圖斯邊取回毀滅密碼第二部。\n\n遭受幽魂獵手攻擊或傷害的生物將無法獲得戰利品或經驗值。"
Lang["Q1_10570"] = "血薊花的陷阱"			-- https://cn.tbc.wowhead.com/?quest=10570
Lang["Q2_10570"] = "影月谷的日蝕崗哨附近橋上的柏爾拉克，歐朗諾克之子要你取回怒風信件。"
Lang["Q1_10576"] = "影月谷的潛行"			-- https://cn.tbc.wowhead.com/?quest=10576
Lang["Q2_10576"] = "位在影月谷靠近日蝕崗哨一座橋上的柏爾拉克, 歐朗諾克之子要你找回6件日蝕護甲。"
Lang["Q1_10577"] = "予取予求的伊利丹..."			-- https://cn.tbc.wowhead.com/?quest=10577
Lang["Q2_10577"] = "位在影月谷靠近日蝕崗哨的一座橋上的柏爾拉克, 歐朗諾克之子要你傳遞伊利丹的一段訊息給日蝕崗哨的大指揮官魯斯克。"
Lang["Q1_10578"] = "毀滅密碼 - 柏爾拉克的命令"			-- https://cn.tbc.wowhead.com/?quest=10578
Lang["Q2_10578"] = "影月谷的日蝕崗哨附近橋上的柏爾拉克，歐朗諾克之子要你從『晦暗者』魯歐身上奪回毀滅密碼第三部。"
Lang["Q1_10541"] = "毀滅密碼 - 取回第二部"			-- https://cn.tbc.wowhead.com/?quest=10541
Lang["Q2_10541"] = "將阿爾托的上鎖帶鎖箱交給影月谷裡歐朗諾克的農場的歐朗諾克·碎心。"
Lang["Q1_10579"] = "毀滅密碼 - 取回第三部"			-- https://cn.tbc.wowhead.com/?quest=10579
Lang["Q2_10579"] = "帶著柏爾拉克的帶鎖箱到影月谷的歐朗諾克的農場交給歐朗諾克·碎心。"
Lang["Q1_10588"] = "毀滅密碼"			-- https://cn.tbc.wowhead.com/?quest=10588
Lang["Q2_10588"] = "在詛咒祭壇使用毀滅密碼，召喚『火焰之王』賽洛庫。\n\n殺死火焰之王賽洛庫然後去跟大地治癒者托爾洛克談話，你同樣可以在詛咒祭壇找到他"
Lang["Q1_10883"] = "風暴之鑰"			-- https://cn.tbc.wowhead.com/?quest=10883
Lang["Q2_10883"] = "與撒塔斯城的阿達歐談談。"
Lang["Q1_10884"] = "那魯的試煉：寬容"			-- https://cn.tbc.wowhead.com/?quest=10884
Lang["Q2_10884"] = "撒塔斯城的阿達歐要你自地獄火堡壘的破碎大廳取回劊子手的廢棄之斧。\n\n此任務必須在英雄難度的地城裡完成。"
Lang["Q1_10885"] = "那魯的試煉：力量"			-- https://cn.tbc.wowhead.com/?quest=10885
Lang["Q2_10885"] = "撒塔斯城的阿達歐要你去取回卡利斯瑞的三叉戟和莫爾墨的精華。\n\n此任務必須在英雄難度的地城裡完成。"
Lang["Q1_10886"] = "那魯的試煉：堅毅"			-- https://cn.tbc.wowhead.com/?quest=10886
Lang["Q2_10886"] = "撒塔斯城的阿達歐要你去援救來自風暴要塞，亞克崔茲的米歐浩斯·曼納斯頓。\n\n此任務必須在英雄難度的地城裡完成。"
Lang["Q1_10888"] = "那魯的試煉：瑪瑟里頓"			-- https://cn.tbc.wowhead.com/?quest=10888
Lang["Q2_10888"] = "撒塔斯城的阿達歐要你殺死瑪瑟里頓。"
Lang["Q1_10680"] = "古爾丹火山"			-- https://cn.tbc.wowhead.com/?quest=10680
Lang["Q2_10680"] = "跟影月谷詛咒祭壇的大地治癒者托爾洛克交談。"
Lang["Q1_10445"] = "永恆之瓶"			-- https://cn.tbc.wowhead.com/?quest=10445
Lang["Q2_10445"] = "時光之穴的索芮朵蜜要你去從盤牙蓄湖的瓦許女士身上取得瓦許的殘存之瓶，從風暴要塞的凱爾薩斯·逐日者身上取得凱爾薩斯的殘存之瓶。"
Lang["Q1_10568"] = "巴瑞碑文"			-- https://cn.tbc.wowhead.com/?quest=10568
Lang["Q2_10568"] = "薩塔祭壇的隱士希拉要你去巴瑞廢墟從地上或者灰舌勞工的身上收集12個巴瑞碑文。\n\n為奧多爾完成任務會讓你的占卜者聲望降低。"
Lang["Q1_10683"] = "巴瑞碑文"			-- https://cn.tbc.wowhead.com/?quest=10683
Lang["Q2_10683"] = "星光聖所的秘法師賽利斯要你去巴瑞廢墟從地上及灰舌勞工身上收集12個巴瑞碑文。\n\n為占卜者完成任務會讓你的奧多爾聲望降低。"
Lang["Q1_10571"] = "長者奧洛努"			-- https://cn.tbc.wowhead.com/?quest=10571
Lang["Q2_10571"] = "薩塔祭壇的隱士希拉要你去巴瑞廢墟的長者奧洛努手中奪得阿卡瑪的命令。\n\n為奧多爾完成任務會讓你的占卜者聲望降低。"
Lang["Q1_10684"] = "長者奧洛努"			-- https://cn.tbc.wowhead.com/?quest=10684
Lang["Q2_10684"] = "星光聖所的秘法師賽利斯要你去巴瑞廢墟的長者奧洛努手中奪得阿卡瑪的命令。\n\n為占卜者完成任務會讓你的奧多爾聲望降低。"
Lang["Q1_10574"] = "灰舌墮落者"			-- https://cn.tbc.wowhead.com/?quest=10574
Lang["Q2_10574"] = "從哈盧姆，伊肯尼恩，拉卡恩和烏拉魯那邊取回四個勳章碎片然後回到影月谷的薩塔祭壇找隱士希拉。\n\n為奧多爾完成任務會使你的占卜者聲望降低。"
Lang["Q1_10685"] = "灰舌墮落者"			-- https://cn.tbc.wowhead.com/?quest=10685
Lang["Q2_10685"] = "從哈盧姆，伊肯尼恩，拉卡恩和烏拉魯那邊取回四個勳章碎片然後回到影月谷的星光聖所的秘法師賽利斯。\n\n為占卜者完成任務會讓你的奧多爾聲望降低。"
Lang["Q1_10575"] = "典獄官監牢"			-- https://cn.tbc.wowhead.com/?quest=10575
Lang["Q2_10575"] = "隱士希拉要求你進入巴瑞廢墟以南的典獄官監牢，從薩諾魯口中審問出阿卡瑪的下落。\n\n為奧多爾完成任務會讓你的占卜者聲望降低。"
Lang["Q1_10686"] = "典獄官監牢"			-- https://cn.tbc.wowhead.com/?quest=10686
Lang["Q2_10686"] = "秘法師賽利斯要求你進入巴瑞廢墟以南的典獄官監牢，從薩諾魯口中審問出阿卡瑪的下落。\n\n為占卜者完成任務會讓你的奧多爾聲望降低。"
Lang["Q1_10622"] = "忠誠的證明"			-- https://cn.tbc.wowhead.com/?quest=10622
Lang["Q2_10622"] = "殺死影月谷内典獄官監牢的杉德拉斯，然後向薩諾魯覆命。"
Lang["Q1_10628"] = "阿卡瑪"			-- https://cn.tbc.wowhead.com/?quest=10628
Lang["Q2_10628"] = "與典獄官監牢的密室中的阿卡瑪談一談。"
Lang["Q1_10705"] = "先知烏達羅"			-- https://cn.tbc.wowhead.com/?quest=10705
Lang["Q2_10705"] = "到風暴要塞的亞克崔茲找到先知烏達羅。"
Lang["Q1_10706"] = "神秘的前兆"			-- https://cn.tbc.wowhead.com/?quest=10706
Lang["Q2_10706"] = "回到影月谷的典獄官監牢找阿卡瑪。"
Lang["Q1_10707"] = "阿塔莫露臺"			-- https://cn.tbc.wowhead.com/?quest=10707
Lang["Q2_10707"] = "到影月谷內阿塔莫露臺的頂端取得狂怒之心。完成任務後回到影月谷的典獄官監牢找阿卡瑪。"
Lang["Q1_10708"] = "阿卡瑪的保證"			-- https://cn.tbc.wowhead.com/?quest=10708
Lang["Q2_10708"] = "將卡拉伯爾勳章交給撒塔斯城的阿達歐。"
Lang["Q1_10944"] = "保守的秘密"			-- https://cn.tbc.wowhead.com/?quest=10944
Lang["Q2_10944"] = "前往影月谷的典獄官監牢並且跟阿卡瑪交談。"
Lang["Q1_10946"] = "灰舌偽裝"			-- https://cn.tbc.wowhead.com/?quest=10946
Lang["Q2_10946"] = "前往風暴要塞並且戴上灰舌風帽殺死歐爾。完成任務後回到影月谷找阿卡瑪。"
Lang["Q1_10947"] = "古老的神器"			-- https://cn.tbc.wowhead.com/?quest=10947
Lang["Q2_10947"] = "前往塔納利斯的時光之穴並且進入海加爾山戰役。進入之後，擊敗瑞齊·凜冬並且將時間定相骨匣交給影月谷的阿卡瑪。"
Lang["Q1_10948"] = "靈魂之囚"			-- https://cn.tbc.wowhead.com/?quest=10948
Lang["Q2_10948"] = "前往塔斯城，將阿卡瑪的請求告訴阿達歐。"
Lang["Q1_10949"] = "進入黑暗神廟"			-- https://cn.tbc.wowhead.com/?quest=10949
Lang["Q2_10949"] = "前往影月谷的黑暗神廟，在入口處與希瑞談話。"
Lang["Q1_10985"] = "幫助阿卡瑪"			-- https://cn.tbc.wowhead.com/?quest=10985
Lang["Q2_10985"] = "在克希利的軍隊發動佯攻之後，保護阿卡瑪和瑪維進入影月谷内的黑暗神廟。"
--v243
Lang["Q1_10984"] = "援助食人魔"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10984
Lang["Q2_10984"] = "與沙塔斯城貧民窟的食人魔格羅科爾談一談。"
Lang["Q1_10983"] = "枯瘦的莫戈多格"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10983
Lang["Q2_10983"] = "與枯瘦的莫戈多格談一談，他就在刀鋒山鮮血之環外的某座塔頂上。"
Lang["Q1_10995"] = "格魯洛克的巨龍顱骨"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10995
Lang["Q2_10995"] = "奪回格魯洛克的巨龍顱骨，將其交給刀鋒山鮮血之環塔頂上的枯瘦的莫戈多格。"
Lang["Q1_10996"] = "瑪古克的寶箱"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10996
Lang["Q2_10996"] = "奪取瑪古克的寶箱，將它交給刀鋒山鮮血之環塔頂上的枯瘦的莫戈多格。"
Lang["Q1_10997"] = "戈隆的軍旗"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10997
Lang["Q2_10997"] = "奪取斯萊格的軍旗，將其交給刀鋒山鮮血之環塔頂上的枯瘦的莫戈多格。"
Lang["Q1_10998"] = "維姆高爾的魔典"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10998
Lang["Q2_10998"] = "奪取維姆高爾的魔典，並將它帶回刀鋒山內鮮血之環的塔頂上，交給枯瘦的莫戈多格。"
Lang["Q1_11000"] = "磨魂者"			-- https://www.thegeekcrusade-serveur.com/db/?quest=11000
Lang["Q2_11000"] = "奪得斯古洛克的靈魂，然後返回刀鋒山的鮮血之環，將它交給塔樓頂部的枯瘦的莫戈多格。"
Lang["Q1_11022"] = "與莫戈多格會面"			-- https://www.thegeekcrusade-serveur.com/db/?quest=11022
Lang["Q2_11022"] = "與枯瘦的莫戈多格談一談，他就在刀鋒山鮮血之環東側的塔樓頂部。"
Lang["Q1_11009"] = "食人魔的天堂"			-- https://www.thegeekcrusade-serveur.com/db/?quest=11009
Lang["Q2_11009"] = "枯瘦的莫戈多格要求你與刀鋒山奧格瑞拉的庫洛爾談一談。"
--v244
Lang["Q1_10804"] = "友善"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10804
Lang["Q2_10804"] = "影月谷靈翼平原的莫德奈要你餵養8只成熟的靈翼幼龍。"
Lang["Q1_10811"] = "尋找奈爾薩拉庫"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10811
Lang["Q2_10811"] = "尋找奈爾薩拉庫，虛空龍族的領袖。"
Lang["Q1_10814"] = "奈爾薩拉庫的故事"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10814
Lang["Q2_10814"] = "與奈爾薩拉庫談一談，聽聽他的故事。"
Lang["Q1_10836"] = "攻擊龍喉要塞"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10836
Lang["Q2_10836"] = "殺死15名龍喉獸人，然後向飛翔在影月谷靈翼平原上空的奈爾薩拉庫復命。"
Lang["Q1_10837"] = "前往靈翼浮島！"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10837
Lang["Q2_10837"] = "前往靈翼浮島收集12枚靈藤水晶，然後向飛翔在影月谷靈翼平原上空的奈爾薩拉庫復命。"
Lang["Q1_10854"] = "奈爾薩拉庫之力"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10854
Lang["Q2_10854"] = "解救5只被奴役的靈翼幼龍，然後向飛翔在影月谷靈翼平原上空的奈爾薩拉庫復命。"
Lang["Q1_10858"] = "卡瑞納庫"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10858
Lang["Q2_10858"] = "前往龍喉要塞，尋找卡瑞納庫。"
Lang["Q1_10866"] = "疲憊的祖魯希德"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10866
Lang["Q2_10866"] = "殺死疲憊的祖魯希德，取回祖魯希德的鑰匙，並用它打開祖魯希德的鎖鏈，釋放卡瑞納庫。"
Lang["Q1_10870"] = "靈翼之盟"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10870
Lang["Q2_10870"] = "让卡瑞纳库把你送回灵翼平原的莫德奈身边。"
--v247
Lang["Q1_3801"] = "黑鐵的遺產"		
Lang["Q2_3801"] = "如果你想要得到進入這座城市主城區的鑰匙，就去和弗蘭克羅恩·鑄鐵談一談。"
Lang["Q1_3802"] = "黑鐵的遺產"		
Lang["Q2_3802"] = "殺掉弗諾斯·達克維爾並拿回戰鎚鐵膽。把鐵膽之鎚拿到索瑞森神殿去，將其放在弗蘭克羅恩·鑄鐵的雕像上。"
Lang["Q1_5096"] = "誤導血色十字軍"
Lang["Q2_5096"] = "到血色十字軍建在費爾斯通農場和達爾松之淚之間的營地去，摧毀他們的指揮帳篷。"
Lang["Q1_5098"] = "標記哨塔"
Lang["Q2_5098"] = "使用信號火炬為安多哈爾城中的四座哨塔做上標記，你必須站在哨塔門口才能成功地進行標記。"
Lang["Q1_838"] = "通靈學院"
Lang["Q2_838"] = "和西瘟疫之地亡靈壁壘的藥劑師迪瑟斯談一談。"
Lang["Q1_964"] = "骸骨碎片"
Lang["Q2_964"] = "將15塊骸骨碎片交給西瘟疫之地亡靈壁壘的藥劑師迪瑟斯。"
Lang["Q1_5514"] = "昂貴的模具"
Lang["Q2_5514"] = "把灌魔的骸骨碎片和15枚金幣交給加基森的克林科·古德斯迪爾。"
Lang["Q1_5802"] = "火羽山"
Lang["Q2_5802"] = "把骷髏鑰匙模具和2塊瑟銀錠帶到安戈洛爾環形山地區的火羽山頂部。在熔岩湖旁使用骷髏鑰匙模具，鑄造出一把未完工的骷髏鑰匙。"
Lang["Q1_5804"] = "阿拉基的聖甲蟲"
Lang["Q2_5804"] = "殺掉召喚者阿拉基，並將阿拉基的聖甲蟲交給西瘟疫之地亡靈壁壘的藥劑師迪瑟斯。"
Lang["Q1_5511"] = "通靈學院的鑰匙"
Lang["Q2_5511"] = "好吧，你在這裡 - 完成的萬能鑰匙。我可以肯定，這把鑰匙會讓你在通靈學院的範圍內。"
Lang["Q1_5092"] = "掃清道路"
Lang["Q2_5092"] = "殺掉悔恨嶺中的10個骷髏剝皮者和10個被奴役的食屍鬼。"
Lang["Q1_5097"] = "標記哨塔"
Lang["Q2_5097"] = "使用信號火炬為安多哈爾城中的四座哨塔做上標記，你必須站在哨塔門口才能成功地進行標記。"
Lang["Q1_5533"] = "通靈學院"
Lang["Q2_5533"] = "和西瘟疫之地冰風崗的化學家阿爾比頓談一談。"
Lang["Q1_5537"] = "骸骨碎片"
Lang["Q2_5537"] = "將15塊骷髏碎片交給西瘟疫之地冰風崗的化學家阿爾比頓。"
Lang["Q1_5538"] = "昂貴的模具"
Lang["Q2_5538"] = "把灌魔的骸骨碎片和15枚金幣交給加基森的克林科·古德斯迪爾。"
Lang["Q1_5801"] = "火羽山"
Lang["Q2_5801"] = "把骷髏鑰匙模具和2塊瑟銀錠帶到安戈洛爾環形山地區的火羽山頂部。在熔岩湖旁使用骷髏鑰匙模具，鑄造出一把未完工的骷髏鑰匙。"
Lang["Q1_5803"] = "阿拉基的聖甲蟲"
Lang["Q2_5803"] = "殺掉召喚者阿拉基，並將阿拉基的聖甲蟲交給西瘟疫之地冰風崗的化學家阿爾比頓。"
Lang["Q1_5505"] = "通靈學院的鑰匙"
Lang["Q2_5505"] = "通靈學院的鑰好吧，你在這裡 - 完成的萬能鑰匙。我可以肯定，這把鑰匙會讓你在通靈學院的範圍內。匙"
--v250
Lang["Q1_6804"] = "被囚禁的水元素"
Lang["Q2_6804"] = "對東瘟疫之地的被感染的水元素使用海神之水。把12副不諧護腕和海神之水交給艾薩拉的海達克西斯公爵。"
Lang["Q1_6805"] = "雷暴和磐石"
Lang["Q2_6805"] = "殺死15個灰塵風暴和15個沙漠奔行者，然後回到艾薩拉的海達克西斯公爵那兒。"
Lang["Q1_6821"] = "艾博希爾之眼"
Lang["Q2_6821"] = "將艾博希爾之眼交給艾薩拉的海達克西斯公爵。"
Lang["Q1_6822"] = "熔火之心"
Lang["Q2_6822"] = "殺死一個火焰之王、一個熔岩巨人、一個上古熔火惡犬和一個熔岩奔騰者，然後回到艾薩拉的海達克西斯公爵那裡。"
Lang["Q1_6823"] = "海達克西斯的使者"
Lang["Q2_6823"] = "在海達希亞水元素中達到被尊敬的聲望，然後與艾薩拉的海達克西斯公爵談一談。"
Lang["Q1_6824"] = "敵人之手"
Lang["Q2_6824"] = "將魯西弗隆之手、薩弗隆之手、基赫納斯之手和沙斯拉爾之手交給艾薩拉的海達克西斯公爵。"
Lang["Q1_7486"] = "英雄的獎賞"
Lang["Q2_7486"] = "從海達克西斯的箱子拿取你的獎勵。"


-- NPC
Lang["N1_9196"] = "歐莫克大王"	-- https://cn.tbc.wowhead.com/?npc=9196
Lang["N2_9196"] = "歐莫克大王能在以下地區找到：黑石塔下層。"
Lang["N1_9237"] = "指揮官沃恩"	-- https://cn.tbc.wowhead.com/?npc=9237
Lang["N2_9237"] = "指揮官沃恩能在以下地區找到：​黑石塔下層。"
Lang["N1_9568"] = "維姆薩拉克主宰"	-- https://cn.tbc.wowhead.com/?npc=9568
Lang["N2_9568"] = "維姆薩拉克主宰能在以下地區找到：​黑石塔下層。"
Lang["N1_10429"] = "大酋長雷德·黑手"	-- https://cn.tbc.wowhead.com/?npc=10429
Lang["N2_10429"] = "大酋長雷德·黑手能在以下地區找到：​黑石塔上層。"
Lang["N1_10182"] = "雷克萨<部落的勇士>"	-- https://cn.tbc.wowhead.com/?npc=10182
Lang["N2_10182"] = "雷克薩能能在以下地區找到：淒涼之地、菲拉斯、石爪山脈。"
Lang["N1_8197"] = "克魯納里斯"	-- https://cn.tbc.wowhead.com/?npc=8197
Lang["N2_8197"] = "克魯納里斯能在塔納利斯的時光之穴門外找到。"
Lang["N1_10664"] = "斯克利爾"	-- https://cn.tbc.wowhead.com/?npc=10664
Lang["N2_10664"] = "斯克利爾能在冬泉谷的藍龍洞深處找到。"
Lang["N1_12900"] = "索姆努斯"	-- https://cn.tbc.wowhead.com/?npc=12900
Lang["N2_12900"] = "索姆努斯能在悲傷沼澤的沉默的神廟東側找到。"
Lang["N1_12899"] = "埃克托茲"	-- https://cn.tbc.wowhead.com/?npc=12899
Lang["N2_12899"] = "埃克托茲能在濕地的格瑞姆巴托找到。"
Lang["N1_10363"] = "達基薩斯將軍"	-- https://cn.tbc.wowhead.com/?npc=10363
Lang["N2_10363"] = "達基薩斯將軍是黑石塔上層的最終首領。"
Lang["N1_8983"] = "魔像領主阿格曼奇"	-- https://cn.tbc.wowhead.com/?npc=8983
Lang["N2_8983"] = "魔像領主阿格曼奇能在以下地區找到：​黑石深淵。"
Lang["N1_9033"] = "安格佛將軍"	-- https://cn.tbc.wowhead.com/?npc=9033
Lang["N2_9033"] = "安格佛將軍能在以下地區找到：​黑石深淵。"
Lang["N1_17804"] = "侍衛洛文"	-- https://cn.tbc.wowhead.com/?npc=17804
Lang["N2_17804"] = "侍衛洛文能在暴風城大門找到。"
Lang["N1_10929"] = "哈爾琳"	-- https://cn.tbc.wowhead.com/?npc=10929
Lang["N2_10929"] = "站在馬茲索里爾洞穴頂部。\n可以通過洞穴深處地板上的藍色符文到達。"
Lang["N1_9046"] = "裂盾軍需官 <裂盾軍團>"	-- https://cn.tbc.wowhead.com/?npc=9046
Lang["N2_9046"] = "位於副本外，在黑石塔陽台入口附近。"
Lang["N1_15180"] = "流沙守望者巴里斯托爾斯"	-- https://cn.tbc.wowhead.com/?npc=15180
Lang["N2_15180"] = "流沙守望者巴里斯托爾斯位於希利蘇斯 (49.6,36.6)。"
Lang["N1_12017"] = "龍領主勒西雷爾"	-- https://cn.tbc.wowhead.com/?npc=12017
Lang["N2_12017"] = "龍領主勒西雷爾是黑翼之巢的第三位首領。"
Lang["N1_13020"] = "堕落的瓦拉斯塔兹"	-- https://cn.tbc.wowhead.com/?npc=13020
Lang["N2_13020"] = "堕落的瓦拉斯塔兹是黑翼之巢的第二位首領。"
Lang["N1_11583"] = "奈法利安"	-- https://cn.tbc.wowhead.com/?npc=11583
Lang["N2_11583"] = "奈法利安是黑翼之巢的最終首領。"
Lang["N1_15362"] = "瑪法里恩·怒風"	-- https://cn.tbc.wowhead.com/?npc=15362
Lang["N2_15362"] = "瑪法里恩·怒風位於沉默的神廟最終首領附近。"
Lang["N1_15624"] = "森林幽光"	-- https://cn.tbc.wowhead.com/?npc=15624
Lang["N2_15624"] = "森林幽光位於達納蘇斯(37.6,48.0)。"
Lang["N1_15481"] = "艾索雷葛斯之魂"	-- https://cn.tbc.wowhead.com/?npc=15481
Lang["N2_15481"] = "艾索雷葛斯之魂位於艾薩拉 (58.8,82.2)。"
Lang["N1_11811"] = "納瑞安"	-- https://cn.tbc.wowhead.com/?npc=11811
Lang["N2_11811"] = "納瑞安位於塔納利斯 (65.2,18.4)."
Lang["N1_15526"] = "人魚米莉蒂絲"	-- https://cn.tbc.wowhead.com/?npc=15526
Lang["N2_15526"] = "人魚米莉蒂絲位於塔納利斯 (59.6,95.6)。"
Lang["N1_15554"] = "人造猿二號"	-- https://cn.tbc.wowhead.com/?npc=15554
Lang["N2_15554"] = "人造猿二號位於冬泉谷 (67.2,72.6). "
Lang["N1_15552"] = "維維爾博士"	-- https://cn.tbc.wowhead.com/?npc=15552
Lang["N2_15552"] = "維維爾博士位於塵泥沼澤(77.8,17.6)。"
Lang["N1_10184"] = "奧妮克希亞"	-- https://cn.tbc.wowhead.com/?npc=10184
Lang["N2_10184"] = "奧妮克希亞位於奧妮克希亞的巢穴。"
Lang["N1_11502"] = "拉格納羅斯"	-- https://cn.tbc.wowhead.com/?npc=11502
Lang["N2_11502"] = "拉格納羅斯是熔火之心的最終首領。"
Lang["N1_12803"] = "拉克麥拉"	-- https://cn.tbc.wowhead.com/?npc=12803
Lang["N2_12803"] = "拉克麥拉位於菲拉斯 (29.8,72.6)。"
Lang["N1_15571"] = "巨齒鯊"	-- https://cn.tbc.wowhead.com/?npc=15571
Lang["N2_15571"] = "巨齒鯊位於艾薩拉 (65.6,54.6)。"
Lang["N1_22037"] = "鐵匠戈蘭克"	-- https://cn.tbc.wowhead.com/?npc=22037
Lang["N2_22037"] = "鐵匠戈蘭克位於影月谷 (67,36)。"
Lang["N1_18733"] = "惡魔劫奪者"	-- https://cn.tbc.wowhead.com/?npc=18733
Lang["N2_18733"] = "傾向於漫遊在地獄火壁壘的西側。"
Lang["N1_18473"] = "鷹王伊奇斯"	-- https://cn.tbc.wowhead.com/?npc=18473
Lang["N2_18473"] = "鷹王伊奇斯是塞司克大廳的最終首領"
Lang["N1_20142"] = "時間服務員 <時光守望者>"	-- https://cn.tbc.wowhead.com/?npc=20142
Lang["N2_20142"] = "時間服務員 <時光守望者>位於時光之穴的入口"
Lang["N1_20130"] = "安杜姆 <時光守望者>"	-- https://cn.tbc.wowhead.com/?npc=20130
Lang["N2_20130"] = "看起來像一個小男孩，靠近時光之穴的沙漏."
Lang["N1_18096"] = "紀元狩獵者"	-- https://cn.tbc.wowhead.com/?npc=18096
Lang["N2_18096"] = "紀元狩獵者是希爾斯布萊德丘陵舊址的最終首領."
Lang["N1_19880"] = "虛空巡者凱澤"	-- https://cn.tbc.wowhead.com/?npc=19880
Lang["N2_19880"] = "虛空巡者凱澤位於虛空風暴52區 (32,64)"
Lang["N1_19641"] = "星界強盜奈薩德"	-- https://cn.tbc.wowhead.com/?npc=19641
Lang["N2_19641"] = "星界強盜奈薩德於虛空風暴(28,79)。"
Lang["N1_18481"] = "阿達歐"	-- https://cn.tbc.wowhead.com/?npc=18481
Lang["N2_18481"] = "阿達歐位於撒塔斯城的中央。"
Lang["N1_19220"] = "操縱者帕薩里歐"	-- https://cn.tbc.wowhead.com/?npc=19220
Lang["N2_19220"] = "操縱者帕薩里歐是麥克納爾的最終首領。"
Lang["N1_17977"] = "扭曲分裂者"	-- https://cn.tbc.wowhead.com/?npc=17977
Lang["N2_17977"] = "扭曲分裂者波塔尼卡的最終首領。"
Lang["N1_17613"] = "大法師艾特羅斯"	-- https://cn.tbc.wowhead.com/?npc=17613
Lang["N2_17613"] = "大法師艾特羅斯站在卡拉贊的入口。"
Lang["N1_18708"] = "莫爾墨"	-- https://cn.tbc.wowhead.com/?npc=18708
Lang["N2_18708"] = "莫爾墨是暗影迷宫的最終首領。"
Lang["N1_17797"] = "水占師希斯比亞"	-- https://cn.tbc.wowhead.com/?npc=17797
Lang["N2_17797"] = "水占師希斯比亞是蒸氣洞窟的第一位首領。"
Lang["N1_20870"] = "無約束的希瑞奇斯"	-- https://cn.tbc.wowhead.com/?npc=20870
Lang["N2_20870"] = "無約束的希瑞奇斯亞克崔茲的第一位首領。"
Lang["N1_15608"] = "麥迪文"	-- https://cn.tbc.wowhead.com/?npc=15608
Lang["N2_15608"] = "麥迪文在黑色沼澤南部的黑暗之門附近。"
Lang["N1_16524"] = "埃蘭之影"	-- https://cn.tbc.wowhead.com/?npc=16524
Lang["N2_16524"] = "麥迪文的瘋狂父親，在卡拉贊。"
Lang["N1_16807"] = "大術士奈德克斯"	-- https://cn.tbc.wowhead.com/?npc=16807
Lang["N2_16807"] = "大術士奈德克斯是破碎大廳的第一位首領。"
Lang["N1_18472"] = "暗織者希斯"	-- https://cn.tbc.wowhead.com/?npc=18472
Lang["N2_18472"] = "暗織者希斯是塞司克大廳的第一位首領。"
Lang["N1_22421"] = "異教徒司卡利斯"	-- https://cn.tbc.wowhead.com/?npc=22421
Lang["N2_22421"] = "異教徒司卡利斯在英雄難度的奴隸監獄。"
Lang["N1_19044"] = "弒龍者戈魯爾"	-- https://cn.tbc.wowhead.com/?npc=19044
Lang["N2_19044"] = "弒龍者戈魯爾是戈魯爾的巢穴的最終首領。"
Lang["N1_17225"] = "夜禍"	-- https://cn.tbc.wowhead.com/?npc=17225
Lang["N2_17225"] = "夜禍是卡拉贊的召喚首領。"
Lang["N1_21938"] = "大地治愈者斯普林·裂蹄 <陶土議會>"	-- https://cn.tbc.wowhead.com/?npc=21938
Lang["N2_21938"] = "大地治愈者斯普林·裂蹄 <陶土議會>位於影月谷 (28.6,26.6)。"
Lang["N1_21183"] = "歐朗諾克·碎心 <隱士和商人>"	-- https://cn.tbc.wowhead.com/?npc=21183
Lang["N2_21183"] = "歐朗諾克·碎心 <隱士和商人>位於影月谷 (53.8,23.4)。"
Lang["N1_21291"] = "葛洛姆特，歐朗諾克之子"	-- https://cn.tbc.wowhead.com/?npc=21291
Lang["N2_21291"] = "葛洛姆特，歐朗諾克之子位於影月谷 (44.6,23.6)。"
Lang["N1_21292"] = "阿爾托，歐朗諾克之子"	-- https://cn.tbc.wowhead.com/?npc=21292
Lang["N2_21292"] = "阿爾托，歐朗諾克之子位於影月谷 (29.6,50.4)。"
Lang["N1_21293"] = "柏爾拉克，歐朗諾克之子"	-- https://cn.tbc.wowhead.com/?npc=21293
Lang["N2_21293"] = "柏爾拉克，歐朗諾克之子位於影月谷 (47.6,57.2)。"
Lang["N1_18166"] = "卡德加 <洛薩之子>"	-- https://cn.tbc.wowhead.com/?npc=18166
Lang["N2_18166"] = "他站在撒塔斯城的中心，就在黄色發光的阿達歐旁邊。"
Lang["N1_16808"] = "大酋長卡加斯·刃拳"	-- https://cn.tbc.wowhead.com/?npc=16808
Lang["N2_16808"] = "大酋長卡加斯·刃拳是破碎大廳的最終首領。"
Lang["N1_17798"] = "督軍卡利斯瑞"	-- https://cn.tbc.wowhead.com/?npc=17798
Lang["N2_17798"] = "督軍卡利斯瑞是蒸氣洞窟的最終首領。"
Lang["N1_20912"] = "先驅者史蓋力司"	-- https://cn.tbc.wowhead.com/?npc=20912
Lang["N2_20912"] = "先驅者史蓋力司是亞克崔茲的最終首領。"
Lang["N1_20977"] = "米歐浩斯·曼納斯頓"	-- https://cn.tbc.wowhead.com/?npc=20977
Lang["N2_20977"] = "米歐浩斯·曼納斯頓是在亞克崔茲中發現的地精法師。 他將協助攻擊從監獄釋放的其他生物。"
Lang["N1_17257"] = "瑪瑟里頓"	-- https://cn.tbc.wowhead.com/?npc=17257
Lang["N2_17257"] = "瑪瑟里頓被關押在地獄火壁壘的下層，團隊副本被稱為瑪瑟里頓的巢穴."
Lang["N1_21937"] = "大地治癒者索菲魯斯 <陶土議會>"	-- https://cn.tbc.wowhead.com/?npc=21937
Lang["N2_21937"] = "大地治癒者索菲魯斯 <陶土議會>位於影月谷 (36.4,56.8)。"
Lang["N1_19935"] = "索芮朵蜜 <流沙之鳞>"	-- https://cn.tbc.wowhead.com/?npc=19935
Lang["N2_19935"] = "索芮朵蜜徘徊在時光之穴的大沙漏周圍."
Lang["N1_19622"] = "凱爾薩斯·逐日者 <血精靈之王>"	-- https://cn.tbc.wowhead.com/?npc=19622
Lang["N2_19622"] = "凱爾薩斯·逐日者 <血精靈之王>是風暴要塞的最終首領。"
Lang["N1_21212"] = "瓦許女士 <盤牙女王>"	-- https://cn.tbc.wowhead.com/?npc=21212
Lang["N2_21212"] = "瓦許女士 <盤牙女王>是毒蛇神殿的最終首領。"
Lang["N1_21402"] = "隱士希拉"	-- https://cn.tbc.wowhead.com/?npc=21402
Lang["N2_21402"] = "隱士希拉位於影月谷 (62.6,28.4)。"
Lang["N1_21955"] = "秘法師賽利斯"	-- https://cn.tbc.wowhead.com/?npc=21955
Lang["N2_21955"] = "秘法師賽利斯位於影月谷 (56.2,59.6)。"
Lang["N1_21962"] = "烏達羅"	-- https://cn.tbc.wowhead.com/?npc=21962
Lang["N2_21962"] = "烏達羅在亞克崔茲的最終首領戰鬥之前，他躺在小坡道上死了."
Lang["N1_22006"] = "暗影領主達斯維爾"	-- https://cn.tbc.wowhead.com/?npc=22006
Lang["N2_22006"] = "暗影領主達斯維爾騎龍在黑暗神廟的北塔上 (71.6,35.6)。"
Lang["N1_22820"] = "先知奧魯姆"	-- https://cn.tbc.wowhead.com/?npc=22820
Lang["N2_22820"] = "先知奥鲁姆位於毒蛇神殿深淵之王卡拉薩瑞斯附近。"
Lang["N1_21700"] = "阿卡瑪"	-- https://cn.tbc.wowhead.com/?npc=21700
Lang["N2_21700"] = "阿卡瑪位於影月谷 (58.0,48.2)。"
Lang["N1_19514"] = "歐爾 <鳳凰神>"	-- https://cn.tbc.wowhead.com/?npc=19514
Lang["N2_19514"] = "歐爾 <鳳凰神>是風暴要塞的第一位首領。"
Lang["N1_17767"] = "瑞齊·凜冬"	-- https://cn.tbc.wowhead.com/?npc=17767
Lang["N2_17767"] = "瑞齊·凜冬是海加爾山的第一位首領。"
Lang["N1_18528"] = "希瑞"	-- https://cn.tbc.wowhead.com/?npc=18528
Lang["N2_18528"] = "希瑞位於黑暗神廟的門外."
--v243
Lang["N1_22497"] = "弗埃盧"	-- https://www.thegeekcrusade-serveur.com/db/?npc=22497
Lang["N2_22497"] = "弗埃盧和阿達爾在同一個房間，但他是藍色的。他在頂層著陸。"
--v244
Lang["N1_22113"] = "莫德奈"
Lang["N2_22113"] = "一個血精靈（劇透警報，實際上是一條龍）走在星辰聖殿東邊的虛空之翼領域"
--v247
Lang["N1_8888"]  = "弗蘭克羅恩·鑄鐵"
Lang["N2_8888"]  = "一個幽靈矮人，站在地牢外他自己的墳墓上，在懸浮在熔岩上方的結構中。 只有死了才能與他互動。"
Lang["N1_9056"]  = "弗諾斯·達克維爾"
Lang["N2_9056"]  = "他在地牢內，在伊森迪烏斯勳爵房間外的採石場巡邏。"
Lang["N1_10837"] = "高級執行官德靈頓"
Lang["N2_10837"] = "他可以在壁壘中找到，靠近提瑞斯法和西瘟疫之地的邊界"
Lang["N1_10838"] = "指揮官阿什拉姆·瓦羅菲斯特"
Lang["N2_10838"] = "他可以在西瘟疫之地安多哈爾以南的寒風營地找到"
Lang["N1_1852"]  = "召喚者阿拉吉"
Lang["N2_1852"]  = "巫妖，在安多哈爾的中央"
--v250
Lang["N1_13278"]  = "海達克西斯公爵"
Lang["N2_13278"]  = "艾薩拉一個遙遠的小島上的大型水元素 (79.2,73.6)"
Lang["N1_12264"]  = "沙斯拉爾"
Lang["N2_12264"]  = "沙斯拉爾 是熔火之心的第五個boss。"
Lang["N1_12118"]  = "魯西弗隆"
Lang["N2_12118"]  = "魯西弗隆 是熔火之心的第一個boss。"
Lang["N1_12259"]  = "基赫纳斯"
Lang["N2_12259"]  = "基赫纳斯 是熔火之心的第三个boss。"
Lang["N1_12098"]  = "S薩弗隆先驅者r"
Lang["N2_12098"]  = "薩弗隆先驅者 是熔火之心的第八個boss。"
-- Ragefire Chasm / Deadmines
Lang["N1_11519"] = "巴札蘭"
Lang["N2_11519"] = "巴札蘭是怒焰裂谷中位於耶戈什上方平台的薩特首領。"
Lang["N1_11518"] = "祈求者耶戈什"
Lang["N2_11518"] = "祈求者耶戈什是怒焰裂谷深處的術士首領。"
Lang["N1_11520"] = "飢餓者塔拉加曼"
Lang["N2_11520"] = "飢餓者塔拉加曼是怒焰裂谷熔岩湖中的地獄衛士首領。"
Lang["N1_11834"] = "瑪爾·恐怖圖騰"
Lang["N2_11834"] = "瑪爾·恐怖圖騰的屍體位於怒焰裂谷第一個首領之後，右側岔路上。"
Lang["N1_639"] = "艾德溫·范克里夫"
Lang["N2_639"] = "艾德溫·范克里夫是死亡礦坑的最終首領，位於鐵甲灣的海盜船上。"
-- Shadowfang Keep
Lang["N1_4275"] = "大法師阿魯高"
Lang["N2_4275"] = "大法師阿魯高是影牙城堡的最終首領，位於城堡頂部。"
Lang["N1_3849"] = "亡靈哨兵阿達曼特"
Lang["N2_3849"] = "亡靈哨兵阿達曼特的屍體位於影牙城堡前段，庭院路徑旁的側室內。"
Lang["N1_4444"] = "亡靈哨兵文森特"
Lang["N2_4444"] = "亡靈哨兵文森特的屍體位於影牙城堡更深處，餐廳附近。"
-- Blackfathom Deeps
Lang["N1_4787"] = "銀月守衛塞爾瑞德"
Lang["N2_4787"] = "銀月守衛塞爾瑞德位於黑暗深淵內，穿過前段納迦洞穴後可見。"
Lang["N1_4832"] = "夢遊者克爾里斯"
Lang["N2_4832"] = "夢遊者克爾里斯是黑暗深淵的首領，位於月光神殿。"
Lang["N1_12902"] = "洛古斯·傑特"
Lang["N2_12902"] = "洛古斯·傑特是黑暗深淵中的暮光之錘施法者，在通往神殿的路上。"
-- Gnomeregan
Lang["N1_7800"] = "麥克尼爾·瑟瑪普拉格"
Lang["N2_7800"] = "麥克尼爾·瑟瑪普拉格是諾姆瑞根的最終首領，位於工匠議會。"
Lang["N1_6231"] = "尖端機器人"
Lang["N2_6231"] = "尖端機器人位於諾姆瑞根副本入口附近，在副本外。"
Lang["N1_7850"] = "克努比"
Lang["N2_7850"] = "克努比位於諾姆瑞根內，並開始護送任務《一團亂麻》。"
-- Razorfen Kraul
Lang["N1_4421"] = "卡爾加·刺肋"
Lang["N2_4421"] = "卡爾加·刺肋是剃刀沼澤的最終首領。"
Lang["N1_4508"] = "進口商威利克斯"
Lang["N2_4508"] = "進口商威利克斯位於剃刀沼澤內，需要護送他離開。"


Lang["O_1"] = "擊殺達基薩斯將軍以完成任務。\n位於達基薩斯將軍後面的發光球。"
Lang["O_2"] = "這是一個在地面上發光的小紅點\n位於安琪拉之門 (28.7,89.2)。"
--v247
Lang["O_3"] = "神殿位於一條走廊的盡頭，這條走廊從法則之環的上層開始。"
Lang["Work in progress"] = "製作中"
-- Forever dungeon names
Lang["Excavation Site"] = "挖掘場"
Lang["City of Dalaran"] = "達拉然城"
Lang["The Drowned City"] = "沉沒之城"
Lang["Krol'dok Stronghold"] = "克羅多克要塞"
Lang["Alcaz Prison"] = "奧卡茲監獄"
Lang["Blackmaw Hold"] = "黑喉要塞"
Lang["The Shapers Terrace"] = "塑形者露臺"

-- Synced from enUS (missing keys - English fallback until translated)
Lang["Beast"] = "Beast"
Lang["Blackfathom Deeps"] = "Blackfathom Deeps"
Lang["Blackrock Depths Quests"] = "Blackrock Depths Quests"
Lang["DUNGEONS"] = "DUNGEONS"
Lang["Darkshore"] = "Darkshore"
Lang["Darnassus"] = "Darnassus"
Lang["Dire Maul"] = "Dire Maul"
Lang["Dun Morogh"] = "Dun Morogh"
Lang["DungeonQuest_Desc"] = "Complete the dungeon quests and any chains that lead into this instance."
Lang["Durotar"] = "Durotar"
Lang["Giant"] = "Giant"
Lang["Gnomeregan"] = "Gnomeregan"
Lang["Hillsbrad Foothills"] = "Hillsbrad Foothills"
Lang["I_10420"] = "Skull of the Coldbringer"
Lang["I_10454"] = "Essence of Eranikus"
Lang["I_10465"] = "Egg of Hakkar"
Lang["I_10660"] = "First Mosh'aru Tablet"
Lang["I_10661"] = "Second Mosh'aru Tablet"
Lang["I_10662"] = "Filled Egg of Hakkar"
Lang["I_11230"] = "Encased Fiery Essence"
Lang["I_11268"] = "Head of Argelmach"
Lang["I_11269"] = "Intact Elemental Core"
Lang["I_11309"] = "The Heart of the Mountain"
Lang["I_11312"] = "Lost Thunderbrew Recipe"
Lang["I_11313"] = "Ribbly's Head"
Lang["I_11468"] = "Dark Iron Fanny Pack"
Lang["I_12241"] = "Collected Dragon Egg"
Lang["I_12263"] = "Caged Worg Pup"
Lang["I_12335"] = "Gemstone of Smolderthorn"
Lang["I_12336"] = "Gemstone of Spirestone"
Lang["I_12337"] = "Gemstone of Bloodaxe"
Lang["I_12345"] = "Bijou's Belongings"
Lang["I_12352"] = "Doomrigger's Clasp"
Lang["I_12358"] = "Darkstone Tablet"
Lang["I_12402"] = "Ancient Egg"
Lang["I_12530"] = "Spire Spider Egg"
Lang["I_12712"] = "Warosh's Mojo"
Lang["I_12740"] = "Fifth Mosh'aru Tablet"
Lang["I_12741"] = "Sixth Mosh'aru Tablet"
Lang["I_12780"] = "General Drakkisath's Command"
Lang["I_12923"] = "Awbee's Scale"
Lang["I_13172"] = "Grimm's Premium Tobacco"
Lang["I_13174"] = "Plagued Flesh Sample"
Lang["I_13176"] = "Scourge Data"
Lang["I_13180"] = "Stratholme Holy Water"
Lang["I_13207"] = "Head of Baron Rivendare"
Lang["I_13250"] = "Head of Balnazzar"
Lang["I_13471"] = "The Deed to Brill"
Lang["I_13626"] = "Human Head of Ras Frostwhisper"
Lang["I_13725"] = "Krastinov's Bag of Horrors"
Lang["I_14395"] = "Spells of Shadow"
Lang["I_14396"] = "Incantations from the Nether"
Lang["I_14540"] = "Taragaman the Hungerer's Heart"
Lang["I_14544"] = "Lieutenant's Insignia"
Lang["I_14679"] = "Of Love and Family"
Lang["I_17009"] = "Ambassador Malcin's Head"
Lang["I_17322"] = "Eye of the Emberseer"
Lang["I_17684"] = "Theradric Crystal Carving"
Lang["I_17702"] = "Celebrian Rod"
Lang["I_17703"] = "Celebrian Diamond"
Lang["I_17756"] = "Shadowshard Fragment"
Lang["I_17758"] = "Amulet of Union"
Lang["I_18240"] = "Azj'Tordin's Book of Incantations"
Lang["I_18426"] = "Lethtendris's Web"
Lang["I_18502"] = "Felvine Shard"
Lang["I_1875"] = "Thistlenettle's Badge"
Lang["I_1894"] = "Miners' Union Card"
Lang["I_274286"] = "Durgen Dirgehammer's Head"
Lang["I_274289"] = "Dwarven Heirloom"
Lang["I_281030"] = "Treaty of Understanding"
Lang["I_2874"] = "An Unsent Letter"
Lang["I_2909"] = "Red Wool Bandana"
Lang["I_2926"] = "Head of Bazil Thredd"
Lang["I_3628"] = "Hand of Dextren Ward"
Lang["I_3630"] = "Head of Targorr"
Lang["I_3637"] = "Head of VanCleef"
Lang["I_4635"] = "Hammertoe's Amulet"
Lang["I_5824"] = "Tablet of Will"
Lang["I_5826"] = "Tablet of Ryun'eh"
Lang["I_6175"] = "Atal'ai Artifact"
Lang["I_6181"] = "Fetish of Hakkar"
Lang["I_6188"] = "Fetish of Hakkar"
Lang["I_6212"] = "Head of Jammal'an"
Lang["I_6288"] = "Atal'ai Tablet"
Lang["I_7365"] = "Gnoam Sprecklesprocket"
Lang["I_7672"] = "Obsidian Power Source"
Lang["I_7740"] = "Shattered Necklace"
Lang["I_8009"] = "Dentrium Power Stone"
Lang["I_8047"] = "Magenta Fungus Cap"
Lang["I_8052"] = "An'Alleum Power Stone"
Lang["I_8548"] = "Divino-matic Rod"
Lang["I_8707"] = "Gahz'rilla's Electrified Scale"
Lang["I_915"] = "Red Silk Bandana"
Lang["I_9234"] = "Tiara of the Deep"
Lang["I_9238"] = "Uncracked Scarab Shell"
Lang["I_9321"] = "Venom Bottle"
Lang["I_9322"] = "Undamaged Venom Sac"
Lang["I_9471"] = "Nekrum's Medallion"
Lang["I_9523"] = "Troll Temper"
Lang["Ironforge"] = "Ironforge"
Lang["Loch Modan"] = "Loch Modan"
Lang["Maraudon"] = "Maraudon"
Lang["N1_"] = ""
Lang["N1_10220"] = "Halycon"
Lang["N1_10321"] = "Emberstrife"
Lang["N1_10439"] = "Baron Rivendare"
Lang["N1_10503"] = "Jandice Barov"
Lang["N1_10506"] = "Kirtonos the Herald"
Lang["N1_10508"] = "Ras Frostwhisper"
Lang["N1_10584"] = "Urok Doomhowl"
Lang["N1_10596"] = "Mother Smolderweb"
Lang["N1_10811"] = "Archivist Galford"
Lang["N1_11261"] = "Doctor Theolen Krastinov"
Lang["N1_11486"] = "Prince Tortheldrin"
Lang["N1_11496"] = "Immol'thar"
Lang["N1_12201"] = "Princess Theradras"
Lang["N1_12236"] = "Lord Vyletongue"
Lang["N1_12865"] = "Ambassador Malcin"
Lang["N1_13282"] = "Noxxion"
Lang["N1_14327"] = "Lethtendris"
Lang["N1_1663"] = "Dextren Ward"
Lang["N1_1696"] = "Targorr the Dread"
Lang["N1_1716"] = "Bazil Thredd"
Lang["N1_260322"] = "Saltspine"
Lang["N1_260325"] = "Shadetooth"
Lang["N1_260326"] = "Relic Guardian"
Lang["N1_260808"] = "Highland Horror"
Lang["N1_261306"] = "Faldrim Anvilmar"
Lang["N1_261319"] = "Durgen Dirgehammer"
Lang["N1_2748"] = "Archaedas"
Lang["N1_3974"] = "Houndmaster Loksey"
Lang["N1_3975"] = "Herod"
Lang["N1_3976"] = "Scarlet Commander Mograine"
Lang["N1_3977"] = "High Inquisitor Whitemane"
Lang["N1_5710"] = "Jammal'an the Prophet"
Lang["N1_7272"] = "Theka the Martyr"
Lang["N1_7273"] = "Gahz'rilla"
Lang["N1_7358"] = "Amnennar the Coldbringer"
Lang["N1_7795"] = "Hydromancer Velratha"
Lang["N1_7797"] = "Nekrum Gutchewer"
Lang["N1_9016"] = "Bael'Gar"
Lang["N1_9017"] = "Lord Incendius"
Lang["N1_9019"] = "Emperor Dagran Thaurissan"
Lang["N1_9543"] = "Ribbly Screwspigot"
Lang["N1_9816"] = "Pyroguard Emberseer"
Lang["N2_"] = ""
Lang["N2_10220"] = "Halycon is the worg pack mistress in Lower Blackrock Spire, in the Hordemar City pens."
Lang["N2_10321"] = "Emberstrife is an ancient black drake in the Wyrmbog in Dustwallow Marsh."
Lang["N2_10439"] = "Baron Rivendare is the final boss of Stratholme Undead."
Lang["N2_10503"] = "Jandice Barov is a Scholomance boss who drops Krastinov's Bag of Horrors."
Lang["N2_10506"] = "Kirtonos the Herald is summoned on the Scholomance porch with the Blood of Innocents."
Lang["N2_10508"] = "Ras Frostwhisper is a lich boss in Scholomance."
Lang["N2_10584"] = "Urok Doomhowl is summoned in Lower Blackrock Spire with Warosh's Scroll."
Lang["N2_10596"] = "Mother Smolderweb guards the Skitterweb tunnels in Lower Blackrock Spire."
Lang["N2_10811"] = "Archivist Galford is in the Scarlet Bastion wing of Stratholme."
Lang["N2_11261"] = "Doctor Theolen Krastinov, the Butcher, is a Scholomance boss."
Lang["N2_11486"] = "Prince Tortheldrin is the final boss of Dire Maul West, in the Athenaeum."
Lang["N2_11496"] = "Immol'thar is imprisoned in Dire Maul West and must be freed by destroying the pylons."
Lang["N2_12201"] = "Princess Theradras is the final boss of Maraudon, in Zaetar's Grave."
Lang["N2_12236"] = "Lord Vyletongue is a Maraudon boss in the purple crystal wing."
Lang["N2_12865"] = "Ambassador Malcin camps outside Razorfen Downs among the Death's Head forces."
Lang["N2_13282"] = "Noxxion is a Maraudon boss in the orange crystal wing (Wicked Grotto)."
Lang["N2_14327"] = "Lethtendris is a Dire Maul East boss who drops Lethtendris's Web."
Lang["N2_1663"] = "Dextren Ward is a boss in The Stockade, found at the end of the left wing."
Lang["N2_1696"] = "Targorr the Dread is a boss in The Stockade, found at the end of the right wing."
Lang["N2_1716"] = "Bazil Thredd is the final boss of The Stockade, VanCleef's lieutenant held in the deepest cells."
Lang["N2_260322"] = "Saltspine is the first boss in the Excavation Site, a crocolisk in the Lost Marsh."
Lang["N2_260325"] = "Shadetooth is a raptor boss in the Excavation Site."
Lang["N2_260326"] = "Relic Guardian is the final boss of the Excavation Site, a titan construct in the Site of the Guardian."
Lang["N2_260808"] = "Highland Horror is a bog beast boss in the Excavation Site."
Lang["N2_261306"] = "Faldrim Anvilmar patrols Anvilmar's Rest inside the Hall of Thanes."
Lang["N2_261319"] = "Durgen Dirgehammer is the final boss of the Hall of Thanes."
Lang["N2_2748"] = "Archaedas is the final boss of Uldaman."
Lang["N2_3974"] = "Houndmaster Loksey is the boss of Scarlet Monastery Library, in the courtyard with his hounds."
Lang["N2_3975"] = "Herod the Scarlet Champion is the boss of Scarlet Monastery Armory."
Lang["N2_3976"] = "Scarlet Commander Mograine is fought in Scarlet Monastery Cathedral; Whitemane resurrects him."
Lang["N2_3977"] = "High Inquisitor Whitemane is the final boss of Scarlet Monastery Cathedral."
Lang["N2_5710"] = "Jammal'an the Prophet is a boss in the Temple of Atal'Hakkar."
Lang["N2_7272"] = "Theka the Martyr is a Zul'Farrak boss who drops the First Mosh'aru Tablet."
Lang["N2_7273"] = "Gahz'rilla is summoned at the pool in Zul'Farrak with the Mallet of Zul'Farrak."
Lang["N2_7358"] = "Amnennar the Coldbringer is the final boss of Razorfen Downs, atop the Spiral of Thorns."
Lang["N2_7795"] = "Hydromancer Velratha patrols near Gahz'rilla's pool in Zul'Farrak."
Lang["N2_7797"] = "Nekrum Gutchewer appears during the Zul'Farrak pyramid stairs event."
Lang["N2_9016"] = "Bael'Gar is a giant magma elemental boss in Blackrock Depths."
Lang["N2_9017"] = "Lord Incendius is a fire elemental boss near the Black Anvil in Blackrock Depths."
Lang["N2_9019"] = "Emperor Dagran Thaurissan is the final boss of Blackrock Depths."
Lang["N2_9543"] = "Ribbly Screwspigot is found in the Grim Guzzler in Blackrock Depths."
Lang["N2_9816"] = "Pyroguard Emberseer is imprisoned in Upper Blackrock Spire and must be freed before he can be killed."
Lang["Q1_1013"] = "The Book of Ur"
Lang["Q1_1014"] = "Arugal Must Die"
Lang["Q1_1048"] = "Into The Scarlet Monastery"
Lang["Q1_1049"] = "Compendium of the Fallen"
Lang["Q1_1050"] = "Mythology of the Titans"
Lang["Q1_1051"] = "Vorrel's Revenge"
Lang["Q1_1052"] = "Down the Scarlet Path"
Lang["Q1_1053"] = "In the Name of the Light"
Lang["Q1_1098"] = "Deathstalkers in Shadowfang"
Lang["Q1_1100"] = "Lonebrow's Journal"
Lang["Q1_1101"] = "The Crone of the Kraul"
Lang["Q1_1102"] = "A Vengeful Fate"
Lang["Q1_1109"] = "Going, Going, Guano!"
Lang["Q1_1113"] = "Hearts of Zeal"
Lang["Q1_1139"] = "The Lost Tablets of Will"
Lang["Q1_1142"] = "Mortality Wanes"
Lang["Q1_1144"] = "Willix the Importer"
Lang["Q1_1149"] = "Test of Faith"
Lang["Q1_1150"] = "Test of Endurance"
Lang["Q1_1151"] = "Test of Strength"
Lang["Q1_1152"] = "Test of Lore"
Lang["Q1_1154"] = "Test of Lore"
Lang["Q1_1159"] = "Test of Lore"
Lang["Q1_1160"] = "Test of Lore"
Lang["Q1_1198"] = "In Search of Thaelrid"
Lang["Q1_1199"] = "Twilight Falls"
Lang["Q1_12"] = "The People's Militia"
Lang["Q1_1200"] = "Blackfathom Villainy"
Lang["Q1_1221"] = "Blueleaf Tubers"
Lang["Q1_1275"] = "Researching the Corruption"
Lang["Q1_13"] = "The People's Militia"
Lang["Q1_132"] = "The Defias Brotherhood"
Lang["Q1_135"] = "The Defias Brotherhood"
Lang["Q1_1360"] = "Reclaimed Treasures"
Lang["Q1_1394"] = "Final Passage"
Lang["Q1_14"] = "The People's Militia"
Lang["Q1_141"] = "The Defias Brotherhood"
Lang["Q1_142"] = "The Defias Brotherhood"
Lang["Q1_1424"] = "Pool of Tears"
Lang["Q1_1429"] = "The Atal'ai Exile"
Lang["Q1_1444"] = "Return to Fel'Zerul"
Lang["Q1_1445"] = "The Temple of Atal'Hakkar"
Lang["Q1_1446"] = "Jammal'an the Prophet"
Lang["Q1_1475"] = "Into The Temple of Atal'Hakkar"
Lang["Q1_1486"] = "Deviate Hides"
Lang["Q1_1487"] = "Deviate Eradication"
Lang["Q1_1489"] = "Hamuul Runetotem"
Lang["Q1_1490"] = "Nara Wildmane"
Lang["Q1_1491"] = "Smart Drinks"
Lang["Q1_155"] = "The Defias Brotherhood"
Lang["Q1_166"] = "The Defias Brotherhood"
Lang["Q1_167"] = "Oh Brother..."
Lang["Q1_168"] = "Collecting Memories"
Lang["Q1_17"] = "Uldaman Reagent Run"
Lang["Q1_2040"] = "Underground Assault"
Lang["Q1_2041"] = "Speak with Shoni"
Lang["Q1_214"] = "Red Silk Bandanas"
Lang["Q1_2200"] = "Back to Uldaman"
Lang["Q1_2201"] = "Find the Gems"
Lang["Q1_2202"] = "Uldaman Reagent Run"
Lang["Q1_2204"] = "Restoring the Necklace"
Lang["Q1_2240"] = "The Hidden Chamber"
Lang["Q1_2278"] = "The Platinum Discs"
Lang["Q1_2279"] = "The Platinum Discs"
Lang["Q1_2280"] = "The Platinum Discs"
Lang["Q1_2283"] = "Necklace Recovery"
Lang["Q1_2284"] = "Necklace Recovery, Take 2"
Lang["Q1_2339"] = "Find the Gems and Power Source"
Lang["Q1_2342"] = "Reclaimed Treasures"
Lang["Q1_2398"] = "The Lost Dwarves"
Lang["Q1_2418"] = "Power Stones"
Lang["Q1_261"] = "Down the Scarlet Path"
Lang["Q1_2768"] = "Divino-matic Rod"
Lang["Q1_2770"] = "Gahz'rilla"
Lang["Q1_2841"] = "Rig Wars"
Lang["Q1_2842"] = "Chief Engineer Scooty"
Lang["Q1_2843"] = "Gnomer-gooooone!"
Lang["Q1_2846"] = "Tiara of the Deep"
Lang["Q1_2865"] = "Scarab Shells"
Lang["Q1_2904"] = "A Fine Mess"
Lang["Q1_2922"] = "Save Techbot's Brain!"
Lang["Q1_2923"] = "Tinkmaster Overspark"
Lang["Q1_2924"] = "Essential Artificials"
Lang["Q1_2926"] = "Gnogaine"
Lang["Q1_2927"] = "The Day After"
Lang["Q1_2928"] = "Gyrodrillmatic Excavationators"
Lang["Q1_2929"] = "The Grand Betrayal"
Lang["Q1_2933"] = "Venom Bottles"
Lang["Q1_2934"] = "Undamaged Venom Sac"
Lang["Q1_2935"] = "Consult Master Gadrin"
Lang["Q1_2936"] = "The Spider God"
Lang["Q1_2991"] = "Nekrum's Medallion"
Lang["Q1_3042"] = "Troll Temper"
Lang["Q1_3341"] = "Bring the End"
Lang["Q1_3369"] = "In Nightmares"
Lang["Q1_3373"] = "The Essence of Eranikus"
Lang["Q1_3380"] = "The Sunken Temple"
Lang["Q1_3444"] = "The Stone Circle"
Lang["Q1_3445"] = "The Sunken Temple"
Lang["Q1_3446"] = "Into the Depths"
Lang["Q1_3447"] = "Secret of the Circle"
Lang["Q1_3520"] = "Screecher Spirits"
Lang["Q1_3523"] = "Scourge of the Downs"
Lang["Q1_3525"] = "Extinguishing the Idol"
Lang["Q1_3527"] = "The Prophecy of Mosh'aru"
Lang["Q1_3528"] = "The God Hakkar"
Lang["Q1_3636"] = "Bring the Light"
Lang["Q1_373"] = "The Unsent Letter"
Lang["Q1_377"] = "Crime and Punishment"
Lang["Q1_386"] = "What Comes Around..."
Lang["Q1_387"] = "Quell The Uprising"
Lang["Q1_388"] = "The Color of Blood"
Lang["Q1_389"] = "Bazil Thredd"
Lang["Q1_3906"] = "Disharmony of Flame"
Lang["Q1_3907"] = "Disharmony of Fire"
Lang["Q1_391"] = "The Stockade Riots"
Lang["Q1_3981"] = "Commander Gor'shak"
Lang["Q1_4001"] = "What Is Going On?"
Lang["Q1_4002"] = "The Eastern Kingdoms"
Lang["Q1_4003"] = "The Royal Rescue"
Lang["Q1_4004"] = "The Princess Saved?"
Lang["Q1_4024"] = "A Taste of Flame"
Lang["Q1_4063"] = "The Rise of the Machines"
Lang["Q1_4081"] = "KILL ON SIGHT: Dark Iron Dwarves"
Lang["Q1_4082"] = "KILL ON SIGHT: High Ranking Dark Iron Officials"
Lang["Q1_4123"] = "The Heart of the Mountain"
Lang["Q1_4126"] = "Hurley Blackbreath"
Lang["Q1_4134"] = "Lost Thunderbrew Recipe"
Lang["Q1_4136"] = "Ribbly Screwspigot"
Lang["Q1_4201"] = "The Love Potion"
Lang["Q1_4262"] = "Overmaster Pyron"
Lang["Q1_4263"] = "Incendius!"
Lang["Q1_4286"] = "The Good Stuff"
Lang["Q1_4341"] = "Kharan Mighthammer"
Lang["Q1_4342"] = "Kharan's Tale"
Lang["Q1_4361"] = "The Bearer of Bad News"
Lang["Q1_4362"] = "The Fate of the Kingdom"
Lang["Q1_4363"] = "The Princess's Surprise"
Lang["Q1_4701"] = "Put Her Down"
Lang["Q1_4724"] = "The Pack Mistress"
Lang["Q1_4729"] = "Kibler's Exotic Pets"
Lang["Q1_4734"] = "Egg Freezing"
Lang["Q1_4735"] = "Egg Collection"
Lang["Q1_4742"] = "Seal of Ascension"
Lang["Q1_4743"] = "Seal of Ascension"
Lang["Q1_4764"] = "Doomrigger's Clasp"
Lang["Q1_4766"] = "Mayara Brightwing"
Lang["Q1_4768"] = "The Darkstone Tablet"
Lang["Q1_4769"] = "Vivian Lagrave and the Darkstone Tablet"
Lang["Q1_4787"] = "The Ancient Egg"
Lang["Q1_4788"] = "The Final Tablets"
Lang["Q1_4862"] = "En-Ay-Es-Tee-Why"
Lang["Q1_4866"] = "Mother's Milk"
Lang["Q1_4867"] = "Urok Doomhowl"
Lang["Q1_4981"] = "Operative Bijou"
Lang["Q1_4982"] = "Bijou's Belongings"
Lang["Q1_4983"] = "Bijou's Reconnaissance Report"
Lang["Q1_5001"] = "Bijou's Belongings"
Lang["Q1_5002"] = "Message to Maxwell"
Lang["Q1_5047"] = "Finkle Einhorn, At Your Service!"
Lang["Q1_5081"] = "Maxwell's Mission"
Lang["Q1_5089"] = "General Drakkisath's Command"
Lang["Q1_5102"] = "General Drakkisath's Demise"
Lang["Q1_5160"] = "The Matron Protectorate"
Lang["Q1_5212"] = "The Flesh Does Not Lie"
Lang["Q1_5213"] = "The Active Agent"
Lang["Q1_5214"] = "The Great Ezra Grimm"
Lang["Q1_5243"] = "Houses of the Holy"
Lang["Q1_5251"] = "The Archivist"
Lang["Q1_5262"] = "The Truth Comes Crashing Down"
Lang["Q1_5263"] = "Above and Beyond"
Lang["Q1_5282"] = "The Restless Souls"
Lang["Q1_5341"] = "Barov Family Fortune"
Lang["Q1_5342"] = "The Last Barov"
Lang["Q1_5343"] = "Barov Family Fortune"
Lang["Q1_5344"] = "The Last Barov"
Lang["Q1_5382"] = "Doctor Theolen Krastinov, the Butcher"
Lang["Q1_5384"] = "Kirtonos the Herald"
Lang["Q1_5463"] = "Menethil's Gift"
Lang["Q1_5466"] = "The Lich, Ras Frostwhisper"
Lang["Q1_5515"] = "Krastinov's Bag of Horrors"
Lang["Q1_5526"] = "Shards of the Felvine"
Lang["Q1_5529"] = "Plagued Hatchlings"
Lang["Q1_5722"] = "Searching for the Lost Satchel"
Lang["Q1_5723"] = "Testing an Enemy's Strength"
Lang["Q1_5724"] = "Returning the Lost Satchel"
Lang["Q1_5725"] = "The Power to Destroy..."
Lang["Q1_5726"] = "Hidden Enemies"
Lang["Q1_5727"] = "Hidden Enemies"
Lang["Q1_5728"] = "Hidden Enemies"
Lang["Q1_5729"] = "Hidden Enemies"
Lang["Q1_5730"] = "Hidden Enemies"
Lang["Q1_5761"] = "Slaying the Beast"
Lang["Q1_5848"] = "Of Love and Family"
Lang["Q1_6141"] = "Brother Anton"
Lang["Q1_65"] = "The Defias Brotherhood"
Lang["Q1_6521"] = "An Unholy Alliance"
Lang["Q1_6522"] = "An Unholy Alliance"
Lang["Q1_6561"] = "Blackfathom Villainy"
Lang["Q1_6562"] = "Trouble in the Deeps"
Lang["Q1_6563"] = "The Essence of Aku'Mai"
Lang["Q1_6564"] = "Allegiance to the Old Gods"
Lang["Q1_6565"] = "Allegiance to the Old Gods"
Lang["Q1_6626"] = "A Host of Evil"
Lang["Q1_6627"] = "Test of Lore"
Lang["Q1_6628"] = "Test of Lore"
Lang["Q1_6921"] = "Amongst the Ruins"
Lang["Q1_6922"] = "Baron Aquanis"
Lang["Q1_6981"] = "The Glowing Shard"
Lang["Q1_7028"] = "Twisted Evils"
Lang["Q1_7029"] = "Vyletongue Corruption"
Lang["Q1_7041"] = "Vyletongue Corruption"
Lang["Q1_7044"] = "Legends of Maraudon"
Lang["Q1_7046"] = "The Scepter of Celebras"
Lang["Q1_7064"] = "Corruption of Earth and Seed"
Lang["Q1_7065"] = "Corruption of Earth and Seed"
Lang["Q1_7066"] = "Seed of Life"
Lang["Q1_7067"] = "The Pariah's Instructions"
Lang["Q1_7068"] = "Shadowshard Fragments"
Lang["Q1_7070"] = "Shadowshard Fragments"
Lang["Q1_709"] = "Solution to Doom"
Lang["Q1_721"] = "A Sign of Hope"
Lang["Q1_722"] = "Amulet of Secrets"
Lang["Q1_7441"] = "Pusillin and the Elder Azj'Tordin"
Lang["Q1_7461"] = "The Madness Within"
Lang["Q1_7462"] = "The Treasure of the Shen'dralar"
Lang["Q1_7481"] = "Elven Legends"
Lang["Q1_7482"] = "Elven Legends"
Lang["Q1_7488"] = "Lethtendris's Web"
Lang["Q1_7489"] = "Lethtendris's Web"
Lang["Q1_78916"] = "The Heart of the Void"
Lang["Q1_78917"] = "The Heart of the Void"
Lang["Q1_79987"] = "Return of the Ring"
Lang["Q1_80140"] = "Return of the Ring"
Lang["Q1_80324"] = "The Mad King"
Lang["Q1_80325"] = "The Mad King"
Lang["Q1_865"] = "Raptor Horns"
Lang["Q1_870"] = "The Forgotten Pools"
Lang["Q1_877"] = "The Stagnant Oasis"
Lang["Q1_880"] = "Altered Beings"
Lang["Q1_886"] = "The Barrens Oases"
Lang["Q1_914"] = "Leaders of the Fang"
Lang["Q1_92401"] = "A Frightened Request"
Lang["Q1_92415"] = "Remember That I Love You"
Lang["Q1_92421"] = "Light's Justice"
Lang["Q1_92422"] = "The Wrath of Rath'mael"
Lang["Q1_92742"] = "Testing the Wells"
Lang["Q1_92744"] = "Murloc Gills"
Lang["Q1_92745"] = "The State of the Mines"
Lang["Q1_92747"] = "Moonbrook Espionage"
Lang["Q1_92748"] = "Explosive Consultation"
Lang["Q1_92749"] = "A Dynamite Plan"
Lang["Q1_92750"] = "Detonation at a Distance"
Lang["Q1_92751"] = "Detonation at a Distance"
Lang["Q1_92752"] = "Explosive Consultation"
Lang["Q1_92753"] = "Destruction in Deadmines"
Lang["Q1_95189"] = "Crest of Lordaeron"
Lang["Q1_95195"] = "Bloodied Insignia"
Lang["Q1_95204"] = "Crest of Lordaeron"
Lang["Q1_95216"] = "The New Plague"
Lang["Q1_95250"] = "Abominable Creatures"
Lang["Q1_959"] = "Trouble at the Docks"
Lang["Q1_962"] = "Serpentbloom"
Lang["Q1_96393"] = "Old Ironforge Incursion"
Lang["Q1_96394"] = "The Restless Dead"
Lang["Q1_96395"] = "An Ancient Grudge"
Lang["Q1_96403"] = "Important Heirlooms"
Lang["Q1_971"] = "Knowledge in the Deeps"
Lang["Q1_97288"] = "Unending Torment"
Lang["Q1_98423"] = "The Treaty of Understanding"
Lang["Q2_1013"] = "Bring the Book of Ur to Keeper Bel'dugur in the Undercity."
Lang["Q2_1014"] = "Kill Arugal and bring his head to Dalar Dawnweaver at the Sepulcher."
Lang["Q2_1048"] = "Kill High Inquisitor Whitemane, Scarlet Commander Mograine, Herod, and Houndmaster Loksey, then report to Varimathras in the Undercity."
Lang["Q2_1049"] = "Retrieve the Compendium of the Fallen from the Monastery and return to Sage Truthseeker in Thunder Bluff."
Lang["Q2_1050"] = "Retrieve Mythology of the Titans from the Monastery and bring it to Librarian Mae Paledust in Ironforge."
Lang["Q2_1051"] = "Return Vorrel Sengutz's wedding ring to Monika Sengutz in Tarren Mill."
Lang["Q2_1052"] = "Take Brother Anton's Letter of Commendation to Raleigh the Devout in Southshore."
Lang["Q2_1053"] = "Kill High Inquisitor Whitemane, Scarlet Commander Mograine, Herod, and Houndmaster Loksey, then report to Raleigh the Devout in Southshore."
Lang["Q2_1098"] = "Find the Deathstalker Adamant and Deathstalker Vincent."
Lang["Q2_1100"] = "Read Henrig Lonebrow's Journal."
Lang["Q2_1101"] = "Bring Razorflank's Medallion to Falfindel Waywarder in Thalanaar."
Lang["Q2_1102"] = "Bring Razorflank's Heart to Auld Stonespire in Thunder Bluff."
Lang["Q2_1109"] = "Bring 1 pile of Kraul Guano to Master Apothecary Faranell in the Undercity."
Lang["Q2_1113"] = "Master Apothecary Faranell in the Undercity wants 20 Hearts of Zeal."
Lang["Q2_1139"] = "Find the Tablet of Will and return it to Advisor Belgrum in Ironforge."
Lang["Q2_1142"] = "Find and return Treshala's Pendant to Treshala Fallowbrook in Darnassus."
Lang["Q2_1144"] = "Escort Willix the Importer out of Razorfen Kraul."
Lang["Q2_1149"] = "If you have faith, leap from the planks overlooking Thousand Needles."
Lang["Q2_1150"] = "Bring Grenka's Claw to Dorn Plainstalker in Thousand Needles."
Lang["Q2_1151"] = "Bring Fragments of Rok'Alim to Dorn Plainstalker in Thousand Needles."
Lang["Q2_1152"] = "Find Braug Dimspirit near the entrance to Talondeep Path in Stonetalon Mountains."
Lang["Q2_1154"] = "Find the Legacy of the Aspects and return it to Braug Dimspirit near the entrance to Talondeep Path in Stonetalon Mountains."
Lang["Q2_1159"] = "Find Parqual Fintallas in Undercity."
Lang["Q2_1160"] = "Find The Beginnings of the Undead Threat, and return it to Parqual Fintallas in Undercity."
Lang["Q2_1198"] = "Seek out Argent Guard Thaelrid in Blackfathom Deeps."
Lang["Q2_1199"] = "Bring 10 Twilight Pendants to Argent Guard Manados in Darnassus."
Lang["Q2_12"] = "Gryan Stoutmantle wants you to kill 15 Defias Trappers and 15 Defias Smugglers then return to him on Sentinel Hill."
Lang["Q2_1200"] = "Bring the head of Twilight Lord Kelris to Dawnwatcher Selgorm in Darnassus."
Lang["Q2_1221"] = "Bring 6 Blueleaf Tubers to Mebok Mizzyrix in Ratchet."
Lang["Q2_1275"] = "Gershala Nightwhisper in Auberdine wants 8 Corrupt Brain stems."
Lang["Q2_13"] = "Gryan Stoutmantle wants you to kill 15 Defias Pillagers and 15 Defias Looters and return to him on Sentinel Hill."
Lang["Q2_132"] = "Take Wiley's Note to Gryan Stoutmantle in Westfall."
Lang["Q2_135"] = "Take Wiley's Note to Mathias Shaw in Stormwind."
Lang["Q2_1360"] = "Get Krom Stoutarm's treasure from the North Common Hall and bring it to Ironforge."
Lang["Q2_1394"] = "Speak to Dorn Plainstalker in Thousand Needles."
Lang["Q2_14"] = "Gryan Stoutmantle wants you to kill 15 Defias Highwaymen, 5 Defias Pathstalkers and 5 Defias Knuckledusters then return to him on Sentinel Hill."
Lang["Q2_141"] = "Take Shaw's report to Gryan Stoutmantle in Westfall."
Lang["Q2_142"] = "Track down the Defias Messenger in Westfall and bring his message to Stoutmantle."
Lang["Q2_1424"] = "Fel'Zerul in Stonard wants you to gather 10 Atal'ai Artifacts."
Lang["Q2_1429"] = "Bring the Bundle of Atal'ai Artifacts to the Atal'ai Exile in the Hinterlands."
Lang["Q2_1444"] = "Return to Fel'Zerul in Stonard."
Lang["Q2_1445"] = "Collect 20 Fetishes of Hakkar and bring them to Fel'Zerul in Stonard."
Lang["Q2_1446"] = "The Atal'ai Exile in the Hinterlands wants the Head of Jammal'an."
Lang["Q2_1475"] = "Gather 10 Atal'ai Tablets for Brohann Caskbelly in Stormwind."
Lang["Q2_1486"] = "Nalpak wants 20 Deviate Hides."
Lang["Q2_1487"] = "Ebru wants you to kill 7 Deviate Ravagers, Vipers, Shamblers and Dreadfangs."
Lang["Q2_1489"] = "Speak with Hamuul Runetotem on the Elder Rise in Thunder Bluff."
Lang["Q2_1490"] = "Speak with Nara Wildmane in Thunder Bluff."
Lang["Q2_1491"] = "Bring 6 portions of Wailing Essence to Mebok Mizzyrix in Ratchet."
Lang["Q2_155"] = "Escort the Defias Traitor to the secret hideout of the Defias Brotherhood. Once the Defias Traitor shows you where VanCleef and his men are hiding out, return to Gryan Stoutmantle with the information."
Lang["Q2_166"] = "Kill Edwin VanCleef and bring his head to Gryan Stoutmantle."
Lang["Q2_167"] = "Bring Foreman Thistlenettle's Explorers' League Badge to Wilder Thistlenettle in Stormwind."
Lang["Q2_168"] = "Retrieve 4 Miners' Union Cards and return them to Wilder Thistlenettle in Stormwind."
Lang["Q2_17"] = "Bring 12 Magenta Fungus Caps to Ghak Healtouch in Thelsamar."
Lang["Q2_2040"] = "Retrieve the Gnoam Sprecklesprocket from the Deadmines and return it to Shoni the Shilent in Stormwind."
Lang["Q2_2041"] = "Speak with Shoni the Shilent in Stormwind."
Lang["Q2_214"] = "Scout Riell at the Sentinel Hill Tower wants you to bring her 10 Red Silk Bandanas."
Lang["Q2_2200"] = "Search for clues to the shattered necklace in Uldaman."
Lang["Q2_2201"] = "Find the ruby, sapphire and topaz in Uldaman."
Lang["Q2_2202"] = "Bring 12 Magenta Fungus Caps to Jarkal Mossmeld in Kargath."
Lang["Q2_2204"] = "Obtain a power source from the strongest construct in Uldaman and deliver it to Talvash in Ironforge."
Lang["Q2_2240"] = "Read Baelog's Journal, explore the hidden chamber, then report to Prospector Stormpike."
Lang["Q2_2278"] = "Speak with the stone watcher and learn what you can, then activate the Discs of Norgannon."
Lang["Q2_2279"] = "Take the miniature platinum discs to the Explorers' League in Ironforge."
Lang["Q2_2280"] = "Take the miniature platinum discs to someone interested in them in Thunder Bluff."
Lang["Q2_2283"] = "Look for a valuable necklace in the Uldaman dig site and bring it to Dran Droffers in Orgrimmar."
Lang["Q2_2284"] = "Find a clue as to the gems' whereabouts in the depths of Uldaman."
Lang["Q2_2339"] = "Recover all three gems and a power source from Uldaman; bring them to Jarkal in Kargath."
Lang["Q2_2342"] = "Get the Garrett Family Treasure from the South Common Hall and bring it to Undercity."
Lang["Q2_2398"] = "Find Baelog in Uldaman."
Lang["Q2_2418"] = "Bring 8 Dentrium Power Stones and 8 An'Alleum Power Stones to Rigglefuzz in the Badlands."
Lang["Q2_261"] = "Destroy 30 Undead Ravagers, then return to Brother Anton at Nijel's Point."
Lang["Q2_2768"] = "Bring the Divino-matic Rod to Chief Engineer Bilgewhizzle in Gadgetzan."
Lang["Q2_2770"] = "Bring Gahz'rilla's Electrified Scale to Wizzle Brassbolts in the Shimmering Flats."
Lang["Q2_2841"] = "Retrieve the Rig Blueprints and Thermaplugg's Safe Combination from Gnomeregan for Nogg in Orgrimmar."
Lang["Q2_2842"] = "Speak with Scooty in Booty Bay."
Lang["Q2_2843"] = "Wait for Scooty to calibrate the Goblin Transponder."
Lang["Q2_2846"] = "Bring the Tiara of the Deep to Tabetha in Dustwallow Marsh."
Lang["Q2_2865"] = "Bring 5 Uncracked Scarab Shells to Tran'rek in Gadgetzan."
Lang["Q2_2904"] = "Escort Kernobee to the Clockwerk Run exit, then report to Scooty in Booty Bay."
Lang["Q2_2922"] = "Bring Techbot's Memory Core to Tinkmaster Overspark in Ironforge."
Lang["Q2_2923"] = "Speak with Tinkmaster Overspark in Ironforge."
Lang["Q2_2924"] = "Bring 12 Essential Artificials to Klockmort Spannerspan in Ironforge."
Lang["Q2_2926"] = "Collect radioactive fallout with the Empty Leaden Collection Phial and return it to Ozzie Togglevolt."
Lang["Q2_2927"] = "Speak with Ozzie Togglevolt in Kharanos."
Lang["Q2_2928"] = "Bring 24 Robo-mechanical Guts to Shoni in Stormwind."
Lang["Q2_2929"] = "Venture to Gnomeregan and kill Mekgineer Thermaplugg. Return to High Tinker Mekkatorque."
Lang["Q2_2933"] = "Bring a Venom Bottle to an apothecary in Tarren Mill."
Lang["Q2_2934"] = "Bring an Undamaged Venom Sac to Apothecary Lydon in Tarren Mill."
Lang["Q2_2935"] = "Speak with Master Gadrin in Sen'jin Village."
Lang["Q2_2936"] = "Read from the Tablet of Theka to learn the name of the Witherbark spider god, then return to Master Gadrin."
Lang["Q2_2991"] = "Bring Nekrum's Medallion to Thadius Grimshade in the Blasted Lands."
Lang["Q2_3042"] = "Bring 20 Vials of Troll Temper to Trenton Lighthammer in Gadgetzan."
Lang["Q2_3341"] = "Andrew Brownell wants you to kill Amnennar the Coldbringer and return his skull."
Lang["Q2_3369"] = "Bring the Nightmare Shard to Hamuul Runetotem on the Elder Rise."
Lang["Q2_3373"] = "Place the Essence of Eranikus in the Essence Font located in this lair in the Sunken Temple."
Lang["Q2_3380"] = "Find Marvon Rivetseeker in Tanaris."
Lang["Q2_3444"] = "Retrieve the Stone Circle from Marvon Rivetseeker's workshop in Ratchet."
Lang["Q2_3445"] = "Find Marvon Rivetseeker in Tanaris."
Lang["Q2_3446"] = "Find the Altar of Hakkar in the Sunken Temple in Swamp of Sorrows."
Lang["Q2_3447"] = "Travel to the Sunken Temple and discover the secret hidden in the circle of statues."
Lang["Q2_3520"] = "Capture the spirits of 3 screechers in Feralas, then return to Yeh'kinya in Steamwheedle Port."
Lang["Q2_3523"] = "Speak with Belnistrasz and hand the Oathstone back to him if you agree to aid him."
Lang["Q2_3525"] = "Protect Belnistrasz while he performs the ritual to shut down the Quilboar idol."
Lang["Q2_3527"] = "Bring the First and Second Mosh'aru Tablets to Yeh'kinya in Tanaris."
Lang["Q2_3528"] = "Bring the Filled Egg of Hakkar to Yeh'kinya in Tanaris."
Lang["Q2_3636"] = "Archbishop Benedictus wants you to slay Amnennar the Coldbringer in Razorfen Downs."
Lang["Q2_373"] = "Deliver the Letter to the City Architect to Baros Alexston in Stormwind."
Lang["Q2_377"] = "Bring the hand of Dextren Ward to Councilman Millstipe in Darkshire."
Lang["Q2_386"] = "Bring the head of Targorr the Dread to Guard Berton in Lakeshire."
Lang["Q2_387"] = "Warden Thelwater wants you to kill 10 Defias Prisoners, 8 Defias Convicts and 8 Defias Insurgents."
Lang["Q2_388"] = "Nikova Raskol in Stormwind wants 10 Red Wool Bandanas."
Lang["Q2_389"] = "Speak with Warden Thelwater in the Stockade."
Lang["Q2_3906"] = "Travel to the quarry near Blackrock Depths and slay Overmaster Pyron. Return to Thunderheart when the task is complete."
Lang["Q2_3907"] = "Enter Blackrock Depths and track down Lord Incendius. Slay him and bring any information you find to Thunderheart."
Lang["Q2_391"] = "Kill Bazil Thredd and bring his head back to Warden Thelwater."
Lang["Q2_3981"] = "Find Commander Gor'shak in Blackrock Depths."
Lang["Q2_4001"] = "Find out from Kharan Mighthammer what he knows about Princess Moira. Take that information to Thrall in Orgrimmar."
Lang["Q2_4002"] = "Speak with Thrall if you are prepared to take on the mission he has planned."
Lang["Q2_4003"] = "Slay Emperor Dagran Thaurissan and free Princess Moira Bronzebeard."
Lang["Q2_4004"] = "Return to Thrall!"
Lang["Q2_4024"] = "Travel to Blackrock Depths and slay Bael'Gar. Return Encased Fiery Essence to Cyrus Therepentous."
Lang["Q2_4063"] = "Find and slay Golem Lord Argelmach. Return his head to Lotwil. You will also need to collect 10 Intact Elemental Cores from the Ragereaver Golems."
Lang["Q2_4081"] = "Venture to Blackrock Depths and destroy the vile Dwarves! Warlord Goretooth wants you to kill 15 Anvilrage Guardsmen, 10 Anvilrage Wardens and 5 Anvilrage Footmen."
Lang["Q2_4082"] = "Venture to Blackrock Depths and destroy the vile Dwarves! Warlord Goretooth wants you to kill 10 Anvilrage Medics, 10 Anvilrage Soldiers and 10 Anvilrage Officers."
Lang["Q2_4123"] = "Bring the Heart of the Mountain to Maxwort Uberglint in the Burning Steppes."
Lang["Q2_4126"] = "Bring the Lost Thunderbrew Recipe to Ragnar Thunderbrew."
Lang["Q2_4134"] = "Bring the Lost Thunderbrew Recipe to Vivian Lagrave."
Lang["Q2_4136"] = "Bring Ribbly's Head to Yuka Screwspigot in the Burning Steppes."
Lang["Q2_4201"] = "Bring 4 Gromsblood, 10 Giant Silver Veins and Nagmara's Filled Vial to Mistress Nagmara in Blackrock Depths."
Lang["Q2_4262"] = "Slay Overmaster Pyron and return to Jalinda Sprig."
Lang["Q2_4263"] = "Find Lord Incendius in Blackrock Depths and destroy him!"
Lang["Q2_4286"] = "Travel to Blackrock Depths and recover 20 Dark Iron Fanny Packs."
Lang["Q2_4341"] = "Travel to Blackrock Depths and find Kharan Mighthammer."
Lang["Q2_4342"] = "Listen as Kharan Mighthammer tells his story."
Lang["Q2_4361"] = "Return to Ironforge and speak with King Magni Bronzebeard."
Lang["Q2_4362"] = "Return to Blackrock Depths and rescue Princess Moira Bronzebeard from the evil Emperor Dagran Thaurissan."
Lang["Q2_4363"] = "Return to King Magni Bronzebeard in Ironforge and give him the good news."
Lang["Q2_4701"] = "Slay Halycon, the worg pack mistress in Lower Blackrock Spire, then return to Helendis Riverhorn."
Lang["Q2_4724"] = "Slay Halycon, pack mistress of the Bloodaxe worg, then return to Galamav the Marksman."
Lang["Q2_4729"] = "Capture a Bloodaxe Worg Pup in Lower Blackrock Spire and bring the Caged Worg Pup to Kibler."
Lang["Q2_4734"] = "Use the Eggscilloscope Prototype on an egg in the Rookery."
Lang["Q2_4735"] = "Bring 8 Collected Dragon Eggs and the Collectronic Module to Tinkee Steamboil."
Lang["Q2_4742"] = "Bring Vaelan the Gemstones of Smolderthorn, Spirestone, and Bloodaxe, along with the Unadorned Seal of Ascension."
Lang["Q2_4743"] = "Break Emberstrife in Dustwallow Marsh and temper the Unforged Seal of Ascension in the flames of the black dragonflight."
Lang["Q2_4764"] = "Bring Doomrigger's Clasp to Mayara Brightwing in the Burning Steppes."
Lang["Q2_4766"] = "Speak with Mayara Brightwing in the Burning Steppes."
Lang["Q2_4768"] = "Bring the Darkstone Tablet to Shadowmage Vivian Lagrave in Kargath."
Lang["Q2_4769"] = "Speak with Shadowmage Vivian Lagrave."
Lang["Q2_4787"] = "Bring the Ancient Egg to Yeh'kinya in Tanaris."
Lang["Q2_4788"] = "Bring the Fifth and Sixth Mosh'aru Tablets to Prospector Ironboot in Tanaris."
Lang["Q2_4862"] = "Collect 15 Spire Spider Eggs in Lower Blackrock Spire for Kibler."
Lang["Q2_4866"] = "Get Mother Smolderweb to poison you, then return to Ragged John so he can milk the venom."
Lang["Q2_4867"] = "Read Warosh's Scroll, defeat Urok Doomhowl, and bring Warosh's Mojo to Warosh."
Lang["Q2_4981"] = "Travel to Lower Blackrock Spire and find out what happened to Bijou."
Lang["Q2_4982"] = "Find Bijou's Belongings on the bottom floor of the city and return them to her."
Lang["Q2_4983"] = "Take Bijou's reconnaissance report back to Lexlort in Kargath."
Lang["Q2_5001"] = "Find Bijou's Belongings and return them to her."
Lang["Q2_5002"] = "Take Bijou's Information to Marshal Maxwell in the Burning Steppes."
Lang["Q2_5047"] = "Talk to Malyfous Darkhammer in Everlook."
Lang["Q2_5081"] = "Destroy War Master Voone, Highlord Omokk, and Overlord Wyrmthalak, then return to Marshal Maxwell."
Lang["Q2_5089"] = "Take General Drakkisath's Command to Marshal Maxwell in the Burning Steppes."
Lang["Q2_5102"] = "Destroy General Drakkisath in Upper Blackrock Spire, then return to Marshal Maxwell."
Lang["Q2_5160"] = "Take Awbee's Scale to Haleh in Winterspring."
Lang["Q2_5212"] = "Recover 10 Plagued Flesh Samples from Stratholme and return them to Betina Bigglezink."
Lang["Q2_5213"] = "Travel to Stratholme and search the ziggurats. Find and return new Scourge Data to Betina Bigglezink."
Lang["Q2_5214"] = "Find Ezra Grimm's smoke shop in Stratholme and recover a box of Grimm's Premium Tobacco for Smokey LaRue."
Lang["Q2_5243"] = "Travel to Stratholme, in the north. Search the supply crates that permeate the city and recover 5 Stratholme Holy Water. Return to Leonid Barthalomew the Revered when you have collected enough of the blessed fluid."
Lang["Q2_5251"] = "Travel to Stratholme and find Archivist Galford of the Scarlet Crusade. Destroy him and burn the Scarlet Archive."
Lang["Q2_5262"] = "Take the Head of Balnazzar to Duke Nicholas Zverenhoff at Light's Hope Chapel."
Lang["Q2_5263"] = "Venture to Stratholme and destroy Baron Rivendare. Take his head and return to Duke Nicholas Zverenhoff."
Lang["Q2_5282"] = "Use Egan's Blaster on the ghostly and spectral citizens of Stratholme. When the restless souls break free of their ghostly shells, feed them again - free 15 souls and return to Egan."
Lang["Q2_5341"] = "Venture to Scholomance and recover the Barov family fortune. Four deeds make up this fortune. Return to Alexi Barov when you have completed this task."
Lang["Q2_5342"] = "Travel to Chillwind Camp - Alliance territory - and assassinate Weldon Barov. Take his head and return to Alexi Barov."
Lang["Q2_5343"] = "Venture to Scholomance and recover the Barov family fortune. Four deeds make up this fortune: The Deed to Caer Darrow; The Deed to Brill; The Deed to Tarren Mill; and The Deed to Southshore. Return to Weldon Barov when you have completed this task."
Lang["Q2_5344"] = "Travel to the Bulwark - Alliance territory - and assassinate Alexi Barov. Take his head and return to Weldon Barov."
Lang["Q2_5382"] = "Find Doctor Theolen Krastinov inside Scholomance. Destroy him, then burn the Remains of Eva Sarkhoff and the Remains of Lucien Sarkhoff. Return to Eva Sarkhoff when the task is complete."
Lang["Q2_5384"] = "Return to Scholomance with the Blood of Innocents. Find the porch and place the Blood of Innocents in the brazier. Kirtonos will come to feast upon your soul. Fight valiantly, do not give an inch! Destroy Kirtonos and return to Eva Sarkhoff."
Lang["Q2_5463"] = "Travel to Stratholme and find Menethil's Gift. Place the Keepsake of Remembrance upon the unholy ground."
Lang["Q2_5466"] = "Find Ras Frostwhisper in Scholomance. Use the Soulbound Keepsake on his undead form. Should you succeed, destroy the mortal Ras Frostwhisper and bring his Human Head to Magistrate Marduke."
Lang["Q2_5515"] = "Locate Jandice Barov in Scholomance and destroy her. Recover Krastinov's Bag of Horrors from her corpse. Return to Eva Sarkhoff."
Lang["Q2_5526"] = "Find a Felvine Shard in Dire Maul East, seal it in a Reliquary of Purity, and return to Rabine Saturna."
Lang["Q2_5529"] = "Kill 20 Plagued Hatchlings, then return to Betina Bigglezink at the Light's Hope Chapel."
Lang["Q2_5722"] = "Search Ragefire Chasm for Maur Grimtotem's corpse and search it for any items of interest."
Lang["Q2_5723"] = "Search Orgrimmar for Ragefire Chasm, then kill 8 Ragefire Troggs and 8 Ragefire Shaman before returning to Rahauro in Thunder Bluff."
Lang["Q2_5724"] = "Take the Grimtotem Satchel to Rahauro in Thunder Bluff."
Lang["Q2_5725"] = "Bring the books Spells of Shadow and Incantations from the Nether to Varimathras in Undercity."
Lang["Q2_5726"] = "Bring a Lieutenant's Insignia to Thrall in Orgrimmar."
Lang["Q2_5727"] = "Take the Lieutenant's Insignia to Neeru Fireblade and speak to him. Gauge if he believes you are a member of the Burning Blade and then return to Thrall in Orgrimmar."
Lang["Q2_5728"] = "Kill Bazzalan and Jergosh the Invoker before returning to Thrall in Orgrimmar."
Lang["Q2_5729"] = "Speak to Neeru Fireblade in Orgrimmar."
Lang["Q2_5730"] = "Speak to Thrall in Orgrimmar and tell him what you've learned."
Lang["Q2_5761"] = "Enter Ragefire Chasm and slay Taragaman the Hungerer, then bring his heart back to Neeru Fireblade in Orgrimmar."
Lang["Q2_5848"] = "Travel to Stratholme, in the northern part of the Plaguelands. Find the painting 'Of Love and Family' in the Scarlet Bastion and bring it back to Tirion Fordring."
Lang["Q2_6141"] = "Speak with Brother Anton in Desolace."
Lang["Q2_65"] = "Gryan Stoutmantle wants you to talk to Wiley in Lakeshire."
Lang["Q2_6521"] = "Bring Ambassador Malcin's Head to Varimathras in the Undercity."
Lang["Q2_6522"] = "Take the Small Scroll to Varimathras in the Undercity."
Lang["Q2_6561"] = "Bring the head of Twilight Lord Kelris to Bashana Runetotem in Thunder Bluff."
Lang["Q2_6562"] = "Speak with Je'neu Sancrea at Zoram'gar Outpost in Ashenvale."
Lang["Q2_6563"] = "Bring 20 Sapphires of Aku'Mai to Je'neu Sancrea at Zoram'gar Outpost."
Lang["Q2_6564"] = "Bring the Damp Note to Je'neu Sancrea at Zoram'gar Outpost."
Lang["Q2_6565"] = "Kill Lorgus Jett in Blackfathom Deeps and then return to Je'neu Sancrea."
Lang["Q2_6626"] = "Kill 8 Razorfen Battleguard, 8 Razorfen Thornweavers, and 8 Death's Head Cultists; return to Myriam Moonsinger."
Lang["Q2_6627"] = "Answer Braug Dimspirit's question successfully and then speak to him again. He will remain in Stonetalon Mountains when you are ready."
Lang["Q2_6628"] = "Answer Parqual Fintallas' question successfully and then speak to him again. He will remain in the Undercity until you are ready."
Lang["Q2_6921"] = "Bring the Fathom Core to Je'neu Sancrea at Zoram'gar Outpost."
Lang["Q2_6922"] = "Bring the Strange Water Globe to Je'neu Sancrea at Zoram'gar Outpost, Ashenvale."
Lang["Q2_6981"] = "Travel to Ratchet to find someone that can tell you more about the glowing shard."
Lang["Q2_7028"] = "Collect 15 Theradric Crystal Carvings for Willow in Desolace."
Lang["Q2_7029"] = "Heal 8 Vylestem Vines using the Coated Cerulean Vial, then return to Vark Battlescar in Shadowprey Village."
Lang["Q2_7041"] = "Heal 8 Vylestem Vines using the Coated Cerulean Vial, then return to Talendria in Nijel's Point."
Lang["Q2_7044"] = "Recover the Celebrian Rod and Celebrian Diamond, then find a way to speak with Celebras."
Lang["Q2_7046"] = "Assist Celebras the Redeemed while he creates the Scepter of Celebras."
Lang["Q2_7064"] = "Slay Princess Theradras and return to Selendra near Shadowprey Village."
Lang["Q2_7065"] = "Slay Princess Theradras and return to Keeper Marandis at Nijel's Point."
Lang["Q2_7066"] = "Seek out Remulos in Moonglade and give him the Seed of Life."
Lang["Q2_7067"] = "Read the Pariah's Instructions, obtain the Amulet of Union from Maraudon, and return it to the Centaur Pariah."
Lang["Q2_7068"] = "Collect 10 Shadowshard Fragments from Maraudon and return them to Uthel'nay in Orgrimmar."
Lang["Q2_7070"] = "Collect 10 Shadowshard Fragments from Maraudon and return them to Archmage Tervosh in Theramore."
Lang["Q2_709"] = "Bring the Tablet of Ryun'eh to Theldurin the Lost."
Lang["Q2_721"] = "Find Hammertoe Grez in Uldaman."
Lang["Q2_722"] = "Find Hammertoe's Amulet and return it to him in Uldaman."
Lang["Q2_7441"] = "Travel to Dire Maul and locate the Imp Pusillin. Convince him to give you Azj'Tordin's Book of Incantations."
Lang["Q2_7461"] = "You must destroy the guardians surrounding the 5 Force Field Pylons that power Immol'thar's prison. Once the Field pylons have powered down, destroy Immol'thar, then confront Prince Tortheldrin."
Lang["Q2_7462"] = "Return to the Athenaeum and claim your treasure from the Treasure of the Shen'dralar. Speak with Shen'dralar Ancient for more information."
Lang["Q2_7481"] = "Search Dire Maul for Kariel Winthalus and report to Sage Korolusk at Camp Mojache."
Lang["Q2_7482"] = "Search Dire Maul for Kariel Winthalus and report to Scholar Runethorn at Feathermoon."
Lang["Q2_7488"] = "Bring Lethtendris's Web to Latronicus Moonspear at Feathermoon Stronghold."
Lang["Q2_7489"] = "Bring Lethtendris's Web to Talo Thornhoof at Camp Mojache."
Lang["Q2_78916"] = "Bring the Blackfathom Pearl to Dawnwatcher Selgorm in Darnassus."
Lang["Q2_78917"] = "Bring the Blackfathom Pearl to Bashana Runetotem in Thunder Bluff."
Lang["Q2_79987"] = "You may keep the ring, or find the person responsible for the imprint and engravings on the inside of the band."
Lang["Q2_80140"] = "You may keep the ring, or find the person responsible for the imprint and engravings on the inside of the band."
Lang["Q2_80324"] = "Bring Thermaplugg's Engineering Notes to High Tinker Mekkatorque at Tinker Town in Ironforge."
Lang["Q2_80325"] = "Bring Thermaplugg's Engineering Notes to Nogg at the Valley of Honor in Orgrimmar."
Lang["Q2_865"] = "Bring 5 Intact Raptor Horns to Mebok Mizzyrix in Ratchet."
Lang["Q2_870"] = "Search the Forgotten Pools northwest of the Crossroads for a source of power, then return to Tonga Runetotem."
Lang["Q2_877"] = "Test the Dried Seeds at the fissure in the Stagnant Oasis southeast of the Crossroads, then return to Tonga Runetotem."
Lang["Q2_880"] = "Bring 8 Altered Snapjaw Shells to Tonga Runetotem at the Crossroads."
Lang["Q2_886"] = "Speak with Tonga Runetotem at the Crossroads."
Lang["Q2_914"] = "Bring the Gems of Cobrahn, Anacondra, Pythas and Serpentis to Nara Wildmane in Thunder Bluff."
Lang["Q2_92401"] = "Investigate the disappearance of Edward Heartweaver in the Ruins of Lordaeron."
Lang["Q2_92415"] = "Bring the Blood-Stained Letter to Orphan Matron Nightingale in Stormwind City."
Lang["Q2_92421"] = "Collect 25 Intact Limbs within The Ruins of Lordaeron for Morbin Lightbane in the Undercity."
Lang["Q2_92422"] = "Kill Rath'mael in the Ruins of Lordaeron for Deathguard Kristof in Brill."
Lang["Q2_92742"] = "Use the Well Water Sample Kit to collect samples from the wells at the Jansen Stead and the Molsen Farm."
Lang["Q2_92744"] = "Collect 7 Longshore Murloc Gills along the shoreline of Westfall for Alba Fairmoon."
Lang["Q2_92745"] = "Slay 4 Kobold Diggers in the Jangolode Mine and 6 Riverpaw Miners in the Gold Coast Quarry."
Lang["Q2_92747"] = "Collect 8 Suspicious Industrial Supplies from Moonbrook."
Lang["Q2_92748"] = "Travel to the Dwarven District in Stormwind and find an engineer who can help."
Lang["Q2_92749"] = "Obtain 10 Coarse Dynamite, then return to Sprite Jumpsprocket in the Dwarven District of Stormwind."
Lang["Q2_92750"] = "Talk to someone in Stormwind Intelligence about acquiring a remote detonator."
Lang["Q2_92751"] = "Bring the Remote Detonator Kit to Sprite Jumpsprocket in the Dwarven District of Stormwind."
Lang["Q2_92752"] = "Return to Alba Fairmoon in Westfall with the Extra-Destructive Explosives."
Lang["Q2_92753"] = "Find the forge hidden in the Deadmines, and plant the Extra-Destructive Explosives nearby. Then, meet up with Alba Fairmoon at the Deadmines exit."
Lang["Q2_95189"] = "Return the Crest of Lordaeron to Lady Dena Kennedy in Stormwind City."
Lang["Q2_95195"] = "Collect 10 Bloodied Insignias and take them to General Marcus Jonathan in Stormwind City."
Lang["Q2_95204"] = "Bring the Crest of Lordaeron to Oran Snakewrithe in Undercity."
Lang["Q2_95216"] = "Collect the Highly Toxic Strain from Witherfang in Ruins of Lordaeron for Theodore Griffs in Undercity."
Lang["Q2_95250"] = "Collect the Head of the Baron in the Ruins of Lordaeron and bring it back to Captain Truman."
Lang["Q2_959"] = "Crane Operator Bigglefuzz in Ratchet wants you to retrieve the bottle of 99-Year-Old Port from Mad Magglish."
Lang["Q2_962"] = "Apothecary Zamah in Thunder Bluff wants 10 Serpentbloom."
Lang["Q2_96393"] = "Enter the Hall of Thanes beneath Old Ironforge and claim the Head of Durgen Dirgehammer. Deliver it to King Magni Bronzebeard."
Lang["Q2_96394"] = "Kill 15 Enraged Apparitions and 10 Tormented Souls in the Hall of Thanes."
Lang["Q2_96395"] = "Put the spirit of Faldrim Anvilmar to rest in the Hall of Thanes."
Lang["Q2_96403"] = "Collect 8 Dwarven Heirlooms from the Hall of Thanes."
Lang["Q2_971"] = "Bring the Lorgalis Manuscript to Gerrig Bonegrip in the Forlorn Cavern of Ironforge."
Lang["Q2_97288"] = "Deliver the Abominable Head to someone within the Undercity."
Lang["Q2_98423"] = "Interact with the Treaty of Understanding tablet in a Reliquary of Kings vault, then deliver it to King Magni Bronzebeard in Ironforge."
Lang["Quillboar"] = "Quillboar"
Lang["Ragefire Chasm"] = "Ragefire Chasm"
Lang["Razorfen Downs"] = "Razorfen Downs"
Lang["Razorfen Kraul"] = "Razorfen Kraul"
Lang["Ruins of Lordaeron"] = "Ruins of Lordaeron"
Lang["Scarlet Monastery"] = "Scarlet Monastery"
Lang["Scholomance Quests"] = "Scholomance Quests"
Lang["Shadowfang Keep"] = "Shadowfang Keep"
Lang["Stonetalon Mountains"] = "Stonetalon Mountains"
Lang["Stranglethorn Vale"] = "Stranglethorn Vale"
Lang["Stratholme"] = "Stratholme"
Lang["The Barrens"] = "The Barrens"
Lang["The Deadmines"] = "The Deadmines"
Lang["The Hall of Thanes"] = "The Hall of Thanes"
Lang["The Hinterlands"] = "The Hinterlands"
Lang["The Stockade"] = "The Stockade"
Lang["Thousand Needles"] = "Thousand Needles"
Lang["Thunder Bluff"] = "Thunder Bluff"
Lang["Uldaman"] = "Uldaman"
Lang["Wailing Caverns"] = "Wailing Caverns"
Lang["Westfall"] = "Westfall"
Lang["Zul'Farrak"] = "Zul'Farrak"

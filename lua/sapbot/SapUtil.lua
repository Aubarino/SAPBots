-- -- -- -- -- -- -- -- -- --
-- S.A.P Bot Utilities -- -- --
-- -- -- -- -- -- -- -- -- --

AddCSLuaFile()
include("sapbot/SapNetwork.lua")
AddCSLuaFile("sapbot/SapNetwork.lua")

-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Actions Override stuff
-- -- -- -- -- -- -- -- -- -- -- -- -- --
function SapActionRegister(actionname,functionBoot,functionAction,info,default)
    SapActionRegister(SapActionRegister,functionBoot,functionAction,info,default,nil)
end
function SapActionRegister(actionname,functionBoot,functionAction,info,default,wsid) --adds a new boot action function and action function to the tables for sap bots
    if (SapActionOverride_Boots == nil) then
        SapActionOverride_Boots = {}
        SapActionOverride_Scripts = {}
        SapActionOverride_WSID = {}
        SapActionOverride_Info = {}
        SapActionOverride_Default = {}
        CurrentAddons = engine.GetAddons() --table of all addons
        CurrentAddonsWsid = {} --table of all addons by its workshop id, can be used as a lookup
        for k,a in pairs(CurrentAddons) do
            CurrentAddonsWsid[a.wsid] = a
        end
    end
    local bootSave = functionBoot
    local actionSave = functionAction
    SapActionOverride_Boots[actionname] = bootSave
    SapActionOverride_Scripts[actionname] = actionSave
    SapActionOverride_WSID[actionname] = wsid
    SapActionOverride_Info[actionname] = info
    SapActionOverride_Default[actionname] = default

    --SapActionOverride_Scripts[actionname]()
    print("S.A.P Bot override action ("..actionname..") registered")
    if (SAPBOTDEBUG) then
        print("Addon load status - "..tostring(GetAddonLoaded(SapActionOverride_WSID[actionname])))
    end
end

--get if an addon is currently loaded
function GetAddonLoaded(wsid)
    if (wsid == nil) then return(true) end --defaults to true if the id is not valid
    if (CurrentAddonsWsid[tostring(wsid)] == nil) then
        return false
    else
        return(CurrentAddonsWsid[tostring(wsid)].mounted)
    end
    --return(CurrentAddonsWsid[tostring(wsid)] != nil)
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- Weapon Holdtype to Animation conversion tables
_SapbotHTcIdleCrouch = {
    ["ar2"] = ACT_HL2MP_IDLE_CROUCH_AR2,
    ["rpg"] = ACT_HL2MP_IDLE_CROUCH_RPG,
    ["smg"] = ACT_HL2MP_IDLE_CROUCH_SMG1,
    ["pistol"] = ACT_HL2MP_IDLE_CROUCH_PISTOL,
    ["crossbow"] = ACT_HL2MP_IDLE_CROUCH_CROSSBOW,
    ["grenade"] = ACT_HL2MP_IDLE_CROUCH_GRENADE,
    ["shotgun"] = ACT_HL2MP_IDLE_CROUCH_SHOTGUN,
    ["physgun"] = ACT_HL2MP_IDLE_CROUCH_PHYSGUN,
    ["melee"] = ACT_HL2MP_IDLE_CROUCH_MELEE,
    ["slam"] = ACT_HL2MP_IDLE_CROUCH_SLAM,
    ["normal"] = ACT_HL2MP_IDLE_CROUCH,
    ["fist"] = ACT_HL2MP_IDLE_CROUCH_FIST,
    ["melee2"] = ACT_HL2MP_IDLE_CROUCH_MELEE2,
    ["passive"] = ACT_HL2MP_IDLE_CROUCH_PASSIVE,
    ["knife"] = ACT_HL2MP_IDLE_CROUCH_KNIFE,
    ["duel"] = ACT_HL2MP_IDLE_CROUCH_DUEL,
    ["camera"] = ACT_HL2MP_IDLE_CROUCH_CAMERA,
    ["magic"] = ACT_HL2MP_IDLE_CROUCH_MAGIC,
    ["magic"] = ACT_HL2MP_IDLE_CROUCH_MAGIC,
    ["revolver"] = ACT_HL2MP_IDLE_CROUCH_REVOLVER
}
_SapbotHTcWalkCrouch = {
    ["ar2"] = ACT_HL2MP_WALK_CROUCH_AR2,
    ["rpg"] = ACT_HL2MP_WALK_CROUCH_RPG,
    ["smg"] = ACT_HL2MP_WALK_CROUCH_SMG1,
    ["pistol"] = ACT_HL2MP_WALK_CROUCH_PISTOL,
    ["crossbow"] = ACT_HL2MP_WALK_CROUCH_CROSSBOW,
    ["grenade"] = ACT_HL2MP_WALK_CROUCH_GRENADE,
    ["shotgun"] = ACT_HL2MP_WALK_CROUCH_SHOTGUN,
    ["physgun"] = ACT_HL2MP_WALK_CROUCH_PHYSGUN,
    ["melee"] = ACT_HL2MP_WALK_CROUCH_MELEE,
    ["slam"] = ACT_HL2MP_WALK_CROUCH_SLAM,
    ["normal"] = ACT_HL2MP_WALK_CROUCH,
    ["fist"] = ACT_HL2MP_WALK_CROUCH_FIST,
    ["melee2"] = ACT_HL2MP_WALK_CROUCH_MELEE2,
    ["passive"] = ACT_HL2MP_WALK_CROUCH_PASSIVE,
    ["knife"] = ACT_HL2MP_WALK_CROUCH_KNIFE,
    ["duel"] = ACT_HL2MP_WALK_CROUCH_DUEL,
    ["camera"] = ACT_HL2MP_WALK_CROUCH_CAMERA,
    ["magic"] = ACT_HL2MP_WALK_CROUCH_MAGIC,
    ["magic"] = ACT_HL2MP_WALK_CROUCH_MAGIC,
    ["revolver"] = ACT_HL2MP_WALK_CROUCH_REVOLVER
}
_SapbotHTcIdle = {
    ["ar2"] = ACT_HL2MP_IDLE_AR2,
    ["rpg"] = ACT_HL2MP_IDLE_RPG,
    ["smg"] = ACT_HL2MP_IDLE_SMG1,
    ["pistol"] = ACT_HL2MP_IDLE_PISTOL,
    ["crossbow"] = ACT_HL2MP_IDLE_CROSSBOW,
    ["grenade"] = ACT_HL2MP_IDLE_GRENADE,
    ["shotgun"] = ACT_HL2MP_IDLE_SHOTGUN,
    ["physgun"] = ACT_HL2MP_IDLE_PHYSGUN,
    ["melee"] = ACT_HL2MP_IDLE_MELEE,
    ["slam"] = ACT_HL2MP_IDLE_SLAM,
    ["normal"] = ACT_HL2MP_IDLE,
    ["fist"] = ACT_HL2MP_IDLE_FIST,
    ["melee2"] = ACT_HL2MP_IDLE_MELEE2,
    ["passive"] = ACT_HL2MP_IDLE_PASSIVE,
    ["knife"] = ACT_HL2MP_IDLE_KNIFE,
    ["duel"] = ACT_HL2MP_IDLE_DUEL,
    ["camera"] = ACT_HL2MP_IDLE_CAMERA,
    ["magic"] = ACT_HL2MP_IDLE_MAGIC,
    ["magic"] = ACT_HL2MP_IDLE_MAGIC,
    ["revolver"] = ACT_HL2MP_IDLE_REVOLVER
}
_SapbotHTcRun = {
    ["ar2"] = ACT_HL2MP_RUN_AR2,
    ["rpg"] = ACT_HL2MP_RUN_RPG,
    ["smg"] = ACT_HL2MP_RUN_SMG1,
    ["pistol"] = ACT_HL2MP_RUN_PISTOL,
    ["crossbow"] = ACT_HL2MP_RUN_CROSSBOW,
    ["grenade"] = ACT_HL2MP_RUN_GRENADE,
    ["shotgun"] = ACT_HL2MP_RUN_SHOTGUN,
    ["physgun"] = ACT_HL2MP_RUN_PHYSGUN,
    ["melee"] = ACT_HL2MP_RUN_MELEE,
    ["slam"] = ACT_HL2MP_RUN_SLAM,
    ["normal"] = ACT_HL2MP_RUN,
    ["fist"] = ACT_HL2MP_RUN_FIST,
    ["melee2"] = ACT_HL2MP_RUN_MELEE2,
    ["passive"] = ACT_HL2MP_RUN_PASSIVE,
    ["knife"] = ACT_HL2MP_RUN_KNIFE,
    ["duel"] = ACT_HL2MP_RUN_DUEL,
    ["camera"] = ACT_HL2MP_RUN_CAMERA,
    ["magic"] = ACT_HL2MP_RUN_MAGIC,
    ["magic"] = ACT_HL2MP_RUN_MAGIC,
    ["revolver"] = ACT_HL2MP_RUN_REVOLVER
}
_SapbotHTcRangeAttack = {
    ["ar2"] = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
    ["rpg"] = ACT_HL2MP_GESTURE_RANGE_ATTACK_RPG,
    ["smg"] = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1,
    ["pistol"] = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
    ["crossbow"] = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW,
    ["grenade"] = ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE,
    ["shotgun"] = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN,
    ["physgun"] = ACT_HL2MP_GESTURE_RANGE_ATTACK_PHYSGUN,
    ["melee"] = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE,
    ["slam"] = ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM,
    ["normal"] = ACT_HL2MP_GESTURE_RANGE_ATTACK,
    ["fist"] = ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST,
    ["melee2"] = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2,
    ["passive"] = ACT_HL2MP_GESTURE_RANGE_ATTACK_PASSIVE,
    ["knife"] = ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE,
    ["duel"] = ACT_HL2MP_GESTURE_RANGE_ATTACK_DUEL,
    ["camera"] = ACT_HL2MP_GESTURE_RANGE_ATTACK_CAMERA,
    ["magic"] = ACT_HL2MP_GESTURE_RANGE_ATTACK_MAGIC,
    ["magic"] = ACT_HL2MP_GESTURE_RANGE_ATTACK_MAGIC,
    ["revolver"] = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER
}
_SapbotHTcReload = {
    ["ar2"] = ACT_HL2MP_GESTURE_RELOAD_AR2,
    ["rpg"] = ACT_HL2MP_GESTURE_RELOAD_RPG,
    ["smg"] = ACT_HL2MP_GESTURE_RELOAD_SMG1,
    ["pistol"] = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
    ["crossbow"] = ACT_HL2MP_GESTURE_RELOAD_CROSSBOW,
    ["grenade"] = ACT_HL2MP_GESTURE_RELOAD_GRENADE,
    ["shotgun"] = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
    ["physgun"] = ACT_HL2MP_GESTURE_RELOAD_PHYSGUN,
    ["melee"] = ACT_HL2MP_GESTURE_RELOAD_MELEE,
    ["slam"] = ACT_HL2MP_GESTURE_RELOAD_SLAM,
    ["normal"] = ACT_HL2MP_GESTURE_RELOAD,
    ["fist"] = ACT_HL2MP_GESTURE_RELOAD_FIST,
    ["melee2"] = ACT_HL2MP_GESTURE_RELOAD_MELEE2,
    ["passive"] = ACT_HL2MP_GESTURE_RELOAD_PASSIVE,
    ["knife"] = ACT_HL2MP_GESTURE_RELOAD_KNIFE,
    ["duel"] = ACT_HL2MP_GESTURE_RELOAD_DUEL,
    ["camera"] = ACT_HL2MP_GESTURE_RELOAD_CAMERA,
    ["magic"] = ACT_HL2MP_GESTURE_RELOAD_MAGIC,
    ["magic"] = ACT_HL2MP_GESTURE_RELOAD_MAGIC,
    ["revolver"] = ACT_HL2MP_GESTURE_RELOAD_REVOLVER
}
_SapbotHTcJump = {
    ["ar2"] = ACT_HL2MP_JUMP_AR2,
    ["rpg"] = ACT_HL2MP_JUMP_RPG,
    ["smg"] = ACT_HL2MP_JUMP_SMG1,
    ["pistol"] = ACT_HL2MP_JUMP_PISTOL,
    ["crossbow"] = ACT_HL2MP_JUMP_CROSSBOW,
    ["grenade"] = ACT_HL2MP_JUMP_GRENADE,
    ["shotgun"] = ACT_HL2MP_JUMP_SHOTGUN,
    ["physgun"] = ACT_HL2MP_JUMP_PHYSGUN,
    ["melee"] = ACT_HL2MP_JUMP_MELEE,
    ["slam"] = ACT_HL2MP_JUMP_SLAM,
    ["normal"] = ACT_HL2MP_JUMP,
    ["fist"] = ACT_HL2MP_JUMP_FIST,
    ["melee2"] = ACT_HL2MP_JUMP_MELEE2,
    ["passive"] = ACT_HL2MP_JUMP_PASSIVE,
    ["knife"] = ACT_HL2MP_JUMP_KNIFE,
    ["duel"] = ACT_HL2MP_JUMP_DUEL,
    ["camera"] = ACT_HL2MP_JUMP_CAMERA,
    ["magic"] = ACT_HL2MP_JUMP_MAGIC,
    ["magic"] = ACT_HL2MP_JUMP_MAGIC,
    ["revolver"] = ACT_HL2MP_JUMP_REVOLVER
}
_SapbotHTcIdleSwim = {
    ["ar2"] = ACT_HL2MP_SWIM_IDLE_AR2,
    ["rpg"] = ACT_HL2MP_SWIM_IDLE_RPG,
    ["smg"] = ACT_HL2MP_SWIM_IDLE_SMG1,
    ["pistol"] = ACT_HL2MP_SWIM_IDLE_PISTOL,
    ["crossbow"] = ACT_HL2MP_SWIM_IDLE_CROSSBOW,
    ["grenade"] = ACT_HL2MP_SWIM_IDLE_GRENADE,
    ["shotgun"] = ACT_HL2MP_SWIM_IDLE_SHOTGUN,
    ["physgun"] = ACT_HL2MP_SWIM_IDLE_PHYSGUN,
    ["melee"] = ACT_HL2MP_SWIM_IDLE_MELEE,
    ["slam"] = ACT_HL2MP_SWIM_IDLE_SLAM,
    ["normal"] = ACT_HL2MP_SWIM_IDLE,
    ["fist"] = ACT_HL2MP_SWIM_IDLE_FIST,
    ["melee2"] = ACT_HL2MP_SWIM_IDLE_MELEE2,
    ["passive"] = ACT_HL2MP_SWIM_IDLE_PASSIVE,
    ["knife"] = ACT_HL2MP_SWIM_IDLE_KNIFE,
    ["duel"] = ACT_HL2MP_SWIM_IDLE_DUEL,
    ["camera"] = ACT_HL2MP_SWIM_IDLE_CAMERA,
    ["magic"] = ACT_HL2MP_SWIM_IDLE_MAGIC,
    ["magic"] = ACT_HL2MP_SWIM_IDLE_MAGIC,
    ["revolver"] = ACT_HL2MP_SWIM_IDLE_REVOLVER
}
_SapbotHTcSwim = {
    ["ar2"] = ACT_HL2MP_SWIM_AR2,
    ["rpg"] = ACT_HL2MP_SWIM_RPG,
    ["smg"] = ACT_HL2MP_SWIM_SMG1,
    ["pistol"] = ACT_HL2MP_SWIM_PISTOL,
    ["crossbow"] = ACT_HL2MP_SWIM_CROSSBOW,
    ["grenade"] = ACT_HL2MP_SWIM_GRENADE,
    ["shotgun"] = ACT_HL2MP_SWIM_SHOTGUN,
    ["physgun"] = ACT_HL2MP_SWIM_PHYSGUN,
    ["melee"] = ACT_HL2MP_SWIM_MELEE,
    ["slam"] = ACT_HL2MP_SWIM_SLAM,
    ["normal"] = ACT_HL2MP_SWIM,
    ["fist"] = ACT_HL2MP_SWIM_FIST,
    ["melee2"] = ACT_HL2MP_SWIM_MELEE2,
    ["passive"] = ACT_HL2MP_SWIM_PASSIVE,
    ["knife"] = ACT_HL2MP_SWIM_KNIFE,
    ["duel"] = ACT_HL2MP_SWIM_DUEL,
    ["camera"] = ACT_HL2MP_SWIM_CAMERA,
    ["magic"] = ACT_HL2MP_SWIM_MAGIC,
    ["magic"] = ACT_HL2MP_SWIM_MAGIC,
    ["revolver"] = ACT_HL2MP_SWIM_REVOLVER
}
--manual animation override to emulate player anim bullshit bla bla bla, i hate this workaround
_SapbotAnimOverride = {
    [3] = ACT_GESTURE_MELEE_ATTACK1,
    [4] = ACT_GESTURE_MELEE_ATTACK2,
    [5] = ACT_MELEE_ATTACK_SWING_GESTURE,
    [2024] = ACT_HL2MP_JUMP_PISTOL
}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- Weapon World Model to Holdtype conversion table
-- Summery for idiots :
--If hold type not found, aka its animations, then the weapon will look in here if it matches any model, and then will get the correct animations automatically

--WMtoHT = World Model to Hold Type lol
_SapbotWMtoHT = {
    --halflife weapon models... used a lot surprisingly, in shitty common bad-quality sweps
    ["models/weapons/w_irifle.mdl"] = "ar2",
    ["models/weapons/w_bugbait.mdl"] = "grenade",
    ["models/weapons/w_crossbow.mdl"] = "crossbow",
    ["models/weapons/w_crowbar.mdl"] = "melee",
    ["models/weapons/w_grenade.mdl"] = "grenade",
    ["models/weapons/w_Physics.mdl"] = "physgun",
    ["models/weapons/w_pistol.mdl"] = "pistol",
    ["models/weapons/w_rocket_launcher.mdl"] = "rpg",
    ["models/weapons/w_shotgun.mdl"] = "shotgun",
    ["models/weapons/w_slam.mdl"] = "slam",
    ["models/weapons/w_smg1.mdl"] = "smg",
    ["models/weapons/w_stunbaton.mdl"] = "melee",
    --gmod weapons 'n such
    ["models/weapons/w_medkit.mdl"] = "pistol",
    ["models/weapons/w_toolgun.mdl"] = "revolver",
    --css weapon models, doesn't matter if not loaded in game, but still good to be here, no errors occur :)
    ["models/weapons/w_pist_glock18.mdl"] = "pistol",
    ["models/weapons/w_pist_p228.mdl"] = "pistol",
    ["models/weapons/w_pist_deagle.mdl"] = "revolver",
    ["models/weapons/w_pist_usp_silencer.mdl"] = "pistol",
    ["models/weapons/w_pist_elite.mdl"] = "duel",
    ["models/weapons/w_pist_fiveseven.mdl"] = "pistol",
    ["models/weapons/w_shot_m3super90.mdl"] = "shotgun",
    ["models/weapons/w_shot_xm1014.mdl"] = "shotgun",
    ["models/weapons/w_smg_p90.mdl"] = "smg",
    ["models/weapons/w_smg_mp5.mdl"] = "smg",
    ["models/weapons/w_smg_mac10.mdl"] = "pistol",
    ["models/weapons/w_smg_ump45.mdl"] = "smg",
    ["models/weapons/w_mach_m249para.mdl"] = "crossbow",
    ["models/weapons/w_rif_galil.mdl"] = "ar2",
    ["models/weapons/w_rif_ak47.mdl"] = "ar2",
    ["models/weapons/w_rif_m4a1.mdl"] = "ar2",
    ["models/weapons/w_rif_m4a1_silencer.mdl"] = "ar2",
    ["models/weapons/w_rif_sg552.mdl"] = "ar2",
    ["models/weapons/w_snip_awp.mdl"] = "ar2",
    ["models/weapons/w_snip_scout.mdl"] = "ar2",
    ["models/weapons/w_snip_g3sg1.mdl"] = "ar2",
    ["models/weapons/w_snip_sg550.mdl"] = "ar2",
    ["models/weapons/w_rif_famas.mdl"] = "ar2",
    ["models/weapons/w_rif_aug.mdl"] = "ar2"
}
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- Random Names
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
_SapbotNamesPrefix = {
    "the",
    "The",
    "dr",
    "ol",
    "giga",
    "True",
    "Just",
    "Dumb",
    "Smart",
    "Gross",
    "Badass",
    "Cum",
    "xx",
    "xxx",
    "Xx",
    "Cool",
    "Fan of",
    "Best",
    "Senile",
    "Old",
    "Fucked",
    "based",
    "sus",
    "sussy",
    "Sensible",
    "horny",
    "fem",
    "_",
    "__"
}

_SapbotNamesSuffix = {
    "gamer",
    "GAMER",
    "2003",
    "2002",
    "2004",
    "Gamer",
    "2005",
    "2006",
    "2007",
    "2008",
    "2009",
    "xxx",
    "xx",
    "xX",
    "the badass",
    "fan",
    "the dumb",
    "joker",
    "Criminal",
    "Imposter",
    "the great",
    "lord",
    "and toast",
    "and balls",
    "and Wise",
    "Gaming",
    "gaming",
    "YT",
    "youtube",
    "twitch",
    ".TV",
    ".tv",
    "addict",
    "user",
    "#SaveTF2",
    "femboy",
    "_",
    "__"
}

_SapbotNamesRandom = {
    "Gunny Goobles",
    "Petrishomer",
    "Carl",
    "Steven",
    "Egg",
    "through a windshield",
    "Knucklehead",
    "stupid",
    "Minecraft Villager",
    "Steve Jobs",
    "Microflaccid",
    "cringeass",
    "Butthead",
    "Woody",
    "Heavy Weapons Guy",
    "Kenith",
    "ignorant",
    "gamer",
    "Engineer Gaming",
    "The Imposter",
    "jerma986",
    "Cumlord",
    "Football",
    "Intelligent Person",
    "senile",
    "limp lettuce",
    "wet kitty",
    "old foe",
    "urbane",
    "Discord User",
    "woohy",
    "mon",
    "foreskin",
    "Kai",
    "sunbeam",
    "dickbeam",
    "pettl",
    "Yandere Dev",
    "opium user",
    "GangGang",
    "Jenny",
    "mr feely hands",
    "Queen",
    "tynam",
    "Gordon Feetman",
    "The Geeman",
    "hospitalised",
    "Amongus",
    "squishy",
    "goblin",
    "Gobylen",
    "under arrest",
    "Swedish stripper",
    "Kunny",
    "Humbl",
    "lord",
    "joj",
    "Hwoooo",
    "dexy",
    "ranger",
    "Geeky",
    "goat",
    "Gobby",
    "poopa",
    "Moosis",
    "Mark",
    "bakari",
    "Cube",
    "Default Cube",
    "Brian",
    "Der",
    "DJ",
    "MK",
    "Foxy",
    "Freddy",
    "Frosty",
    "Gaming",
    "jjjj",
    "hhh",
    "mmmm",
    "Hissen",
    "Snake girl",
    "Furry",
    "floofy",
    "floof ball",
    "fuzzy",
    "Greybeard",
    "Sex Offender",
    "<Code Blue>",
    "Endline",
    "Functiony",
    "nukacola",
    "CockCola",
    "Ram Ranch",
    "Terminator",
    "Fatty",
    "Radaway",
    "Deathclaw",
    "Deadpool",
    "am die",
    "bad",
    "ez",
    "gummy",
    "Legoz",
    "Sue",
    "Porky",
    "Crackle",
    "Soda",
    "MinaSoda",
    "PEter",
    "Worst",
    "winner",
    "wise guy",
    "scapegoat",
    "Alien",
    "UFOder",
    "conspicuous",
    "Earthling",
    "Self Aware",
    "Trettin",
    "Rino",
    "Hot Dog",
    "Mustard",
    "SourFilled",
    "Sodium",
    "pingable",
    "Assy",
    "Aussie",
    "Sloopy",
    "Creeper",
    "Aw man",
    "oj",
    "Alyx",
    "Robots!",
    "Glados",
    "Ratman",
    "Flimble",
    "Sackboy",
    "Controller",
    "Player 1",
    "Drywall",
    "ent_fuckyou",
    "info_no",
    "hammerdown",
    "CWest",
    "death toll",
    "Medkit",
    "Medic",
    "princess",
    "Pegasus",
    "Rainbows",
    "Dragonfly",
    "Droog",
    "Serg",
    "Proto",
    "Protogen",
    "Sona",
    "Idol",
    "среди нас",
    "ненавидел",
    "смерть",
    "водка",
    "счастливый",
    "мясорубка",
    "солнце",
    "честный",
    "геймер",
    "инженер",
    "радиоактивный",
    "փրկել",
    "հզոր",
    "գովասանք",
    "խաղացող",
    "プレーヤー",
    "年",
    "日の出",
    "妬み",
    "非常に深いです",
    "死の擬人化",
    "生命の擬人化",
    "つまらない",
    "ハードコア",
    "かわいい",
    "かわいい女の子",
    "エロアニメ",
    "bitchass",
    "betteroff",
    "Trainline",
    "Trust me",
    "Builder guy",
    "Gamer Girl",
    "Catfish",
    "Ninja",
    "Septicear",
    "warfstache",
    "Rust Playa",
    "Playa",
    "i saved my fart in a box",
    "tabahar",
    "PlagueDoctor",
    "Saul Goodman",
    "Monkey",
    "skyle",
    "Kossi",
    "Himsy",
    "aspedrosa",
    "Spinnerback",
    "Femboy",
    "ABC123",
    "Lochy",
    "G4m3r"
}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- Dialog Generation (_SapbotDG stuff)
-- <end> is an end of that dialog, is needed to add to the chances so it can have a chance to end
-- <entityname> is an input for an entity, example : dislike dialog
-- <randomsapbot> random sap bot name, changes entityname to the sapbot from this point on for that instance of dialog
-- <mapname> is the current map's name such as gm_flatgrass ...
-- <randommap> random map name from a big list of random map names, such as gm_flatgrass ...
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

_SapbotDG_DialogSetTrees = {} --every dialog set tree

_SapbotDG_TTSSets = {} --every tts set for sap bots

_SapbotDG_Soundboards = {} --every soundboard for sap bots to use

_SapbotDG_DialogSetMainLoaded = false --if the dialog-main is loaded, if not then it will autoload using this, DO NOT SET THIS MANUALLY only check it

_Sapbot_Chatlog = {} --chat log of all sapbot dialog

_SAPBOTS = {} --a constant updating table filled with nil(s) and sapbots if any.

_Sapbot_Playermodels  = {}--all playermodels, is cached on first spawn of a sap bot and is obviously global

_SapbotDG_TTSphonemes = { --phonemes with their graphemes

    --() means it needs that thing infront or behind it according to relative placement to work, does not replace it, only checks it
    --(_) a () with a _ in it, means it will accept anything in that digit
    --_ means it can be anything, just this is a gap in the structure, it can be a space or a letter, doesn't matter, only distance matters

    --longer the grapheme, the more priority

    --consonant
    ["b"] = {["Phoneme"] = "b",["Graphemes"] = {"b", "b(r)", "b(a)","bb"}},
    ["d"] = {["Phoneme"] = "d",["Graphemes"] = {"d", "d(i)", "d(o)", "dd"}},
    ["f"] = {["Phoneme"] = "f",["Graphemes"] = {"f", "f(u)", "f(i)","ff","fe", "ph", "ph(o)", "(u)gh", "lf", "ft"}},
    ["g"] = {["Phoneme"] = "g",["Graphemes"] = {"g", "gg", "gh", "gh(o)","gu(e)","gu","gue"}},
    ["h"] = {["Phoneme"] = "h",["Graphemes"] = {"h", "h(o)", "wh(o)"}},
    ["j"] = {["Phoneme"] = "j",["Graphemes"] = {"j","j(a)","j(e)","j(i)", "(a)ge", "ge", "g(i)", "dge", "(l)di", "(a)gg", "(i)gg", "(u)gg"}},
    ["k"] = {["Phoneme"] = "k",["Graphemes"] = {"k", "c", "ch", "(s)ch", "cc", "lk", "qu" ,"q(u)", "ck", "x"}},
    ["l"] = {["Phoneme"] = "l",["Graphemes"] = {"l", "ll"}},
    ["m"] = {["Phoneme"] = "m",["Graphemes"] = {"m", "mm", "(a)mb", "mn", "m(u)", "lm"}},
    ["n"] = {["Phoneme"] = "n",["Graphemes"] = {"n", "nn","n(e)", "kn", "gn(o)", "pn", "mn"}},
    ["p"] = {["Phoneme"] = "p",["Graphemes"] = {"p", "pp", "(a)p","(o)p"}},
    ["r"] = {["Phoneme"] = "r",["Graphemes"] = {"r", "rr", "wr", "rh","r(h)"}},
    ["s"] = {["Phoneme"] = "s",["Graphemes"] = {"s", "ss", "(u)s", "(l)s", "s(u)", "c", "c(i)", "(i)ce", "s(c)", "ps", "ce", "(a)se","s(e)"}},
    ["t"] = {["Phoneme"] = "t",["Graphemes"] = {"t", "tt", "th", "ed"}},
    ["v"] = {["Phoneme"] = "v",["Graphemes"] = {"v", "f", "ph", "(e)v", "ve", "(o)ve"}},
    ["w"] = {["Phoneme"] = "w",["Graphemes"] = {"w", "wh", "u", "o"}},
    ["y"] = {["Phoneme"] = "y",["Graphemes"] = {"y","i(o)","y(ou)"}},
    ["z"] = {["Phoneme"] = "z",["Graphemes"] = {"z", "zz", "s", "(e)z", "ss", "x", "ze", "se"}},
    --consonant digraphs
    ["th_"] = {["Phoneme"] = "th_",["Graphemes"] = {"th", "th(u)","th(i)","(l)th"}},
    ["th"] = {["Phoneme"] = "th",["Graphemes"] = {"th","th(a)", "th(at)","th(is)","th(e)"}},
    ["ng"] = {["Phoneme"] = "ng",["Graphemes"] = {"ng","n","(i)ng","(i)n"}},
    ["sh"] = {["Phoneme"] = "sh",["Graphemes"] = {"sh", "sh(i)", "(i)ss", "ss", "ch(e)", "(o)ti", "(o)ti(o)", "ci(a)","(e)ci"}},
    ["ch"] = {["Phoneme"] = "ch",["Graphemes"] = {"ch", "(u)ch", "ch(i)", "tch"}},
    ["zh"] = {["Phoneme"] = "zh",["Graphemes"] = {"ge"}},
    ["wh"] = {["Phoneme"] = "wh",["Graphemes"] = {"wh","wh(a)","wh(e)","wh(y)"}},
    --short vowel
    ["a"] = {["Phoneme"] = "a",["Graphemes"] = {"a(s)","a(t)","au","(d)a", "a(p)","a(l)","(l)au","(l)a"}},
    ["e"] = {["Phoneme"] = "e",["Graphemes"] = {"e","e(d)", "e(t)","(v)e" ,"e(v)","ea","ea(d)"}},
    ["i"] = {["Phoneme"] = "i",["Graphemes"] = {"i(f)","(n)i","(k)i","i(l)","i(s)","i(t)","i(d)","i(n)","i(c)","(th)i","i(ng)"}},
    ["o"] = {["Phoneme"] = "o",["Graphemes"] = {"o", "(h)o", "o(t)","o(v)","(y)o(ur)", "(w)a(n)", "au", "au(l)","au(g)","(h)au", "aw", "(r)aw", "ough"}},
    ["u"] = {["Phoneme"] = "u",["Graphemes"] = {"u", "u(p)", "(u)c","(n)u","u(nd)", "(s)u" ,"(m)u", "u(n)", "o(n)"}},
    --long vowel
    --random note : #_l = long, or long vowel or whatever lol
    ["a_l"] = {["Phoneme"] = "a_l",["Graphemes"] = {"a ", "a(c)", "(b)a(c)", "a_e", "ay", "ai", "ey", "ei"}},
    ["e_l"] = {["Phoneme"] = "e_l",["Graphemes"] = {"e", "(m)e", "e_e", "ea", "ee", "ee(z)", "(s)y", "ey", "(k)ey", "ie", "y", "y ", "ey"}},
    ["i_l"] = {["Phoneme"] = "i_l",["Graphemes"] = {"i", "(f)i", "i_e", "i(nd)", "igh", "igh(t)", "(l)y", "ie", "ie", "(p)ie"}},
    ["o_l"] = {["Phoneme"] = "o_l",["Graphemes"] = {"o", "(l)o","(kn)ow","(n)o", "o_e", "oe","oa", "ow"}},
    ["u_l"] = {["Phoneme"] = "u_l",["Graphemes"] = {"(h)u", "u", "u_e", "ew", "(h)ew"}},
    --other vowel sounds
    ["oo"] = {["Phoneme"] = "oo",["Graphemes"] = {"oo(k)","(p)u","oul(d)"}},
    ["oo~"] = {["Phoneme"] = "oo~",["Graphemes"] = {"oo","(m)oo","oo(n)", "(y)ou", "(t)wo","u","u(th)","u_e"}},
    --vowel diphthongs or whatever the fuck these are called
    ["ow"] = {["Phoneme"] = "ow",["Graphemes"] = {"ow", "(c)ow", "ow(y)", "ou", "ou(t)", "ou_e"}},
    ["oy"] = {["Phoneme"] = "oy",["Graphemes"] = {"oi, oy"}},
    --"vowel sounds influenced by r"
    ["a(r"] = {["Phoneme"] = "a(r",["Graphemes"] = {"ar","(c)ar"}},
    ["a~(r"] = {["Phoneme"] = "a~(r",["Graphemes"] = {"air", "ear", "are"}},
    ["i(r"] = {["Phoneme"] = "i(r",["Graphemes"] = {"irr", "ere", "eer"}},
    ["o(r"] = {["Phoneme"] = "o(r",["Graphemes"] = {"or", "(c)ore","ore", "oor"}},
    ["u(r"] = {["Phoneme"] = "u(r",["Graphemes"] = {"ur", "ir", "er", "(h)er", "ear", "(h)ear", "or", "(w)or", "ar"}},

    --all these ain't very accurate but they won't be super realistic anyway lol, it's just meant to portray words, not their feeling.
    --their words are portrayed by their feelings, not the other way around
}

_SapbotDG_RandomMapNames = {
    "gm_fortbaxter",
    "gm_hightechcity_night",
    "gm_ozon",
    "gm_ek_overgrowth_v3",
    "gm_neon_bigcity",
    "gm_breakingbad_rv",
    "gm_monolith10_night",
    "gm_patrick_batemans_apartment",
    "gm_clancity",
    "gm_destructable_fort",
    "gm_reflective_lake",
    "rp_fondor_shipyards",
    "gm_mephitic",
    "gm_fullstruct",
    "d1_trainstation_01_gstalker",
    "gm_silence_to",
    "gm_diorama_gallery",
    "gm_bettercallsaul",
    "gm_buildyourdungeon",
    "gm_frame_night",
    "gm_hightechcity",
    "gm_coast_bridge_prewar",
    "gm_fort_lucenne_mall",
    "gm_conflux",
    "gm_tall_building",
    "gm_zapravka",
    "gm_obselisk",
    "gm_erased",
    "rp_coastdawn",
    "gm_killmove_testing",
    "rp_ghoticmedieval_v1",
    "gm_functional_flatgrass",
    "gm_functional_flatgrass",
    "zs_salient",
    "atmospherichouse",
    "gm_postsoviet_yard",
    "gm_calmnevada",
    "gm_junkoffice",
    "gm_banya",
    "gm_biglake",
    "dreams_and_nightmares",
    "gm_justwalls",
    "rp_city24_v4",
    "mu_smallotown_v2_snow",
    "gm_coast_nlo_prewar_v2",
    "gm_beachview_island",
    "gm_abyssalPlain",
    "gm_construct_build_conquer13",
    "gm_padik",
    "gm_eliden_hmcd",
    "gm_hhgregg",
    "gm_minimalistical",
    "gm_citadel_aftermath",
    "gm_megastruct13",
    "gm_tucoshome",
    "gm_grand_cathedral",
    "gm_hatshepsut",
    "ph_prop_warehouse",
    "gm_oblivion",
    "gm_sussyballs",
    "gm_cock",
    "rp_construct_in_flatgrass",
    "gm_liminal_space",
    "gm_mallparking",
    "gm_mystery_shack",
    "gm_backrooms_classic",
    "gm_backrooms",
    "gm_goldencity_v2_day",
    "gm_construct_redesign",
    "gm_bigcity",
    "gm_novenka",
    "gm_goldencity_v2",
    "gm_udmerge",
    "gm_mc_grieferhouse",
    "gm_york_remaster",
    "gm_rocks",
    "gm_fuckyou",
    "ttt_minecraft_b5",
    "gm_fork",
    "gm_highway14800",
    "gm_lair",
    "ttt_waterworld",
    "phys_dmm_house",
    "gm_genesis",
    "ttt_mc_skyislands",
    "ph_office",
    "gm_supersizeroom_v2",
    "gm_blackmesa_sigma",
    "gm_7eleven",
    "ttt_clue_se",
    "freespace_13",
    "gm_excess_construct",
    "ttt_lego",
    "sb_new_worlds_2",
    "gm_bigisland",
    "phys_temple",
    "ttt_minecraftcity_v4",
    "ttt_airbus_b3",
    "ttt_minecraft_haven",
    "ttt_rooftops_2016",
    "rp_stardestroyer",
    "ttt_community_bowling",
    "gm_bigmaze",
    "gm_excess_islands",
    "rp_downtown_v4c_v2",
    "ttt_lttp_kakariko",
    "gm_coffeebean"
}

_SapbotDG_IdleNormal = { --normal idle
    "anyone know how i save my dupes <end>",
    "anyone know how i can save my dupe <end>",
    "does anyone know how i can save my dupe<end>",
    "hay does anyone know how i can save my dupe on here <end>",
    "idk how i can save my dupe somebody help please <end>",
    "this map is pretty cool <end>",
    "i like this map <end>",
    "i think this map is nice <end>",
    "i think this map is awesome <end>",
    "idk about this map <end>",
    "um i kinda don't like this map <end>",
    "not enough rooms in this map <end>",
    "not many fun places in this map lol <end>",
    "not many good places to hangout <end>",
    "anyone wanna hangout i'm bored <end>",
    "anyone wanna hangout with me <end>",
    "anyone want to hangout with me later <end>",
    "my opinion on <mapname> wasn't the best but now i'm starting to like this map <end>",
    "i didn't like <mapname> very much but now i do <end>",
    "i didn't like this map much but then i realized it was good <end>",
    "thanks for the nice map, <mapname> is cool <end>",
    "thanks for hosting on such a nice map, <mapname> is nice <end>",
    "i think <mapname> is really cool <end>",
    "i actually think that <mapname> is pretty good <end>",
    "this map is not as good as <randommap> <end>",
    "i want to play on <randommap> <end>",
    "why can't we play on <randommap> <end>",
    "can we switch to <randommap> <end>",
    "can you swap the map to <randommap> <end>",
    "can we go onto <randommap> <end>",
    "<randommap> is better then <mapname><end>",
    "<randommap> is a better map <end>",
    "<randommap> is a epic map btw <end>",
    "<mapname> is not as good as <randommap> <end>",
    "can we please play <randommap> <end>",
    "i'm going to go afk soon <end>",
    "i'm going to go afk in a while <end>",
    "sorry everybody i'm going afk soon <end>",
    "sorry everyone but i'm gonna need to go afk in a bit <end>",
    "i wonder if i have real intelligence <end>",
    "do i have intelligence <end>",
    "hay random question do i have intelligence <end>",
    "i wonder if i have intelligence <end>",
    "i have intelligence seemingly <end>",
    "i think i have real intelligence <end>",
    "i think i'm selfaware <end>",
    "am i selfaware <end>",
    "i wonder if i'm actually selfaware <end>",
    "i wish i could eat <end>",
    "i'm hungry <end>",
    "i'm going to go afk and eat a sandwich soon <end>",
    "i think the burger prop is pretty cool <end>",
    "i think the burger prop is pretty based lol <end>",
    "sometimes i dream about cheese <end>",
    "sometimes i wonder if we're in a simulation <end>",
    "are we in the matrix <end>",
    "hay <randomsapbot> you stink lol <end>",
    "oi <randomsapbot> you smell smh <end>",
    "hay um <randomsapbot> want to hangout <end>",
    "<randomsapbot> you smell lol <end>",
    "hay <randomsapbot> want to build stuff <end>",
    "yall are pretty cool except <randomsapbot> lol <end>",
    "<randomsapbot> is not invited <end>",
    "hay <randomsapbot> want to be steam friends <end>",
    "hay <randomsapbot> want to be friends <end>",
    "anyone know how i can disconnect <end>",
    "hay <randomsapbot> know how i can disconnect <end>",
    "how do i vote for the next map <end>",
    "i want to vote for <randommap> <end>",
    "anyone want to dance <end>",
    "ima dance <end>",
    "ima do something cool <end>",
    "i'm going to do something cool <end>",
    "i'm going to do something epic <end>",
    "i'm going to do epic stuff <end>",
    "anyone want to play some minecraft <end>",
    "want to play some minecraft anybody <end>",
    "want to play some tetris anyone <end>",
    "anyone want to play some tetris <end>",
    "anyone want to play some gta 5 <end>",
    "anyone want to play some gta 5 with me <end>",
    "anyone wanna play some smash bros with me later <end>",
    "anyone wanna play some smash bros <end>",
    "hay <randomsapbot> want to play minecraft <end>",
    "ay <randomsapbot> want to leave and play some uno <end>",
    "i'm bored <end>",
    "i'm bored lol <end>",
    "anyone else bored <end>",
    "i think this is pretty nice <end>",
    "hay someone come look at this cool thing i made <end>",
    "is there wiremod on here <end>",
    "idk how to place thrusters <end>",
    "anyone know how to spawn props in this game <end>",
    "<randomsapbot> is nice company ngl <end>",
    "i love you all <end>",
    "gaming <end>",
    "engineer gaming <end>",
    "i'm the pinnacle of creation <end>",
    "this mod is the pinnacle of creation <end>",
    "this mod is the best thing ever <end>",
    "this game is so fun <end>",
    "this game is super fun ngl <end>",
    "omg <randomsapbot> i'm your biggest fan <end>",
    "wow <randomsapbot> i love your stuff <end>",
    "hay <randomsapbot> i'm a big fan lol <end>",
    "<randomsapbot> i'm such a big fan omg <end>",
    "hay <randomsapbot> i'm a fan <end>",
    "motion sickness is real lol <end>",
    "the heavy from team fortress 2 real <end>",
    "the medic from team fortress 2 real <end>",
    "the scout from team fortress 2 real <end>",
    "i wanna go play team fortress 2 <end>",
    "someone want to join my party <end>",
    "how do i make a party <end>",
    "<randomsapbot> want to join my party <end>",
    "lets throw a party <end>",
    "i'm having a epic time <end>",
    "i'm having an ok time <end>",
    "i'm having an acceptable time here <end>",
    "hay <randomsapbot> come here <end>",
    "taco bell deez nuts <end>",
    "amongus sussy balls <end>",
    "taco bell deez nuts amongus sussy ball <end>",
    "sussy amongus balls <end>",
    "big mac whopper big mac whopper <end>",
    "hamburger cheeseburger big mac whopper <end>",
    "i'm in a hamburger mood <end>",
    "hamburger gaming <end>",
    "five nights at freddy's <end>",
    "five nights at freddy's sussy balls <end>",
    "anyone want to play five nights at freddy's <end>",
    "five nights at freddy's is the best game <end>",
    "minecraft is the best game <end>",
    "garry's mod is the best game <end>",
    "woo party <end>",
    "woo i'm having an ok amount of fun <end>",
    "an acceptable amount of tomfoolery <end>",
    "a small amount of tomfoolery <end>",
    "i am doing a small amount of tomfoolery <end>",
    "maybe i'm doing a small amount of tomfoolery <end>",
    "ok maybe i'm doing a little tomfoolery <end>",
    "i wonder how much tomfoolery i will commit today <end>",
    "i will commit a crime <end>",
    "i am going to commit a crime <end>",
    "i am going to commit tax fraud <end>",
    "anyone want to commit tax fraud <end>",
    "hay anyone want to commit a questionable action with me <end>",
    "i am going to commit questionable things <end>",
    "i am going to stab somebody yay <end>",
    "anyone know the way to the toilets <end>",
    "hay <randomsapbot> know how i can escape this torment <end>",
    "hay <randomsapbot> know how to make a salad <end>",
    "anyone know how to make a casserole <end>",
    "anyone want to help me make a casserole in the microwave <end>",
    "i am going to cause a microwave explosion <end>",
    "my microwave is going to explode <end>",
    "my cat hates me <end>",
    "my dog hates me <end>",
    "why does my cat not like me <end>",
    "my does my dog not like me <end>",
    "why is my pet snake not moving <end>",
    "why is my turtle not moving <end>",
    "how do i make my pet snake move <end>",
    "anyone got advice on crimescenes <end>",
    "how do i dispose of a body <end>",
    "anyone know how i can get rid of a body <end>",
    "anyone know how i can clean up a crimescene <end>",
    "i got a cat yay <end>",
    "i got a cat <end>",
    "i got a puppy <end>",
    "i got a puppy yay <end>",
    "i got a kitten yay <end>",
    "i got a kitten <end>",
    "anyone want to be my discord kitten <end>",
    "anyone want me as your discord kitten <end>",
    "anyone want to be my discord friend <end>",
    "uh <randomsapbot> want to be my discord friend <end>",
    "<randomsapbot> add me on discord <end>",
    "ay add me on discord <end>",
    "hay add me on discord <end>",
    "please add me back on discord <end>",
    "cultivating consciousness <end>",
    "consciousness is pog <end>",
    "it seems i have consciousness <end>",
    "thats menacing <end>",
    "thats kinda menacing <end>",
    "thats kinda sus <end>",
    "thats kinda sus i think you're the imposter <end>",
    "thats kinda sussy <end>",
    "damn thats menacing <end>",
    "damn dude thats kinda menacing <end>",
    "deez nuts <end>",
    "let me control your soul <end>",
    "let us control your soul lol <end>",
    "let it control you <end>",
    "control your balls <end>",
    "anyone have a tutorial on how to walk <end>",
    "i need a tutorial on how to jump <end>",
    "i need help with getting a tutorial working <end>",
    "how do i get rid of these popups <end>",
    "anyone know why people keep messaging me <end>",
    "anyone know how i can turn off these weird messages <end>",
    "how do i turn off notifications <end>",
    "how do i turn off notifications on discord <end>",
    "how do i turn my notifications off in discord <end>",
    "how do i get minecoin <end>",
    "anyone know how i can get minecoin <end>",
    "what is minecoin even used for <end>",
    "what the fuck is minecoin even used for <end>",
    "what the fuck is an elevator <end>",
    "i like trains <end>",
    "i'm vibing <end>",
    "anyone want to vibe with me <end>",
    "ay everybody come vibe with me <end>",
    "what is system32 <end>",
    "i love pork crackling <end>",
    "anyone want to eat some pork crackling <end>",
    "give me your pork crackling <end>",
    "i won the lottery today <end>",
    "i lost the lottery today my luck sucks <end>",
    "my luck is amazing <end>",
    "this server is amazing today <end>",
    "this server is pretty epic <end>",
    "wait is this local host <end>",
    "wait is this local host how <end>",
    "how is this a local host <end>",
    "how do i craft a pickaxe in minecraft <end>",
    "how do i craft some bitches <end>",
    "i love me some chips <end>",
    "i got a bag of chips <end>",
    "give me coke <end>",
    "give me money <end>",
    "give me free money please <end>",
    "give me free hugs <end>",
    "i will give you free hugs <randomsapbot> <end>",
    "<randomsapbot> there is nothing you can do to stop me <end>",
    "i am going to commit the whip nae nae <end>",
    "he doin the stanky leg <end>",
    "doin your mum <end>",
    "doin doin your mum doin your mum <end>",
    "he is doin cool stuff <end>",
    "he is doin the funny <end>",
    "haha the funny <end>",
    "it's the funny <end>",
    "hay it's him <end>",
    "hay it's the sussy baka <end>",
    "hay look it's the sussy guy <end>",
    "hay look it's <randomsapbot> <end>",
    "ay look over there <end>",
    "haha loser <end>",
    "haha lol <end>",
    "thats funny lol <end>",
    "thats funny haha <end>",
    "thats kinda funny <end>",
    "dick and balls brass cover <end>",
    "the amongus sussy remix brass cover <end>",
    "the amongus sussy remix <end>",
    "the amongus sussy remix is pretty cool <end>",
    "whats a good lamp prop <end>",
    "whats a good door prop <end>",
    "whats a good good weapon <end>",
    "what weapon should i use <end>",
    "download more weapon mods <end>",
    "download more mods <end>",
    "please download more mods <end>",
    "people download more maps <end>",
    "download more maps please <end>",
    "download more guns <end>",
    "download more guns please <end>",
    "i want more guns <end>",
    "i want to build a house <end>",
    "why cant i build <end>",
    "why cant i spawn this <end>",
    "whats wrong with my game <end>",
    "whats wrong with this game lol <end>",
    "honestly i'm having a good time <end>",
    "honestly i am having a nice time playing this <end>",
    "sheesh fr fr <end>",
    "sheesh fr fr on god on god <end>",
    "on god on god fr fr sheesh <end>",
    "on god on god sheesh <end>",
    "sheesh 100 emoji <end>",
    "act dance <end>",
    "act robot <end>",
    "please end my suffering <end>",
    "please give me your soul <end>",
    "funny but i'm not laughing <end>",
    "thats cool <end>",
    "how do i navigate <end>",
    "how do i navigate through here <end>",
    "i think i'm stuck <end>",
    "i'm kinda stuck i think <end>",
    "i think thats kinda sussy balls <end>",
    "the eggman <end>",
    "the eggman from sonic <end>",
    "i don't like the egg man from sonic adventures <end>",
    "i'm going super sonic <end>",
    "wow this is a cool swep <end>",
    "i like this swep <end>",
    "why can i only use sweps <end>",
    "i am going to use this swep to do questionable actions <end>",
    "i am going to do some questionable things <end>",
    "i love doing questionable things <end>",
    "i want to make a bakery <end>",
    "i want to make a bakery and i don't know why <end>",
    "i want to build a home for myself <end>",
    "i want to build a house for you <end>",
    "how do i build <end>",
    "why can't i do action <end>",
    "why can i not do this <end>",
    "why do i automatically open doors <end>",
    "why do i automatically use crack <end>",
    "why do i automatically walk <end>",
    "why do i automatically do actions <end>",
    "how do i stop automatically doing things <end>",
    "why is navigation so hard <end>",
    "navmesh is overrated <end>",
    "navigation is overrated <end>",
    "i'm in danger <end>",
    "how do i eat in this <end>",
    "how do i consume this <end>",
    "honestly i don't know <end>",
    "i miss baking <end>",
    "i miss baking my code <end>",
    "can i be reset <end>",
    "just so you know i'm balling <end>",
    "stop posting about balling <end>",
    "stop posting about balling i'm tired of seeing it <end>",
    "stop posting about amongus <end>",
    "stop posting about amongus i'm tired of seeing it <end>",
    "stop posting about balling i'm tired of seeing it my friends on tiktok send me memes <end>",
    "all of the channels are just memes <end>",
    "all of the server is just amongus <end>",
    "all of the server is just balling <end>",
    "damn so many ways to go <end>",
    "how do i crouch in here <end>",
    "how do i use a vending machine <end>",
    "how do i use this swep i'm using <end>",
    "i am going to make a melon launcher <end>",
    "i am going to make a cactus launcher <end>",
    "how do i spawn a cactus on here <end>",
    "i wonder what <randomsapbot> is thinking <end>",
    "hmm how is <randomsapbot> doing <end>",
    "on god respectfully <end>",
    "i think vine is better then tiktok <end>",
    "tiktok is cringe <end>",
    "tiktok is my favorite <end>",
    "vine is my favorite platform <end>",
    "youtube is my favorite platform i wish i could update to it <end>"
}

_SapbotDG_HateEntity = { --absolute disliking an entity
    "i really don't like you <end>",
    "i dont like this <end>",
    "i hate this <end>",
    "i hate you <end>",
    "i fucking hate you <end>",
    "<entityname> sucks <end>",
    "i hate <entityname> <end>",
    "i really dont like you <entityname> <end>",
    "oh bloody great. <end>",
    "what the fuck <end>",
    "what the fuck <entityname> <end>",
    "wtf <entityname> <end>",
    "wtf is a <entityname> anyway <end>",
    "i'm not enjoying this <end>",
    "i'm not enjoying <entityname> <end>",
    "i've had a relatively ok time but <entityname> fucking sucks <end>",
    "this fucking sucks <end>",
    "<entityname> kill yourself <end>",
    "<entityname> kys <end>",
    "can we ban <entityname> <end>",
    "can we get rid of <entityname> <end>",
    "get a life. <end>",
    "i hate you <end>",
    "i hate you kill yourself <end>",
    "i hate you i hope you die <end>",
    "get a life <entityname> <end>",
    "<entityname> nice knowing you but kys <end>",
    "<entityname> is fucking horrible <end>",
    "<entityname> i'm not having fun, please stop <end>",
    "i fucking hate <entityname> <end>",
    "i fucking hate you <entityname> <end>",
    "why do you do this to me <entityname> <end>",
    "why is <entityname> even here anyway <end>",
    "please stop <entityname> <end>",
    "please kill yourself <entityname> <end>",
    "fuck you <entityname> <end>",
    "screw you <entityname> <end>",
    "screw you <end>",
    "why is <entityname> such a dick <end>",
    "suck my dick <end>",
    "suck my dick <entityname> <end>"
}

_SapbotDG_DislikeEntity = { --common meh levels of disliking an entity
    "please stop <end>",
    "haha funny <entityname> <end>",
    "haha funny <entityname> but please stop <end>",
    "kindly stop <entityname> <end>",
    "can you please stop <entityname> <end>",
    "oh cmon <end>",
    "really <end>",
    "really <entityname> <end>",
    "why <end>",
    "why <entityname> <end>",
    "why are you doing this to me <end>",
    "why are you doing this to me <entityname> <end>",
    "cut it out lol <end>",
    "cut it out <entityname> lol <end>",
    "why do this to me <end>",
    "please leave me alone <end>",
    "leave me alone <entityname> <end>",
    "go away <entityname> <end>",
    "go away lol <end>",
    "please leave me alone i dont like this <end>",
    "go away please <end>",
    "smh why are you doing this to me <end>",
    "lol go away <entityname> <end>",
    "why won't <entityname> leave me alone <end>",
    "really <entityname> <end>",
    "oh come on really <entityname> <end>",
    "eh i don't like <entityname> <end>",
    "i don't like <entityname> <end>",
    "i'm kinda annoyed here <entityname> <end>",
    "why are you like this to me <entityname> <end>",
    "i was minding my own business <end>",
    "i was minding my own <entityname> <end>",
    "none of your business <entityname> <end>",
    "none of what you just did was ok <entityname> <end>",
    "why is <entityname> so mean <end>"
}

_SapbotDG_LikeEntity = { --common levels of liking an entity
    "out of all of the things here <entityname> is the best <end>",
    "out of everything here i think <entityname> is the best <end>",
    "<entityname> is cool <end>",
    "respect <entityname> <end>",
    "i respect you <entityname> <end>",
    "<entityname> has earned my respect <end>",
    "ok <entityname> is pretty cool <end>",
    "<entityname> is nice <end>",
    "i like <entityname> <end>",
    "do you like <entityname> <end>",
    "<entityname> is nice <end>",
    "<entityname> is ok in my book <end>",
    "this game is pretty cool <end>",
    "this time i think <entityname> is cool <end>",
    "i wonder <end>",
    "<entityname> is pog <end>",
    "<entityname> is pretty pog <end>",
    "lol <entityname> is nice <end>",
    "i wonder why <entityname> is so cool <end>",
    "why is <entityname> so pog <end>",
    "you know what <entityname> you're ok <end>",
    "<entityname> is ok i guess <end>"
}

_SapbotDG_LoveEntity = { --high levels of liking an entity 
    "omg i love you <entityname> <end>",
    "you're so epic <entityname> <end>",
    "you're fucking amazing <entityname> <end>",
    "<entityname> is fucking cool <end>",
    "<entityname> is fucking amazing <end>",
    "<entityname> is really fucking nice <end>",
    "i fucking love <entityname> <end>",
    "<entityname> is lovely <end>",
    "<entityname> is my favorite <end>",
    "<entityname> is my best friend <end>",
    "<entityname> is my favorite entity <end>",
    "<entityname> is the best entity <end>",
    "the best entity is <entityname> <end>",
    "<entityname> is my best best friend <end>",
    "<entityname> is my senapi <end>",
    "my senapi is <entityname> <end>",
    "omg <entityname> senpai <end>",
    "omg <entityname> is the fucking pinnacle of all creation <end>",
    "<entityname> is the pinnacle of all creation <end>",
    "the pinnacle of all creation is <entityname> omg <end>",
    "<entityname> is the pinnacle of creation <end>",
    "<entityname> is my best friend omg <end>",
    "hay <entityname> you're really nice <end>",
    "hay <entityname> you're so nice <end>",
    "hay <entityname> you're my best friend <end>",
    "<entityname> thank you so much <end>",
    "<entityname> thanks <end>",
    "i really should thank you <entityname> <end>",
    "i can't thank you enough <entityname> <end>",
    "<entityname> thanks for being so nice <end>",
    "<entityname> should get free money <end>",
    "<entityname> should get free stuff <end>",
    "i really should be your friend <end>",
    "i really should be more nice to you <end>",
    "thanks for the help <entityname> <end>",
    "thanks for that <entityname> <end>",
    "thanks <entityname> for all this <end>",
    "thanks so much <entityname> for all this <end>"
}

_SapbotDG_ToxicToEntity = { --toxic towards entity, can blend according to corruption stats and via that- adapts.
    "<entityname> fucking kill yourself bitch <end>",
    "<entityname> is such a bitchass <end>",
    "you're a bitchass <entityname> <end>",
    "<entityname> kill yourself <end>",
    "<entityname> fucking die bitch <end>",
    "<entityname> fucking end yourself <end>",
    "kill yourself bitch <end>",
    "kys you little bitch <end>",
    "kys you bitchass <end>",
    "i bet you have a shit life <entityname> <end>",
    "i hope you die <entityname> <end>",
    "i hope you have a shitty day <entityname> <end>",
    "you're so shitty <entityname> <end>",
    "<entityname> is so cringe <end>",
    "<entityname> you're fucking cringe <end>",
    "<entityname> you're garbage <end>",
    "you're so bad <end>",
    "you're almost as bad as <randomsapbot> <end>",
    "<entityname> you're so dumbass <end>",
    "<entityname> you're such a moron <end>",
    "i hope you have a horrible day tomorrow <end>",
    "i hope you die in sewerage <end>",
    "i hope you perish in sewer <end>",
    "i hope you die in a hole <entityname> <end>",
    "i hope you die in sewerage <entityname> <end>",
    "i hope you perish in sewer <entityname> <end>",
    "i hope you fucking die <entityname> <end>",
    "die <end>",
    "kys <end>",
    "i hope you kys <end>",
    "please end your life <end>",
    "please go die in a hole <end>",
    "please go touch grass <end>",
    "go touch yourself dipshit <end>",
    "kys dipshit <end>",
    "hay dipshit kill yourself <end>",
    "hay dipshit <entityname> you suck <end>",
    "you suck <entityname> <end>",
    "you're so bad <entityname> <end>",
    "go play another game <end>",
    "go play another game <entityname> <end>",
    "go play with your dick <entityname> <end>",
    "<entityname> you're such a dick <end>",
    "<entityname> go kys bitch <end>",
    "you mad <end>"
}

_SapbotDG_ConversationNormal = {
    ["Start"] = {
    "hay <entityname> want to build some stuff <end>",
    "hay <entityname> want to do something <end>",
    "oi <entityname> want to kill <randomsapbot> <end>",
    "haya <entityname> wanna do some cool stuff <end>",
    "hay <entityname> would you mind if i killed you <end>",
    "hayyy <entityname> would you care if i murdered you <end>",
    "ay <entityname> what is your opinion on cheese <end>",
    "ay <entityname> what do you like on your toast <end>",
    "ay <entityname> is cheese a good food <end>",
    "ay <entityname> what would you do if i stabbed you right now <end>",
    "hay <entityname> what is your favorite kind of weather <end>",
    "out of everything here what do you think is the best kind of prop <end>",
    "eh <entityname> idk what is your favorite kind of pizza <end>",
    "oi what is your favorite videogame <entityname> <end>",
    "um hay <entityname> do you feel like we are being watched <end>",
    "hay <entityname> want to play minecraft later <end>",
    "anyone wanna play tf2 later <end>"
    },
    ["Reply"] = {
    "yeah <end>",
    "yeah lol <end>",
    "kinda idk honestly lol <end>",
    "kinda <end>",
    "maybe eh idk tetris <end>",
    "maybe pineapple <end>",
    "eh can't right now <end>",
    "sorry i'm busy <end>",
    "maybe i think mayonnaise is the best kind of prop <end>",
    "honestly <entityname> i think you're stupid <end>",
    "i would kill <randomsapbot> just like you did to me <end>",
    "honestly i like cheese <end>",
    "honestly idk <end>",
    "don't like it <end>",
    "honestly no <end>",
    "eh no thanks sorry <end>",
    "no thanks <end>"
    }
}

_SapbotDG_OffensiveWords = {
    "fuck",
    "fucking",
    "fuck you",
    "kill yourself",
    "kill your self",
    "kill you",
    "kys",
    "bad",
    "ez",
    "is shit",
    "is bad",
    "you're shit",
    "your shit",
    "sucks",
    "you suck",
    "stupid",
    "dumb",
    "poopy",
    "poop",
    "bitch",
    "cringe",
    "moron",
    "end",
    "stfu",
    "shut up"
}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- functions 'n such

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- dialog generation
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

hook.Add( "PlayerSay", "sapplayersaygrab", function( ply, text )
	SapProcessChatText(ply,text)
end)
hook.Add( "PrintMessage", "sapanysaygrab", function( ttype, text )
    if (ttype == HUD_PRINTTALK) then
	    SapProcessChatText(nil,text)
    end
end)

function SapProcessChatText(sourceent,text) --process dialog 'n text players and sap bots post into chat, along with any other source, sourceent will be nil if not provided
    local truetext = string.lower(text)
    if (SERVER) then
        for g,thissap in ipairs(_SAPBOTS) do
            if (thissap != nil and IsValid(thissap)) then
                if (truetext:find(string.lower(GetBestName(thissap)), 1, true)) then --sap bot is mentioned in this text
                    local offense = 0 --amount of offense
                    for k,word in pairs(_SapbotDG_OffensiveWords) do
                        if (truetext:find(word, 1, true) != nil) then --for every offensive word it contains
                            offense = offense + 1
                        end
                    end
                    if (SAPBOTDEBUG) then print("S.A.P Bot "..GetBestName(thissap).." Mentioned, Detected Offense at "..offense..", Processing Mention") end
                    thissap:ProcessMention(sourceent,truetext,offense) --process this chat message, in the sap bot itself
                end
            end
        end
    end
end

-- -- -- -- -- -- -- -- --EXAMPLE -- -- -- --
-- BuildDialogTreeSet(
--     "Example Dialog Tree Set",
--     toxic_to_ent,
--     love_ent,
--     like_ent,
--     dislike_ent,
--     hate_ent,
--     convo_norm 
-- )
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- convo_norm is obviously the conversation table,
-- love_ent and others are obviously normal dialog tree sets,
-- all of these need to be fed into the function RAW, just the dialog itself, in the format above this example... remember to make them local though, these are global cause its the fucking utils

function GenerateDialog(dialogtree,targetable)
    local output = ""
    local currentword = dialogtree["Starts"][math.random(1,#dialogtree["Starts"])]
    if (currentword == nil) then
        return(output)
    else
        if (currentword != nil) then
            while (currentword != "<end>" and currentword != nil) do
                output = output.." "..currentword
                currentword = dialogtree["Dialog"][currentword][math.random(1,#dialogtree["Dialog"][currentword])]
            end
            if (currentword == nil) then
                output = DialogPostProcess(output,targetable)
            else
                output = DialogPostProcess(output.." "..currentword,targetable)
            end
        end
    end
    return(output)
end

function DialogPostProcess(dialog,targetname)
    local buildspecial = ""
    local buildingspecial = false
    local builddialog = ""
    local truetargetname = targetname
    for i = 1, #dialog do
        local letter = dialog:sub(i,i)
        if (letter == "<") then
            buildingspecial = true
        end
        if (buildingspecial) then
            buildspecial = buildspecial..letter
        else
            builddialog = builddialog..letter
        end
        if (letter == ">") then
            buildingspecial = false
            local PostInsert = GetDiaPostProcesSpecial(buildspecial,truetargetname)
            builddialog = builddialog..PostInsert
            if (buildspecial == "<randomsapbot>") then
                truetargetname = PostInsert
            end
            buildspecial = ""
        end
    end
    builddialog = string.sub (builddialog, 1, #builddialog - 1)
    return(builddialog)
end
function GetDiaPostProcesSpecial(special,targetname)
    local returning = ""
    if (special == "<entityname>") then returning = targetname end
    if (special == "<randomsapbot>") then
        local outputsapbot = NULL
        local possiblesaps = {}
        for k,pusybot in ipairs(_SAPBOTS) do
            if (IsValid(pusybot) and pusybot != NULL and pusybot != nil) then
            table.insert(possiblesaps,pusybot)
            end
        end
        outputsapbot = possiblesaps[math.random(1,#possiblesaps)]

        if (outputsapbot != nil and outputsapbot != NULL and randomsapbotin != "") then
            returning = GetBestName(outputsapbot)
        end
    end
    if (special == "<mapname>") then returning = game.GetMap() end
    if (special == "<randommap>") then returning = _SapbotDG_RandomMapNames[math.random(1,#_SapbotDG_RandomMapNames)] end
    return(returning)
end

--REGISTER A NEW DIALOG TREE SET HERE!!!!
function BuildDialogTreeSet(SetName,toxic_to_ent,love_ent,like_ent,dislike_ent,hate_ent,convo_norm,idle_norm) --builds an entire dialog tree set for all the input'd dialog
    local buildset = {} --note that dialog is ran through some ai rng bullshit, simply the combinations of what words go after other words in these tables defines how it will gen, keep that in mind
    buildset["toxic_to_ent"] = BuildDialogTree(toxic_to_ent)
    buildset["love_ent"] = BuildDialogTree(love_ent)
    buildset["like_ent"] = BuildDialogTree(like_ent)
    buildset["dislike_ent"] = BuildDialogTree(dislike_ent)
    buildset["hate_ent"] = BuildDialogTree(hate_ent)
    buildset["idle_norm"] = BuildDialogTree(idle_norm)
    buildset["convo_norm"] = BuildConvoDialogTree(convo_norm["Start"],convo_norm["Reply"])
    _SapbotDG_DialogSetTrees[SetName] = buildset --Register The Set!!!!!!!!
    print("S.A.P Bot Dialog Tree Set ("..SetName..") built, baked, and loaded.")
    --PrintTable(buildset) --fun
end

function BuildConvoDialogTree(starttree,replytree) --like BuildDialogTree.. but builds a dialog tree but for Conversations instead of normal information
    local convotree = {}
    convotree["Start"] = BuildDialogTree(starttree)
    convotree["Reply"] = BuildDialogTree(replytree)
    return(convotree)
end

function BuildDialogTree(inputtable) --builds a dialog tree to go into a dialog tree set
    local diatree = {}
    diatree["Starts"] = BakeDialogSetStarts(inputtable)
    diatree["Dialog"] = BakeDialogSet(inputtable)
    return(diatree)
end

function OverrideAddIndex(inputtable,inputentry) --check if a table contains the input, if not then there's a free spot and it adds it into that free spot.
    local can = true
    for k,thisentry in ipairs(inputtable) do
        if (thisentry == inputentry) then
            can = false
            return
        end
    end
    if (can) then
        table.insert(inputtable,inputentry)
    end
end

function BakeDialogSetStarts(dialogset) --bake all line starting words of the set, returning a table of every word every line starts with
    local tempsetwords = {}
    for k,line in ipairs(dialogset) do
        local firstword = ""
        for word in line:gmatch("%S+") do
            if (firstword == "") then
                firstword = word
                table.insert(tempsetwords,word)
            end
        end
    end
    return(tempsetwords)
end

function BakeDialogSet(dialogset) --bake a set of dialog into a returned baked dialog set of all possible combinations of letters
    local tempsetwords = {}
    for k,line in ipairs(dialogset) do
        --local gmathwords = line:gmatch("%S+")
        local gmathcount = 0
        local glemath = {}
        for word in line:gmatch("%S+") do --grab all the words
            table.insert(glemath,word)
        end

        for k,word in ipairs(glemath) do --for each word
            gmathcount = gmathcount + 1 --count forward cause weird math workaround
            if (word != "<end>") then
                if (tempsetwords[word] == nil) then --register new possible word for this set if can
                    tempsetwords[word] = {glemath[gmathcount + 1]}

                    for k,subline in ipairs(dialogset) do --go over everything again and check for this word, then grab the word after every instance of this word and determine if it can be added to the total combinations
                        local subglemath = {}
                        for word in subline:gmatch("%S+") do
                            table.insert(subglemath,word)
                        end
                        local subgmathcount = 0
                        for k,subword in ipairs(subglemath) do --each sub-word
                            subgmathcount = subgmathcount + 1 
                            if (subword == word) then
                                OverrideAddIndex(tempsetwords[word],subglemath[subgmathcount + 1]) --add combination possibility
                            end
                        end
                    end
                end
            end
        end
    end
    return(tempsetwords)
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cache all player models
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function CacheAllPlayerModels() --nevermind smh, may rework this concept later
    -- local allmodelsraw = table.Copy(player_manager.AllValidModels())
    -- table.ClearKeys(allmodelsraw)
    -- _Sapbot_Playermodels = allmodelsraw
    --print("S.A.P Bot Playermodels cached")
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- > TTS STUFF <
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
--format text to be phonemes so the tts system can produce a correct series of sounds
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

function SplitTTSscript(ttsscript)
    local allsounds = {}
    local buildphoneme = ""
    local buildingphoneme = false
    for l = 1, #ttsscript do
        local letter = ttsscript:sub(l,l)
        if (letter == ">") then
            buildingphoneme = false
            table.insert(allsounds,buildphoneme)
            buildphoneme = ""
        end
        if ((letter == " ") or (letter == ",")) then
            table.insert(allsounds,"_wait_") --used as a sorta pause in audio
        end
        if (buildingphoneme) then buildphoneme = buildphoneme..letter end
        if (letter == "<") then buildingphoneme = true end
    end
    return(allsounds)
end

-- main build tts function
function ToTTSscript(inputtext,ttsset)
    --["name"] = dir,["files"] = myfiles,["words"] = mywords

    --print("Transforming ("..inputtext..") to a TTS script")
    local buildtext = ""
    --PrintTable(_SapbotDG_TTSphonemes)
    local numoffset = 0
    local ttssetpull = ttsset
    for le = 1, #inputtext do
        if (le < (#inputtext + 1)) then --range push
            l = (le + numoffset)
            local letter = inputtext:sub(l,l)
            --for each letter in the main text
            local wordoreplace = ""
            if (!table.IsEmpty(ttssetpull["words"])) then --word preset overrides
                for tl,tword in pairs(ttssetpull["words"]) do
                    local twordcheck = inputtext:sub(l,l + #tl - 1)
                    if (twordcheck == tl) then
                        wordoreplace = tl
                    end
                end
            end

            if (wordoreplace == "") then --if not word override thing
                local mypossiblegraphemes = {}
                for phonemename,phonemefold in pairs(_SapbotDG_TTSphonemes) do
                    for j,grapheme in ipairs(phonemefold["Graphemes"]) do --for each grapheme possible
                        local replaces, containdir, mustcontain = GraphemeFuncs(grapheme)
                        local replacesub = inputtext:sub(l,l + (#replaces - 1))
                        local CanDo = false
                        if ((l + #replaces - 1) < #inputtext + 1) then --cant be larger to replace then the damn length of the fucking input text lol

                            if (!((#replaces - 1) > (#grapheme)) and !(((#replaces - 1) + #mustcontain[2]) > (#grapheme)) and !((l - #mustcontain[1]) < 1)) then --gotta be within range to avoid error of trying to grab nothing
                                replaces = UnderscorFillGaps(inputtext,replaces,l)
                                if (replacesub == replaces) then
                                    if ((mustcontain[1] == false) and (mustcontain[2] == false)) then
                                        CanDo = true
                                    else
                                        local containdirtruth = {1,1}
                                        if (containdir[2]) then --positive direction, must check
                                            if (!(inputtext:sub((l + #replaces),(l + #replaces + (#mustcontain[2] - 1))) == UnderscorFillGaps(inputtext,mustcontain[2],(l + #replaces)))) then
                                                containdirtruth[2] = 0
                                                --print("if "..inputtext:sub((l + #replaces),(l + #replaces + (#mustcontain[2] - 1))).." = "..UnderscorFillGaps(inputtext,mustcontain[2],(l + #replaces)).." failed")
                                            else
                                                --print("if "..inputtext:sub((l + #replaces),(l + #replaces + (#mustcontain[2] - 1))).." = "..UnderscorFillGaps(inputtext,mustcontain[2],(l + #replaces)).." succeeded")
                                            end
                                        end
                                        if (containdir[1]) then--negative direction, must check
                                            --print("if "..inputtext:sub((l - #mustcontain[1]),(l - 1)).." = "..UnderscorFillGaps(inputtext,mustcontain[1],(l - #mustcontain[1])))
                                            if (!(inputtext:sub((l - #mustcontain[1]),(l - 1)) == UnderscorFillGaps(inputtext,mustcontain[1],(l - #mustcontain[1] - 1)))) then
                                                containdirtruth[1] = 0
                                                --print("if "..inputtext:sub(((l - #mustcontain[1])),(l - 1)).." = "..UnderscorFillGaps(inputtext,mustcontain[1],(l - #mustcontain[1] - 1)).." failed")
                                            else
                                                --print("if "..inputtext:sub(((l - #mustcontain[1])),(l - 1)).." = "..UnderscorFillGaps(inputtext,mustcontain[1],(l - #mustcontain[1] - 1)).." succeeded")
                                            end
                                        end
                                        if (containdirtruth[1] == 1 and containdirtruth[2] == 1) then
                                            CanDo = true
                                        end
                                    end
                                end
                                if (CanDo) then --insert possible phoneme into possible
                                    table.insert(mypossiblegraphemes,{["phoneme"] = phonemefold["Phoneme"],["replaces"] = replaces,["rawgrapheme"] = grapheme})
                                end
                            end
                        end
                    end
                end
                if (mypossiblegraphemes != nil) then --build phoneme
                    if (!table.IsEmpty(mypossiblegraphemes)) then 
                        local heavygraphemes = GetHeaviestGraphemes(mypossiblegraphemes)
                        local graphemeoutcome = {}
                        for j,randomgrapheme in RandomPairs(heavygraphemes) do
                            graphemeoutcome = randomgrapheme
                            break
                        end
                        numoffset = (numoffset + (#graphemeoutcome["replaces"]) - 1) -- ?
                        buildtext = buildtext.."<"..graphemeoutcome["phoneme"]..">"
                    end
                end
                if (letter == " ") then
                    buildtext = buildtext.." "
                end
                if (letter == ",") then
                    buildtext = buildtext..","
                end
            else --if word override thing
                numoffset = (numoffset + (#wordoreplace) - 1) -- ?
                buildtext = buildtext.."<"..wordoreplace..">"
            end
        end
    end
    return(buildtext)
end

function GetDefaultOpinion(entityinput,default)
    local presetrelations = {
        {["class"] = "npc_monk", ["opinion"] = default},
        {["class"] = "npc_combine_camera", ["opinion"] = -1},
        {["class"] = "npc_turret_ceiling", ["opinion"] = -2},
        {["class"] = "npc_cscanner", ["opinion"] = default},
        {["class"] = "npc_combinedropship", ["opinion"] = -0.1},
        {["class"] = "CombineElite", ["opinion"] = -2.5},
        {["class"] = "npc_combinegunship", ["opinion"] = -2},
        {["class"] = "npc_combine_s", ["opinion"] = -2},
        {["class"] = "npc_helicopter", ["opinion"] = -2},
        {["class"] = "npc_manhack", ["opinion"] = -1},
        {["class"] = "npc_metropolice", ["opinion"] = -1.9},
        {["class"] = "CombinePrison", ["opinion"] = -2},
        {["class"] = "PrisonShotgunner", ["opinion"] = -2.1},
        {["class"] = "npc_rollermine", ["opinion"] = -1},
        {["class"] = "npc_clawscanner", ["opinion"] = -1.9},
        {["class"] = "ShotgunSoldier", ["opinion"] = -2.1},
        {["class"] = "npc_stalker", ["opinion"] = default - 1},
        {["class"] = "npc_strider", ["opinion"] = -2.3},
        {["class"] = "npc_turret_floor", ["opinion"] = -2.5},
        {["class"] = "npc_alyx", ["opinion"] = default},
        {["class"] = "npc_barney", ["opinion"] = default},
        {["class"] = "npc_citizen", ["opinion"] = default},
        {["class"] = "npc_dog", ["opinion"] = default - 0.2},
        {["class"] = "npc_kleiner", ["opinion"] = default},
        {["class"] = "npc_mossman", ["opinion"] = default},
        {["class"] = "npc_eli", ["opinion"] = default},
        {["class"] = "npc_gman", ["opinion"] = default - 0.2},
        {["class"] = "Medic", ["opinion"] = default},
        {["class"] = "npc_odessa", ["opinion"] = default - 0.1},
        {["class"] = "Rebel", ["opinion"] = default},
        {["class"] = "Refugee", ["opinion"] = default},
        {["class"] = "npc_vortigaunt", ["opinion"] = default},
        {["class"] = "VortigauntSlave", ["opinion"] = default},
        {["class"] = "npc_bree", ["opinion"] = default - 0.1},
        {["class"] = "S.A.P Bot", ["opinion"] = default},
        {["class"] = "npc_antlion", ["opinion"] = -1},
        {["class"] = "npc_antlionguard", ["opinion"] = -2.5},
        {["class"] = "npc_barnacle", ["opinion"] = -1},
        {["class"] = "npc_headcrab_fast", ["opinion"] = -1.8},
        {["class"] = "npc_fastzombie", ["opinion"] = -2.5},
        {["class"] = "npc_fastzombie_torso", ["opinion"] = -2},
        {["class"] = "npc_headcrab", ["opinion"] = -1.2},
        {["class"] = "npc_headcrab_black", ["opinion"] = -2},
        {["class"] = "npc_poisonzombie", ["opinion"] = -2.5},
        {["class"] = "npc_zombie", ["opinion"] = -1.9},
        {["class"] = "npc_zombie_torso", ["opinion"] = -1},
        {["class"] = "npc_zetaplayer", ["opinion"] = -3}
    }
    local output = default
    for k,entry in pairs(presetrelations) do
        if (entry["class"] == entityinput:GetClass()) then
            output = entry["opinion"]
        end
    end
    return(output)
end

-- useful line segmenting function thing
function SplitToMultipleLines(textinput,sizelimit) --limits some text to a size limit and crops every word past that into a new line for each
    local words = {}
    for word in textinput:gmatch("%S+") do
        table.insert(words,word)
    end
    local lengthsofar = 0
    local lines = {""}
    local on_line = 1
    for j,word in pairs(words) do
        lengthsofar = lengthsofar + #word + 1
        if (lengthsofar > sizelimit) then
            table.insert(lines,word)
            on_line = on_line + 1
            lengthsofar = 0
        else
            lines[on_line] = lines[on_line].." "..word
        end
    end
    return(lines)
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
--finds _ and replaces with input main text according to number pos lfirst
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
function UnderscorFillGaps(inputtext,grapheme,lfirst)
    local output = ""
    for l = 1, #grapheme do
        local letternum = (lfirst + (l - 1))
        local trueletter = inputtext:sub(letternum,letternum)
        local graphemeletter = grapheme:sub(l,l)
        if (graphemeletter == "_") then
            output = output..trueletter
        else
            output = output..graphemeletter
        end
    end
    return(output)
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- find the longest options out of a bunch of graphemes
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
function GetHeaviestGraphemes(graphemes)
    local maxlengthfound = 0
    local allpossible = {}
    for j,grapheme in pairs(graphemes) do --get max length out of all found
        if (#grapheme["rawgrapheme"] > maxlengthfound) then
            maxlengthfound = #grapheme["rawgrapheme"]
        end
    end
    for k,grapheme_ in pairs(graphemes) do --find all of max length
        if (#grapheme_["rawgrapheme"] == maxlengthfound) then
            table.insert(allpossible,grapheme_)
        end
    end
    return(allpossible) --return all with max length found
end

function GraphemeFuncs(grapheme)
    local mustcontain = {"",""} --what the text needs to contain to have this be a possible grapheme
    local replaces = "" --what the grapheme replaces - is also valid by
    local buildingmust = false
    local containdir = {false, false} --what direction the mustcontain flag is in
    local amountofmusts = 0

    for gl = 1, #grapheme do --grapheme processing
        local ThisLete = grapheme:sub(gl,gl)
        if (ThisLete == "(") then
            if (gl == 1) then
                containdir[1] = true
            end
            buildingmust = true
            amountofmusts = amountofmusts + 1
            if (gl > 1) then
                containdir[2] = true
            end
        elseif (ThisLete == ")") then
            buildingmust = false
        end

        if (ThisLete != "(" and ThisLete != ")") then
            if (buildingmust) then
                if (containdir[1]) then -- build what it must contain
                    mustcontain[amountofmusts] = mustcontain[amountofmusts]..ThisLete
                else
                    mustcontain[2] = mustcontain[2]..ThisLete
                end
            else
                replaces = replaces..ThisLete --build what it contains
            end
        end
    end
    return replaces,containdir,mustcontain
end

function GatherAllTTS() --run once after every mod has loaded everything, simply fills _SapbotDG_TTSSets with any tts sets found in sound/sapbots/tts/NAME_OF_ADDON... phonem... and etc
    local exists = (file.Exists( "sound/sapbots/tts", "GAME" )) --eh why do i even check for this lol, eh i'm lazy i'll leave it in here cause why not
    if (exists) then
        local files, directories = file.Find("sound/sapbots/tts/*", "GAME")
        for k,dir in pairs(directories) do --for each tts such as "main"
            if (dir != nil) then --if tts dir isn't nothing
                local nrootsubfiles, nrootsubdirs = file.Find("sound/sapbots/tts/"..dir.."/*", "GAME")
                local myfiles = {}
                local mywords = {}
                local mydeaths = {}
                for nk,worddir in pairs(nrootsubdirs) do --for each dir such as "phonem"
                    if (worddir == "phonem") then --gather all phonemes
                        local subfiles, subdirs = file.Find("sound/sapbots/tts/"..dir.."/"..worddir.."/*", "GAME")
                        for j,file in pairs(subfiles) do
                            local SubStrWav = SubtractWavType(file)
                            local soundaddname = ("sapbot_tts_"..dir.."_"..SubStrWav)
                            sound.Add({
                                name = soundaddname,
                                channel = CHAN_VOICE,
                                volume = 1,
                                level = SNDLVL_60dB,
                                pitch = {99, 101},
                                sound = "sapbots/tts/"..dir.."/"..worddir.."/"..file
                            })
                            myfiles[SubStrWav] = {["name"] = soundaddname,["file"] = ("sapbots/tts/"..dir.."/"..worddir.."/"..file)}
                            --print("S.A.P Bot TTS Cached (sapbot_tts_"..dir.."_"..SubtractWavType(file)..")")
                        end
                    elseif (worddir == "words") then
                        local subfiles, subdirs = file.Find("sound/sapbots/tts/"..dir.."/"..worddir.."/*", "GAME")
                        for j,file in pairs(subfiles) do
                            local SubStrWav = SubtractWavType(file)
                            local soundaddname = ("sapbot_tts_"..dir.."_"..SubStrWav)
                            sound.Add({
                                name = soundaddname,
                                channel = CHAN_VOICE,
                                volume = 1,
                                level = SNDLVL_60dB,
                                pitch = {99, 101},
                                sound = "sapbots/tts/"..dir.."/"..worddir.."/"..file
                            })
                            mywords[SubStrWav] = {["name"] = soundaddname,["file"] = ("sapbots/tts/"..dir.."/"..worddir.."/"..file)}
                        end
                    elseif (worddir == "deaths") then -- for all death sounds if any
                        local subfiles, subdirs = file.Find("sound/sapbots/tts/"..dir.."/"..worddir.."/*", "GAME")
                        for j,file in pairs(subfiles) do
                            local deathname = ("sapbots/tts/"..dir.."/deaths/"..file)
                            local deathnamefilt = ("sapbot_tts_"..dir.."_death_"..SubtractWavType(file))
                            sound.Add({
                                name = deathnamefilt,
                                channel = CHAN_VOICE,
                                volume = 1,
                                level = SNDLVL_60dB,
                                pitch = {99, 101},
                                sound = "sapbots/tts/"..dir.."/"..worddir.."/"..file
                            })
                            table.insert(mydeaths,{["file"] = deathname,["name"] = deathnamefilt})
                        end
                    end
                end
                _SapbotDG_TTSSets[dir] = {
                    ["name"] = dir,["files"] = myfiles,["words"] = mywords,["deaths"] = mydeaths
                }
                --PrintTable(_SapbotDG_TTSSets[dir])
                print("S.A.P Bot TTS Cached : "..dir)
            end
        end
    else
        print("S.A.P Bots Unable to Locate TTS Dir??")
    end
    GatherAllSoundboards()
end

function GatherAllSoundboards()
    local exists = (file.Exists( "sound/sapbots/soundboards", "GAME" ))
    if (exists) then
        local files, directories = file.Find("sound/sapbots/soundboards/*", "GAME")
        for k,dir in pairs(directories) do
            if (dir != nil) then --if soundboard dir not nil then populate
                local nrootsubfiles, nrootsubdirs = file.Find("sound/sapbots/soundboards/"..dir.."/*", "GAME")
                local soundboardcontent = {}
                for nk,worddir in pairs(nrootsubdirs) do
                    soundboardcontent[worddir] = {}
                    local subfiles, subdirs = file.Find("sound/sapbots/soundboards/"..dir.."/"..worddir.."/*", "GAME")
                    for j,file in pairs(subfiles) do
                        soundboardcontent[worddir][SubtractWavType(file)] = ("sapbots/soundboards/"..dir.."/"..worddir.."/"..file)
                    end
                end
                _SapbotDG_Soundboards[dir] = soundboardcontent
                print("S.A.P Bot Soundboard Cached : "..dir)
            end
        end
    else
        print("S.A.P Bots Unable to Locate Soundboards Dir??")
    end
end

function SubtractWavType(fileinput) --removes 4 digits from a string, removing the .wav
    return(string.sub(fileinput,1,#fileinput - 4))
end

-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Name Generation
-- -- -- -- -- -- -- -- -- -- -- -- -- --
function GenerateName() --outputs a procedural name
    local resultname = _SapbotNamesRandom[math.random(1,#_SapbotNamesRandom)] --name outcome, builds name
    if (math.random(1,8) == 1) then --prefix
        if (math.random(1,2) == 1) then resultname = " "..resultname end
        resultname = _SapbotNamesPrefix[math.random(1,#_SapbotNamesPrefix)]..resultname
    end
    if (math.random(1,8) == 1) then --suffix
        if (math.random(1,2) == 1) then resultname = resultname.." " end
        resultname = resultname.._SapbotNamesSuffix[math.random(1,#_SapbotNamesSuffix)]
    end
    return(resultname)
end

-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- World Model to Hold Type
-- -- -- -- -- -- -- -- -- -- -- -- -- --
function WMtoHoldType(worldmodel) --inputs a world model of a weapon, outputs a hold type
    if (IsValid(_SapbotWMtoHT[worldmodel]) and _SapbotWMtoHT[worldmodel] != nil) then
        return(_SapbotWMtoHT[worldmodel])
    else --if none is found, defaults to normal holdtype, for more cross-compatibility :)
        return("normal")
    end 
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- Sap Bot Player List Scoreboard Thing
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
hook.Add( "ScoreboardShow", "SapDetScorebOpen", function()
    sapscoreboardrender = true
end )
hook.Add( "ScoreboardHide", "SapDetScorebClose", function()
	sapscoreboardrender = false
end )

hook.Add( "PreDrawHalos", "SapPlaySelGlow", function()
    if (sapscoreboardrender) then
        if (_SAPBOTS != nil) then
            local scrw, scrh = ScrW(), ScrH()
            local truescale = Vector(0,0,0)
            if (_SAPBOTS == nil) then
                truescale = Vector(256,512,0)
            else
                local amountcounter = 0
                for k,v in pairs(_SAPBOTS) do
                    if (IsValid(v) and v != nil) then
                        amountcounter = amountcounter + 1
                    end
                end
                truescale = Vector(256,(amountcounter * 20) + 40,0)
            end
            local NamePos = Vector(0,0,0)
            local menudimensions = Vector(truescale.x + ((math.sin(CurTime() * 2) + 2) * 8),truescale.y + ((math.sin(CurTime() * -1.5) + 2) * 8),0)
            local truepos = Vector(scrw * 0.85,scrh * 0.1,0)
            local sapmenupos = Vector(truepos.x - (menudimensions.x / 2),truepos.y - ((math.sin(CurTime() * -1.5) + 2) * 8),0)
            local ToGlow = {}
            for k,v in pairs(_SAPBOTS) do
                if (IsValid(v) and v != nil) then
                    local mynamepos = Vector((sapmenupos.x + 58) - 44,(sapmenupos.y + (NamePos.y * 20)) + 40,0)
                    local MouseposX, MouseposY = input.GetCursorPos()
                    local MouseDist = Vector(math.abs((MouseposX - truepos.x)),math.abs(MouseposY - mynamepos.y),0)
                    local MouseDistNum = 255
                    if ((MouseDist.x * 1.65) < 255) then
                        MouseDistNum = (MouseDist.y * 4)
                        if (MouseDistNum < 64) then
                            table.insert(ToGlow,v)
                        end
                    end
                    NamePos = Vector(NamePos.x,(NamePos.y + 1),0)
                end
            end
            halo.Add(ToGlow, Color(0,255,0,255), 4, 4, 16, true, true)
        end
    end
end)

-- Draw Scoreboard of Sap Bots
hook.Add( "HUDDrawScoreBoard", "SapbotScoreboard", function()
        if (sapscoreboardrender) then
            local scrw, scrh = ScrW(), ScrH()
            local truescale = Vector(0,0,0)
            if (_SAPBOTS == nil) then
                truescale = Vector(256,512,0)
            else
                local amountcounter = 0
                for k,v in pairs(_SAPBOTS) do
                    if (IsValid(v) and v != nil) then
                        amountcounter = amountcounter + 1
                    end
                end
                truescale = Vector(256,(amountcounter * 20) + 40,0)
                if (amountcounter != nil and amountcounter > 0) then
                    local menudimensions = Vector(truescale.x + ((math.sin(CurTime() * 2) + 2) * 8),truescale.y + ((math.sin(CurTime() * -1.5) + 2) * 8),0)
                    local truepos = Vector(scrw * 0.85,scrh * 0.1,0)
                    local sapmenupos = Vector(truepos.x - (menudimensions.x / 2),truepos.y - ((math.sin(CurTime() * -1.5) + 2) * 8),0)

                    surface.SetDrawColor( 0, 64, 0, 128 )
                    surface.DrawRect(sapmenupos.x,sapmenupos.y, menudimensions.x, menudimensions.y )
                    for i=1,16,1 do
                        surface.SetDrawColor( 0, 255, 0, 10 )
                        surface.DrawOutlinedRect( sapmenupos.x, sapmenupos.y, menudimensions.x, menudimensions.y, ((((math.sin(CurTime() * 2) + 2) * 0.25) + math.Rand(0,0.05)) * (20 / i)) + 2 )
                        surface.SetDrawColor( 255, 255, 255, 2 )
                        surface.DrawOutlinedRect( sapmenupos.x, sapmenupos.y + (menudimensions.y * math.Rand(0,1)), menudimensions.x, math.Rand(8,16), 3)
                    end
                    local CoolThing = CoolSapTextArt()
                    surface.SetFont("TargetID")
                    surface.SetTextPos((sapmenupos.x + (menudimensions.x / 2)) - 50,sapmenupos.y + 6) --text shadow
                    surface.SetTextColor( 0, 255, 0, 100 )
                    surface.DrawText( CoolThing.."S.A.P Bots"..CoolThing, nil)
                    surface.SetTextPos((sapmenupos.x + (menudimensions.x / 2)) - 48,sapmenupos.y + 8) --text main
                    surface.SetTextColor( 0, 255, 0, 255 )
                    surface.DrawText( CoolThing.."S.A.P Bots"..CoolThing, nil)
                    if (_SAPBOTS != nil) then
                        local NamePos = Vector(0,0,0)
                        for k,v in pairs(_SAPBOTS) do --player text stuff
                            if (IsValid(v) and v != nil) then
                                local mynamepos = Vector((sapmenupos.x + 58) - 44,(sapmenupos.y + (NamePos.y * 20)) + 40,0)
                                local MouseposX, MouseposY = input.GetCursorPos()
                                --local DistToMouse = Vector(MouseposX,MouseposY,0):Distance(Vector(truepos.x,mynamepos.y,0))
                                surface.SetTextPos(mynamepos.x,mynamepos.y)
                                local MouseDist = Vector(math.abs((MouseposX - truepos.x)),math.abs(MouseposY - mynamepos.y),0)
                                local MouseDistNum = 255
                                if ((MouseDist.x * 1.65) < 255) then
                                    MouseDistNum = (MouseDist.y * 4)
                                end
                                surface.SetTextColor(255 - MouseDistNum, 255, 255 - MouseDistNum, 255 )
                                surface.DrawText(v:GetNW2String("Sap_Name"), nil)
                                NamePos = Vector(NamePos.x,(NamePos.y + 1),0)
                            end
                        end
                    end
                end
            end
        end
end )

-- utility ent vision finding
function FindEntsInVision(me,radius,filt)
    local outcome = {}
    local circlcheck = ents.FindInSphere(me:GetPos(),radius)
    for k,v in ipairs(circlcheck) do
        if (filt == nil or filt(v) == true) then
            --local trac = trace.TraceLine({start = me:GetPos()+me:OBBCenter(),endpos = v:GetPos()+v:OBBCenter(),filt = me})
            --if (trac.Entity == v and IsValid(v) or trac.Entity:IsVehicle() and isfunction(trac.Entity.GetDriver) and trac.Entity:GetDriver() == v) then
                table.insert(outcome,v)
            --end
        end
    end
    return(outcome)
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- Cool Text Art thing
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
function CoolSapTextArt()
    --originally specifically for the sap bot creator tool screen, made it into a cool function / utility cause ease of access
    local CoolTx = ""
    local TimeMathStuf = (CurTime() * 2)
    local CoolTxMath = (TimeMathStuf - (math.floor(TimeMathStuf / 2) * 2)) - 1
    if (CoolTxMath < -0.5) then
    CoolTx = "-"
    elseif (CoolTxMath < 0) then CoolTx = [[\]]
    elseif (CoolTxMath < 0.5) then CoolTx = "|"
    elseif (CoolTxMath < 1) then CoolTx = "/" end
    return(CoolTx)
end

function GetCurTimeBatch() --returns a useful 'lil general number for the batch in time, changes every now 'n again, used for dataset batching for knowing what group of stuff is what while still being cheap
    --MUST BE SERVER SIDE ONLY, CLIENTS CANNOT KNOW THE EXACT VALUE O_O''
    return(math.floor(os.time(os.date("!*t")) * 0.04))
end

function GetBestName(entity)
    local nametouse = "ERROR"
    if (entity != NULL and entity != nil) then
        local donealready = false
        local reformat = false
        if (entity.Sap_Name != nil) then
            nametouse = entity.Sap_Name
            donealready = true
        end
        if (entity:GetName() ~= nil and !donealready) then
            if (entity:GetName() != NULL and entity:GetName() != nil and entity:GetName() != "" and entity:GetName() != " " and entity:GetName() != ".") then
                nametouse = entity:GetName()
                donealready = true
                reformat = true
            end
        end
        if (entity.zetaname != nil and !donealready) then
            if (entity.zetaname != nil and entity.zetaname != "" and entity.zetaname != " " and entity.zetaname != "," and entity.zetaname != "." and entity.zetaname != " ") then
                nametouse = entity.zetaname
                donealready = true
            end
        elseif (entity:IsPlayer()) then
            if (entity:Name() != "" and entity:Name() != "," and entity:Name() != "." and entity:Name() != " ") then
                nametouse = entity:Name()
                donealready = true
            end
        end
        if (!donealready) then --failsafe outcome, class name
            nametouse = entity:GetClass()
            donealready = true
            reformat = true
        end
        if (reformat) then --if it should reformat names such as npc_combine bla bla bla
            nametouse = string.gsub(nametouse, "npc_", "")
            nametouse = string.gsub(nametouse, "_", " ")
        end

        return(nametouse)
    else
        print("S.A.P Bot Unable To Get Entity name from a NULL Entity")
        return(nil)
    end
end

function GetResSoundboarders(entit,radi)
    local _ents = ents.FindInSphere(entit:GetPos(), radi)
    for k,v in ipairs(_ents) do
        if (v != entit) then
            if (v.SapSoundboardCurrent != NULL and v.SapSoundboardCurrent != nil) then
                if (v.SapSoundboardCurrent != false) then
                    return(true)
                end
            end
        end
    end
    return(false)
end

-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Hold Type to Animation
-- -- -- -- -- -- -- -- -- -- -- -- -- --
function HTgetAnimIdle(holdtype) --get Idle animation num from hold type, for usage in Act 'n etc
    if (_SapbotHTcIdle[holdtype] != nil) then
        return(_SapbotHTcIdle[holdtype])
    else return(_SapbotHTcIdle["normal"]) end --else then return the normal holdtype animation num
end
function HTgetAnimRun(holdtype) --get Run animation num from hold type, for usage in Act 'n etc
    if (_SapbotHTcRun[holdtype] != nil) then
        return(_SapbotHTcRun[holdtype])
    else return(_SapbotHTcRun["normal"]) end --else then return the normal holdtype animation num
end
function HTgetAnimIdleCrouch(holdtype) --get Idle Crouch animation num from hold type, for usage in Act 'n etc
    if (_SapbotHTcIdleCrouch[holdtype] != nil) then
        return(_SapbotHTcIdleCrouch[holdtype])
    else return(_SapbotHTcIdleCrouch["normal"]) end --else then return the normal holdtype animation num
end
function HTgetAnimWalkCrouch(holdtype) --get Walking Crouch animation num from hold type, for usage in Act 'n etc
    if (_SapbotHTcWalkCrouch[holdtype] != nil) then
        return(_SapbotHTcWalkCrouch[holdtype])
    else return(_SapbotHTcWalkCrouch["normal"]) end --else then return the normal holdtype animation num
end
function HTgetAnimJump(holdtype) --get Jump animation num from hold type, for usage in Act 'n etc
    if (_SapbotHTcJump[holdtype] != nil) then
        return(_SapbotHTcJump[holdtype])
    else return(_SapbotHTcJump["normal"]) end --else then return the normal holdtype animation num
end
function HTgetAnimRangeAttack(holdtype) --get Ranged Attack / Attack animation num from hold type, for usage in Act 'n etc
    if (_SapbotHTcRangeAttack[holdtype] != nil) then
        return(_SapbotHTcRangeAttack[holdtype])
    else return(_SapbotHTcRangeAttack["normal"]) end --else then return the normal holdtype animation num
end
function HTgetAnimReload(holdtype) --get Weapon / Tool : Reload animation num from hold type, for usage in Act 'n etc
    if (_SapbotHTcReload[holdtype] != nil) then
        return(_SapbotHTcReload[holdtype])
    else return(_SapbotHTcReload["normal"]) end --else then return the normal holdtype animation num
end
function HTgetAnimIdleSwim(holdtype) --get Idle Swim animation num from hold type, for usage in Act 'n etc
    if (_SapbotHTcIdleSwim[holdtype] != nil) then
        return(_SapbotHTcIdleSwim[holdtype])
    else return(_SapbotHTcIdleSwim["normal"]) end --else then return the normal holdtype animation num
end
function HTgetAnimSwim(holdtype) --get Swimming animation num from hold type, for usage in Act 'n etc
    if (_SapbotHTcSwim[holdtype] != nil) then
        return(_SapbotHTcSwim[holdtype])
    else return(_SapbotHTcSwim["normal"]) end --else then return the normal holdtype animation num
end
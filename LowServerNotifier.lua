-- this script was made by @AntiPixel (.antipixel) and modified to work with Koro Hub
local Args = {...};
local WebhookUrl = Args[1];

repeat wait(0.25) until game:IsLoaded()
repeat wait(0.25) until getgenv().UsingLowServerNotifier and #game:GetService("Players"):GetPlayers() <= 8 and #game:GetService("Players"):GetPlayers() > 1
local Players = game:GetService("Players"):GetPlayers()
table.remove(Players, 1);

local raceAbilities = { ["Shift"] = "Madrasian", ["Emulate"] = "Navaran", ["Shoulder Throw"] = "Ashiin", ["Galvanize"] = "Cons", ["Soul Rip"] = "Dinakeri", ["Pumpkin Grenade"] = "Dullahan", ["World's Pulse"] = "Dzin", ["Dissolve"] = "Fisch", ["Repair"] = "Gaian", ["Bloodline"] = "Haseldan", ["Respirare"] = "Kasp", ["Exhaust"] = "Mtlscroom", ["Flock"] = "Morvid", ["Flood"] = "Rigan", ["Detoxify"] = "Scroom" }
local classAbilities = { ["Grapple"] = "Shinobi", ["Shadowrush"] = "Shinobi", ["Owl Slash"] = "Shinobi", ["White Fire Charge"] = "Solans", ["Charged Blow"] = "SKC", ["Hyper Body"] = "SKC", ["Azure Ignition"] = "Vanguard", ["Brandish"] = "Vanguard", ["Blade Crash"] = "Vanguard", ["Puncture"] = "Vanguard", ["The Wraith"] = "UltraSpy", ["The Shadow"] = "UltraSpy", ["Elegant Slash"] = "UltraSpy", ["Needle's Eye"] = "UltraSpy", ["Dark Flame Burst"] = "Wraith Knight", ["Dark Eruption"] = "Wraith Knight", ["Swallow Reversal"] = "Samurai", ["Calm Mind"] = "Samurai", ["Demon Flip"] = "Oni", ["Axe Kick"] = "Oni", ["Demon Step"] = "Oni", ["Secare"] = "Necro", ["Furantur"] = "Necro", ["Command Monsters"] = "Necro", ["Howler Summoning"] = "Necro", ["Observe"] = "Illu", ["Globus"] = "Illu", ["Intermissum"] = "Illu", ["Dominus"] = "Illu", ["Hammer"] = "Lapidarist", ["Shadowfan"] = "Faceless", ["Ethereal Strike"] = "Faceless", ["Verdien"] = "Druid", ["Fons Vitae"] = "Druid", ["Perflora"] = "Druid", ["Floresco"] = "Druid", ["Wing Soar"] = "DSlayer", ["Thunder Spear Crash"] = "DSlayer", ["Dragon Awakening"] = "DSlayer", ["Lightning Drop"] = "DSage", ["Lightning Elbow"] = "DSage", ["Deep Sacrifice"] = "DeepKnight", ["Chain Pull"] = "DeepKnight", ["Song of Lethargy"] = "UltraBard", ["Sweet Soothing"] = "UltraBard", ["Joyous Dance"] = "UltraBard", ["Ocean's Protection"] = "Spearfisher", ["Fisherman's Trap"] = "Spearfisher", ["Tidal Trident"] = "Spearfisher", ["Wrathful Leap"] = "Abyss Walker", ["Abyssal Scream"] = "Abyss Walker" }
local specAbilities = { "Time Erase", "Wallet Swipe", "Jester's Scheme", "Time Halt", "Jester's Ruse", "Mederi Major", "Mori", "Pondus", "Ray of Frost", "Darkness", "Restrain", }

local ping = math.round(game:GetService("Players").LocalPlayer:GetNetworkPing() * 1000)
local region = game:GetService("Players").LocalPlayer.PlayerGui.ServerStatsGui.Frame.Stats.ServerRegion.ContentText; region = string.gsub(region, "^Server Region: ", "")

function getEdict(player)
    if player.Backpack:FindFirstChild("Verto") then return "Blademaster" end
    if player.Backpack:FindFirstChild("Mederi") then return "Healer" end
    if player.Backpack:FindFirstChild("Analysis") then return "Seer" end
    return ""
end

function isModspecBuild(player)
    for i, ability in pairs(specAbilities) do
        if player.Backpack:FindFirstChild(ability) then
            return true
        end
    end
    return false
end

function getSpells(player)
    local spells = {["Gate"] = "Gate", ["Snarvindur"]="Snarv", ["Hoppa"]="Hoppa", ["Percutiens"]="Perc"}
    local foundSpells = {}

    for spell, shorthand in pairs(spells) do
        if player.Backpack:FindFirstChild(spell) then table.insert(foundSpells, shorthand) end
    end
    return table.concat(foundSpells, ' ')
end

function getArtifact(player)
    local playerData = workspace.Live:FindFirstChild(player.Name)
    local artifact = ""
    if playerData then 
        artifact = playerData.Artifacts:FindFirstChildOfClass("Accessory").Name 
        if artifact == "PhilosophersStone" then artifact = "Philo"; return artifact end
        if artifact == "LannisAmulet" then artifact = "Lannis"; return artifact end
        if artifact == "Spider Cloak" then artifact = "SC"; return artifact end 
    end
    return artifact
end

function getClass(player)
    for ability, class in pairs(classAbilities) do
        if player.Backpack:FindFirstChild(ability) then return class end
    end
    -- Extra illu check since the previous method doesn't always work and I care about illus being in a server
    local playerData = workspace.Live:FindFirstChild(player.Name)
    if playerData then return playerData:FindFirstChild("Observe") and "Illu" or "" end
    return ""
end

function getRace(player)
    for ability, race in pairs(raceAbilities) do
        if player.Backpack:FindFirstChild(ability) then return race end
    end
    local playerData = workspace.Live:FindFirstChild(player.Name)
    if playerData then return playerData:FindFirstChild("AzaelHorn") and "Azael" or "" end
    return ""
end

function fixString(s)
    if s:match("^%s*$") then return '-' end
    local c = string.gsub(s, "%s+", " ")
    c = string.gsub(c, "^%s+", "")
    c = string.gsub(c, "%s+$", "")
    return c
end

local function GetFullCharacterName(User)
    local FIndFirstChild = game.FindFirstChild;
    local FirstName;
    local LastName;
    if (RogueVersion == 'Gaia') then 
        FirstName = User:GetAttribute('FirstName');
        LastName = User:GetAttribute('LastName');
    elseif (FindFirstChild(User, 'leaderstats') and FindFirstChild(User.leaderstats, 'FirstName') and FindFirstChild(User.leaderstats, 'LastName')) then
        FirstName = User.leaderstats.FirstName.Value;
        LastName = User.leaderstats.LastName.Value;
    end;

    FirstName = FirstName or '';
    LastName = LastName or '';

    return LastName ~= '' and FirstName .. ' ' .. LastName or FirstName;
end;

local playerRows = {}
local playerIdList = {}

for i, player in pairs(Players) do
    if (player == game:GetService('Players').LocalPlayer) then continue; end;
    local username = player.Name

    local url = "https://www.roblox.com/users/"..player.UserId.."/profile"
    local markdownLink = "["..username.."]("..url..")"
    
    local fullName = GetFullCharacterName(player)

    local spawned = player.Character and true or false

    local edict = isModspecBuild(player) and "**Modspec**" or getEdict(player)

    local spells = getSpells(player)

    local artifact = getArtifact(player)

    local class = getClass(player)

    local race = getRace(player)

    local t = {edict, race, artifact, class, spells, (spawned ~= true and '(In Menu)' or '')}

    local description = fixString(table.concat(t, ' '))

    local row = {markdownLink, fullName, description}
    playerRows[i] = row

    playerIdList[i] = player.UserId
end

local playersJoinable =  {}

-- constructing the webhook message
local description = ''
local field1 = ''
local field2 = ''

for i, row in pairs(playerRows) do
    local s = playersJoinable[i] and ' (joinable)' or ''
    description = description..row[1]..s..'\n'
    field1 = field1..row[2]..'\n'
    field2 = field2..row[3]..'\n'
end

local footer = ping .. " ms | " .. #Players .. " players" .. " | " .. region .. "\n" .. game.JobId

local msg = {
	["embeds"] = {{
			["title"] = "Small Server Detected (SERVER: " .. game:GetService('ReplicatedStorage'):WaitForChild('ServerInfo', 9e9)[game.JobId].ServerName.Value .. ")",
			["description"] = description,
            ["fields"] = {
                {
                    ["name"] = "Name",
                    ["value"] = field1,
                    ["inline"] = true
                },
                {
                    ["name"] = "Info",
                    ["value"] = field2,
                    ["inline"] = true
                }
            },
            ["color"] = 6219680,
            ["footer"] = {
                ["text"] = footer
            },
            ["timestamp"] = DateTime.now():ToIsoDate(),
        }
    }
}

local response = request({
    Url = WebhookUrl,
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/json"
    },
    Body = game:GetService("HttpService"):JSONEncode(msg)
});
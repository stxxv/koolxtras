--[[
    $$\                  $$$$$$\                $$\                     
    $$ |                $$  __$$\               $$ |                    
    $$ |  $$\  $$$$$$$\ $$ /  \__|$$\   $$\     $$ |$$\   $$\  $$$$$$\
    $$ | $$  |$$  _____|$$$$\     $$ |  $$ |    $$ |$$ |  $$ | \____$$\
    $$$$$$  / \$$$$$$\  $$  _|    $$ |  $$ |    $$ |$$ |  $$ | $$$$$$$ |
    $$  _$$<   \____$$\ $$ |      $$ |  $$ |    $$ |$$ |  $$ |$$  __$$ |
    $$ | \$$\ $$$$$$$  |$$ |      \$$$$$$  |$$\ $$ |\$$$$$$  |\$$$$$$$ |
    \__|  \__|\_______/ \__|       \______/ \__|\__| \______/  \_______|

    info:
        creator discord: .__stav (DM if any issues with script)
        support: https://discord.gg/aeWuPMA5zX

    to-do:
        add finddestinyshard to AutoShard

    exec issues:
        Nexomia: unable to start script
        Madium: crashsploit with firetouchinterest

        Externals (Solara, Xeno): bad fire funcs (touchinterest, proximityprompt)
--]]

local realtime = os.clock()

local cloneref = cloneref or function(obj)
    return obj
end

local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local httpService = cloneref(game:GetService('HttpService'))
local playersService = cloneref(game:GetService('Players'))
local lplr = playersService.LocalPlayer

local vape = shared.vape
local entitylib = vape.Libraries.entity
vape.Place = 14724906937

local run = function(func)
    func()  
end

local function getTool()
	return lplr.Character and lplr.Character:FindFirstChildWhichIsA('Tool', true) or nil
end

local function notif(...)
	return vape:CreateNotification(...)
end

local ksfu = {
    ShardSwords = {
        Cosmicality = {
            Kills = 666666666666,
            ShardsGiven = 12
        },
        Curse = {
            Kills = 50000000000,
            ShardsGiven = 3
        },
        Ruler = {
            Kills = 23500000000,
            ShardsGiven = 3
        },
        Darkstar = {
            Kills = 900000000,
            ShardsGiven = 2
        },
        Apotheosis = {
            Kills = 50000000,
            ShardsGiven = 1
        }
    },
    getKills = function()
        if entitylib.isAlive and lplr.Character:FindFirstChild('Kills') then -- this better not return nil..
            return lplr.Character:FindFirstChild('Kills').Value
        end

        return 0
    end,
    getSword = function()
        if entitylib.isAlive then
            if lplr:FindFirstChild('Backpack') then
                for i,v in lplr.Backpack:GetChildren() do
                    if v:IsA('Tool') and v:FindFirstChild('SwordScript') then
                        return v
                    end
                end
            end

            return nil
        end

        return nil
    end,
    getPortal = function()
        for i,v in workspace.Map:GetChildren() do
            if v:IsA('Model') and v.Name == 'Portal' then
                if v:FindFirstChild('Teleporter') then
                    return v.Teleporter
                end
            end
        end

        return nil
    end,
    getInputEvent = function()
        if entitylib.isAlive then
            local tool = getTool()
            if tool then
                return tool.Phases.InputEvent
            end
        end

        return nil
    end
}

run(function()
    local oldstart = entitylib.start
    local function customEntity(ent)
        repeat task.wait() until ent:GetAttribute('Id') ~= nil

        if ent:IsDescendantOf(workspace) then
            entitylib.addEntity(ent, nil)
        end
    end

    entitylib.start = function()
        oldstart()
        if entitylib.Running then
            for i, v in workspace.Map.Humanoids:GetDescendants() do
                if v:IsA('Folder') then
                    table.insert(entitylib.Connections, v.ChildAdded:Connect(customEntity))

                    table.insert(entitylib.Connections, v.ChildRemoved:Connect(function(ent)
                        entitylib.removeEntity(ent)
                    end))
                end

                if v:IsA('Model') and v:GetAttribute('Id') then
                    customEntity(v)
                end
            end
        end
    end
end)

entitylib.start()

run(function()
    local AutoShard

    AutoShard = vape.Categories.Utility:CreateModule({
        Name = 'AutoShard',
        Function = function(callback)
            if callback then
                if not fireproximityprompt then
                    notif('Vape', 'no proximity prompt func (unable to run AutoShard)', 4)
                    return AutoShard:Toggle()
                end

                repeat
                    if entitylib.isAlive then
                        local tool = getTool()
                        if tool then
                            if not ksfu.ShardSwords[tool.Name] then
                                return
                            end

                            if ksfu.getKills() >= ksfu.ShardSwords[tool.Name].Kills then
                                lplr.Character.HumanoidRootPart.CFrame = workspace.VoidShrinePrompt.CFrame
                                task.spawn(fireproximityprompt, workspace.VoidShrinePrompt.ProximityPrompt)
                            end
                        end
                    end

                    task.wait()
                until not AutoShard.Enabled
            end
        end,
        Tooltip = 'Automatically gives you shards (requires Killaura)'
    })
end)

run(function()
    local AutoArena
    AutoArena = vape.Categories.Blatant:CreateModule({
        Name = 'AutoArena',
        Function = function(callback)
            if callback then
                if not firetouchinterest then
                    notif('Vape', 'no firetouchinterest func (unable to go automatically to the arena)', 4)
                    return AutoArena:Toggle()
                end

                repeat
                    if entitylib.isAlive and lplr.Character.HumanoidRootPart.Position.Y >= 2539 then
                        local portal = ksfu.getPortal()

                        if portal then
                            task.spawn(firetouchinterest, portal, lplr.Character.HumanoidRootPart, true)
                            task.spawn(firetouchinterest, portal, lplr.Character.HumanoidRootPart, false)
                        end
                    end

                    task.wait()
                until not AutoArena.Enabled
            else
                if entitylib.isAlive then
                    local portal = ksfu.getPortal()

                    if portal then
                        task.spawn(firetouchinterest, portal, lplr.Character.HumanoidRootPart, false)
                    end
                end
            end
        end,
        Tooltip = 'Automatically teleports you to the Arena'
    })
end)

run(function()
    local AutoEquip
    AutoEquip = vape.Categories.Inventory:CreateModule({
        Name = 'AutoEquip',
        Function = function(callback)
            if callback then
                repeat
                    if entitylib.isAlive and lplr.Character.HumanoidRootPart.Position.Y <= 2539 then
                        local tool = ksfu.getSword()
                        if tool then
                            tool.Parent = lplr.Character
                        end
                    end
                    
                    task.wait()
                until not AutoEquip.Enabled
            end
        end,
        Tooltip = 'Automatically equips your Sword when you\'re in the Arena.'
    })
end)

run(function()
    local AutoAbility
    AutoAbility = vape.Categories.Utility:CreateModule({
        Name = 'AutoAbility',
        Function = function(callback)
            if callback then
                repeat
                    task.spawn(function() -- spawn so it doesn't tax your performance !!
                        for i,v in lplr.PlayerGui.AbilityGUI2.Frame:GetChildren() do
                            if v.Name ~= 'Template' and v:IsA('Frame') then
                                if v.Cooldown.Value ~= 0 then continue end
                                if v.Button.KeyInput.Value ~= '' then
                                    local input = ksfu.getInputEvent()

                                    if input then
                                        input:FireServer(Enum.KeyCode[v.Button.KeyInput.Value])
                                        replicatedStorage.ABILITY:FireServer(v.Button.KeyInput.Value)
                                    end
                                end
                            end
                        end
                    end)

                    task.wait()
                until not AutoAbility.Enabled
            end
        end,
        Tooltip = 'Automatically uses your Ability so you don\'t have to'
    })
end)

run(function()
    local FakeText
    local Text
    local Color
    local FontOption
    local Size
    FakeText = vape.Categories.Render:CreateModule({
        Name = 'FakeText',
        Function = function(callback)
            if callback then
                if not firesignal or ({identifyexecutor()})[1] == 'Solara' then
                    notif('Vape', 'unable to send, limited/no firesignal func', 4)
                    return FakeText:Toggle()
                end

                firesignal(replicatedStorage.MainEvents.ChatEvent.OnClientEvent, Text.Value, Color3.fromHSV(Color.Hue, Color.Sat, Color.Value), FontOption.Value.Family:match('([^/]+)%.json$'), Size.Value)
                notif('Vape', 'sent faketext in chat (will only show on your screen)', 3)

                FakeText:Toggle()
            end
        end,
        Tooltip = 'Sends a fake message in the Chat (clientside only)'
    })
    Text = FakeText:CreateTextBox({
        Name = 'Text',
        Placeholder = 'KSFU developers are autistic'
    })
    Color = FakeText:CreateColorSlider({
        Name = 'Text Color'
    })
    FontOption = FakeText:CreateFont({
        Name = 'Font',
        Blacklist = 'Arial'
    })
    Size = FakeText:CreateSlider({
        Name = 'Scale',
        Default = 18,
        Min = 1,
        Max = 108
    })
end)

task.spawn(function()
    run(function()
        if isfile and writefile and readfile then
            local commit = httpService:JSONDecode(game:HttpGet('https://api.github.com/repos/stxxv/koolxtras/commits'))[1]

            if not isfile('newvape/profiles/ksfucommit.txt') then
                writefile('newvape/profiles/ksfucommit.txt', commit.sha)
            elseif readfile('newvape/profiles/ksfucommit.txt') ~= commit.sha then
                notif('Update detected', commit.commit.message, 12)
                writefile('newvape/profiles/ksfucommit.txt', commit.sha)
            end
        end

        if setclipboard then
            setclipboard('https://discord.gg/aeWuPMA5zX')
        end

        notif('Vape', string.format('loaded successfully in: %.2fs, support server has been copied to your clipboard!', os.clock() - realtime), 6)
    end)
end)

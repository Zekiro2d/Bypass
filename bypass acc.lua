	if not game:IsLoaded() then
		repeat wait(.1) until game:IsLoaded() 
	end
local ReplicatedStorage = game:GetService("ReplicatedStorage")


local tablefind = table.find
local MainEvent = ReplicatedStorage.MainEvent
local SpoofTable = {
    WalkSpeed = 30,
    JumpPower = 50
}


local Flags = {
    "CHECKER_1",
    "TeleportDetect",
    "OneMoreTime"
}


local __namecall
__namecall = hookmetamethod(game, "__namecall", function(...)

    local args = {...}
    local self = args[1]
    local method = getnamecallmethod()
    local caller = getcallingscript()


    if (method == "FireServer" and self == MainEvent and tablefind(Flags, args[2])) then
        return
    end


    if (not checkcaller() and getfenv(2).crash) then
        hookfunction(getfenv(2).crash, function()
            warn("Crash Attempt") 
        end)
    end


    return __namecall(...)
end)

local __index
__index = hookmetamethod(game, "__index", function(t, k)
    -- // Make sure it's trying to get our humanoid's ws/jp
    if (not checkcaller() and t:IsA("Humanoid") and (k == "WalkSpeed" or k == "JumpPower")) then
        return SpoofTable[k]
    end
    return __index(t, k)
end)


local __newindex
__newindex = hookmetamethod(game, "__newindex", function(t, k, v)

    if (not checkcaller() and t:IsA("Humanoid") and (k == "WalkSpeed" or k == "JumpPower")) then
        SpoofTable[k] = v

        return
    end
    return __newindex(t, k, v)
  end)
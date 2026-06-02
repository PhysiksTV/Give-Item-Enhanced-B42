if isServer() then return end

local function OnServerCommand(module, command, args)
    if module ~= "giveitem" then return end
    local player = getPlayer()

    if command == "onGaveItem" then
        player:Say("Gave " .. (args.itemName or "item") .. "!")
        getSoundManager():playUISound("ItemGiveSound")
        ISInventoryPage.renderDirty = true
    elseif command == "onReceiveItem" then
        player:Say("Received " .. (args.itemName or "item") .. "!")
        getSoundManager():playUISound("ItemReceivedSound")
        ISInventoryPage.renderDirty = true
    end
end

Events.OnServerCommand.Add(OnServerCommand)

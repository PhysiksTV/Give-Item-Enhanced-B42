-- I have tried every way short of a json file to server verify the transfer and just admin cammond it, it shouldnt have to take that tho!

if not isServer() then return end

local function OnClientCommand(module, command, player, args)
    if module ~= "giveitem" or command ~= "onGiveItem" then return end

    local senderInv = player:getInventory()
    local item = senderInv:getItemById(args.itemID)
    if not item then return end

    local targetPlayer = getPlayerByOnlineID(args.targetID)
    if not targetPlayer then return end

    local itemName = item:getDisplayName()

    -- Transfer on the server layer *NOT FKN WORKING*
    senderInv:Remove(item)
    targetPlayer:getInventory():AddItem(item)

    -- Push full inventory state to both clients so it persists on reconnect *Reverts to Receiver!!!*
    player:sendInventory()
    targetPlayer:sendInventory()

    sendServerCommand(player,       "giveitem", "onGaveItem",    { itemName = itemName })
    sendServerCommand(targetPlayer, "giveitem", "onReceiveItem", { itemName = itemName })
end

Events.OnClientCommand.Add(OnClientCommand)

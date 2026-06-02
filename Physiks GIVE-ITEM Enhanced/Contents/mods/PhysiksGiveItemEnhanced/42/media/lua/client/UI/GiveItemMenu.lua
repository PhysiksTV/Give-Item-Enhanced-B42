local function onFillInventoryObjectContextMenu(playerNum, context, items)
    if not isClient() then return end

    local player = getSpecificPlayer(playerNum)
    if not player then return end

    -- Collect real items from selection
    local giveItems = {}
    for _, v in ipairs(items) do
        local realItem = v.items and v.items[1] or v
        if realItem then table.insert(giveItems, realItem) end
    end
    if #giveItems == 0 then return end

    -- Find nearby players within 5 tiles on same Z
    local px, py, pz = player:getX(), player:getY(), player:getZ()
    local nearbyPlayers = {}
    local onlinePlayers = getOnlinePlayers()
    if onlinePlayers then
        for i = 0, onlinePlayers:size() - 1 do
            local target = onlinePlayers:get(i)
            if target ~= player and target:getZ() == pz then
                if IsoUtils.DistanceTo(px, py, target:getX(), target:getY()) <= 5.0 then
                    table.insert(nearbyPlayers, target)
                end
            end
        end
    end
    if #nearbyPlayers == 0 then return end

    local giveOption = context:addOption("Give To...", nil, nil)
    local subMenu    = ISContextMenu:getNew(context)
    context:addSubMenu(giveOption, subMenu)

    for _, target in ipairs(nearbyPlayers) do
        subMenu:addOption(target:getUsername(), player, function(pl, tgt)
            for _, itm in ipairs(giveItems) do
                if luautils.walkAdj(pl, tgt:getCurrentSquare()) then
                    ISTimedActionQueue.add(ISGiveItemAction:new(pl, itm, tgt, 50))
                end
            end
        end, target)
    end
end

Events.OnFillInventoryObjectContextMenu.Add(onFillInventoryObjectContextMenu)

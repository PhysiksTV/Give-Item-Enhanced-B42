require "TimedActions/ISBaseTimedAction"

ISGiveItemAction = ISBaseTimedAction:derive("ISGiveItemAction")

function ISGiveItemAction:isValid()
    return self.character:getInventory():contains(self.item) and
           IsoUtils.DistanceTo(self.character:getX(), self.character:getY(), self.target:getX(), self.target:getY()) <= 5.0
end

function ISGiveItemAction:update()
    self.character:faceThisObject(self.target)
end

function ISGiveItemAction:perform()
    local args = {
        itemID   = self.item:getID(),
        itemType = self.item:getFullType(),
        itemName = self.item:getDisplayName(),
        targetID = self.target:getOnlineID()
    }
    sendClientCommand(self.character, "giveitem", "onGiveItem", args)
    ISBaseTimedAction.perform(self)
end

function ISGiveItemAction:new(character, item, target, time)
    local o = ISBaseTimedAction.new(self, character)
    o.item       = item
    o.target     = target
    o.maxTime    = time
    o.stopOnWalk = true
    o.stopOnRun  = true
    return o
end

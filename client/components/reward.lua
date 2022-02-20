pass.__rewardTable = {
    [1] = {
        callback = function(source, passId)
            setElementData(source, 'pass:claimed_' .. passId, true)
            triggerServerEvent('pass:weaponClaim', source, source, 31, 9999);
        end
    }
}
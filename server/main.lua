addEvent('pass:weaponClaim', true);
addEventHandler('pass:weaponClaim', root,
    function(source, Id, ammo)
        if not Id or not ammo or not isElement(source) then
            return false;
        end
        giveWeapon(source, Id, ammo, true);
    end
);
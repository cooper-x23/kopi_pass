local utils = pass.utils;
pass.panel = {};
pass.panel.data = {
    visible = true,
    blue = tocolor(95, 158, 160),
    size = Vector2(screenX / 2, utils.resp(150)),
    hovered = false,
    selected = false
};

local data = pass.panel.data;
data.position = Vector2(screenX / 2 - data.size.x / 2, screenY / 2 - data.size.y / 2);

pass.panel.render = function()
    data.hovered = false;
    data.selected = false;
    if not data.visible then
        return false;
    end
    local sans = pass.fonts.openSans;
    dxDrawRectangle(data.position, data.size, tocolor(35, 35, 35));
    -- player pass level
    dxDrawRectangle(data.position.x, data.position.y + (data.size.y - utils.resp(23)), data.size.x, utils.resp(23), data.blue);
    _dxDrawText('Jelenlegi szinted: ' .. (getElementData(localPlayer, 'pass:level') or 1), 
        data.position.x,
        data.position.y + (data.size.y - utils.resp(23)),
        data.size.x,
        utils.resp(23),
        tocolor(255, 255, 255), 1, sans,
        'center', 'center');

    local level = (getElementData(localPlayer, 'pass:level') or 1);
    for i = 1, 15, 1 do
        dxDrawRoundedRectangle(data.position.x - (22.5) + (i * 50), screenY / 2 - utils.resp(60) / 2, utils.resp(45), utils.resp(45), data.blue, 0.3, true);
        if (level == i) then
            dxDrawRoundedRectangle(data.position.x - (22.5) + (i * 50), screenY / 2 - utils.resp(60) / 2, utils.resp(45), utils.resp(45), tocolor(255, 11, 11), 0.3, false, {0.05, 0.05});    
            -- text rectangle top
            _dxDrawText('itt v', 
            data.position.x - (22.5) + (i * 50), 
            screenY / 2 - utils.resp(100) / 2, 
            utils.resp(45), 
            utils.resp(45), 
            tocolor(255, 255, 255), 1, sans, 
            'center', 'top');
        end
        local _isCursorInArea = isCursorInArea(data.position.x - (22.5) + (i * 50), screenY / 2 - utils.resp(60) / 2, utils.resp(45), utils.resp(45));
        if _isCursorInArea then
            data.hovered = 'reward';
            data.selected = i;
        end
    end
end

pass.panel.open = function()
    data.visible = true;
    addEventHandler('onClientRender', root, pass.panel.render);
    addEventHandler('onClientClick', root, pass.panel.__claimReward);
end

pass.panel.close = function()
    data.visible = false;
    removeEventHandler('onClientRender', root, pass.panel.render);
    removeEventHandler('onClientClick', root, pass.panel.__claimReward);
end


pass.panel.__claimReward = function(button, state)
    if button ~= 'left' and state ~= 'down' then
        return false;
    end
    if data.hovered ~= 'reward' or data.selected <= 0 then
        return false;
    end
    if (getElementData(localPlayer, 'pass:level') == data.selected) then
        if getElementData(localPlayer, 'pass:claimed_' .. getElementData(localPlayer, 'pass:level')) then
            outputChatBox('ezt mar kivetted 1x');
            return false;
        end
        pass.__rewardTable[getElementData(localPlayer, 'pass:level')].callback(localPlayer, getElementData(localPlayer, 'pass:level'));
    end
end

addEventHandler('onClientResourceStart', root, 
    function(resource)
        if (getResourceName(resource) == 'kopi_core' or resource == getThisResource()) then
            local source = localPlayer;            
            core = exports.kopi_core;
            setTimer(function()
                pass.fonts.openSans = core:requireFont('opensans', 11);
                setElementData(source, 'pass:level', 1);
                setElementData(source, 'pass:claimed', false);
            end, 155, 1);
        end
    end
);


addEventHandler('onClientKey', root, 
    function(key, state)
        if key ~= 'F2' or not state then
            return false;
        end
        data.visible = not data.visible;
        if data.visible then
            pass.panel.open();
        else
            pass.panel.close();
        end
    end
);
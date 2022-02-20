pass = {};
pass.utils = {};
pass.fonts = {};
screenX, screenY = guiGetScreenSize();
loadstring(exports.kopi_core:require({'Rectangle'}))();

function _dxDrawText(text, x, y, width, height, ...)
    dxDrawText(text, x, y, x + width, y + height, ...);
end 

respMultiplier = 0.75 + (screenX - 1024) * 0.25 / (1920 - 1080)
pass.utils.resp = function(num)
    return math.ceil(num * respMultiplier)
end
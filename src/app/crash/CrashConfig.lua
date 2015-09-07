local CrashConfig = class('CrashConfig')

local type_img_dict = {
}
function CrashConfig:ctor()
   --
end

function CrashConfig:getAvailableTileTypeList()
   return {1,5,37,47,144}
end

function CrashConfig:getImg(tile_type)
   return 'tile-'..tile_type..'.jpg'
end

return CrashConfig

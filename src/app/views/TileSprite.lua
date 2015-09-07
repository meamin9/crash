local function create_class(tile)
   local aside = tile:getAside()
   local texture = cc.Director:getInstance():getTextureCache():addImage(tile:getImg())
--   local spriteFrame = display.newSpriteFrame(texture, cc.rect(0,0,aside, aside))
   local spriteFrame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0,0,aside,aside))
   return cc.Sprite:createWithSpriteFrame(spriteFrame)
end

local TileSprite = class('TileSprite', create_class)

function TileSprite:ctor(tile)
   self.model = tile
   tile:setView(self)
end

return TileSprite

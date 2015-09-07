local TileFactory = class('TileFactory')
local TileModel = import '.TileModel'

function TileFactory:ctor()
   self.tile_recycle_list = {} --it's not more useful
   self.max_tiles = 20
end

function TileFactory:create_empty_tile()
   local tile = table.remove(self.tile_recycle_list)
   if not tile then
      tile = TileModel.new()
   end
   return tile
end

function TileFactory:create_tile_matrix()
   local col = crash.tmp.crash_model:getCol()
   local row = crash.tmp.crash_model:getRow()
   local tiles = {}
   for i = 1, row do
      tiles[i] = {}
      for j = 1, col do
         local ttype = self.spawn_tile_type(tiles, i, j)
         tiles[i][j] = TileModel.new(ttype, i, j)
      end
   end
   return tiles
end

function TileFactory.spawn_tile_type(tiles, i, j)
   local conf = crash.tmp.crash_model:getConfig()
   local type_list = clone(conf:getAvailableTileTypeList())
   if tiles[i-2] and tiles[i-2][j] and tiles[i-2][j]:getType() == tiles[i-1][j]:getType() then
      table.removebyvalue(type_list, tiles[i-1][j]:getType())
   end
   if tiles[i][j-2] and tiles[i][j-2]:getType() == tiles[i][j-1]:getType() then
      table.removebyvalue(type_list, tiles[i][j-1]:getType())
   end
   assert(#type_list > 0, 'we need at least 3 type of tiles')
   return type_list[math.random(1, #type_list)]
end

function TileFactory:delete_tile(tile)
   --assert(tile not in self.tile_recycle_list)
   tile.cleanup()
   if self.max_tiles >= #self.tile_recycle_tile then
      self.tile_recycle_list[1] = tile
   else
      table.insert(self.tile_recycle_list)
   end
end

return TileFactory

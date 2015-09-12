local operator = {}

function operator.exchange_two_tiles_without_crash(tile1, tile2)
   tile1:addMovingRestrict()
   tile2:addMovingRestrict()
   local view1 = tile1:getView()
   local view2 = tile2:getView()
   local p1 = {}
   local p2 = {}
   p1.x, p1.y = view1:getPosition()
   p2.x, p2.y = view2:getPosition()
   local move2p2 = cc.MoveTo:create(0.2, p2)
   local move2p1 = cc.MoveTo:create(0.2, p1)
   local delay = cc.DelayTime:create(0.2)
   local callback1 = cc.CallFunc:create(
      function()
         tile1:removeMovingRestrict()
      end
   )
   local callback2 = cc.CallFunc:create(
      function()
         tile2:removeMovingRestrict()
      end
   )
   view1:runAction(cc.Sequence:create(move2p2, move2p1, delay, callback1))
   view2:runAction(cc.Sequence:create(move2p1, move2p2, delay, callback2))
end

function operator.exchange_two_tiles_without_crash(tile1, tile2)
   tile1:addMovingRestrict()
   tile2:addMovingRestrict()
   local view1 = tile1:getView()
   local view2 = tile2:getView()
   local p1 = {}
   local p2 = {}
   p1.x, p1.y = view1:getPosition()
   p2.x, p2.y = view2:getPosition()
   local move2p2 = cc.MoveTo:create(0.2, p2)
   local move2p1 = cc.MoveTo:create(0.2, p1)
   local delay = cc.DelayTime:create(0.2)
   local callback1 = cc.CallFunc:create(
      function()
         tile1:removeMovingRestrict()
      end
   )
   local callback2 = cc.CallFunc:create(
      function()
         tile2:removeMovingRestrict()
      end
   )
   view1:runAction(cc.Sequence:create(move2p2, move2p1, delay, callback1))
   view2:runAction(cc.Sequence:create(move2p1, move2p2, delay, callback2))
end

return operator

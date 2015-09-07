local BoardTouchLayer = class('BoardTouchLayer', cc.Node)

function BoardTouchLayer:ctor()
   self:onTouch(handler(self, self.onTouchEvent))
end

function BoardTouchLayer:onTouchEvent(event)
   if event.name == 'began' then
      return true
   elseif event.name == 'moved' then
      print('moved')
   elseif event.name == 'ended' then
      print('ended')
   end
end

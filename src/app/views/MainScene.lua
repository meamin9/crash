
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()
    -- add background image
    -- display.newSprite("MainSceneBg.jpg")
    --     :move(display.center)
    --     :addTo(self)

    -- -- add play button
    -- local playButton = cc.MenuItemImage:create("PlayButton.png", "PlayButton.png")
    --     :onClicked(function()
    --         self:getApp():enterScene("PlayScene")
    --     end)
    -- cc.Menu:create(playButton)
    --     :move(display.cx, display.cy - 200)
    --     :addTo(self)
   print('crash begin')
   cc.LayerColor:create(cc.c4b(199,32,199,128)):addTo(self)
   cc.Label:createWithSystemFont('touch anywhere to start', 'Arial', 72):addTo(self)
      :align(display.CEBTER, display.center)
      :move(display.cx, display.height/3)
   cc.Layer:create():addTo(self)
      :onTouch(function(event)
            print('touch', dump(event))
            if event.name == 'began' then
               print(event.name)
               return true
            elseif event.name == 'ended' then
               print('touched click')
               self:getApp():enterScene('PlayScene')
            end
              end)
   utils.DebugPanel.new():addTo(self)
end

return MainScene

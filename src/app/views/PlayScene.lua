
local PlayScene = class("PlayScene", cc.load("mvc").ViewBase)

local CrashView = import('.CrashView')

function PlayScene:onCreate()
    -- create game view and add it to stage
    self.crashView_ = CrashView:create():addTo(self)
--        :addEventListener(CrashView.events.PLAYER_DEAD_EVENT, handler(self, self.onPlayerDead))
  --      :start()
end

function PlayScene:onPlayerDead(event)
    -- add game over text
    local text = string.format("You killed %d bugs", self.gameView_:getKills())
    cc.Label:createWithSystemFont(text, "Arial", 96)
        :align(display.CENTER, display.center)
        :addTo(self)

    -- add exit button
    local exitButton = cc.MenuItemImage:create("ExitButton.png", "ExitButton.png")
        :onClicked(function()
            self:getApp():enterScene("MainScene")
        end)
    cc.Menu:create(exitButton)
        :move(display.cx, display.cy - 200)
        :addTo(self)
end

return PlayScene

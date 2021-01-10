ScoreBoardUI = {}
ScoreBoardUI.__index = ScoreBoardUI

function ScoreBoardUI.create()
  local self = setmetatable({}, ScoreBoardUI)
  self.show = ""
  self.scoresDiff = {}
  return self
end

function ScoreBoardUI:setData(show, diff)
  self.show = show
  self.scoresDiff = diff
  state.Interface:draw()
end

function ScoreBoardUI:getXml()
  if (self.show == "totals") then
    return self:_getDefaultXml(function(player) return tostring(player.score) end, 1)
  elseif (self.show == "differences") then
    local getText = function(player)
      return self.scoresDiff[player.color] < 0 and
        (tostring(player.score) .. " - " .. tostring(-self.scoresDiff[player.color])) or 
        (tostring(player.score) .. " + " .. tostring(self.scoresDiff[player.color]))
    end
    return self:_getDefaultXml(getText, 1)
  elseif (self.show == "final") then
    local getText = function(player)
      local p = Player[player.color]
      return tostring(p.steam_name) .. " - " .. tostring(player.score)
    end
    local startButton = { tag="Panel", attributes={ color="Black", outline="Black", outlineSize="5 5", width=800}, children={
      {tag="Button", value="Play again", attributes={ color="White", onClick="_startGameMenuClicked", fontSize=30, width=400 }}
    }}
    return self:_getDefaultXml(getText, 2, {startButton})
  end
end

function ScoreBoardUI:_getDefaultXml(getText, size, extraRows)
  local sizeX = size
  local sizeY = size * 2
  local alignment = size == 1 and "MiddleRight" or "MiddleCenter"
  local rows = {}
  table.insert(rows, self:_createTextPanel("Score", 25 * sizeX, {40 * sizeX, 200 * sizeY}, "White", "Black"))
   for _, player in ipairs(self:_getPlayerScores()) do
    table.insert(rows, self:_createTextPanel(getText(player) .. " points", 20 * sizeX, {25 * sizeX, 200 * sizeY}, "Black", player.color))
  end
  if (extraRows) then
    for _, newRow in pairs(extraRows) do table.insert(rows, newRow) end
  end
  local children = table.map(rows, function(value) return { tag="Row", children=value } end)
  return { tag="TableLayout", attributes={ rectAlignment=alignment, height=(10+30*#rows) * sizeX, width=250 * sizeY}, children=children}
end

function ScoreBoardUI:_getPlayerScores()
  local scores = {}
  for playerColor, player in pairs(state.Player) do
    table.insert(scores, { color = playerColor, score = player.score })
  end
  table.sort(scores, function(p1, p2) return p1.score > p2.score end)
  return scores
end

function ScoreBoardUI:_createTextPanel(text, fontSize, size, color, back, animated)
  return {
    tag="Panel", attributes={ color=back, outline="Black", outlineSize="5 5", height=size[1], width=size[2] },
    children = {
      { tag="Text", attributes={ text=text, color=color, fontSize=fontSize, fontStyle="Bold" }}
    }
  }
end
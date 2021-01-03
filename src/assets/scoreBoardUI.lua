ScoreBoardUI = {}
ScoreBoardUI.__index = ScoreBoardUI

function ScoreBoardUI.create()
  local self = setmetatable({}, ScoreBoardUI)
  self.obj = nil
  return self
end

function ScoreBoardUI:draw()
  local scores = {}
  table.insert(scores, { tag="Row", children={ self:_createTextPanel("Score", 25, {40, 200}, "White", "Black") }})
   local len = 0
   for playerColor, player in pairs(state.Player) do
    table.insert(scores, { tag="Row", children={ self:_createTextPanel(player.score .. " points", 20, {25, 200}, "Black", playerColor) }})
    len = len + 1
  end
  UI.setXmlTable({
      { tag="TableLayout", attributes={ rectAlignment="MiddleRight", height=40+30*len, width=250}, children=scores}
  })
end

function ScoreBoardUI:drawScores(diff)
  local scores = {}
  table.insert(scores, { tag="Row", children={ self:_createTextPanel("Score", 25, {40, 200}, "White", "Black") }})
  local len = 0
  for playerColor, player in pairs(state.Player) do
    local text = diff[playerColor] < 0 and
      (tostring(player.score) .. " - " .. tostring(-diff[playerColor])) or 
      (tostring(player.score) .. " + " .. tostring(diff[playerColor]))
    table.insert(scores, { tag="Row", children={ self:_createTextPanel(text .. " points", 20, {25, 200}, "Black", playerColor) }})
    len = len + 1
  end
  UI.setXmlTable({
      { tag="TableLayout", attributes={ rectAlignment="MiddleRight", height=40+30*len, width=250}, children=scores}
  })
end

function ScoreBoardUI:_createTextPanel(text, fontSize, size, color, back)
  return {
    tag="Panel", attributes={ color=back, outline="Black", outlineSize="5 5", height=size[1], width=size[2] },
    children = {
      { tag="Text", attributes={ text=text, color=color, fontSize=fontSize, fontStyle="Bold" }}
    }
  }
end
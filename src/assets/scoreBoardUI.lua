ScoreBoardUI = {}
ScoreBoardUI.__index = ScoreBoardUI

function ScoreBoardUI.create()
  local self = setmetatable({}, ScoreBoardUI)
  self.obj = nil
  return self
end

function ScoreBoardUI:draw()
  local rows = {}
  table.insert(rows, { tag="Row", children={ self:_createTextPanel("Score", 25, {40, 200}, "White", "Black") }})
   for _, player in ipairs(self:_getPlayerScores()) do
    table.insert(rows, { tag="Row", children={ self:_createTextPanel(player.score .. " points", 20, {25, 200}, "Black", player.color) }})
  end
  UI.setXmlTable({
      { tag="TableLayout", attributes={ rectAlignment="MiddleRight", height=10+30*#rows, width=250}, children=rows}
  })
end

function ScoreBoardUI:drawScores(diff)
  local rows = {}
  table.insert(rows, { tag="Row", children={ self:_createTextPanel("Score", 25, {40, 200}, "White", "Black") }})
  for playerColor, player in pairs(self:_getPlayerScores()) do
    local text = diff[player.color] < 0 and
      (tostring(player.score) .. " - " .. tostring(-diff[player.color])) or 
      (tostring(player.score) .. " + " .. tostring(diff[player.color]))
    table.insert(rows, { tag="Row", children={ self:_createTextPanel(text .. " points", 20, {25, 200}, "Black", player.color) }})
  end
  UI.setXmlTable({
      { tag="TableLayout", attributes={ rectAlignment="MiddleRight", height=10+30*#rows, width=250}, children=rows}
  })
end

function ScoreBoardUI:_getPlayerScores()
  local scores = {}
  for playerColor, player in pairs(state.Player) do
    table.insert(scores, { color = playerColor, score = player.score })
  end
  table.sort(scores, function(p1, p2) return p1.score > p2.score end)
  return scores
end

function ScoreBoardUI:_createTextPanel(text, fontSize, size, color, back)
  return {
    tag="Panel", attributes={ color=back, outline="Black", outlineSize="5 5", height=size[1], width=size[2] },
    children = {
      { tag="Text", attributes={ text=text, color=color, fontSize=fontSize, fontStyle="Bold" }}
    }
  }
end
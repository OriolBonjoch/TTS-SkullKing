ScaryMaryPromptUI = {}
ScaryMaryPromptUI.__index = ScaryMaryPromptUI

function ScaryMaryPromptUI.create()
  local self = setmetatable({}, ScaryMaryPromptUI)
  self.showPrompt = false
  self.scaryMaryCardId = ""
  return self
end

function ScaryMaryPromptUI:show(cardId)
  self.showPrompt = true
  self.scaryMaryCardId = cardId
  state.Interface:draw()
end

function ScaryMaryPromptUI:hide()
  self.showPrompt = false
  self.scaryMaryCardId = ""
  state.Interface:draw()
end

function ScaryMaryPromptUI:fillAssets(assets)
  table.insert(assets, { name = "escapeImg", url  = "https://github.com/OriolBonjoch/TTS-SkullKing/raw/main/assets/huida.jpg" })
  table.insert(assets, { name = "pirataImg", url  = "https://github.com/OriolBonjoch/TTS-SkullKing/raw/main/assets/pirata.jpg" })
end

function ScaryMaryPromptUI:getXml()
  if (not self.showPrompt) then return end
  return { tag="VerticalLayout", attributes={ color="Black", childAlignment="MiddleCenter", spacing=10, height=190, width=400, padding="0 0 0 20" }, children={
    { tag="Text", attributes={ color="White", fontSize=24, fontStyle="Bold", height=80 }, value="Elige como jugar 'Scary Mary'"},
    { tag="HorizontalLayout", attributes={ childAlignment="MiddleCenter", height=80, width=170, spacing=10, padding="115 115 0 0" }, children= {
      { tag="Button", attributes={ icon= "pirataImg", color="White", padding="5", onClick="_playScaryMaryAsPirate(" .. self.scaryMaryCardId .. ")"}},
      { tag="Button", attributes={ icon= "escapeImg", color="White", padding="5", onClick="_playScaryMaryAsEscape(" .. self.scaryMaryCardId .. ")"}}
    }}
  }}
end

function _playScaryMaryAsPirate(owner, cardId)
  _playScaryMary(cardId, "https://github.com/OriolBonjoch/TTS-SkullKing/raw/main/assets/PirateScaryMary.png")
end

function _playScaryMaryAsEscape(owner, cardId)
  _playScaryMary(cardId, "https://github.com/OriolBonjoch/TTS-SkullKing/raw/main/assets/EscapeScaryMary.png")
end

function _playScaryMary(cardId, faceUrl) 
  local luaCard = getObjectFromGUID(cardId)
  state.Interface.ScaryMaryPrompt:hide()
  state.Deck:discardHidden(luaCard)
  
  local card = spawnObject({ type = "Card", position = luaCard.getPosition(), rotation = luaCard.getRotation() })
  card.setCustomObject({
    face = faceUrl,
    back = "https://github.com/OriolBonjoch/TTS-SkullKing/raw/main/assets/back.jpg"
  })

  Wait.time(function()
    Turns.turn_color = Turns.getNextTurnColor()
    state.Game:endTrick()
  end, 5)
end

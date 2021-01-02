Deck = {}
Deck.__index = Deck

function Deck.create()
  local self =  setmetatable({}, Deck)
  self.obj = {}
  self.cards = {}
  return self
end

function Deck:draw()
  self.obj =
    spawnObject(
    {
      type = "DeckCustom",
      position = {x = 0, y = 5, z = 0},
      rotation = {x = 180, y = 0, z = 0}
    }
  )

  self.obj.setCustomObject(
    {
      face = "https://github.com/OriolBonjoch/TTS-SkullKing/raw/main/data/deck.jpg",
      back = "https://github.com/OriolBonjoch/TTS-SkullKing/raw/main/data/back.jpg",
      number = 66,
      width = 10,
      height = 7
    }
  )

  self:getCards()
end

function Deck:getCards()
  self.cards = {}
  for index, cardData in ipairs(self.obj.getObjects()) do
    self.cards[cardData.guid] = staticData.cards[index]
  end
end

function Deck:shuffle()
  self.obj.reset()
  self.obj.shuffle()
end

function Deck:deal()
  for playerColor, player in pairs(state.Player) do
    self.obj.deal(state.Game.round, playerColor)
  end
end

function Deck:discard(card)
  self.obj.putObject(card)
end
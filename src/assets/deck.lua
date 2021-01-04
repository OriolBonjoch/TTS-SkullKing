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
      face = "https://github.com/OriolBonjoch/TTS-SkullKing/raw/main/assets/deck.jpg",
      back = "https://github.com/OriolBonjoch/TTS-SkullKing/raw/main/assets/back.jpg",
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

function Deck:deal()
  self.obj.reset()
  self.obj.shuffle()
  for playerColor, player in pairs(state.Player) do
    self.obj.deal(state.Game.round, playerColor)
  end
end

function join(newDecks)
  for playerColor, player in pairs(state.Player) do
    newDecks[2].deal(state.Game.round, playerColor)
  end

  state.Deck.obj = group({newDecks[1], newDecks[2]})[1]
end

function Deck:discard(card)
  card.setInvisibleTo(getSeatedPlayers())
  self.obj.putObject(card)
  Wait.time(function() card.setInvisibleTo({}) end, 1)
end

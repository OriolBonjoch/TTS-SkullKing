function createDeck()
  savedData.deck =
    spawnObject(
    {
      type = "DeckCustom",
      position = {x = 0, y = 5, z = 0},
      rotation = {x = 180, y = 0, z = 0}
    }
  )
  savedData.deck.setCustomObject(
    {
      face = "https://github.com/OriolBonjoch/TTS-SkullKing/raw/main/data/deck.jpg",
      back = "https://github.com/OriolBonjoch/TTS-SkullKing/raw/main/data/back.jpg",
      number = 66,
      width = 10,
      height = 7
    }
  )
  for index, cardData in ipairs(savedData.deck.getObjects()) do
    savedData.cards[cardData.guid] = staticData.cards[index]
  end
end
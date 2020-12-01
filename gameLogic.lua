function initPlayer(playerColor)
  savedData.votes[playerColor] = 0
  chestDraw(playerColor)
end

function calculateWinner()
-- suit should be an argument to this function as we need to block the playable cards
  broadcastToAll("Calculating winner", Color.White)
  -- nos olvidamos de sirena > rey pirata, scary mary = pirata y de los puntos extras de sirena y rey pirata

  local suitPriority = { "bandera", "sirena", "pirata", "scary mary", "rey pirata" }

  local winner = ""
  local suit = ""
  local highestValue = -1

  for index, playerColor in ipairs(Turns.order) do
    print("Jugador "..index)
    local cardId = savedData.rounds[savedData.round][playerColor].cards[savedData.trick]
    local cardData = savedData.cards[cardId]

    if (suit == "" and has_value({ "mapa", "cofre", "loro", "bandera"}, cardData.name)) then
      print("manda el palo ".. cardData.name)
      suit = cardData.name
    end

    if (cardData.name == suit) then
      if (cardData.value > highestValue) then
        print("el jugador ".. playerColor .. " gana")
        winner = playerColor
        highestValue = cardData.value
      end
    else
      if (has_value(suitPriority, cardData.name)) then
        print("has_value(suitPriority, cardData.name) ")
        if (cardData.value > highestValue) then
          print("cardData.value > highestValue ")
          winner = playerColor
          highestValue = cardData.value
        end
      end
    end
  end

  broadcastToAll("Winner of this round: " .. winner, Color.White)
  return winner
end

function startRound()
  for index, playerColor in ipairs(getSeatedPlayers()) do
    savedData.rounds[savedData.round][playerColor].cards = {}
    savedData.rounds[savedData.round][playerColor].wins = 0
    printToAll("Player " .. playerColor .. " voted " .. savedData.votes[playerColor], playerColor)
    winsLabelDraw(playerColor)
  end

  savedData.trick = savedData.round
  Turns.enable = true
  startTrick()
end

function startTrick()
  savedData.suit = ""
end

function endTrick()
  broadcastToAll("Trick finished! calculate winner", playerColor)
  
  log( savedData.rounds)
  local winner = calculateWinner()

  for index, player_color in ipairs(getSeatedPlayers()) do
    local cardId = savedData.rounds[savedData.round][player_color].cards[savedData.trick]
    local card = getObjectFromGUID(cardId)
    -- card.destruct()
  end

  savedData.rounds[savedData.round][winner].wins = savedData.rounds[savedData.round][winner].wins + 1
  
  winsLabelUpdate(winner)

  -- subir puntos (rey pirata o sirena)

  savedData.trick = savedData.trick - 1
  if (savedData.trick == 0) then
    broadcastToAll("TODO: Bid again", Color.White)
    -- savedData.deck.reload()
    savedData.deck.reset()
    savedData.deck.shuffle()
    Turns.enable = false
  end
end



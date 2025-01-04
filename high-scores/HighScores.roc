module [latest, personalBest, personalTopThree]

Score : U64


personalTopN : List Score, U64 -> List Score
personalTopN = \scores, n ->
    scores 
    |> List.sortDesc
    |> List.takeFirst n


latest : List Score -> Result Score _
latest = List.last


personalBest : List Score -> Result Score _
personalBest = List.max


personalTopThree : List Score -> List Score
personalTopThree = \scores -> personalTopN scores 3

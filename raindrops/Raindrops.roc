module [convert]

drops = [{factor: 3, sound: "Pling"},
         {factor: 5, sound: "Plang"},
         {factor: 7, sound: "Plong"}]

convert : U64 -> Str
convert = \number ->
    drops
    |> List.walk "" \result, { factor, sound } ->
        if number % factor == 0
        then Str.concat result sound
        else result
    |> \result ->
        if result == ""
        then Num.toStr number
        else result

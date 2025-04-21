module [sum_of_multiples]

sum_of_multiples : List U64, U64 -> U64
sum_of_multiples = |factors, limit|
    factors
    |> Set.from_list
    |> Set.join_map(|factor| mupliplies(factor, limit))
    |> Set.walk(0, Num.add)

mupliplies : U64, U64 -> Set U64
mupliplies = |factor, limit|
    when factor is
        0 -> Set.empty({})
        _ ->
            { start: At factor, end: Before limit, step: factor }
            |> List.range
            |> Set.from_list

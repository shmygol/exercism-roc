module [distance]

distance : Str, Str -> Result (Num *) _
distance = |strand1, strand2|
    strand_list1 = Str.to_utf8(strand1)
    strand_list2 = Str.to_utf8(strand2)

    if List.len(strand_list1) != List.len(strand_list2) then
        DifferentStrandLength |> Err
    else
        List.map2(
            strand_list1,
            strand_list2,
            |a, b| if a == b then 0 else 1
        )
        |> List.sum
        |> Ok

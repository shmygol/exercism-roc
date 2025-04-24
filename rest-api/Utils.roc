module [func_swap, str_compare, hacky_dict_to_json]

func_swap :
    (a, b -> c)
    -> (b, a -> c)
func_swap = |f|
    |a, b| f(b, a)

str_compare : List U8, List U8 -> [LT, EQ, GT]
str_compare = |bytes_left, bytes_right|
    when (bytes_left, bytes_right) is
        ([], []) ->
            EQ

        ([], _) ->
            LT

        (_, []) ->
            GT

        ([head_left, .. as tail_left], [head_right, .. as tail_right]) ->
            if head_left < head_right then
                LT
            else if head_left > head_right then
                GT
            else
                str_compare(tail_left, tail_right)

hacky_dict_to_json : Dict Str F64 -> Str
hacky_dict_to_json = |dict|
    dict
    |> Dict.to_list
    |> List.sort_with(
        |(a, _), (b, _)|
            str_compare(
                Str.to_utf8(a),
                Str.to_utf8(b)
            ),
    )
    |> List.map(
        |(user_name, amount)|
            """
            "${user_name}": ${Num.to_str(amount)}
            """
        )
    |> Str.join_with(", ")
    |> |fields| "{ ${fields} }"

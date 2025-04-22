module [clean]

is_valid_lead : U8 -> Bool
is_valid_lead = |byte|
    byte >= '2' and byte <= '9'

clean : Str -> Result Str _
clean = |phone_number|
    phone_number
    |> Str.to_utf8
    |> |bytes|
        when bytes is
            ['1', .. as rest] -> rest
            ['+', '1', .. as rest] -> rest
            _ -> bytes
    |> List.keep_if(|byte| byte >= '0' and byte <= '9')
    |> |digits|
        when digits is
            [n1, _, _, n4, _, _, _, _, _, _] if is_valid_lead(n1) and is_valid_lead(n4) ->
                digits |> Str.from_utf8_lossy |> Ok

            _ ->
                InvalidPhoneNumber |> Err

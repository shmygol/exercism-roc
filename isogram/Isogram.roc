module [is_isogram]

is_alpha : U8 -> Bool
is_alpha = |code|
    code >= 97 && code <= 122

is_isogram : Str -> Bool
is_isogram = |phrase|
    codes =
        phrase
        |> Str.with_ascii_lowercased
        |> Str.to_utf8
        |> List.keep_if(is_alpha)

    Set.len(Set.from_list(codes)) == List.len(codes)


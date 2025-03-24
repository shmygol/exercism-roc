module [reverse]

import unicode.Grapheme

reverse : Str -> Str
reverse = |string|
    graphemes = when Grapheme.split(string) is
        Ok(value) -> value
        Err(_) -> crash "Failed to split ${string} into graphemes"

    List.walk(
        graphemes,
        "",
        |acc, grapheme| Str.concat(grapheme, acc)
    )

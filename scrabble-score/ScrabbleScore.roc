module [score]

ascii_uppercased : U8 -> U8
ascii_uppercased = |byte|
    if byte >= 'a' && byte <= 'z' then
        byte - 32
    else
        byte

score_letter : U8 -> U64
score_letter = |byte|
    when ascii_uppercased(byte) is
        'A' | 'E' | 'I' | 'O' | 'U' | 'L' | 'N' | 'R' | 'S' | 'T' -> 1
        'D' | 'G' -> 2
        'B' | 'C' | 'M' | 'P' -> 3
        'F' | 'H' | 'V' | 'W' | 'Y' -> 4
        'K' -> 5
        'J' | 'X' -> 8
        'Q' | 'Z' -> 10
        _ -> 0

score : Str -> U64
score = |word|
    word
    |> Str.walk_utf8(0, |acc, byte| acc + score_letter(byte))

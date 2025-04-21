module [response]

ascii_uppercase : Set U8
ascii_uppercase = List.range({ start: At 65, end: At 90 }) |> Set.from_list

ascii_lowercase : Set U8
ascii_lowercase = List.range({ start: At 97, end: At 122 }) |> Set.from_list

ascii_whitespace : Set U8
ascii_whitespace = [9, 10, 11, 12, 13, 32] |> Set.from_list

response : Str -> Str
response = |hey_bob|
    salutation = Str.walk_utf8(
        hey_bob,
        Silence,
        |previous, char|
            if Set.contains(ascii_uppercase, char) and previous != Statement then
                Yelling
            else if char == '?' and previous == Yelling then
                YellingQuestion
            else if char == '?' then
                Question
            else if Set.contains(ascii_lowercase, char) then
                Statement
            else if previous == Silence and !Set.contains(ascii_whitespace, char) then
                Punctuation
            else
                previous,
    )

    when salutation is
        Silence -> "Fine. Be that way!"
        Yelling -> "Whoa, chill out!"
        YellingQuestion -> "Calm down, I know what I'm doing!"
        Question -> "Sure."
        Statement | Punctuation -> "Whatever."

module [is_pangram]

alphabet_codes : Set(U8)
alphabet_codes = Set.from_list(
    List.range({start: At 97, end: At 122})
)

is_superset_of = |a, b|
    Set.difference(b, a)
    |> Set.is_empty

is_pangram : Str -> Bool
is_pangram = |sentence|
    sentence
    |> Str.with_ascii_lowercased
    |> Str.to_utf8
    |> Set.from_list
    |> is_superset_of(alphabet_codes)
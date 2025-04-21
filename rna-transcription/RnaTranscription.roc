module [to_rna]

to_rna : Str -> Str
to_rna = |dna|
    Str.walk_utf8(
        dna,
        "",
        |acc, c|
            when c is
                'C' -> "${acc}G"
                'G' -> "${acc}C"
                'T' -> "${acc}A"
                'A' -> "${acc}U"
                _ -> crash("Invalid DNA sequence")
    )
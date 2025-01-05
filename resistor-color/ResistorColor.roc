module [colorCode, colors]

colorCode : Str -> Result U64 _
colorCode = \color ->
    List.findFirstIndex colors (\c -> c == color)

colors : List Str
colors = ["black",
          "brown",
          "red",
          "orange",
          "yellow",
          "green",
          "blue",
          "violet",
          "grey",
          "white"]

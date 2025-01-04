module [isLeapYear]

isLeapYear : I64 -> Bool
isLeapYear = \year ->
    if year % 400 == 0 then
        Bool.true
    else if year % 100 == 0 then
        Bool.false
    else if year % 4 == 0 then
        Bool.true
    else
        Bool.false

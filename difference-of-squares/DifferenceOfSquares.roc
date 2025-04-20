module [square_of_sum, sum_of_squares, difference_of_squares]

pow_scaled : U64, U64, U64 -> U64
pow_scaled = |x, n, k|
    x
    |> Num.pow_int(n)
    |> Num.mul(k)

square_of_sum : U64 -> U64
square_of_sum = |number|
    number * (number + 1)
    |> Num.div_trunc(2)
    |> Num.pow_int(2)

sum_of_squares : U64 -> U64
sum_of_squares = |number|
    pow_scaled(number, 3, 2) + pow_scaled(number, 2, 3) + number
    |> Num.div_trunc(6)

difference_of_squares : U64 -> U64
difference_of_squares = |number|
    square_of_sum(number) - sum_of_squares(number)
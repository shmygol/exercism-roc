module [score]

score : F64, F64 -> U64
score = |x, y|
    distance = Num.sqrt(x^2 + y^2)

    if distance <= 1 then 10
    else if distance <= 5 then 5
    else if distance <= 10 then 1
    else 0

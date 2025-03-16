module [steps]

steps_from = |number, step|
    if number < 1 then
        Err("The number must be 1 or greater")
    else if number == 1 then
        Ok(step)
    else
        steps_from(
            if number % 2 == 0 then
                number // 2
            else
                number * 3 + 1              
            , step + 1
        )

steps : U64 -> Result U64 _
steps = |number|
    steps_from(number, 0)
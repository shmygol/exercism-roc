module [rebase]

walk_try_with_index :
    List elem,
    state,
    (state, elem, U64 -> Result state err)
    -> Result state err
walk_try_with_index = |list, state, f|
    list
    |> List.walk_try(
        { index: 0, state },
        |compound_state, elem|
            Ok(
                {
                    index: compound_state.index + 1,
                    state: f(compound_state.state, elem, compound_state.index)?,
                },
            ),
    )
    |> Result.map_ok(.state)

mod : U64, U64 -> { quotient : U64, remainder : U64 }
mod = |a, b|
    { quotient: Num.div_trunc(a, b), remainder: Num.rem(a, b) }

rebase_from_10 : U64, U64, List U64 -> Result (List U64) [InvalidBase]
rebase_from_10 = |value, output_base, acc|
    if output_base == 1 or output_base == 0 then
        Err(InvalidBase)
    else if value == 0 then
        acc
        |> List.reverse
        |> |l| if List.is_empty(l) then List.single(0) else l
        |> Ok
    else
        { quotient, remainder } = mod(value, output_base)
        rebase_from_10(quotient, output_base, List.append(acc, remainder))

rebase_to_10 : List U64, U64 -> Result U64 [InvalidBase]
rebase_to_10 = |digits, input_base|
    if input_base == 1 or input_base == 0 then
        Err (InvalidBase)
    else
        digits
        |> walk_try_with_index(
            0,
            |acc, digit, index|
                if digit >= input_base then
                    InvalidBase
                    |> Err
                else
                    acc
                    + digit
                    * Num.pow_int(input_base, index)
                    |> Ok,
        )

rebase : { input_base : U64, output_base : U64, digits : List U64 } -> Result (List U64) [InvalidBase]
rebase = |{ input_base, output_base, digits }|
    digits
    |> List.reverse
    |> rebase_to_10(input_base)?
    |> rebase_from_10(output_base, [])

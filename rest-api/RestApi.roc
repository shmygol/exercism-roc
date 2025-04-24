module [get, post]

import json.Json
import Utils exposing [func_swap]
import Database exposing [Database, User]

iou : Database, { lender : Str, borrower : Str, amount : F64 } -> Result (List User) _
iou = |database, { lender: lender_name, borrower: borrower_name, amount }|
    lender = Database.get_user(database, lender_name)?
    borrower = Database.get_user(database, borrower_name)?

    new_balance_between_users =
        amount
        + (Dict.get(lender.owed_by, borrower.name) ?? 0)
        - (Dict.get(lender.owes, borrower.name) ?? 0)

    new_lender_record = {
        lender &
        owes: Dict.update(lender.owes, borrower.name, |_|
            if new_balance_between_users >= 0 then
                Missing |> Err
            else
                new_balance_between_users |> Num.abs |> Ok
        ),
        owed_by: Dict.update(lender.owed_by, borrower.name, |_|
            if new_balance_between_users <= 0 then
                Missing |> Err
            else
                new_balance_between_users |> Num.abs |> Ok
        ),
        balance: lender.balance + amount,
    }

    new_borrower_record = {
        borrower &
        owes: Dict.update(borrower.owes, lender.name, |_|
            if new_balance_between_users <= 0 then
                Missing |> Err
            else
                new_balance_between_users |> Num.abs |> Ok
        ),
        owed_by: Dict.update(borrower.owed_by, lender.name, |_|
            if new_balance_between_users >= 0 then
                Missing |> Err
            else
                new_balance_between_users |> Num.abs |> Ok
        ),
        balance: borrower.balance - amount,
    }

    [(lender.name, new_lender_record), (borrower.name, new_borrower_record)]
    |> Dict.from_list
    |> func_swap(Database.update_users)(database)?
    |> Database.get_users(ByName([lender.name, borrower.name]))

get : Database, { url : Str, payload ?? Str } -> Result Str _
get = |database, { url, payload ?? "" }|
    when url is
        "/users" if payload == "" ->
            Database.get_users(database, All)?
            |> List.map(
                Database.hacky_user_to_json,
            )
            |> Str.join_with(", ")
            |> |users_json| """{ "users": [${users_json}] }"""
            |> Ok

        "/users" ->
            payload
            |> Str.to_utf8
            |> Decode.from_bytes(Json.utf8)?
            |> .users
            |> ByName
            |> func_swap(Database.get_users)(database)?
            |> List.map(
                Database.hacky_user_to_json,
            )
            |> Str.join_with(", ")
            |> |users_json| """{ "users": [${users_json}] }"""
            |> Ok

        _ ->
            Err(NotFound)

post : Database, { url : Str, payload ?? Str } -> Result Str _
post = |database, { url, payload ?? "" }|
    when url is
        "/add" ->
            payload
            |> Str.to_utf8
            |> Decode.from_bytes(Json.utf8)?
            |> |{user}| Database.make_user({name: user})
            # For the purpose of the task, no need to call `Database.add_user`
            # |> func_swap(Database.add_user(database))?
            |> Database.hacky_user_to_json
            |> Ok

        "/iou" ->
            payload
            |> Str.to_utf8
            |> Decode.from_bytes(Json.utf8)?
            |> func_swap(iou)(database)?
            |> List.map(
                Database.hacky_user_to_json,
            )
            |> Str.join_with(", ")
            |> |users_json| """{ "users": [${users_json}] }"""
            |> Ok

        _ ->
            Err(NotFound)

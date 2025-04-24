module [Database, User, get_users, get_user, make_user, add_user, update_users, empty, hacky_user_to_json]

import Utils exposing [str_compare, hacky_dict_to_json]

Database : { users : List User }

User : {
    name : Str,
    owes : Dict Str F64,
    owed_by : Dict Str F64,
    balance : F64,
}

empty : {} -> Database
empty = |{}|
    { users : [] }

get_users : Database, [All, ByName (List Str)] -> Result (List User) _
get_users = |database, filter|
    when filter is
        All ->
            database.users
            |> Ok
        ByName names -> 
            database.users
            |> List.keep_if(
                |user| List.contains(names, user.name),
            )
            |> Ok

get_user : Database, Str -> Result User _
get_user = |database, name|
    when get_users(database, ByName([name])) is
        Err(err) ->
            Err(err)
        Ok([]) -> 
            Err(UserNotFound)
        Ok([user]) ->
            Ok(user)
        Ok([_, ..]) -> 
            Err(MultipleUsersFound)

make_user : { name : Str, owes ?? Dict Str F64, owed_by ?? Dict Str F64, balance ?? F64} -> User
make_user = |{ name, owes ?? Dict.empty({}), owed_by ?? Dict.empty({}), balance ?? 0.0}|
    { name, owes, owed_by, balance }

add_user : Database, User -> Result Database _
add_user = |database, new_user|
    if List.count_if(database.users, |existing_user| existing_user.name == new_user.name) > 0 then
        Err(UserAlreadyExists)
    else
        database.users
        |> List.append(new_user)
        |> List.sort_with(
            |u1, u2|
                str_compare(
                    u1.name |> Str.to_utf8,
                    u2.name |> Str.to_utf8,
                ),
        )
        |> |users| { database & users }
        |> Ok

update_users : Database, Dict Str User -> Result Database _
update_users = |database, new_users|
    database.users
    |> List.map(
        |existing_user|
            when Dict.get(new_users, existing_user.name) is
                Err(_) ->
                    existing_user
                Ok(user) ->
                    user
    )
    |> |users| { database & users }
    |> Ok

hacky_user_to_json : User -> Str
hacky_user_to_json = |user|
    """
    {
        "balance": ${Num.to_str(user.balance)},
        "name": "${user.name}",
        "owed_by": ${hacky_dict_to_json(user.owed_by)},
        "owes": ${hacky_dict_to_json(user.owes)}
    }
    """

-module(client).
-export([convert/5]).
-define(CONCAT_ATOM(A, B), list_to_atom(lists:concat([A, B]))).

convert(from, FromT, to, ToT, T) ->
    ?CONCAT_ATOM(from, FromT) ! {who, self(), to, ToT, val, T},
    receive
        {result, X} ->
            io:format(
                "~p°~s are equivalent to ~p°~s~n",
                [T, atom_to_list(FromT), X, atom_to_list(ToT)]
            )
    end.

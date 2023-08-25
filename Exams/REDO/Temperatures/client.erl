-module(client).
-export([convert/5]).
-define(CONCAT_ATOM(A, B), list_to_atom(lists:concat([A, B]))).

convert(from, From, to, T, Value) ->
    ?CONCAT_ATOM(from, From) ! {who, self(), to, T, val, Value},
    receive
        {result, X} ->
            io:format(
                "~p°~s are equivalent to ~p°~s~n",
                [Value, atom_to_list(From), X, atom_to_list(T)]
            )
    end.

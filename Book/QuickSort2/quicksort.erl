-module(quicksort).
-export([quicksort/1]).

quicksort([]) ->
    [];
quicksort([Pivot|Rest]) ->
    {Smaller, Larger} = partition(Pivot, Rest),
    quicksort(Smaller) ++ [Pivot] ++ quicksort(Larger).

partition(Pivot, Rest) ->
    % NOTE can be easily done using
    % {Smaller, Larger} = lists:partition(fun(X)->X =< Pivot, Rest).
    % NOTE that the above also returns the tuple automatically (as the end of the function)
    Smaller = lists:filter(fun(X) -> X =< Pivot end, Rest),
    Larger = Rest -- Smaller,
    {Smaller, Larger}.

-module(recursive).
-export([fibonacci/1, factorial/1, avg/1, zip/2]).

fibonacci(0) -> 0;
fibonacci(1) -> 1;
fibonacci(N) ->
    fibonacci(N - 1) + fibonacci(N - 2).

factorial(0) -> 1;
factorial(N) ->
    N * factorial(N - 1).

avg(L) ->
    % length function for list is already imported
    sum(L) / length(L).

% Not seen outside of the file because not exported
sum([]) -> 0;
sum([H | T]) ->
    H + sum(T).

zip(L1, L2) ->
    lists:reverse(zip_aux(L1, L2, [])).

zip_aux(_, [], Acc) ->
    Acc;
zip_aux([], _, Acc) ->
    Acc;
zip_aux([X|Xs], [Y|Ys], Acc) ->
    zip_aux(Xs, Ys, [{X, Y} | Acc]).

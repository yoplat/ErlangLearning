-module(map).
-export([map/2, add1/1]).

add1(X) ->
    X + 1.

% NOTE to use add1 inside the map function in the shell:
% map(fun fun_name/arity, L)
% map(fun add1/1, L)
% NOTE if not for this then erl would interpret them as atoms (being lowercase)
map(_, []) ->
    [];
map(F, [H|T]) ->
    [F(H) | map(F, T)].

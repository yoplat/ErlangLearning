-module(calculator).
-export([rpn/1]).

% is_list == is_string
rpn(L) when is_list(L) ->
    [Res] = lists:foldl(fun rpn/2, [], string:tokens(L, " ")).

rpn("+", [N1, N2 | Stack]) ->
    [(N1 + N2) | Stack];
rpn("-", [N1, N2 | Stack]) ->
    [(N1 - N2) | Stack];
rpn("*", [N1, N2 | Stack]) ->
    [(N1 * N2) | Stack];
rpn("/", [N1, N2 | Stack]) ->
    [(N1 / N2) | Stack];
rpn(X, Stack) ->
    [read(X) | Stack].

% Converts a string to a float or an int
read(N) ->
    case string:to_float(N) of
        {error, no_float} ->
            list_to_integer(N);
        {F, _} ->
            F
    end.

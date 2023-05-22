-module(guard).
-export([factorial/1, range/1]).

% fun(Arg1, Arg2...) when G1; G2; ... -> NOTE ; only one needs to be true
% fun(Arg1, Arg2...) when G1, G2, ... -> NOTE , ALL needs to be true
% NOTE guard can't use user defined functions, because there may be side-effects
factorial(N) when N < 2; N > 100 -> % If any
    1;
factorial(N) ->
    N * factorial(N - 1).

range(N) when is_integer(N), N > 10, N < 100 -> % If ALL
    io:format("~w is in range~n", [N]);
range(N) ->
    io:format("~w is not in range~n", [N]).

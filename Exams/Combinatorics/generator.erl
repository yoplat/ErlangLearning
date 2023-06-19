-module(generator).
-export([init/3]).

init(P, N, M) ->
    counter(1, trunc(math:pow(M, (N - P))), trunc(math:pow(M, N)), 1, P, N, M).

% Own counter increases every M^(N-P) ticks
% Seq is the iteration number
% Delay is the countdown to the next increase
% Value is the current value of the counter
% T is the maximum iterations
counter(Seq, _, T, _, _, _, _) when Seq > T -> stop;
counter(Seq, _, T, Value, P, N, M) when (Value > M) ->
    counter(Seq, trunc(math:pow(M, (N - P))), T, 1, P, N, M);
counter(Seq, 1, T, Value, P, N, M) ->
    entrypoint ! {seq, Seq, val, Value, pos, P},
    counter(Seq + 1, trunc(math:pow(M, (N - P))), T, Value + 1, P, N, M);
counter(Seq, Delay, T, Value, P, N, M) ->
    entrypoint ! {seq, Seq, val, Value, pos, P},
    counter(Seq + 1, Delay - 1, T, Value, P, N, M).

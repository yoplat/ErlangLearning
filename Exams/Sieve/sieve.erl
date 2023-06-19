-module(sieve).
-export([init/1]).

% N is the number used to sieve
init(N) ->
    receive
        % check inviato all'ultimo sieve (connesso al primo sieve)
        {who, From} ->
            From ! {who, N},
            init(N);
        % Gate e' il primo sieve che interagisce direttamente con controllore
        % To e' il sieve successivo
        {Gate, To} ->
            loop(Gate, To, N)
    end.

% Gate: primo sieve
% To: next sieve
% N: numero per fare il sieve
loop(Gate, To, N) ->
    receive
        % N1 is the number received to be checked by the sieve
        {new, N1} ->
            Gate ! {pass, N1},
            loop(Gate, To, N);
        {pass, N1} ->
            RootN1 = trunc(math:sqrt(N1)),
            if
                % Sieve is useless for the number => prime number
                (N > RootN1) ->
                    Gate ! {res, true},
                    loop(Gate, To, N);
                ((N1 rem N) == 0) ->
                    Gate ! {res, false},
                    loop(Gate, To, N);
                true ->
                    To ! {pass, N1},
                    loop(Gate, To, N)
            end;
        % Only used by the first sieve to send to the controller the result
        {res, V} ->
            controller ! {res, V},
            loop(Gate, To, N);
        Other ->
            io:format("unrecognized message:- ~p~n", [Other]),
            loop(Gate, To, N)
    end.

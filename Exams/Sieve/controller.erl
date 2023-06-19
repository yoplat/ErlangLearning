-module(controller).
-export([start/1]).

start(N) ->
    register(controller, spawn(fun() -> init_ring(N) end)).

init_ring(N) ->
    connect([
        % Inizializza tanti sieve quanti sono i numeri primi da 2 a N
        spawn_link(sieve, init, [X])
     || X <- lists:seq(2, N),
        % Y is the vector of numbers that divide X with no remainder
        % so we check that the length of the vector is 0 so that X is a prime number
        (length([Y || Y <- lists:seq(2, trunc(math:sqrt(X))), ((X rem Y) == 0)]) == 0)
    ]).

% First connect pushes the first element ALSO at the last position to connect
% the last sieve with the first one
connect(L = [H | TL]) -> connect(H, L, TL ++ [H]).
% Pid e' il primo sieve che fa da tramite tra tutti i sieve e il controllore
connect(Pid, [Pid1 | []], [Pid2 | []]) ->
    % Pid dovrebbe essere uguale al Pid2 (il primo sieve)
    % Pid1 dovrebbe essere l'ultimo sieve (connesso al primo)
    % Invia al sieve il Pid di se stesso (controllore)
    Pid1 ! {who, self()},
    receive
        % Il sieve restituisce il numero che usa come sieve
        % Max e' il numero massimo su cui fare sieve (essendo l'ultimo sieve)
        {who, Max} ->
            Pid1 ! {Pid, Pid2},
            loop(Max, Pid)
    end;
connect(Pid, [Pid1 | TL1], [Pid2 | TL2]) ->
    Pid1 ! {Pid, Pid2},
    connect(Pid, TL1, TL2).

% Max: sieve massimo
% Head: primo sieve
loop(Max, Head) ->
    % Ricevuto dal client per inizio di sieve
    receive
        {new, N, From} ->
            io:format("You asked for: ~p~n", [N]),
            RootN = trunc(math:sqrt(N)),
            if
                (RootN < Max) ->
                    Head ! {new, N},
                    receive
                        {res, R} ->
                            From !
                                {result, lists:flatten(io_lib:format("is ~p prime? ~p", [N, R]))}
                    end,
                    loop(Max, Head);
                true ->
                    From !
                        {result,
                            lists:flatten(
                                io_lib:format("~p is uncheckable, too big value.", [N])
                            )}
            end;
        {quit, From} ->
            io:format("I'm closing ...~n"),
            From ! {result, "The service is closed!!!"};
        Other ->
            io:format("unrecognized message:- ~p~n", [Other]),
            loop(Max, Head)
    end.

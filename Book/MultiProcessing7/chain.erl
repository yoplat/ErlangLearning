-module(chain).
-compile(export_all).

chain(0) ->
    receive
        _ -> ok
    % This will be reached after 2000 + time to create the 5 function (negligible)
    after 2000 ->
        exit("chain dies here")
    end;
chain(N) ->
    % the chain(N-1) is wrapped in an anonymous fun to be able to
    % pass its argument by default (equal to using the spawn/3 function)
    Pid = spawn(fun() -> chain(N-1) end),
    link(Pid), % NOTE corresponding unlink command to remove connection
    receive
        _ -> ok
    end.

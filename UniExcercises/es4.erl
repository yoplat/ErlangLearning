-module(es4).
-export([start/0, print/1, stop/0]).

-record(message, {text = ""}).

start() ->
    register(server, spawn(fun loop/0)),
    ok.

print(Term) ->
    try erlang:is_process_alive(whereis(server)) of
        _ ->
            server ! #message{ text = Term },
            ok
    catch
        _:_ ->
            io:format("Server is not up, use the start command.~n")
    end.

stop() ->
    try erlang:is_process_alive(whereis(server)) of
        _ ->
            server ! stop,
            ok
    catch
        _:_ ->
            io:format("Server is already down.~n")
    end.

loop() ->
    receive
        stop ->
            io:format("Terminated server, to restart use the start command.~n"),
            exit(normal);
        #message{ text = Text } ->
            io:format("~s~n", [Text]),
            loop();
        _ ->
            io:format("Non ho capito il messaggio~n"),
            exit(unknown_message)
    end.

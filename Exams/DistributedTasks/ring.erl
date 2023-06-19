-module(ring).
-export([start/2, send_message/1, send_message/2, stop/0, create/3]).

start(N, F) ->
    register(
        ring_recursion_functional,
        spawn(?MODULE, create, [N, F, self()])
    ),
    receive
        ready -> ok
    after 5000 -> {error, timeout}
    end.

% Last actor
create(1, [H | _], Starter) ->
    Starter ! ready,
    loop_last(ring_recursion_functional, H);
create(N, [H | TL], Starter) ->
    Next = spawn_link(?MODULE, create, [N - 1, TL, Starter]),
    loop(Next, H).

send_message(X) ->
    send_message(X, 1).

send_message(X, N) ->
    ring_recursion_functional ! {command, message, [X, N]}.

loop(Next, F) ->
    receive
        Msg = {command, stop} ->
            Next ! Msg,
            ok;
        {command, message, [Message, Times]} ->
            Next ! {command, message, [F(Message), Times]},
            loop(Next, F)
    end.

loop_last(Next, F) ->
    receive
        {command, stop} ->
            exit(normal),
            unregister(ring_recursion_functional);
        {command, message, [Message, 1]} ->
            io:format("~p~n", [F(Message)]),
            loop_last(Next, F);
        {command, message, [Message, N]} ->
            Next ! {command, message, [F(Message), N - 1]},
            loop_last(Next, F)
    end.

stop() ->
    ring_recursion_functional ! {command, stop}.

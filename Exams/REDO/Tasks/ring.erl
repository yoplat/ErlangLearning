-module(ring).
-export([start/2, send_message/1, send_message/2, stop/0]).

start(N, FL) ->
    register(
        ring_recursion_functional,
        spawn(?MODULE, create, [N, FL, self()])
    ),
    receive
        ready -> ok
    after 5000 -> {error, timeout}
    end.

stop() -> ring_recursion_functional ! {command, stop}.

send_message(Message) -> send_message(Message, 1).
send_message(Message, Times) ->
    ring_recursion_functional ! {command, message, [Message, Times]}.

create(1, [H | []], Starter) ->
    Starter ! ready,
    loop_last(ring_recursion_functional, H);
create(N, [F | FT], Starter) ->
    Next = spawn_link(?MODULE, create, [N - 1, FT, Starter]),
    loop(Next, F).

loop_last(NextProcess, F) ->
    receive
        {command, stop} ->
            exit(normal),
            unregister(ring_recursion_functional);
        {command, message, [Message, 1]} ->
            io:format("~p~n", [F(Message)]),
            loop_last(NextProcess, F);
        {command, message, [Message, Times]} ->
            NextProcess ! {command, message, [F(Message), Times - 1]},
            loop_last(NextProcess, F)
    end.

loop(NextProcess, F) ->
    receive
        Msg = {command, stop} ->
            NextProcess ! Msg,
            ok;
        {command, message, [Message, Times]} ->
            NextProcess ! {command, message, [F(Message), Times]},
            loop(NextProcess, F)
    end.

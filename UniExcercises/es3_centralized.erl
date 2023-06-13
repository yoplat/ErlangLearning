-module(es3_centralized).
-export([start/3]).

start(M, N, Message) ->
    create(N),
    send_messages(M, {1, Message}),
    timer:sleep(10),
    first_node ! stop,
    io:format("ciao").

% Creates node N (to connect to first_node)
create(N) ->
    Pid = spawn(fun() -> ring_node(first_node) end),
    io:format(
        "[master] created node ~p with pid ~p chained to node 1 (first_node, not yet created)~n",
        [N, Pid]
    ),
    create(Pid, N - 1).

create(NextNode, 1) ->
    register(first_node, spawn(fun() -> ring_node(NextNode) end)),
    io:format(
        "[master] created node 1 (first_node) with pid ~p chained to node 2 with pid ~p~n",
        [whereis(first_node), NextNode]
    );
create(NextNode, N) ->
    Pid = spawn(fun() -> ring_node(NextNode) end),
    io:format(
        "[master] created node ~p with pid ~p chained to node ~p with pid ~p~n",
        [N, Pid, N + 1, NextNode]
    ),
    create(Pid, N - 1).

send_messages(0, _) ->
    ok;
send_messages(M, {Index, Message}) ->
    first_node ! {0, Index, Message},
    send_messages(M - 1, {Index + 1, Message}).

ring_node(NextNode) ->
    receive
        stop ->
            debug_print("stop", NextNode),
            % uso catch per evitare un eccezione badarg nel momento in cui NextNode == first_node
            catch NextNode ! stop,
            debug_print("stopping"),
            exit(stop);
        {ForwardedCount, Index, Message} ->
            debug_print(ForwardedCount, Index, Message, NextNode),
            catch NextNode ! {ForwardedCount + 1, Index, Message},
            ring_node(NextNode)
    end.

debug_print(Count, Index, Msg, To) ->
    io:format("[From: ~p] -> [To: ~p] - ~p:~p (forwarded ~p times)~n", [
        self(), To, Index, Msg, Count
    ]).
debug_print(Msg, To) -> io:format("[From: ~p] -> [To: ~p] - ~p~n", [self(), To, Msg]).
debug_print(Msg) -> io:format("[Pid: ~p] ~p~n", [self(), Msg]).

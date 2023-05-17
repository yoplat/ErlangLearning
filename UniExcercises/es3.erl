-module(es3).
-export([start/3, create/3]).

% Sends M messages to N processes
start(M, N, Msg) ->
  % Spawn first process
  register(rring_fst, spawn(?MODULE, create, [N, 1, self()])),
  io:format("*** [rring_fst] is at ~p~n", [whereis(rring_fst)]),
  receive
    % All processes were created
    ready      -> ok
    after 5000 -> exit(timeout)
  end,
  % Start sending messages
  msg_dispatcher(M, 1, Msg),
  % Kill all processes
  rring_fst!stop,
  ok.

% Last message to be sent
msg_dispatcher(M, M, Msg) -> rring_fst!{Msg, M, 1};
% Nth message to be sent
msg_dispatcher(M, N, Msg) -> rring_fst!{Msg, N, 1}, msg_dispatcher(M, N+1, Msg).

% Last process created sends ready and connects to first process to close ring
create(1, Who, Starter) ->
  Starter ! ready,
  io:format("*** created [~p] as ~p connected to ~p~n", [self(), Who, rring_fst]),
  loop_last(rring_fst, Who);
% Create N processes with current one number "Who" with the starting point Starter
create(N, Who, Starter) ->
  % The Who'nth process creates the Who+1 process
  Next = spawn(?MODULE, create, [N-1, Who+1, Starter]),
  io:format("*** created [~p] as ~p connected to ~p~n", [self(), Who, Next]),
  % Receive loop for Who'nth process
  loop(Next, Who).

% loop with next node = Next and Who is the current process
loop(Next, Who) ->
  receive
    % Msg is the message to be sent to all processes
    % N is the number of messages sent till now (this is the Nth message)
    % Pass is the number of times the message was received by Who
    {Msg, N, Pass}=M ->
        io:format("[~p] Got {~p ~p} for the ~p time~n", [Who, Msg, N, Pass]),
        % Checks if Next process is still alive
        io:format("*** [~p] is ~p alive? ~p~n", [Who, Next, erlang:is_process_alive(Next)]),
        % Sends message to the next process
        Next ! {Msg, N, Pass},
        io:format("*** [~p] sent ~p to [~p]~n", [Who, M, Next]),
        % Keeps looping for next messages
        loop(Next, Who);
    stop ->
        io:format("[~p] Got {stop}~n", [Who]),
        % Is Next still alive?
        io:format("*** [~p] is ~p alive? ~p~n", [Who, Next, erlang:is_process_alive(Next)]),
        Next ! stop,
        io:format("*** [~p] sent {stop} to [~p]~n", [Who, Next]),
        io:format("# Actor ~p stops.~n", [Who]);
    Other -> io:format("*** Houston we have a problem: ~p~n", [Other])
  end.

loop_last(Next, Who) ->
  receive
    {Msg, N, Pass}=M ->
        io:format("[~p] Got {~p ~p} for the ~p time [loop_last]~n", [Who, Msg, N, Pass]),
        io:format("*** [~p] is ~p alive? ~p [loop_last]~n", [Who, Next, erlang:is_process_alive(whereis(Next))]),
        % Sends message back to rring_fst with Pass+1
        Next ! {Msg, N, Pass+1},
        io:format("*** [~p] sent ~p to [~p] [loop_last]~n", [Who, M, Next]),
        loop_last(Next, Who);
    stop ->
        io:format("[~p] Got {stop} [loop_last]~n", [Who]),
        exit(normal),
        unregister(rring_fst),
        io:format("*** [~p] unregistered [~p]~n", [Who, rring_fst]),
        io:format("# Actor ~p stops [loop_last].~n", [Who]);
    Other -> io:format("*** Houston we have a problem: ~p~n", [Other])
  end.

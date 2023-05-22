-module(event).
-export([start/2, start_link/2, cancel/1]).
-record(state, {server, name="", to_go=0}). % NOTE c(event)., rr(event, state).

% An event is a reminder set with a certain time to go
% Server is the event server that process multiple events
loop(S = #state{server=Server, to_go=[T|Next]}) ->
    receive
        % NOTE we name the Server in the fun sig because the method used
        % for the after clause can't be used for pattern matching
        {Server, Ref, cancel} ->
            Server ! {Ref, ok}
    % to_go is the time until the event has to happen in seconds
    after T*1000 ->
        if Next =:= [] ->
                Server ! {done, S#state.name};
           Next =/= [] ->
                loop(S#state{to_go=Next})
        end
    end.

% Max value for after clause is Limit, so workaround
normalize(N) ->
    Limit = 49*24*60*60,
    % lists:duplicate(n_times, value)
    [N rem Limit | lists:duplicate(N div Limit, Limit)].

start(EventName, Delay) ->
    spawn(?MODULE, init, [self(), EventName, Delay]).

start_link(EventName, Delay) ->
    spawn_link(?MODULE, init, [self(), EventName, Delay]).

%% Event starting point
init(Server, EventName, Delay) ->
    loop(#state{server=Server, name=EventName, to_go=normalize(Delay)}).

cancel(Pid) ->
    % In case the process is already dead
    Ref = erlang:monitor(process, Pid),
    Pid ! {self(), Ref, cancel},
    receive
        {Ref, ok} ->
            erlang:demonitor(Ref, [flush]),
            ok;
        % Already down
        {'DOWN', Ref, process, Pid, _Reason} ->
            ok
    end.


%% USE CASES
%% 6> c(event).
%% {ok,event}
%% 7> rr(event, state).
%% [state]
%% 8> spawn(event, loop, [#state{server=self(), name="test", to_go=5}]).
%% <0.60.0>
%% 9> flush().
%% ok
%% 10> flush().
%% Shell got {done,"test"}
%% ok
%% 11> Pid = spawn(event, loop, [#state{server=self(), name="test", to_go=500}]).
%% <0.64.0>
%% 12> ReplyRef = make_ref().
%% #Ref<0.0.0.210>
%% 13> Pid ! {self(), ReplyRef, cancel}.
%% {<0.50.0>,#Ref<0.0.0.210>,cancel}
%% 14> flush().
%% Shell got {#Ref<0.0.0.210>,ok}

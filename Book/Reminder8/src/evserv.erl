-module(evserv).
-compile(export_all).
-record(state, {events, % list of #event record
                clients}). % list of Pids
-record(event, {name="", description="", pid, timeout}).

init() ->
    loop(#state{events = orddict:new(), 
                clients = orddict:new()}).

loop(S = #state{}) ->
    receive
        {Pid, MsgRef, {subscribe, Client}} ->
            Ref = erlang:monitor(process, Client),
            % * orddict:store(key, value, oldDict)
            NewClients = orddict:store(Ref, Client, S#state.clients),
            Pid ! {MsgRef, ok},
            loop(S#state.clients=NewClients);
        {Pid, MsgRef, {add, Name, Description, TimeOut}} ->
            % * Note how the module can be directly called even if not built in
            EventPid = event:start_link(Name, TimeOut),
            NewEvents = orddict:store(Name, #event{name=Name, 
                                                    description=Description,
                                                    pid = EventPid,
                                                    timeout = TimeOut}, 
                                            S#state.events),
            Pid ! {MsgRef, ok},
            loop(S#state.events=NewEvents);
        {Pid, MsgRef, {cancel, Name}} ->
            Events = case orddict:find(Name, S#state.events) of
                          {ok, E} ->
                              event:cancel(E#event.pid),
                              orddict:erase(Name, S#state.events);
                          error ->
                              S#state.events
                     end,
            Pid ! {MsgRef, ok},
            loop(S#state{events=Events});
        {done, Name} ->
      ;
        shutdown ->
      ;
        {'DOWN', Ref, process, _Pid, _Reason} ->
      ;
        code_change ->
      ;
        Unknown ->
            io:format("Unknown message ~p~n", [Unknown]),
            loop(State)
    end.

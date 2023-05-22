-module(monitor).
-compile(export_all).

main() ->
    % Outputs {'DOWN', MonitorRef, process, Pid, Reason} when process ends
    erlang:monitor(process, spawn(fun() -> timer:sleep(500) end)),
    % Easier spawning and monitoring at the same time
    % Pid, MonitorRef
    {Pid, Ref} = spawn_monitor(fun() -> receive _ -> exit(boom) end end),
    Pid ! die,
    %% Remove monitoring of the process and outputs false if process didnt exist
    erlang:demonitor(Ref, [flush, info]).

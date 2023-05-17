-module(linkmon).
-compile(export_all).

start_critic() ->
    spawn(?MODULE, critic, []).

judge(Pid, Band, Album) ->
    Pid ! {self(), {Band, Album}},
    receive
        {Pid, Criticism} -> Criticism
    after 2000 ->
        timeout
    end.

critic() ->
    % NOTE the only problem with spawning directly the critic, is that if there is an
    % unexpected error and the process shuts down, the user doesnt notices it until a new message
    % see the restarter function for fix
    receive
        {From, {"Rage Against the Turing Machine", "Unit Testify"}} ->
            From ! {self(), "They are great!"};
        {From, {"System of a Downtime", "Memoize"}} ->
            From ! {self(), "They're not Johnny Crash but they're good."};
        {From, {"Johnny Crash", "The Token Ring of Fire"}} ->
            From ! {self(), "Simply incredible."};
        {From, {_Band, _Album}} ->
            From ! {self(), "They are terrible!"}
        end,
        critic().

spawn_critic2() ->
    spawn(?MODULE, restarter, []).

% NOTE there is no way for the user to have the critic Pid
% only the restarter Pid
restarter() ->
    % NOTE tranforms exit signals to regular messages
    process_flag(trap_exit, true),
    % Spawn and links processes
    Pid = spawn_link(?MODULE, critic, []),
    % NOTE now the atom critic is the name of the process critic in the whole file
    register(critic, Pid),
    receive
        {'EXIT', Pid, normal} ->
            ok;
        {'EXIT', Pid, shutdown} ->
            ok;
        % NOTE if anomaly, restart the process
        {'EXIT', Pid, _} ->
            restarter()
    end.

judge2(Band, Album) ->
    critic ! {self(), {Band, Album}},
    % Gets Pid of critic to pattern match
    Pid = whereis(critic),
    receive
        % NOTE NOTE IMPORTANT: note that Pid is not an empty variable,
        % its the Pid of critic, so I think that if a variable has already a value
        % then the pattern match is true if the record contains that exact value,
        % while if the var is unbound, the pattern match will bind its value to that var
        % Pid is the first option, Criticism is the second
        {Pid, Criticism} -> Criticism
    after 2000 ->
        timeout
    end.

-module(changecase_server).
-export([start/0, loop/0]).

start() ->
    % Creates a new process (module, loop, args)
    spawn(?MODULE, loop, []).

loop() -> 
    receive 
        % c(changecase_server).
        % Server = changecase_server:start().\
        % Server ! {self(), {"hello", uppercase).
        % receive X -> X end.
        % pattern matching
        % if client sends a string and atom uppercase it sends back an uppercase 
        {Client, {Str, uppercase}} -> 
            Client ! {self(), string:to_upper(Str)};
        % if client sends a string and atom lowercase it sends back an lowercase 
        {Client, {Str, lowercase}} -> 
            Client ! {self(), string:to_lower(Str)}
    end,
    loop().

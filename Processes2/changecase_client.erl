-module(changecase_client).
-export([changecase/3]).

changecase (Server, Str, Command) -> 
    % Client sends message to server with its Pid
    Server ! {self(), {Str, Command}},
    receive
        % The message returned by the server 
        {Server, ResultString} -> 
            % Returns the resultString
            ResultString
    end.

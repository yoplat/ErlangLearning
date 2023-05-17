-module(if_expr).
-export([check_temperature/1]).

check_temperature(Temperature) ->
    if
        % You can also assign the value of the if statement like so:
        % Var = if ...... end.
        % This works because there is a default branch
        Temperature < 40 ->
            io:format("Temperature is ok~n");
        Temperature > 40 ->
            io:format("Temperature is hot~n");
        true -> % default branch / ELSE branch
            io:format("40 degrees~n")
    end.

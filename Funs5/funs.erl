-module(funs).
-export([main/0]).

main() ->
    % End a statement with a , if the function is not finished
    % End a function  with a .
    % Lambda function
    Greetings = fun(Name) ->
                         io:format("Hello, ~s~n", [Name]) end,
    Greetings("Erlang"),

    Filter = fun(X) ->
                     X > 10 end,

    Scores = [10, 24, 33, 4, 51],
    % list:map, filter...
    lists:filter(Filter, Scores),

    Hello = fun(Greeting) ->
                    (fun (Name) ->
                             % NOTE that the first end doesn't need the .
                             io:format("~s, ~s~n", [Greeting, Name]) end) end,
    % Partial application
    HelloGreeting = Hello("Hello"),
    HelloGreeting("Carlo").

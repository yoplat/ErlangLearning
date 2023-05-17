-module(case_expr).
-export([greet/3]).

greet(Name, Language, Age) ->
    case Language of
        % Atoms matching
        % You can use guards too
        polish when Age < 18 ->
            io:format("Witaj, ~s~n", [Name]);
        polish ->
            io:format("Witaj, Panie ~s~n", [Name]);
        english ->
            io:format("Hello, ~s~n", [Name]);
        spanish ->
            io:format("Ola, ~s~n", [Name]) % NOTE no .
    end. % NOTE the end. for the case

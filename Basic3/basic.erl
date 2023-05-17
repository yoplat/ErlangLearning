-module(basic).
-export([main/0]).

main () ->
    % Variables start with uppercase letter
    % Can't change the value (it tries to pattern match)
    Myvar = "Hello",
    % 10 / 3. is floating point divison
    % 10 div 3. is integer division
    % 10 rem 3. (1) is module operation
    % you can define "atoms" as like new values for variables
    % red. defines an atom red -> Myvar = red

    % TUPLES
    % usually you put an atom at the start to define what
    % the tuple is supposed to be
    Profile = {profile, 1, "Mike"},
    % Tuple extraction
    {_, Username} = Profile,

    % LISTS
    % L = [1, 2, 4, 6].
    % [H1, H2 | T] = L. -> H1 = 1, H2 = 2, T = [4, 6]
    % List concatenation L ++ L1
    % lists:sum(L).
    % lists:nth(2, L).

    % STRINGS
    % $char -> outputs unicode of char
    Language = "Erlang",
    % Outputs the array of corresponding ascii values
    io:format("~w~n", [Language]),
    % Outputs the string normally
    io:format("~s~n", [Language]).
    % string:reverse("ciao")
    % Without all it splits only one time
    % string:split("ciao io sono", " ", all).

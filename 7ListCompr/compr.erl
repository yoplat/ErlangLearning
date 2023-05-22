-module(compr).
-export([main/0]).

main() ->
    Scores = [10, 2, 46, 34],
    % List comprehension
    % NOTE [Expression || Pattern <- List, Pattern1 <- List2..., Cond1, Cond2, Cond3...]
    % Can use Pattern to pattern match (Ex: {X, Y} <- AssocList)
    % Divides every value by 5 of the list Scores and outputs corresponding list
    [X / 5 || X <- Scores],
    % List from 1 to 9 of even elem
    [X || X <- [1, 2, 3, 4, 5, 6, 7, 8, 9], X rem 2 == 0].

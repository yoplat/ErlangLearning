-module(control).
-export([for/3, fordown/3, range/4]).

% lib_misc.erl
% Prints all the numbers from 0 to 10
% control:for(1, 10, fun(I) -> io:format("~w~n", [I]) end).
for(Max, Max, F) ->
    [F(Max)];
for(I, Max, F) ->
    [F(I) | for(I+1, Max, F)].

fordown(Min, Min, F) ->
    [F(Min)];
fordown(I, Min, F) ->
    [F(I) | fordown(I-1, Min, F)].

% NOTE the problem in case the Step fun skip the Max value
% NOTE the first clause raises a warning if Step is put as opposed to _
% because it is not used inside it
range(Max, Max, _, F) ->
    [F(Max)];
range(I, Max, Step, F) ->
    [F(I) | range(Step(I), Max, Step, F)].

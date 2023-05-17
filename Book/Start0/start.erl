-module(start).
-export([main/0]).

main() ->
    % Boolean op are with and, or, not
    %
    % =:= and =/= are for comparing values
    % >= is greater-equal, NOTE =< is for less-equal
    %
    % NOTE LISTS
    % L1 ++ L2 to concatenate lists
    % L1 -- L2 to subtract lists
    % hd(L), tl(L) to get head and tail of lists
    % list:seq(start, end) -> [start, start+1, ..., end]
    %
    % NOTE TUPLES
    % element(n, Tuple) -> gets element n (from 1 to length)
    %
    % NOTE USEFUL FUNCTIONS
    % - fromType_to_toType -> functions to convert values
    %  list_to_integer("54") -> 54 (NOTE this is because strings are lists)
    %  atom_to_list(ciao) -> "ciao" (list are string and viceversa)
    % - math:pow(n, k) -> n^k
    % - string:token("stirng", " ") -> string.split
    io:format("Hello~n").

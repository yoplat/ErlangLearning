-module(road).
-export([main/0]).

%
% A for orizonatal upper segments values
% B for orizonatal lower segments values
% X for vertical segments values
%     50    5     40
% A ------------------
%        |     |
%     30 |  20 |      DESTINATION
%        |     |
%        |     |
% B ------------------
%     10    90    2
%

main() ->
    File = "road.txt",
    % Reads and outputs to Binary the content of the file
    {ok, Binary} = file:read_file(File),
    Map = parse_map(Binary),
    optimal_path(Map).

% From binary to string
parse_map(Bin) when is_binary(Bin) ->
    parse_map(binary_to_list(Bin));
% From string to list of integers
parse_map(Str) when is_list(Str) ->
    % the token passed to the function are individually checked
    % they don't need to be connected
    Values = [list_to_integer(X) || X <- string:tokens(Str, "\r\n\t ")],
    group_vals(Values, []).

% Group values as {A, B, X}
group_vals([], Acc) ->
    lists:reverse(Acc);
group_vals([A, B, X | Rest], Acc) ->
    group_vals(Rest, [{A, B, X} | Acc]).

shortest_step({A, B, X}, {{DistA, PathA}, {DistB, PathB}}) ->
    % Path to A lane selecting A
    OptA1 = {DistA + A, [{a, A} | PathA]},
    % Path to A lane selecting B and X
    % NOTE the path are put backwards to be reversed at the end
    OptA2 = {DistB + B + X, [{x, X}, {b, B} | PathB]},
    % Path to B lane selecting B
    OptB1 = {DistB + B, [{b, B} | PathB]},
    % Path to B lane selecting A and X
    OptB2 = {DistA + A + X, [{x, X}, {a, A} | PathA]},
    {erlang:min(OptA1, OptA2), erlang:min(OptB1, OptB2)}.

optimal_path(Map) ->
    {A, B} = lists:foldl(fun shortest_step/2, {{0, []}, {0, []}}, Map),
    % At the end of the fold, both path should have the same distance,
    % apart from one that will have passed for the X path with value 0
    % So we will pick the one that didn't pass for that
    {_Dist, Path} = if hd(element(2, A)) =/= {x, 0} -> A;
                       hd(element(2, B)) =/= {x, 0} -> B
                    end,
    lists:reverse(Path).

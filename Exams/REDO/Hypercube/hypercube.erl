-module(hypercube).
-export([create/0, hamilton/2, gray/1, neighbors/1]).

create() ->
    % PIDs is a list of {gray code, PID}
    PIDs = [{G, spawn(node, start, [G])} || G <- gray(4)],
    lists:foreach(
        % For each gray code and list of neighbors
        fun({G, Ns}) ->
            % Find the PID of the process with gray code G
            {_, P} = lists:keyfind(G, 1, PIDs),
            % Send the list of neighbors to the process
            % self is the PID of the current process
            P ! {neighbors, pair_pids(PIDs, Ns), src, self()}
        end,
        grayneighbors(gray(4))
    ),
    {_, P} = lists:keyfind("0000", 1, PIDs),
    % Register the process with gray code "0000" as zero
    register(zero, P).

hamilton(M, [HG | TG]) ->
    zero ! {msg, {src, HG, msg, M}, path, TG},
    receive
        Other -> io:format("~p~n", [Other])
    end.

% gray(0) -> [""]
% gray(1) -> ["0", "1"]
% gray(2) -> ["00", "01", "11", "10"]
% gray(3) -> ["000", "001", "011", "010", "110", "111", "101", "100"]
% gray(N) is all combination of N bits
gray(0) ->
    [""];
gray(N) ->
    % All combination of previous N - 1 bits
    G = gray(N - 1),
    % Add 0 to the front of all previous N - 1 bits
    % Add 1 to the front of all previous N - 1 bits in reverse order
    % this is to ensure that the distance between two consecutive
    % elements is 1
    % Concatenate the two lists
    ["0" ++ L || L <- G] ++ ["1" ++ L || L <- lists:reverse(G)].

strxor([], []) -> [];
% $0 is the ASCII code for 0
strxor([H1 | T1], [H2 | T2]) -> [(H1 bxor H2) + $0 | strxor(T1, T2)].

% Lab is a string of 0 and 1 from the gray code
neighbors(Lab) ->
    [
        strxor(X, N)
     || {X, N} <- lists:zip(
            % trick to get a list of Lab repeated 4 times
            %  "1010" -> ["1010", "1010", "1010", "1010"]
            %   mask  -> ["1000", "0100", "0010", "0001"]
            % X xor Y -> ["0010", "1110", "1000", "1011"]
            % => if the mask is 0, the result is the same as X
            % => if the mask is 1, the result the opposite of X
            % => changes one bit at a time
            [X || X <- [Lab], _ <- lists:seq(0, 3)],
            ["1000", "0100", "0010", "0001"]
        )
    ].

grayneighbors([]) -> [];
% list of {gray code, list of neighbors}
grayneighbors([H | T]) -> [{H, neighbors(H)}] ++ grayneighbors(T).

pair_pids(_, []) ->
    [];
pair_pids(PIDs, [H | T]) ->
    {H, P} = lists:keyfind(H, 1, PIDs),
    [{H, P}] ++ pair_pids(PIDs, T).

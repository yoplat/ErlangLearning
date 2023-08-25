-module(joseph).
-export([joseph/2]).

joseph(N, K) ->
    PIDs = [spawn(hebrew, start, [G, N, K]) || G <- lists:seq(1, N)],
    [
        P ! {neighbor, Next, master, self()}
     || {P, Next} <- lists:zip(PIDs, tl(PIDs) ++ [hd(PIDs)])
    ],
    hd(PIDs) ! {msg, "Who will survive?", from, lists:last(PIDs), stepn, 1, stepk, 1},
    receive
        {msg, "I'm the survivor!", from, _, label, L} ->
            io:format(
                "In a circle of ~p people, killing number ~p~nJoseph is the Hebrew in position ~p~n",
                [N, K, L]
            );
        Other ->
            io:format("### error ~p~n", [Other])
    end.

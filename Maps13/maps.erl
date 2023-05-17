-module(maps).
-export([main/0]).

main() ->
    % USEFUL FUNCTIONS
    % -maps:new() -> #{}.
    % -is_map()
    % -maps:to_list(M) -> Association list
    % -maps:from_list(L) -> Association list to map
    % -maps:size(M)
    % -maps:is_key(key, M)
    % -maps:get(key, M)
    % -maps:find(key, M) -> Returns {ok, Value} or Error (Not exception)
    % -maps:remove(key, M) -> Returns NEW map
    % -maps:without([keylist], M) -> Returns map without keys
    % The key can be almost anything, can be a tuple
    Scores = #{ john => 100, adam => 114, sarah => 120 },
    % Creates a new map with new assoc added
    Scores1 = Scores#{ carlo => 20 },
    % => can be used also to update existing assoc
    Scores2 = Scores1#{ carlo => 24 },
    % NOTE := can ONLY be used for updating, useful to make sure key already exists
    Scores3 = Scores2#{ carlo := 25 },

    % Pattern matching for key values -> maps:get(key, M)
    #{ john := Value } = Scores.

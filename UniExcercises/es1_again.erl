-module(es1_again).
-compile(export_all).

is_palindrome(Str) ->
    string:reverse(Str) =:= Str.

is_an_anagram(_, []) ->
    false;
is_an_anagram(Str, [X | Xs]) ->
    (lists:sort(Str) =:= lists:sort(X)) or is_an_anagram(Str, Xs).

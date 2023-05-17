-module(es1).
-compile(export_all).

is_palindrome(Str) ->
    string:reverse(Str) =:= Str.

is_an_anagram(_, []) ->
    false;
is_an_anagram(Str, [H | T]) ->
    (lists:sort(Str) =:= lists:sort(H)) or is_an_anagram(Str, T).

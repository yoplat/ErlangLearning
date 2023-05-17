-module(records).
-include("messages.hrl"). % NOTE To include .hrl files
% -define(message, {sender, receiver, text = ""})
-export([print_message/1, is_message/1]).

% This lets us store the message as M but also the individual args
% Can also omit certain args
print_message(#message{sender=S, receiver=R, text=T} = M) ->
    io:format("Message~n"),
    io:format("From: ~s~n", [S]),
    io:format("To: ~s~n", [R]),
    io:format("Text: ~s~n", [T]).

% Guard to check if record is of type message
% It doesnt check if it's that exact record, simply checks the num of args
is_message(X) when is_record(X, message) ->
    true;
is_message(_) ->
    false.

%% Module declaration REQUIRED and starts with lowercase letter
%% NEEDS to match filename
-module(intro).
%% Means that the function start is to be used in shell and has 0 parameters
-export([start/0]).

%% Start erl shell in same dir and type 
%% c(module_name) 
%% To call a function imported in the shell
%% module_name:fun_name()

%% To compile : erlc file_name
%% To run     : erl -noshell -s module_name fun_name -s init intro

start() -> 
    %% ~n used as opposed to \n 
    io:format("Hello world~n").
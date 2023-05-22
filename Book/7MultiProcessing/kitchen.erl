-module(kitchen).
-export([start/1, store2/2, take2/2]).

% NOTE flush() outputs the messages sent to client

fridge1() ->
    receive
        {From, {store, _Food}} ->
            From ! {self , ok},
            fridge1();
        {From, {take , _Food}} ->
            % NOTE there is no state to save the food
            From ! {self, not_found},
            fridge1();
        terminate ->
            ok
    end.

fridge2(FoodList) ->
    % NOTE to use this functions the user needs to know the structure
    % of the messages to send -> See store and take functions
    receive
        {From, {store, Food}} ->
            % Store food in the fridge
            From ! {self , ok},
            fridge2([Food | FoodList]);
        {From, {take , Food}} ->
            case lists:member(Food, FoodList) of
                true -> % There is that food in the frige
                    From ! {self, {ok, Food}},
                    fridge2(lists:delete(Food, FoodList));
                false -> % Food not found
                    From ! {self, not_found},
                    fridge2(FoodList)
            end;
        terminate ->
            ok
    end.

% NOTE using this function the only thing the user HAS to do
% is to start the fridge2 process (and assign it to a variable) -> See start fun
% Pid -> Process ID
store(Pid, Food) ->
    Pid ! {self(), {store, Food}},
    receive
        {Pid, Msg} -> Msg
    end.

take(Pid, Food) ->
    Pid ! {self(), {take, Food}},
    receive
        {Pid, Msg} -> Msg
    end.

% Helper function to create a new fridge with a FoodList to start
start(FoodList) ->
    % NOTE ?MODULE is a macro for the current module
    spawn(?MODULE, fridge2, [FoodList]).

% NOTE if the Pid was an unknown or fake process (created with pid(A, B, C) fun
% that takes in 3 integers and outputs a process id), the start and take fun
% would freeze the shell because they would be waiting for a message that doesnt come
store2(Pid, Food) ->
    Pid ! {self(), {store, Food}},
    receive
        {Pid, Msg} -> Msg
    % NOTE after N milliseconds
    after 3000 -> % NOTE the -> after N
            timeout
    end.

take2(Pid, Food) ->
    Pid ! {self(), {take, Food}},
    receive
        {Pid, Msg} -> Msg
    after 3000 ->
            timeout
    end.

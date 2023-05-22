-module(conc).
-compile(export_all).

main() ->
    G = fun(X) ->
                % Sleeps for 10ms
                timer:sleep(10),
                io:format("~p~n", [X])
        end,
    % NOTE last run because of sleep
    [spawn(fun() -> G(X) end) || X <- lists:seq(1, 10)],

    % NOTE self() -> to get process id
    % process ! message -> self() ! hello -> sends "message" to "process"
    % NOTE it also returns the message itself so:
    % process ! process ! ... ! message -> sends "message" to all processes
    %
    % NOTE to see the mailbox of the current process -> flush()

    % New type of spawn
    % spawn(module, func, argument of the func)
    Dolphin = spawn(conc, dolphin1, []),
    % NOTE first run
    Dolphin ! fish,
    % NOTE that this is not run, because after the process has received a
    % message, it terminates
    Dolphin ! do_a_flip,

    Dolphin1 = spawn(fun dolphin2/0),
    % NOTE second run
    Dolphin1 ! {self(), do_a_flip},

    receive
        Message -> io:format("~s~n", [Message])
    end,

    io:format("Hello~n").

dolphin1() ->
    % Receive message for current process
    receive
        % Can also have guards
        do_a_flip ->
            io:format("How about no?~n");
        fish ->
            io:format("So long and thanks for all the fish!~n");
        _ ->
            io:format("Heh, we're smarter than you humans.~n")
    end.

dolphin2() ->
    receive
        {From, do_a_flip} ->
            From ! "How about a no?";
        {From, fish} ->
            From ! "So long and thanks for all the fish!";
        _ ->
            io:format("Heh, we're smarter than you humans.~n")
    end.

dolphin3() ->
    receive
        {From, do_a_flip} ->
            From ! "How about a no?",
            % NOTE to create recursion to be able to have a receive server
            % if not after one exec it would stop
            dolphin3();
        {From, fish} ->
            From ! "So long and thanks for all the fish!";
        _ ->
            io:format("Heh, we're smarter than you humans.~n"),
            dolphin3()
    end.

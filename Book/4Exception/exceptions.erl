-module(exceptions).
-compile(export_all).

% NOTE the name can be a string or an atom
% throw(error_name)
% erlang:error(error_name)
% exit(error_name)
throws(F) ->
    % NOTE any number of expressions can be put in the try _ of
    % NOTE 'of' can be omitted if you don't want to do anything if
    % everything is right (remove the _ -> ok)
    try F() of
        _ -> ok
    catch
        % NOTE Throw is not a special keyword,
        % it's just a variable to contain the error
        % This is because if not specified, throw is assumed as the error
        Throw -> {throw, caught, Throw}
    end.

errors(F) ->
    try F() of
        _ -> ok
    catch
        % NOTE here it needs to be specified that is an error
        % Still the Error is just the name of the variable
        error:Error -> {error, caught, Error}
    end.

exits(F) ->
    try F() of
        _ -> ok
    catch
        exit:Exit -> {exit, caught, Exit};
        _:_ -> "bla" % NOTE default branch
    end.

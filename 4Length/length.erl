-module(length).
-export([convert_meters/1]).

% Substituted at compile times with corresponding values
-define(YARD, 1.0936).
-define(INCH, 39.370).
-define(FOOT, 3.28).

% FIRST clause length:convert_meters({yard, _})
convert_meters({yard, Meters}) ->
    % NOTE the ;
    % Is used when defining multiple clauses for a function
    Meters * ?YARD;
% SECOND clause length:convert_meters({inch, _})
convert_meters({inch, Meters}) ->
    Meters * ?INCH;
% THIRD clause length:convert_meters({inch, _})
convert_meters({foot, Meters}) ->
    Meters * ?FOOT. % NOTE final clause

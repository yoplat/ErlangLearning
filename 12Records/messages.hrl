% NOTE to read in shell -> rr("message.hrl").
%
% to create message -> #message{sender = , receiver = ,} NOTE you can omit message atom
% to create message from another -> Message1#message{receiver="George"}.
%
% PATTERN MATCHING
% This assigns Sender from Message1
% #message{sender=Sender, receiver=Receiver, text=Text} = Message1.
%
% To extract only one arg
% Message1#message.text
%
% record(describer_atom, {args = default_value}) NOTE All lowercase
-record(message, {sender, receiver, text = ""}).

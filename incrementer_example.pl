
:- use_module(turing).

%-----------------------------------------------------------------------------%
% Sample Turing machines.
%-----------------------------------------------------------------------------%

% A tape with a string of 1 will have a 1 appended.
% Input tape: [1, 1, 1]
% Output tape: [1, 1, 1, 1]
% Uses the default configuration from the turing module.
incrementer(q0, 1, 1, right, q0).
incrementer(q0, b, 1, stay,  qf).

go :-
    
    turing(default_config, incrementer, [1, 1, 1], T1),
    write(T1), nl.

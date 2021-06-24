 /*                   Instituto Tecnologico de Costa Rica                 
            Proyecto Programado Lenguajes de programacion (IC4700)

Authors:Eric Alpizar.
        Jacob Picado.
        Natalia Vargas.

*/ 


:- use_module(turing).

%-----------------------------------------------------------------------------%
% Sample Turing Machine for the Universal Turing Machine.
%-----------------------------------------------------------------------------%

% A tape with a string of 1 will have a 1 appended.
% Input tape: [1, 1, 1]
% Output tape: [1, 1, 1, 1]
% Uses the default configuration from the turing module.

incrementer(q0, 1, 1, right, q0).
incrementer(q0, b, 1, stay,  qf).

go :-
    
    % The provided rules above are fed into the universal turing machine here

    turing(default_config, incrementer, [1, 1, 1], T1),

    % The result is written on T1 and its printed to console

    write(T1), nl.

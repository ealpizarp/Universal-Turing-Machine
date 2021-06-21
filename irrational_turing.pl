 /*                   Instituto Tecnologico de Costa Rica                 
            Proyecto Programado Lenguajes de programacion (IC4700)

Authors:Eric Alpizar.
        Jacob Picado.
        Natalia Vargas.

*/ 

:- use_module(turing).

% The config for the irrational turing sequence (001011011101111011111) is specified below

irrational_turing_paper(IS, FS, RS, B, S) :-

    % The initial state refers to the b states as specified in turings paper (1936)
    IS = b,

    % List of final states 
    FS = [h],

    % Running states of the irrational turing machine
    RS = [b,b1,b2,b3,b4,o,o1,o2,o3,q,q1,p,p1,f,h,f1, f2],

    % The blank space is specified here as the symbol b
    B = b,

    % List of valid symbols are listed below
    S = [e, x, 0, 1, b, h].


% The rules for the turing machine that generates an irrational number are specified here

irrational_turing(b, b, 0, right, b1).
irrational_turing(b1, b, 0, right, b2).
irrational_turing(b2, b, b, right, b3).
irrational_turing(b3, b, 0, left, b4).
irrational_turing(b4, b, b, left, o).


irrational_turing(o, 1, 1, right, o1).
irrational_turing(o1, b, 1, left, o2).

irrational_turing(o2, 1, 1, left, o3).
irrational_turing(o2, 0, 0, left, o3).

irrational_turing(o3, b, b, left, o).

irrational_turing(o, 0, 0, stay, q).


irrational_turing(q, 0, 0, right, q1).
irrational_turing(q, 1, 1, right, q1).

irrational_turing(q1, 1, 1, right, q).
irrational_turing(q1, b, b, right, q).

irrational_turing(q, b, 1, left, p).


irrational_turing(p, 1, b, right, q).
irrational_turing(p, b, b, left, p1).

irrational_turing(p1, 0, 0, left, p).
irrational_turing(p1, 1, 1, left, p).

irrational_turing(p, 0, 0, right, f).


irrational_turing(f, 0, 0, right, f1).
irrational_turing(f, 1, 1, right, f1).

irrational_turing(f1, b, b, right, f).

irrational_turing(f, b, 0, left, f2).
irrational_turing(f2, b, b, left, o).


irrational_turing(b, h, h, stay, h).
irrational_turing(b1, h, h, stay, h).
irrational_turing(b2, h, h, stay, h).
irrational_turing(b3, h, h, stay, h).
irrational_turing(b4, h, h, stay, h).
irrational_turing(o, h, h, stay, h).
irrational_turing(o1, h, h, stay, h).
irrational_turing(o2, h, h, stay, h).
irrational_turing(o3, h, h, stay, h).
irrational_turing(q, h, h, stay, h).

irrational_turing(q1, h, h, stay, h).
irrational_turing(p, h, h, stay, h).
irrational_turing(f, h, h, stay, h).
irrational_turing(f1, h, h, stay, h).
irrational_turing(f2, h, h, stay, h).

irrational_turing(p1, h, 0, stay, h).

irrational_turing(h, h, h, stay, h).


go :-
    turing(irrational_turing_paper, irrational_turing, 
        [b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,
        b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,
        b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,h], T1),
        
    write(T1), nl.
 /*                   Instituto Tecnologico de Costa Rica                 
            Proyecto Programado Lenguajes de programacion (IC4700)

Authors:Eric Alpizar.
        Jacob Picado.
        Natalia Vargas.


For this implementation we rely on the Turing module by Michael T. Richter

*/


:- module(turing, [turing/4,
                   default_config/5]).
:- meta_predicate turing(5, 5, +, -).

:- use_module(library(lists)).





/** <module> Turing machine simulation
 *
 * Simulate a universal turing machine.  To define a Turing machine, the caller
 * must supply two things: a machine configuration (c.f. default_config/5), and
 * a set of machine rules (c.f. rules/5). The file turing_test.pl (the name is
 * a joke, yes) contains two examples of Turing machines.
 *
 * This code is known to be compatible with SWI-Prolog and YAP Prolog.  Other
 * dialects may require alteration.
 *
 * @author    Michael T. Richter <ttmrichter@gmail.com>
 * @version   1.0.0
 * @copyright (c)2013 Michael T. Richter
 * @license   This program is free software. It comes without any warranty, to
 *            the extent permitted by applicable law. You can redistribute it
 *            and/or modify it under the terms of the Do What The Fuck You
 *            Want To Public License, Version 2, as published by Sam Hocevar.
 *            Consult http://www.wtfpl.net/txt/copying for more details.
 * @see       http://en.wikipedia.org/wiki/Turing_Machine#Formal_definition
 * 
*/




%% turing(Config, Rules, TapeIn, TapeOut)
%
% Excecutes a specified turing machine with the a set of rules (predicates)
% and the initial tape given in another file
%
% =TapeOut=.  Note that turing/4 is a meta-predicate and that =Parameters= and
% =Rules= are module-delimited as a result.
%
% @param Config  C.f. default_config/5.
% @param Rules   C.f. rule/5.
% @param TapeIn  A list of symbols representing the input tape.
% @param TapeOut A list of symbols representing the output tape.

turing(Config, Rules, TapeIn, TapeOut) :-

% the call predicate places the initial state given in the config 

    call(Config, IS, _, _, _, _),

% The recursion for exceuting the turing machine starts here with perform 

    perform(Config, Rules, IS, {[], TapeIn}, {Ls, Rs}),

% The output Tape is reversed due to prolog characteristics

    reverse(Ls, Ls1),

% The left list and right list are appended into a single tape out

    append(Ls1, Rs, TapeOut).







%% perform(Conf, Rules, State, TapeIn, TapeOut)
%
% Performs one step of the rules on the current state according to the current
% machine configuration.  Note that =TapeIn= and =TapeOut= are divided into
% pairs =|{Left, Right}|=.  The current symbol being read is the head of the
% =Right= side of the tape.
%
% Note also that the output tape is built up in reverse on the left side.  The
% final whole tape must be built of the reversed =Left= and the =Right=.
%
% @param Conf    C.f. default_config/5.
% @param Rules   C.f. rule/5.
% @param State   The current state of the machine.
% @param TapeIn  The input tape, divided into =|{Left, Right}|= sides.
% @param TapeOut The output tape, similarly divided.
%


perform(Config, Rules, State, TapeIn, TapeOut) :-
    call(Config, _, FS, RS, B, Symbols),
    ( memberchk(State, FS) ->
        % A stopping state has been reached.
        TapeOut = TapeIn

    ; memberchk(State, RS) ->
        {LeftIn, RightIn} = TapeIn,
        symbol(RightIn, Symbol, RightRem, B),

        % Checks if the symbol is valid, uses the symbols array provided by the config
        memberchk(Symbol, Symbols), 

        % Asks for a rule that has this set of parameters
        once(call(Rules, State, Symbol, NewSymbol, Action, NewState)),

        % Checks if the new symbol is valid
        memberchk(NewSymbol, Symbols),

        % Performs the action specified with the provided new symbol

        action(Action, {LeftIn, [NewSymbol|RightRem]}, {LeftOut, RightOut}, B),

        % The recursion continues

        perform(Config, Rules, NewState, {LeftOut, RightOut}, TapeOut) ).







%% symbol(Rin, Symbol, Rout, Blank)
%
% Extracts the current symbol from the right side of the input tape.  Going
% past the right generates blank symbols.  Since blank symbols are
% configurable, the blank symbol is passed in.
%
% @param Rin    The right side of the tape.
% @param Symbol The symbol the head is over.
% @param Rout   The right side of the tape after the symbol is removed.
% @param Blank  The symbol used for a blank square.

symbol([],       B,   [], B).
symbol([Sym|Rs], Sym, Rs, _).






%% action(Action, TapeIn, TapeOut, Blank)
%
% Performs one of the following three legal actions: move the tape forward
% (=left=), keep the tape in place (=stay=), and move the tape backward
% (=right=).
%
% @param Action  The action to perform: one of =left=, =right=, or =stay=.
% @param TapeIn  The input tape, split into ={Left, Right}= components.
% @param TapeOut The output tape, similarly split.
% @param Blank   The symbol to be interpreted as a blank.


action(left,  {Lin, Rin},  {Lout, Rout}, B) :- left(Lin, Rin, Lout, Rout, B).
action(stay,  Tape,        Tape,         _).
action(right, {Lin, Rin},  {Lout, Rout}, B) :- right(Lin, Rin, Lout, Rout, B).





%% left(Lin, Rin, Lout, Rout, Blank)
%
% Helper predicate for action/4.  Going past the left generates blank symbols.
% Because of some problems with indexing, to keep this deterministic the tape
% tuples (=|{Left, Right}|=) had to be broken out.
%
% @param Lin   Left side of the tape input.
% @param Rin   Right side of the tape input.
% @param Lout  Left side of the tape output.
% @param Rout  Right side of the tape output.
% @param Blank The configured blank character.
%
left([],     Rs, [], [B|Rs], B).
left([L|Ls], Rs, Ls, [L|Rs], _).







%% right(Lin, Rin, Lout, Rout, Blank)
%
% Helper predicate for action/4.  Going past the right generates blank symbols.
% Because of some problems with indexing, to keep this deterministic the tape
% tuples (=|{Left, Right}|=) had to be broken out.
%
% @param Lin   Left side of the tape input.
% @param Rin   Right side of the tape input.
% @param Lout  Left side of the tape output.
% @param Rout  Right side of the tape output.
% @param Blank The configured blank character.
%
right(L, [],     [B|L], [], B).
right(L, [S|Rs], [S|L], Rs, _).







%% rule(StateIn, SymbolIn, StateOut, SymbolOut, Action).
%
% A machine is specified by a collection of rule/5 predicates using this
% footprint.  The name of a given machine's rules is passed in to the turing/3
% call.  The file turing_test.pl illustrates some sample turing machines and
% how they are called.
%
% Note that this is a model of how rules should be coded, not a predicate
% that's intended for use.
%
% @param StateIn   The name of the current state of the machine.
% @param SymbolIn  The symbol currently at the machine's head.
% @param StateOut  The state the machine should move to after this rule is
%                  executed.
% @param SymbolOut The symbol that should be placed on the tape after this rule
%                  is executed.
% @param Action    The action (right, left, stay) to be performed based on this
%                  rule
%

rule(_, _, _, _, _).








%% default_config(IState, FStates, RStates, Blank, Symbols) is det.
%
% These are the default parameters for a Turing machine used mainly as a means
% of demonstrating the making of a custom machine.  The params call provides
% the legal states and symbols for use in the Turing machine.  The Turing
% engine enforces state names and symbols as a strict subset of those provided.
%
% Note that this is a model of how a machine configuration should be coded.  It
% *may* be called, but in reality is not very useful a setup.
%
% @param IState  The initial state of the machine when starting.
% @param FStates A list of the terminating states of the machine.
% @param RStates A list of the running states of the machine (*|must include the
%                initial state|*).
% @param Blank   The blank symbol.
% @param Symbols The complete list of legal tape symbols (*|must include the
%                blank symbol|*).
%
default_config(IState, FStates, RStates, Blank, Symbols) :-
    IState  = q0,
    FStates = [qf],
    RStates = [IState],
    Blank   = b,
    Symbols = [Blank, 0, 1].
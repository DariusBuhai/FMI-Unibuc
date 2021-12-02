
plus(0, X, X).
:- discontiguous plus/3.


minus(X, Y, Z) :-
    plus(Y, Z, X).

%!  mul(?X, ?Y, ?Z)

mul(0, _, 0).
mul(s(X), Y, Z) :-
    mul(X, Y, Z1),
    plus(Y, Z1, Z).


plus(X, s(X)).

plus(s(Y), X, s(Z)) :- plus(Y, X, Z).

adevarat.

fals :- \+ adevarat.
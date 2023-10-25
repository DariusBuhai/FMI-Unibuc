
plus(0, X, X).
plus(s(Y), X, s(Z)) :- plus(Y, X, Z).

:- discontiguous plus/3.


minus(X, Y, Z) :-
    plus(Z, Y, X).

%!  mul(?X, ?Y, ?Z)

mul(0, _, 0).
mul(s(X), Y, Z) :-
    mul(X, Y, Z1),
    plus(Y, Z1, Z).


plus(X, s(X)).

adevarat.

fals :- \+ adevarat.
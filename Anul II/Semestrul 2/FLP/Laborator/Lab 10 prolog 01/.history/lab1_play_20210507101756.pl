plus(0, X, X).
plus(s(Y), X, s(Z)) :- plus(Y, X, Z).

mul(0, _, 0).
mul(s(X), Y, Z) :-
    mul(X, Y, Z1)

plus(0, X, X).
plus(s(Y), X, s(Z)) :- plus(Y, X, Z).

minus(X, Y, Z) :-
    plus()

%!  mul(?X, ?Y, ?Z)

mul(0, _, 0).
mul(s(X), Y, Z) :-
    mul(X, Y, Z1),
    plus(Y, Z1, Z).
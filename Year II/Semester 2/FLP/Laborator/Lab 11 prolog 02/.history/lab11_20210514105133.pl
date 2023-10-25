plus(0, X, X).
plus(s(Y), X, s(Z)) :- plus(Y, X, Z).

:- a(a, a(1)) == a(a, a(1)).
:- a(a, a(1)) == _X.

:- a(a, a(1)) = X, write(X).
:- a(a, a(1)) = a(X), write(X).  % failing
:- a(a, a(1)) = a(X, Y), write(X), nl, write(Y).  % works

eq(A, B) :-   % =:=
    X is A,
    Y is B,
    X == Y.

cauta(X + A, Y) :- integer(A), X is Y - A.
cauta(X + A, Y) :- integer(X), A is Y - X.
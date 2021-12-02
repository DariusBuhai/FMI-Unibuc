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

intexp(I) :- integer(I).
intexp(A + B) :- intexp(A), intexp(B).

cauta(X, X) :- integer(X).
cauta(X + A, Y) :- integer(A), X1 is Y - A, cauta(X, X1).
cauta(X + A, Y) :- integer(X), A1 is Y - X, cauta(A, A1).
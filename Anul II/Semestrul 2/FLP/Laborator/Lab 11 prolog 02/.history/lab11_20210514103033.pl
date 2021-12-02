plus(0, X, X).
plus(s(Y), X, s(Z)) :- plus(Y, X, Z).

:- a(a, a(1)) == a(a, a(1)).
:- a(a, a(1)) == _X.

:- a(a, a(1)) = X.
:- a(a, a(1)) = a(X).  % failing
:- a(a, a(1)) = a(X, Y).  % works

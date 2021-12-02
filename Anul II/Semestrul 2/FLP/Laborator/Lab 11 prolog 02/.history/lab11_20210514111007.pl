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
intexp(A) :- var(A), !, fail.
intexp(A + B) :- intexp(A), intexp(B).

cauta(X, X) :- integer(X).
cauta(X + A, Y) :- intexp(A), X1 is Y - A, cauta(X, X1).
cauta(A + X, Y) :- intexp(A), X1 is Y - A, cauta(X, X1).

%merge(L1,L2, L)

merge([],L2, L2).
merge(L1, [], L1).
merge([H1|T1], [H2|T2], [H1|T]) :-
    H1 < H2,
    merge(T1, [H2|T2], T).
merge([H1|T1], [H2|T2], [H2|T]) :-
    H1 >= H2,
    merge([H1|T1], T2, T).

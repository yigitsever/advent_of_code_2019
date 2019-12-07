%353096-843212
digit(X) :- X = 0..9.
place(N) :- N = 1..6.

1 {pass(Q,X) : digit(X)} 1 :- place(Q).
value(N) :- N = A + B * 10 + C * 100 + D * 1000 + E * 10000 + F * 100000, pass(6,A), pass(5,B), pass(4,C), pass(3,D), pass(2,E), pass(1,F).

:- value(N), N < 353096.
:- value(N), N > 843212.

:- pass(Q,X), pass(Q', Y), Q' = Q + 1, X > Y.
%:- pass(Q,X), pass(Q', Y), pass(QQ, Z), Q' = Q + 1, QQ = Q' + 1, X = Y, Y = Z. % I couldn't figure out this so I did 581 - 2

%1 {target(X,Y,XX,YY) : dir(DX,DY), XX-X = DX*S, YY-Y = DY*S, size(S), area(XX,YY,_)} 1 :- number(X,Y,_).

#show pass/2.
#show value/1.

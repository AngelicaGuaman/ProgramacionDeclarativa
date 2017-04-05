%Angélica Guamán Albarracín
%t110212

:-module(_,_).

%OFICIALES DE ELECTRICIDAD
oficiales(juan, electricidad).
oficiales(jorge, electricidad).
oficiales(cristian, electricidad).
oficiales(kiko, electricidad).
oficiales(justo, electricidad).

%OFICIALES DE ALBANILERIA
oficiales(pablo, albanileria).
oficiales(cristian, albanileria).
oficiales(guillermo, albanileria).
oficiales(david, albanileria).

%OFICIALES DE FONTANERIA
oficiales(david, fontaneria).
oficiales(ruben, fontaneria).
oficiales(carlos, fontaneria).

%OFICIALES DE COORDINACION
oficiales(juan, coordinacion).
oficiales(pablo, coordinacion).
oficiales(justo, coordinacion).
oficiales(miguel, coordinacion).

%AFICIONES
aficion(juan, yoga).
aficion(pablo, yoga).
aficion(jorge, yoga).
aficion(kiko, toros).
aficion(ruben, futbol).
aficion(ruben, yoga).
aficion(carlos, toros).
aficion(miguel, yoga).
aficion(miguel, toros).
aficion(justo, yoga).
aficion(justo, futbol).
aficion(guillermo, futbol).
aficion(cristian, futbol).
aficion(david, futbol).
aficion(david,yoga).

% Genera todas las permutaciones de una lista
%funcion determinista
%prolog da todas las soluciones posibles...

permutacion([],[]):-!. 
permutacion(Xs,[Z|Zs]):-
	desarma(Z,Xs,Ys),
	permutacion(Ys,Zs). 

desarma(X,[X|Xs],Xs).
desarma(X,[Y|Ys],[Y|Zs]):-
	desarma(X,Ys,Zs). 

%para buscar 
parte_de(_X,[_X|_Y]).
parte_de(X,[_C|Y]):-
	parte_de(X,Y). 

%GRUPO DE OFICIALES
grupo_de_oficiales(L):-
	grupo_de_oficiales(L,_).

grupo_de_oficiales([X,Y,Z],[X:coordinacion,X:A,Y:B,Z:C]):-
	oficiales(X,coordinacion),
	oficiales(X,A),
	oficiales(Y,B),
	Y\=X,
	oficiales(Z,C),
	Z\=Y, Z\=X, %para las personas repetidas
	permutacion([A,B,C],[fontaneria,electricidad,albanileria]).

grupo_de_oficiales([X,Y,Z,T],[X:A,Y:B,Z:C,T:D]):-
	oficiales(X,A),
	oficiales(Y,B),
	Y\=X, %para los predicados logicos \=, = , unifica con, no unifica con
	oficiales(Z,C),
	Z\=Y, Z\=X,
	oficiales(T,D),
	T\=X, T\=Y, T\=Z,
	permutacion([A,B,C,D],[coordinacion,fontaneria,electricidad,albanileria]).
	
buen_ambiente(L):-
	buen_ambiente(L,_).

buen_ambiente([X,Y,Z]):-
	aficion_mayoritaria([X,Y,Z],yoga);
	aficion(X,A), aficion(Y,A),aficion(Z,A),
	grupo_de_oficiales([X,Y,Z]).
	
buen_ambiente([X,Y,Z,T]):-
	aficion_mayoritaria([X,Y,Z,T],yoga);
	aficion(X,A), aficion(Y,A),aficion(Z,A), aficion(T,A), grupo_de_oficiales([X,Y,Z,T]).

buen_ambiente([X,Y,Z], L):-
	desarma(X,L,L1),
	desarma(Y,L1,L2),
	desarma(Z,L2,L3), 
	aficion_mayoritaria([X,Y,Z],yoga);
	aficion(X,A), aficion(Y,A),aficion(Z,A),
	grupo_de_oficiales([X,Y,Z]).

buen_ambiente([X,Y,Z,T], L):-
	desarma(X,L,L1),
	desarma(Y,L1,L2),
	desarma(Z,L2,L3),
	desarma(T,L3,L4),
	aficion_mayoritaria([X,Y,Z,T],yoga);
	aficion(X,A), aficion(Y,A),aficion(Z,A), aficion(T,A), grupo_de_oficiales([X,Y,Z,T]).

aficion_mayoritaria([X,Y,Z], A):-
	aficion(X,A), aficion(Y,A), Y\=X, X\=Z, Y\=Z;
	aficion(X,A), aficion(Z,A), Z\=X, X\=Y, Z\=Y;
	aficion(Y,A), aficion(Z,A),
	grupo_de_oficiales([X,Y,Z]).

aficion_mayoritaria([X,Y,Z,T], A):-
	aficion(X,A), aficion(Y,A), aficion(Z,A), Y\=X, Z\=Y, Z\=X, T\=X, T\=Y, T\=Z;
	aficion(X,A), aficion(Y,A), aficion(T,A), Y\=X, T\=Y, T\=X, Z\=X, Z\=Y, Z\=T;
	aficion(X,A), aficion(Z,A), aficion(T,A),
	grupo_de_oficiales([X,Y,Z,T]).

grupo_de_excelencia(L):-
	grupo_de_excelencia(L_).
	
%para ser un grupo de excelencia, en un grupo de oficiales debe de aparecer justo o juan
grupo_de_excelencia(L):-
	grupo_de_oficiales(L),
	parte_de(juan,L);
	parte_de(justo,L).

grupo_de_excelencia([X,Y,Z],L):-
	desarma(X,L,L1),
	desarma(Y,L1,L2),
	desarma(Z,L2,L3),
	grupo_de_oficiales([X,Y,Z]),
	parte_de(juan,[X,Y,Z]);
	parte_de(justo,[X,Y,Z]).

grupo_de_excelencia([X,Y,Z,T],L):-
	desarma(X,L,L1),
	desarma(Y,L1,L2),
	desarma(Z,L2,L3),
	desarma(T,L3,L4),
	grupo_de_oficiales([X,Y,Z,T]),
	parte_de(juan,[X,Y,Z,T]);
	parte_de(justo,[X,Y,Z,T]).







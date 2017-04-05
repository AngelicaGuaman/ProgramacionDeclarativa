%Practica 2 de PDLR 
%Autores: 
%Angélica Guamán Albarracin T110212
%Mónica Zori Martín N060119
%Carlos Prado Ventura R090058 
%Carlos Soriano Soriano Q080037


module(_,_).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% PREDICADO abrir/4 %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% abrir(Estado_Inicial, Estado_Final, Movimientos_Automaticos, Solucion)

%%% Estado_Inicial -> predicado palancas/n origen
%%% Estado_Final -> predicado palancas/n final
%%% Movimientos_Automaticos -> LISTA formato [X1-[X2,X3,X4...]] o vacia[]
%%% Solucion -> LISTA movimientos a seguir

abrir(Estado,Estado,Movimientos_Automaticos,[]):-!.
abrir(Estado_Inicial,Estado_Final,Movimientos_Automaticos,Solucion):-
	abrir(Estado_Inicial,Estado_Final,Movimientos_Automaticos,[Estado_Inicial],Solucion).

%Para llegar a la Solución nos apoyamos en el predicado abrir/5, este tiene un nuevo argumento que es una
%lista donde guarda todos los estados visitados para ir descartando posible palancas.
abrir(Estado,Estado,Movimientos_Automaticos,Visitados,[]):-!.
abrir(Estado_Inicial,Estado_Final,Movimientos_Automaticos,Visitados,[Elegido|Solucion]):-
	%comprobamos si Estado_Inicial y Estado_Final son el mismo predicado y tienen la misma aridad
	functor(Estado_Inicial,P1,Aridad), 
	functor(Estado_Final,P2,Aridad2),
	P1=palancas,
	P2=palancas,
	Aridad =:= Aridad2, %(Chequeo Basico: mismo predicado y misma cantidad de elementos) 
	functor(Estado_Actual,P1,Aridad),  %creamos una nueva estructura sin instanciar.
	generarLista(Aridad,Lista),%genero una lista con todas las palancas
	desarma(Elegido,Lista,Lista2), %Lista2 es la lista modificada = Lista-Elegido
	automatico(Elegido,Movimientos_Automaticos,Movimientos), %nos devuelve todos los movimientos que hay que hacer
	rellenaEstado(Estado_Inicial,Aridad,Movimientos,Estado_Actual),
	\+ member(Estado_Actual,Visitados),
	% si pasa esta condicion anterior, pasamos de el estado, aÃ±adiendo el estado a visited
	abrir(Estado_Actual,Estado_Final,Movimientos_Automaticos,[Estado_Actual|Visitados],Solucion).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% OTROS PREDICADOS %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CAMBIA POSICION DE PALANCAS
mover_palanca(on,off).
mover_palanca(off,on).

%En este predicado vamos a ir cambiando las palancas de estado, solo se
%cambian las palancas que se indiquen en Posiciones.
rellenaEstado(EstadoI,0,Posiciones,EstadoF). %Termina
rellenaEstado(EstadoI,Indice,Posiciones,EstadoF):-
	Indice >= 1,
	AridadN is Indice - 1,
	member(Indice,Posiciones),%si la posicion actual pertenece a las posiciones:
	arg(Indice,EstadoI,ElementoI),
	mover_palanca(ElementoI,Opuesto),
	arg(Indice,EstadoF,Opuesto),
	rellenaEstado(EstadoI,AridadN,Posiciones,EstadoF).
	
%Las palancas que no aparezcan el Posiciones se agregan tal cual, el estado que tiene
%EstadoI
rellenaEstado(EstadoI,Indice,Posiciones,EstadoF):-
	Indice >= 1,
	AridadN is Indice - 1,
	%Si no pertenece la posicion actual a las posiciones
	\+ member(Indice,Posiciones),
	%copia el anterior estado:
	arg(Indice,EstadoI,ElementoI),
	arg(Indice,EstadoF,ElementoI),
	rellenaEstado(EstadoI,AridadN,Posiciones,EstadoF).

% E-L|Xs --> palanca en lista de acciones (busqueda)
%Nos devuelve una lista con todas la palancas que hay que realizar los cambios de estado
automatico(Palanca,[],[Palanca]).
automatico(P,[P-L|Xs],[P|L]):-!.
automatico(Palanca,[P-L|Xs],Lista):-
	automatico(Palanca,Xs,Lista).

%vamos cogiendo una palanca, y esa palanca elegida la quitamos de la lista
%Nos devuelve una lista2=Lista-elegido
%X -> palanca Elegida
%[X|Xs] lista a la que voy a quitar X 
desarma(X,[X|Xs],Xs).
desarma(X,[Y|Ys],[Y|Zs]):-
	desarma(X,Ys,Zs).

%Nos genera una lista desde el 1 hasta aridad
%que son el número de palancas que tiene la estructura.
generarLista(0,[]).
generarLista(Aridad,[Aridad|Lista]):-
	Num is Aridad - 1,
	Aridad >= 1,
	generarLista(Num, Lista).
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% CASOS DE EJEMPLO %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% abrir(palancas(on,on,on),palancas(on,on,on),[], Solucion).
%	
% abrir(palancas(on,on,on), palancas(off,off,off),[],Solucion).
%
% abrir(palancas(on,on,on), palancas(off,off,off), [1-[2,3],2-[1,3],3-[2,1]],Solucion).
%
% abrir(palancas(on,on,on,on,on,on),palancas(off,off,off,off,off,off),[1-[3,4],6-[3,4],2-[4,5],3-[1,6],5-[2,4],4-[1,2,6,3]],Solucion).
% 	Solucion = [6,5,6,4,6,5,6,3,6,5,6,4] ? ;
% 	Solucion = [6,5,6,4,6,5,6,3,6,5,6,1,6,5,6,4,6,5,6,1] ? ;
% 	Solucion = [6,5,6,4,6,5,6,3,6,5,6,1,6,5,6,4,6,5,3,6,3,1] ? ;
% 	Solucion = [6,5,6,4,6,5,6,3,6,5,6,1,6,5,6,4,6,5,3,5,6,5,3,1] ? ;
% 	Solucion = [6,5,6,4,6,5,6,3,6,5,6,1,6,5,6,4,6,5,3,5,6,4,6,5,6,4,3,1] ?
%		Solucion = [5,3] ? ;
%		Solucion = [3,5] ? ;
%		Solucion = [3,2] ? ;
%		Solucion = [2,3] ? ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
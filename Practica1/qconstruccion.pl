%¿Qué grupos de oficiales en los que reine un buen ambiente pueden formarse con Juan
%como uno de sus miembros?

buen_ambiente(X), parte_de(juan,X).

%¿Qué grupos de excelencia en los que reine un buen ambiente pueden formarse con
%los profesionales disponible?

buen_ambiente(L,G), grupo_de_excelencia(L).

%¿Hay algún grupo de excelencia que incluya a Miguel?, Sí

grupo_de_excelencia(L), parte_de(miguel,L).

%¿Qué grupos de oficiales formados por 4 miembros en los que reina un buen ambiente
%pueden reducirse a grupo de oficiales de 3 miembros de tal manera que siga reinando
%un buen ambiente?

grupo_de_oficiales([X,Y,Z,T]), buen_ambiente([X,Y,Z,T]), grupo_de_oficiales([X,Y,Z]), buen_ambiente([X,Y,Z]).

%Formular 4 preguntas más (y su traducción a Prolog) que muestre la flexibilidad de
%los predicados definidos en el apartado 1. Tratad de ser creativos y formulad
%preguntas complejas (similares a la anterior).

%Mostrar un grupo de oficiales de tamaño cuatro que tengan buen ambiente y que su aficion mayoritaria sea el futbol
buen_ambiente([X,Y,Z,T],L), aficion_mayoritaria([X,Y,Z,T],futbol).

%Mostrar
grupo_de_excelencia([X,Y,Z],L), buen_ambiente([X,Y,Z]), parte_de(guillermo,[X,Y,Z]).





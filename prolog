
% ---------- Dominios (fatos) ----------
mochila(amarela).
mochila(azul).
mochila(branca).
mochila(verde).
mochila(vermelha).

nome(denis).
nome(joao).
nome(lenin).
nome(otavio).
nome(will).

mes(agosto).
mes(dezembro).
mes(janeiro).
mes(maio).
mes(setembro).

jogo(tres_ou_mais).
jogo(caca_palavras).
jogo(cubo_vermelho).
jogo(jogo_da_forca).
jogo(prob_de_logica).

materia(biologia).
materia(geografia).
materia(historia).
materia(matematica).
materia(portugues).

suco(laranja).
suco(limao).
suco(maracuja).
suco(morango).
suco(uva).

% ---------- Predicado principal ----------
main :-
    statistics(cputime, T1),
    (   modelo(Solucao),
        nl, write('=== Solucao encontrada ==='), nl,
        imprime_lista(Solucao),
        fail
    ;   true
    ),
    statistics(cputime, T2),
    T is T2 - T1,
    nl, write('Tempo de CPU (segundos): '), write(T), nl,
    write('Busca terminada.'), nl.

% ---------- Modelo ----------
modelo(Solucao) :-
    Solucao = [
        menino(M1, N1, Mes1, J1, Mat1, S1),
        menino(M2, N2, Mes2, J2, Mat2, S2),
        menino(M3, N3, Mes3, J3, Mat3, S3),
        menino(M4, N4, Mes4, J4, Mat4, S4),
        menino(M5, N5, Mes5, J5, Mat5, S5)
    ],
    Mochilas = [M1, M2, M3, M4, M5],
    Nomes    = [N1, N2, N3, N4, N5],
    Meses    = [Mes1, Mes2, Mes3, Mes4, Mes5],
    Jogos    = [J1, J2, J3, J4, J5],
    Materias = [Mat1, Mat2, Mat3, Mat4, Mat5],
    Sucos    = [S1, S2, S3, S4, S5],

    % Restricoes fixas imediatas
    S1 = limao,             % 19
    S3 = morango,           % 6
    J3 = jogo_da_forca,     % 23
    N5 = lenin,             % 21

    % Sucos
    lista_valores(suco, LSucos),
    valores_distintos(LSucos, Sucos),

    % Materias
    lista_valores(materia, LMaterias),
    valores_distintos(LMaterias, Materias),

    % 12: Biologia -> Morango
    mesma_posicao(biologia, Materias, morango, Sucos),
    % 20: Matematica -> Maracuja
    mesma_posicao(matematica, Materias, maracuja, Sucos),
    % 14: Uva exatamente a esquerda de Portugues
    posicao(uva, Sucos, PUva),
    posicao(portugues, Materias, PPort),
    PPort is PUva + 1,

    % Jogos
    lista_valores(jogo, LJogos),
    valores_distintos(LJogos, Jogos),

    % 7: Uva -> Problemas de Logica
    mesma_posicao(uva, Sucos, prob_de_logica, Jogos),
    % 8: Forca ao lado de 3 ou Mais
    posicao(jogo_da_forca, Jogos, PForca),
    posicao(tres_ou_mais, Jogos, PTres),
    ao_lado(PForca, PTres),
    % 10: Cubo Vermelho em uma ponta
    posicao(cubo_vermelho, Jogos, PCubo),
    ponta(PCubo),

    % Mochilas
    lista_valores(mochila, LMochilas),
    valores_distintos(LMochilas, Mochilas),

    % 11: Forca ao lado da mochila Vermelha
    posicao(jogo_da_forca, Jogos, PForca2),
    posicao(vermelha, Mochilas, PVermelha),
    ao_lado(PForca2, PVermelha),
    % 16: Problemas de Logica ao lado da mochila Amarela
    posicao(prob_de_logica, Jogos, PProb),
    posicao(amarela, Mochilas, PAmarela),
    ao_lado(PProb, PAmarela),
    % 9: Uva a direita da mochila Azul
    posicao(uva, Sucos, PUva2),
    posicao(azul, Mochilas, PAzul),
    PUva2 > PAzul,

    % Nomes
    lista_valores(nome, LNomes),
    valores_distintos(LNomes, Nomes),

    % 2: Joao -> Historia
    mesma_posicao(joao, Nomes, historia, Materias),
    % 4: Will ao lado de Problemas de Logica
    posicao(will, Nomes, PWill),
    posicao(prob_de_logica, Jogos, PProb2),
    ao_lado(PWill, PProb2),
    % 5: Branca exatamente a esquerda de Will
    posicao(branca, Mochilas, PBranca),
    posicao(will, Nomes, PWill2),
    PWill2 is PBranca + 1,
    % 22: Otavio em uma ponta
    posicao(otavio, Nomes, POtavio),
    ponta(POtavio),

    % Meses
    lista_valores(mes, LMeses),
    valores_distintos(LMeses, Meses),

    % 15: Matematica -> Dezembro
    mesma_posicao(matematica, Materias, dezembro, Meses),
    % 17: Azul -> Janeiro
    mesma_posicao(azul, Mochilas, janeiro, Meses),
    % 3: Azul a esquerda de Maio
    posicao(azul, Mochilas, PAzul2),
    posicao(maio, Meses, PMaio),
    PAzul2 < PMaio,
    % 1: Setembro ao lado de Laranja
    posicao(setembro, Meses, PSet),
    posicao(laranja, Sucos, PLaranja),
    ao_lado(PSet, PLaranja),
    % 13: Janeiro ao lado de Setembro
    posicao(janeiro, Meses, PJan),
    posicao(setembro, Meses, PSet2),
    ao_lado(PJan, PSet2),
    % 18: Setembro ao lado de Cubo Vermelho
    posicao(setembro, Meses, PSet3),
    posicao(cubo_vermelho, Jogos, PCubo2),
    ao_lado(PSet3, PCubo2).

% ---------- Auxiliares para listar valores ----------
lista_valores(mochila, L) :- findall(X, mochila(X), L).
lista_valores(nome, L)    :- findall(X, nome(X), L).
lista_valores(mes, L)     :- findall(X, mes(X), L).
lista_valores(jogo, L)    :- findall(X, jogo(X), L).
lista_valores(materia, L) :- findall(X, materia(X), L).
lista_valores(suco, L)    :- findall(X, suco(X), L).

% ---------- Geracao de listas com valores distintos ----------
valores_distintos(Valores, Lista) :-
    permutacao(Valores, Lista),
    alldifferent(Lista).

% alldifferent sem bibliotecas externas
alldifferent([]).
alldifferent([H|T]) :-
    \+ membro(H, T),
    alldifferent(T).

membro(X, [X|_]).
membro(X, [_|T]) :- membro(X, T).

% permutacao sem bibliotecas externas
permutacao([], []).
permutacao(Valores, [X|Resto]) :-
    selecionar(X, Valores, ValoresRestantes),
    permutacao(ValoresRestantes, Resto).

selecionar(X, [X|T], T).
selecionar(X, [H|T], [H|R]) :-
    selecionar(X, T, R).

% posicao de um valor em uma lista de 5 posicoes
posicao(X, Lista, Pos) :-
    posicao_aux(X, Lista, 1, Pos).

posicao_aux(X, [X|_], Pos, Pos) :- !.
posicao_aux(X, [_|T], Pos0, Pos) :-
    Pos1 is Pos0 + 1,
    posicao_aux(X, T, Pos1, Pos).

% posicoes vizinhas
ao_lado(P1, P2) :-
    (   P1 =:= P2 + 1
    ->  true
    ;   P1 =:= P2 - 1
    ).

% posicoes 1 ou 5
ponta(1).
ponta(5).

% mesma posicao para dois valores em listas diferentes
mesma_posicao(X, ListaX, Y, ListaY) :-
    posicao(X, ListaX, P),
    posicao(Y, ListaY, P).

% ---------- Impressao ----------
imprime_lista(Lista) :-
    imprime_lista(Lista, 1).

imprime_lista([], _) :-
    write('FIM do imprime_lista'), nl.

imprime_lista([menino(Mochila, Nome, Mes, Jogo, Materia, Suco)|T], I) :-
    nl,
    write('Menino #'), write(I), nl,
    write('Mochila : '), write(Mochila), nl,
    write('Nome    : '), write(Nome), nl,
    write('Mes     : '), write(Mes), nl,
    write('Jogo    : '), write(Jogo), nl,
    write('Materia : '), write(Materia), nl,
    write('Suco    : '), write(Suco), nl,
    I1 is I + 1,
    imprime_lista(T, I1).

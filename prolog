% =========================================================================
% DOMÍNIOS (FATOS)
% =========================================================================
mochila(amarela). mochila(azul). mochila(branca). mochila(verde). mochila(vermelha).
nome(denis). nome(joao). nome(lenin). nome(otavio). nome(will).
mes(agosto). mes(dezembro). mes(janeiro). mes(maio). mes(setembro).
jogo(tres_ou_mais). jogo(caca_palavras). jogo(cubo_vermelho). jogo(jogo_da_forca). jogo(prob_de_logica).
materia(biologia). materia(geografia). materia(historia). materia(matematica). materia(portugues).
suco(laranja). suco(limao). suco(maracuja). suco(morango). suco(uva).

% =========================================================================
% PREDICADO PRINCIPAL (MAIN)
% =========================================================================
main :-
    statistics(cputime, T1),
    (   modelo(Solucao),
        nl, write('=== Solucao encontrada ==='), nl,
        imprime_lista(Solucao),
        fail % Forca o backtracking para buscar todas as solucoes
    ;   true
    ),
    statistics(cputime, T2),
    T is T2 - T1,
    nl, write('Tempo de CPU (segundos): '), write(T), nl,
    write('Busca terminada.'), nl.

% =========================================================================
% MODELO (ESTRUTURA E RESTRICOES)
% =========================================================================
modelo(Solucao) :-
    % 1. Estrutura da Solucao (5 meninos com 6 atributos cada)
    Solucao = [
        menino(M1, N1, Mes1, J1, Mat1, S1),
        menino(M2, N2, Mes2, J2, Mat2, S2),
        menino(M3, N3, Mes3, J3, Mat3, S3),
        menino(M4, N4, Mes4, J4, Mat4, S4),
        menino(M5, N5, Mes5, J5, Mat5, S5)
    ],
    
    % Listas para facilitar a manipulacao das posicoes
    Mochilas = [M1, M2, M3, M4, M5],
    Nomes    = [N1, N2, N3, N4, N5],
    Meses    = [Mes1, Mes2, Mes3, Mes4, Mes5],
    Jogos    = [J1, J2, J3, J4, J5],
    Materias = [Mat1, Mat2, Mat3, Mat4, Mat5],
    Sucos    = [S1, S2, S3, S4, S5],

    % 2. Geracao de Dominios com alldifferent (Reduz espaco de busca)
    preenche_lista(Mochilas, mochila), alldifferent(Mochilas),
    preenche_lista(Nomes, nome),       alldifferent(Nomes),
    preenche_lista(Meses, mes),        alldifferent(Meses),
    preenche_lista(Jogos, jogo),       alldifferent(Jogos),
    preenche_lista(Materias, materia), alldifferent(Materias),
    preenche_lista(Sucos, suco),       alldifferent(Sucos),

    % -------------------------------------------------------------------------
    % 3. RESTRICOES (Ordenadas da mais restritiva para a menos restritiva)
    % -------------------------------------------------------------------------

    % A. Posicoes Fixas Imediatas (Eliminam muitas possibilidades logo de inicio)
    S1 = limao,                 % 19. Na primeira posicao esta quem gosta de Limao
    S3 = morango,               % 6. Na terceira posicao esta quem gosta de Morango
    J3 = jogo_da_forca,         % 23. Na terceira posicao esta o menino que gosta da Forca
    N5 = lenin,                 % 21. Lenin esta na quinta posicao

    % B. Equivalencias Diretas (Mesma Posicao)
    mesma_posicao(biologia, Materias, morango, Sucos),       % 12. Biologia -> Morango
    mesma_posicao(matematica, Materias, maracuja, Sucos),    % 20. Matematica -> Maracuja
    mesma_posicao(matematica, Materias, dezembro, Meses),    % 15. Matematica -> Dezembro
    mesma_posicao(azul, Mochilas, janeiro, Meses),           % 17. Azul -> Janeiro
    mesma_posicao(uva, Sucos, prob_de_logica, Jogos),        % 7. Uva -> Prob. de Logica
    mesma_posicao(joao, Nomes, historia, Materias),          % 2. Joao -> Historia

    % C. Posicoes Exatas (Exatamente a esquerda)
    exatamente_a_esquerda(branca, Mochilas, will, Nomes),    % 5. Branca ex. esq. de Will
    exatamente_a_esquerda(uva, Sucos, portugues, Materias),  % 14. Uva ex. esq. de Portugues

    % D. Pontas e Extremidades
    posicao(otavio, Nomes, POtavio), ponta(POtavio),         % 22. Otavio em uma das pontas
    posicao(cubo_vermelho, Jogos, PCubo), ponta(PCubo),      % 10. Cubo Vermelho em uma ponta

    % E. Restrições de Vizinhanca (Ao lado)
    ao_lado(will, Nomes, prob_de_logica, Jogos),             % 4. Will ao lado de Prob. Logica
    ao_lado(jogo_da_forca, Jogos, tres_ou_mais, Jogos),      % 8. Forca ao lado de 3 ou Mais
    ao_lado(jogo_da_forca, Jogos, vermelha, Mochilas),       % 11. Forca ao lado da Vermelha
    ao_lado(prob_de_logica, Jogos, amarela, Mochilas),       % 16. Prob. Logica ao lado da Amarela
    ao_lado(setembro, Meses, laranja, Sucos),                % 1. Setembro ao lado de Laranja
    ao_lado(janeiro, Meses, setembro, Meses),                % 13. Janeiro ao lado de Setembro
    ao_lado(setembro, Meses, cubo_vermelho, Jogos),          % 18. Setembro ao lado do Cubo Vermelho

    % F. Restrições Relativas (Em algum lugar a esquerda/direita)
    a_esquerda_de(azul, Mochilas, maio, Meses),              % 3. Azul em algum lugar a esq. de Maio
    a_direita_de(uva, Sucos, azul, Mochilas).                % 9. Uva em algum lugar a dir. da Azul

% =========================================================================
% PREDICADOS AUXILIARES DE LISTAS E DOMINIOS
% =========================================================================

% Preenche uma lista com valores de um dominio e garante que sejam distintos
preenche_lista([], _).
preenche_lista([H|T], Pred) :-
    call(Pred, H),
    preenche_lista(T, Pred).

% Garante que todos os elementos de uma lista sejam distintos (Conforme tutorial)
alldifferent([]).
alldifferent([H|T]) :-
    \+ member(H, T),
    alldifferent(T).

% =========================================================================
% PREDICADOS AUXILIARES DE POSICAO E RELACIONAMENTO
% =========================================================================

% Encontra a posicao (1 a 5) de um elemento na lista
posicao(X, [X|_], 1) :- !.
posicao(X, [_|T], P) :-
    posicao(X, T, P1),
    P is P1 + 1.

% Verifica se duas posicoes sao vizinhas (diferenca de 1)
ao_lado(X, ListaX, Y, ListaY) :-
    posicao(X, ListaX, PX),
    posicao(Y, ListaY, PY),
    (PX =:= PY + 1 ; PX =:= PY - 1).

% Verifica se X esta exatamente a esquerda de Y (X + 1 = Y)
exatamente_a_esquerda(X, ListaX, Y, ListaY) :-
    posicao(X, ListaX, PX),
    posicao(Y, ListaY, PY),
    PY =:= PX + 1.

% Verifica se X esta em algum lugar a esquerda de Y (X < Y)
a_esquerda_de(X, ListaX, Y, ListaY) :-
    posicao(X, ListaX, PX),
    posicao(Y, ListaY, PY),
    PX < PY.

% Verifica se X esta em algum lugar a direita de Y (X > Y)
a_direita_de(X, ListaX, Y, ListaY) :-
    posicao(X, ListaX, PX),
    posicao(Y, ListaY, PY),
    PX > PY.

% Verifica se dois elementos estao na mesma posicao em listas diferentes
mesma_posicao(X, ListaX, Y, ListaY) :-
    posicao(X, ListaX, P),
    posicao(Y, ListaY, P).

% Verifica se a posicao e uma ponta (1 ou 5)
ponta(1).
ponta(5).

% =========================================================================
% IMPRESSAO DA SOLUCAO
% =========================================================================
imprime_lista([]) :- 
    nl, write('----------------------------------------'), nl,
    write('FIM da impressao da lista'), nl.

imprime_lista([menino(Mochila, Nome, Mes, Jogo, Materia, Suco)|T]) :-
    write('Mochila : '), write(Mochila), nl,
    write('Nome    : '), write(Nome), nl,
    write('Mes     : '), write(Mes), nl,
    write('Jogo    : '), write(Jogo), nl,
    write('Materia : '), write(Materia), nl,
    write('Suco    : '), write(Suco), nl,
    write('----------------------------------------'), nl,
    imprime_lista(T).

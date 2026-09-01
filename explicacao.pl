% ============================================================================
% TRABALHO DE INTELIGÊNCIA ARTIFICIAL - RESOLUÇÃO DE PUZZLE LÓGICO
% ============================================================================
% 
% Descrição:
%   Este programa resolve um puzzle lógico onde 5 meninos foram ao laboratório
%   de computação jogar seus jogos favoritos. O objetivo é descobrir as 
%   características de cada um (mochila, nome, mês de nascimento, jogo favorito,
%   matéria preferida e suco favorito) respeitando 23 regras de restrição.
%
% Paradigma:
%   Programação Lógica Declarativa em Prolog
%
% Estratégia:
%   - Modelagem como CSP (Constraint Satisfaction Problem)
%   - Aplicação de restrições em ordem decrescente de poder de poda
%   - Uso de backtracking para explorar o espaço de busca
%
% Autor: [Seu Nome]
% Data: [Data]
% Disciplina: Inteligência Artificial
% ============================================================================

% ============================================================================
% SEÇÃO 1: DOMÍNIOS (FATOS)
% ============================================================================
% Definição dos valores possíveis para cada atributo.
% Cada fato representa um valor válido do domínio do problema.

% Cores das mochilas disponíveis
mochila(amarela).
mochila(azul).
mochila(branca).
mochila(verde).
mochila(vermelha).

% Nomes dos 5 meninos
nome(denis).
nome(joao).
nome(lenin).
nome(otavio).
nome(will).

% Meses de nascimento possíveis
mes(agosto).
mes(dezembro).
mes(janeiro).
mes(maio).
mes(setembro).

% Jogos favoritos
jogo(tres_ou_mais).
jogo(caca_palavras).
jogo(cubo_vermelho).
jogo(jogo_da_forca).
jogo(prob_de_logica).

% Matérias escolares preferidas
materia(biologia).
materia(geografia).
materia(historia).
materia(matematica).
materia(portugues).

% Sabores de suco
suco(laranja).
suco(limao).
suco(maracuja).
suco(morango).
suco(uva).

% ============================================================================
% SEÇÃO 2: PREDICADO PRINCIPAL (MAIN)
% ============================================================================
% Ponto de entrada do programa. Executa a busca por todas as soluções,
% imprime os resultados e mede o tempo de execução.

main :-
    % Marca o tempo inicial de execução
    statistics(cputime, T1),
    
    % Loop de busca de soluções:
    % - modelo(Solucao) tenta encontrar uma solução válida
    % - imprime_lista exibe a solução encontrada
    % - fail FORÇA o backtracking para buscar a próxima solução
    % - Quando não há mais soluções, o fail falha e cai no (; true)
    (   modelo(Solucao),
        nl, write('=== Solucao encontrada ==='), nl,
        imprime_lista(Solucao),
        fail  % Backtracking forçado para encontrar todas as soluções
    ;   true  % Quando não há mais soluções, encerra o loop
    ),
    
    % Marca o tempo final e calcula o tempo total
    statistics(cputime, T2),
    T is T2 - T1,
    nl, write('Tempo de CPU (segundos): '), write(T), nl,
    write('Busca terminada.'), nl.

% ============================================================================
% SEÇÃO 3: MODELO DO PROBLEMA (CORAÇÃO DO PROGRAMA)
% ============================================================================
% Define a estrutura da solução e aplica todas as 23 restrições do enunciado.
% A ordem das restrições é estratégica: das mais restritivas para as menos.

modelo(Solucao) :-
    % -------------------------------------------------------------------------
    % FASE 1: ESTRUTURA DA SOLUÇÃO
    % -------------------------------------------------------------------------
    % Cria uma lista com 5 "meninos", cada um representado por uma tupla
    % com 6 atributos: (Mochila, Nome, Mês, Jogo, Matéria, Suco)
    % As variáveis estão inicialmente LIVRES (não instanciadas)
    
    Solucao = [
        menino(M1, N1, Mes1, J1, Mat1, S1),  % Menino na posição 1
        menino(M2, N2, Mes2, J2, Mat2, S2),  % Menino na posição 2
        menino(M3, N3, Mes3, J3, Mat3, S3),  % Menino na posição 3
        menino(M4, N4, Mes4, J4, Mat4, S4),  % Menino na posição 4
        menino(M5, N5, Mes5, J5, Mat5, S5)   % Menino na posição 5
    ],
    
    % -------------------------------------------------------------------------
    % FASE 2: LISTAS TRANSVERSAIS
    % -------------------------------------------------------------------------
    % Cria "visões" dos dados para facilitar a aplicação de restrições.
    % Em vez de olhar para meninos individuais, olhamos para "todas as mochilas",
    % "todos os nomes", etc.
    
    Mochilas = [M1, M2, M3, M4, M5],  % Lista de todas as mochilas
    Nomes    = [N1, N2, N3, N4, N5],  % Lista de todos os nomes
    Meses    = [Mes1, Mes2, Mes3, Mes4, Mes5],  % Lista de todos os meses
    Jogos    = [J1, J2, J3, J4, J5],  % Lista de todos os jogos
    Materias = [Mat1, Mat2, Mat3, Mat4, Mat5],  % Lista de todas as matérias
    Sucos    = [S1, S2, S3, S4, S5],  % Lista de todos os sucos

    % -------------------------------------------------------------------------
    % FASE 3: GERAÇÃO DE DOMÍNIOS COM ALDIFFERENT
    % -------------------------------------------------------------------------
    % Preenche cada lista com valores válidos do domínio correspondente
    % e garante que não haja repetições (cada valor aparece exatamente uma vez)
    
    preenche_lista(Mochilas, mochila), alldifferent(Mochilas),
    preenche_lista(Nomes, nome),       alldifferent(Nomes),
    preenche_lista(Meses, mes),        alldifferent(Meses),
    preenche_lista(Jogos, jogo),       alldifferent(Jogos),
    preenche_lista(Materias, materia), alldifferent(Materias),
    preenche_lista(Sucos, suco),       alldifferent(Sucos),

    % -------------------------------------------------------------------------
    % FASE 4: APLICAÇÃO DAS RESTRIÇÕES (23 REGRAS)
    % -------------------------------------------------------------------------
    % As restrições são aplicadas em ordem estratégica para maximizar a poda
    % do espaço de busca (das mais restritivas para as menos restritivas)

    % -------------------------------------------------------------------------
    % GRUPO A: POSIÇÕES FIXAS IMEDIATAS
    % -------------------------------------------------------------------------
    % Estas regras fixam valores em posições específicas, eliminando muitas
    % possibilidades logo no início
    
    S1 = limao,                 % Regra 19: Na 1ª posição, suco é limão
    S3 = morango,               % Regra 6: Na 3ª posição, suco é morango
    J3 = jogo_da_forca,         % Regra 23: Na 3ª posição, jogo é Forca
    N5 = lenin,                 % Regra 21: Na 5ª posição, nome é Lenin

    % -------------------------------------------------------------------------
    % GRUPO B: EQUIVALÊNCIAS DIRETAS (MESMA POSIÇÃO)
    % -------------------------------------------------------------------------
    % Estas regras associam atributos de domínios diferentes na mesma posição
    
    mesma_posicao(biologia, Materias, morango, Sucos),       % Regra 12: Biologia → Morango
    mesma_posicao(matematica, Materias, maracuja, Sucos),    % Regra 20: Matemática → Maracujá
    mesma_posicao(matematica, Materias, dezembro, Meses),    % Regra 15: Matemática → Dezembro
    mesma_posicao(azul, Mochilas, janeiro, Meses),           % Regra 17: Azul → Janeiro
    mesma_posicao(uva, Sucos, prob_de_logica, Jogos),        % Regra 7: Uva → Prob. de Lógica
    mesma_posicao(joao, Nomes, historia, Materias),          % Regra 2: João → História

    % -------------------------------------------------------------------------
    % GRUPO C: POSIÇÕES EXATAS (EXATAMENTE À ESQUERDA)
    % -------------------------------------------------------------------------
    % Estas regras fixam relações de posição consecutiva
    
    exatamente_a_esquerda(branca, Mochilas, will, Nomes),    % Regra 5: Branca ex. esq. de Will
    exatamente_a_esquerda(uva, Sucos, portugues, Materias),  % Regra 14: Uva ex. esq. de Português

    % -------------------------------------------------------------------------
    % GRUPO D: PONTAS E EXTREMITADES
    % -------------------------------------------------------------------------
    % Estas regras limitam elementos às posições 1 ou 5
    
    posicao(otavio, Nomes, POtavio), ponta(POtavio),         % Regra 22: Otávio em uma ponta
    posicao(cubo_vermelho, Jogos, PCubo), ponta(PCubo),      % Regra 10: Cubo Vermelho em uma ponta

    % -------------------------------------------------------------------------
    % GRUPO E: RESTRIÇÕES DE VIZINHANÇA (AO LADO)
    % -------------------------------------------------------------------------
    % Estas regras impõem relações de adjacência (diferença de posição = 1)
    
    ao_lado(will, Nomes, prob_de_logica, Jogos),             % Regra 4: Will ao lado de Prob. Lógica
    ao_lado(jogo_da_forca, Jogos, tres_ou_mais, Jogos),      % Regra 8: Forca ao lado de 3 ou Mais
    ao_lado(jogo_da_forca, Jogos, vermelha, Mochilas),       % Regra 11: Forca ao lado da Vermelha
    ao_lado(prob_de_logica, Jogos, amarela, Mochilas),       % Regra 16: Prob. Lógica ao lado da Amarela
    ao_lado(setembro, Meses, laranja, Sucos),                % Regra 1: Setembro ao lado de Laranja
    ao_lado(janeiro, Meses, setembro, Meses),                % Regra 13: Janeiro ao lado de Setembro
    ao_lado(setembro, Meses, cubo_vermelho, Jogos),          % Regra 18: Setembro ao lado do Cubo Vermelho

    % -------------------------------------------------------------------------
    % GRUPO F: RESTRIÇÕES RELATIVAS (EM ALGUM LUGAR À ESQUERDA/DIREITA)
    % -------------------------------------------------------------------------
    % Estas são as menos restritivas (aplicadas por último)
    
    a_esquerda_de(azul, Mochilas, maio, Meses),              % Regra 3: Azul em algum lugar à esq. de Maio
    a_direita_de(uva, Sucos, azul, Mochilas).                % Regra 9: Uva em algum lugar à dir. da Azul

% ============================================================================
% SEÇÃO 4: PREDICADOS AUXILIARES DE LISTAS E DOMÍNIOS
% ============================================================================

% ----------------------------------------------------------------------------
% preenche_lista/2 - Gera valores do domínio
% ----------------------------------------------------------------------------
% Preenche uma lista com valores válidos de um domínio específico.
% Para cada posição da lista, chama o predicado correspondente (ex: mochila(H))
%
% Exemplo: preenche_lista([M1, M2, M3, M4, M5], mochila)
%          vai tentar mochila(M1), mochila(M2), etc.

preenche_lista([], _).  % Caso base: lista vazia, nada a fazer
preenche_lista([H|T], Pred) :-
    call(Pred, H),              % Chama dinamicamente o predicado (ex: mochila(H))
    preenche_lista(T, Pred).    % Recursão para o resto da lista

% ----------------------------------------------------------------------------
% alldifferent/1 - Garante unicidade
% ----------------------------------------------------------------------------
% Verifica se todos os elementos de uma lista são distintos.
% Usa negação por falha (\+) para garantir que H não aparece no resto da lista.
%
% Exemplo: alldifferent([a, b, c]) → true
%          alldifferent([a, b, a]) → false

alldifferent([]).  % Caso base: lista vazia, todos são distintos
alldifferent([H|T]) :-
    \+ member(H, T),           % H NÃO pode estar no resto da lista (negação por falha)
    alldifferent(T).           % Recursão para verificar o resto

% ============================================================================
% SEÇÃO 5: PREDICADOS AUXILIARES DE POSIÇÃO E RELACIONAMENTO
% ============================================================================

% ----------------------------------------------------------------------------
% posicao/3 - Encontra posição de um elemento
% ----------------------------------------------------------------------------
% Retorna a posição (1 a 5) de um elemento X na lista.
% Usa pattern matching e recursão com acumulador.
%
% Exemplo: posicao(uva, [laranja, limao, uva, morango, maracuja], P)
%          → P = 3
%
% O cut (!) impede backtracking depois de encontrar o elemento (otimização)

posicao(X, [X|_], 1) :- !.     % Se X é o primeiro elemento, posição = 1
posicao(X, [_|T], P) :-
    posicao(X, T, P1),         % Busca X no resto da lista
    P is P1 + 1.               % Soma 1 à posição encontrada

% ----------------------------------------------------------------------------
% ao_lado/4 - Verifica vizinhança
% ----------------------------------------------------------------------------
% Verifica se X e Y estão em posições adjacentes (vizinhas).
% Duas posições são vizinhas se a diferença entre elas for exatamente 1.
%
% Exemplo: ao_lado(a, [a, b, c, d, e], c, [x, y, c, w, z])
%          → true (a está na pos. 1, c está na pos. 3... não, espera)
%          → false (diferença = 2, não é vizinho)
%
% O operador ; é o OU lógico em Prolog

ao_lado(X, ListaX, Y, ListaY) :-
    posicao(X, ListaX, PX),    % Encontra posição de X
    posicao(Y, ListaY, PY),    % Encontra posição de Y
    (PX =:= PY + 1 ; PX =:= PY - 1).  % Diferença de exatamente 1 (OU lógico)

% ----------------------------------------------------------------------------
% exatamente_a_esquerda/4 - Posição consecutiva
% ----------------------------------------------------------------------------
% Verifica se X está exatamente à esquerda de Y (posições consecutivas).
% Se X está na posição P, então Y deve estar na posição P+1.
%
% Exemplo: exatamente_a_esquerda(branca, [azul, branca, verde, ...], will, [denis, will, ...])
%          → true (branca na pos. 2, will na pos. 2... não, espera)
%          → Exemplo correto: branca na pos. 2, will na pos. 3

exatamente_a_esquerda(X, ListaX, Y, ListaY) :-
    posicao(X, ListaX, PX),    % Encontra posição de X
    posicao(Y, ListaY, PY),    % Encontra posição de Y
    PY =:= PX + 1.             % Y está exatamente uma posição à direita de X

% ----------------------------------------------------------------------------
% a_esquerda_de/4 - Ordem relativa (esquerda)
% ----------------------------------------------------------------------------
% Verifica se X está em algum lugar à esquerda de Y (não necessariamente adjacente).
% Se X está na posição PX e Y está na posição PY, então PX < PY.
%
% Exemplo: a_esquerda_de(azul, [azul, ...], maio, [..., maio, ...])
%          → true se azul estiver antes de maio na ordem das posições

a_esquerda_de(X, ListaX, Y, ListaY) :-
    posicao(X, ListaX, PX),    % Encontra posição de X
    posicao(Y, ListaY, PY),    % Encontra posição de Y
    PX < PY.                   % X está antes de Y

% ----------------------------------------------------------------------------
% a_direita_de/4 - Ordem relativa (direita)
% ----------------------------------------------------------------------------
% Verifica se X está em algum lugar à direita de Y (não necessariamente adjacente).
% Se X está na posição PX e Y está na posição PY, então PX > PY.
%
% Exemplo: a_direita_de(uva, [..., uva, ...], azul, [azul, ...])
%          → true se uva estiver depois de azul na ordem das posições

a_direita_de(X, ListaX, Y, ListaY) :-
    posicao(X, ListaX, PX),    % Encontra posição de X
    posicao(Y, ListaY, PY),    % Encontra posição de Y
    PX > PY.                   % X está depois de Y

% ----------------------------------------------------------------------------
% mesma_posicao/4 - Equivalência de posição
% ----------------------------------------------------------------------------
% Verifica se X e Y estão na mesma posição em listas diferentes.
% Útil para regras do tipo "X → Y" (X implica Y na mesma posição).
%
% Exemplo: mesma_posicao(biologia, [geo, bio, hist, mat, port], morango, [lar, lim, mor, mar, uva])
%          → true (ambos na posição 2)

mesma_posicao(X, ListaX, Y, ListaY) :-
    posicao(X, ListaX, P),     % Encontra posição de X
    posicao(Y, ListaY, P).     % Y deve estar na mesma posição P

% ----------------------------------------------------------------------------
% ponta/1 - Verifica se é uma extremidade
% ----------------------------------------------------------------------------
% Verifica se a posição é uma das pontas (1 ou 5).
%
% Exemplo: ponta(1) → true
%          ponta(3) → false
%          ponta(5) → true

ponta(1).  % Posição 1 é uma ponta
ponta(5).  % Posição 5 é uma ponta

% ============================================================================
% SEÇÃO 6: IMPRESSÃO DA SOLUÇÃO
% ============================================================================

% ----------------------------------------------------------------------------
% imprime_lista/1 - Exibe a solução formatada
% ----------------------------------------------------------------------------
% Percorre a lista de meninos recursivamente e imprime cada atributo.
% Usa pattern matching para extrair os valores da tupla menino(...).
%
% Formato de saída:
% Mochila : azul
% Nome    : otavio
% Mes     : janeiro
% Jogo    : cubo_vermelho
% Materia : geografia
% Suco    : limao
% ----------------------------------------

imprime_lista([]) :- 
    nl, write('----------------------------------------'), nl,
    write('FIM da impressao da lista'), nl.  % Caso base: lista vazia

imprime_lista([menino(Mochila, Nome, Mes, Jogo, Materia, Suco)|T]) :-
    % Extrai os 6 atributos do functor menino/6 usando pattern matching
    write('Mochila : '), write(Mochila), nl,
    write('Nome    : '), write(Nome), nl,
    write('Mes     : '), write(Mes), nl,
    write('Jogo    : '), write(Jogo), nl,
    write('Materia : '), write(Materia), nl,
    write('Suco    : '), write(Suco), nl,
    write('----------------------------------------'), nl,
    imprime_lista(T).  % Recursão para o próximo menino

% ============================================================================
% FIM DO CÓDIGO
% ============================================================================
% 
% Para executar:
%   1. Salve este arquivo como puzzle.pl
%   2. Abra o SWI-Prolog
%   3. Carregue o arquivo: ?- [puzzle].
%   4. Execute: ?- main.
%
% Conceitos de IA aplicados:
%   - CSP (Constraint Satisfaction Problem)
%   - Busca em profundidade com backtracking
%   - Poda do espaço de busca (pruning)
%   - Unificação e pattern matching
%   - Negação por falha
%   - Recursão
%
% ============================================================================
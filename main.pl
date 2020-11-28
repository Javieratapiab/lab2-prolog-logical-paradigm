% Base de conocimiento

% --------  TDA STACK ---------
% Dominio:

% Metas
% Principales: stack
% Secundarias: setUsers, setQuestions, setAnswers

% Clásulas
% Hechos
stack([Users,Questions,Answers],[Users,Questions,Answers]).

% Reglas
setUsers(Users,[_,Questions,Answers], R):- stack([Users,Questions,Answers], R).
setQuestions(Questions,[Users,_,Answers], R):- stack([Users,Questions,Answers], R).
setAnswers(Answers,[Users,Questions,_], R):- stack([Users,Questions,Answers], R).

% Base de conocimiento

% ------------ UTILS ------------------
exists(Elem,[H|T]):- Elem = H; exists(Elem,T),!,true.

appendList([],List,List).
appendList([H|T],L2,[H|List]):- appendList(T,L2,List).

%customLast(X,X).
%customLast(X,[_|L]):- customLast(X,L).

% ------------ TDA STACK ---------------
stack([Users,Questions,Answers],[Users,Questions,Answers]).
question([Id,Author,Date,Text,Labels],[Id,Author,Date,Text,Labels]).
answer([Id,QuestionId,Author,Date,Text,Labels],[Id,QuestionId,Author,Date,Text,Labels]).

setUsers(Users,[_,Questions,Answers],R):- stack([Users,Questions,Answers],R).
setQuestions(Questions,[Users,_,Answers],R):- stack([Users,Questions,Answers],R).
setAnswers(Answers,[Users,Questions,_],R):- stack([Users,Questions,Answers],R).

getUsers([Users,_,_],Users).
getQuestions([_,Questions,_],Questions).
getAnswers([_,_,Answers],Answers).

addUser(Users,Username,_,Users):- exists([Username,_],Users),!,false.
addUser([H|T],Username,Password,R):- appendList([[Username,Password],H],T, R).

stackRegister([],Username,Password,[[[Username,Password]],[],[]]).
stackRegister(Stack,Username,Password,Stack2):- getUsers(Stack,Users),
  addUser(Users,Username,Password,U2),
  getQuestions(Stack,Q1),
  getAnswers(Stack,A1),
  stack([U2,Q1,A1],Stack2).

validateRegistedUser(Users,Username,Password,Users):- \+ exists([Username,Password],Users),!,false.
validateRegistedUser(Users,Username,_,R):- appendList([Username],Users,R).

stackLogin(Stack,Username,Password,Stack2):- getUsers(Stack,Users),
  validateRegistedUser(Users,Username,Password,U2),
  getQuestions(Stack,Q1),
  getAnswers(Stack,A1),
  stack([U2,Q1,A1],Stack2).

validateLoggedUser(Users):- getLoggedUser(Users,R), string(R).
getLoggedUser([H|_], H).
removeLoggedUser([_|T], T).

setQuestionId(Question,NewId):- getQuestionId(Question,Id), NewId is Id + 1.
getQuestionId([Id,_,_,_,_],Id).

addQuestion([],Author,Date,Text,Labels,[R]):- question([1,Author,Date,Text,Labels],R).
addQuestion([H|T],Author,Date,Text,Labels,R):- setQuestionId(H,NewId),
    question([NewId, Author,Date,Text,Labels], Q),
    appendList([Q],[H|T],R).

validateQuestionId(Questions,QuestionId):- exists([QuestionId,_,_,_,_],Questions),!,true.

getAnswerId([Id,_,_,_,_,_],Id).
setAnswerId(Answer,NewId):- getAnswerId(Answer,Id), NewId is Id + 1.

addAnswer([],QuestionId,Author,Date,Text,Labels,[R]):- answer([1,QuestionId,Author,Date,Text,Labels],R).
addAnswer([H|T],QuestionId,Author,Date,Text,Labels,R):- setAnswerId(H,NewId),
    answer([NewId,QuestionId,Author,Date,Text,Labels], Q),
    appendList([Q],[H|T],R).

ask(Stack,Fecha,TextoPregunta,ListaEtiquetas,Stack2):- getUsers(Stack,Users),
  validateLoggedUser(Users),
  getLoggedUser(Users,UL),
  getQuestions(Stack,Q1),
  getAnswers(Stack,A1),
  addQuestion(Q1,UL,Fecha,TextoPregunta,ListaEtiquetas,Q2),
  removeLoggedUser(Users,U2),
  stack([U2,Q2,A1],Stack2).

answer(Stack,Fecha,IdPregunta,TextoRespuesta,ListaEtiquetas,Stack2):- getUsers(Stack,Users),
  validateLoggedUser(Users),
  getLoggedUser(Users,UL),
  getQuestions(Stack,Q1),
  validateQuestionId(Q1,IdPregunta),
  getAnswers(Stack,A1),
  addAnswer(A1,IdPregunta,UL,Fecha,TextoRespuesta,ListaEtiquetas,A2),
  removeLoggedUser(Users,U2),
  stack([U2,Q1,A2],Stack2).

% EJEMPLO EN CONSOLA:
% stackRegister([[["Tomas", "#wes@"],["Javiera", "pa$$"]],[],[]],"Fran", "sdad", R), stackLogin(R, "Fran", "sdad", R2), ask(R2, "2020-10-23", "Hola qué tal?", [1,2,45], R3), stackLogin(R3, "Fran", "sdad", R4), ask(R4, "2020-10-23", "Hola quésfasdf tal?", [1,2,45], R5), stackLogin(R5, "Fran", "sdad", R6), answer(R6,"2020-11-28",2,"Tudu bem",["Javascript"], R7), stackLogin(R7, "Javiera", "pa$$", R8),answer(R8,"2020-11-28",1,"bien y túuuuu",["no sé"], R9).
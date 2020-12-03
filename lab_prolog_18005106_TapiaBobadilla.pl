% BASE DE CONOCIMIENTO

% ------------------  UTILS ------------------
% Dominios
% Elem: elemento cualquiera (átomo, número, lista, string, etc).
% T: cola que representa cualquier elemento (átomo, número, lista, string, etc) en una lista.
% H: cabeza que representa cualquier elemento (átomo, número, lista, string, etc) en una lista.
% F: elemento cualquiera (átomo, número, lista, string, etc) que representa el match con otro elemento buscado.
% O: elemento cualquiera (átomo, número, lista, string, etc) que simboliza la palabra "old", que será reemplazado por otro elemento (R) en una lista.
% R: elemento cualquiera (átomo, número, lista, string, etc) que simboliza la palabra "replacement", que será el reemplazo de un elemento (O) en una lista.
% L2: lista que representa una segunda lista entregada a un predicado que operará sobre ella.
% T2: nueva cola de una lista que será retornada luego de una operación sobre esta última.
% Length: número que representa el largo de una lista.

% Predicados
% exists(Elem,[H|T]).
% find([H|T],Elem,F).
% appendList([H|T],L2,[H|List]).
% lengthList([H|T],Length).
% replace(O,R,[H|T],[H|T2]).

% Metas
% Secundarias: exists,find,appendList,lenghtList,replace

% Cláusulas
% Reglas
exists(Elem,[Elem|_]):-!.
exists(Elem,[_|T]):- exists(Elem,T).

find([],_,_):-!,false.
find([Elem|_],Elem,Elem):-!.
find([_|T],Elem,F):- find(T,Elem,F).

appendList([],L2,L2).
appendList([H|T],L2,[H|T2]):- appendList(T,L2,T2).

lengthList([],0).
lengthList([_|T],Length):- lengthList(T,TL), Length is TL + 1.

replace(_,_,[],[]).
replace(O,R,[O|T],[R|T2]):- replace(O,R,T,T2).
replace(O,R,[H|T],[H|T2]):- H \= O, replace(O,R,T,T2).

% ------------------  TDA STACK  ------------------
% Dominios

% Predicados
% stack(LoggedUser,Users,Questions,Answers)
% stackRegister(Stack, Username, Password, Stack2)
% stackLogin(Stack, Username, Password, Stack2)
% ask(Stack, Fecha, TextoPregunta, ListaEtiquetas, Stack2)
% answer(Stack, Fecha, IdPregunta, TextoRespuesta, ListaEtiquetas, Stack2)
% accept(Stack, IdPregunta, IdRespuesta, Stack2)
% vote(Stack,TdaPreguntaORespuesta,Voto,Stack2)
% stackTostring(Stack, StackStr)
% setVote(Stack,QuestionOrAnswer,Vote,R)

% Metas
% Principales: stackRegister,stackLogin,ask,answer,accept,vote,stackTostring
% Secundarias: addRegistedUser,validateLogin,updateUsers,updateQuestions,updateAnswers, setVote

% Hechos
stack(LoggedUser,Users,Questions,Answers,[LoggedUser,Users,Questions,Answers]).
stack([],[["Bilz y Pap", "pa$$",0],["Pepsi", "pa$$w0rd",0]],[[1,"Bilz y Pap", "2020-12-01", "¿Qué es un string?", 15, "abierta", ["Computer science","Paradigms"]]],[[1, 1, "Pepsi", "2020-12-01","Es una secuencia de caracteres", 0,"no", ["Computer science", "Paradigms"]]],_).
stack([],[["Coca Cola", "12345",20],["Fanta", "p4ss",0]],[[1,"Fanta", "2020-12-02", "¿Qué es un scope?", 2, "abierta", ["Computer science","Javascript"]]],[[1, 1, "Coca Cola", "2020-12-03","Contexto que pertenece a un nombre dentro de un programa", 0,"no", ["Computer science", "Javascript"]]],_).

% ------------------  TDA USER  ------------------
% Dominios
% Username string que representa la llave primaria y nombre de un usuario registrado.
% Password: string que representa la password de un usuario registrado.
% Reputation: número que representa la reputación de un usuario registrado.

% Predicados
% user(Username,Password,Reputation)
% updateUsers(Users,UpdatedUser,UpdatedUsers)
% updateQuestionAuthorReputation(Users,Question,UpdatedQuestionAuthor)
% updateAnswerAuthorReputation(Users,Answer,UpdatedAnswerAuthor)
% userString([Username,Password,Reputation],Result)
% usersToString(U0,[H|T],[SH|ST])

% Metas
% Primarias: user
% Secundarias: updateUsers, updateQuestionAuthorReputation, updateAnswerAuthorReputation, userString
%              usersToString        

% Hechos
user(Username,Password,Reputation,[Username,Password,Reputation]).
user("Quatro","mypass",10,_).
user("Sprite","customPa$$",0,_).
user("Inca Cola","admin",22,_).
user("DrPepper","admin",8,_).

% ------------------ TDA QUESTION ------------------
% Dominios
% Id: número consecutivo que representa la llave primaria de una pregunta.
% Author: string que representa al autor de una pregunta.
% Date: string que representa la fecha de creación de una pregunta.
% Text: string que representa el contenido de una pregunta.
% Votes: número que presenta la cantidad de votos de una pregunta.
% Status: string que presenta el estatus de una pregunta.
% Labels: lista que presenta las etiquetas (tópicos) de una pregunta.
% Question: representa una pregunta.
% NewId: número que representa un nuevo id consecutivo.

% Predicados
% question(Id,Author,Date,Text,Votes,Status,Labels)
% setQuestionId(Question,NewId)
% addQuestion([H|T],[Author|_],Date,Text,Labels,Q)
% validateQuestionId(Questions,QuestionId)
% validateAuthorAndQuestion(Questions,QuestionId,[Author|_])
% updateQuestions(Questions,UpdatedQuestion,UpdatedQuestions)
% calculateQuestionReputation(boolean,Reputation)
% questionString([Id,Author,Date,Text,Votes,Status,Labels],Result)
% questionsToString(U0,[H|T],[SH|ST])

% Metas
% Primarias: question, getQuestion
% Secundarias: setQuestionId, addQuestion, validateQuestionId,
% 			       validateAuthorAndQuestion, setQuestionAcceptStatus, updateQuestions, calculateQuestionReputation
%              questionString, questionsToString

% Hechos
question(Id,Author,Date,Text,Votes,Status,Labels,[Id,Author,Date,Text,Votes,Status,Labels]).
question(1,"Coca Cola","2020-12-02","¿Cómo funciona Elixir?",10,"abierta",["elixir", "functional programming"]).
question(2,"Pepsi","2020-11-22","¿Qué es un Grafo?",5,"abierta",["algorithms", "computer science"]).
question(3,"Fanta","2020-11-05","¿Cuáles son los lenguajes más populares el 2020?",0,"abierta",["programming languages", "computer science"]).
question(4,"Inca Cola","2020-10-08","¿Cómo funciona malloc?",8,"abierta",["C", "memory management"]).
question(5,"DrPepper","2020-02-11","¿Cuál es la diferencia entre .map y .forEach?",0,"abierta",["javascript", "high order functions"]).

% ------------------  TDA ANSWER  ------------------
% Dominios
% Id: número consecutivo que representa la llave primaria de una respuesta.
% QuestionId: número que representa el ID de una pregunta asociada a una respuesta.
% Author: string que representa al autor de una respuesta.
% Date: string que representa la fecha de creación de una respuesta.
% Text: string que representa el contenido de una respuesta.
% Votes: número que presenta la cantidad de votos de una respuesta.
% Status: string que presenta el estatus de aceptación de una respuesta.
% Labels: lista que presenta las etiquetas (tópicos) de una respuesta.

% Predicados
% answer(Id,QuestionId,Author,Date,Text,Votes,AcceptStatus,Labels)
% setAnswerId(Answer,NewId)
% addAnswer([H|T],QuestionId,[Author|_],Date,Text,Labels,[A]).
% getAnswer(Stack,QuestionId,AnswerId,Answer)
% updateAnswers(Answers,UpdatedAnswer,UpdatedAnswers)
% calculateAnswerReputation(AnswerAuthor,[VoteAuthor|_],false,Reputation)
% answerString([Id,QuestionId,Author,Date,Text,Votes,Status,Labels],Result)
% answersToString(U0,[H|T],[SH|ST])

% Metas
% Primarias: answer, getAnswer
% Secundarias: setAnswerId, addAnswer, validateAnswerId,
%              setAnswerAcceptStatus, updateAnswers, calculateAnswerReputation,
%              answerString, answersToString.

answer(Id,QuestionId,Author,Date,Text,Votes,AcceptStatus,Labels,[Id,QuestionId,Author,Date,Text,Votes,AcceptStatus,Labels]).
answer(1,1,"Pepsi","2020-12-03","No lo sé, pero es cool",-10,"abierta",["elixir", "functional programming"],_).
answer(2,1,"Coca Cola","2020-12-03","Elixir es un lenguaje de programación funcional, concurrente, de propósito general que se ejecuta sobre la máquina virtual de Erlang",20,"cerrada",["elixir", "functional programming"],_).
answer(3,2,"Inca Cola","2020-11-05","Un grafo consiste de un conjunto V de vértices (o nodos) y un conjunto E de arcos que conectan a esos vértices",40,"abierta",["algorithms", "computer science"],_).
answer(4,2,"Fanta","2020-10-08","LTGFY.",-40,"abierta",["algorithms", "computer science"],_).
answer(5,3,"Coca Cola","2020-02-11","Probablemente Python, por su uso en Data science",20,"abierta",["programming languages", "computer science"],_).
answer(6,3,"DrPepper","2020-12-02","Diría que Ruby, por la madurez del lenguage y su comunidad",50,"abierta",["programming languages", "computer science"],_).
answer(7,4,"Quatro","2020-11-22","Me cuesta entenderlo también",-5,"abierta",["C", "memory management"],_).
answer(8,4,"DrPepper","2020-11-05","La asignación dinámica de memoria en el Lenguaje de programación C, se realiza a través de un grupo de funciones en la biblioteca estándar de C, como malloc",30,"cerrada",["C", "memory management"],_).
answer(9,5,"Fanta","2020-10-08","Map retorna un nuevo arreglo, mientras que forEach modifica el arreglo original",45,"abierta",["javascript", "high order functions"],_).
answer(10,5,"Sprite","2020-02-11","El método forEach() está pensado para recorrer colecciones, mientras que el método map() está pensado para iterar sobre una colección dada",48,"abierta",["javascript", "high order functions"],_).

% Clausulas
% Reglas
addRegistedUser(Users,Username,_,_):- exists(Users,[Username,_]),false.
addRegistedUser([H|T],Username,Password,Users):- user(Username,Password,0,User),appendList([User,H],T,Users).

stackRegister([_,[],_,_],Username,Password,Stack2):- stack([],[[Username,Password,0]],[],[],Stack2).
stackRegister(Stack, Username, Password, Stack2):-
  stack(_,U1,_,_,Stack),
  addRegistedUser(U1,Username,Password,U2),
  stack(_,_,Q1,_,Stack),
  stack(_,_,_,A1,Stack),
  stack([],U2,Q1,A1,Stack2).

validateLogin(Users,Username,Password):- exists([Username,Password,_],Users),true.

stackLogin(Stack, Username, Password, Stack2):-
  stack(_,U1,_,_,Stack),
  validateLogin(U1,Username,Password),
  stack(_,_,Q1,_,Stack),
  stack(_,_,_,A1,Stack),
  stack([Username],U1,Q1,A1,Stack2).

setQuestionId(Question,NewId):- question(Id,_,_,_,_,_,_,Question),NewId is Id + 1.
addQuestion([],[Author|_],Date,Text,Labels,[Q]):- question(1,Author,Date,Text,0,"abierta",Labels,Q).
addQuestion([H|T],[Author|_],Date,Text,Labels,Q):-
  setQuestionId(H,NewId),
  question(NewId,Author,Date,Text,0,"abierta",Labels,Question),
  appendList([Question],[H|T],Q).

validateQuestionId(Questions,QuestionId):- exists([QuestionId,_,_,_,_,_,_],Questions),true.

ask(Stack, Fecha, TextoPregunta, ListaEtiquetas, Stack2):-
  stack(_,U1,_,_,Stack),
  stack(U0,_,_,_,Stack),
  lengthList(U0,Length),Length = 1,
  stack(_,_,Q1,_,Stack),
  stack(_,_,_,A1,Stack),
  addQuestion(Q1,U0,Fecha,TextoPregunta,ListaEtiquetas,Q2),
  stack([],U1,Q2,A1,Stack2).
 
setAnswerId(Answer,NewId):- answer(Id,_,_,_,_,_,_,_,Answer),NewId is Id + 1.
addAnswer([],QuestionId,[Author|_],Date,Text,Labels,[A]):- answer(1,QuestionId,Author,Date,Text,0,"no",Labels,A).
addAnswer([H|T],QuestionId,[Author|_],Date,Text,Labels,A):-
  setAnswerId(H,NewId),
  answer(NewId,QuestionId,Author,Date,Text,0,"no",Labels,Answer),
  appendList([Answer],[H|T],A).

answer(Stack, Fecha, IdPregunta, TextoRespuesta, ListaEtiquetas, Stack2):-
  stack(_,U1,_,_,Stack),
  stack(U0,_,_,_,Stack),
  lengthList(U0,Length),Length = 1,
  stack(_,_,Q1,_,Stack),
  validateQuestionId(Q1,IdPregunta),
  stack(_,_,_,A1,Stack),
  addAnswer(A1,IdPregunta,U0,Fecha,TextoRespuesta,ListaEtiquetas,A2),
  stack([],U1,Q1,A2,Stack2).

validateAuthorAndQuestion(Questions,QuestionId,[Author|_]):- exists([QuestionId,Author,_,_,_,_,_],Questions),true.
validateAnswerId(Answers,AnswerId):- exists([AnswerId,_,_,_,_,_,_,_],Answers),true.

getQuestion(Stack,QuestionId,Question):-
  stack(_,_,Questions,_,Stack),
  find(Questions,[QuestionId,_,_,_,_,_,_],Question).

getAnswer(Stack,QuestionId,AnswerId,Answer):- 
  stack(_,_,_,Answers,Stack),
  find(Answers,[AnswerId,QuestionId,_,_,_,_,_,_],Answer).

setAnswerAcceptStatus(Answer,UpdatedAnswer):-
  answer(Id,QuestionId,AnswerAuthor,AnswerDate,AnswerText,AnswerVotes,_,AnswerLabels,Answer),
  answer(Id,QuestionId,AnswerAuthor,AnswerDate,AnswerText,AnswerVotes,"si",AnswerLabels,UpdatedAnswer).

setQuestionAcceptStatus(Question,UpdatedQuestion):-
  question(Id,QuestionAuthor,QuestionDate,QuestionText,QuestionVotes,_,QuestionLabels,Question),
  question(Id,QuestionAuthor,QuestionDate,QuestionText,QuestionVotes,"cerrada",QuestionLabels,UpdatedQuestion).

updateQuestionAuthorReputation(Users,Question,UpdatedQuestionAuthor):-
  question(_,Author,_,_,_,_,_,Question),
  find(Users,[Author,_,_],User),
  user(Username,Password,Reputation,User),
  NewReputation is Reputation + 2,
  user(Username,Password,NewReputation,UpdatedQuestionAuthor).
 
updateAnswerAuthorReputation(Users,Answer,UpdatedAnswerAuthor):-
  answer(_,_,Author,_,_,_,_,_,Answer),
  find(Users,[Author,_,_],User),
  user(Username,Password,Reputation,User),
  NewReputation is Reputation + 15,
  user(Username,Password,NewReputation,UpdatedAnswerAuthor).

updateUsers(Users,UpdatedUser,UpdatedUsers):-
  user(Username,_,_,UpdatedUser),
  find(Users,[Username,_,_],OldUser),
  replace(OldUser,UpdatedUser,Users,UpdatedUsers).

updateQuestions(Questions,UpdatedQuestion,UpdatedQuestions):-
  question(Id,_,_,_,_,_,_,UpdatedQuestion),
  find(Questions,[Id,_,_,_,_,_,_],OldQuestion),
  replace(OldQuestion,UpdatedQuestion,Questions,UpdatedQuestions).

updateAnswers(Answers,UpdatedAnswer,UpdatedAnswers):-
  answer(Id,_,_,_,_,_,_,_,UpdatedAnswer),
  find(Answers,[Id,_,_,_,_,_,_,_],OldAnswer),
  replace(OldAnswer,UpdatedAnswer,Answers,UpdatedAnswers).

accept(Stack, IdPregunta, IdRespuesta, Stack2):-
  stack(_,U1,_,_,Stack),
  stack(U0,_,_,_,Stack),
  lengthList(U0,Length),Length = 1,
  stack(_,_,Q1,_,Stack),
  stack(_,_,_,A1,Stack),
  validateAuthorAndQuestion(Q1,IdPregunta,U0),
  validateAnswerId(A1,IdRespuesta),
  getQuestion(Stack,IdPregunta,Question),
  getAnswer(Stack,IdPregunta,IdRespuesta,Answer),
  setQuestionAcceptStatus(Question,UpdatedQuestion),
  setAnswerAcceptStatus(Answer,UpdatedAnswer),
  updateQuestionAuthorReputation(U1,UpdatedQuestion,UpdatedQuestionAuthor),
  updateAnswerAuthorReputation(U1,UpdatedAnswer,UpdatedAnswerAuthor),
  updateQuestions(Q1,UpdatedQuestion,Q2),
  updateAnswers(A1,UpdatedAnswer,A2),
  updateUsers(U1,UpdatedQuestionAuthor,U2),
  updateUsers(U2,UpdatedAnswerAuthor,U3),
  stack([],U3,Q2,A2,Stack2).

calculateQuestionReputation(true,Reputation):- Reputation is + 10.
calculateQuestionReputation(false,Reputation):- Reputation is - 2.
calculateAnswerReputation(_,_,true,Reputation):- Reputation is + 10.
calculateAnswerReputation(AnswerAuthor,[VoteAuthor|_],false,Reputation):- AnswerAuthor = VoteAuthor, Reputation is - 2.
calculateAnswerReputation(AnswerAuthor,[VoteAuthor|_],false,Reputation):- AnswerAuthor \= VoteAuthor, Reputation is - 1.

setVote(Stack,QuestionOrAnswer,Vote,R):-
  stack(U0,_,_,_,Stack),
  lengthList(U0,Length),Length = 1,
  stack(_,U1,_,_,Stack),
  stack(_,_,Q1,_,Stack),
  stack(_,_,_,A1,Stack),
  find(Q1,QuestionOrAnswer,Question),
  question(_,QuestionAuthor,_,_,_,_,_,Question),
  U0 = [QuestionAuthor],
  calculateQuestionReputation(Vote,VoteReputation),
  find(U1,[QuestionAuthor,_,_],OldUser),
  user(_,Password,Reputation,OldUser),
  NewReputation is Reputation + VoteReputation,
  user(QuestionAuthor,Password,NewReputation,UpdatedUser),
  replace(OldUser,UpdatedUser,U1,UpdatedUsers),
  stack([],UpdatedUsers,Q1,A1,R).

setVote(Stack,QuestionOrAnswer,Vote,R):-
  stack(U0,_,_,_,Stack),
  lengthList(U0,Length),Length = 1,
  stack(_,U1,_,_,Stack),
  stack(_,_,Q1,_,Stack),
  stack(_,_,_,A1,Stack),
  find(A1,QuestionOrAnswer,Answer),
  answer(_,_,AnswerAuthor,_,_,_,_,_,Answer),
  calculateAnswerReputation(AnswerAuthor,U0,Vote,VoteReputation),
  find(U1,[AnswerAuthor,_,_],OldUser),
  user(_,Password,Reputation,OldUser),
  NewReputation is Reputation + VoteReputation,
  user(AnswerAuthor,Password,NewReputation,UpdatedUser),
  replace(OldUser,UpdatedUser,U1,UpdatedUsers),
  stack([],UpdatedUsers,Q1,A1,R).

vote(Stack,TdaPreguntaORespuesta,Voto,Stack2):- setVote(Stack,TdaPreguntaORespuesta,Voto,Stack2).

userString([Username,Password,Reputation],Result):-
  string_concat("Username: ",Username,R1),
  string_concat("Password: ",Password,R2),
  string_concat("Reputación: ",Reputation,R3),
  atomics_to_string([R1,R2,R3], '\n', Result).

usersToString(_,[],[]):- !.
usersToString(U0,[H|T],[SH|ST]):-
  userString(H,S1),
  string_concat(S1,"\n",SH),
  usersToString(U0,T,ST).

questionString([Id,Author,Date,Text,Votes,Status,Labels],Result):-
  string_concat("ID:",Id,R1),
  string_concat("Autor:",Author,R2),
  string_concat("Fecha:",Date,R3),
  string_concat("Texto pregunta:",Text,R4),
  string_concat("Votos:",Votes,R5),
  string_concat("Estado:",Status,R6),
  atomics_to_string(Labels,LabelsStr),
  string_concat("Labels:",LabelsStr,R7),
  atomic_list_concat([R1,R2,R3,R4,R5,R6,R7],'\n',QuestionsAtom),
  atom_string(QuestionsAtom, Result).

questionsToString(_,[],[]):- !.
questionsToString(U0,[H|T],[SH|ST]):-
  questionString(H,S1),
  string_concat(S1,"\n",SH),
  questionsToString(U0,T,ST).

answerString([Id,QuestionId,Author,Date,Text,Votes,Status,Labels],Result):-
  string_concat("ID:",Id,R1),
  string_concat("ID de pregunta:",QuestionId,R2),
  string_concat("Autor:",Author,R3),
  string_concat("Fecha:",Date,R4),
  string_concat("Texto respuesta:",Text,R5),
  string_concat("Votos:",Votes,R6),
  string_concat("Estado:",Status,R7),
  atomics_to_string(Labels,LabelsStr),
  string_concat("Labels:",LabelsStr,R8),
  atomic_list_concat([R1,R2,R3,R4,R5,R6,R7,R8],'\n',AnswersAtom),
  atom_string(AnswersAtom, Result).

answersToString(_,[],[]):- !.
answersToString(U0,[H|T],[SH|ST]):-
  answerString(H,S1),
  string_concat(S1,"\n",SH),
  answersToString(U0,T,ST).

stackTostring(Stack, StackStr):-
  stack(_,U1,_,_,Stack),
  stack(_,_,Q1,_,Stack),
  stack(_,_,_,A1,Stack),
  usersToString(U0,U1,UsersList),
  atomic_list_concat(UsersList,'',UsersAtom),
  atom_string(UsersAtom,UsersStr),
  questionsToString(U0,Q1,QuestionsList),
  atomic_list_concat(QuestionsList,'',QuestionsAtom),
  atom_string(QuestionsAtom,QuestionsStr),
  answersToString(U0,A1,AnswersList),
  atomic_list_concat(AnswersList,'',AnswersAtom),
  atom_string(AnswersAtom,AnswersStr),
  atomics_to_string([UsersStr,QuestionsStr,AnswersStr],'',StackStr).

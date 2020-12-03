% Hechos

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

% ------------------  TDA STACK ------------------ 
stack(LoggedUser,Users,Questions,Answers,[LoggedUser,Users,Questions,Answers]).
user(Username,Password,Reputation,[Username,Password,Reputation]).
question(Id,Author,Date,Text,Votes,Status,Labels,[Id,Author,Date,Text,Votes,Status,Labels]).
answer(Id,QuestionId,Author,Date,Text,Votes,AcceptStatus,Labels,[Id,QuestionId,Author,Date,Text,Votes,AcceptStatus,Labels]).

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
 
/*
stackRegister([[],[],[],[]],"Fran", "sdad", R),
stackRegister(R,"Javiera", "pa$$", R1),
stackLogin(R1, "Javiera", "pa$$", R2),
ask(R2, "2020-10-23", "Pregunta de Javiera", [1,2,45], R3),
stackLogin(R3, "Fran", "sdad", R4),
ask(R4, "2020-10-23", "Pregunta de Francisca", [1,2,45], R5),
stackLogin(R5, "Fran", "sdad", R6),
answer(R6,"2020-11-28",1,"Tudu bem",["Javascript"], R7),
stackLogin(R7, "Javiera", "pa$$", R8),
answer(R8,"2020-11-28",2,"TODO EXCELENTEEEE",["Javascript"], R9),
stackLogin(R9, "Fran", "sdad", R10),
accept(R10,2,2,R11),
stackLogin(R11,"Javiera","pa$$",R12),
getQuestion(R12,1,Question),
vote(R12,Question,true,Stack2),
stackLogin(Stack2, "Fran", "sdad", R13),
getQuestion(R13,2,Question2),
vote(R13,Question2,false,R15),
stackLogin(R15, "Fran", "sdad", R16),
getAnswer(R16,2,2,Answer),
vote(R16,Answer,false,R17),
stackTostring(R17,StackStr).*/
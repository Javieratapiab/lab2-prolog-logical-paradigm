exists(Elem,[Elem|_]):-!.
exists(Elem,[_|T]):- exists(Elem,T).

find([],_,_):-!,false.
find([Elem|_],Elem,Elem):-!.
find([_|T],Elem,R):- find(T,Elem,R).

appendList([],List,List).
appendList([H|T],L2,[H|List]):- appendList(T,L2,List).

lengthList([],0).
lengthList([_|T],Length):- lengthList(T,TL), Length is TL + 1.

replace(_,_,[],[]).
replace(O,R,[O|T],[R|T2]):- replace(O,R,T,T2).
replace(O,R,[H|T],[H|T2]):- H \= O, replace(O,R,T,T2).

stack(LoggedUser,Users,Questions,Answers,[LoggedUser,Users,Questions,Answers]).
user(Username,Password,Reputation,[Username,Password,Reputation]).
question(Id,Author,Date,Text,Votes,Status,Labels,[Id,Author,Date,Text,Votes,Status,Labels]).
answer(Id,QuestionId,Author,Date,Text,Votes,AcceptStatus,Labels,[Id,QuestionId,Author,Date,Text,Votes,AcceptStatus,Labels]).

addRegistedUser(Users,Username,_,_):- exists(Users,[Username,_]),false.
addRegistedUser([H|T],Username,Password,Users):- user(Username,Password,0,User),appendList([User,H],T,Users).

stackRegister([_,[],_,_],Username,Password,Stack2):- stack([],[[Username,Password,0]],[],[],Stack2).
stackRegister(Stack,Username,Password,Stack2):-
  stack(_,U1,_,_,Stack),
  addRegistedUser(U1,Username,Password,U2),
  stack(_,_,Q1,_,Stack),
  stack(_,_,_,A1,Stack),
  stack([],U2,Q1,A1,Stack2).

validateLogin(Users,Username,Password):- exists([Username,Password,_],Users),true.

stackLogin(Stack,Username,Password,Stack2):-
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

ask(Stack,Fecha,TextoPregunta,ListaEtiquetas,Stack2):-
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

answer(Stack,Fecha,IdPregunta,TextoRespuesta,ListaEtiquetas,Stack2):-
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

accept(Stack,IdPregunta,IdRespuesta,Stack2):-
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


%Debe retornar false si el voto va para una pregunta que no es del usuario que tiene sesión activa en el stack.
setVote(Stack,QuestionOrAnswer,R):-
 stack(_,_,Q1,_,Stack),
 find(Q1,QuestionOrAnswer,Question),
 question(Id,QuestionAuthor,_,_,_,_,_,Question),
 stack(U0,_,_,_,Stack),
 U0 = [QuestionAuthor],
 
 
 %question(Id,QuestionAuthor,QuestionDate,QuestionText,QuestionVotes,_,QuestionLabels,Question),
 %stack([],U1,Q1,A1,R).

setVote(Stack,QuestionOrAnswer,R):-
 stack(_,_,_,A1,Stack),
 find(A1,QuestionOrAnswer,Answer),
 stack([],U1,Q1,A1,R).

vote(Stack,TdaPreguntaORespuesta,Voto,Stack2):-
 setVote(Stack,TdaPreguntaORespuesta,Stack2).


/* EJEMPLO EN CONSOLA:
stackRegister([[],[],[],[]],"Fran", "sdad", R),
stackRegister(R,"Javiera", "pa$$", R1),
stackLogin(R1, "Javiera", "pa$$", R2),
ask(R2, "2020-10-23", "Hola qué tal?", [1,2,45], R3),
stackLogin(R3, "Fran", "sdad", R4),
ask(R4, "2020-10-23", "Hola quésfasdf tal?", [1,2,45], R5),
stackLogin(R5, "Fran", "sdad", R6),
answer(R6,"2020-11-28",1,"Tudu bem",["Javascript"], R7),
stackLogin(R7, "Javiera", "pa$$", R8),
answer(R8,"2020-11-28",2,"TODO EXCELENTEEEE",["Javascript"], R9),
stackLogin(R9, "Fran", "sdad", R10),
accept(R10,2,1,R11).
*/
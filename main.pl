exists(Elem,[Elem|_]):-!.
exists(Elem,[_|T]):- exists(Elem,T).
appendList([],List,List).
appendList([H|T],L2,[H|List]):- appendList(T,L2,List).
lengthList([],0).
lengthList([_|T],Length):- lengthList(T,TL), Length is TL + 1.

stack(LoggedUser,Users,Questions,Answers,[LoggedUser,Users,Questions,Answers]).
user(Username,Password,[Username,Password]).
question(Id,Author,Date,Text,Labels,[Id,Author,Date,Text,Labels]).
answer(Id,QuestionId,Author,Date,Text,Labels,[Id,QuestionId,Author,Date,Text,Labels]).

addRegistedUser(Users,Username,_,_):- exists(Users,[Username,_]),false.
addRegistedUser([H|T],Username,Password,R):- appendList([[Username,Password],H],T, R).

stackRegister([_,[],_,_],Username,Password,Stack2):- stack([],[[Username,Password]],[],[],Stack2).
stackRegister(Stack,Username,Password,Stack2):- stack(_,U1,_,_,Stack),
  addRegistedUser(U1,Username,Password,U2),
  stack(_,_,Q1,_,Stack),
  stack(_,_,_,A1,Stack),
  stack([],U2,Q1,A1,Stack2).

validateLoggedUser(Users,Username,Password):- exists([Username,Password],Users),true.

stackLogin(Stack,Username,Password,Stack2):- stack(_,U1,_,_,Stack),
  validateLoggedUser(U1,Username,Password),
  stack(_,_,Q1,_,Stack),
  stack(_,_,_,A1,Stack),
  stack([Username],U1,Q1,A1,Stack2).

setQuestionId(Question,NewId):- question(Id,_,_,_,_,Question), NewId is Id + 1.
addQuestion([],[Author|_],Date,Text,Labels,[Q]):- question(1,Author,Date,Text,Labels,Q).
addQuestion([H|T],[Author|_],Date,Text,Labels,Q):- setQuestionId(H,NewId),
  question(NewId,Author,Date,Text,Labels,Question),
  appendList([Question],[H|T],Q).

validateQuestionId(Questions,QuestionId):- exists([QuestionId,_,_,_,_],Questions),true.

ask(Stack,Fecha,TextoPregunta,ListaEtiquetas,Stack2):- stack(_,U1,_,_,Stack),
  stack(U0,_,_,_,Stack),
  lengthList(U0,Length),Length = 1,
  stack(_,_,Q1,_,Stack),
  stack(_,_,_,A1,Stack),
  addQuestion(Q1,U0,Fecha,TextoPregunta,ListaEtiquetas,Q2),
  stack([],U1,Q2,A1,Stack2).

setAnswerId(Answer,NewId):- answer(Id,_,_,_,_,_,Answer), NewId is Id + 1.
addAnswer([],QuestionId,[Author|_],Date,Text,Labels,[A]):- answer(1,QuestionId,Author,Date,Text,Labels,A).
addAnswer([H|T],QuestionId,[Author|_],Date,Text,Labels,A):- setAnswerId(H,NewId),
  answer(NewId,QuestionId,Author,Date,Text,Labels,Answer),
  appendList([Answer],[H|T],A).

answer(Stack,Fecha,IdPregunta,TextoRespuesta,ListaEtiquetas,Stack2):- stack(_,U1,_,_,Stack),
  stack(U0,_,_,_,Stack),
  lengthList(U0,Length),Length = 1,
  stack(_,_,Q1,_,Stack),
  validateQuestionId(Q1,IdPregunta),
  stack(_,_,_,A1,Stack),
  addAnswer(A1,IdPregunta,U0,Fecha,TextoRespuesta,ListaEtiquetas,A2),
  stack([],U1,Q1,A2,Stack2).

accept(Stack,IdPregunta,IdRespuesta,Stack2):- stack(Users,_,_,Stack),
 validateLoggedUser(Users),
 getLoggedUser(Users,UL),
 stack(_,Q1,_,Stack),
 validateQuestionId(Q1,IdPregunta),
 validateQuestionAuthor(Q1,IdPregunta,UL).

% EJEMPLO EN CONSOLA:
%stackRegister([[],[["Tomas", "#wes@"],["Javiera", "pa$$"]],[],[]],"Fran", "sdad", R),
%stackLogin(R, "Fran", "sdad", R2),
%ask(R2, "2020-10-23", "Hola qué tal?", [1,2,45], R3),
% stackLogin(R3, "Fran", "sdad", R4),
% ask(R4, "2020-10-23", "Hola quésfasdf tal?", [1,2,45], R5),
%stackLogin(R5, "Fran", "sdad", R6),
%answer(R6,"2020-11-28",2,"Tudu bem",["Javascript"], R7),
%stackLogin(R7, "Javiera", "pa$$", R8),
%answer(R8,"2020-11-28",1,"bien y túuuuu",["no sé"], R9).

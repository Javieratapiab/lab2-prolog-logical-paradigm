% Base de conocimiento

% ------------ UTILS ------------------
exists(Elem,[H|T]):- Elem = H; exists(Elem,T), !.

appendList([],List,List).
appendList([H|T],L2,[H|List]):- appendList(T,L2,List).

customLast(X,X).
customLast(X,[_|L]):- customLast(X,L).

% ------------ TDA STACK ---------------
stack([Users,Questions,Answers],[Users,Questions,Answers]).
question([Id,Author,Date,Text,Labels],[Id,Author,Date,Text,Labels]).

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
  getAnswers(Stack,R1),
  stack([U2,Q1,R1],Stack2).

validateRegistedUser(Users,Username,Password,Users):- \+ exists([Username,Password],Users),!,false.
validateRegistedUser(Users,Username,_,R):- appendList([Username],Users,R).

stackLogin(Stack,Username,Password,Stack2):- getUsers(Stack,Users),
  validateRegistedUser(Users,Username,Password,U2),
  getQuestions(Stack,Q1),
  getAnswers(Stack,R1),
  stack([U2,Q1,R1],Stack2).

validateLogguedUser(Users):- getLogguedUser(Users,R), string(R).
getLogguedUser([H|_], H).
removeLogguedUser([_|T], T).

setQuestionId(Question,NewId):- getQuestionId(Question,Id), NewId is Id + 1.
getQuestionId([Id,_,_,_,_],Id).

addQuestion([],Author,Date,Text,Labels,[R]):- question([1,Author,Date,Text,Labels],R).
addQuestion([H|T],Author,Date,Text,Labels,R):- setQuestionId(H,NewId),
    question([NewId, Author,Date,Text,Labels], Q),
    appendList([Q],[H|T], R).

ask(Stack,Fecha,TextoPregunta,ListaEtiquetas,Stack2):- getUsers(Stack,Users),
  validateLogguedUser(Users),
  getLogguedUser(Users,UL),
  getQuestions(Stack,Q1),
  getAnswers(Stack,A1),
  addQuestion(Q1,UL,Fecha,TextoPregunta,ListaEtiquetas,Q2),
  removeLogguedUser(Users,U2),
  stack([U2,Q2,A1],Stack2).

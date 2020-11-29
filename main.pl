% Base de conocimiento

% ------------ UTILS ------------------
exists(Elem, [H|T]) :- Elem = H; exists(Elem, T).

% ------------ TDA STACK ---------------
stack([Users,Questions,Answers],[Users,Questions,Answers]).

setUsers(Users,[_,Questions,Answers], R):- stack([Users,Questions,Answers],R).
setQuestions(Questions,[Users,_,Answers], R):- stack([Users,Questions,Answers],R).
setAnswers(Answers,[Users,Questions,_], R):- stack([Users,Questions,Answers],R).

getUsers([Users,_,_], Users).
getQuestions([_,Questions,_], Questions).
getAnswers([_,_,Answers], Answers).

addUser(Users,Username,_,Users):- exists([Username,_],Users),!,false.
addUser(Users,Username,Password,[[Username,Password],Users]).

stackRegister([],Username,Password,[[[Username,Password]],[],[]]).
stackRegister(Stack,Username,Password,Stack2):- getUsers(Stack,Users),
    addUser(Users,Username,Password,U2),
    getQuestions(Stack,Q1),
    getAnswers(Stack,R1),
    stack([U2,Q1,R1],Stack2).

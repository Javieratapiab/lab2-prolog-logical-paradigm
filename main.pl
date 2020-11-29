% Base de conocimiento

% ------------ UTILS ------------------
exists(Elem,[H|T]):- Elem = H; exists(Elem,T), !.
appendList([],List,List).
appendList([H|T],L2,[H|List]):- appendList(T,L2,List).

% ------------ TDA STACK ---------------
stack([Users,Questions,Answers],[Users,Questions,Answers]).

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

validateUser(Users,Username,Password,Users):- \+ exists([Username,Password],Users),!,false.
validateUser(Users,Username,_,[Username,Users]).

stackLogin(Stack,Username,Password,Stack2):- getUsers(Stack,Users),
    validateUser(Users,Username,Password,U2),
    getQuestions(Stack,Q1),
    getAnswers(Stack,R1),
    stack([U2,Q1,R1],Stack2).

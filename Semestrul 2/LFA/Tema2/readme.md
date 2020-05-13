# **LFA Project 2 & 3**


## **NFA Class**:
### Implements Nondeterministic finite automaton

 - [x] Remove lambdas
 - [x] Convert to Dfa
 - [x] Get Regex 
 
 - [x] Get/Push States
 - [x] Read/Write automaton

## **DFA Class - Subclass of NFA**:
### Implements deterministic finite automaton
 - [x] Minimize
 
 - [x] Read/Write automaton
 
## REGGRAM Class:
### Implements regular grammar
 - [x] Get NFA
 - [x] Remove Lambdas
 
 - [x] Read/Write grammar
 
## REGGEX Class:
### Implements regex
 - [x] Minimize
 - [x] Remove Lambdas
 
 - [x] Read/Write regex
 
 ## Example output: 
 ```
 <------ Model: ----------------------->

(States) (Connections) (Number of final states)
(Start state)
(Final states)
(State from) (State to) (Cost)
...
...
(State from) (State to) (Cost)

<------ Lambda nfa to dfa: ----------->

NFA: 
3 4 1
0 
2 
0 0 0
0 0 1
0 1 1
1 2 0

DFA: 
3 6 1
0 
2 
0 0 0
0 1 1
1 2 0
1 1 1
2 0 0
2 1 1

<------ Dfa to regex: ---------------->

Minimized DFA: 
4 6 1
0 
3 
0 1 a
1 3 b
1 2 a
1 1 b
2 3 c
2 2 c

Regex: 
ab*bab*ac*c

<------ Regular grammar to dfa: ------>

Grammar: 
A aA | aS
B cS | ~
S a | aA | bB | ~

Epsilon free grammar: 
A aA | aS | a
B cS | c
S a | aA | bB | b
S1 a | aA | bB | b | ~

NFA: 
5 13 2
3 
3 4 
0 0 a
0 2 a
0 4 a
1 2 c
1 4 c
2 4 a
2 0 a
2 1 b
2 4 b
3 4 a
3 0 a
3 1 b
3 4 b

Regex: 
a+aa*a+b+bc+bc(aa*a+bc)*a

DFA: 
6 9 6
1 
0 1 2 3 4 5 
0 0 a
0 5 b
1 3 a
1 5 b
2 3 a
2 5 b
3 0 a
4 0 a
5 1 c

Final Regex: 
aaa*baaa*b(caaa*b+cb)*ccaaa*


A aA | aS
B cS | ~
S a | aA | bB | ~

A aA | aS | a
B cS | c
S a | aA | bB | b
S1 a | aA | bB | b | ~

5 13 2
3 
3 4 
0 0 a
0 2 a
0 4 a
1 2 c
1 4 c
2 4 a
2 0 a
2 1 b
2 4 b
3 4 a
3 0 a
3 1 b
3 4 b

a+aa*a+b+bc+bc(aa*a+bc)*a

6 9 6
1 
0 1 2 3 4 5 
0 0 a
0 5 b
1 3 a
1 5 b
2 3 a
2 5 b
3 0 a
4 0 a
5 1 c

aaa*baaa*b(caaa*b+cb)*ccaaa*

 ```
 
 **Created By Darius Buhai, all rights reserved**
 
 ***Personal website: https://darius.buhai.ro***
 
 
 

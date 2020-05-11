#include <iostream>
#include <fstream>

#include "include/nfa.h"
#include "include/dfa.h"
#include "include/reggram.h"
#include "include/reggex.h"

using namespace std;

void show_model(){
    cout<<"\n<------ Model: ----------------------->\n\n";
    cout<<"(States) (Connections) (Number of final states)\n(Start state)\n(Final states)\n";
    cout<<"(State from) (State to) (Cost)\n...\n...\n";
    cout<<"(State from) (State to) (Cost)\n";
}

void lambda_nfa_dfa(){
    cout<<"\n<------ Lambda nfa to dfa: ----------->\n\n";
    NFA nfa;
    ifstream fin("data/nfa.in");
    fin>>nfa;
    nfa.remove_lambdas();
    nfa.convert_to_dfa();
    DFA dfa = *(DFA*)&nfa;
    dfa.minimize();
    cout<<dfa;
    fin.close();
}

void dfa_regex(){
    cout<<"\n<------ Dfa to regex: ---------------->\n\n";
    DFA dfa;
    ifstream fin("data/dfa.in");
    fin>>dfa;
    dfa.minimize();
    cout<<dfa;
    cout<<dfa.get_regex();
    fin.close();
}

void regular_grammar_dfa(){
    cout<<"\n<------ Regular grammar to dfa: ------>\n\n";
    REGGRAM reggram;
    ifstream fin("data/reggram.in");
    fin>>reggram;
    cout<<reggram;
    reggram.remove_lambdas();
    cout<<reggram;
    NFA nfa = reggram.get_nfa();
    nfa.remove_lambdas();
    cout<<nfa;
    cout<<nfa.get_regex()<<'\n';
    nfa.convert_to_dfa();
    DFA dfa = *(DFA*)&nfa;
    dfa.minimize();
    cout<<dfa;
    cout<<dfa.get_regex();
    fin.close();
}
int main() {

    show_model();

    lambda_nfa_dfa();
    dfa_regex();
    regular_grammar_dfa();

    return 0;
}

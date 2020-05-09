#include <iostream>
#include <fstream>

#include "include/nfa.h"
#include "include/dfa.h"
#include "include/reggram.h"

using namespace std;

void lambda_nfa_dfa(){
    NFA nfa;
    ifstream fin("data/nfa.in");
    fin>>nfa;
    nfa.remove_lambdas();
    /// Final states need to be fixed!
    nfa.convert_to_dfa();
    DFA dfa = *(DFA*)&nfa;
    dfa.minimize();
    cout<<dfa;
    cout<<dfa.get_regex()<<"\n\n";
    fin.close();
}

void dfa_regex(){
    DFA dfa;
    ifstream fin("data/dfa.in");
    fin>>dfa;
    dfa.minimize();
    cout<<dfa.get_regex()<<"\n\n";
    fin.close();
}

void regular_grammar_dfa(){
    REGGRAM reggram;
    ifstream fin("data/reggram.in");
    fin>>reggram;
    /// Not working for the moment
    reggram.remove_lambdas();
    ///
    cout<<reggram;
    NFA nfa = reggram.get_nfa();
    nfa.remove_lambdas();
    /// Final states need to be fixed!
    nfa.convert_to_dfa();
    DFA dfa = *(DFA*)&nfa;
    dfa.minimize();
    cout<<nfa;
    cout<<dfa.get_regex();
    fin.close();
}

int main() {

    //lambda_nfa_dfa();
    //dfa_regex();
    regular_grammar_dfa();

    return 0;
}

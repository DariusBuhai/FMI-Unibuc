#include <iostream>
#include <cstdio>

#include "src/nfa.h"
#include "src/dfa.h"

using namespace std;

int main() {
    NFA nfa;
    DFA dfa;

    freopen("data/nfa.in", "r", stdin);
    cin>>nfa;
    nfa.remove_lambdas();
    nfa.convert_to_dfa();
    dfa = DFA(nfa.get_states());
    dfa.minimize();
    cout<<dfa;
    cout<<dfa.get_regex()<<"\n\n";

    freopen("data/dfa.in", "r", stdin);
    cin>>dfa;
    dfa.minimize();
    cout<<dfa.get_regex()<<'\n';

    return 0;
}

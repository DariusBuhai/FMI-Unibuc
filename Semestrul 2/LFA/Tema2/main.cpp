#include <iostream>
#include <cstdio>

#include "include/nfa.h"
#include "include/dfa.h"

using namespace std;

int main() {
    DFA dfa;

    freopen("data/nfa.in", "r", stdin);
    cin>>dfa;
    dfa.remove_lambdas();
    dfa.convert_to_dfa();
    dfa.minimize();
    cout<<dfa;
    cout<<dfa.get_regex()<<"\n\n";

    freopen("data/dfa.in", "r", stdin);
    cin>>dfa;
    dfa.minimize();
    cout<<dfa.get_regex()<<'\n';

    return 0;
}

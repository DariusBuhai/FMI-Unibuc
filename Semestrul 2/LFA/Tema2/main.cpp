#include <iostream>
#include <cstdio>

#include "nfa.h"

using namespace std;

int main() {
    NFA nfa;

    freopen("nfa.in", "r", stdin);

    nfa.read_data(cin);

    nfa.remove_lambdas();
    nfa.convert_to_dfa();
    nfa.remove_inaccessible();
    nfa.minimize();
    
    nfa.write();

    return 0;
}

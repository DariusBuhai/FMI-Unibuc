#include <iostream>
#include <cstdio>

#include "nfa.h"

using namespace std;

int main() {
    NFA nfa;

    freopen("nfa.in", "r", stdin);
    //freopen("nfa.out", "w", stdout);

    nfa.read_data(cin);
    nfa.remove_lambdas();
    nfa.convert_to_dfa();
    nfa.minimize();
    nfa.remove_inaccessible();
    
    nfa.write(cout, true);

    return 0;
}

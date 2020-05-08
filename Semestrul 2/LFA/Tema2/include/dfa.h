#include "nfa.h"

#include <iostream>
#include <vector>
#include <string>

#ifndef TEMA2_DFA_H
#define TEMA2_DFA_H

class DFA: public NFA{
private:
    static void strip_char(std::string&, const char);
    void strip_lambdas();
    void remove_from_states(State* state);
    std::vector<std::pair<State*, std::pair<State*, std::string>>> get_all_inputs(State* state);
    void remove_state(State* state);
    void remove_inaccessible();

public:
    void minimize();
    std::string get_regex();
};

#endif //TEMA2_DFA_H

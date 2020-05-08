#include "nfa.h"

#include <iostream>
#include <vector>
#include <string>

#ifndef TEMA2_DFA_H
#define TEMA2_DFA_H

class DFA{
private:
    std::vector<State*> states;
    int start_state;

    static void strip_char(std::string&, const char);
    void strip_lambdas();
    void remove_from_states(State* state);
    std::vector<std::pair<State*, std::pair<State*, std::string>>> get_all_inputs(State* state);
    void remove_state(State* state);
    void remove_inaccessible();

public:
    DFA(std::vector<State*>);
    DFA() = default;

    void minimize();
    std::string get_regex();

    std::vector<State*> get_states() const;
    std::vector<State*> get_states(bool, bool);

    friend std::istream& operator>>(std::istream&, DFA&);
    friend std::ostream& operator<<(std::ostream&, const DFA&);

    friend NFA;
};

#endif //TEMA2_DFA_H

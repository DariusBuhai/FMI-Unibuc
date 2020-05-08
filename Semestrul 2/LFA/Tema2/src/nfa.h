#include "state.h"

#include <vector>
#include <iostream>

#ifndef TEMA2_NFA_H
#define TEMA2_NFA_H

class NFA{
private:
    std::vector<State *> states;

    void remove_lambda(State*, State*, int);
    std::vector<State*> get_states(bool, bool);
public:
    void remove_lambdas();
    void convert_to_dfa();
    //DFA get_dfa();

    std::vector<State *> get_states() const;

    friend std::istream& operator>>(std::istream&, NFA&);
    friend std::ostream& operator<<(std::ostream&, const NFA&);
};

#endif //TEMA2_NFA_H

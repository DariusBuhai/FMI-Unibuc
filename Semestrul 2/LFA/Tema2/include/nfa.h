#include "state.h"

#include <vector>
#include <iostream>

#ifndef TEMA2_NFA_H
#define TEMA2_NFA_H

class NFA{
    static void remove_lambda(State*, State*, int);
protected:
    std::vector<State *> states;
public:
    NFA(std::vector<State *>);
    NFA(NFA const &);
    NFA() = default;

    void remove_lambdas();
    void convert_to_dfa();

    std::vector<State *> get_states() const;
    std::vector<State*> get_states(bool, bool);

    friend std::istream& operator>>(std::istream&, NFA&);
    friend std::ostream& operator<<(std::ostream&, const NFA&);
};

#endif //TEMA2_NFA_H

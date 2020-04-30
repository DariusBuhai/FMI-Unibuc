//
// Created by Darius Buhai on 4/2/20.
//

#include <vector>
#include <iostream>

#ifndef TEMA2_NFA_H
#define TEMA2_NFA_H

class Node{
public:
    /// Nu ar trebui sa fie publice, dar dureaza prea mult sa le fac gettere si settere
    std::vector<std::pair<Node *, char>> next;
    bool final_state, start_state;
    int id;

    Node(int, bool = false, bool = false);
};

class NFA{
private:
    std::vector<Node *> g;

    void remove_lambda(Node*, Node*, int);
    std::vector<Node*> get_states(bool, bool);
public:
    void read_data(std::istream&);

    void remove_lambdas();
    void convert_to_dfa();

    void remove_inaccessible();
    void minimize();
    void write();
};

#endif //TEMA2_NFA_H

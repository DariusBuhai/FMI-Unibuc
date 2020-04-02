//
// Created by Darius Buhai on 4/2/20.
//

#include <vector>
#include <iostream>

#ifndef TEMA2_NFA_H
#define TEMA2_NFA_H

template <typename T>
class Node{
public:
    /// Nu ar trebui sa fie publice, dar dureaza prea mult sa le fac gettere si settere
    std::vector<std::pair<Node *, T>> next;
    bool final_state, start_state;
    int id;

    Node(int, bool = false, bool = false);
};

template <typename T = char, T lambda = '~'>
class NFA{
private:
    std::vector<Node<T> *> g;

    void remove_lambda(Node<T>*, Node<T>*, int);
    void remove_inaccessible();

public:
    void read_data(std::istream&);

    void remove_lambdas();
    void convert_to_dfa();

    void minimize();
};

#include "nfa.cpp"

#endif //TEMA2_NFA_H

//
// Created by Darius Buhai on 4/1/20.
//

#include <vector>
#include <string>

#ifndef TEMA2_BTREE_H
#define TEMA2_BTREE_H

template <typename T = int>
class Node{
private:
    const int t;
    bool isLeaf = false;

    void remove_from_leaf(int x);
    void remove_from_non_leaf(int x);
    void fill(int i);
public:
    std::vector<T> keys;
    std::vector<Node*> childs;
public:
    Node(int = 3, bool = false);
    Node(std::vector<T>, int = 3, bool = false);

    int size();
    bool isFull();

    void split_child(int i);
    void append_child(T x);
    void remove(T x);

    void traverse(std::vector<T>&);
    Node<T>* search(T x);
};

template <typename T = int>
class BTree{
private:
    const int t;
    Node<T> *root;
public:

    BTree(int = 3);
    BTree(std::vector<T>, int = 3);

    void insert(T x);
    void insert(std::vector<T>);
    void insert_string(std::string);
    void remove(T x);

    std::vector<T> traverse();
    void print(std::string = " ");
    Node<T>* search(int x);
};

#include "btree.tpp"

#endif //TEMA2_BTREE_H

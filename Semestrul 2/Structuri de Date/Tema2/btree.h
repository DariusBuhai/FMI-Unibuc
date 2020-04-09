//
// Created by Darius Buhai on 4/1/20.
//

#include <vector>
#include <string>

#ifndef TEMA2_BTREE_H
#define TEMA2_BTREE_H

class Node{
private:
    void splitChild(int, Node*);

    void borrowFromPrev(int);
    void borrowFromNext(int);

    void merge(int);
    void fill(int);

    int getPred(int);
    int getSucc(int);

    void removeFromLeaf(int);
    void removeFromNonLeaf(int);

protected:
    std::vector<int> keys;
    std::vector<Node*> childs;
    const int t;
    int n;
    bool isLeaf;
public:

    Node(int = 3, bool = true);

    void traverse(std::vector<int>&);
    Node *search(int);

    bool isFull();

    void appendChild(int);
    void removeChild(int);

    friend class BTree;
};

class BTree{
    Node *root; // Pointer to root node
    const int t;  // Minimum degree
public:
    BTree(int = 3);

    Node* search(int);
    std::vector<int> traverse();
    void print(std::string = " ");
    
    void insert(int);
    void insert(std::vector<int>);
    void remove(int);
};

#endif //TEMA2_BTREE_H

//
// Created by Darius Buhai on 4/1/20.
//

#include <vector>
#include <iostream>
#include "btree.h"

using namespace std;

template <typename T>
Node<T>::Node(int t, bool isLeaf): t(t), isLeaf(isLeaf){}

template <typename T>
Node<T>::Node(std::vector<T> keys, int t, bool isLeaf): keys(keys), t(t), isLeaf(isLeaf){}

template <typename T>
bool Node<T>::isFull() { return this->size()==2*t-1; }

template <typename T>
int Node<T>::size() { return this->keys.size(); }

template <typename T>
void Node<T>::split_child(int i) {
    Node *child = this->childs[i];
    Node *rchild = new Node(child->t, child->isLeaf);

    for (int j = 0; j < t-1; j++)
        rchild->keys.emplace_back(child->keys[j+t]);

    if (!rchild->isLeaf){
        for (int j = 0; j < t; j++)
            rchild->childs.emplace_back(child->childs[j+t]);
        child->childs.resize(t);
    }
    child->keys.resize(t-1);

    childs.emplace_back(nullptr);
    for (int j = size(); j >= i+1; j--)
        childs[j+1] = childs[j];
    childs[i+1] = rchild;

    keys.emplace_back(0);
    for (int j = size()-1; j >= i; j--)
        keys[j+1] = keys[j];
    keys[i] = child->keys[t-1];
}

template <typename T>
void Node<T>::append_child(T x) {
    int i = this->size()-1;
    if(this->isLeaf){
        this->keys.push_back(0);
        while(i>=0 && this->keys[i] > x){
            this->keys[i+1] = this->keys[i];
            i--;
        }
        this->keys[++i] = x;
        return;
    }
    while(i>=0 && this->keys[i] > x)
        i--;
    i++;
    if(childs[i]->isFull()){
        this->split_child(i);
        if (keys[i] < x)
            i++;
    }
    childs[i]->append_child(x);
}

template <typename T>
void Node<T>::fill(int i){
    ///
}

template <typename T>
void Node<T>::remove(T x) {

    /// Search
    int i = 0;
    while(i<=size() && keys[i]<x) i++;

    if(i<size() && keys[i]==x){
        if(isLeaf) remove_from_leaf(x);
        else remove_from_non_leaf(x);
        return;
    }
    if(isLeaf) return;

    bool flag = (i==size());
    if (childs[i]->size() < t) fill(i);
    if(flag && i>size()) i--;
    childs[i]->remove(x);
}

template <typename T>
void Node<T>::traverse(vector<T> &values){
    int i;
    for (i = 0; i < size(); i++){
        if (!isLeaf)
            childs[i]->traverse(values);
        values.push_back(keys[i]);
    }
    if (!isLeaf) childs[i]->traverse(values);
}

template <typename T>
Node<T>* Node<T>::search(T x){

    int i = 0;
    while (i < size() && x > keys[i]) i++;

    if (keys[i] == x) return this;
    if (!isLeaf)return childs[i]->search(x);

    return nullptr;
}

template <typename T>
BTree<T>::BTree(int t): t(t){
    root = nullptr;
}

template <typename T>
BTree<T>::BTree(std::vector<T> values, int t): t(t){
    root = nullptr;
    this->insert(values);
}

template <typename T>
void BTree<T>::insert(T x) {
    if(root==NULL){
        root = new Node<T>({x}, t, true);
        return;
    }
    if(root->isFull()){
        int i = 0;
        Node<T> *newroot = new Node<T>(t);

        newroot->childs.emplace_back(root);
        newroot->split_child(0);

        if (newroot->keys[0] < x) i++;
        newroot->childs[i]->append_child(x);

        root = newroot;
        return;
    }
    root->append_child(x);
}

template <typename T>
void BTree<T>::insert(std::vector<T> values){
    for(auto x: values)
        this->insert(x);
}

template <typename T>
void BTree<T>::insert_string(std::string str){
    if(typeid(T)!=typeid(char)) throw EXIT_FAILURE;
    for(auto x: str) this->insert(x);
}

template <typename T>
void BTree<T>::remove(T x) {
    if(root == nullptr) return;

    root->remove(x);
}

template <typename T>
vector<T> BTree<T>::traverse() {
    vector<T> values;
    if(root!= nullptr)
        root->traverse(values);
    return values;
}

template <typename T>
Node<T>* BTree<T>::search(int x){
    if(root!= nullptr)
        return root->search(x);
    return nullptr;
}

template <typename T>
void BTree<T>::print(string sep) {
    vector<T> values = this->traverse();
    bool alpha = false;
    for(auto x: values){
        if(alpha) cout<<sep;
        alpha = true;
        cout<<x;
    }
}



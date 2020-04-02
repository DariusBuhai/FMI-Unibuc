//
// Created by Darius Buhai on 4/2/20.
//

#include "nfa.h"

#include <iostream>
#include <vector>
#include <queue>
#include <map>

using namespace std;

template <typename T>
Node<T>::Node(int id, bool is_final_state, bool is_start_state): id(id), final_state(is_final_state), start_state(is_start_state){}

template <typename T, T lambda>
void NFA<T, lambda>::read_data(std::istream &in){
    int s, fs, m, ss;
    g.clear();
    in>>s>>m>>fs;
    in>>ss;
    for(int i=0;i<s;i++) g.push_back(new Node<T>(i));
    g[ss]->start_state = true;
    while(fs--){
        int x;
        in>>x;
        g[x]->final_state = true;
    }
    while(m--){
        int a, b;
        T acc;
        in>>a>>b>>acc;
        g[a]->next.push_back({g[b], acc});
    }
}

template <typename T, T lambda>
void NFA<T, lambda>::remove_lambda(Node<T> *v1, Node<T> *v2, int id){
    /// step 1 - remove lambda
    /// step 2 - duplicate moves that starts from v2
    /// step 3 - duplicate initial states
    /// step 4 - duplicate final states
    for(int j=id;j<v1->next.size()-1;j++)
        v1->next[j] = v1->next[j+1];
    v1->next.pop_back();
    for(auto m: v2->next)
        v1->next.push_back(m);
    if(v1->start_state) v2->start_state = true;
    if(v2->start_state) v1->start_state = true;
    if(v1->final_state) v2->final_state = true;
    if(v2->final_state) v1->final_state = true;
}

template <typename T, T lambda>
void NFA<T, lambda>::remove_lambdas(){
    int id;
    for(int i=0;i<g.size();i++){
        id = 0;
        for(auto c : g[i]->next){
            if(c.second==lambda)
                remove_lambda(g[i], c.first, id);
            id++;
        }
    }
}

template <typename T, T lambda>
void NFA<T, lambda>::convert_to_dfa(){

    map<set<int>, map<T, set<int>>> states;
    queue<set<int>> to_add;
    map<T, set<int>> to;

    for(Node<T>* x: this->g)
        if(x->start_state){
            to.clear();
            for(auto s: x->next)
                to[s.second].insert(s.first->id);
            if(to.size()>0) states[{x->id}] = to;
            for(auto t: to)
                if(t.second.size()>1 && states.find(t.second)==states.end())
                    to_add.push(t.second);
            break;
        }

    while(!to_add.empty()){
        set<int> current = to_add.front();
        to_add.pop();
        if(states.find(current)==states.end()){
            to.clear();
            for(int id: current){
                for(auto s: g[id]->next)
                    to[s.second].insert(s.first->id);
            }
            if(to.size()>0) states[current] = to;
            for(auto t: to)
                if(t.second.size()>1 && states.find(t.second)==states.end())
                    to_add.push(t.second);
        }
    }
    map<set<int>, Node<T>*> new_nodes;
    bool final_state, start_state;
    int id = 0;
    for(auto state: states){
        final_state = start_state = false;
        for(auto i: state.first){
            if(g[i]->final_state) final_state = true;
            if(g[i]->start_state) start_state = true;
        }
        new_nodes[state.first] = new Node<T>(id, final_state, start_state);
        id++;
    }
    g.clear();
    for(auto new_node: new_nodes){
        for(auto t: states[new_node.first])
            new_node.second->next.push_back({new_nodes[t.second], t.first});
        g.push_back(new_node.second);
    }

}

template <typename T, T lambda>
void NFA<T, lambda>::remove_inaccessible(){

    set<int> accessible;
    for(auto s: g) {
        for (auto n: s->next)
            accessible.insert(n.first->id);
        if (s->start_state)
            accessible.insert(s->id);
    }
    for(auto s: g)
        if(accessible.find(s->id)==accessible.end()){
            for(int i=s->id;i<g.size()-1;i++)
                g[i] = g[i+1];
            g.pop_back();
        }
}

template <typename T, T lambda>
void NFA<T, lambda>::minimize(){

    this->remove_inaccessible();

    /// Minimization algorithm

}
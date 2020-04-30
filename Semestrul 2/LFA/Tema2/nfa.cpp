//
// Created by Darius Buhai on 4/2/20.
//

#include "nfa.h"

#include <iostream>
#include <vector>
#include <queue>
#include <set>
#include <map>

#define LAMBDA '~'

using namespace std;

Node::Node(int id, bool is_final_state, bool is_start_state): id(id), final_state(is_final_state), start_state(is_start_state){}

vector<Node*> NFA::get_states(bool final_state, bool start_state){
    vector<Node*> states;
    for(auto s:g)
        if(s->start_state==start_state || s->final_state==final_state)
            states.push_back(s);
    return states;
}

void NFA::read_data(std::istream &in){
    int s, fs, m, ss;
    g.clear();
    in>>s>>m>>fs;
    in>>ss;
    for(int i=0;i<s;i++) g.push_back(new Node(i));
    g[ss]->start_state = true;
    while(fs--){
        int x;
        in>>x;
        g[x]->final_state = true;
    }
    while(m--){
        int a, b;
        char acc;
        in>>a>>b>>acc;
        g[a]->next.push_back({g[b], acc});
    }
}

void NFA::remove_lambda(Node *v1, Node *v2, int id){

    /**
     * step 1 - remove lambda
     * step 2 - duplicate moves that starts from v2
     * step 3 - set initial states
     * step 4 - set final states
     */

    for(int j=id;j<v1->next.size()-1;j++)
        v1->next[j] = v1->next[j+1];
    v1->next.pop_back();
    for(auto m: v2->next)
        v1->next.push_back(m);
    if(v1->start_state) v2->start_state = true;
    if(v2->final_state) v1->final_state = true;

}

void NFA::remove_lambdas(){
    /// Algoritmul de pe GeekForGeeks, ceva mai ok nu stiu sa fac
    int id;
    bool found_lambda;
    do{
        found_lambda = false;
        for(auto state: g){
            id = 0;
            for(auto c : state->next){
                if(c.second==LAMBDA){
                    found_lambda = true;
                    remove_lambda(state, c.first, id);
                    break;
                }
                id++;
            }
            if(found_lambda) break;
        }
    }while(found_lambda);
}

void NFA::convert_to_dfa(){

    map<set<int>, map<char, set<int>>> states;
    queue<set<int>> to_add;
    map<char, set<int>> to;

    /** First, add only the start states */
    for(Node* x: this->g)
        if(x->start_state){
            to.clear();
            for(auto s: x->next)
                to[s.second].insert(s.first->id);
            states[{x->id}] = to;
            for(auto t: to)
                if(states.find(t.second)==states.end())
                    to_add.push(t.second);
            break;
        }

    /** While there is a change in the states, group them */
    while(!to_add.empty()){
        set<int> current = to_add.front();
        to_add.pop();
        if(states.find(current)==states.end()){
            to.clear();
            for(int id: current){
                for(auto s: g[id]->next)
                    to[s.second].insert(s.first->id);
            }
            states[current] = to;
            for(auto t: to){
                to_add.push(t.second);
            }

        }
    }

    /** Merge all states and add them in the final graph */
    map<set<int>, Node*> new_nodes;
    bool final_state, start_state;
    int id = 0;
    for(auto state: states){
        final_state = start_state = false;
        for(auto i: state.first){
            if(g[i]->final_state) final_state = true;
            if(g[i]->start_state) start_state = true;
        }
        new_nodes[state.first] = new Node(id, final_state, start_state);
        id++;
    }
    g.clear();
    for(auto new_node: new_nodes){
        for(auto t: states[new_node.first])
            new_node.second->next.push_back({new_nodes[t.second], t.first});
        g.push_back(new_node.second);
    }

}

void NFA::remove_inaccessible(){

    vector<Node*> states, new_states;
    set<int> coaccesible, accessible;

    /** Find all accessible states -- should include only the accesible from the start node */
    states = get_states(false, true);
    for(auto s: g) {
        for (auto n: s->next)
            accessible.insert(n.first->id);
        if (s->start_state)
            accessible.insert(s->id);
    }

    /** Find all coaccesible states */
    states = get_states(true, false);
    while(!states.empty()){
        new_states.clear();
        for(auto state: states){
            coaccesible.insert(state->id);
            for(auto s: g)
                for(auto n: s->next)
                    if(n.first==state){
                        if(coaccesible.find(s->id)==coaccesible.end())
                        new_states.push_back(s);
                        break;
                    }
        }
        states = new_states;
    }

    /** Keep only the accessible and coaccesible states, delete the rest */
    vector<Node*> new_g;
    for(int i=0;i<g.size();i++)
        if(coaccesible.find(g[i]->id)!=coaccesible.end() && accessible.find(g[i]->id)!=accessible.end()){
            Node* to_add = g[i];
            vector<pair<Node*, char>> next;
            for(auto n:to_add->next)
                if(coaccesible.find(n.first->id)!=coaccesible.end() && accessible.find(n.first->id)!=accessible.end())
                    next.push_back(n);
            to_add->next = next;
            new_g.push_back(to_add);
        }
    g.clear();
    g = new_g;
}

void NFA::minimize(){

    /** Minimization algorithm */
    vector<vector<Node*>> partitions;
    partitions.resize(2);
    for(auto x: this->g)
        if(x->final_state) partitions[1].push_back(x);
        else partitions[0].push_back(x);
    bool changed;
    do{
        changed = false;
        /** New partitions */
        vector<vector<Node*>> new_partitions;

        for(auto partition: partitions){
            if(partition.size()==1){
                new_partitions.push_back(partition);
                continue;
            }
            /** Iterate through all pairs of states */
            for(int i=0;i<partition.size();++i){
                for(int j=i+1;j<partition.size();++j){
                    Node *node1 = partition[i], *node2 = partition[j];
                    /** Check if node1 and node2 are distinguishable */
                    bool distinguishable = false;
                    for(auto next1: partition[i]->next){
                        Node *m, *n = nullptr;
                        m = next1.first;
                        for(auto next2: partition[j]->next)
                            if(next2.second==next1.second){
                                n = next2.first;
                                break;
                            }
                        if(n == nullptr){
                            distinguishable = true;
                            break;
                        }
                        int pk1 = 0, pk2 = 0;
                        for (auto p:partitions) {
                            bool found = false;
                            for (auto pn: p)
                                if (pn->id == n->id) {
                                    found = true;
                                    break;
                                }
                            if (found) break;
                            pk1++;
                        }
                        for (auto p:partitions) {
                            bool found = false;
                            for (auto pn: p)
                                if (pn->id == m->id) {
                                    found = true;
                                    break;
                                }
                            if (found) break;
                            pk2++;
                        }
                        if (pk1 != pk2) {
                            distinguishable = true;
                            break;
                        }
                    }
                    /** if node1 and node2 are distinguishable */
                    if(!distinguishable){
                        //cout<<node1->id<<" "<<node2->id<<'\n';
                        bool added = false;
                        for(int k=0;k<new_partitions.size();k++)
                            if(find(new_partitions[k].begin(), new_partitions[k].end(), node1)!=new_partitions[k].end()){
                                if(find(new_partitions[k].begin(), new_partitions[k].end(), node2)==new_partitions[k].end())
                                    new_partitions[k].push_back(node2);
                                added = true;
                                break;
                            }else if(find(new_partitions[k].begin(), new_partitions[k].end(), node2)!=new_partitions[k].end()){
                                if(find(new_partitions[k].begin(), new_partitions[k].end(), node1)==new_partitions[k].end())
                                    new_partitions[k].push_back(node1);
                                added = true;
                                break;
                            }
                        if(!added)
                            new_partitions.push_back({node1, node2});
                    }else{
                        bool found_node_1 = false, found_node_2 = false;
                        for(int k=0;k<new_partitions.size();k++)
                            if(find(new_partitions[k].begin(), new_partitions[k].end(), node1)!=new_partitions[k].end() )
                                found_node_1 = true;
                            else if(find(new_partitions[k].begin(), new_partitions[k].end(), node2)!=new_partitions[k].end())
                                found_node_2 = true;
                        if(!found_node_1) new_partitions.push_back({node1});
                        if(!found_node_2) new_partitions.push_back({node2});
                        changed = true;
                    }
                }
            }
        }
        partitions.clear();
        for(auto new_partition: new_partitions)
            partitions.push_back(new_partition);
    }while(changed);

    /** Merge partitions in states */
    vector<Node*> new_states;
    vector<vector<pair<int, char>>> next_states;
    int id = 0;
    for(auto partition: partitions){
        bool start_state = false, final_state = false;
        vector<pair<int, char>> next;
        for(auto state: partition){
            if(state->final_state) final_state = true;
            if(state->start_state) start_state = true;
            for(auto n: state->next){
                int p_id = 0;
                for(auto partition2: partitions){
                    bool found = false;
                    for(auto node: partition2)
                        if(node->id==n.first->id){
                            found = true;
                            break;
                        }
                    if(found) break;
                    p_id++;
                }
                pair<int, char> to_add = {p_id, n.second};
                if(find(next.begin(), next.end(), to_add)==next.end())
                    next.push_back(to_add);
            }
        }
        next_states.push_back(next);
        Node* node = new Node(id++, final_state, start_state);
        new_states.push_back(node);
    }

    /** Add state in the final graph */
    id = 0;
    g.clear();
    for(auto new_state: new_states){
        vector<pair<Node*, char>> next;
        for(auto n: next_states[id]){
            pair<Node*, char> to_add = {new_states[n.first], n.second};
            if(find(next.begin(), next.end(), to_add)==next.end())
                next.push_back(to_add);
        }
        id++;
        new_state->next = next;
        g.push_back(new_state);
    }
}

void NFA::write(std::ostream& out, bool show_details) {
    if(show_details) out<<"Numar stari: ";
    out<<g.size()<<'\n';
    if(show_details) out<<"Stare initiala: ";
    for(auto state: g)
        if(state->start_state){
            out<<state->id<<' ';
            break;
        }
    out<<'\n';
    if(show_details) out<<"Stari finale: ";
    for(auto state: g)
        if(state->final_state)
            out<<state->id<<' ';
    out<<'\n';
    for(auto state: g)
        for(auto n: state->next)
            out<<state->id<<' '<<n.first->id<<' '<<n.second<<'\n';
    out<<'\n';
}
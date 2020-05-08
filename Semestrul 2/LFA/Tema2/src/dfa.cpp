#include "../include/dfa.h"
#include "../include/state.h"

#include <iostream>
#include <vector>
#include <set>
#include <map>
#include <string>

#define LAMBDA '~'

using namespace std;

void DFA::strip_char(std::string& str, const char ch) {
    string new_string;
    for(auto c: str)
        if(c!=ch)
            new_string.push_back(c);
    str = new_string;
}

void DFA::strip_lambdas(){
    for(auto &state: states)
        for(auto &n: state->next)
            strip_char(n.second, LAMBDA);
}

void DFA::remove_from_states(State* state){
    bool found_state = false;
    for(int i=0;i<states.size();i++){
        if(!found_state && states[i]==state)
            found_state = true;
        if(found_state)
            states[i] = states[i+1];
    }
    states.pop_back();
}

vector<pair<State*, pair<State*, string>>> DFA::get_all_inputs(State* state){
    vector<pair<State*, pair<State*, string>>> in;
    for(auto &i : states){
        vector<pair<State*, string>> new_next;
        for(auto &n: i->next)
            if(n.first == state)
                in.emplace_back(i, n);
            else
                new_next.emplace_back(n);
        i->next.clear();
        i->next = new_next;
    }
    return in;
}

void DFA::remove_state(State* state){
    /// Find all connections ( in and out )
    vector<pair<State*, string>> out;
    out = state->next;
    auto in = get_all_inputs(state);
    /// Remove from states vector
    remove_from_states(state);
    /// Connect loops
    string loop;
    for(auto const & input: in)
        if(input.first==state){
            if(!loop.empty()) loop+="+";
            loop += input.second.second;
        }
    if(loop.size()>1) loop = "("+loop+")";
    if(!loop.empty()) loop += "*";
    /// Connect all inputs to the outputs
    for(auto &input: in)
        for(auto const& output: out){
            if(output.first!=state)
                input.first->next.emplace_back(output.first, input.second.second+loop+output.second);
        }
    /// Merge states that are the same
    for(auto &input: in){
        map<State*, vector<pair<State*, string>>> connections;
        for(auto &x: input.first->next)
            connections[x.first].push_back(x);
        if(connections.size()!=input.first->next.size()){
            input.first->next.clear();
            for(const auto& con: connections){
                string cost;
                for(const auto& a: con.second){
                    if(!cost.empty()) cost+="+";
                    cost+=a.second;
                }
                input.first->next.emplace_back(con.first, cost);
            }
        }
    }
    /// Free space
    delete state;
}

string DFA::get_regex(){
    /// Step 1 - add new start state, with lambda connection
    states.push_back(nullptr);
    for(int i = static_cast<int>(states.size()-1);i>0;i--){
        states[i] = states[i-1];
        states[i]->id++;
    }
    int start_state =0;
    for(auto const&state: states)
        if(state->start_state){
            start_state = state->id;
            break;
        }
    states[0] = new State(0, false, true);
    states[start_state]->start_state = false;
    states[0]->next.emplace_back(states[start_state], string(1, LAMBDA));
    /// Step 2 - add new final state and connect old final states
    states.push_back(new State(states.size(), true, false));
    for(int i=1;i<states.size()-1;i++)
        if(states[i]->final_state){
            states[i]->final_state = false;
            states[i]->next.emplace_back(states.back(), string(1, LAMBDA));
        }
    /// Step 3, remove all states, one by one
    bool removed_state;
    do{
        remove_state(states[1]);
    }while(states.size()>2);
    /// Clear lambdas
    strip_lambdas();
    /// Return regex
    if(!states.empty() && !states[0]->next.empty())
        return states[0]->next[0].second;
    return "";
}

void DFA::minimize(){
    /** Minimization algorithm */
    vector<vector<State*>> partitions;
    partitions.resize(2);
    for(auto x: this->states)
        if(x->final_state) partitions[1].push_back(x);
        else partitions[0].push_back(x);
    bool changed;
    do{
        changed = false;
        /** New partitions */
        vector<vector<State*>> new_partitions;

        for(auto partition: partitions){
            if(partition.size()==1){
                new_partitions.push_back(partition);
                continue;
            }
            /** Iterate through all pairs of states */
            for(int i=0;i<partition.size();++i){
                for(int j=i+1;j<partition.size();++j){
                    State *State1 = partition[i], *State2 = partition[j];
                    /** Check if State1 and State2 are distinguishable */
                    bool distinguishable = false;
                    for(const auto& next1: partition[i]->next){
                        State *m, *n = nullptr;
                        m = next1.first;
                        for(const auto& next2: partition[j]->next)
                            if(next2.second==next1.second){
                                n = next2.first;
                                break;
                            }
                        if(n == nullptr){
                            distinguishable = true;
                            break;
                        }
                        int pk1 = 0, pk2 = 0;
                        for (const auto& p:partitions) {
                            bool found = false;
                            for (auto pn: p)
                                if (pn->id == n->id) {
                                    found = true;
                                    break;
                                }
                            if (found) break;
                            pk1++;
                        }
                        for (const auto& p:partitions) {
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
                    /** if State1 and State2 are distinguishable */
                    if(!distinguishable){
                        //cout<<State1->id<<" "<<State2->id<<'\n';
                        bool added = false;
                        for(auto & new_partition : new_partitions)
                            if(find(new_partition.begin(), new_partition.end(), State1)!=new_partition.end()){
                                if(find(new_partition.begin(), new_partition.end(), State2)==new_partition.end())
                                    new_partition.push_back(State2);
                                added = true;
                                break;
                            }else if(find(new_partition.begin(), new_partition.end(), State2)!=new_partition.end()){
                                if(find(new_partition.begin(), new_partition.end(), State1)==new_partition.end())
                                    new_partition.push_back(State1);
                                added = true;
                                break;
                            }
                        if(!added)
                            new_partitions.push_back({State1, State2});
                    }else{
                        bool found_State_1 = false, found_State_2 = false;
                        for(auto & new_partition : new_partitions)
                            if(find(new_partition.begin(), new_partition.end(), State1)!=new_partition.end() )
                                found_State_1 = true;
                            else if(find(new_partition.begin(), new_partition.end(), State2)!=new_partition.end())
                                found_State_2 = true;
                        if(!found_State_1) new_partitions.push_back({State1});
                        if(!found_State_2) new_partitions.push_back({State2});
                        changed = true;
                    }
                }
            }
        }
        partitions.clear();
        for(const auto& new_partition: new_partitions)
            partitions.push_back(new_partition);
    }while(changed);
    /** Merge partitions in states */
    vector<State*> new_states;
    vector<vector<pair<int, string>>> next_states;
    int id = 0;
    for(const auto& partition: partitions){
        bool is_start_state = false, is_final_state = false;
        vector<pair<int, string>> next;
        for(auto state: partition){
            if(state->final_state) is_final_state = true;
            if(state->start_state) is_start_state = true;
            for(const auto& n: state->next){
                int p_id = 0;
                for(const auto& partition2: partitions){
                    bool found = false;
                    for(auto State: partition2)
                        if(State->id==n.first->id){
                            found = true;
                            break;
                        }
                    if(found) break;
                    p_id++;
                }
                pair<int, string> to_add = {p_id, n.second};
                if(find(next.begin(), next.end(), to_add)==next.end())
                    next.push_back(to_add);
            }
        }
        next_states.push_back(next);
        auto* new_state = new State(id++, is_final_state, is_start_state);
        new_states.push_back(new_state);
    }

    /** Add state in the final graph */
    id = 0;
    states.clear();
    for(auto new_state: new_states){
        vector<pair<State*, string>> next;
        for(const auto& n: next_states[id]){
            pair<State*, string> to_add = {new_states[n.first], n.second};
            if(find(next.begin(), next.end(), to_add)==next.end())
                next.push_back(to_add);
        }
        id++;
        new_state->next = next;
        states.push_back(new_state);
    }
    /// Remove all inaccessible states
    this->remove_inaccessible();
}

void DFA::remove_inaccessible(){

    vector<State*> states, new_states;
    set<int> coaccesible, accessible;

    /** Find all accessible states -- should include only the accesible from the start node */
    states = get_states(false, true);
    for(auto s: states) {
        for (const auto& n: s->next)
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
            for(auto s: states)
                for(const auto& n: s->next)
                    if(n.first==state){
                        if(coaccesible.find(s->id)==coaccesible.end())
                            new_states.push_back(s);
                        break;
                    }
        }
        states = new_states;
    }

    /** Keep only the accessible and coaccesible states, delete the rest */
    vector<State*> new_g;
    for(auto & state : states)
        if(coaccesible.find(state->id)!=coaccesible.end() && accessible.find(state->id)!=accessible.end()){
            State* to_add = state;
            vector<pair<State*, string>> next;
            for(const auto& n:to_add->next)
                if(coaccesible.find(n.first->id)!=coaccesible.end() && accessible.find(n.first->id)!=accessible.end())
                    next.push_back(n);
            to_add->next = next;
            new_g.push_back(to_add);
        }
    states.clear();
    states = new_g;
}
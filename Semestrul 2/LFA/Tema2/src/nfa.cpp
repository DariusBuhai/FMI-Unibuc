#include "../include/nfa.h"
#include "../include/state.h"

#include <iostream>
#include <utility>
#include <vector>
#include <queue>
#include <set>
#include <map>

#define LAMBDA '~'

using namespace std;

NFA::NFA(std::vector<State *> _states): states(std::move(_states)){}

NFA::NFA(NFA const &_old): states(_old.states){}

void NFA::remove_lambda(State *v1, State *v2, int id){
    /**
     * step 1 - remove lambda
     * step 2 - duplicate moves that starts from v2
     * step 3 - set initial current_states
     * step 4 - set final current_states
     */
    for(int j=id;j<v1->next.size()-1;j++)
        v1->next[j] = v1->next[j+1];
    v1->next.pop_back();
    for(const auto& m: v2->next)
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
        for(auto state: states){
            id = 0;
            for(auto c : state->next){
                if(c.second == string(1,LAMBDA)){
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
    map<set<int>, map<string, set<int>>> current_states;
    queue<set<int>> to_add;
    map<string, set<int>> to;
    int start_state_id;
    /** First, add only the start current_states */
    for(State* x: states)
        if(x->start_state){
            start_state_id = x->id;
            for(const auto& s: x->next)
                to[s.second].insert(s.first->id);
            current_states[{x->id}] = to;
            for(const auto& t: to)
                if(current_states.find(t.second)==current_states.end())
                    to_add.push(t.second);
            break;
        }
    /** While there is a change in the current_states, group them */
    while(!to_add.empty()){
        set<int> current = to_add.front();
        to_add.pop();
        if(current_states.find(current)==current_states.end()){
            to.clear();
            for(int id: current){
                for(const auto& s: states[id]->next)
                    to[s.second].insert(s.first->id);
            }
            current_states[current] = to;
            for(const auto& t: to){
                to_add.push(t.second);
            }
        }
    }
    /** Merge all current_states and add them in the final graph */
    map<set<int>, State*> new_nodes;
    bool is_final_state, is_start_state;
    int id = 0;
    for(const auto& state: current_states){
        is_final_state = is_start_state = false;
        for(auto i: state.first)
            if(states[i]->final_state) is_final_state = true;
        if(state.first.size()==1 && state.first.find(start_state_id)!=state.first.end())
            is_start_state = true;
        new_nodes[state.first] = new State(id, is_final_state, is_start_state);
        id++;
    }
    states.clear();
    for(const auto& new_node: new_nodes){
        for(const auto& t: current_states[new_node.first])
            new_node.second->next.emplace_back(new_nodes[t.second], t.first);
        states.push_back(new_node.second);
    }
}

std::vector<State *> NFA::get_states() const{
    return this->states;
}

vector<State*> NFA::get_states(bool final_state, bool start_state){
    vector<State*> new_states;
    for(auto s:states)
        if(s->start_state==start_state || s->final_state==final_state)
            new_states.push_back(s);
    return new_states;
}

std::istream& operator>>(std::istream& in, NFA &nfa){
    int s, fs, m, ss;
    nfa.states.clear();
    in>>s>>m>>fs;
    in>>ss;
    for(int i=0;i<s;i++) nfa.states.push_back(new State(i));
    nfa.states[ss]->start_state = true;
    while(fs--){
        int x;
        in>>x;
        nfa.states[x]->final_state = true;
    }
    while(m--){
        int a, b;
        string acc;
        in>>a>>b>>acc;
        nfa.states[a]->next.emplace_back(nfa.states[b], acc);
    }
    return in;
}

ostream & operator<<(std::ostream& out, const NFA & nfa) {
    int cnt_final = 0, cnt_next = 0;
    for(auto state: nfa.states)
        if(state->final_state)
            cnt_final++;
    for(auto state: nfa.states)
        for(auto n: state->next)
            cnt_next++;
    out<<nfa.states.size()<<' '<<cnt_next<<' '<<cnt_final<<'\n';
    for(auto state: nfa.states)
        if(state->start_state){
            out<<state->id<<' ';
            break;
        }
    out<<'\n';
    for(auto state: nfa.states)
        if(state->final_state)
            out<<state->id<<' ';
    out<<'\n';
    for(auto state: nfa.states)
        for(const auto& n: state->next)
            out<<state->id<<' '<<n.first->id<<' '<<n.second<<'\n';
    out<<'\n';
    return out;
}
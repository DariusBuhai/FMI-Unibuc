#include <iostream>
#include <fstream>
#include <vector>
#include <map>

#define LAMBDA '~'

using namespace std;

struct State{
    bool start_state, final_state;
    vector<pair<State*, string>> next;
    int id;
    State(int _id, bool _start_state = false, bool _final_state = false){
        this->id = _id;
        this->start_state = _start_state;
        this->final_state = _final_state;
    }
};
vector<State*> states;
int n, m, o, start_state;

void read_dfa(std::istream& in){
    int a, b;
    char x;
    in>>n>>m>>o>>a;
    for(int i=0;i<n;i++)
        states.push_back(new State(i));
    start_state = a;
    states[start_state]->start_state = true;
    while(o--){
        in>>a;
        states[a]->final_state = true;
    }
    for(int i=0;i<m;i++){
        in>>a>>b>>x;
        states[a]->next.emplace_back(states[b], string(1, x));
    }
}

void strip_char(std::string& str, const char ch) {
    string new_string;
    for(auto c: str)
        if(c!=ch)
            new_string.push_back(c);
    str = new_string;
}

void strip_lambdas(){
    for(auto &state: states)
        for(auto &n: state->next)
            strip_char(n.second, LAMBDA);
}

void remove_from_states(State* state){
    bool found_state = false;
    for(int i=0;i<states.size();i++){
        if(!found_state && states[i]==state)
            found_state = true;
        if(found_state)
            states[i] = states[i+1];
    }
    states.pop_back();
}

vector<pair<State*, pair<State*, string>>> get_all_inputs(State* state){
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

void remove_state(State* state){
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

void convert_to_regex(){
    /// Step 1 - add new start state, with lambda connection
    states.push_back(nullptr);
    for(int i = static_cast<int>(states.size()-1);i>0;i--){
        states[i] = states[i-1];
        states[i]->id++;
    }
    states[0] = new State(0, true);
    states[start_state+1]->start_state = false;
    states[0]->next.emplace_back(states[start_state+1], string(1, LAMBDA));
    start_state = 0;
    /// Step 2 - add new final state and connect old final states
    states.push_back(new State(states.size(), false, true));
    for(int i=1;i<states.size()-1;i++)
        if(states[i]->final_state){
            states[i]->final_state = false;
            states[i]->next.emplace_back(states.back(), string(1, LAMBDA));
        }
    /// Step 3, remove all states, one by one
    bool removed_state;
    do{
        removed_state = false;
        for(int i=1;i<states.size()-1;i++)
            if(!states[i]->final_state && !states[i]->start_state){
                remove_state(states[i]);
                removed_state = true;
                break;
            }
    }while(removed_state);
    /// Clear lambdas
    strip_lambdas();
}

void write_as_dfa(std::ostream& out){
    out<<states.size()<<'\n'<<start_state<<'\n';
    for(auto state: states)
        if(state->final_state)
            out<<state->id<<' ';
    out<<'\n';
    for(auto state: states)
        for(auto n: state->next)
            out<<state->id<<' '<<n.first->id<<' '<<n.second<<'\n';
    out<<'\n';
}

void write_as_regex(std::ostream& out){
    out<<states[0]->next[0].second<<'\n';
}

int main() {
    ifstream fin("dfa.in");
    ofstream fout("dfa.out");
    
    read_dfa(fin);
    convert_to_regex();
    //write_as_dfa(cout);
    write_as_regex(fout);
    return 0;
}

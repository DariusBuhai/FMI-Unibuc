#include "../include/reggram.h"
#include "../include/dfa.h"

#include <iostream>
#include <vector>
#include <string>

#define LAMBDA '~'

using namespace std;

NFA REGGRAM::get_nfa() {
    NFA nfa;
    map<string, int> rename;
    for(auto& g: grammar){
        bool is_start_state = false;
        if(g.first==start_state) is_start_state = true;
        rename[g.first] = nfa.push_state(new State(false, is_start_state));
    }
    auto* final_state = new State(true, false);
    nfa.push_state(final_state);
    int idx = 0;
    for(const auto& g: grammar){
        for(const auto& s: g.second){
            State* conn = final_state;
            if(s.size()>1)
                conn = nfa[rename[s.substr(1)]];
            nfa[idx]->next.emplace_back(conn, s.substr(0,1));
        }
        idx++;
    }
    return nfa;
}

void REGGRAM::remove_lambdas(){

}

std::istream& operator>>(std::istream& in, REGGRAM& _reggram){
    int n;
    in>>n;
    while(n--){
        string a, b;
        in>>a>>b;
        if(_reggram.start_state.empty()) _reggram.start_state = a;
        _reggram.grammar[a].push_back(b);
    }
    return in;
}

std::ostream& operator<<(std::ostream& out, const REGGRAM& _reggram){
    for(const auto& g: _reggram.grammar){
        out<<g.first<<' ';
        for(int i=0;i<g.second.size();i++){
            if(i>0) out<<" | ";
            out<<g.second[i];
        }
        out<<'\n';
    }
    out<<'\n';
    return out;
}


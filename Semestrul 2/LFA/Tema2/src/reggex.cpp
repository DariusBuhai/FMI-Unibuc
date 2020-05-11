#include <iostream>
#include <string>
#include <vector>
#include <set>

#include "../include/reggex.h";

using namespace std;

REGGEX::REGGEX(std::string _syntax): syntax(_syntax){}

string REGGEX::minimize_string(string _syntax){
    set<string> options;
    string last_option;
    auto next_p = [](string in){
        int m = 1;
        for(int i=0;i<in.size();i++){
            if(in[i]=='(') m++;
            if(in[i]==')') m--;
            if(m==0) return i;
        }
        return -1;
    };
    for(int i=0;i<_syntax.size();i++){
        if(_syntax[i]=='+'){
            options.insert(last_option);
            last_option.clear();
        }
        else if(_syntax[i]=='('){
            int np = next_p(_syntax.substr(i+1));
            if(np!=-1){
                last_option+='('+minimize_string(_syntax.substr(i+1, np))+')';
                i += np+1;
            }
        }else
            last_option+=_syntax[i];
    }
    if(!last_option.empty()) options.insert(last_option);
    string final;
    for(const auto& o: options){
        if(!final.empty()) final+="+";
        final+=o;
    }
    return final;
}

void REGGEX::minimize() {
    this->syntax = this->minimize_string(this->syntax);
}


std::istream& operator>>(std::istream& in, REGGEX &reggex){
    in>>reggex.syntax;
    return in;
}

ostream & operator<<(std::ostream& out, const REGGEX & reggex) {
    out<<reggex.syntax<<'\n';
    return out;
}
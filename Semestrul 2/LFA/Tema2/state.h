//
// Created by Darius Buhai on 5/8/20.
//

#include <vector>
#include <iostream>
#include <string>

#ifndef TEMA2_STATE_H
#define TEMA2_STATE_H

struct State{
    std::vector<std::pair<State*, std::string>> next;
    bool final_state, start_state;
    int id;

    State(int id = 0, bool is_final_state = false, bool is_start_state = false): id(id), final_state(is_final_state), start_state(is_start_state){}
};

#endif //TEMA2_STATE_H

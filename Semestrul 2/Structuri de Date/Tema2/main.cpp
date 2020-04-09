#include <iostream>
#include <vector>
#include <random>

#include "btree.h"

using namespace std;

int main() {
    BTree t(3);
    t.insert({1,3,7,10,11,13,14,15,18,16,19,24,25,26,21,4,5,20,22,2,17,12,6});

    t.print();

    t.remove(6);
    cout << "Traversal of tree after removing 6\n";
    t.print();

    t.remove(13);
    cout << "Traversal of tree after removing 13\n";
    t.print();

    t.remove(7);
    cout << "Traversal of tree after removing 7\n";
    t.print();

    t.remove(4);
    cout << "Traversal of tree after removing 4\n";
    t.print();

    t.remove(2);
    cout << "Traversal of tree after removing 2\n";
    t.print();

    t.remove(16);
    cout << "Traversal of tree after removing 16\n";
    t.print();

    return 0;
}

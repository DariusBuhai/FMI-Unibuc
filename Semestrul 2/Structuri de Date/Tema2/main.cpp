#include <iostream>
#include <vector>
#include <random>

#include "btree.h"

using namespace std;

/// Clasele se bazeaza pe template-uri ( typename default = int )
/// In g++ 14 codul functioneaza, in schimb
/// linkarea pentru alte compilatoare s-ar putea sa nu fie buna

int main() {
    BTree<> t;
    t.insert({10,20,5,6,12,30,7,6,78,2000, 7, 12, 90, 11, 23, 11, 214, 121, 11, 8781, 121});

    for(int i=0;i<45;i++)
        t.insert(rand() % 100);

    t.print(", ");

    return 0;
}

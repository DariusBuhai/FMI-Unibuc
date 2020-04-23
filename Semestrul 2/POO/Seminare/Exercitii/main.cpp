#include <iostream>
#include <cstdio>

using namespace std;

class C{
    int * const p;
public:
    C(int x): p(&x) {(*p)+=3;}
    void set(int x){
        *p = x;
    }
    friend ostream& operator<<(ostream& o, C x){
        o<<*x.p;return o;
    }
};

int main() {
    C c(3);
    cout<<c;
    return 0;
}

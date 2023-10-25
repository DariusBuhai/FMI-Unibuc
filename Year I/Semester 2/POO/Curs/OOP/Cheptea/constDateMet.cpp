#include <cstdlib>
#include <iostream>
#include <fstream>
using namespace std;

class C
{ int nc;
 const int c;
static const int cs1=1; // nu se mai redeclara in afara clasei

public:
 C(int k):c(k) //initializarea doar in lista de initializare
              {nc=1;
              // c=1; // eroare nu pot folosi = pt const ;
              }
 const int * fnc(){return &nc;} //functia intoarce un pointer prin care nu pot modifica un int
                                // nu este functie constanta
 void fc() const {}//nc++;// nu pot modifica datele obiectului apelat

};




int main()
{
 C o1(1);
 o1.fnc();o1.fc(); // obiectele neconst pot apela metode const si neconst

 const C o2(2);  // obiect const
 o2.fc();    //obiectele const nu pot apela decat functii const
// o2.fnc(); //obiectele const nu pot apela  functii neconst

 const C *p; // prin pointer nu se poate modifica zona
 p=&o1;
 p->fc();
// p->fnc(); //prin pointer care nu modifica zona nu pot apela decat functii const

}


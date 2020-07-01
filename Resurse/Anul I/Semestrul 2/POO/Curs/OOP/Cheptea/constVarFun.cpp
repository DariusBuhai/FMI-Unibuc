#include <cstdlib>
#include <iostream>
#include <fstream>
using namespace std;
const int ic=1;
int i=1, j=1;
const int *p; // pointer spre o zona considerata constanta
int * const pc=&i; //pointer constant

const int &ri=i;

void f1(int i){i=1;} // modifica copia parametrului actual
void f2(int *pi){*pi=1;}// modifica variabila adresata de parametrul actual
void f3(const int *pi){}// nu pot modifica  prin parametrul actual variabila adresata (de parametrul actual)
void f4(int &ri){ri=1;} // modific zona parametrului actual prin parametrul formal (alt nume pentru zona parametrului actual)
void f5(const int &ri){}// nu pot modifica parametrul actual prin parametrul formal


int main()
{ p=&i;
  i=2;   // pot modifica zona
//*p=2; // nu pot modifica zona prin pointer
 *pc=2;
 //pc=&j; //nu pot modifica pointerul

 i=2;
 // ri=2; // nu pot modifica zona prin ri
}


#include <cstdlib>
#include <iostream>
using namespace std;
struct complex
{float re,im;
 } a,b;
complex c;

// complex este tip de date
// a,b,c sunt variabile de tipul complex
// accesul la cimpuri -implicit este public-din orice punct al programului

class Complex
{
  float re,im;
public: void f();
} A,B;
Complex C;

// Complex este un tip de date
// A,B,C sunt variabile de tipul Complex -se numesc obiecte sau instante ale clasei Complex
//  cimpurile: re,im  se numesc date
//functiile:  f, se numesc metode
// datele si metodele sunt membrii ai clasei
// implicit specificatorul de acces este private: -am acces la membrii privati  (ai tuturor obiectelor) doar intr-o metoda a clasei

// struct este analog class -mostenire, constructori, destructori, etc
//folosim  struct -fara functii,mostenire, etc
//folosim  class cu functii , mostenire, etc

// definim functia f din clasa Complex- putem avea o alta clasa class Clasa1{void f()};
// o diferentiem de metoda din clasa Clasa1: void Clasa1::f(){}


// functia poate fi apelata doar de catre un obiect =obiectul implicit
//exemplu :  A.f();-obiectul implicit este A
 // exemplu: B.f();-obiectul implicit este B
//this este adresa obiectului  are apeleaza metoda-existent in orice metoda nestatica
//* this este chiar obiectul care apeleaza metoda
//exemplu pt A.f() ; * this  este chiar A
//                  B.f() ; * this  este chiar B
// pot accesa datele si metodele obiectului care apeleaza metoda
// (*this).im=0;   echivalent cu:
// this->im=0 ;    echivalent cu :
// im=0;
void Complex :: f()
{ im=1;  // data an a obiectului care apeleaza metoda -echivalent cu :
(*this).im=0;
Complex D;
D.im=0; // din  metoda pot accesa datele private ale TUTUROR obiectelor
}

int main()
{ A.f();
   B.f();
}



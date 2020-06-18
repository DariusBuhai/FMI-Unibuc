#include <stdio.h>
#include <stdlib.h>
#include<iostream>
using namespace std;

class A{
    int x;
public:
    int get_x(){return x;} ///exemplu getter
    void set_x(int y){ x = y;} ///
    A(int y=100){x = y;}
    //A(){x = 100;}
};

int main()
{
    A ob; /// constructor de initializare
    //cin>>ob.x;
    ///ob.set_x(45);
    cout<<ob.get_x()<<endl;

    A ob2(45); /// constructor parametrizat
    cout<<ob2.get_x()<<endl;

    A ob3(ob); /// constructor de copiere cel default
    cout<<ob3.get_x()<<endl;

    A ob4 = ob; /// constructor de copiere cel default
cout<<ob4.get_x();

    A ob5;/// constructor de initializare pt ob5
    ob5 = ob; /// + operator de atribuire pentru ob5
    cout<<ob5.get_x();
}

/*
class A{
public:
void f(); ///antet
};

class B{
public:
void f(); ///antet
};

void A::f() ///antet+corp
{
    cout<<"Clasa A\n";
}

void B::f() ///antet+corp
{
    cout<<"Clasa B\n";
}

int main()
{
    A ob1;
    ob1.f();
    B ob2;
    ob2.f();
}
*/

/*
class A{
    //public:
int x,y;
public:
void f(); ///antet
};

void A::f() ///antet+corp
{
    cin>>x;
}

int main()
{
    A v;
    v.f();
   //cin>>v.x;
    return 0;
}
*/

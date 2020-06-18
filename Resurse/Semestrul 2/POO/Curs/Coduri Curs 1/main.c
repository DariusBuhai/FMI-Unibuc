#include <stdio.h>
#include <stdlib.h>

struct A{
int x,y;

void f()
{
    scanf("%d",&x);
}
};

/*
void f(struct A ob)
{
    scanf("%d",&ob.x);
}*/

int main()
{
    struct A v;
   // f(v);
   v.f();
    return 0;
}

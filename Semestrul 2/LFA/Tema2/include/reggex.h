#include <iostream>
#include <string>

#ifndef TEMA2_REGGEX_H
#define TEMA2_REGGEX_H

class REGGEX{
    std::string syntax;
    std::string minimize_string(std::string);
public:
    REGGEX(std::string);

    void minimize();

    friend std::istream& operator>>(std::istream&, REGGEX&);
    friend std::ostream& operator<<(std::ostream&, const REGGEX&);
};

#endif //TEMA2_REGGEX_H

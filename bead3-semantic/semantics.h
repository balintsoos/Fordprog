#ifndef SEMANTICS_H
#define SEMANTICS_H

#include <string>
#include <iostream>
#include <cstdlib>

enum type { Natural, Bool };

struct expression_def
{
    int line;
    type expType;
    expression_def(int l, type t)
        : line(l), expType(t) {}
};

#endif //SEMANTICS_H

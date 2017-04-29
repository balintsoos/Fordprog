#ifndef SEMANTICS_H
#define SEMANTICS_H

#include <string>
#include <iostream>
#include <cstdlib>

enum type { Natural, Bool };

struct variable_def
{
  int line;
  type varType;

  variable_def(int l = 0, type t = Natural)
    : line(l), varType(t) {}
};

struct expression_def
{
  int line;
  type expType;

  expression_def(int l, type t)
    : line(l), expType(t) {}
};

struct statement_def
{
  int line;

  statement_def(int l)
    : line(l) {}
};

#endif //SEMANTICS_H

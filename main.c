
#include <memory.h>
#include <stdio.h>
#include "formula.h"

// array for searching formula
formula_t formula_array[] = {
        {"add", &fp_add},
        {"subtract", &fp_subtract},
        {"multiply", &fp_multiply},
};

void get_formula(char *formula_type, int left_spec, int right_spec)
{
    int i=0;
    char str[80];

    for(i=0;i<sizeof(formula_array);i++)
    {
        if(strcmp(formula_type, formula_array[i].formula_type)==0) {
            sprintf(str, "the sum is %d", formula_array[i].formula(left_spec, right_spec));
            puts(str);

            return;
        }
    }

    sprintf(str, "error *** can't find %s", formula_type);
    puts(str);
}

int main()
{
    get_formula("add", 2,2);
    get_formula("subtract", 2,2);
    get_formula("multiply", 2,2);

    return 0;
}



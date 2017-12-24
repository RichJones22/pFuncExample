
#ifndef FIRSTPROJECT_FUNCTIONS_H
#define FIRSTPROJECT_FUNCTIONS_H

    // function pointer type
    typedef int (*fp_formula)(int,int);

    // struct for formula array
    struct formula_struct {
        char formula_type[10];
        fp_formula formula;
    };

    // type for formula array
    typedef struct formula_struct formula_t;

    // function prototypes
    int fp_add(int right_spec, int left_spec);
    int fp_subtract(int right_spec, int left_spec);
    int fp_multiply(int right_spec, int left_spec);
#endif //FIRSTPROJECT_FUNCTIONS_H
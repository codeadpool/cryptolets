#ifndef PARAMS_H
#define PARAMS_H

#include <ac_int.h>

// Enums
#define MRED_MONT 0
#define MRED_BAR 1
#define FIXED_Q 0
#define VAR_Q 1
#define FIXED_RC 0
#define VAR_RC 1
#define MUL_NOR 0
#define MUL_SB 1
#define MUL_KAR 2
#define MUL_OUTPUT_FULL 0
#define MUL_OUTPUT_LO 1
#define MUL_OUTPUT_HI 2
#define CMUL_OUTPUT_FULL 0
#define CMUL_OUTPUT_LO 1
#define CMUL_OUTPUT_HI 2
#define PDBL_A0 0
#define PDBL_A3 1
#define PDBL_AVAR 2
#define PADD_TE_ADD 0
#define PADD_TE_CYCLONE 1
// Parameters
#define BITWIDTH 381
#define MRED MRED_MONT
#define Q_TYPE FIXED_Q
#define RC_TYPE FIXED_RC
#define MUL_TYPE MUL_KAR
#define BASE_MUL_WIDTH 64
#define KAR_BASE_MUL_WIDTH 192
// Structs
struct BLS12_381_BASE {
    static constexpr int W = 381;
    struct Q {
        static constexpr int W = 381;
        static ac_int<381, false> VALUE() {
            ac_int<381, false> v;
            v.bit_fill_hex("1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaab");
            return v;
        }
    };
    struct Q_PRIME {
        static constexpr int W = 381;
        static ac_int<381, false> VALUE() {
            ac_int<381, false> v;
            v.bit_fill_hex("eb06106feaafc9468b316fee268cf5819ecca0e8eb2db4c16ef2ef0c8e30b48286adb92d9d113e889f3fffcfffcfffd");
            return v;
        }
    };
    struct MU {
        static constexpr int W = 382;
        static ac_int<382, false> VALUE() {
            ac_int<382, false> v;
            v.bit_fill_hex("2760d74bcf32791738a0406c331e9ae8a46e09d07fda82a52f7d1dc780a19de74e65c59e8163c701ec4f881fd59646e8");
            return v;
        }
    };
    struct A {
        static constexpr int W = 381;
        static ac_int<381, false> VALUE() {
            ac_int<381, false> v;
            v.bit_fill_hex("0");
            return v;
        }
    };
    struct A_MONT {
        static constexpr int W = 381;
        static ac_int<381, false> VALUE() {
            ac_int<381, false> v;
            v.bit_fill_hex("0");
            return v;
        }
    };
    struct B {
        static constexpr int W = 381;
        static ac_int<381, false> VALUE() {
            ac_int<381, false> v;
            v.bit_fill_hex("4");
            return v;
        }
    };
    struct B_MONT {
        static constexpr int W = 381;
        static ac_int<381, false> VALUE() {
            ac_int<381, false> v;
            v.bit_fill_hex("17fbb8571a006596d3916126f2d14ca26e22d1ec31ebb502633cb57c253c276f855000053ab000011804000000015554");
            return v;
        }
    };
};
using FIELD = BLS12_381_BASE;
#endif // PARAMS_H

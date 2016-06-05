/*********************************************************************

Copyright 2016 Ryan Moore
Contact: moorer@udel.edu

This file is part of StatC.

StatC is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your
option) any later version.

StatC is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
for more details.

You should have received a copy of the GNU General Public License
along with StatC.  If not, see <http://www.gnu.org/licenses/>.

*********************************************************************/

#include <ruby.h>
#include <math.h>

/* based on NIL_P in ruby.h */
#define FALSE_P(v) !((VALUE)(v) != Qfalse)

/* modules */
VALUE sc_mStatC;
VALUE sc_mArray;
VALUE sc_mError;
VALUE sc_mTest;
VALUE sc_mT;

/* classes */
VALUE sc_eError;

/* @private */
static size_t assert_array_not_empty(VALUE ary)
{
  size_t len = RARRAY_LEN(ary);

  if (len <= 0) {
    rb_raise(sc_eError, "Array cannot be empty");
  } else {
    return len;
  }
}

/* @private */
static long double sc_ary_entry(VALUE ary, long idx)
{
  return NUM2DBL(rb_ary_entry(ary, idx));
}

/* Calculate the mean of values in the given array.

@param ary [Array<Numeric>] an array of Numerics

@example Get mean of array
  StatC::Array.mean([-1.4, 0, 1, 2, 3.0]).round(2)  #=> 0.92

@raise [StatC::Error::Error] if array length is zero

@return [Numeric] mean of values in the array

*/
static VALUE sc_mean(VALUE obj, VALUE ary)
{

  unsigned long i = 0;
  long double sum = 0;
  size_t len = 0;
  len = assert_array_not_empty(ary);

  for (i = 0; i < len; ++i) {
    sum += NUM2DBL(rb_ary_entry(ary, i));
  }

  return DBL2NUM(sum / len);
}

/* Calculate the variance of values in given array.

If pop param is set to true, calculates the population variance of
values in the array. Otherwise, the sample variance is calculated
(default).

@param ary [Array<Numeric>] an array of Numerics
@param pop [Bool] pass true to calculate population variance,
  default: false

@example Get sample variance of array
  StatC::Array.var([-1.4, 0, 1, 2, 3.0]).round(2)  #=> 2.93
@example Get population variance of array
  StatC::Array.var([-1.4, 0, 1, 2, 3.0], pop=true).round(2)  #=> 2.35

@raise [StatC::Error::Error] if array length is zero

@return [Numeric] variance of values in the array

*/
static VALUE sc_var(int argc, VALUE* argv, VALUE obj)
{
  VALUE ary, calc_pop_var;

  /* one required and one optional argument */
  rb_scan_args(argc, argv, "11", &ary, &calc_pop_var);

  unsigned long i = 0;
  long double sum = 0;
  size_t len = 0;
  len = assert_array_not_empty(ary);

  long double mean = NUM2DBL(sc_mean(obj, ary));

  for (i = 0; i < len; ++i) {
    sum += pow(sc_ary_entry(ary, i) - mean, 2);
  }

  if (NIL_P(calc_pop_var) || FALSE_P(calc_pop_var)) { /* sample variance */
    return DBL2NUM(sum / (len - 1));
  } else { /* population variance */
    return DBL2NUM(sum / len);
  }
}

/* Calculate the standard deviation of values in given array.

If pop param is set to true, the standard deviation is based on
population variance. Otherwise, sample variance is used (default).

@param ary [Array<Numeric>] an array of Numerics
@param pop [Bool] pass true to calculate population standard
  deviation, default: false

@example Get sample standard deviation of array
  StatC::Array.sd([-1.4, 0, 1, 2, 3.0]).round(2)  #=> 1.71
@example Get population standard deviation of array
  StatC::Array.sd([-1.4, 0, 1, 2, 3.0], pop=true).round(2)  #=> 1.53

@raise [StatC::Error::Error] if array length is zero

@return [Numeric] standard deviation of values in the array

*/
static VALUE sc_sd(int argc, VALUE* argv, VALUE obj)
{
  VALUE ary, calc_pop_var;

  /* one required and one optional argument */
  rb_scan_args(argc, argv, "11", &ary, &calc_pop_var);

  return DBL2NUM(sqrt(NUM2DBL(sc_var(argc, argv, obj))));
}

/* Calculate the standard deviation of values in given array.

If pop param is set to true, the standard error of the mean is based
on population variance. Otherwise, sample variance is used (default).

@param ary [Array<Numeric>] an array of Numerics
@param pop [Bool] pass true to calculate population standard
  error of the mean, default: false

@example Get sample standard error of array
  StatC::Array.se([-1.4, 0, 1, 2, 3.0]).round(2)  #=> 0.77
@example Get population standard error of array
  StatC::Array.se([-1.4, 0, 1, 2, 3.0], pop=true).round(2)  #=> 0.68

@raise [StatC::Error::Error] if array length is zero

@return [Numeric] standard error of the mean for values in the array

*/
static VALUE sc_se(int argc, VALUE* argv, VALUE obj)
{
  VALUE ary, calc_pop_var;

  /* one required and one optional argument */
  rb_scan_args(argc, argv, "11", &ary, &calc_pop_var);

  long double sd = NUM2DBL(sc_sd(argc, argv, obj));

  size_t len = 0;
  len = assert_array_not_empty(ary);

  return DBL2NUM(sd / sqrt(len));
}

/* Calculate Welch's t statistic

@param mean1 [Numeric] mean of sample 1
@param var1  [Numeric] sample variance of sample 1
@param len1  [Numeric] size of sample 1
@param mean2 [Numeric] mean of sample 2
@param var2  [Numeric] sample variance of sample 2
@param len1  [Numeric] size of sample 2

@example Get Welch's t stat for two samples
  StatC::Test::T.t_stat_welch(-0.1, 2.3, 5, 2.42, 1.282, 5).round(2) #=> -2.98

@raise [StatC::Error::Error] if divide by zero error

@return [Numeric] Welch's t statistic

*/
static VALUE
sc_t_stat_welch(VALUE obj,
                VALUE mean1, VALUE var1, VALUE len1,
                VALUE mean2, VALUE var2, VALUE len2)
{
  double m1, v1, l1, m2, v2, l2, val;

  m1 = NUM2DBL(mean1);
  v1 = NUM2DBL(var1);
  l1 = NUM2DBL(len1);

  m2 = NUM2DBL(mean2);
  v2 = NUM2DBL(var2);
  l2 = NUM2DBL(len2);

  if (l1 <= 0 || l2 <= 0) {
    rb_raise(sc_eError, "Sample sizes must be > 0");
  }

  val = (v1 / l1) + (v2 / l2);

  if (val == 0.0) {
    rb_raise(sc_eError, "Divide by zero error");
  }

  return DBL2NUM((m1 - m2) / sqrt(val));
}

/* Calculate degrees of freedom for Welch's t statistic

@note Uses non pooled variance

@param var1  [Numeric] sample variance of sample 1
@param len1  [Numeric] size of sample 1
@param var2  [Numeric] sample variance of sample 2
@param len1  [Numeric] size of sample 2

@example Get dof for two samples
  StatC::Test::T.dof_welch(2.3, 5, 1.282, 5).round(2) #=> 7.40

@raise [StatC::Error::Error] if divide by zero error

@return [Numeric] dof

*/
static VALUE
sc_dof_welch(VALUE obj,
             VALUE var1, VALUE len1,
             VALUE var2, VALUE len2)
{
  double v1, l1, v2, l2, num, denom, val, d1, d2;

  v1 = NUM2DBL(var1);
  l1 = NUM2DBL(len1);

  v2 = NUM2DBL(var2);
  l2 = NUM2DBL(len2);

  if (l1 <= 0 || l2 <= 0) {
    rb_raise(sc_eError, "Sample sizes must be > 0");
  }

  num = pow( (v1 / l1) + (v2 / l2), 2);

  d1 = pow(l1, 2) * (l1 - 1);
  d2 = pow(l2, 2) * (l2 - 1);

  if (d1 == 0|| d2 == 0) {
    rb_raise(sc_eError, "Divide by zero error");
  }

  denom =
    (pow(v1, 2) / d1) + (pow(v2, 2) / d2);

  if (denom == 0) {
    rb_raise(sc_eError, "Divide by zero error");
  }

  val = num / denom;

  return DBL2NUM(val);

}
/*********************************************************************

Initializers

*********************************************************************/

/* Document-module: StatC::Array

Statistical methods operating on the values of an array

*/
static void sc_init_mArray(void)
{
  sc_mArray = rb_define_module_under(sc_mStatC, "Array");

  rb_define_singleton_method(sc_mArray, "mean", sc_mean, 1);
  rb_define_singleton_method(sc_mArray, "var",  sc_var, -1);
  rb_define_singleton_method(sc_mArray, "sd",   sc_sd,  -1);
  rb_define_singleton_method(sc_mArray, "se",   sc_se,  -1);
}

/* Document-module: StatC::Error

Module containing all error classes of the StatC module.

 */
static void sc_init_mError(void)
{
  sc_mError = rb_define_module_under(sc_mStatC, "Error");
}


/* Document-class: StatC::Error::Error

Error class from which all errors raised by StatC inherit. Thus, you
can rescue from StatC::Error::Error to catch all errors specific to
StatC.

@note Inherits from StandardError

*/
static void sc_init_eError(void)
{
  sc_eError = rb_define_class_under(sc_mError, "Error", rb_eStandardError);
}

/* Document-module: StatC::Test

Module containing various statistical tests.

*/
static void sc_init_mTest(void)
{
  sc_mTest = rb_define_module_under(sc_mStatC, "Test");
}


/* Document-module: StatC::Test::T

Module containing T test methods.

*/
static void sc_init_mT(void)
{
  sc_mT = rb_define_module_under(sc_mTest, "T");

  rb_define_singleton_method(sc_mT, "t_stat_welch", sc_t_stat_welch, 6);
  rb_define_singleton_method(sc_mT, "dof_welch", sc_dof_welch, 4);
}

/* Document-module: StatC

C stats module for Ruby.

*/
void Init_stat_c(void)
{
  sc_mStatC = rb_define_module("StatC");

  sc_init_mArray();

  sc_init_mError();
  sc_init_eError();

  sc_init_mTest();
  sc_init_mT();
}

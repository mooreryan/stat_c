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

/* classes and modules */
VALUE sc_mStatC;
VALUE sc_mArray;
VALUE sc_mError;
VALUE sc_eError;

static VALUE sc_mean(VALUE self, VALUE ary)
{

  unsigned long i = 0;
  long double sum = 0;
  size_t len = RARRAY_LEN(ary);

  if (len <= 0) {
    rb_raise(sc_eError, "Array cannot be empty");
  }

  for (i = 0; i < len; ++i) {
    sum += NUM2DBL(rb_ary_entry(ary, i));
  }

  return DBL2NUM(sum / len);
}

/* static VALUE var(VALUE self, VALUE ary) */
/* { */

/* } */

/* static VALUE var(int argc, VALUE* argv, VALUE self) */
/* { */
/*   VALUE ary, sample; */

/*   /\* one required and one optional argument *\/ */
/*   rb_scan_args(argc, argv, "11", &ary, &sample); */

/*   /\* if sample wasn't specified, set it to true *\/ */
/*   if (NIL_P(sample)) { sample = 1; } */
/* } */

/* static VALUE var(int argc, VALUE* argv, VALUE self) */
/* { */
/*   VALUE ary, sample; */

/*   /\* one required and one optional argument *\/ */
/*   rb_scan_args(argc, argv, "11", &ary, &sample); */

/*   /\* if sample wasn't specified, set it to true *\/ */
/*   if (NIL_P(sample)) { sample = 1; } */
/* } */

void Init_stat_c(void)
{
  sc_mStatC = rb_define_module("StatC");

  sc_mArray = rb_define_module_under(sc_mStatC, "Array");
  sc_mError = rb_define_module_under(sc_mStatC, "Error");

  sc_eError    = rb_define_class_under(sc_mError, "Error", rb_eStandardError);

  rb_define_singleton_method(sc_mArray, "mean", sc_mean, 1);
  /* rb_define_singleton_method(mArray, "var",  var,  1); */
  /* rb_define_singleton_method(mArray, "sd",   sd,  -1); */
  /* rb_define_singleton_method(mArray, "se",   se,  -1); */
}

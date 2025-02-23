module d_mpdecimal.decimal;

import d_mpdecimal.deimos;
import core.stdc.stdint;
import core.stdc.stdio : printf;
import std.string : toStringz, fromStringz;
import std.stdio;
import core.memory;
import core.stdc.stdlib;
import core.stdc.stdio:printf;
import std.format : format;

/* 

MIT License

Copyright (c) 2021 Pablo De Nápoli

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/

mpd_context_t decimal_ctx;

void init_decimal(int prec)
{
  printf("Using libmpdec version %s \n", mpd_version);
  mpd_ieee_context(&decimal_ctx, prec);
  //mpd_init(&decimal_ctx, prec);
}

struct Decimal
{
  mpd_t* value;
  private string name;

  //@disable this();

  this(mpd_t* v)
  {
    value = v;
  }

  this(Decimal original)
  {
    //debug writeln("Call copy constructor");
    value = mpd_qncopy(original.value);
  }

  this(this)
  {
    //debug writeln("Calling this(this)");
    if (value)
      value = mpd_qncopy(value);
  }

  this(string s)
  {
    value = mpd_new(&decimal_ctx);
    immutable(char)* c_string = toStringz(s);
    GC.addRoot(cast(void*) c_string);
    GC.setAttr(cast(void*) c_string, GC.BlkAttr.NO_MOVE);
    mpd_set_string(value, c_string, &decimal_ctx);
    GC.removeRoot(cast(void*) c_string);
    GC.clrAttr(cast(void*) c_string, GC.BlkAttr.NO_MOVE);
  }

  this(int x)
  {
    value = mpd_new(&decimal_ctx);
    mpd_set_i32(value, x, &decimal_ctx);
  }

  this(long x)
  {
    value = mpd_new(&decimal_ctx);
    mpd_set_i64(value, x, &decimal_ctx);
  }

  ~this()
  {
    //debug writeln("Calling mpd_del value=",value);
    if (value)
      mpd_del(value);
    value = null;
  }

  // a string representation, used by write.
  string toString() const
  {
    if (value)
    {
      char* s = mpd_to_eng(value, 0); // 0 = exponential in lower case
      auto s_string = cast(string) fromStringz(s);
      return s_string;
    }
    else
      return "null";
  }

  string format(const string fmt) const
  {
    if (value)
    {
      char* s = mpd_format(value, fmt.toStringz(), &decimal_ctx);
      auto s_string = cast(string) fromStringz(s);
      return s_string;
    }
    else
      return "null";
  }

  bool opEquals(const Decimal rhs) const
  {
    if (!value || !rhs.value)
      return false;
    return mpd_cmp(value, rhs.value, &decimal_ctx) == 0;
  }

  // unary operator overloading

  Decimal opUnary(string op)()
  {
    mpd_t* result;
    if (!value)
      return this;
    static if (op == "-")
    {
      result = mpd_new(&decimal_ctx);
      mpd_minus(result, value, &decimal_ctx);
      return Decimal(result);
    }
    else static if (op == "+")
    {
      result = mpd_new(&decimal_ctx);
      mpd_plus(result, value, &decimal_ctx);
      return Decimal(result);
    }
    else static if (op == "++")
    {
      mpd_add_i32(value, value, 1, &decimal_ctx);
      return this;
    }
    else static if (op == "--")
    {
      mpd_sub_i32(value, value, 1, &decimal_ctx);
      return this;
    }
    else
      static assert(0, "Operator " ~ op ~ " not implemented");
  }

  // binary operator overloading

  Decimal opBinary(string op)(const Decimal rhs)
  {
    if (!value || !rhs.value)
      return this;
    mpd_t* result = mpd_new(&decimal_ctx);
    static if (op == "+")
    {
      mpd_add(result, value, rhs.value, &decimal_ctx);
    }
    else static if (op == "-")
    {
      mpd_sub(result, value, rhs.value, &decimal_ctx);
    }
    else static if (op == "*")
    {
      mpd_mul(result, value, rhs.value, &decimal_ctx);
    }
    else static if (op == "/")
    {
      mpd_div(result, value, rhs.value, &decimal_ctx);
    }
    else static if (op == "%")
    {
      mpd_rem(result, value, rhs.value, &decimal_ctx);
    }
    else static if (op == "^^")
    {
      mpd_pow(result, value, rhs.value, &decimal_ctx);
    }
    else
      static assert(0, "Operator " ~ op ~ " not implemented");

    return Decimal(result);
  }

  // assign operator overloading

  Decimal opOpAssign(string op)(const Decimal rhs)
  {
    if (!value || !rhs.value)
      return this;
    static if (op == "+")
    {
      mpd_add(value, value, rhs.value, &decimal_ctx);
    }
    else static if (op == "-")
    {
      //debug mpd_print(value);
      // debug mpd_print(rhs.value);
      mpd_sub(value, value, rhs.value, &decimal_ctx);
    }
    else static if (op == "/")
    {
      mpd_div(value, value, rhs.value, &decimal_ctx);
    }
    else static if (op == "%")
    {
      mpd_rem(value, value, rhs.value, &decimal_ctx);
    }
    else static if (op == "^^")
    {
      mpd_pow(value, value, rhs.value, &decimal_ctx);
    }
    else
      static assert(0, "opOpAssign: Operator " ~ op ~ " not implemented");
    return this;
  }

  // comparison operator overloading

  int opCmp(const Decimal rhs) const
  {
    if (!value || !rhs.value)
      return false;
    return mpd_cmp(value, rhs.value, &decimal_ctx);
  }

  bool isfinite() const 
  {
    if (!value)
      return false;
    return cast(bool) mpd_isfinite(value);
  }

  bool isinfinite() const 
  {
    if (!value)
      return false;
    return cast(bool) mpd_isinfinite(value);
  }

  bool isnan() const 
  {
    if (!value)
      return false;
    return cast(bool) mpd_isnan(value);
  }

  bool isnegative() const 
  {
    if (!value)
      return false;
    return cast(bool) mpd_isnegative(value);
  }

  bool ispositive() const 
  {
    if (!value)
      return false;
    return cast(bool) mpd_ispositive(value);
  }

  bool isqnan() const 
  {
    if (!value)
      return false;
    return cast(bool) mpd_isqnan(value);
  }

  bool issigned() const 
  {
    if (!value)
      return false;
    return cast(bool) mpd_issigned(value);
  }

  bool issnan() const 
  {
    if (!value)
      return false;
    return cast(bool) mpd_issnan(value);
  }

  bool isspecial() const 
  {
    if (!value)
      return false;
    return cast(bool) mpd_isspecial(value);
  }

  bool iszero() const 
  {
    if (!value)
      return false;
    return cast(bool) mpd_iszero(value);
  }

  bool is_nonnegative() const 
  {
    return iszero() || ispositive();
  }

  bool is_nonpositive() const 
  {
    return iszero() || isnegative();
  }

  bool isinteger() const 
  {
    return cast(bool) mpd_isinteger(value);
  }
}

Decimal decimal_abs(const Decimal x)
{
  mpd_t* result;
  result = mpd_new(&decimal_ctx);
  mpd_abs(result, x.value, &decimal_ctx);
  return Decimal(result);
}

// round-to-integral-exact
Decimal decimal_round_to_intx(const Decimal x)
{
  mpd_t* result;
  result = mpd_new(&decimal_ctx);
  mpd_round_to_intx(result, x.value, &decimal_ctx);
  return Decimal(result);
}

Decimal decimal_round_to_int(const Decimal x)
{
  mpd_t* result;
  result = mpd_new(&decimal_ctx);
  mpd_round_to_int(result, x.value, &decimal_ctx);
  return Decimal(result);
}

Decimal decimal_floor(const Decimal x)
{
  mpd_t* result;
  result = mpd_new(&decimal_ctx);
  mpd_floor(result, x.value, &decimal_ctx);
  return Decimal(result);
}

Decimal decimal_ceil(const Decimal x)
{
  mpd_t* result;
  result = mpd_new(&decimal_ctx);
  mpd_ceil(result, x.value, &decimal_ctx);
  return Decimal(result);
}

Decimal decimal_trunc(const Decimal x)
{
  mpd_t* result;
  result = mpd_new(&decimal_ctx);
  mpd_trunc(result, x.value, &decimal_ctx);
  return Decimal(result);
}

Decimal decimal_exp(const Decimal x) 
{
  mpd_t* result;
  result = mpd_new(&decimal_ctx);
  mpd_exp(result, x.value, &decimal_ctx);
  return Decimal(result);
}

Decimal decimal_ln(const Decimal x)
{
  mpd_t* result;
  result = mpd_new(&decimal_ctx);
  mpd_ln(result, x.value, &decimal_ctx);
  return Decimal(result);
}

Decimal decimal_log10(const Decimal x)
{
  mpd_t* result;
  result = mpd_new(&decimal_ctx);
  mpd_log10(result, x.value, &decimal_ctx);
  return Decimal(result);
}

Decimal decimal_sqrt(const Decimal x)
{
  mpd_t* result;
  result = mpd_new(&decimal_ctx);
  mpd_sqrt(result, x.value, &decimal_ctx);
  return Decimal(result);
}

// inverse-square-root
Decimal decimal_invroot(const Decimal x)
{
  mpd_t* result;
  result = mpd_new(&decimal_ctx);
  mpd_invroot(result, x.value, &decimal_ctx);
  return Decimal(result);
}

void clear_status()
{
  mpd_qsetstatus(&decimal_ctx, 0);
}

uint32_t get_status()
{
  return mpd_getstatus(&decimal_ctx);
}

/// Prints and return the status flags
uint32_t print_status()
{
  uint32_t status = get_status();
  string binary_status = format("%b", status);
  writeln("status=", binary_status, "b");

  if (status & MPD_Clamped)
    writeln("MPD_Clamped");

  if (status & MPD_Conversion_syntax)
    writeln("MPD_Conversion_syntax");

  if (status & MPD_Division_by_zero)
    writeln("MPD_Division_by_zero");

  if (status & MPD_Division_impossible)
    writeln("MPD_Division_impossible");

  if (status & MPD_Division_undefined)
    writeln("MPD_Division_undefined");

  if (status & MPD_Fpu_error)
    writeln("MPD_Fpu_error");

  if (status & MPD_Inexact)
    writeln("MPD_Inexact");

  if (status & MPD_Invalid_context)
    writeln("MPD_Invalid_context");

  if (status & MPD_Invalid_operation)
    writeln("MPD_Invalid_operation");

  if (status & MPD_Malloc_error)
    writeln("MPD_Malloc_error");

  if (status & MPD_Not_implemented)
    writeln("MPD_Not_implemented");

  if (status & MPD_Overflow)
    writeln("MPD_Overflow");

  if (status & MPD_Rounded)
    writeln("MPD_Rounded");

  if (status & MPD_Subnormal)
    writeln("MPD_Subnormal");

  if (status & MPD_Underflow)
    writeln("MPD_Underflow");

  return status;
}

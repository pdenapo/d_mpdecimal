module mpdec.decimal;

import mpdec.mpdec;
import core.stdc.stdio:printf;
import std.string:toStringz,fromStringz;
import std.stdio;
import core.memory;
import core.stdc.stdlib;

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

void init_decimal(int prec) {
  printf("Using libmpdec version %s \n",mpd_version);
  mpd_init(&decimal_ctx,prec);
}

void init_ieee_decimal(int bits) {
    printf("Using libmpdec version %s \n",mpd_version);
    mpd_ieee_context(&decimal_ctx, bits); 
}

struct Decimal{
    mpd_t* value;
    private string name;

    this(mpd_t* v)
    {
      value=v;
    }

    this(Decimal original)
    {
      // debug writeln("Call copy constructor");
      value=mpd_qncopy(original.value);
    }

    this(this)
    {
      // debug writeln("Calling this(this)");
      value = mpd_qncopy(value);
    }

    this(string s)
    {
      value=mpd_new(&decimal_ctx);
      immutable(char)* c_string = toStringz(s); 
      GC.addRoot(cast(void*)c_string);
      GC.setAttr(cast(void*)c_string, GC.BlkAttr.NO_MOVE);
      mpd_set_string(value,c_string,&decimal_ctx);
      GC.removeRoot(cast(void*)c_string);
      GC.clrAttr(cast(void*)c_string, GC.BlkAttr.NO_MOVE);
    }

    this(int x)
    {
      value=mpd_new(&decimal_ctx);
      mpd_set_i32(value, x, &decimal_ctx);
    }

    this(long x)
    {
      value=mpd_new(&decimal_ctx);
      mpd_set_i64(value, x, &decimal_ctx);
    }

    ~this()
    {
       //debug writeln("Calling mpd_del value=",value);
       if (value)
          mpd_del(value);
       value=null;   
    }

    // a string representation, used by write.
    string toString() const  
    {
      char* s= mpd_to_eng(value, 0); // 0 = exponential in lower case
      auto s_string = cast(string) fromStringz(s); 
      return s_string;
    }


    bool opEquals(Decimal rhs) const {
       return mpd_cmp(value,rhs.value,&decimal_ctx)==0;
    }


    // unary operator overloading

    Decimal opUnary(string op)()
    {
     mpd_t* result;
    static if (op == "-") 
    {
        result=mpd_new(&decimal_ctx); 
        mpd_minus(result,value,&decimal_ctx);
        return Decimal(result);
    }
    else static if (op == "+") 
    {
        result=mpd_new(&decimal_ctx); 
        mpd_plus(result,value,&decimal_ctx);
        return Decimal(result);
    }
    else static if (op == "++") 
    {
        mpd_add_i32(value, value, 1,&decimal_ctx);
        return this;
    }
    else static if (op == "--") 
    {
        mpd_sub_i32(value, value, 1,&decimal_ctx);
        return this;
    }
    else static assert(0, "Operator "~op~" not implemented");
    }



    // binary operator overloading

    Decimal opBinary(string op)(Decimal rhs)
    {
    mpd_t*  result= mpd_new(&decimal_ctx);
    static if (op == "+") 
    {
        mpd_add(result,value,rhs.value,&decimal_ctx);
    }
    else static if (op == "-") 
    {
        mpd_sub(result,value,rhs.value,&decimal_ctx);
    }
    else static if (op == "*") 
    {
        mpd_mul(result,value,rhs.value,&decimal_ctx);
    }
    else static if (op == "/") 
    {
        mpd_div(result,value,rhs.value,&decimal_ctx);
    }
    else static if (op == "%") 
    {
        mpd_rem(result,value,rhs.value,&decimal_ctx);
    }
    else static if (op == "^^") 
    {
        mpd_pow(result,value,rhs.value,&decimal_ctx);
    }
    else static assert(0, "Operator "~op~" not implemented");
    
    return Decimal(result);
    }

    // assign operator overloading

    Decimal opOpAssign(string op)(Decimal rhs)
    {
    static if (op == "+") 
    {
        mpd_add(value,value,rhs.value,&decimal_ctx);
    }
    else static if (op == "-") 
    {
        write("value=");
        mpd_print(value);
        write("rhs.value=");
        mpd_print(rhs.value);
        mpd_sub(value,value,rhs.value,&decimal_ctx);
    }
    else static if (op == "/") 
    {
        mpd_div(value,value,rhs.value,&decimal_ctx);
    }
    else static if (op == "%") 
    {
        mpd_rem(value,value,rhs.value,&decimal_ctx);
    }
    else static if (op == "^^") 
    {
        mpd_pow(value,value,rhs.value,&decimal_ctx);
    }
    else static assert(0, "opOpAssign: Operator "~op~" not implemented");   
    return this;
    }

        // comparison operator overloading

    const int opCmp(const Decimal rhs){
        return  mpd_cmp(value,rhs.value,&decimal_ctx); 
    }

    bool isfinite()
    {
     return cast(bool) mpd_isfinite(value);
    }

    bool isinfinite()
    {
     return cast(bool) mpd_isinfinite(value);
    }

    bool isnan()
    {
     return cast(bool) mpd_isnan(value);
    }

    bool isnegative()
    {
     return cast(bool) mpd_isnegative(value);
    }

    bool ispositive()
    {
     return cast(bool) mpd_ispositive(value);
    }

    bool isqnan()
    {
     return cast(bool) mpd_isqnan(value);
    }

    bool issigned()
    {
     return cast(bool) mpd_issigned(value);
    }

    bool issnan()
    {
     return cast(bool) mpd_issnan(value);
    }

    bool isspecial()
    {
     return cast(bool) mpd_isspecial(value);
    }

    bool iszero()
    {
     return cast(bool) mpd_iszero(value);
    }

    bool is_nonnegative()
    {
      return iszero() ||ispositive() ;   
    }

    bool is_nonpositive()
    {
      return iszero()||isnegative();   
    }
}
 
 Decimal abs(Decimal x)
  {
    mpd_t* result;
    result=mpd_new(&decimal_ctx);
    mpd_abs(result,x.value,&decimal_ctx);
    return Decimal(result);        
  }

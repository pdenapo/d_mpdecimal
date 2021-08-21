import mpdec.decimal;
import std.stdio;

// This is a test program for the mpdec.decimal module.
// (C) 2021 Pablo De Nápoli

int passed;
int failed;

void perform_test(string name, bool result)
{
  if (result)
  {
    writeln("Test ",name, " passed");
    passed++;
  }
  else
  {
    writeln("Test ",name, " failed");
    failed++; 
  }
}

Decimal doble(Decimal x)
{
 return(Decimal(2)*x);
}

void main()
{
 init_ieee_decimal(128);
 Decimal a=Decimal("3.1416");
 Decimal b=Decimal("0.01");
 Decimal zero=Decimal(0);
 writeln("a=",a);
 perform_test("a_to_string",a.toString()=="3.1416");
 
 writeln("b=",b);
 perform_test("b_to_string",b.toString()=="0.01");
 writeln("b=",zero);
 perform_test("zero_to_string",zero.toString()=="0");
 
 // Test +
 Decimal c=a+b;
 writeln("c=",c);
 perform_test("+",c.toString()=="3.1516");
 perform_test("a_to_string +",a.toString()=="3.1416");  // We test that a has not been modified!

// Test -
Decimal d=a-b;
writeln("d=",d);
perform_test("- ",d.toString()=="3.1316");
perform_test("a_to_string -",a.toString()=="3.1416");  // We test that a has not been modified!

// Test *
Decimal e=a*b;
writeln("e=",e);
perform_test("* ",e.toString()=="0.031416");
perform_test("a_to_string *",a.toString()=="3.1416");  // We test that a has not been modified!


// Test /
Decimal f=a/b;
writeln("f=",f);
perform_test("/ ",f.toString()=="314.16");
perform_test("a_to_string *",a.toString()=="3.1416");  // We test that a has not been modified!

// Test +=
Decimal g=a;
perform_test("= ",g.toString()== a.toString());
g += b;
perform_test("!= ",g.toString()!= a.toString());
writeln("g=",g);
perform_test("+=",g.toString()=="3.1516");
perform_test("a_to_string +=",a.toString()=="3.1416");  // We test that a has not been modified!

// Test -=
Decimal h=a;
perform_test("a_to_string =",a.toString()=="3.1416");
perform_test("h_to_string =",h.toString()=="3.1416");
writeln("h=",h);
h -= b;
writeln("h=",h);
perform_test("-=",h.toString()=="3.1316");
perform_test("a_to_string -=",a.toString()=="3.1416");

// Test unary +
perform_test("Unary +",a==+a);
writeln("a=",a);
writeln("+a=",+a);
writeln("-a=",-a);
perform_test("Unary -",(-a).toString=="-3.1416");

perform_test("abs",abs(-a)==a);

perform_test("<",(a<b)==false);
perform_test(">",(a>b)==true);
perform_test("is_zero ",zero.iszero);

perform_test("a=a ",a==a);
perform_test("a=b ",!(a==b));

Decimal other_b=Decimal("0.01");
perform_test("= ",b==other_b);
perform_test("!= ",!(b!=other_b)); 

Decimal m=Decimal(17);
Decimal n=Decimal(3);
perform_test("% ",m%n == Decimal(2));

perform_test("doble ",doble(m)==Decimal(34)); //test calling a function

perform_test("++ ",++m==Decimal(18));
perform_test("++2 ",m==Decimal(18));
perform_test("++3 ",m++==Decimal(18));
perform_test("++4 ",m==Decimal(19));

perform_test("-- ",--m==Decimal(18));
perform_test("--2 ",m==Decimal(18));
perform_test("--3 ",m--==Decimal(18));
perform_test("--4 ",m==Decimal(17));

Decimal x;
perform_test("null",x.toString()=="null"); // this should not give a seg fault!

writeln(passed," tests passed.");
writeln(failed," tests failed.");



}

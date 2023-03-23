import d_mpdecimal.decimal;
import d_mpdecimal.deimos;
import std.stdio;

// This is a test program for the d_mpdecimal.decimal module.
// (C) 2021 Pablo De Nápoli

int passed;
int failed;

void perform_test(string name, bool result)
{
  if (result)
  {
    writeln("Test ", name, " passed");
    passed++;
  }
  else
  {
    writeln("Test ", name, " failed");
    failed++;
  }
}

Decimal doble(Decimal x)
{
  return (Decimal(2) * x);
}

void main()
{
  init_ieee_decimal(128);
  Decimal a = Decimal("3.1416");
  check_status();
  Decimal b = Decimal("0.01");
  Decimal zero = Decimal(0);
  writeln("a=", a);
  perform_test("a_to_string", a.toString() == "3.1416");
  check_status();
  string a_with_format = a.format("0.3f");
  writeln("a_with_format=", a_with_format);
  perform_test("a_with_format", a_with_format == "3.142");
  check_status();

  writeln("b=", b);
  perform_test("b_to_string", b.toString() == "0.01");
  check_status();
  writeln("b=", zero);
  perform_test("zero_to_string", zero.toString() == "0");
  check_status();
  perform_test("isinteger b ", !b.isinteger);
  check_status();

  // Test +
  Decimal c = a + b;
  writeln("c=", c);
  perform_test("+", c.toString() == "3.1516");
  check_status();
  perform_test("a_to_string +", a.toString() == "3.1416"); // We test that a has not been modified!
  check_status();
  perform_test("b_to_string +", b.toString() == "0.01");

  // Test -

  Decimal d = a - b;
  writeln("d=", d);
  check_status();
  perform_test("- ", d.toString() == "3.1316");
  check_status();
  perform_test("a_to_string -", a.toString() == "3.1416"); // We test that a has not been modified!
  check_status();
  perform_test("b_to_string -", b.toString() == "0.01");
  check_status();

  // Test *
  Decimal e = a * b;
  check_status();
  writeln("e=", e);
  check_status();
  perform_test("* ", e.toString() == "0.031416");
  check_status();
  perform_test("a_to_string *", a.toString() == "3.1416"); // We test that a has not been modified!
  check_status();
  perform_test("b_to_string *", b.toString() == "0.01");
  check_status();

  // Test /
  Decimal f = a / b;
  writeln("f=", f);
  check_status();
  perform_test("/ ", f.toString() == "314.16");
  check_status();
  perform_test("a_to_string *", a.toString() == "3.1416"); // We test that a has not been modified!
  check_status();
  perform_test("b_to_string /", b.toString() == "0.01");
  check_status();

  // Test +=
  Decimal g = a;
  perform_test("= ", g.toString() == a.toString());
  check_status();
  g += b;
  perform_test("!= ", g.toString() != a.toString());
  check_status();
  writeln("g=", g);
  perform_test("+=", g.toString() == "3.1516");
  check_status();
  perform_test("b_to_string", b.toString() == "0.01"); // We test that a has not been modified!
  check_status();

  // Test -=
  Decimal h = a;
  check_status();
  perform_test("a_to_string =", a.toString() == "3.1416");
  check_status();
  perform_test("h_to_string =", h.toString() == "3.1416");
  check_status();
  writeln("h=", h);
  h -= b;
  writeln("h=", h);
  check_status();
  perform_test("-=", h.toString() == "3.1316");
  check_status();
  perform_test("b_to_string", b.toString() == "0.01");

  // Test unary +
  perform_test("Unary +", a == +a);
  check_status();
  writeln("a=", a);
  check_status();
  writeln("+a=", +a);
  check_status();
  writeln("-a=", -a);
  check_status();
  perform_test("Unary -", (-a).toString == "-3.1416");
  check_status();

  perform_test("abs ", decimal_abs(-a) == a);
  check_status();
  perform_test("<", (a < b) == false);
  check_status();
  perform_test(">", (a > b) == true);
  check_status();
  perform_test("is_zero ", zero.iszero);
  check_status();

  perform_test("a=a ", a == a);
  check_status();
  perform_test("a=b ", !(a == b));
  check_status();

  Decimal other_b = Decimal("0.01");
  check_status();
  perform_test("= ", b == other_b);
  check_status();
  perform_test("!= ", !(b != other_b));
  check_status();

  Decimal m = Decimal(17);
  perform_test("isinteger m  ", m.isinteger);
  check_status();
  Decimal n = Decimal(3);
  perform_test("% ", m % n == Decimal(2));
  check_status();

  perform_test("doble ", doble(m) == Decimal(34)); //test calling a function
  check_status();

  perform_test("++ ", ++m == Decimal(18));
  check_status();
  perform_test("++2 ", m == Decimal(18));
  check_status();
  perform_test("++3 ", m++ == Decimal(18));
  check_status();
  perform_test("++4 ", m == Decimal(19));
  check_status();

  perform_test("-- ", --m == Decimal(18));
  check_status();
  perform_test("--2 ", m == Decimal(18));
  check_status();
  perform_test("--3 ", m-- == Decimal(18));
  check_status();
  perform_test("--4 ", m == Decimal(17));
  check_status();

  m++;
  perform_test("++5 ", m == Decimal(18));
  check_status();
  ++m;
  perform_test("++6 ", m == Decimal(19));
  check_status();
  m--;
  perform_test("--5 ", m == Decimal(18));
  check_status();
  --m;
  perform_test("--6 ", m == Decimal(17));
  check_status();

  // When a variable is declared to be of type Decimal but not initializated,
  // value is a null pointer. We check that this does nos cause a segmentation fault

  Decimal x;
  perform_test("null", x.toString() == "null");
  perform_test("null1", (x + Decimal(1)).toString() == "null");
  perform_test("null2", (x++).toString() == "null");
  perform_test("null3", !x.iszero());
  check_status();
  x += Decimal(1);
  perform_test("null4", x.toString() == "null");
  Decimal one = Decimal("1");
  perform_test("exp ", decimal_exp(zero) == one);
  check_status();
  perform_test("ln ", decimal_ln(one) == zero);
  check_status();
  Decimal ten = Decimal("10");
  perform_test("log10 ", decimal_log10(ten) == one);
  check_status();
  Decimal four = Decimal("4");
  Decimal two = Decimal("2");
  perform_test("sqrt ", decimal_sqrt(four) == two);
  check_status();
  perform_test("invsqrt ", decimal_invroot(four) == Decimal("0.5"));
  auto status = check_status();
  perform_test("invsqrt status", status == (MPD_Inexact | MPD_Rounded));

  clear_status();
  check_status();
  perform_test("decimal_round_to_int ", decimal_round_to_int(Decimal("1.9999")) == two);
  check_status();
  perform_test("decimal_floor ", decimal_floor(Decimal("1.9999")) == one);
  check_status();
  perform_test("decimal_ceil ", decimal_ceil(Decimal("1.9999")) == two);
  check_status();
  perform_test("decimal_trunc ", decimal_floor(Decimal("1.9999")) == one);
  check_status();
  Decimal division_by_zero = Decimal("1") / Decimal("0");
  status = check_status();
  perform_test("division_by_zero ", status == MPD_Division_by_zero);

  writeln(passed, " tests passed.");
  writeln(failed, " tests failed.");
}
